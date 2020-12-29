require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-cctvpoc"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-cctvpoc
                   DESC
  s.homepage     = "https://github.com/nat-rojsawang/react-native-cctvpoc"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Forviz" => "nat@forviz.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/nat-rojsawang/react-native-cctvpoc.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.resource_bundles = {
    'CCTVPOC' => ["ios/**/*.{storyboard,xib,xcassets}"]
  }
  s.frameworks = 'UIKit'
  s.requires_arc = true

  s.dependency "React"
  s.dependency "EZOpenSDK"
  # ...
  # s.dependency "..."
end

