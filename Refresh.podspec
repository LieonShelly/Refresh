
Pod::Spec.new do |s|

  s.name         = "Refresh"
  s.version      = "0.0.1"
  s.summary      = "Refresh."
  s.description  = <<-DESC
  					RefreshRefreshRefreshRefreshRefreshRefresh
                   DESC

  s.homepage     = "https://github.com/lieonCX/Refresh"
  s.license      = 'MIT'

  s.author             = { "lieon" => "lieonCX@163.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/lieonCX/Refresh.git", :tag => s.version }

  s.source_files  = 'Source'
  s.resources = 'Source/*.xib'
  s.framework  = 'UIKit'
  s.requires_arc = true

end
