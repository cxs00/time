#!/usr/bin/env python3
"""
添加Copy Files Build Phase到Xcode项目
强制将Web目录复制到Resources
"""

import re
import sys
import os
import uuid

def generate_uuid():
    """生成24位大写UUID"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def add_copy_files_phase(project_path):
    """添加Copy Files Build Phase"""
    
    print("🔧 添加Copy Files Build Phase...")
    print(f"📁 项目路径: {project_path}")
    
    # 读取项目文件
    with open(project_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 生成UUID
    copy_files_phase_uuid = generate_uuid()
    web_build_file_uuid = generate_uuid()
    web_file_ref_uuid = generate_uuid()
    
    print(f"🆔 生成UUID:")
    print(f"   Copy Files Phase: {copy_files_phase_uuid}")
    print(f"   Web Build File: {web_build_file_uuid}")
    print(f"   Web File Ref: {web_file_ref_uuid}")
    
    # 检查是否已存在
    if 'PBXCopyFilesBuildPhase' in content and 'Web' in content:
        print("⚠️  Copy Files Phase可能已存在")
    
    # 1. 添加PBXFileReference for Web folder
    file_ref_end = content.find('/* End PBXFileReference section */')
    if file_ref_end != -1:
        web_file_ref = f'\t\t{web_file_ref_uuid} /* Web */ = {{isa = PBXFileReference; lastKnownFileType = folder; name = Web; path = time/Web; sourceTree = SOURCE_ROOT; }};\n'
        content = content[:file_ref_end] + web_file_ref + content[file_ref_end:]
        print("✅ 添加Web文件夹引用")
    
    # 2. 创建PBXCopyFilesBuildPhase section (如果不存在)
    if '/* Begin PBXCopyFilesBuildPhase section */' not in content:
        # 在PBXFrameworksBuildPhase之前插入
        frameworks_section = content.find('/* Begin PBXFrameworksBuildPhase section */')
        if frameworks_section != -1:
            copy_files_section = """/* Begin PBXCopyFilesBuildPhase section */
/* End PBXCopyFilesBuildPhase section */

"""
            content = content[:frameworks_section] + copy_files_section + content[frameworks_section:]
            print("✅ 创建PBXCopyFilesBuildPhase section")
    
    # 3. 添加Copy Files Phase定义
    copy_files_section_end = content.find('/* End PBXCopyFilesBuildPhase section */')
    if copy_files_section_end != -1:
        # dstPath = Resources, dstSubfolderSpec = 7 (Resources folder)
        copy_files_phase = f'''\t\t{copy_files_phase_uuid} /* Copy Web Resources */ = {{
\t\t\tisa = PBXCopyFilesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tdstPath = "";
\t\t\tdstSubfolderSpec = 7;
\t\t\tfiles = (
\t\t\t\t{web_build_file_uuid} /* Web in Copy Web Resources */,
\t\t\t);
\t\t\tname = "Copy Web Resources";
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t}};
'''
        if copy_files_phase_uuid not in content:
            content = content[:copy_files_section_end] + copy_files_phase + content[copy_files_section_end:]
            print("✅ 添加Copy Files Phase定义")
    
    # 4. 创建PBXBuildFile section (如果不存在)
    if '/* Begin PBXBuildFile section */' not in content:
        # 在PBXContainerItemProxy之后插入
        container_end = content.find('/* End PBXContainerItemProxy section */')
        if container_end != -1:
            insert_pos = content.find('\n', container_end) + 1
            build_file_section = """
/* Begin PBXBuildFile section */
/* End PBXBuildFile section */
"""
            content = content[:insert_pos] + build_file_section + content[insert_pos:]
            print("✅ 创建PBXBuildFile section")
    
    # 5. 添加PBXBuildFile
    build_file_section_end = content.find('/* End PBXBuildFile section */')
    if build_file_section_end != -1:
        web_build_file = f'\t\t{web_build_file_uuid} /* Web in Copy Web Resources */ = {{isa = PBXBuildFile; fileRef = {web_file_ref_uuid} /* Web */; }};\n'
        if web_build_file_uuid not in content:
            content = content[:build_file_section_end] + web_build_file + content[build_file_section_end:]
            print("✅ 添加Web构建文件")
    
    # 6. 添加Copy Files Phase到time target的buildPhases
    # 查找time target (ABC70D492EA3E6CE00466629)
    target_pattern = r'(ABC70D492EA3E6CE00466629 /\* time \*/ = \{[\s\S]*?buildPhases = \()([\s\S]*?)(\);)'
    target_match = re.search(target_pattern, content)
    
    if target_match:
        build_phases = target_match.group(2)
        copy_phase_ref = f'\t\t\t\t{copy_files_phase_uuid} /* Copy Web Resources */,'
        if copy_files_phase_uuid not in build_phases:
            # 在buildPhases列表开头添加（Resources之前）
            new_build_phases = copy_phase_ref + '\n' + build_phases
            content = content[:target_match.start(2)] + new_build_phases + content[target_match.end(2):]
            print("✅ 添加Copy Files Phase到time target")
        else:
            print("ℹ️  Copy Files Phase已在target中")
    
    # 备份
    backup_path = project_path + '.backup2'
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(open(project_path, 'r', encoding='utf-8').read())
    print(f"💾 已备份到: {backup_path}")
    
    # 写入
    with open(project_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ Copy Files Phase添加完成！")
    return True

def main():
    project_path = '/Users/shanwanjun/Desktop/cxs/time/time/time.xcodeproj/project.pbxproj'
    
    if not os.path.exists(project_path):
        print(f"❌ 项目文件不存在: {project_path}")
        return False
    
    try:
        success = add_copy_files_phase(project_path)
        if success:
            print("\n🎉 修改成功！")
            print("\n⚠️  现在需要:")
            print("   1. Clean Build")
            print("   2. 重新Build")
            print("   3. Web目录将被复制到Resources")
            return True
        else:
            print("\n❌ 修改失败")
            return False
    except Exception as e:
        print(f"\n❌ 发生错误: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)

