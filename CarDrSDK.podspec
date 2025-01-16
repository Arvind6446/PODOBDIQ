Pod::Spec.new do |spec|

  # Metadata
  spec.name         = "CarDrSDK"
  spec.version      = "0.0.1"
  spec.summary      = "For Scan Cars."
  spec.description  = <<-DESC
    CarDr.com is an automotive technology company providing industry-leading 
    software services for vehicle diagnostics, appraisal, and inspections.
  DESC
  spec.homepage     = "http://example.com/CarDrSDK"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Arvind_Cardr" => "arvind@cardr.com" }
  spec.platform     = :ios, "10.0"

  # Source location
  spec.source       = { 
    :git => "https://github.com/CarDr-com/CarDr-iOS-OBDScan-SDK.git",
    :tag => "0.0.2"
  }

  # Source files and resources
  spec.source_files = "CarDrSDK/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"
  spec.vendored_frameworks = "CarDrSDK/VoyoAPI.framework"

  # Build settings
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => "$(PODS_ROOT)/CarDrSDK/CarDrSDK",
    'HEADER_SEARCH_PATHS' => "$(PODS_ROOT)/Headers/Public"
  }

  # Dependencies
  spec.dependency "Alamofire", "~> 5.6.4"
  spec.dependency "SwiftyJSON", "~> 5.0.1"
  spec.dependency "RepairClubSDK", :git => "https://github.com/RRCummins/OBD2Interface.git"

end
