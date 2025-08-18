# Step 3 - RTL Testbench

**[🏠 Home](../README.md)**

## 📋 Tổng Quan

Phần này mô tả cấu trúc và kết quả của các testbench được sử dụng để verify AES Accelerator. Các testbench được thiết kế để kiểm tra toàn diện chức năng của từng module, đảm bảo tính chính xác của thuật toán AES theo chuẩn NIST FIPS 197, và validate sự tích hợp giữa các module con.

---

## 🏗️ Cấu Trúc Testbench

### **Testbench Hierarchy**
```
Testbench Files
├── tb_aes.v (Top-level AES)
├── tb_aes_core.v (Core Control)
├── tb_aes_key_mem.v (Key Memory)
├── tb_aes_encipher_block.v (Encryption)
└── tb_aes_decipher_block.v (Decryption)
```

### **Test Strategy**
- **Functional Testing**: Verify chức năng cơ bản của từng module
- **NIST Compliance**: Sử dụng NIST test vectors chuẩn
- **Coverage Testing**: Đảm bảo độ bao phủ code và functionality
- **Edge Case Testing**: Test các trường hợp đặc biệt và boundary conditions

---

## 🔧 Các Testbench Chính

### **1. tb_aes.v - Top-Level Testing**
- **Mục đích**: Test toàn bộ hệ thống AES end-to-end
- **Test Cases**: 
  - AES-128 encryption/decryption
  - AES-256 encryption/decryption
  - NIST test vector verification
  - Round-trip testing (encrypt → decrypt → original)
- **Coverage**: Integration testing, bus interface, control flow

### **2. tb_aes_core.v - Control Logic Testing**
- **Mục đích**: Verify state machine và control logic
- **Test Cases**:
  - State transitions (IDLE → INIT → NEXT → IDLE)
  - Control signal validation
  - Round counter logic
  - Error handling
- **Coverage**: State machine coverage, control signal coverage

### **3. tb_aes_key_mem.v - Key Management Testing**
- **Mục đích**: Test key expansion algorithm
- **Test Cases**:
  - AES-128 key expansion (11 round keys)
  - AES-256 key expansion (15 round keys)
  - S-box integration
  - Round constants (Rcon) verification
- **Coverage**: Key expansion coverage, S-box coverage

### **4. tb_aes_encipher_block.v - Encryption Testing**
- **Mục đích**: Verify encryption transformations
- **Test Cases**:
  - SubBytes transformation
  - ShiftRows transformation
  - MixColumns transformation
  - AddRoundKey operation
  - Galois Field arithmetic (gm2, gm3)
- **Coverage**: Transformation coverage, mathematical correctness

### **5. tb_aes_decipher_block.v - Decryption Testing**
- **Mục đích**: Verify decryption transformations
- **Test Cases**:
  - InvSubBytes transformation
  - InvShiftRows transformation
  - InvMixColumns transformation
  - AddRoundKey operation
  - Inverse Galois Field arithmetic (gm9, gm11, gm13, gm14)
- **Coverage**: Inverse transformation coverage, round-trip verification

---

## 🎯 Verification Methodology

### **Test Vector Strategy**
- **NIST FIPS 197**: Sử dụng test vectors chuẩn quốc tế
- **Known Plaintext**: Test với plaintext và ciphertext đã biết
- **Round-trip Testing**: Verify encryption → decryption → original
- **Edge Cases**: Test với all-zero, all-one, và boundary values

---

## 📊 Kết Quả Testbench

### **Functional Verification Results**

#### **tb_aes.v - Top-Level**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **AES-128 Encryption** | 1 | 1 | 0 | 100% |
| **AES-128 Decryption** | 1 | 1 | 0 | 100% |
| **AES-256 Encryption** | 1 | 1 | 0 | 100% |
| **AES-256 Decryption** | 1 | 1 | 0 | 100% |
| **Total** | **4** | **4** | **0** | **100%** |

#### **tb_aes_core.v - Control Logic**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **State Machine** | 4 | 4 | 0 | 100% |
| **AES-128 Encryption Flow** | 1 | 1 | 0 | 100% |
| **AES-256 Decryption Flow** | 1 | 1 | 0 | 100% |
| **Reset Functionality** | 2 | 2 | 0 | 100% |
| **Total** | **8** | **8** | **0** | **100%** |

#### **tb_aes_key_mem.v - Key Memory**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **AES-128 Key Expansion** | 11 | 11 | 0 | 100% |
| **AES-256 Key Expansion** | 15 | 15 | 0 | 100% |
| **Edge Cases** | 3 | 3 | 0 | 100% |
| **Reset Functionality** | 2 | 2 | 0 | 100% |
| **Total** | **31** | **31** | **0** | **100%** |

#### **tb_aes_encipher_block.v - Encryption**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **SubBytes Transformation** | 2 | 2 | 0 | 100% |
| **ShiftRows Transformation** | 2 | 2 | 0 | 100% |
| **MixColumns Transformation** | 1 | 1 | 0 | 100% |
| **AddRoundKey Transformation** | 1 | 1 | 0 | 100% |
| **Complete Round Processing** | 1 | 1 | 0 | 100% |
| **Total** | **7** | **7** | **0** | **100%** |

#### **tb_aes_decipher_block.v - Decryption**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **InvSubBytes Transformation** | 2 | 2 | 0 | 100% |
| **InvShiftRows Transformation** | 2 | 2 | 0 | 100% |
| **InvMixColumns Transformation** | 2 | 2 | 0 | 100% |
| **AddRoundKey Transformation** | 1 | 1 | 0 | 100% |
| **Complete Decryption Round** | 1 | 1 | 0 | 100% |
| **Round-trip Testing** | 1 | 1 | 0 | 100% |
| **Total** | **9** | **9** | **0** | **100%** |

### **Tổng Kết Coverage**
| Module | Test Cases | Passed | Failed | Success Rate |
|--------|------------|--------|--------|--------------|
| **Top-Level (aes.v)** | 4 | 4 | 0 | 100% |
| **Core Control** | 8 | 8 | 0 | 100% |
| **Key Memory** | 31 | 31 | 0 | 100% |
| **Encryption** | 7 | 7 | 0 | 100% |
| **Decryption** | 9 | 9 | 0 | 100% |
| **Grand Total** | **59** | **59** | **0** | **100%** |

---

### **Giải Thích Chi Tiết Từng File Testbench**

* [tb_aes.v](tb_aes.md)
* [tb_aes_core.v](tb_aes_core.md)
* [tb_aes_encipher_block.v](tb_aes_encipher_block.md)
* [tb_aes_decipher_block.v](tb_aes_decipher_block.md)
* [tb_aes_key_mem.v](tb_aes_key_mem.md)
* [tb_aes_sbox.v](tb_aes_sbox.md)
* [tb_aes_inv_sbox.v](tb_aes_inv_sbox.md)

---

**[🔧 Step 4 - Build project, step by step](04_build_project.md)** - Hướng dẫn build project
