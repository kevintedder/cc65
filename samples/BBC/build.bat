@cls

rem Check to see if and new library modules need to be updated
@echo #====================================
@echo Make Libsrc
@pushd ..\..\libsrc
@rem make clean
@make
@popd


@echo #====================================
@echo Make Sideways Rom
@make -r all

@rem  copy ROM image to BEEBEM folder
copy swr.rom  C:\Users\kevin\Documents\BeebEm\BeebFile\sideways_rom.rom
