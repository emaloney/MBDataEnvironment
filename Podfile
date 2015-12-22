source 'https://github.com/CocoaPods/Specs.git'

def import_pods
    #
    # include Mockingbird Toolbox
    #
    pod 'MBToolbox', '~> 1.1.7'

    #
    # include our forked version of Rapture XML
    #
    # Why did we fork? See: https://github.com/ZaBlanc/RaptureXML/issues/61
    #
    pod 'RaptureXML@Gilt', '~> 1.0.4'
end

target :ios do
    platform :ios, '7.0'
    link_with 'MBDataEnvironment iOS'
    import_pods
end

target :osx do
    platform :osx, '10.9'
    link_with 'MBDataEnvironment OSX'
    import_pods
end
