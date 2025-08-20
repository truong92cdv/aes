# Step 1 - Theory

**[🏠 Home](../README.md)**

## 1. Tổng Quan về Mã Hóa AES (Advanced Encryption Standard)

### 1.1. Bối cảnh ra đời

Trước thập niên 1970, việc bảo mật dữ liệu điện tử chưa thực sự được chú trọng. Đến năm 1977, DES (Data Encryption Standard) ra đời như một chuẩn mã hóa đối xứng của Mỹ, được sử dụng rộng rãi trong ngân hàng, tài chính và chính phủ. Tuy nhiên, DES chỉ có khóa 56-bit, khá ngắn so với tốc độ phát triển máy tính. Đến cuối thập niên 1990, DES đã trở nên yếu: các hệ thống chuyên dụng có thể phá DES trong vòng vài giờ.

Giải pháp tình thế lúc đó là Triple DES (3DES) – tức mã hóa 3 lần bằng DES để tăng độ an toàn. Nhưng 3DES chậm, tốn tài nguyên, và không phải giải pháp lâu dài.

Vì vậy, năm 1997, NIST (Viện Tiêu chuẩn và Công nghệ Hoa Kỳ) khởi động cuộc thi để tìm kiếm một thuật toán mã hóa mới, thay thế DES. Thuật toán này phải an toàn, hiệu quả, và có khả năng tồn tại lâu dài. Cuộc thi kéo dài 5 năm, thu hút 15 ứng viên từ khắp nơi trên thế giới.

Sau nhiều vòng kiểm tra, đánh giá và thảo luận công khai, năm 2000, NIST chọn Rijndael – một thuật toán do hai nhà mật mã học người Bỉ Joan Daemen và Vincent Rijmen phát triển – làm chuẩn mới. Từ đó, Rijndael được gọi là AES (Advanced Encryption Standard) và chính thức trở thành chuẩn mã hóa đối xứng toàn cầu từ năm 2001.

### 1.2. Đặc điểm của AES

AES có những đặc điểm khác biệt so với DES/3DES:
- Độ dài khóa linh hoạt: hỗ trợ 128, 192 và 256 bit (so với DES chỉ có 56 bit).
- Khối dữ liệu 128 bit (DES chỉ 64 bit).
- Cấu trúc toán học hiện đại: dùng các phép biến đổi trong đại số hữu hạn (S-box, ShiftRows, MixColumns).
- Nhanh và hiệu quả: AES được thiết kế để chạy tốt trên cả phần cứng và phần mềm.
- Tính chuẩn hóa quốc tế: không thuộc sở hữu riêng, được công khai thuật toán và khuyến khích kiểm tra.

AES là chuẩn mã hóa quốc tế đầu tiên được chọn qua một cuộc thi mở, có sự đóng góp và đánh giá của cộng đồng học thuật, thay vì chỉ do chính phủ Mỹ tự chọn. Điều này giúp AES được tin tưởng rộng rãi.

Đã từng có lo ngại rằng AES có “cửa hậu” (backdoor) do một số tổ chức an ninh cài vào. Nhưng đến nay, sau hơn 20 năm nghiên cứu, chưa ai tìm thấy bằng chứng nào như vậy.

Các nhà thiết kế AES, Daemen và Rijmen, đã trở thành những tên tuổi huyền thoại trong giới mật mã học nhờ thành công này.

### 1.3. So sánh AES và DES/3DES

| Tiêu chí         | DES (1977)        | 3DES (1998)       | AES (2001)                    |
| ---------------- | ----------------- | ----------------- | ----------------------------- |
| Độ dài khóa      | 56 bit            | 112/168 bit       | 128, 192, 256 bit             |
| Khối dữ liệu     | 64 bit            | 64 bit            | 128 bit                       |
| Tốc độ           | Nhanh (thời 1970) | Chậm (3 lần DES)  | Nhanh cả phần cứng & phần mềm |
| Bảo mật hiện tại | Không an toàn     | Yếu dần           | Vẫn an toàn                   |
| Ứng dụng         | Ngân hàng, cũ     | Thay thế tạm thời | Chuẩn toàn cầu                |

### 1.4. AES trong thời hiện đại

Sau hơn 20 năm sử dụng, AES vẫn được xem là an toàn nếu dùng với khóa 128 bit trở lên.

AES-128 có thể bị đe dọa trong tương lai khi máy tính lượng tử phát triển, nhưng AES-192 và AES-256 vẫn được dự đoán an toàn trong thời gian dài.

Các thuật toán mới (ví dụ: ChaCha20, Camellia, Twofish) cũng được nghiên cứu và sử dụng trong một số ứng dụng, nhưng chưa thuật toán nào vượt qua AES để trở thành “chuẩn toàn cầu”.

Hiện nay, AES xuất hiện ở mọi nơi: từ mạng Wi-Fi, VPN, ngân hàng trực tuyến, điện thoại thông minh, cho tới blockchain và tiền mã hóa.

## 2. Nguyên Lý Hoạt Động của AES

### 2.1 Cấu Trúc Tổng Quan

AES sử dụng kiến trúc Substitution-Permutation Network (SPN) với các thành phần chính:

```
    Plaintext (128 bits)
       ↓
    AddRoundKey
       ↓
   ┌─────────────────┐
   │  9 Main Rounds  │
   │  (10, 12, 14)   │
   └─────────────────┘
       ↓
    Final Round
       ↓
    Ciphertext (128 bits)
```

### 2.2 Các Thành Phần Cơ Bản

#### 2.2.1 State Array
Dữ liệu được tổ chức thành ma trận 4x4 byte:
```
┌──────┬──────┬──────┬──────┐
│ s0,0 │ s0,1 │ s0,2 │ s0,3 │
├──────┼──────┼──────┼──────┤
│ s1,0 │ s1,1 │ s1,2 │ s1,3 │
├──────┼──────┼──────┼──────┤
│ s2,0 │ s2,1 │ s2,2 │ s2,3 │
├──────┼──────┼──────┼──────┤
│ s3,0 │ s3,1 │ s3,2 │ s3,3 │
└──────┴──────┴──────┴──────┘
```

#### 2.2.2 Key Schedule
Quá trình tạo ra các khóa con (subkeys) cho từng vòng:
- **Key Expansion**: Tạo 11, 13, hoặc 15 khóa con
- **Key Derivation**: Sử dụng hằng số vòng và S-box

### 2.3 Các Phép Biến Đổi Chính

#### 2.3.1 SubBytes
Thay thế mỗi byte bằng giá trị tương ứng từ S-box:
```
s'i,j = S-box(si,j)
```

**Ví dụ S-box:**
```
Input:  0x53
Output: 0xED
```

#### 2.3.2 ShiftRows
Dịch chuyển các hàng theo quy tắc:
- Hàng 0: Không dịch
- Hàng 1: Dịch trái 1 vị trí
- Hàng 2: Dịch trái 2 vị trí  
- Hàng 3: Dịch trái 3 vị trí

```
Trước:          Sau:
┌─┬─┬─┬─┐      ┌─┬─┬─┬─┐
│a│b│c│d│      │a│b│c│d│
├─┼─┼─┼─┤      ├─┼─┼─┼─┤
│e│f│g│h│      │f│g│h│e│
├─┼─┼─┼─┤   →  ├─┼─┼─┼─┤
│i│j│k│l│      │k│l│i│j│
├─┼─┼─┼─┤      ├─┼─┼─┼─┤
│m│n│o│p│      │p│m│n│o│
└─┴─┴─┴─┘      └─┴─┴─┴─┘
```

#### 2.3.3 MixColumns
Nhân ma trận State với ma trận cố định trong trường GF(2⁸):
```
┌─┬─┬─┬─┐   ┌────┬────┬────┬────┐   ┌─────┬─────┬─────┬─────┐
│2│3│1│1│   │s0,0│s0,1│s0,2│s0,3│   │s'0,0│s'0,1│s'0,2│s'0,3│
├─┼─┼─┼─┤   ├────┼────┼────┼────┤   ├─────┼─────┼─────┼─────┤
│1│2│3│1│   │s1,0│s1,1│s1,2│s1,3│   │s'1,0│s'1,1│s'1,2│s'1,3│
├─┼─┼─┼─┤ × ├────┼────┼────┼────┤ = ├─────┼─────┼─────┼─────┤
│1│1│2│3│   │s2,0│s2,1│s2,2│s2,3│   │s'2,0│s'2,1│s'2,2│s'2,3│
├─┼─┼─┼─┤   ├────┼────┼────┼────┤   ├─────┼─────┼─────┼─────┤
│3│1│1│2│   │s3,0│s3,1│s3,2│s3,3│   │s'3,0│s'3,1│s'3,2│s'3,3│
└─┴─┴─┴─┘   └────┴────┴────┴────┘   └─────┴─────┴─────┴─────┘
```

#### 2.3.4 AddRoundKey
Thực hiện phép XOR giữa State và khóa con:
```
s'i,j = si,j ⊕ ki,j
```

### 2.4 Quá Trình Mã Hóa Chi Tiết

#### 2.4.1 Khởi Tạo
```
State = Plaintext
State = AddRoundKey(State, Key[0])
```

#### 2.4.2 Các Vòng Chính
```
for round = 1 to Nr-1:
    State = SubBytes(State)
    State = ShiftRows(State)
    State = MixColumns(State)
    State = AddRoundKey(State, Key[round])
```

#### 2.4.3 Vòng Cuối
```
State = SubBytes(State)
State = ShiftRows(State)
State = AddRoundKey(State, Key[Nr])
Ciphertext = State
```

### 2.5 Quá Trình Giải Mã

Giải mã AES sử dụng các phép biến đổi ngược:
- **InvSubBytes**: S-box ngược
- **InvShiftRows**: Dịch chuyển phải
- **InvMixColumns**: Ma trận nghịch đảo
- **AddRoundKey**: Giữ nguyên (tính chất XOR)

## 3. Bảo Mật và Phân Tích

### 3.1 Độ Mạnh Mã Hóa

- **Brute Force**: 2¹²⁸, 2¹⁹², 2²⁵⁶ operations
- **Differential Cryptanalysis**: Không hiệu quả
- **Linear Cryptanalysis**: Không hiệu quả
- **Side-Channel Attacks**: Cần bảo vệ đặc biệt

### 3.2 Các Loại Tấn Công

#### 3.2.1 Power Analysis
- **Simple Power Analysis (SPA)**: Phân tích công suất đơn giản
- **Differential Power Analysis (DPA)**: Phân tích công suất vi sai

#### 3.2.2 Timing Attacks
- **Cache Timing**: Tấn công dựa trên thời gian cache
- **Branch Prediction**: Tấn công dựa trên dự đoán nhánh

#### 3.2.3 Fault Injection
- **Glitch Attacks**: Tấn công bằng xung nhiễu
- **Laser Fault Injection**: Tiêm lỗi bằng laser

## 4. Caravel Platform và AES IP Core

### 4.1 Giới Thiệu Caravel

Caravel là một SoC (System-on-Chip) mã nguồn mở được phát triển bởi Google và Efabless, được thiết kế đặc biệt cho các dự án chip mã nguồn mở. Caravel cung cấp một nền tảng hoàn chỉnh để tích hợp các IP core tùy chỉnh.

**Đặc điểm chính:**
- **Open Source**: Toàn bộ RTL và tài liệu đều mở
- **SkyWater 130nm**: Sử dụng công nghệ SkyWater 130nm
- **Wishbone Bus**: Giao diện bus Wishbone chuẩn
- **RISC-V Core**: Tích hợp lõi RISC-V
- **User Project Area**: Khu vực dành cho IP core tùy chỉnh

### 4.2 Kiến Trúc Caravel

```
┌─────────────────────────────────────────┐
│              Caravel SoC                │
├─────────────────────────────────────────┤
│  ┌─────────────┐  ┌──────────────────┐  │
│  │  RISC-V     │  │  User Project    │  │
│  │  Core       │  │  Area            │  │
│  └─────────────┘  │                  │  │ 
│  ┌─────────────┐  │  ┌─────────────┐ │  │ 
│  │  Wishbone   │◄─┤  │  AES IP     │ │  │ 
│  │  Bus        │  │  │  Core       │ │  │ 
│  └─────────────┘  │  └─────────────┘ │  │
│  ┌─────────────┐  │                  │  │
│  │  GPIO,      │  │  ┌─────────────┐ │  │
│  │  UART,      │  │  │  Other      │ │  │
│  │  SPI, etc.  │  │  │  Peripherals│ │  │
│  └─────────────┘  │  └─────────────┘ │  │
|                   └──────────────────┘  |
└─────────────────────────────────────────┘
```

### 4.3 Tích Hợp AES IP Core

#### 4.3.1 Giao Diện Wishbone
AES IP core được tích hợp thông qua giao diện Wishbone:
- **Slave Interface**: Nhận lệnh từ RISC-V core
- **Register Map**: Định nghĩa các thanh ghi điều khiển
- **Data Transfer**: Truyền dữ liệu và khóa

#### 4.3.2 Memory Mapping
```
0x3000_0000 - 0x3000_0003: Control Register
0x3000_0004 - 0x3000_0007: Status Register  
0x3000_0008 - 0x3000_000B: Configuration Register
0x3000_0010 - 0x3000_002F: Key Storage (128-bit)
0x3000_0020 - 0x3000_002F: Input Block (128-bit)
0x3000_0030 - 0x3000_003F: Output Block (128-bit)
```

#### 4.3.3 Điều Khiển và Trạng Thái
- **Control Register**: Khởi tạo, bắt đầu mã hóa/giải mã
- **Status Register**: ready, finish, error
- **Configuration Register**: Chế độ mã hóa/giải mã, kích thước khóa

### 4.4 Lợi Ích của Caravel Platform

#### 4.4.1 Phát Triển Nhanh
- **Pre-built Infrastructure**: Hạ tầng có sẵn
- **Standard Interfaces**: Giao diện chuẩn
- **Open Source Tools**: Công cụ mở

#### 4.4.2 Chi Phí Thấp
- **No Licensing Fees**: Không phí cấp phép
- **Community Support**: Hỗ trợ cộng đồng
- **Shared Resources**: Chia sẻ tài nguyên

#### 4.4.3 Tương Thích
- **Industry Standards**: Tiêu chuẩn công nghiệp
- **Multiple Foundries**: Nhiều nhà máy sản xuất
- **Scalable Design**: Thiết kế có thể mở rộng

## 5. Kết Luận

AES là một thuật toán mã hóa mạnh mẽ và được sử dụng rộng rãi, cung cấp bảo mật cao cho các ứng dụng hiện đại. Việc triển khai AES trên Caravel platform mang lại nhiều lợi ích:

- **Hiệu suất cao**: Xử lý phần cứng chuyên dụng
- **Bảo mật tốt**: Bảo vệ chống side-channel attacks
- **Tích hợp dễ dàng**: Giao diện Wishbone chuẩn
- **Chi phí thấp**: Nền tảng mã nguồn mở
- **Phát triển nhanh**: Hạ tầng có sẵn

Dự án AES Accelerator trên Caravel không chỉ cung cấp một giải pháp mã hóa hiệu quả mà còn mở ra cơ hội học tập và nghiên cứu về thiết kế chip mã nguồn mở.

---

**[🏗️ Step 2 - RTL design](02_rtl_design.md)** - Kiến trúc RTL và luồng thực thi CPU
