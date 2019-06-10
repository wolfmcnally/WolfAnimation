Pod::Spec.new do |s|
    s.name             = 'WolfAnimation'
    s.version          = '3.0.4'
    s.summary          = 'Tools for Core Animation and time-sequencing events.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfAnimation'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfAnimation.git', :tag => s.version.to_s }

    s.swift_version = '5.1'

    s.ios.deployment_target = '12.0'
    s.ios.source_files = 'Sources/WolfAnimation/Shared/**/*', 'Sources/WolfAnimation/iOS/**/*', 'Sources/WolfAnimation/iOSShared/**/*', 'Sources/WolfAnimation/AppleShared/**/*'

    s.macos.deployment_target = '10.14'
    s.macos.source_files = 'Sources/WolfAnimation/Shared/**/*', 'Sources/WolfAnimation/macOS/**/*', 'Sources/WolfAnimation/AppleShared/**/*'

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = 'Sources/WolfAnimation/Shared/**/*', 'Sources/WolfAnimation/tvOS/**/*', 'Sources/WolfAnimation/iOSShared/**/*', 'Sources/WolfAnimation/AppleShared/**/*'

    s.module_name = 'WolfAnimation'

    s.dependency 'WolfLog'
    s.dependency 'WolfNIO'
    s.dependency 'WolfCore'
end
