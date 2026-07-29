# Uncomment the next line to define a global platform for your project
platform :ios, '16.4'

target 'ViaCep' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ViaCep
    
  target 'ViaCepTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_MODULE_VERIFIER'] = 'NO'
      if Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] || '0') < Gem::Version.new('16.4')
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.4'
      end
    end
  end
end
