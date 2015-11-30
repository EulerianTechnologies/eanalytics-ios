#
# Be sure to run `pod lib lint EAnalytics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EAnalytics"
  s.version          = "1.3.0"
  s.summary          = "iOS tracking library for Eulerian Technologies Analytics."

  # s.description      = <<-DESC
  #                     DESC

  s.homepage         = "https://bitbucket.org/euleriantechnologies/eanalytics-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'MIT' }
  s.author           = { "Eulerian Technologies" => "francois@eulerian.com" }
  s.source           = { :git => "git@bitbucket.org:euleriantechnologies/eanalytics-ios.git", :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'EAnalytics' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
