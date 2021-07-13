Pod::Spec.new do |spec|
  spec.name         = 'DevpaySDK'
  spec.ios.deployment_target = '10.0'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/dev-pay/ios-sdk'
  spec.authors      = { 'devpay-dev' => 'dev@devpay.io' }
  spec.summary      = 'A iOS SDK for Devpay Payment Gateway Get your API Keys at https://devpay.io'
  spec.source       = { :git => 'https://github.com/dev-pay/ios-sdk.git', :tag => '1.0.0' }
  spec.source_files = 'DevpaySDK/DevpaySDK/*.{swift}'
  spec.resources    = 'DevpaySDK/DevpaySDK/*.{storyboard,png}'
  spec.dependency  'IQKeyboardManagerSwift'
end
