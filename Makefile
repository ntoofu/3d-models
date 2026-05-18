FILAMENT ?= pla

PRINTER_PROFILE = profiles/printer.ini
FILAMENT_PROFILE = profiles/filament_$(FILAMENT).ini

# Usage:
#   make path/to/model.gcode slice            # PLA (default)
#   make FILAMENT=petg path/to/model.gcode    # PETG
#   make path/to/model.gcode+support          # with support
#   make -B path/to/model.gcode+brim+support  # force re-slicing with brim & support

FLAGS ?=
MODEL ?= model.stl

.PHONY:
%+support: OPT_FLAGS+= --support-material
%+support: %
	@echo "Enable support material"

.PHONY:
%+brim: OPT_FLAGS+= --load option_brim.ini
%+brim: %
	@echo "Enable brim"

.PHONY:
%+skirt: OPT_FLAGS+= --load option_skirt.ini
%+skirt: %
	@echo "Enable skirt"

%.stl: %.scad
	openscad -o $@ $<

.SECONDARY:
%.gcode: %.stl
	prusa-slicer --export-gcode --load $(PRINTER_PROFILE) --load $(FILAMENT_PROFILE) --output $@ $(OPT_FLAGS) $(FLAGS) $<