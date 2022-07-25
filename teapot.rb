
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_project "vulkan-sdk" do |project|
	project.add_author "Samuel Williams"
	project.license = " Apache License, Version 2.0 / MIT License"

	project.version = "1.3.216"
end

define_target "vulkan-sdk-library" do |target|
	target.depends :platform	
	target.depends "Build/Files"

	target.depends :vulkan_library, public: true

	target.provides "SDK/Vulkan/Library" do
		source_root = target.package.path + 'source'
		
		append header_search_paths source_root
	end
end

define_target "vulkan-sdk-platform" do |target|
	target.depends :platform
	target.depends "Build/Files"
	
	target.depends :vulkan_platform, public: true

	target.provides "SDK/Vulkan"
end

define_target 'vulkan-sdk-test' do |target|
	target.depends 'Language/C++17'
	
	target.depends 'Library/UnitTest'

	target.depends 'SDK/Vulkan/Library'
	
	target.provides 'Test/SDK/Vulkan' do |*arguments|
		test_root = target.package.path + 'test'
		
		run source_files: test_root.glob('vulkan/**/*.cpp'), arguments: arguments
	end
end

# Configurations

define_configuration 'development' do |configuration|
	configuration[:source] = "https://github.com/kurocha"
	configuration.import "vulkan-sdk"

	# Provides unit testing infrastructure and generators:
	configuration.require 'unit-test'

	# Provides all the build related infrastructure:
	configuration.require 'platforms'
	configuration.require 'build-files'
end

define_configuration "vulkan-sdk" do |configuration|
	configuration.public!
	
	configuration.require 'logger'
	configuration.require 'units'
	configuration.require 'memory'

	host /linux/ do
		configuration.require 'vulkan-sdk-linux'
	end

	host /darwin/ do
		configuration.require 'vulkan-sdk-darwin'
	end
end
