#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/3ds_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# DATA is a list of directories containing data files
# INCLUDES is a list of directories containing header files
# RESOURCES is the directory where AppInfo template.rsf etc can be found
# OUTPUT is the directory where final executables will be placed
# ROMFS is the directory which contains the RomFS, relative to the Makefile
#---------------------------------------------------------------------------------
TARGET      := $(notdir $(CURDIR))
BUILD       := build
SOURCES     := source
DATA        := data
INCLUDES    := include
ROMFS       := romfs
OUTPUT      := output
RESOURCES   := resources

#---------------------------------------------------------------------------------
# Resource Setup
#---------------------------------------------------------------------------------
APP_INFO        := $(RESOURCES)/AppInfo
BANNER_AUDIO    := $(RESOURCES)/audio
BANNER_IMAGE    := $(RESOURCES)/banner
ICON            := $(RESOURCES)/icon.png
RSF             := $(TOPDIR)/$(RESOURCES)/template.rsf

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH        := -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft
COMMON      := -Wall -O2 -mword-relocations -fomit-frame-pointer -ffunction-sections $(ARCH) $(INCLUDE) -DARM11 -D_3DS
CFLAGS      := $(COMMON) -std=gnu99
CXXFLAGS    := $(COMMON) -fno-rtti -fno-exceptions -std=gnu++11
ASFLAGS     := $(ARCH)
LDFLAGS     = -specs=3dsx.specs $(ARCH) -Wl,-Map,$(notdir $*.map)

#---------------------------------------------------------------------------------
# Libraries needed to link into the executable.
#---------------------------------------------------------------------------------
LIBS := -lcitro3d -lctru -lm

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:= $(PORTLIBS) $(CTRULIB)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export TOPDIR      := $(CURDIR)
export OUTPUT_DIR  := $(TOPDIR)/$(OUTPUT)
export OUTPUT_FILE := $(OUTPUT_DIR)/$(TARGET)
export VPATH       := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) $(foreach dir,$(DATA),$(CURDIR)/$(dir))
export DEPSDIR     := $(TOPDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
PICAFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.v.pica)))
SHLISTFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.shlist)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
	export LD := $(CC)
else
	export LD := $(CXX)
endif
#---------------------------------------------------------------------------------

export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export OFILES_BIN     := $(addsuffix .o,$(BINFILES)) $(PICAFILES:.v.pica=.shbin.o) $(SHLISTFILES:.shlist=.shbin.o)
export OFILES         := $(OFILES_BIN) $(OFILES_SOURCES)
export HFILES         := $(PICAFILES:.v.pica=_shbin.h) $(addsuffix .h,$(subst .,_,$(BINFILES)))
export INCLUDE        := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) $(foreach dir,$(LIBDIRS),-I$(dir)/include) -I$(CURDIR)/$(BUILD)
export LIBPATHS       := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

#---------------------------------------------------------------------------------
# Inclusion of romfs folder and building SMDH
#---------------------------------------------------------------------------------
export _3DSXFLAGS += --romfs=$(CURDIR)/$(ROMFS)
export _3DSXFLAGS += --smdh=$(OUTPUT_FILE).smdh

#---------------------------------------------------------------------------------
# First set of targets ensure the build/output directories are created and execute
# in the context of the BUILD directory.
#---------------------------------------------------------------------------------
.PHONY : clean all bootstrap 3dsx cia elf 3ds citra release

all : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

3dsx : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

cia : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

3ds : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

elf : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

citra : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

release : bootstrap
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile $@

bootstrap :
	@[ -d $(BUILD) ] || mkdir -p $(BUILD)
	@[ -d $(OUTPUT_DIR) ] || mkdir -p $(OUTPUT_DIR)

clean :
	@echo clean ...
	@rm -rf $(BUILD) $(OUTPUT)

#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d)

include $(TOPDIR)/$(APP_INFO)
APP_TITLE         := $(shell echo "$(APP_TITLE)" | cut -c1-128)
APP_DESCRIPTION   := $(shell echo "$(APP_DESCRIPTION)" | cut -c1-256)
APP_AUTHOR        := $(shell echo "$(APP_AUTHOR)" | cut -c1-128)
APP_PRODUCT_CODE  := $(shell echo $(APP_PRODUCT_CODE) | cut -c1-16)
APP_UNIQUE_ID     := $(shell echo $(APP_UNIQUE_ID) | cut -c1-7)
APP_VERSION_MAJOR := $(shell echo $(APP_VERSION_MAJOR) | cut -c1-3)
APP_VERSION_MINOR := $(shell echo $(APP_VERSION_MINOR) | cut -c1-3)
APP_VERSION_MICRO := $(shell echo $(APP_VERSION_MICRO) | cut -c1-3)

ifneq ("$(wildcard $(TOPDIR)/$(BANNER_IMAGE).cgfx)","")
	BANNER_IMAGE_FILE := $(TOPDIR)/$(BANNER_IMAGE).cgfx
	BANNER_IMAGE_ARG  := -ci $(BANNER_IMAGE_FILE)
else
	BANNER_IMAGE_FILE := $(TOPDIR)/$(BANNER_IMAGE).png
	BANNER_IMAGE_ARG  := -i $(BANNER_IMAGE_FILE)
endif

ifneq ("$(wildcard $(TOPDIR)/$(BANNER_AUDIO).cwav)","")
	BANNER_AUDIO_FILE := $(TOPDIR)/$(BANNER_AUDIO).cwav
	BANNER_AUDIO_ARG  := -ca $(BANNER_AUDIO_FILE)
else
	BANNER_AUDIO_FILE := $(TOPDIR)/$(BANNER_AUDIO).wav
	BANNER_AUDIO_ARG  := -a $(BANNER_AUDIO_FILE)
endif

APP_ICON := $(TOPDIR)/$(ICON)
APP_ROMFS := $(TOPDIR)/$(ROMFS)

COMMON_MAKEROM_PARAMS := -rsf $(RSF) -target t -exefslogo -elf $(OUTPUT_FILE).elf -icon icon.icn \
-banner banner.bnr -DAPP_TITLE="$(APP_TITLE)" -DAPP_PRODUCT_CODE="$(APP_PRODUCT_CODE)" \
-DAPP_UNIQUE_ID="$(APP_UNIQUE_ID)" -DAPP_ROMFS="$(APP_ROMFS)" -DAPP_SYSTEM_MODE="64MB" \
-DAPP_SYSTEM_MODE_EXT="Legacy" -major "$(APP_VERSION_MAJOR)" -minor "$(APP_VERSION_MINOR)" \
-micro "$(APP_VERSION_MICRO)"

ifeq ($(OS),Windows_NT)
	MAKEROM = makerom.exe
	BANNERTOOL = bannertool.exe
else
	MAKEROM = makerom
	BANNERTOOL = bannertool
endif

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
.PHONY: all 3dsx cia elf 3ds citra release

$(OUTPUT_FILE).3dsx : $(OUTPUT_FILE).elf $(OUTPUT_FILE).smdh

$(OFILES_SOURCES) : $(HFILES)

$(OUTPUT_FILE).elf : $(OFILES)

$(OUTPUT_FILE).3ds : $(OUTPUT_FILE).elf banner.bnr icon.icn
	@$(MAKEROM) -f cci -o $(OUTPUT_FILE).3ds -DAPP_ENCRYPTED=true $(COMMON_MAKEROM_PARAMS)
	@echo "built ... $(notdir $@)"

$(OUTPUT_FILE).cia : $(OUTPUT_FILE).elf banner.bnr icon.icn
	@$(MAKEROM) -f cia -o $(OUTPUT_FILE).cia -DAPP_ENCRYPTED=false $(COMMON_MAKEROM_PARAMS)

$(OUTPUT_FILE).zip : $(OUTPUT_FILE).smdh $(OUTPUT).3dsx
	@cd $(OUTPUT_DIR) \
	mkdir -p 3ds/$(TARGET) \
	cp $(OUTPUT_FILE).3dsx 3ds/$(TARGET) \
	cp $(OUTPUT_FILE).smdh 3ds/$(TARGET) \
	zip -r $(OUTPUT_FILE).zip 3ds > /dev/null \
	rm -r 3ds

banner.bnr : $(BANNER_IMAGE_FILE) $(BANNER_AUDIO_FILE)
	@$(BANNERTOOL) makebanner $(BANNER_IMAGE_ARG) $(BANNER_AUDIO_ARG) -o banner.bnr > /dev/null

icon.icn : $(TOPDIR)/$(ICON)
	@$(BANNERTOOL) makesmdh -s "$(APP_TITLE)" -l "$(APP_TITLE)" -p "$(APP_AUTHOR)" -i $(TOPDIR)/$(ICON) -o icon.icn > /dev/null

3dsx : $(OUTPUT_FILE).3dsx

cia : $(OUTPUT_FILE).cia

3ds : $(OUTPUT_FILE).3ds

elf : $(OUTPUT_FILE).elf

citra : 3dsx
	citra $(OUTPUT_FILE).3dsx

release : $(OUTPUT_FILE).zip cia 3ds

#---------------------------------------------------------------------------------
# Binary Data Rules
#---------------------------------------------------------------------------------
%.png.o	%_png.h :	%.png
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
# rules for assembling GPU shaders
#---------------------------------------------------------------------------------
define shader-as
	$(eval CURBIN := $*.shbin)
	$(eval DEPSFILE := $(DEPSDIR)/$*.shbin.d)
	echo "$(CURBIN).o: $< $1" > $(DEPSFILE)
	echo "extern const u8" `(echo $(CURBIN) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`"_end[];" > `(echo $(CURBIN) | tr . _)`.h
	echo "extern const u8" `(echo $(CURBIN) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`"[];" >> `(echo $(CURBIN) | tr . _)`.h
	echo "extern const u32" `(echo $(CURBIN) | sed -e 's/^\([0-9]\)/_\1/' | tr . _)`_size";" >> `(echo $(CURBIN) | tr . _)`.h
	picasso -o $(CURBIN) $1
	bin2s $(CURBIN) | $(AS) -o $*.shbin.o
endef

%.shbin.o %_shbin.h : %.v.pica %.g.pica
	@echo $(notdir $^)
	@$(call shader-as,$^)

%.shbin.o %_shbin.h : %.v.pica
	@echo $(notdir $<)
	@$(call shader-as,$<)

%.shbin.o %_shbin.h : %.shlist
	@echo $(notdir $<)
	@$(call shader-as,$(foreach file,$(shell cat $<),$(dir $<)$(file)))
	@$(call shader-as,$<)

-include $(DEPENDS)

#---------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------
