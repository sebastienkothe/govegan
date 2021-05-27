# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'govegan' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for govegan
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

  # Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'

  target 'goveganTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('8.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end
end
