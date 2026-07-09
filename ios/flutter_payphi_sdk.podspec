Pod::Spec.new do |s|
  s.name             = 'flutter_payphi_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter bridge to the PayPhi Customer iOS SDK.'
  s.description      = <<-DESC
A Flutter plugin that wraps the PayPhi iOS Customer SDK (customersdk.framework).
DESC
  s.homepage         = 'https://payphi.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'PayPhi' => 'appdeveloper@phicommerce.com' }
  s.source           = { :path => '.' }

  s.platform         = :ios, '12.0'
  s.swift_version    = '5.0'
  
  # Swift/ObjC stub files for the Flutter plugin registrar
  s.source_files     = 'Classes/**/*.{h,m,swift}'
  s.public_header_files = 'Classes/**/*.h'

  # Your packaged iOS SDK framework
  s.vendored_frameworks = 'Frameworks/customersdk.framework'

  # Include any images/json/etc your framework expects to load by name
  s.resources = ['Resources/**/*']

  s.dependency 'Flutter'

  # If the customersdk.framework is built as a static XCFramework and you
  # see duplicate symbol or linking issues, uncomment:
  # s.static_framework = true
end
