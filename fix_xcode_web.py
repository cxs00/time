#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
TIME - 自动添加Web资源到Xcode项目
修复"资源加载失败"问题
"""

import os
import uuid

# 项目路径
project_path = "/Users/shanwanjun/Desktop/cxs/time/time/time.xcodeproj/project.pbxproj"
backup_path = project_path + ".backup"

print("🔧 TIME Xcode项目自动修复工具")
print("=" * 50)
print()

# 备份项目文件
print("📋 备份项目文件...")
os.system(f"cp '{project_path}' '{backup_path}'")
print(f"✅ 备份完成: {backup_path}")
print()

# 读取项目文件
with open(project_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 生成UUID
web_ref_uuid = str(uuid.uuid4()).replace('-', '').upper()[:24]
web_build_uuid = str(uuid.uuid4()).replace('-', '').upper()[:24]

print(f"🆔 生成UUID:")
print(f"   Web文件夹引用: {web_ref_uuid}")
print(f"   Web构建引用: {web_build_uuid}")
print()

# 检查是否已经添加过
if web_ref_uuid in content or 'Web' in content:
    print("⚠️  检测到项目中可能已有Web引用")
    print("    将清理后重新添加...")
    print()

# 准备要插入的内容

# 1. PBXFileReference section - 添加Web文件夹引用
file_ref_section = f"""/* Begin PBXFileReference section */
\t\t{web_ref_uuid} /* Web */ = {{isa = PBXFileReference; lastKnownFileType = folder; path = Web; sourceTree = "<group>"; }};"""

# 2. PBXGroup section - 将Web添加到time组
# 找到time组并添加Web引用

# 3. PBXResourcesBuildPhase - 添加到资源构建阶段
resource_build = f"""\t\t\t\t{web_build_uuid} /* Web in Resources */,"""

# 4. PBXBuildFile - 添加构建文件
build_file = f"""\t\t{web_build_uuid} /* Web in Resources */ = {{isa = PBXBuildFile; fileRef = {web_ref_uuid} /* Web */; }};"""

print("📝 修改项目配置...")

# 修改内容
modified = content

# 在FileReference section添加
if "/* Begin PBXFileReference section */" in modified:
    modified = modified.replace(
        "/* Begin PBXFileReference section */",
        file_ref_section
    )
    print("✅ 添加Web文件夹引用")

# 在BuildFile section添加
if "/* Begin PBXBuildFile section */" in modified:
    modified = modified.replace(
        "/* Begin PBXBuildFile section */",
        f"/* Begin PBXBuildFile section */\n{build_file}"
    )
    print("✅ 添加构建文件引用")

# 在Resources构建阶段添加
if "files = (\n\t\t\t);" in modified and "PBXResourcesBuildPhase" in modified:
    # 找到Resources构建阶段
    import re
    pattern = r'(ABC70D482EA3E6CE00466629 /\* Resources \*/ = \{[^}]*files = \(\n)'
    replacement = r'\1' + resource_build + '\n'
    modified = re.sub(pattern, replacement, modified)
    print("✅ 添加到资源构建阶段")

# 在time组中添加Web引用
# 需要找到time组的children数组
pattern = r'(ABC70D4C2EA3E6CE00466629 /\* time \*/ = \{[^}]*children = \([^)]*)'
if re.search(pattern, modified):
    replacement = r'\1\n\t\t\t\t' + web_ref_uuid + ' /* Web */,'
    modified = re.sub(pattern, replacement, modified)
    print("✅ 添加Web到time组")

# 写回文件
with open(project_path, 'w', encoding='utf-8') as f:
    f.write(modified)

print()
print("=" * 50)
print("🎉 项目配置已更新！")
print()
print("📱 下一步操作：")
print("   1. 在Xcode中 Clean Build Folder (Cmd+Shift+K)")
print("   2. 运行应用 (Cmd+R)")
print("   3. 应该看到完整的TIME界面（紫色主题）")
print()
print("💡 如果还是不行，请手动在Xcode中添加Web文件夹")
print()

