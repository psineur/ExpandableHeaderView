
Pod::Spec.new do |s|
  s.name             = 'SUPHeaderView'
  s.version          = '1.0.2'
  s.summary          = 'Twitter - like Profile Header view for UITableView that stretches and collapses.'
  s.description      = <<-DESC
MEExpandableHeaderView without pages & with alternative collapsed mode content.
Almost completely redone fork of https://github.com/microeditionbiz/ExpandableHeaderView

SUPHeaderView's goal is to provide a nice header for User Profile with Media/Content presented
in UITableView. It reproduces the behaviour that you can find on Twitter app, 
profile section, when the user scrolls down that section and the header is expanded and blurred.
                       DESC

  s.homepage         = 'https://github.com/psineur/SUPHeaderView'
  s.screenshots     = 'https://user-images.githubusercontent.com/507338/28749792-4db37b22-7490-11e7-842d-f88ad677835e.PNG', 'https://user-images.githubusercontent.com/507338/28749791-4be2f462-7490-11e7-91b1-170701498ef1.PNG', 'https://user-images.githubusercontent.com/507338/28749790-49b5d7c2-7490-11e7-9655-8e6d27a25bbc.PNG'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Stepan Generalov' => 'psi.pk.ru@gmail.com', 'Pablo Ezequiel Romero' => 'developer@microedition.biz' }
  s.source           = { :git => 'https://github.com/psineur/SUPHeaderView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'SUPHeaderView/**/*'
  s.public_header_files = 'SUPHeaderView/**/*.h'
  s.frameworks = 'UIKit', 'Accelerate'
end
