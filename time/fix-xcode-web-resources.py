#!/usr/bin/env python3
"""
自动修复Xcode项目 - 将Web文件夹添加为Folder Reference
解决Mac端黑屏问题
"""

import re
import sys
import os
import uuid
from pathlib import Path

def generate_uuid():
    """生成24位大写UUID"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def fix_xcode_project(project_path):
    """修复Xcode项目配置"""
    
    print("🔧 开始修复Xcode项目配置...")
    print(f"📁 项目路径: {project_path}")
    
    # 读取项目文件
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 检查Web是否已存在
    if 'Web' in content and 'folder' in content:
        print("⚠️  Web文件夹引用已存在，检查是否需要更新...")
        # 继续执行，确保完整配置
    
    # 生成UUID
    web_folder_uuid = generate_uuid()
    web_build_file_uuid = generate_uuid()
    
    print(f"🆔 生成UUID:")
    print(f"   Web文件夹: {web_folder_uuid}")
    print(f"   构建文件: {web_build_file_uuid}")
    
    # 1. 添加Web文件夹引用到PBXFileReference
    file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/.*?/\* End PBXFileReference section \*/)', content, re.DOTALL)
    if file_ref_section:
        web_ref = f'\t\t{web_folder_uuid} /* Web */ = {{isa = PBXFileReference; lastKnownFileType = folder; path = Web; sourceTree = "<group>"; }};\n'
        
        # 检查是否已有Web引用
        if web_folder_uuid not in content and 'Web */ = {isa = PBXFileReference' not in content:
            insert_pos = file_ref_section.end() - len('/* End PBXFileReference section */')
            content = content[:insert_pos] + web_ref + content[insert_pos:]
            print("✅ 添加Web文件夹引用到PBXFileReference")
        else:
            print("ℹ️  Web文件夹引用已存在")
    
    # 2. 添加Web到PBXGroup (time组)
    # 查找time组的定义
    time_group_match = re.search(r'(ABC70D4C2EA3E6CE00466629 /\* time \*/ = \{.*?children = \((.*?)\);)', content, re.DOTALL)
    if time_group_match:
        children_section = time_group_match.group(2)
        web_child_ref = f'\t\t\t\t{web_folder_uuid} /* Web */,\n'
        
        if web_folder_uuid not in children_section and '/* Web */' not in children_section:
            # 在children列表末尾添加Web引用
            insert_pos = time_group_match.end(2)
            content = content[:insert_pos] + web_child_ref + content[insert_pos:]
            print("✅ 添加Web到time组的children列表")
        else:
            print("ℹ️  Web已在time组中")
    
    # 3. 添加PBXBuildFile引用
    build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/)', content)
    if build_file_section:
        web_build_file = f'\t\t{web_build_file_uuid} /* Web in Resources */ = {{isa = PBXBuildFile; fileRef = {web_folder_uuid} /* Web */; }};\n'
        
        if web_build_file_uuid not in content and 'Web in Resources' not in content:
            insert_pos = build_file_section.end() + 1
            content = content[:insert_pos] + web_build_file + content[insert_pos:]
            print("✅ 添加Web构建文件引用")
        else:
            print("ℹ️  Web构建文件引用已存在")
    
    # 4. 添加Web到PBXResourcesBuildPhase (time target的Resources)
    # 查找time target的Resources构建阶段
    resources_phase = re.search(r'(ABC70D482EA3E6CE00466629 /\* Resources \*/ = \{.*?files = \((.*?)\);)', content, re.DOTALL)
    if resources_phase:
        files_section = resources_phase.group(2)
        web_resource_ref = f'\t\t\t\t{web_build_file_uuid} /* Web in Resources */,\n'
        
        if web_build_file_uuid not in files_section and 'Web in Resources' not in files_section:
            insert_pos = resources_phase.end(2)
            content = content[:insert_pos] + web_resource_ref + content[insert_pos:]
            print("✅ 添加Web到Resources构建阶段")
        else:
            print("ℹ️  Web已在Resources构建阶段")
    
    # 备份原文件
    backup_path = project_path + '.backup'
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(open(project_path, 'r', encoding='utf-8').read())
    print(f"💾 已备份原文件到: {backup_path}")
    
    # 写入修改后的内容
    with open(project_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ Xcode项目配置修复完成！")
    return True

def main():
    project_path = '/Users/shanwanjun/Desktop/cxs/time/time/time.xcodeproj/project.pbxproj'
    
    if not os.path.exists(project_path):
        print(f"❌ 项目文件不存在: {project_path}")
        return False
    
    try:
        success = fix_xcode_project(project_path)
        if success:
            print("\n🎉 修复成功！现在可以重新编译项目。")
            print("\n📋 后续步骤:")
            print("   1. Xcode会自动重新加载项目")
            print("   2. 运行仿真验证Mac应用")
            print("   3. 确认Web资源正确加载")
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

