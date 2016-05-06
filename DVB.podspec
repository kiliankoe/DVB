#
# Be sure to run `pod lib lint DVB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DVB"
  s.version          = "0.1.0"
  s.summary          = "Query Dresden's public transport system for current bus- and tramstop data in Swift."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is an unofficial Swift package, giving you a few options to query Dresden's public transport system for current bus- and tramstop data.
                       DESC

  s.homepage         = "https://github.com/kiliankoe/DVB"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.source           = { :git => "https://github.com/kiliankoe/DVB.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DVB/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DVB' => ['DVB/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
