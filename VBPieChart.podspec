#
#  Be sure to run `pod spec lint VBPieChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "VBPieChart"
  s.version      = "1.2.0"
  s.summary      = "Pie Chart with different animations to present."

  s.description  = <<-DESC
                   Pie Chart iOS control with different animations to present.
                   Based on CAShapeLayer and CALayer, dependency to QuartzCore framework.
                   Can be created in few lines of code.

                   DESC

  s.homepage     = "https://github.com/sakrist/VBPieChart"
  s.screenshots  = "https://raw.githubusercontent.com/sakrist/VBPieChart/master/Screenshot.png"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "MIT", :file => "README.md" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #
  
  # s.author             = "Volodymyr Boichentsov"
  # Or just: s.author    = "Volodymyr Boichentsov"
  s.authors            = { "Volodymyr Boichentsov" => "sakristx@gmail.com" }
  s.social_media_url   = "http://twitter.com/sakrist"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "7.0"
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/sakrist/VBPieChart.git", :tag => "1.2.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "VBPieChart/Classes", "VBPieChart/Classes/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  s.public_header_files = "VBPieChart/Classes/VBPieChart.h"

  s.frameworks  = "UIKit", "QuartzCore"
  s.requires_arc = true

  
end
