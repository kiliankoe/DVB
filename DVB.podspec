Pod::Spec.new do |s|
  s.name             = "DVB"
  s.version          = "1.0.0"
  s.summary          = "Query Dresden's public transport system for current bus- and tramstop data in Swift."
  s.description      = <<-DESC
Query Dresden's public transport system for current bus- and tramstop data
                       DESC
  s.homepage         = "https://github.com/kiliankoe/DVB"
  s.license          = 'MIT'
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.source           = { :git => "https://github.com/kiliankoe/DVB.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kiliankoe'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'DVB/Classes/**/*'

  s.resources = ['DVB/Assets/VVOStops.plist']
end
