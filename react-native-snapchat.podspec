require 'json'
package_json = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

   s.name           = "react-native-snapchat"
   s.version        = package_json["version"]
   s.summary        = package_json["description"]
   s.homepage       = "https://github.com/felinellc/react-native-snapchat"
   s.license        = package_json["license"]
   s.author         = { package_json["author"] => package_json["author"] }
   s.platform       = :ios, "8.0"
   s.source         = { :git => "#{package_json["repository"]["url"]}" }
   s.source_files   = 'ios/*.{h,m,swift}'
   s.dependency 'React'
   s.dependency 'SnapSDK'

end