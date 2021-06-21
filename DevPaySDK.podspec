Pod::Spec.new do |spec|
  spec.name         = 'DevPaySDK'
  spec.ios.deployment_target = '10.0'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/dev-pay/ios-sdk'
  spec.authors      = { 'Jnix Dev' => 'jnixdev@gmail.com' }
  spec.summary      = 'A iOS SDK for Devpay Payment Gateway Get your API Keys at https://devpay.io'
  spec.source       = { :git => 'https://github.com/dev-pay/ios-sdk.git', :tag => 'v1.0.0' }
  spec.source_files = 'DevPaySDK/DevPaySDK/*.{swift}'
  spec.resources    = 'DevPaySDK/DevPaySDK/*.{storyboard,png}'
  spec.dependency  'IQKeyboardManagerSwift'
end
