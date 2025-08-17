# Step 4 - Setup

## 1. Cài đặt **Nix** và **Openlane2**

## 2. Tạo project từ Caravel template

Tạo 1 repo github từ template của Caravel, tích hợp sẵn bộ công cụ Openlane2 tại [Caravel project](https://github.com/efabless/caravel_user_project_ol2/generate).

Mở terminal, clone repo mới tạo về, ví dụ:
```sh
git clone https://github.com/truong92cdv/caravel_aes_accelerator.git ~/aes
```

## 3. Chuẩn bị file RTL

File RTL thiết kế sẽ được đặt trong thư mục **~/aes/verilog/rtl/**. File **user_project_wrapper.v** là wrapper chứa thiết kế của chúng ta. Bạn cần sửa lại đoạn code *user project is instantiated  here*. Đồng thời copy các file thiết kế của **aes** về cùng thư mục. Bạn có thể copy thủ công hoặc dùng script download tôi đã tạo sẵn:
```sh
curl -s https://raw.githubusercontent.com/truong92cdv/aes/refs/heads/main/script/download.sh ~/download.sh
chmod +x ~/download.sh
~/download.sh https://github.com/truong92cdv/aes/rtl ~/aes/verilog/rtl
```

## 4. Tạo macro AES Wishbone Wrapper với Openlane

Tạo thư mục chứa AES wishbone wrapper
```sh
mkdir -p ~/aes/openlane/aes_wb_wrapper
```

Tạo file **~/aes/openlane/aes_wb_wrapper/config.json** và cấu hình như sau:
```json
{
    "DESIGN_NAME": "aes_wb_wrapper",
    "FP_PDN_MULTILAYER": false,
    "CLOCK_PORT": "wb_clk_i",
    "CLOCK_PERIOD": 25,
    "VERILOG_FILES": [
        "dir::../../verilog/rtl/aes.v",
        "dir::../../verilog/rtl/aes_core.v",
        "dir::../../verilog/rtl/aes_decipher_block.v",
        "dir::../../verilog/rtl/aes_encipher_block.v",
        "dir::../../verilog/rtl/aes_inv_sbox.v",
        "dir::../../verilog/rtl/aes_key_mem.v",
        "dir::../../verilog/rtl/aes_sbox.v",
        "dir::../../verilog/rtl/aes_wb_wrapper.v"
    ],
    "FP_CORE_UTIL": 40
}
```

## 5. Chạy Openlane2 flow cho Macro AES Wishbone Wrapper

Khởi chạy Openlane2 trong môi trường nix-shell, thay đổi đường dẫn theo vị trí cài đặt openlane2 của bạn.
```sh
nix-shell --pure ~/openlane2/shell.nix
```

Chạy flow thiết kế với Openlane2. Hãy đảm bảo bạn đang trong môi trường **nix-shell**
```sh
[nix-shell:~]$ openlane ~/aes/openlane/aes_wb_wrapper/config.json
```
Đợi flow chạy hoàn tất, khoảng 20 phút :(

Mở KLayout xem kết quả

```sh
[nix-shell:~]$ openlane --last-run --flow openinklayout ~/aes/openlane/aes_wb_wrapper/config.json
```

![4_klayout_1](images/4_klayout_1.png)

## 6. Kiểm tra kết quả timing