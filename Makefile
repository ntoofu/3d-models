PROFILE = profiles/custom.def.json

# Usage:
#   make MODEL=path/to/model.stl slice          # without support
#   make MODEL=path/to/model.stl slice-support  # with support

MODEL ?= model.stl

.PHONY: slice slice-support

slice:
	CuraEngine slice -j $(PROFILE) -d profiles -l $(MODEL) -o $(MODEL:.stl=.gcode)

slice-support:
	CuraEngine slice -j $(PROFILE) -d profiles -l $(MODEL) -o $(MODEL:.stl=-support.gcode) \
		-s support_enable=true
