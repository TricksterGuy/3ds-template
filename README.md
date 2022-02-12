# 3ds-template

A starter template for various 3DS homebrew applications. This template is geared specifically towards the Code::Blocks IDE.  This template can also be used without Code::Blocks just use the `Makefile` and directory structure provided.

This is designed to be a simple and fairly minimal setup required to begin developing homebrew for the 3ds system. As such it doesn't include everything needed to build everything out of the box if you want to build 3ds or cia homebrew.

## Usage

| Targets     | Action                                                                                    |
| ------------| ----------------------------------------------------------------------------------------- |
| 3ds         | Builds `<project name>.3ds`. <sup>1</sup>
| 3dsx        | Builds `<project name>.3dsx` and `<project name>.smdh`.
| cia         | Builds `<project name>.cia`. <sup>1</sup>
| citra       | Builds and automatically runs `citra` for testing.<sup>2</sup>
| elf         | Builds `<project name>.elf`.
| release     | Release build, creates a `cia`, `3ds`, and a zip file containing the `smdh` and `3dsx`. <sup>3</sup>

**Notes:** 
* <sup>1</sup> This requires having [makerom] and [bannertool] in your `$PATH`
* <sup>2</sup> `make citra` requires having [citra] installed and in your `$PATH`
* <sup>3</sup> If you are on Windows you will need both of the following in your `$PATH` [zip] and [libbz2.dll]

## Setting up devkitPro
* Follow the steps installing devkitPro at the gbatemp [wiki]

### If you want to build cia and 3ds then follow these extra steps:
* Aquire makerom and bannertool binaries from [buildtools], or compile them yourself from [makerom] and [bannertool]
* Copy the makerom/bannertool to `$DEVKITARM/bin` or some other directory in your `$PATH`

## Code::Blocks Setup
1. Simply open `3ds.cbp` in Code::Blocks
2. Choose File > Save as user-template and enter a template name.  The project setup is now a user template to create new projects.
3. When creating a new project select File > New > From template and follow the wizard's instructions.
4. Ensure you have the environment variables plugin installed (in linux you can install this by installing the codeblocks-contrib package)
5. Choose Settings > Environment and scroll down to the Environment Variables section.
6. Add `DEVKITPRO` and point it to where devkitpro is installed
7. Add `DEVKITARM` and point it to where devkitarm is.

To compile in Code::Blocks simply select your target from the list and click the Gear icon to automatically invoke the `Makefile`

**Note** Make sure you are using MSYS2's make (make.exe) and not MINGW's make (mingw32-make.exe)

## Creating a new project
1. Make a new Code::Blocks project via a user-template you just created above.  Or simply copy this directory.
2. (Only needed for cia/3ds builds) Edit the file `resources/AppInfo`
    1. Edit those values and ensure you choose a unique id see [unique_id_list].
    2. Replace the existing files in the `resources` directory to suit your needs.
    
**Note** please ensure that no folder/directory used in the project contains spaces. Devkitpro's Makefiles apparently does not like this.
That is, do not have it in a folder like `C:/3DS Hacking/3ds-template` rather `C:/3DS_Hacking/3ds-template`
  
## Credits
All of this would not have been possible without the work of
* [Smealum](https://github.com/smealum)
* [Steveice10](https://github.com/Steveice10) for the [buildtools]
* [amaredeus](https://github.com/amaredeus) for various improvements to the template (such as the formatting in this README)


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


[buildtools]: <https://github.com/Steveice10/buildtools>
[bannertool]: <https://github.com/Steveice10/buildtools>
[citra]: <https://github.com/citra-emu/citra>
[libbz2.dll]: <http://downloads.sourceforge.net/gnuwin32/zip-3.0-dep.zip>
[makerom]: <https://github.com/profi200/Project_CTR>
[unique_id_list]: <https://gbatemp.net/threads/homebrew-cias-uniqueid-collection.379362>
[wiki]: <https://wiki.gbatemp.net/wiki/3DS_Homebrew_Development#Install_devkitARM>
[zip]: <http://downloads.sourceforge.net/gnuwin32/zip-3.0-bin.zip>
