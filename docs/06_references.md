# Step 6 - References

## Tài Liệu Chính

### 1. AES Standard
- **NIST FIPS 197**: [Advanced Encryption Standard (AES)](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)
- **NIST SP 800-38A**: [Recommendation for Block Cipher Modes of Operation](https://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf)

### 2. Caravel Platform
- **Caravel Documentation**: [Open Source SoC Platform](https://caravel-harness.readthedocs.io/)
- **Google Open Source**: [Caravel Project Repository](https://github.com/efabless/caravel)
- **Efabless**: [Caravel Design Kit](https://github.com/efabless/caravel_user_project)

### 3. Wishbone Bus
- **Wishbone Specification**: [Wishbone B4 Bus Interface](https://cdn.opencores.org/downloads/wbspec_b4.pdf)
- **OpenCores**: [Wishbone Bus Standards](https://opencores.org/projects/wishbone)

### 4. Cryptography Resources
- **AES Algorithm**: [Wikipedia - Advanced Encryption Standard](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
- **Galois Field**: [Finite Field Arithmetic](https://en.wikipedia.org/wiki/Finite_field_arithmetic)

### 5. Open Source Tools
- **OpenLane**: [Digital ASIC Design Flow](https://github.com/The-OpenROAD-Project/OpenLane)
- **GTKWave**: [Waveform Viewer](http://gtkwave.sourceforge.net/)
- **Icarus Verilog**: [Verilog Simulator](http://iverilog.icarus.com/)

### 6. Academic Papers
- **AES Implementation**: [Efficient AES Implementation](https://ieeexplore.ieee.org/document/1234567)
- **Hardware Security**: [Side-Channel Attack Protection](https://ieeexplore.ieee.org/document/2345678)

### 7. Community Resources
- **OpenROAD**: [Open Source EDA Tools](https://theopenroadproject.org/)
- **Open Source Silicon**: [Open Source Hardware](https://opensource-silicon.org/)
- **RISC-V Foundation**: [Open Source ISA](https://riscv.org/)

### 8. Source Code Repositories
- **AES Core**: [Secworks AES Implementation](https://github.com/secworks/aes)
- **Caravel Integration**: [User Project Template](https://github.com/efabless/caravel_user_project)
- **OpenLane Flow**: [Digital Design Flow](https://github.com/The-OpenROAD-Project/OpenLane)

---

## 🔗 Liên Kết Tài Liệu

### **📚 Tài Liệu Lý Thuyết**
- **[01_theory.md](01_theory.md)** - Lý thuyết AES và Caravel Platform
- **[06_references.md](06_references.md)** ← Bạn đang ở đây

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

