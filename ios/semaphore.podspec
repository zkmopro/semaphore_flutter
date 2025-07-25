#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint semaphore.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'semaphore'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for mobile proving with Semaphore.'
  s.description      = <<-DESC
A Flutter plugin for Semaphore, enabling mobile proving with modern zero-knowledge proof systems.
                       DESC
  s.homepage         = 'https://zkmopro.org/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mopro' => 'hello@zkmopro.org' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'MoproiOSBindings/mopro.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.vendored_frameworks = 'MoproiOSBindings/MoproBindings.xcframework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64',
    'ONLY_ACTIVE_ARCH' => 'YES' 
  }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'semaphore_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
