# PayerModule


## Hướng dẫn sử dụng module

Swift Package Manager: File -> Swift Package -> Add Package Dependency ...
~~~swift
dependencies: [
    .package(url: "https://github.com/absolutvodka8888/PayerModule.git", .upToNextMajor(from: "0.0.1"))
]
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

Tải giá từ server về *Vui lòng chạy trên máy thật và add sandbox tester*
~~~swift
func getProductsInfo() {
    Payer.shared.getInfoSubscriptions { products in
        products.forEach { skProduct in
            if skProduct.productIdentifier == "com.yourcompany.premium.weekly" {
                let price = skProduct.localizedPrice ?? "Weekly $9.99 per week"
                self.btnWeekly.setTitle(price, for: .normal)
            }
            
            if skProduct.productIdentifier == "com.yourcompany.premium.monthly" {
                let price = skProduct.localizedPrice ?? "Weekly $9.99 per week"
                self.btnMonthly.setTitle(price, for: .normal)
            }
            
            if skProduct.productIdentifier == "com.yourcompany.premium.yearly" {
                let price = skProduct.localizedPrice ?? "Weekly $9.99 per week"
                self.btnYearly.setTitle(price, for: .normal)
            }
        }
    }
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

