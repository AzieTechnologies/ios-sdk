# Devpay iOS SDK
A iOS SDK for Devpay Payment Gateway Get your API Keys at https://devpay.io

## Integration
```Ruby
 pod 'DevpaySDK'
```

## Make payment
### Using inbuilt UI
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

### Set Custom Pay title
```swift
devPayVC.customPayBtnTitle = "PAY <AMOUNT> $"
```


### Using raw APIs
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
