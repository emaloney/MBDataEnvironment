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
    s.version               = "1.0.5"
    s.summary               = "Mockingbird Data Environment"
    s.description           = "Provides a flexible runtime mechanism for manipulating arbitrary data structures and extracting values therefrom."
    s.homepage              = "https://github.com/emaloney/MBDataEnvironment"
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { "Evan Coyne Maloney" => "emaloney@gilt.com" }
    s.platform              = :ios, '8.0'
    s.ios.deployment_target = '7.0'
    s.requires_arc          = true

    s.source = {
        :git => 'https://github.com/emaloney/MBDataEnvironment.git',
        :tag => s.version.to_s
    }

    s.xcconfig              = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

	s.default_subspec       = 'Core'

    #################################################################
    #
    # MOCKINGBIRD DATA ENVIRONMENT CORE
    #
    #################################################################

    s.subspec 'Core' do |ss|
        ss.source_files            = 'Code/**/*.{h,m}'
        ss.public_header_files     = 'Code/**/*.h'
        ss.private_header_files    = 'Code/ExpressionEngine/Private/**/*.h'
        ss.resource_bundle         = { 'MBDataEnvironment' => 'Resources/*.xml' }
    end

    #################################################################
    #
    # UNIT TEST SUBSPEC
    #
    #################################################################

    s.subspec 'UnitTests' do |ss|
    	ss.dependency 'MBDataEnvironment/Core'
        ss.source_files            = 'Tests/**/*.{h,m}'
        ss.public_header_files     = 'Tests/**/*.h'
        ss.resource_bundle         = { 'MBDataEnvironmentTests' => 'Tests/Resources/*.xml' }
        ss.framework               = 'XCTest'
    end

    #----------------------------------------------------------------
    # Dependencies
    #----------------------------------------------------------------

    s.dependency 'MBToolbox', '~> 1.0.21'
    s.dependency 'RaptureXML@Gilt', '~> 1.0.3'

end
