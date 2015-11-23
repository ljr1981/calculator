note
	description: "[
		Representation of a Mock Window to test {CALC_DISPLAY}.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	MOCK_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
		do
			create engine
			create display.make_with_engine (engine)
			Precursor
		end

	initialize
		do
			extend (display.widget)
			Precursor
		end

feature {NONE} -- Implementation

	display: CALC_DISPLAY

	engine: CALC_ENGINE

end
