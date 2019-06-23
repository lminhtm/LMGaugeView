Pod::Spec.new do |s|

  s.name             = "LMGaugeView"
  s.version          = "1.0.4"
  s.summary          = "LMGaugeView is a simple and customizable gauge control for iOS."
  s.homepage         = "https://github.com/lminhtm/LMGaugeView"
  s.license          = 'MIT'
  s.author           = { "LMinh" => "lminhtm@gmail.com" }
  s.source           = { :git => "https://github.com/lminhtm/LMGaugeView.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'LMGaugeView/**/*.{h,m}'

end
