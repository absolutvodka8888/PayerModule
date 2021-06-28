# PayerModule


## Hướng dẫn sử dụng module

Import Module
~~~swift
import PayerModule
~~~

Cài đặt Module trong AppDelegate.swift :
~~~swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Payer.shared.config(listSubscription: ["com.avenger.test.premium.weekly",
                                           "com.avenger.test.premium.monthly",
                                           "com.avenger.test.premium.yearly"],
                        appleSharedSecretKey: "you secret key")
    Payer.shared.completeTransactions { _, _ in}
    return true
}
~~~
Thực thi lệnh mua hàng
~~~swift

func purchaseAProduct() {
    Payer.shared.purchase(product: "com.avenger.test.premium.weekly") { success, errorMsg in
        if success {
            //TODO: Thực hiện lệnh khi thanh toán thành công
            // ví dụ: ẩn màn hình IAP
        } else {
            //TODO: Hiển thị message lỗi thanh toán
            
        }
    }
}

func restore() {
    Payer.shared.restore { success, errorMsg in
        if success {
            //TODO: Thực hiện lệnh khi thanh toán thành công
            // ví dụ: ẩn màn hình IAP
        } else {
            //TODO: Hiển thị message lỗi thanh toán
        }
    }
}

~~~

Hàm hỗ trợ kiểm tra trạng thái IAP
~~~swift
let status = Payer.shared.isPurchased
~~~

Copyright (c) <2021> <Dong Nguyen>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
