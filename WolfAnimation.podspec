Pod::Spec.new do |s|
    s.name             = 'WolfAnimation'
    s.version          = '3.0.1'
    s.summary          = 'Tools for Core Animation and time-sequencing events.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfAnimation'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfAnimation.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.ios.deployment_target = '12.0'
    s.ios.source_files = 'WolfAnimation/Classes/Shared/**/*', 'WolfAnimation/Classes/iOS/**/*', 'WolfAnimation/Classes/iOSShared/**/*', 'WolfAnimation/Classes/AppleShared/**/*'

    s.macos.deployment_target = '10.14'
    s.macos.source_files = 'WolfAnimation/Classes/Shared/**/*', 'WolfAnimation/Classes/macOS/**/*', 'WolfAnimation/Classes/AppleShared/**/*'

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = 'WolfAnimation/Classes/Shared/**/*', 'WolfAnimation/Classes/tvOS/**/*', 'WolfAnimation/Classes/iOSShared/**/*', 'WolfAnimation/Classes/AppleShared/**/*'

    s.module_name = 'WolfAnimation'

    s.dependency 'WolfLog'
    s.dependency 'WolfFoundation'
    s.dependency 'WolfNIO'
    s.dependency 'WolfConcurrency'
end
