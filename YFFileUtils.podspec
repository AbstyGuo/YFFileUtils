Pod::Spec.new do |s|

  s.name         = "YFFileUtils"
  s.version      = "0.1.0"
  s.summary      = "YFFileUtils."

  s.description  = <<-DESC
                    this is YFFileUtils
                   DESC

  s.homepage     = "https://github.com/AbstyGuo/YFFileUtils"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "absty_guo"

  s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "git@github.com:AbstyGuo/YFFileUtils.git", :tag => s.version.to_s }

  s.source_files  = "util/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  s.public_header_files = "util/**/*.h"

  s.requires_arc = true

  s.dependency 'SSZipArchive'

end
