hdiutil create -fs HFS+ -volname "NotifyMyAndroid 1.0.1" -srcfolder \
"./build/Release" "./NotifyMyAndroid-1.0.1.dmg"
hdiutil internet-enable -yes "NotifyMyAndroid-1.0.1.dmg"
