# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end

target 'driveBrowser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
    
  pod 'SDWebImage'
  pod 'GoogleAPIClientForREST/Drive', '~> 1.2.1'
  pod 'GoogleSignIn'
end
