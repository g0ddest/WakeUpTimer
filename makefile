all: archive dmg

archive:
	set -o pipefail && xcodebuild archive \
        -project WakeUpTimer.xcodeproj \
        -destination "generic/platform=macOS" \
        -scheme "WakeUpTimer" \
        -archivePath "./WakeUpTimer/WakeUpTimer.xcarchive" \
        -xcconfig "./WakeUpTimer/MainConfig.xcconfig" \
        GCC_OPTIMIZATION_LEVEL=s \
        SWIFT_OPTIMIZATION_LEVEL=-O \
        GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
        DEBUG_INFORMATION_FORMAT=dwarf-with-dsym | xcbeautify

dmg:
	create-dmg \
        --volname "Wake Up Timer" \
        --background "./Misc/Media/dmg_background.png" \
        --window-pos 200 120 \
        --window-size 660 400 \
        --icon-size 160 \
        --icon "WakeUpTimer.app" 180 170 \
        --hide-extension "WakeUpTimer.app" \
        --app-drop-link 480 170 \
        --no-internet-enable \
        "./WakeUpTimer/WakeUpTimer.dmg" \
        "./WakeUpTimer/WakeUpTimer.xcarchive/Products/Applications/"
