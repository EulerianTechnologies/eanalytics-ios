#
# Be sure to run `pod lib lint EAnalytics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EAnalytics"
  s.version          = "1.5.0"
  s.summary          = "iOS tracking library for Eulerian Technologies Analytics."

  # s.description      = <<-DESC
  #                     DESC

  s.homepage         = "https://github.com/EulerianTechnologies/eanalytics-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'MIT' }
  s.author           = { "Eulerian Technologies" => "francois@eulerian.com" }
  s.source           = { :git => "https://github.com/EulerianTechnologies/eanalytics-ios.git", :tag => s.version }
  
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.resource_bundles = { 'EAnalaytics' => ['Pod/Classes/*.xcprivacy'] }

  # Exclude this file that is required for SPM
  s.exclude_files = 'Pod/Classes/include/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
end
