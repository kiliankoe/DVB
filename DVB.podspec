Pod::Spec.new do |s|
  s.name             = "DVB"
  s.version          = "1.1.0"
  s.summary          = "Query Dresden's public transport system for current bus- and tramstop data in Swift."
  s.description      = "This is an unofficial Swift package, giving you a few options to query Dresden's public transport system for current bus- and tramstop data."
  s.homepage         = "https://github.com/kiliankoe/DVB"
  s.license          = 'MIT'
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.source           = { :git => "https://github.com/kiliankoe/DVB.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kiliankoe'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.dependency 'Kanna', '~> 2.0'
  s.dependency 'STRegex', '~> 0.4'

  s.source_files = 'Sources/**/*.swift'

  s.resources = ['Sources/Assets/VVOStops.plist']
end
