# 3ds-template
Template Project for Code::Blocks for developing 3ds homebrew

## To set up in Code::Blocks
1. Simply open the 3ds.cbp in Code::Blocks
2. Choose File > Save as user-template and enter a template name.  The project setup is now a user template to create new projects.
3. When creating a new project select File > New > From template and follow the wizard's instructions.

## To use
1. Two build targets are defined 3dsx and citra.
  * The 3dsx target will build both <project name>.3dsx and <project name>.smdh files
  * The citra target will build <project name>.elf and automatically run citra with the file built (This requires having citra installed an in your $PATH)
2. When you are ready to compile just hit the build button

