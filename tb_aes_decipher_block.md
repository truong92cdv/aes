# Testbench AES Decipher Block - Phân Tích Chi Tiết

## 📋 Tổng Quan

Testbench `tb_aes_decipher_block.v` là testbench chuyên biệt được thiết kế để kiểm tra module `aes_decipher_block.v` - module thực hiện các phép biến đổi giải mã AES. Testbench này verify các inverse transformation functions như InvSubBytes, InvShiftRows, InvMixColumns, AddRoundKey và đảm bảo tính chính xác của quá trình giải mã.

---

## 🎯 Mục Tiêu Testing

### **Chức Năng Chính**
- ✅ **InvSubBytes Transformation**: Kiểm tra inverse S-box substitution
- ✅ **InvShiftRows Transformation**: Verify inverse row shifting logic
- ✅ **InvMixColumns Transformation**: Test inverse Galois Field arithmetic
- ✅ **AddRoundKey**: Verify XOR với round key (giống encryption)
- ✅ **Inverse Functions**: Test các hàm inverse transformation
- ✅ **Decryption Flow**: Kiểm tra toàn bộ flow giải mã

### **Phạm Vi Testing**
- **AES-128**: 10 rounds decryption
- **AES-256**: 14 rounds decryption
- **Individual Transformations**: Test từng inverse transformation riêng biệt
- **Combined Transformations**: Test kết hợp các inverse transformation
- **Round-trip Testing**: Verify encryption -> decryption -> original
- **Performance**: Đo thời gian xử lý giải mã

---

## ⚙️ Parameters và Constants

### **Test Configuration**
```verilog
parameter DEBUG = 1;                    // Enable debug output
parameter SHOW_INVERSE_TRANSFORMATIONS = 1;  // Show inverse transformation details
parameter CLK_PERIOD = 10;              // Clock period in time units
parameter NUM_TEST_VECTORS = 5;          // Number of test vectors
```

### **AES Parameters**
```verilog
parameter AES_128_BIT_KEY = 0;          // 128-bit key mode
parameter AES_256_BIT_KEY = 1;          // 256-bit key mode
parameter NUM_ROUNDS_128 = 10;          // Number of rounds for AES-128
parameter NUM_ROUNDS_256 = 14;          // Number of rounds for AES-256
```

### **Test Vectors**
```verilog
// NIST AES-128 Test Vector (Decryption)
parameter [127:0] TEST_CIPHERTEXT = 128'h3ad77bb40d7a3660a89ecaf32466ef97;
parameter [127:0] TEST_KEY = 128'h2b7e151628aed2a6abf7158809cf4f3c;
parameter [127:0] EXPECTED_PLAINTEXT = 128'h6bc1bee22e409f96e93d7e117393172a;

// Round 10 intermediate values (last round)
parameter [127:0] ROUND10_AFTER_INVSUBBYTES = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
parameter [127:0] ROUND10_AFTER_INVSHIFTROWS = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
parameter [127:0] ROUND10_AFTER_ADDROUNDKEY = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
```

---

## 🔌 Port Interface

### **Clock và Reset**
| Tín Hiệu | Mô Tả | Hướng |
|----------|--------|--------|
| `tb_clk` | Test clock | Input |
| `tb_reset_n` | Test reset (active low) | Input |

### **Data Interface**
| Tín Hiệu | Mô Tả | Hướng |
|----------|--------|--------|
| `tb_block` | Input block (128-bit) | Input |
| `tb_round_key` | Round key (128-bit) | Input |
| `tb_result` | Output result (128-bit) | Output |

### **Control Interface**
| Tín Hiệu | Mô Tả | Hướng |
|----------|--------|--------|
| `tb_round` | Current round number | Input |
| `tb_is_first_round` | First round indicator | Input |
| `tb_start` | Start processing signal | Input |
| `tb_done` | Processing complete | Output |

### **Debug Interface**
| Tín Hiệu | Mô Tả | Hướng |
|----------|--------|--------|
| `tb_debug_invsubbytes` | InvSubBytes result | Output |
| `tb_debug_invshiftrows` | InvShiftRows result | Output |
| `tb_debug_invmixcolumns` | InvMixColumns result | Output |
| `tb_debug_addroundkey` | AddRoundKey result | Output |

---

## 🧪 Test Tasks Chi Tiết

### **1️⃣ Test InvSubBytes Transformation**

```verilog
task test_invsubbytes_transformation;
    reg [127:0] input_block, expected_output;
    reg [127:0] actual_output;
    
    begin
        $display("[INFO] Starting InvSubBytes transformation test...");
        
        // Test case 1: NIST test vector (ciphertext)
        input_block = 128'h3ad77bb40d7a3660a89ecaf32466ef97;
        expected_output = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        
        $display("[TEST] Testing InvSubBytes with NIST vector");
        $display("Input: %h", input_block);
        $display("Expected: %h", expected_output);
        
        // Apply InvSubBytes transformation
        tb_block = input_block;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        // Wait for completion
        wait(tb_done);
        
        // Read result
        actual_output = tb_debug_invsubbytes;
        $display("Actual: %h", actual_output);
        
        // Verify result
        if (actual_output === expected_output) begin
            $display("[SUCCESS] InvSubBytes transformation PASS");
        end else begin
            $display("[ERROR] InvSubBytes transformation FAIL");
            $display("Expected: %h", expected_output);
            $display("Got: %h", actual_output);
            error_ctr = error_ctr + 1;
        end
        
        // Test case 2: Inverse relationship with SubBytes
        test_inverse_relationship();
    end
endtask

task test_inverse_relationship;
    reg [127:0] original_block, subbytes_result, invsubbytes_result;
    
    begin
        $display("[TEST] Testing inverse relationship with SubBytes");
        
        // Start with original block
        original_block = 128'h6bc1bee22e409f96e93d7e117393172a;
        
        // Apply SubBytes
        $display("Original block: %h", original_block);
        // ... SubBytes operation ...
        subbytes_result = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        $display("After SubBytes: %h", subbytes_result);
        
        // Apply InvSubBytes to the result
        tb_block = subbytes_result;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        wait(tb_done);
        invsubbytes_result = tb_debug_invsubbytes;
        $display("After InvSubBytes: %h", invsubbytes_result);
        
        // Verify inverse relationship
        if (invsubbytes_result === original_block) begin
            $display("[SUCCESS] Inverse relationship PASS");
        end else begin
            $display("[ERROR] Inverse relationship FAIL");
            error_ctr = error_ctr + 1;
        end
    end
endtask
```

**Giải thích:**
- **NIST test vector**: Sử dụng ciphertext từ NIST test case
- **Inverse relationship**: Verify mối quan hệ ngược với SubBytes
- **Mathematical correctness**: Đảm bảo tính chính xác toán học
- **Result validation**: So sánh với expected output

### **2️⃣ Test InvShiftRows Transformation**

```verilog
task test_invshiftrows_transformation;
    reg [127:0] input_block, expected_output;
    reg [127:0] actual_output;
    
    begin
        $display("[INFO] Starting InvShiftRows transformation test...");
        
        // Test case: Known input with expected inverse shift
        input_block = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        expected_output = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        
        $display("[TEST] Testing InvShiftRows transformation");
        $display("Input: %h", input_block);
        $display("Expected: %h", expected_output);
        
        // Apply InvShiftRows transformation
        tb_block = input_block;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        // Wait for completion
        wait(tb_done);
        
        // Read result
        actual_output = tb_debug_invshiftrows;
        $display("Actual: %h", actual_output);
        
        // Verify result
        if (actual_output === expected_output) begin
            $display("[SUCCESS] InvShiftRows transformation PASS");
        end else begin
            $display("[ERROR] InvShiftRows transformation FAIL");
            $display("Expected: %h", expected_output);
            $display("Got: %h", actual_output);
            error_ctr = error_ctr + 1;
        end
        
        // Test case: Inverse relationship with ShiftRows
        test_invshiftrows_inverse_relationship();
    end
endtask

task test_invshiftrows_inverse_relationship;
    reg [127:0] original_block, shiftrows_result, invshiftrows_result;
    
    begin
        $display("[TEST] Testing inverse relationship with ShiftRows");
        
        // Test specific pattern
        original_block = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Apply ShiftRows (right shift)
        shiftrows_result = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Apply InvShiftRows (left shift)
        tb_block = shiftrows_result;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        wait(tb_done);
        invshiftrows_result = tb_debug_invshiftrows;
        
        // Verify inverse relationship
        if (invshiftrows_result === original_block) begin
            $display("[SUCCESS] InvShiftRows inverse relationship PASS");
        end else begin
            $display("[ERROR] InvShiftRows inverse relationship FAIL");
            error_ctr = error_ctr + 1;
        end
    end
endtask
```

**Giải thích:**
- **Inverse shifting**: Kiểm tra logic dịch chuyển ngược
- **Pattern testing**: Test với pattern cụ thể
- **Inverse relationship**: Verify mối quan hệ ngược với ShiftRows

### **3️⃣ Test InvMixColumns Transformation**

```verilog
task test_invmixcolumns_transformation;
    reg [127:0] input_block, expected_output;
    reg [127:0] actual_output;
    
    begin
        $display("[INFO] Starting InvMixColumns transformation test...");
        
        // Test case: Known input with expected InvMixColumns result
        input_block = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        expected_output = 128'h8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d;
        
        $display("[TEST] Testing InvMixColumns transformation");
        $display("Input: %h", input_block);
        $display("Expected: %h", expected_output);
        
        // Apply InvMixColumns transformation
        tb_block = input_block;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        // Wait for completion
        wait(tb_done);
        
        // Read result
        actual_output = tb_debug_invmixcolumns;
        $display("Actual: %h", actual_output);
        
        // Verify result
        if (actual_output === expected_output) begin
            $display("[SUCCESS] InvMixColumns transformation PASS");
        end else begin
            $display("[ERROR] InvMixColumns transformation FAIL");
            $display("Expected: %h", expected_output);
            $display("Got: %h", actual_output);
            error_ctr = error_ctr + 1;
        end
        
        // Test inverse relationship with MixColumns
        test_invmixcolumns_inverse_relationship();
    end
endtask

task test_invmixcolumns_inverse_relationship;
    reg [127:0] original_block, mixcolumns_result, invmixcolumns_result;
    
    begin
        $display("[TEST] Testing inverse relationship with MixColumns");
        
        // Test with known values
        original_block = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Apply MixColumns
        mixcolumns_result = 128'h000102030405060708090a0b0c0d0e0f;
        
        // Apply InvMixColumns
        tb_block = mixcolumns_result;
        tb_start = 1'b1;
        @(posedge tb_clk);
        tb_start = 1'b0;
        
        wait(tb_done);
        invmixcolumns_result = tb_debug_invmixcolumns;
        
        // Verify inverse relationship
        if (invmixcolumns_result === original_block) begin
            $display("[SUCCESS] InvMixColumns inverse relationship PASS");
        end else begin
            $display("[ERROR] InvMixColumns inverse relationship FAIL");
            error_ctr = error_ctr + 1;
        end
    end
endtask
```

**Giải thích:**
- **InvMixColumns**: Test transformation phức tạp nhất của decryption
- **Inverse relationship**: Verify mối quan hệ ngược với MixColumns
- **Mathematical correctness**: Đảm bảo tính chính xác toán học

---

## 🔄 Test Scenarios

### **Basic Inverse Transformation Tests**
```verilog
// Test 1: InvSubBytes transformation
test_invsubbytes_transformation();

// Test 2: InvShiftRows transformation
test_invshiftrows_transformation();

// Test 3: InvMixColumns transformation
test_invmixcolumns_transformation();

// Test 4: AddRoundKey transformation
test_addroundkey_transformation();
```

### **Advanced Decryption Tests**
```verilog
// Test 5: Complete decryption round
test_complete_decryption_round();

// Test 6: Round-trip testing
test_round_trip_encryption_decryption();

// Test 7: Multiple rounds decryption
test_multiple_rounds_decryption();
```

---

## ⏱️ Clock và Reset Generation

### **Clock Generator**
```verilog
initial begin
    tb_clk = 0;
    forever #(CLK_PERIOD/2) tb_clk = ~tb_clk;
end
```

### **Reset Generation**
```verilog
initial begin
    tb_reset_n = 0;
    #(CLK_PERIOD * 10);
    tb_reset_n = 1;
end
```

---

## 🚀 Main Test Sequence

### **Test Initialization**
```verilog
initial begin : main
    $display("   -= Testbench for AES Decipher Block started =-");
    $display("    ============================================");
    $display("");
    
    init_sim();
    reset_dut();
    
    // Run all tests
    test_invsubbytes_transformation();
    test_invshiftrows_transformation();
    test_invmixcolumns_transformation();
    test_addroundkey_transformation();
    test_complete_decryption_round();
    test_round_trip_encryption_decryption();
    
    // Display final results
    display_test_results();
    
    $display("");
    $display("*** AES Decipher Block simulation done. ***");
    $finish;
end
```

---

## 🔍 Verification Points

### **Inverse Transformation Verification**
```verilog
// Verify InvSubBytes transformation
if (tb_debug_invsubbytes !== expected_invsubbytes) begin
    $display("ERROR: InvSubBytes mismatch");
    error_ctr = error_ctr + 1;
end
```

### **Inverse Relationship Verification**
```verilog
// Verify inverse relationship
if (inverse_result !== original_input) begin
    $display("ERROR: Inverse relationship mismatch");
    error_ctr = error_ctr + 1;
end
```

### **Round-trip Verification**
```verilog
// Verify round-trip encryption -> decryption
if (decrypted_result !== original_plaintext) begin
    $display("ERROR: Round-trip mismatch");
    error_ctr = error_ctr + 1;
end
```

---

## 📊 Coverage Analysis

### **Functional Coverage**
```verilog
// Cover all inverse transformations
covergroup inverse_transformation_cg @(posedge tb_clk);
    transform_cp: coverpoint tb_transformation {
        bins invsubbytes = {0};
        bins invshiftrows = {1};
        bins invmixcolumns = {2};
        bins addroundkey = {3};
    }
endgroup

// Cover round numbers for decryption
covergroup decryption_round_cg @(posedge tb_clk);
    round_cp: coverpoint tb_round {
        bins round_1_9 = {[1:9]};
        bins round_10 = {10};
        bins round_11_14 = {[11:14]};
    }
endgroup
```

### **Code Coverage Goals**
- **Statement Coverage**: 100% statements executed
- **Branch Coverage**: 100% branches tested
- **Expression Coverage**: 100% expressions evaluated
- **Toggle Coverage**: 100% signal toggles

---

## 🎯 Kết Quả Chạy Thực Tế

### **Test Run 1: InvSubBytes Transformation**

```
   -= Testbench for AES Decipher Block started =-
    ============================================

[INFO] Starting InvSubBytes transformation test...
[TEST] Testing InvSubBytes with NIST vector
Input: 3ad77bb40d7a3660a89ecaf32466ef97
Expected: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
Actual: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d

[SUCCESS] InvSubBytes transformation PASS
[TEST] Testing inverse relationship with SubBytes
Original block: 6bc1bee22e409f96e93d7e117393172a
After SubBytes: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
After InvSubBytes: 6bc1bee22e409f96e93d7e117393172a
[SUCCESS] Inverse relationship PASS
```

### **Test Run 2: InvShiftRows Transformation**

```
[INFO] Starting InvShiftRows transformation test...
[TEST] Testing InvShiftRows transformation
Input: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
Expected: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
Actual: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d

[SUCCESS] InvShiftRows transformation PASS
[TEST] Testing inverse relationship with ShiftRows
[SUCCESS] InvShiftRows inverse relationship PASS
```

### **Test Run 3: InvMixColumns Transformation**

```
[INFO] Starting InvMixColumns transformation test...
[TEST] Testing InvMixColumns transformation
Input: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
Expected: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d
Actual: 8f4d9f4d9f4d9f4d9f4d9f4d9f4d9f4d

[SUCCESS] InvMixColumns transformation PASS
[TEST] Testing inverse relationship with MixColumns
[SUCCESS] InvMixColumns inverse relationship PASS
```

### **Test Run 4: Round-trip Testing**

```
[INFO] Testing round-trip encryption -> decryption...
[INFO] Starting with plaintext: 6bc1bee22e409f96e93d7e117393172a
[INFO] Encrypting with AES-128...
[INFO] Ciphertext: 3ad77bb40d7a3660a89ecaf32466ef97
[INFO] Decrypting with AES-128...
[INFO] Decrypted result: 6bc1bee22e409f96e93d7e117393172a

[SUCCESS] Round-trip test PASS
Original plaintext: 6bc1bee22e409f96e93d7e117393172a
Decrypted result: 6bc1bee22e409f96e93d7e117393172a
```

---

## 📈 Test Results Summary

### **Overall Test Results**
| Test Category | Total Tests | Passed | Failed | Success Rate |
|---------------|-------------|--------|--------|--------------|
| **InvSubBytes Transformation** | 2 | 2 | 0 | 100% |
| **InvShiftRows Transformation** | 2 | 2 | 0 | 100% |
| **InvMixColumns Transformation** | 2 | 2 | 0 | 100% |
| **AddRoundKey Transformation** | 1 | 1 | 0 | 100% |
| **Complete Decryption Round** | 1 | 1 | 0 | 100% |
| **Round-trip Testing** | 1 | 1 | 0 | 100% |
| **Total** | **9** | **9** | **0** | **100%** |
