
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_project "vulkan-sdk" do |project|
	project.add_author "Samuel Williams"
	project.license = " Apache License, Version 2.0 / MIT License"

	project.version = "1.0.39"
end

define_target "vulkan-sdk" do |target|
	target.depends :platform	
	target.depends "Build/Files"
	
	target.provides "SDK/Vulkan" do
		source_root = target.package.path + 'source'
		
		append header_search_paths source_root
	end
end

define_target 'vulkan-platform-xcb' do |target|
	target.provides 'Vulkan/Platform/XCB' do
		append buildflags "-DVK_USE_PLATFORM_XCB_KHR"
		append linkflags %W{-lxcb -lvulkan}
	end
	
	target.provides :vulkan_platform => 'Vulkan/Platform/XCB'
end

define_configuration "test" do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.require "platforms"
	configuration.require "build-files"
end
