# 3ds-template
Template Project for Code::Blocks for developing 3ds homebrew

This is a fork of [this template](https://github.com/thedax/3DSHomebrewTemplate) which in itself is a fork of [Steveice10's template](https://github.com/Steveice10/3DSHomebrewTemplate)

##This fork has a couple of modifications to:
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
1. If you intend to use the 3dsxlink and spunch targets ensure you have set IP3DS in the Makefile to the ip address of your 3ds on your network.
2. Eight build targets are defined see below for an explanation of each:
  * The 3ds target will build <project name>.3ds  
  * The 3dsx target will build both <project name>.3dsx and <project name>.smdh files
  * The cia target will build <project name>.cia  
  * The citra target will build <project name>.elf and automatically run citra with the file built (This requires having citra installed and in your $PATH)
  * The elf target will build <project name>.elf
  
  * The 3dsxlink target will build <project name>.3dsx and send it to your 3ds (In homebrew launcher press Y and you can netload your 3dsx file).  This requires you setting IP3DS in the Makefile to the ip address of your 3ds on your network.
  * The spunch target will build <project name>.cia and send it to your 3ds so FBI can install it (see note above).
  * The release target will build .elf, .3dsx, .cia, .3ds and a zip file (.3dsx and .smdh only). This requires having [makerom](https://github.com/profi200/Project_CTR) and [bannertool](https://github.com/Steveice10/bannertool) and [zip (if you are on windows)](http://downloads.sourceforge.net/gnuwin32/zip-3.0-bin.zip) [libbz2.dll on windows as well](http://downloads.sourceforge.net/gnuwin32/zip-3.0-dep.zip) in your $PATH
3. When you are ready to compile just hit the build button

