//
//  Created by Samuel Williams on 25/7/2022.
//  Copyright, 2022, by Samuel Williams. All rights reserved.
//

#include <UnitTest/UnitTest.hpp>

#include <vulkan/vulkan.hpp>

namespace Vulkan {
	UnitTest::Suite InstanceTestSuite {
		"Vulkan",
		
		{"it can create a Vulkan instance",
			[](UnitTest::Examiner & examiner) {	
				auto application_info = vk::ApplicationInfo()
					.setPEngineName("Test/Vulkan")
					.setApiVersion(VK_MAKE_VERSION(1, 0, 0));
				
				auto instance_create_info = vk::InstanceCreateInfo()
					.setPApplicationInfo(&application_info);
			
				try {
					// We don't care if this succeeds or fails, just that the code compiles and it can execute.
					auto instance = vk::createInstanceUnique(instance_create_info, nullptr);
					
					examiner.check(!!instance);
				} catch (vk::IncompatibleDriverError) {
					// Ignore.
				}
			}
		}
	};
}
