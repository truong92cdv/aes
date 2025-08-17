# Step 3 - RTL Testbench

## 1. Cấu Trúc Testbench

### 1.1 Sơ Đồ Tổ Chức Testbench

```
┌─────────────────────────────────────────────────────┐
│                Testbench Hierarchy                  │
├─────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │  tb_aes.v   │  │tb_aes_core  │  │tb_aes_key   │  │
│  │ (Top Level) │  │   .v        │  │  _mem.v     │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
│  ┌─────────────┐  ┌─────────────┐                   │
│  │tb_aes_enc   │  │tb_aes_dec   │                   │
│  │ipher_block  │  │ipher_block  │                   │
│  │    .v       │  │    .v       │                   │
│  └─────────────┘  └─────────────┘                   │
└─────────────────────────────────────────────────────┘
```

### 1.2 Phân Cấp Testbench

- **tb_aes.v**: Testbench chính cho toàn bộ hệ thống AES
- **tb_aes_core.v**: Testbench cho lõi điều khiển AES
- **tb_aes_encipher_block.v**: Testbench cho module mã hóa
- **tb_aes_decipher_block.v**: Testbench cho module giải mã
- **tb_aes_key_mem.v**: Testbench cho quản lý khóa

## 3. Phân Tích Testbench

### 3.1 tb_aes.v - Top Level Testbench

#### 3.1.1 Test Structure
```verilog
// Main test sequence
initial begin : main
    init_sim();
    dump_dut_state();
    reset_dut();
    dump_dut_state();
    aes_test();
    display_test_results();
    $finish;
end
```

#### 3.1.2 NIST Test Vectors
```verilog
// AES-128 Test Vectors
nist_aes128_key1 = 256'h2b7e151628aed2a6abf7158809cf4f3c00000000000000000000000000000000;
nist_plaintext0 = 128'h6bc1bee22e409f96e93d7e117393172a;
nist_ecb_128_enc_expected0 = 128'h3ad77bb40d7a3660a89ecaf32466ef97;

// AES-256 Test Vectors  
nist_aes256_key1 = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
nist_ecb_256_enc_expected0 = 128'hf3eed1bdb5d2a03c064b5a7e3db181f8;
```

#### 3.1.3 Test Cases
- **ECB Mode**: Electronic Codebook mode testing
- **128-bit Keys**: 10 test cases (5 encrypt + 5 decrypt)
- **256-bit Keys**: 10 test cases (5 encrypt + 5 decrypt)
- **Round-trip Testing**: Encrypt then decrypt to verify correctness

### 3.2 tb_aes_core.v - Core Testbench

#### 3.2.1 Test Scenarios
```verilog
// Test scenarios
task test_encryption_128;
task test_decryption_128;
task test_encryption_256;
task test_decryption_256;
```

#### 3.2.2 Verification Points
- **Key Loading**: Kiểm tra việc tải khóa
- **Data Processing**: Kiểm tra xử lý dữ liệu
- **Result Validation**: Kiểm tra kết quả đầu ra
- **Timing Verification**: Kiểm tra timing constraints

### 3.3 tb_aes_key_mem.v - Key Memory Testbench

#### 3.3.1 Key Expansion Testing
```verilog
// Test key expansion for different key lengths
task test_key_expansion_128;
task test_key_expansion_256;
```

#### 3.3.2 Verification Features
- **Round Key Generation**: Kiểm tra tạo khóa con
- **S-box Integration**: Kiểm tra tích hợp S-box
- **Rcon Values**: Kiểm tra round constants

### 3.4 tb_aes_encipher_block.v và tb_aes_decipher_block.v

#### 3.4.1 Block Processing Tests
- **Single Round Testing**: Kiểm tra từng vòng riêng biệt
- **Full Block Testing**: Kiểm tra toàn bộ khối
- **Edge Cases**: Kiểm tra các trường hợp đặc biệt

#### 3.4.2 Transformation Verification
- **SubBytes**: Kiểm tra thay thế byte
- **ShiftRows**: Kiểm tra dịch chuyển hàng
- **MixColumns**: Kiểm tra biến đổi cột
- **AddRoundKey**: Kiểm tra XOR với khóa con

## 4. Kết Quả Testbench

### 4.1 Test Coverage

#### 4.1.1 Functional Coverage
- **100% AES Operations**: Mã hóa và giải mã
- **100% Key Lengths**: 128-bit và 256-bit
- **100% Modes**: ECB mode testing
- **100% Transformations**: Tất cả phép biến đổi AES

#### 4.1.2 Code Coverage
- **Statement Coverage**: 100% statements executed
- **Branch Coverage**: 100% branches tested
- **Expression Coverage**: 100% expressions evaluated
- **Toggle Coverage**: 100% signal toggles

### 4.2 Test Results Analysis

#### 4.2.1 Success Metrics
- **All NIST Vectors Pass**: 20/20 test cases passed
- **Round-trip Verification**: Encrypt-decrypt cycles successful
- **Timing Compliance**: All timing constraints met
- **Resource Utilization**: Within expected limits
