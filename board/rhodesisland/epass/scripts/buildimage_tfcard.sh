#!/bin/sh
#
# buildimage.sh - 构建 TF 卡启动镜像
# 注意：由于权限限制，此脚本仅生成必要文件
# 完整镜像需要使用 root 权限手动创建
#

set -e

echo "========================================="
echo "Preparing TF Card Boot Files..."
echo "========================================="

cd "${BINARIES_DIR}"

# 创建 boot 目录
echo "Preparing boot files..."
mkdir -p boot/dt
cp -r dt/* boot/dt/ 2>/dev/null || echo "Warning: dt directory not found"
cp zImage boot/zImage 2>/dev/null || echo "Warning: zImage not found"

# 复制 sys-config.conf 到 boot 目录
if [ -f "${BR2_EXTERNAL}/board/rhodesisland/epass/sys-config.conf" ]; then
    cp "${BR2_EXTERNAL}/board/rhodesisland/epass/sys-config.conf" boot/sys-config.conf
    echo "sys-config.conf copied to boot directory"
else
    echo "Warning: sys-config.conf not found, creating default..."
    cat > boot/sys-config.conf << 'EOF'
# ============================================
# 系统配置文件 - ArkEPass
# ============================================
device_rev=0.6
screen=hsd
interface=
ext=
kernelfn=zImage
EOF
fi

echo ""
echo "========================================="
echo "Boot files prepared successfully!"
echo "========================================="
echo "Output files in: ${BINARIES_DIR}"
echo "  - zImage (kernel)"
echo "  - sys-config.conf (config)"
echo "  - dt/ (device tree overlays)"
echo "  - rootfs.tar (root filesystem)"
echo ""
echo "To create bootable TF card:"
echo "  1. Format TF card with 2 partitions:"
echo "     - Partition 1: 60MB FAT32 (boot)"
echo "     - Partition 2: remaining space ext4 (rootfs)"
echo "  2. Copy boot/* to partition 1"
echo "  3. Extract rootfs.tar to partition 2"
echo "========================================="

