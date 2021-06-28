# PayerModule


## Hướng dẫn sử dụng module

Bước 1:  AppDelegate.swift :
~~~swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Payer.shared.config(listSubscription: ["com.avenger.test.premium.weekly",
                                           "com.avenger.test.premium.monthly",
                                           "com.avenger.test.premium.yearly"],
                        appleSharedSecretKey: "you secret key")
    return true
}
~~~
Bước 2:
