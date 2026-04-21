# if we are not running in /dev/tty0, skip animation
if [ "$(tty)" != "/dev/tty0" ]; then
    echo "Welcome to Rhodes Island Pass Debug Shell!"
    echo "You are in Terminal $(tty)."
    return
fi

memcheck

echo "Welcome to Rhodes Island!"
echo "You are in Terminal $(tty)."
echo "Access Level: Operator"
echo ""
echo "DRM application is auto-started by init script."
echo "Use 'ps | grep drm_app' to check status."
echo "Use 'killall epass_drm_app' to stop."
echo ""
