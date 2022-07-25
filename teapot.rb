
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

define_project "vulkan" do |project|
	project.add_author "Samuel Williams"
	project.license = " Apache License, Version 2.0 / MIT License"

	project.version = "1.3.216"
end

define_target "vulkan-library" do |target|
	target.depends :platform	
	target.depends "Build/Files"

	target.depends :vulkan_library, public: true

	target.provides "Library/Vulkan" do
		source_root = target.package.path + 'source'
		
		append header_search_paths source_root
	end
end

define_target "vulkan-platform" do |target|
	target.depends :platform
	target.depends "Build/Files"
	
	target.depends :vulkan_platform, public: true

	target.provides "Platform/Vulkan" do
		source_root = target.package.path + 'source'
		
		append header_search_paths source_root
	end
end

define_target 'vulkan-test' do |target|
	target.depends 'Language/C++17'
	
	target.depends 'Library/UnitTest'

	target.depends 'Library/Vulkan'
	
	target.provides 'Test/Vulkan' do |*arguments|
		test_root = target.package.path + 'test'
		
		run source_files: test_root.glob('Vulkan/**/*.cpp'), arguments: arguments
	end
end

# Configurations

define_configuration 'development' do |configuration|
	configuration[:source] = "https://github.com/kurocha"
	configuration.import "vulkan"

	# Provides unit testing infrastructure and generators:
	configuration.require 'unit-test'

	# Provides all the build related infrastructure:
	configuration.require 'platforms'
	configuration.require 'build-files'
end

define_configuration "vulkan" do |configuration|
	configuration.public!
	
	configuration.require 'logger'
	configuration.require 'units'
	configuration.require 'memory'

	host /linux/ do
		configuration.require 'vulkan-linux'
	end

	host /darwin/ do
		configuration.require 'vulkan-darwin'
	end
end
