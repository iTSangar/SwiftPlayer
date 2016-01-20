Pod::Spec.new do |s|
  s.name             = 'SwiftPlayer'
  s.version          = '0.2.0'
  s.summary          = 'Swift stream music player, on top of HysteriaPlayer'
  s.description      = <<-DESC
This CocoaPod provides the ability to use a stream player using swift language over an abstraction of HysteriaPlayer framework.
                       DESC

  s.homepage         = 'https://github.com/iTSangarDEV/SwiftPlayer'
  s.license          = 'MIT'
  s.author           = { 'iTSangar' => 'itsangardev@gmail.com' }
  s.source           = { :git => 'https://github.com/iTSangarDEV/SwiftPlayer.git', :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*'

  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'HysteriaPlayer', '~> 2.1'
end
