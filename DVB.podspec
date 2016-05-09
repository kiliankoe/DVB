#
# Be sure to run `pod lib lint DVB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DVB"
  s.version          = "0.4.0"
  s.summary          = "Query Dresden's public transport system for current bus- and tramstop data in Swift."
  s.description      = <<-DESC
This is an unofficial Swift package, giving you a few options to query Dresden's public transport system for current bus- and tramstop data.
                       DESC
  s.homepage         = "https://github.com/kiliankoe/DVB"
  s.license          = 'MIT'
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.source           = { :git => "https://github.com/kiliankoe/DVB.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kiliankoe'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'DVB/Classes/**/*'
end
