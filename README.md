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
Bước 2:  Thực thi lệnh mua hàng
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
