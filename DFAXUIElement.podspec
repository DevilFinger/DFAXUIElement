#
#  Be sure to run `pod spec lint DFAXUIElement.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "DFAXUIElement"
  spec.version      = "1.0.2"
  spec.author       = { "raymondchans" => "raymondchans@live.cn" }
  spec.homepage     = "https://github.com/DevilFinger/DFAXUIElement"
  spec.summary      = "A fastway to use Accessibility API in MacOS with AXUIElement with Swift"
  spec.source       = { :git => "https://github.com/DevilFinger/DFAXUIElement.git", :tag => "#{spec.version}" }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.platform              = :osx
  spec.osx.deployment_target = '10.11'
  spec.source_files  = 'Classes/**/*.{h,m,swift}'
  spec.public_header_files = 'Classes/*.h'
  spec.swift_versions = '4.0'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end


