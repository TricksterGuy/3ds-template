# 3ds-template
Template Project for Code::Blocks for developing 3ds homebrew

This is a fork of [this template](https://github.com/thedax/3DSHomebrewTemplate) which itself is a fork of [Steveice10's template](https://github.com/Steveice10/3DSHomebrewTemplate)

This fork has a couple of modifications to:
1. Add support for the makefile in Code::Blocks (add targets for just building 3dsx, running in citra, and building everything).
2. Not package everything (cia, 3ds, 3dsx) into the output zip folder.
3. Remove tools folder and assume developer has makerom and bannertool in the PATH
4. Move tools/template.rsf to resources.rsf

## To set up in Code::Blocks
1. Simply open the 3ds.cbp in Code::Blocks
2. Choose File > Save as user-template and enter a template name.  The project setup is now a user template to create new projects.
3. When creating a new project select File > New > From template and follow the wizard's instructions.
4. Ensure you have the environment variables plugin installed (in linux you can install this by installing the codeblocks-contrib package)
5. Choose Settings > Environment and scroll down to the Environment Variables section.
6. Add DEVKITPRO to point to where devkitpro is installed
7. Add DEVKITARM to point to where devkitarm is.

## To use
1. Two build targets are defined 3dsx, citra, and release.
  * The 3dsx target will build both <project name>.3dsx and <project name>.smdh files
  * The citra target will build <project name>.elf and automatically run citra with the file built (This requires having citra installed and in your $PATH)
  * The release target will build .elf, .3dsx, .cia, .3ds and a zip file (.3dsx and .smdh only). This requires having [makerom](https://github.com/profi200/Project_CTR) and [bannertool](https://github.com/Steveice10/bannertool) in your $PATH
2. When you are ready to compile just hit the build button

