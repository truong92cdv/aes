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

### 2.1. Cấu trúc tổng quan

AES là thuật toán mã hóa khối đối xứng:
- Dữ liệu được chia thành các khối 128 bit (16 byte).
- Khóa có thể dài 128, 192 hoặc 256 bit.
- Số vòng lặp (round) phụ thuộc vào độ dài khóa:
 . AES-128 → 10 round
 . AES-192 → 12 round
 . AES-256 → 14 round

Mỗi round là một chuỗi các phép biến đổi toán học, kết hợp dữ liệu và khóa để tạo ra bản mã.

### 2.2. Các bước chính trong một round AES

Mỗi round (trừ round cuối) có 4 bước:

- SubBytes (Thay thế byte)

 + Mỗi byte của khối dữ liệu đi qua một bảng thay thế gọi là S-box.
 + Đây là phép biến đổi phi tuyến tính, giúp AES chống lại các tấn công tuyến tính và vi sai.

- ShiftRows (Dịch hàng)

Ma trận 4×4 byte được dịch theo hàng:

Hàng 0 giữ nguyên.

Hàng 1 dịch trái 1 byte.

Hàng 2 dịch trái 2 byte.

Hàng 3 dịch trái 3 byte.

Bước này giúp dữ liệu "trộn lẫn" tốt hơn.

- MixColumns (Trộn cột)

Mỗi cột (4 byte) được coi là một vector và nhân với một ma trận cố định trong trường Galois GF(2^8).

Giúp phân tán thông tin trong toàn bộ khối dữ liệu.

- AddRoundKey (Cộng khóa vòng)

Khối dữ liệu được XOR với khóa con (round key) sinh ra từ khóa chính.

Đây là bước duy nhất dùng khóa để “gắn” bảo mật vào dữ liệu.

👉 Ở round cuối cùng, bước MixColumns được bỏ qua.

3. Key Expansion (Mở rộng khóa)

Khóa ban đầu (128/192/256 bit) sẽ được mở rộng thành nhiều round key (mỗi round có 1 khóa riêng).

Nguyên tắc:

Chia khóa gốc thành nhiều “từ” (word) 4 byte.

Sinh thêm các từ mới dựa trên từ trước đó, qua các phép biến đổi:

RotWord: xoay vòng 4 byte.

SubWord: thay thế từng byte bằng S-box.

XOR với Rcon: hằng số vòng.

Cứ mỗi 4 từ tạo thành một round key (128 bit).

Ví dụ AES-128:

Khóa gốc 128 bit → 44 từ (4 từ cho mỗi round key).

Tổng cộng tạo ra 11 round key (1 cho AddRoundKey ban đầu + 10 cho 10 round).

4. Quá trình giải mã (Decryption)

AES được thiết kế có tính đối xứng nên giải mã chỉ là thực hiện ngược lại:

Inverse ShiftRows: dịch ngược lại các hàng.

Inverse SubBytes: dùng bảng S-box nghịch đảo.

Inverse MixColumns: nhân với ma trận nghịch đảo.

AddRoundKey: XOR với round key tương ứng (giống như mã hóa).

Thứ tự các bước cũng đảo ngược so với mã hóa.

👉 Đặc biệt: do AES sử dụng XOR trong bước AddRoundKey, nên mã hóa và giải mã cùng dùng chung round key (chỉ khác thứ tự).

5. Tóm tắt trực quan

Đầu vào: Plaintext (128 bit) + Key (128/192/256 bit).

Tiền xử lý: AddRoundKey với khóa ban đầu.

Round 1 → N-1: SubBytes → ShiftRows → MixColumns → AddRoundKey.

Round cuối: SubBytes → ShiftRows → AddRoundKey.

Đầu ra: Ciphertext (128 bit).

👉 Nói nôm na, AES giống như việc bạn lấy một bản nhạc gốc (plaintext), rồi qua 10–14 lần remix (round), mỗi lần lại thêm hiệu ứng, đảo nhạc, trộn âm thanh, và cuối cùng ra một bản nhạc hoàn toàn khác (ciphertext). Muốn nghe lại nhạc gốc, bạn phải biết chính xác công thức và key remix để đảo ngược quá trình.

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
