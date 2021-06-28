# PayerModule


## Hướng dẫn sử dụng module

Swift Package Manager: File -> Swift Package -> Add Package Dependency ...
~~~swift
https://github.com/absolutvodka8888/PayerModule.git
~~~

Import Module
~~~swift
import PayerModule
~~~

Cài đặt Module trong AppDelegate.swift :
~~~swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Payer.shared.config(listSubscription: ["com.yourcompany.test.premium.weekly",
                                           "com.yourcompany.test.premium.monthly",
                                           "com.yourcompany.test.premium.yearly"],
                        appleSharedSecretKey: "you secret key")
    Payer.shared.completeTransactions { _, _ in}
    return true
}
~~~
Thực thi lệnh mua hàng
~~~swift

func purchaseAProduct() {
    Payer.shared.purchase(product: "com.yourcompany.test.premium.weekly") { success, errorMsg in
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

