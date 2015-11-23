note
	description: "[
		Representation of a Mock Application.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	MOCK_APPLICATION

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			create application
			create window
			window.close_request_actions.extend (agent application.destroy)
			window.set_size (200, 300)
			application.post_launch_actions.extend (agent window.show)
			application.launch
		end

feature {NONE} -- Implementation

	application: EV_APPLICATION

	window: MOCK_WINDOW

end
