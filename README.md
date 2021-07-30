# Devpay iOS SDK
A iOS SDK for Devpay Payment Gateway Get your API Keys at https://devpay.io

## Integration
```Ruby
  pod 'DevpaySDK',:podspec=>'https://github.com/dev-pay/ios-sdk/releases/download/1.0.0/DevpaySDK.podspec'
```

## Make payment
### Using inbuilt UI
#### Showing the payment UI
Devpay SDK provided handy UI to get payment inputs, please refer below code.
```swift
let config = Config(accountId: "ACC_ID",
                    shareableKey: "SHAREABLE_KEY",
                    accessKey: "ACCESS_KEY",
                    sandbox: true)

let payClient = DevpayClient(config: config)

let devPayVC = DevpayPaymentVC.instance()
let amountNumber = <AMOUNT>
devPayVC.amount = Int(amountNumber ?? "")
devPayVC.currency = .USD

devPayVC.onPayAction = { pd in
    
    // Set optional meta data
    pd.metaData = ["client":"dev-pay ios sdk"]

    // Initiate payment confirmation
    payClient.confirmPayment(details: pd) { intent, err in
        
        if err != nil {
            print("Error \(String(describing: err))")
        }else {
            print("Payment successful \(String(describing: intent))")
        }
    }
}
```

### Dissmissing the UI
Devpay UI controller provides closeAction block which triggers when use press `cancel` button. Based on you presentation you can dissmiss or pop the view controller
```
devPayVC.closeAction = {
    // Dissmiss/pop view controller
}
```

> Amount & Currency are mandatory inputs, please make sure its provided correctly

#### Set Custom Pay title
By default inbuilt UI shows pay button text as 'PAY', you can change the text as required. Below snippets gives an example to do so. 
```swift
devPayVC.customPayBtnTitle = "PAY <AMOUNT> $"
```


### Using Devpay APIs with your own UI
In-case you want to use own UI to get payment details from the user, you are free to do so. Use below APIs to create payment details form your custom UI & confirm the payment.
```swift
let config = Config(accountId: "ACC_ID",
                    shareableKey: "SHAREABLE_KEY",
                    accessKey: "ACCESS_KEY",
                    sandbox: true)
let payClient = DevpayClient(config: config)

let card = Card(cardNum: "XXXXYYYYXXXXYYYY",
                expiryMonth: "MM",
                expiryYear: "YYYY",
                cvv: "123")

let billingAddr = BillingAddress("STREET",
                                city: "CITY",
                                zip: "ZIP",
                                state: "STATE",
                                country: "COUNTRY")

let pd = PaymentDetail(amount: <amount>,
                        currency: <currency>,
                        name: <name>,
                        card: card,
                        billingAddress: billingAddr)

payClient.confirmPayment(details: pd) { intent, err in
    
    if err != nil {
        print("Error \(String(describing: err))")
    }else {
        print("Payment successful \(String(describing: intent))")
    }
}

```
