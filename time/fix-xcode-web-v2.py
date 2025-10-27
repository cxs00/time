#!/usr/bin/env python3
"""
修复Xcode项目 V2 - 正确处理PBXFileSystemSynchronizedRootGroup
专门针对Xcode 15+的新项目格式
"""

import re
import sys
import os
import uuid

def generate_uuid():
    """生成24位大写UUID"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def fix_xcode_project_v2(project_path):
    """修复Xcode项目配置 - V2版本"""
    
    print("🔧 开始修复Xcode项目配置 (V2 - 针对PBXFileSystemSynchronizedRootGroup)...")
    print(f"📁 项目路径: {project_path}")
    
    # 读取项目文件
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 恢复备份（如果之前的修改不正确）
    backup_path = project_path + '.backup'
    if os.path.exists(backup_path):
        print("📦 发现备份文件，从备份恢复...")
        with open(backup_path, 'r', encoding='utf-8') as f:
            content = f.read()
    
    # 生成UUID
    web_folder_uuid = generate_uuid()
    web_build_file_uuid = generate_uuid()
    
    print(f"🆔 生成UUID:")
    print(f"   Web文件夹: {web_folder_uuid}")
    print(f"   构建文件: {web_build_file_uuid}")
    
    # 1. 添加PBXBuildFile
    build_file_section_start = content.find('/* Begin PBXBuildFile section */')
    if build_file_section_start == -1:
        print("❌ 找不到PBXBuildFile section")
        return False
    
    # 在section开始后插入
    insert_pos = content.find('\n', build_file_section_start) + 1
    web_build_file = f'\t\t{web_build_file_uuid} /* Web in Resources */ = {{isa = PBXBuildFile; fileRef = {web_folder_uuid} /* Web */; }};\n'
    
    if 'Web in Resources' not in content:
        content = content[:insert_pos] + web_build_file + content[insert_pos:]
        print("✅ 添加 PBXBuildFile")
    else:
        print("ℹ️  PBXBuildFile 已存在")
    
    # 2. 添加PBXFileReference
    file_ref_section_end = content.find('/* End PBXFileReference section */')
    if file_ref_section_end == -1:
        print("❌ 找不到PBXFileReference section")
        return False
    
    web_file_ref = f'\t\t{web_folder_uuid} /* Web */ = {{isa = PBXFileReference; lastKnownFileType = folder; name = Web; path = time/Web; sourceTree = "<group>"; }};\n'
    
    if web_folder_uuid not in content and '/* Web */ = {isa = PBXFileReference' not in content:
        # 在End之前插入
        content = content[:file_ref_section_end] + web_file_ref + content[file_ref_section_end:]
        print("✅ 添加 PBXFileReference (路径: time/Web)")
    else:
        print("ℹ️  PBXFileReference 已存在")
    
    # 3. 添加到主PBXGroup的children
    # 查找主group (ABC70D412EA3E6CE00466629)
    main_group_pattern = r'(ABC70D412EA3E6CE00466629 = \{[\s\S]*?children = \()([\s\S]*?)(\);)'
    main_group_match = re.search(main_group_pattern, content)
    
    if main_group_match:
        children_content = main_group_match.group(2)
        if web_folder_uuid not in children_content and '/* Web */' not in children_content:
            # 在children列表末尾添加
            new_children = children_content.rstrip() + f'\n\t\t\t\t{web_folder_uuid} /* Web */,'
            content = content[:main_group_match.start(2)] + new_children + content[main_group_match.end(2):]
            print("✅ 添加 Web 到主 PBXGroup")
        else:
            print("ℹ️  Web 已在主 PBXGroup 中")
    else:
        print("⚠️  找不到主 PBXGroup，跳过")
    
    # 4. 添加到PBXResourcesBuildPhase
    # 查找time target的Resources phase (ABC70D482EA3E6CE00466629)
    resources_pattern = r'(ABC70D482EA3E6CE00466629 /\* Resources \*/ = \{[\s\S]*?files = \()([\s\S]*?)(\);)'
    resources_match = re.search(resources_pattern, content)
    
    if resources_match:
        files_content = resources_match.group(2)
        if web_build_file_uuid not in files_content and 'Web in Resources' not in files_content:
            # 在files列表末尾添加
            new_files = files_content.rstrip() + f'\n\t\t\t\t{web_build_file_uuid} /* Web in Resources */,'
            content = content[:resources_match.start(2)] + new_files + content[resources_match.end(2):]
            print("✅ 添加 Web 到 PBXResourcesBuildPhase")
        else:
            print("ℹ️  Web 已在 PBXResourcesBuildPhase 中")
    else:
        print("❌ 找不到 PBXResourcesBuildPhase")
        return False
    
    # 备份原文件
    if not os.path.exists(backup_path):
        with open(backup_path, 'w', encoding='utf-8') as f:
            f.write(open(project_path, 'r', encoding='utf-8').read())
        print(f"💾 已备份原文件到: {backup_path}")
    
    # 写入修改后的内容
    with open(project_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ Xcode项目配置修复完成 (V2)！")
    print("\n📋 关键修改:")
    print(f"   - Web路径: time/Web (相对于项目根目录)")
    print(f"   - 类型: folder (Folder Reference)")
    print(f"   - 已添加到 time target 的 Resources 构建阶段")
    return True

def main():
    project_path = '/Users/shanwanjun/Desktop/cxs/time/time/time.xcodeproj/project.pbxproj'
    
    if not os.path.exists(project_path):
        print(f"❌ 项目文件不存在: {project_path}")
        return False
    
    try:
        success = fix_xcode_project_v2(project_path)
        if success:
            print("\n🎉 修复成功！")
            print("\n⚠️  重要：需要重新clean build")
            print("   1. xcodebuild clean")
            print("   2. xcodebuild build")
            print("   3. 验证 Resources 目录")
            return True
        else:
            print("\n❌ 修复失败")
            return False
    except Exception as e:
        print(f"\n❌ 发生错误: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)

