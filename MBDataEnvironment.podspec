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
	s.version               = "0.9.0"
	s.summary               = "Mockingbird Data Environment: Provides a flexible runtime mechanism for manipulating arbitrary data structures and extracting values therefrom."
	s.homepage         	    = "https://github.com/gilt/MBDataEnvironment"
	s.license               = { :type => 'MIT', :file => 'LICENSE' }
	s.author                = { "Evan Coyne Maloney" => "emaloney@gilt.com" }
	s.platform              = :ios, '8.0'
	s.ios.deployment_target = '7.0'
	s.requires_arc          = true

	s.source = {
		:git => 'https://github.com/gilt/MBDataEnvironment.git',
		:tag => s.version.to_s
	}

	s.source_files			= 'Code/**/*.{h,m}'
	s.public_header_files	= 'Code/**/*.h'
	s.private_header_files	= 'Code/ExpressionEngine/Private/**/*.h'

	#----------------------------------------------------------------
	# Dependencies
	#----------------------------------------------------------------

	s.dependency = 'MBToolbox', '~> 1.0'	
	
	# Include the latest (as of this writing) RaptureXML library.
	# We have to specify master because the published podspec is
	# does not include the latest changes. We're also locking to
	# a specific commit to ensure we don't break in the future.
	s.dependency = 'RaptureXML',
						:git => 'https://github.com/ZaBlanc/RaptureXML.git',
						:branch => 'master',
						:commit => '76b59ec0abf68c06d27cc027d7750b6a4da08650'

end
