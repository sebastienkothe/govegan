# set IPHONEOS_DEPLOYMENT_TARGET for the pods project
  platform :ios, '10.0'

target 'govegan' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for govegan
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'

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
