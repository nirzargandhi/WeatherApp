# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      # Workaround for Cocoapods issue #7606
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      # Another workaround for Cocoapods IBDesignable isssue
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end

def shared_pods
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  pod 'IQKeyboardManagerSwift', '~> 6.5.11'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'SDWebImage', '~> 5.15.8'
  pod 'Toast-Swift', '~> 5.0.1'

end

target 'WeatherApp-Dev' do
  shared_pods
end

target 'WeatherApp-Prod' do
  shared_pods
end
