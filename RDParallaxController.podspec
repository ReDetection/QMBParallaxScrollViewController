Pod::Spec.new do |s|
  s.name         = "RDParallaxController"
  s.version      = "0.1"
  s.summary      = "Add a parallax top view to any UIScrollView with ease"

  s.homepage     = "http://redetection.github.io/RDParallaxController/"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "ReDetection" => "redetection@gmail.com" }

  s.source       = { :git => "https://github.com/ReDetection/RDParallaxController.git", :tag => "0.1" }
  s.source_files = "RDParallaxController/*.{h,m}"

  s.platform     = :ios, '6.0'
  s.requires_arc = true

end
