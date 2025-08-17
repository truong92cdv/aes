# Step 4 - Setup

0. Cai dat **Nix** va **Openlane2**

1. Tạo 1 repo github từ template của Caravel, tích hợp sẵn bộ công cụ Openlane2 tại [Caravel project](https://github.com/efabless/caravel_user_project_ol2/generate).

2. Mở terminal, clone repo mới tạo về, ví dụ:
```sh
git clone https://github.com/truong92cdv/caravel_aes_accelerator.git ~/aes
```

3. File RTL thiết kế sẽ được đặt trong thư mục **~/aes/verilog/rtl/**. File **user_project_wrapper.v** là wrapper chứa thiết kế của chúng ta. Bạn cần sửa lại đoạn code *user project is instantiated  here*. Đồng thời copy các file thiết kế của **aes** về cùng thư mục. Bạn có thể copy thủ công hoặc dùng scipt download tôi đã tạo sẵn:
```sh
curl -s https://raw.githubusercontent.com/truong92cdv/aes/refs/heads/main/script/download.sh ~/download.sh
chmod +x ~/download.sh
~/download.sh https://github.com/truong92cdv/aes/rtl ~/aes/verilog/rtl
```

4. Tao macro AES Wishbone Wrapper voi Openlane
```sh
mkdir -p ~/aes/openlane/aes_wb_wrapper
```

5. Tao file **~/aes/openlane/aes_wb_wrapper/config.json** va cau hinh nhu sau:
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

6. Khoi chay Openlane2 trong moi truong nix-shell, thay doi duong dan theo vi tri cai dat openlane2 cua ban.
```sh
nix-shell --pure ~/openlane2/shell.nix
```

7. Chay flow thiet ke voi Openlane2 . Hay dam bao ban dang trong moi truong nix-shell (cmd-line hien thi **[nix-shell:~]$ **)
```sh
[nix-shell:~]$ openlane ~/aes/openlane/aes_wb_wrapper/config.json
```
Doi flow chay hoan tat, khoang 20 phut :(


8. Mo KLayout xem ket qua
```sh
[nix-shell:~]$ openlane --last-run --flow openinklayout ~/aes/openlane/aes_wb_wrapper/config.json
```

![4_klayout_1](images/4_klayout_1.png)

9. Kểm tra kết qủa timing