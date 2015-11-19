Pod::Spec.new do |s|

  s.name         = "ConcurrentMap"
  s.version      = "0.1"
  s.summary      = "Map (high-order function) on multiple threads"

  s.description  = <<-DESC
                   We all love Array.map in Swift. Now you can speed it up by using multiple threads. Like boss.
                   DESC

  s.homepage     = "https://github.com/itchingpixels/ConcurrentMap"

  s.license      = { :type => "MIT", :file => "LICENCE" }

  s.author             = { "Mark Szulyovszky" => "mark.szulyovszky@gmail.com" }
  s.social_media_url   = "http://twitter.com/itchingpixels"

  s.source       = { :git => "https://github.com/itchingpixels/ConcurrentMap.git", :tag => s.version }
  s.source_files = 'ConcurrentMap/*'
  s.exclude_files = "Example/*"
  s.ios.deployment_target = '8.0'
end