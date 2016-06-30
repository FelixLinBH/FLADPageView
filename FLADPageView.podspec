#
# Be sure to run `pod lib lint FLADPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FLADPageView'
  s.version          = '1.0.1'
  s.summary          = 'Carousel ad scrollview'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
      Carousel AD view support auto-scroll,fetch image from url,support jpg/gif/png.
                       DESC

  s.homepage         = 'https://github.com/FelixLinBH/FLADPageView'
  # s.screenshots     = 'https://github.com/FelixLinBH/FLADPageView/blob/master/1.gif?raw=true', 'https://github.com/FelixLinBH/FLADPageView/blob/master/2.gif?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Felix' => 'fly_81211@hotmail.com' }
  s.source           = { :git => 'https://github.com/FelixLinBH/FLADPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FLADPageView/Classes/**/*'
  
  s.resource_bundles = {
    'FLADPageView' => ['FLADPageView/Assets/*.png','FLADPageView/Assets/*.jpg']
  }

  s.public_header_files = 'FLADPageView/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Masonry'
  s.dependency 'DFImageManager'
  s.dependency 'DFImageManager/AFNetworking'
  s.dependency 'DFImageManager/GIF'
end
