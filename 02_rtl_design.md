# Step 2 - RTL Design

## Tổng Quan về Kiến Trúc RTL

Dự án AES Accelerator được thiết kế theo kiến trúc module hóa, với mỗi module thực hiện một chức năng cụ thể. Kiến trúc tổng thể được chia thành các lớp từ cao xuống thấp, từ giao diện Wishbone đến các module xử lý AES cơ bản.

## 1. Cấu Trúc Tổng Thể

### 1.1 Sơ Đồ Kiến Trúc

```
┌─────────────────────────────────────────────────────────┐
│                aes_wb_wrapper.v                         │
│              (Wishbone Interface)                       │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│                    aes.v                                │
│              (Top Level Wrapper)                        │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│                  aes_core.v                             │
│              (Main Control Logic)                       │
└─────────┬───────────┬───────────┬───────────────────────┘
          │           │           │
┌─────────▼─────────┐ │  ┌────────▼─────────┐
│aes_encipher_block │ │  │aes_decipher_block│
│     .v            │ │  │       .v         │
│  (Encryption)     │ │  │   (Decryption)   │
└───────────────────┘ │  └──────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│              aes_key_mem.v                              │
│              (Key Management)                           │
└─────────────────────────────────────────────────────────┘
          │                      |
┌─────────▼─────────┐  ┌─────────▼─────────┐
│    aes_sbox.v     │  │  aes_inv_sbox.v   │
│   (S-box ROM)     │  │  (Inverse S-box)  │
└───────────────────┘  └───────────────────┘
```

### 1.2 Phân Cấp Module

- **Lớp 1**: Giao diện Wishbone (`aes_wb_wrapper.v`)
- **Lớp 2**: Wrapper chính (`aes.v`)
- **Lớp 3**: Lõi điều khiển (`aes_core.v`)
- **Lớp 4**: Module xử lý (`aes_encipher_block.v`, `aes_decipher_block.v`)
- **Lớp 5**: Module hỗ trợ (`aes_sbox.v`, `aes_inv_sbox.v`, `aes_key_mem.v`)

## 2. Phân Tích Chi Tiết Các Module

### 2.1 aes_wb_wrapper.v - Giao Diện Wishbone

#### 2.1.1 Chức Năng
Module này cung cấp giao diện Wishbone slave để tích hợp AES core với hệ thống Caravel.

#### 2.1.2 Port Interface
```verilog
module aes_wb_wrapper (
    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,           // Clock signal
    input wb_rst_i,           // Reset signal
    input wbs_stb_i,          // Strobe signal
    input wbs_cyc_i,          // Cycle signal
    input wbs_we_i,           // Write enable
    input [3:0] wbs_sel_i,    // Byte select
    input [31:0] wbs_dat_i,   // Write data
    input [31:0] wbs_adr_i,   // Address
    output wbs_ack_o,         // Acknowledge
    output [31:0] wbs_dat_o   // Read data
);
```

#### 2.1.3 Logic Điều Khiển
```verilog
assign valid = wbs_cyc_i && wbs_stb_i;
assign write_enable = wbs_we_i && valid;
assign read_enable = ~wbs_we_i && valid;
```

**Phân tích:**
- Sử dụng logic combinational để tạo tín hiệu điều khiển
- `valid` chỉ ra giao dịch Wishbone hợp lệ
- `write_enable` và `read_enable` được tạo từ `valid` và `wbs_we_i`

#### 2.1.4 Kết Nối với AES Core
```verilog
aes aes(
    .clk(wb_clk_i),
    .reset_n(!wb_rst_i),
    .cs(wbs_cyc_i && wbs_stb_i),
    .we(write_enable),
    .address(wbs_adr_i[9:2]),    // 8-bit address
    .write_data(wbs_dat_i),
    .read_data(wbs_dat_o)
);
```

**Phân tích:**
- Địa chỉ được dịch phải 2 bit (chia 4) để chuyển từ byte address sang word address
- Reset được đảo ngược để phù hợp với logic tích cực thấp của AES core

### 2.2 aes.v - Top Level Wrapper

#### 2.2.1 Memory Map
```verilog
localparam ADDR_NAME0       = 8'h00;    // Core name (lower 32 bits)
localparam ADDR_NAME1       = 8'h01;    // Core name (upper 32 bits)
localparam ADDR_VERSION     = 8'h02;    // Version information
localparam ADDR_CTRL        = 8'h08;    // Control register
localparam ADDR_STATUS      = 8'h09;    // Status register
localparam ADDR_CONFIG      = 8'h0a;    // Configuration register
localparam ADDR_KEY0        = 8'h10;    // Key storage start
localparam ADDR_KEY7        = 8'h17;    // Key storage end
localparam ADDR_BLOCK0      = 8'h20;    // Input block start
localparam ADDR_BLOCK3      = 8'h23;    // Input block end
localparam ADDR_RESULT0     = 8'h30;    // Output block start
localparam ADDR_RESULT3     = 8'h33;    // Output block end
```

#### 2.2.2 Control Register
```verilog
localparam CTRL_INIT_BIT    = 0;    // Initialize operation
localparam CTRL_NEXT_BIT    = 1;    // Start next operation
```

#### 2.2.3 Status Register
```verilog
localparam STATUS_READY_BIT = 0;    // Core ready
localparam STATUS_VALID_BIT = 1;    // Result valid
```

#### 2.2.4 Configuration Register
```verilog
localparam CTRL_ENCDEC_BIT  = 0;    // 0=encrypt, 1=decrypt
localparam CTRL_KEYLEN_BIT  = 1;    // 0=128-bit, 1=256-bit
```

### 2.3 aes_core.v - Lõi Điều Khiển Chính

#### 2.3.1 State Machine
```verilog
localparam CTRL_IDLE  = 2'h0;    // Idle state
localparam CTRL_INIT  = 2'h1;    // Initialization state
localparam CTRL_NEXT  = 2'h2;    // Processing state
```

#### 2.3.2 Port Interface
```verilog
module aes_core(
    input wire            clk,
    input wire            reset_n,
    input wire            encdec,         // 0=encrypt, 1=decrypt
    input wire            init,           // Initialize
    input wire            next,           // Start next operation
    output wire           ready,          // Core ready
    input wire [255:0]   key,            // Input key
    input wire            keylen,         // Key length
    input wire [127:0]   block,          // Input block
    output wire [127:0]  result,         // Output block
    output wire           result_valid    // Result valid
);
```

#### 2.3.3 Logic Điều Khiển
```verilog
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        aes_core_ctrl_reg <= CTRL_IDLE;
        result_valid_reg <= 1'b0;
        ready_reg <= 1'b1;
    end else begin
        if (aes_core_ctrl_we)
            aes_core_ctrl_reg <= aes_core_ctrl_new;
        if (result_valid_we)
            result_valid_reg <= result_valid_new;
        if (ready_we)
            ready_reg <= ready_new;
    end
end
```

**Phân tích:**
- Sử dụng flip-flop với write enable để cập nhật có điều kiện
- Reset tích cực thấp với logic đồng bộ
- State machine được điều khiển bởi các tín hiệu `init` và `next`

### 2.4 aes_encipher_block.v - Module Mã Hóa

#### 2.4.1 Các Trạng Thái Xử Lý
```verilog
localparam NO_UPDATE    = 3'h0;    // No update
localparam INIT_UPDATE  = 3'h1;    // Initial round
localparam SBOX_UPDATE  = 3'h2;    // S-box substitution
localparam MAIN_UPDATE  = 3'h3;    // Main round
localparam FINAL_UPDATE = 3'h4;    // Final round
```

#### 2.4.2 Hàm Galois Field
```verilog
function automatic [7:0] gm2(input [7:0] op);
    begin
        gm2 = {op[6:0], 1'b0} ^ (8'h1b & {8{op[7]}});
    end
endfunction

function automatic [7:0] gm3(input [7:0] op);
    begin
        gm3 = gm2(op) ^ op;
    end
endfunction
```

**Phân tích:**
- `gm2`: Thực hiện phép nhân với 2 trong trường GF(2⁸)
- `gm3`: Thực hiện phép nhân với 3 trong trường GF(2⁸)
- Sử dụng `automatic` để tối ưu hóa synthesis

#### 2.4.3 MixColumns Function
```verilog
function automatic [31:0] mixw(input [31:0] w);
    reg [7:0] b0, b1, b2, b3;
    reg [7:0] mb0, mb1, mb2, mb3;
    
    b0 = w[31:24];
    b1 = w[23:16];
    b2 = w[15:8];
    b3 = w[7:0];
    
    mb0 = gm2(b0) ^ gm3(b1) ^ b2 ^ b3;
    mb1 = b0 ^ gm2(b1) ^ gm3(b2) ^ b3;
    mb2 = b0 ^ b1 ^ gm2(b2) ^ gm3(b3);
    mb3 = gm3(b0) ^ b1 ^ b2 ^ gm2(b3);
    
    mixw = {mb0, mb1, mb2, mb3};
endfunction
```

**Phân tích:**
- Thực hiện phép biến đổi MixColumns cho một word 32-bit
- Sử dụng các hàm `gm2` và `gm3` đã định nghĩa
- Kết quả được ghép lại thành word 32-bit

### 2.5 aes_sbox.v - S-box ROM

#### 2.5.1 Cấu Trúc ROM
```verilog
wire [7:0] sbox [0:255];    // 256x8 ROM

assign new_sboxw[31:24] = sbox[sboxw[31:24]];
assign new_sboxw[23:16] = sbox[sboxw[23:16]];
assign new_sboxw[15:8]  = sbox[sboxw[15:8]];
assign new_sboxw[7:0]   = sbox[sboxw[7:0]];
```

**Phân tích:**
- Sử dụng array 2D để tạo ROM 256x8
- 4 S-box song song để xử lý word 32-bit
- Mỗi byte được thay thế độc lập

#### 2.5.2 Nội Dung S-box
```verilog
assign sbox[8'h00] = 8'h63;
assign sbox[8'h01] = 8'h7c;
assign sbox[8'h02] = 8'h77;
// ... (256 entries)
```

**Phân tích:**
- S-box được định nghĩa bằng các assignment combinational
- Mỗi giá trị đầu vào 8-bit có một giá trị đầu ra 8-bit tương ứng
- Được tối ưu hóa cho synthesis thành ROM

### 2.6 aes_key_mem.v - Quản Lý Khóa

#### 2.6.1 Cấu Trúc Bộ Nhớ Khóa
```verilog
reg [31:0] key_mem [0:7];    // 8 words x 32-bit
reg [31:0] key_mem_new [0:7];
reg [7:0]  key_mem_we;
```

#### 2.6.2 Key Expansion
```verilog
function automatic [31:0] next_key;
    input [31:0] prev_key;
    input [31:0] round_key;
    input [7:0]  rcon;
    
    reg [31:0] rot_word;
    reg [31:0] sub_word;
    
    rot_word = {prev_key[23:0], prev_key[31:24]};
    sub_word = {sbox[rot_word[31:24]], sbox[rot_word[23:16]], 
                sbox[rot_word[15:8]], sbox[rot_word[7:0]]};
    next_key = sub_word ^ round_key ^ {rcon, 24'h000000};
endfunction
```

**Phân tích:**
- Sử dụng `function automatic` để tối ưu hóa
- Thực hiện RotWord, SubWord và XOR với Rcon
- Tạo khóa con cho từng vòng AES

## 3. Đặc Điểm Thiết Kế

### 3.1 Kiến Trúc Pipeline
- **Sequential Processing**: Xử lý tuần tự từng khối dữ liệu
- **State Machine**: Điều khiển trạng thái xử lý
- **Resource Sharing**: Chia sẻ tài nguyên giữa mã hóa và giải mã

### 3.2 Tối Ưu Hóa Synthesis
- **Combinational Logic**: Sử dụng cho các phép biến đổi đơn giản
- **Sequential Logic**: Sử dụng cho state machine và bộ nhớ
- **Function Optimization**: Sử dụng `automatic` functions

### 3.3 Giao Diện Chuẩn
- **Wishbone Bus**: Giao diện bus chuẩn cho SoC
- **Memory Mapped**: Truy cập qua địa chỉ bộ nhớ
- **Register Interface**: Giao diện thanh ghi điều khiển
