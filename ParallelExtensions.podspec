Pod::Spec.new do |s|

  s.name         = "ParallelExtensions"
  s.version      = "0.2.0"
  s.summary      = "Parallelize your high-order funtions, like map, filter, find like a boss."

  s.description  = <<-DESC
                   Parallelize your high-order funtions, like map, filter, find like a boss.
                   DESC

  s.homepage     = "https://github.com/itchingpixels/ParallelExtensions"

  s.license      = { :type => "MIT", :file => "LICENCE" }

  s.author             = { "Mark Szulyovszky" => "mark.szulyovszky@gmail.com" }
  s.social_media_url   = "http://twitter.com/itchingpixels"

  s.source       = { :git => "https://github.com/itchingpixels/ParallelExtensions.git", :tag => s.version }
  s.source_files = 'Framework/ParallelExtensions/*'
  s.exclude_files = "Example/*"
  s.ios.deployment_target = '8.0'
end
