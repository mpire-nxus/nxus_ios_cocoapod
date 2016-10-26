#
# Be sure to run `pod lib lint nxus_ios_cocoapod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'nxus_ios_cocoapod'
  s.version          = '1.0.6'
  s.summary          = 'Library for generating attribution events, while also enabling users to track events.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Automatically track attributions and log custom events. Support event parameteres.
                       DESC

  s.homepage         = 'https://github.com/mpire-nxus/nxus_ios_cocoapod'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TechMpire ltd.' => 'sdkdevelopment@mpiremedia.com.au' }
  s.source           = { :git => 'https://github.com/mpire-nxus/nxus_ios_cocoapod.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'NxusDSP/Classes/**/*'

end
