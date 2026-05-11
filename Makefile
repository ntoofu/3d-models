FILAMENT ?= pla

PRINTER_PROFILE = profiles/printer.ini
FILAMENT_PROFILE = profiles/filament_$(FILAMENT).ini

# Usage:
#   make MODEL=path/to/model.stl slice                    # PLA (default)
#   make MODEL=path/to/model.stl FILAMENT=petg slice      # PETG
#   make MODEL=path/to/model.stl slice-support            # with support

MODEL ?= model.stl

.PHONY: slice slice-support

slice:
	prusa-slicer --export-gcode --load $(PRINTER_PROFILE) --load $(FILAMENT_PROFILE) --output $(MODEL:.stl=.gcode) $(MODEL)

slice-support:
	prusa-slicer --export-gcode --support-material --load $(PRINTER_PROFILE) --load $(FILAMENT_PROFILE) --output $(MODEL:.stl=-support.gcode) $(MODEL)
