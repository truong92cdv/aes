# 🔐 AES Accelerator Documentation

## 🎯 Tổng Quan

Dự án AES Accelerator trên Caravel Platform - triển khai phần cứng thuật toán mã hóa AES được tích hợp vào SoC mã nguồn mở Caravel.

## 📖 Tài Liệu

### **🚀 Bắt Đầu**
- **[01_theory.md](01_theory.md)** - Lý thuyết AES và Caravel
- **[02_rtl_design.md](02_rtl_design.md)** - Kiến trúc RTL và CPU flow
- **[03_rtl_testbench.md](03_rtl_testbench.md)** - Testbench và kết quả

### **🏗️ RTL Modules**
- **[rtl_aes.md](rtl_aes.md)** - Module chính AES
- **[rtl_aes_core.md](rtl_aes_core.md)** - Module điều khiển
- **[rtl_aes_key_mem.md](rtl_aes_key_mem.md)** - Module khóa
- **[rtl_aes_encipher_block.md](rtl_aes_encipher_block.md)** - Module mã hóa
- **[rtl_aes_decipher_block.md](rtl_aes_decipher_block.md)** - Module giải mã

### **🧪 Testbench**
- **[tb_aes.md](tb_aes.md)** - Testbench chính
- **[tb_aes_core.md](tb_aes_core.md)** - Testbench điều khiển
- **[tb_aes_key_mem.md](tb_aes_key_mem.md)** - Testbench khóa
- **[tb_aes_encipher_block.md](tb_aes_encipher_block.md)** - Testbench mã hóa
- **[tb_aes_decipher_block.md](tb_aes_decipher_block.md)** - Testbench giải mã

### **🔧 Thực Hành**
- **[cpu_flow.md](cpu_flow.md)** - CPU interface
- **[04_openlane2_flow.md](04_openlane2_flow.md)** - OpenLane2 flow
- **[05_future_devs.md](05_future_devs.md)** - Hướng phát triển
- **[06_references.md](06_references.md)** - Tài liệu tham khảo

## 🎯 Tính Năng

- **AES-128/256**: Hỗ trợ khóa 128-bit và 256-bit
- **NIST FIPS 197**: Tuân thủ chuẩn quốc tế
- **Wishbone Bus**: Giao diện bus chuẩn
- **Caravel Integration**: Tích hợp Caravel Platform
- **Open Source**: Mã nguồn mở hoàn toàn
