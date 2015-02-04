#####################################################################
#
# Mockingbird Data Environment -- CocoaPod Specification
#
# Created by Evan Coyne Maloney on 9/29/14.
# Copyright (c) 2014 Gilt Groupe. All rights reserved.
#
#####################################################################

Pod::Spec.new do |s|

	s.name                  = "MBDataEnvironment"
	s.version               = "1.0.0"
	s.summary               = "Mockingbird Data Environment"
	s.description		= "Provides a flexible runtime mechanism for manipulating arbitrary data structures and extracting values therefrom."
	s.homepage		= "https://github.com/emaloney/MBDataEnvironment"
	s.license               = { :type => 'MIT', :file => 'LICENSE' }
	s.author                = { "Evan Coyne Maloney" => "emaloney@gilt.com" }
	s.platform              = :ios, '8.0'
	s.ios.deployment_target = '7.0'
	s.requires_arc          = true

	s.source = {
		:git => 'https://github.com/emaloney/MBDataEnvironment.git',
		:tag => s.version.to_s
	}

	s.source_files		= 'Code/**/*.{h,m}'
	s.public_header_files	= 'Code/**/*.h'
	s.private_header_files	= 'Code/ExpressionEngine/Private/**/*.h'

	s.resource_bundle	= { 'MBDataEnvironment' => 'Resources/*.xml' }

	s.xcconfig		= { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

	#----------------------------------------------------------------
	# Dependencies
	#----------------------------------------------------------------

	s.dependency 'MBToolbox', '~> 1.0.21'
	s.dependency 'RaptureXML@Gilt', '~> 1.0.3'

end
