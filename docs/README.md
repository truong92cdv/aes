# 📚 AES Accelerator Documentation

## 🎯 Tổng Quan Dự Án

Dự án AES Accelerator trên Caravel Platform là một triển khai phần cứng của thuật toán mã hóa AES (Advanced Encryption Standard) được tích hợp vào hệ thống SoC mã nguồn mở Caravel. Dự án cung cấp một giải pháp mã hóa hiệu quả, bảo mật và dễ tích hợp cho các ứng dụng IoT, embedded systems và các dự án chip mã nguồn mở.

## 🏗️ Kiến Trúc Tổng Thể

```
┌─────────────────────────────────────────────────────────────┐
│                    AES Accelerator System                   │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │   RTL Core  │  │  Wishbone   │  │  Caravel    │        │
│  │   Modules   │◄─┤   Bus       │◄─┤  Platform   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ Testbench   │  │  CPU Flow   │  │  OpenLane2  │        │
│  │  Suite      │  │  Interface  │  │   Flow      │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 📖 Tài Liệu Hướng Dẫn

### **🚀 Bắt Đầu Nhanh**

1. **[01_theory.md](01_theory.md)** - Lý thuyết AES và Caravel Platform
2. **[02_rtl_design.md](02_rtl_design.md)** - Kiến trúc RTL và luồng thực thi CPU
3. **[03_rtl_testbench.md](03_rtl_testbench.md)** - Tổng quan testbench và kết quả

### **🏗️ Thiết Kế RTL Chi Tiết**

#### **Module Chính**
- **[rtl_aes.md](rtl_aes.md)** - Module chính AES (top-level)
- **[rtl_aes_core.md](rtl_aes_core.md)** - Module điều khiển trung tâm

#### **Module Chức Năng**
- **[rtl_aes_key_mem.md](rtl_aes_key_mem.md)** - Module quản lý khóa và key expansion
- **[rtl_aes_encipher_block.md](rtl_aes_encipher_block.md)** - Module mã hóa AES
- **[rtl_aes_decipher_block.md](rtl_aes_decipher_block.md)** - Module giải mã AES

### **🧪 Testbench và Verification**

#### **Testbench Chính**
- **[tb_aes.md](tb_aes.md)** - Testbench module chính AES (end-to-end)
- **[tb_aes_core.md](tb_aes_core.md)** - Testbench module điều khiển
- **[tb_aes_key_mem.md](tb_aes_key_mem.md)** - Testbench module khóa
- **[tb_aes_encipher_block.md](tb_aes_encipher_block.md)** - Testbench module mã hóa
- **[tb_aes_decipher_block.md](tb_aes_decipher_block.md)** - Testbench module giải mã

### **🔧 Hướng Dẫn Thực Hành**

- **[cpu_flow.md](cpu_flow.md)** - Luồng thực thi CPU khi giao tiếp với AES core
- **[04_openlane2_flow.md](04_openlane2_flow.md)** - Quy trình OpenLane2 cho ASIC
- **[05_future_devs.md](05_future_devs.md)** - Hướng phát triển tương lai

### **📚 Tài Liệu Tham Khảo**

- **[06_references.md](06_references.md)** - Tài liệu tham khảo và nguồn

## 🎯 Tính Năng Chính

### **🔐 Thuật Toán AES**
- ✅ **AES-128**: Khóa 128-bit, 10 vòng
- ✅ **AES-256**: Khóa 256-bit, 14 vòng
- ✅ **ECB Mode**: Electronic Codebook mode
- ✅ **NIST FIPS 197**: Tuân thủ chuẩn quốc tế

### **🚀 Hiệu Suất**
- **Throughput**: 1 block/10-14 clock cycles
- **Latency**: 11-15 clock cycles total
- **Frequency**: Hỗ trợ tần số cao
- **Area**: Tối ưu hóa diện tích chip

### **🔌 Giao Diện**
- **Wishbone Bus**: Giao diện bus chuẩn
- **Memory Mapped**: Điều khiển qua thanh ghi
- **Interrupt Support**: Hỗ trợ ngắt
- **Configurable**: Cấu hình linh hoạt

## 🛠️ Công Cụ và Môi Trường

### **Development Tools**
- **Verilog HDL**: Ngôn ngữ thiết kế chính
- **Icarus Verilog**: Simulator
- **GTKWave**: Waveform viewer
- **OpenLane2**: ASIC design flow

### **Platform Support**
- **Caravel**: SoC platform chính
- **SkyWater 130nm**: Process technology
- **RISC-V**: CPU architecture
- **Open Source**: Mã nguồn mở hoàn toàn

## 📊 Kết Quả Verification

### **Test Coverage**
- **Functional Tests**: 59/59 passed (100%)
- **NIST Compliance**: ✅ Verified
- **Round-trip Testing**: ✅ Encrypt → Decrypt → Original
- **Edge Cases**: ✅ All-zero, all-one, boundary values

### **Performance Metrics**
- **Code Coverage**: 100% statement, branch, expression
- **State Machine**: 100% transition coverage
- **Signal Coverage**: 100% control và data signals

## 🚀 Bắt Đầu Sử Dụng

### **1. Đọc Lý Thuyết**
Bắt đầu với **[01_theory.md](01_theory.md)** để hiểu về AES và Caravel platform.

### **2. Hiểu Kiến Trúc**
Đọc **[02_rtl_design.md](02_rtl_design.md)** để nắm kiến trúc tổng thể.

### **3. Xem Testbench**
Kiểm tra **[03_rtl_testbench.md](03_rtl_testbench.md)** để hiểu verification.

### **4. Thực Hành**
Làm theo **[cpu_flow.md](cpu_flow.md)** để giao tiếp với AES core.

### **5. Triển Khai ASIC**
Sử dụng **[04_openlane2_flow.md](04_openlane2_flow.md)** cho OpenLane2 flow.

## 🤝 Đóng Góp

Dự án này hoàn toàn mã nguồn mở và chào đón mọi đóng góp:
- 🐛 Báo cáo lỗi
- 💡 Đề xuất tính năng
- 📝 Cải thiện tài liệu
- 🔧 Tối ưu hóa code

## 📞 Liên Hệ

- **Repository**: [GitHub AES Project](https://github.com/your-username/aes)
- **Issues**: [GitHub Issues](https://github.com/your-username/aes/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/aes/discussions)

---

## 🔗 Navigation

### **📚 Tài Liệu Lý Thuyết**
- **[01_theory.md](01_theory.md)** - Lý thuyết AES và Caravel Platform
- **[06_references.md](06_references.md)** - Tài liệu tham khảo và nguồn

### **🏗️ Thiết Kế RTL**
- **[02_rtl_design.md](02_rtl_design.md)** - Kiến trúc RTL và luồng thực thi CPU
- **[rtl_aes.md](rtl_aes.md)** - Module chính AES (top-level)
- **[rtl_aes_core.md](rtl_aes_core.md)** - Module điều khiển trung tâm
- **[rtl_aes_key_mem.md](rtl_aes_key_mem.md)** - Module quản lý khóa
- **[rtl_aes_encipher_block.md](rtl_aes_encipher_block.md)** - Module mã hóa
- **[rtl_aes_decipher_block.md](rtl_aes_decipher_block.md)** - Module giải mã

### **🧪 Testbench và Verification**
- **[03_rtl_testbench.md](03_rtl_testbench.md)** - Tổng quan testbench và kết quả
- **[tb_aes.md](tb_aes.md)** - Testbench module chính AES
- **[tb_aes_core.md](tb_aes_core.md)** - Testbench module điều khiển
- **[tb_aes_key_mem.md](tb_aes_key_mem.md)** - Testbench module khóa
- **[tb_aes_encipher_block.md](tb_aes_encipher_block.md)** - Testbench module mã hóa
- **[tb_aes_decipher_block.md](tb_aes_decipher_block.md)** - Testbench module giải mã

### **🔧 Hướng Dẫn Thực Hành**
- **[cpu_flow.md](cpu_flow.md)** - Luồng thực thi CPU khi giao tiếp với AES core
- **[04_openlane2_flow.md](04_openlane2_flow.md)** - Quy trình OpenLane2 cho ASIC
- **[05_future_devs.md](05_future_devs.md)** - Hướng phát triển tương lai

---

*📝 Tài liệu được cập nhật lần cuối: Tháng 12/2024*
*🔧 Dự án: AES Accelerator trên Caravel Platform*
*🌟 Mã nguồn mở - Chào đón mọi đóng góp!*
