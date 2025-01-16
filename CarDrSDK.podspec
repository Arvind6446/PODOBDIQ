Pod::Spec.new do |spec|

  # Metadata
  spec.name         = "CarDrSDK"
  spec.version      = "0.0.1"
  spec.summary      = "A library for scanning cars."
  spec.homepage     = "https://github.com/Arvind6446/PODOBDIQ"

  spec.author       = { "Arvind_Cardr" => "arvind@cardr.com" }
 
  spec.description  = <<-DESC
                      RepairClubSDK is a private framework providing core functionality
                      for RC devices, including communication and processing features.
                      DESC

  spec.license      = { :type => 'Proprietary', :text => 'All rights reserved.' }
  spec.source       = { :git => 'https://github.com/Arvind6446/PODOBDIQ.git', :tag => spec.version }

  # Define platform
  spec.platform     = :ios, '16.1'


  # Specify the XCFramework
  spec.vendored_frameworks = 'RepairClubSDK.xcframework'

  # Source files
  spec.source_files = "CarDrSDK/**/*.{h,m,swift}"

  spec.swift_version = '5.0'
  spec.framework     = 'CoreBluetooth'
  spec.libraries     = 'z', 'c++'

  # Dependencies
  spec.dependency "Alamofire", "~> 5.6.4"
  spec.dependency "SwiftyJSON", "~> 5.0.1"

end
