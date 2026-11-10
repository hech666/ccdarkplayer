DEBUG = 0
FINALPACKAGE = 1

ARCHS = arm64 arm64e

# Share the SDK and deployment targets with the PreferenceBundle.
include HaogeCCDarkPlayerBuild.mk
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HaogeCCDarkPlayer
HaogeCCDarkPlayer_FILES = $(wildcard Hooks/*.xm Sources/*.m)
HaogeCCDarkPlayer_CFLAGS = -fobjc-arc -I./Headers -I./Sources
HaogeCCDarkPlayer_FRAMEWORKS = UIKit Foundation CoreFoundation
HaogeCCDarkPlayer_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk


