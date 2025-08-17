# Step 4 - Setup

1. Đầu tiên, bạn cần tạo 1 repo github từ template của Caravel, tích hợp sẵn bộ công cụ Openlane2 tại [Caravel project](https://github.com/efabless/caravel_user_project_ol2/generate).

2. Mở terminal, clone repo mới tạo về, ví dụ:
```sh
git clone https://github.com/truong92cdv/caravel_aes_accelerator.git ~/aes
```

3. File RTL thiết kế sẽ được đặt trong thư mục **~/aes/verilog/rtl/**. File **user_project_wrapper.v** là wrapper chứa thiêt kế của chúng ta. Bạn cần sửa lại đoạn code *user project is instantiated  here*. Tôi đã tạo sẵn, bạn hãy copy file về ghi đè file hiện có. Đồng thời copy các file thiết kế của **aes** về cùng thư mục.
```sh

```