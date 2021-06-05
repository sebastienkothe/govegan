platform :ios, '10.0'

target 'govegan' do

  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'

  # Facebook 
  pod 'FBSDKLoginKit'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'

  target 'goveganTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end
