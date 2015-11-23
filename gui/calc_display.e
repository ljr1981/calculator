note
	description: "[
		Representation of a Calculator Display.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	CALC_DISPLAY

create
	make_with_engine

feature {NONE} -- Initialize

	make_with_engine (a_engine: like engine)
			-- Initialize Current {CALC_DISPLAY}.
		do
			engine := a_engine
			create readout
			create history
			history.set_minimum_height (Default_history_minimum_height)
		ensure
			engine_set: engine ~ a_engine
			minimum_set: history.minimum_height = Default_history_minimum_height
		end

feature -- Access

	widget: EV_TABLE
			-- A table `widget' for displaying Current {CALC_DISPLAY}.
		note
			synopsis: "[
				An {EV_TABLE} widget of 5 columns and 8 rows, with
				common calculator controls spread over the table as
				needed.
				]"
		do
			create Result
			Result.resize (5, 8) -- 5-cols, 8-rows

				-- Row: 1
			Result.put_at_position (readout, 								1, 1, 5, 1)
				-- Row: 2
			Result.put_at_position (button_with_text_and_actions ("9"), 	3, 2, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("8"), 	2, 2, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("7"), 	1, 2, 1, 1)
			Result.put_at_position (clear_button, 							5, 2, 1, 1)
				-- Row: 3
			Result.put_at_position (button_with_text_and_actions ("+"), 	5, 3, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("6"), 	3, 3, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("5"), 	2, 3, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("4"), 	1, 3, 1, 1)
				-- Row: 4
			Result.put_at_position (button_with_text_and_actions ("-"), 	5, 4, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("3"), 	3, 4, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("2"), 	2, 4, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("1"), 	1, 4, 1, 1)
				-- Row: 5
			Result.put_at_position (button_with_text_and_actions ("*"), 	5, 5, 1, 1)
			Result.put_at_position (button_with_text_and_actions ("0"), 	1, 5, 2, 1)
			Result.put_at_position (dot_button, 							3, 5, 1, 1)
				-- Row: 6
			Result.put_at_position (button_with_text_and_actions ("/"), 	5, 6, 1, 1)
			Result.put_at_position (equal_button, 							2, 6, 1, 1)
				-- Row: 7-8
			Result.put_at_position (history, 								1, 7, 5, 2)
		end

feature {NONE} -- Implementation

	engine: CALC_ENGINE
			-- Calculation `engine' ({CALC_ENGINE}) of Current {CALC_DISPLAY}

feature {NONE} -- Implementation: GUI Controls

	readout: EV_TEXT_FIELD
			-- GUI `readout' of Current {CALC_DISPLAY}.

	button_with_text_and_actions (a_button_text: STRING): EV_BUTTON
			-- A common `button_with_text_and_actions' based on `a_button_text'.
		require
			one_digit: a_button_text.count = 1
		do
			create Result.make_with_text_and_action (a_button_text, agent on_button_click (a_button_text [1]))
		end

	clear_button: EV_BUTTON
			-- `clear_button' of Current {CALC_DISPLAY}
		do
			Result := button_with_text_and_actions ("C")
		end

	dot_button: EV_BUTTON
			-- `dot_button' of Current {CALC_DISPLAY}
		do
			Result := button_with_text_and_actions (".")
		end

	equal_button: EV_BUTTON
			-- `equal_button' of Current {CALC_DISPLAY}
		do
			Result := button_with_text_and_actions ("=")
		end

	history: EV_TEXT

feature {NONE} -- Implementation: Basic Operations

	on_button_click (a_character: CHARACTER)
			-- What happens `on_button_click' when `a_character' is sent?
		do
			inspect
				a_character
			when '0' then
				display_and_add (a_character.out)
			when '1' then
				display_and_add (a_character.out)
			when '2' then
				display_and_add (a_character.out)
			when '3' then
				display_and_add (a_character.out)
			when '4' then
				display_and_add (a_character.out)
			when '5' then
				display_and_add (a_character.out)
			when '6' then
				display_and_add (a_character.out)
			when '7' then
				display_and_add (a_character.out)
			when '8' then
				display_and_add (a_character.out)
			when '9' then
				display_and_add (a_character.out)
			when '.' then
				if not readout.text.has (a_character) then
					display_and_add (a_character.out)
				end
			when '+' then
				handle_operation (a_character, agent engine.add_plus_instruction, No_evaluate_requested)
			when '-' then
				handle_operation (a_character, agent engine.add_minus_instruction, No_evaluate_requested)
			when '*' then
				handle_operation (a_character, agent engine.add_multiply_instruction, No_evaluate_requested)
			when '/' then
				handle_operation (a_character, agent engine.add_divide_instruction, No_evaluate_requested)
			when '=' then
				handle_operation (a_character, agent do_nothing, Evaluate_is_requested)
			when 'C' then
				readout.set_text ("")
				history.set_text ("")
				engine.reset_all
			else
				check unknown_character: False end
			end
		end

	handle_operation (a_character: CHARACTER; a_operation: PROCEDURE [ANY, TUPLE]; a_is_evaluate_requested: BOOLEAN)
			-- `handle_operation' (e.g. +, -, *, /, or =) based on `a_character'.
		require
			valid_op: ("+-*/=").has (a_character)
		do
			engine.add_value_as_string (readout.text)
			if a_is_evaluate_requested then
				engine.evaluate
			end
			if history.text.has_substring ("=") and No_evaluate_requested then
				engine.reset_all
				engine.add_value_as_string (readout.text)
			else
				readout.set_text ("")
			end
			history.append_text (" ")
			history.append_text (a_character.out)
			history.append_text (" ")
			if a_is_evaluate_requested then
				check has_result: attached engine.last_result as al_result then
					readout.set_text (al_result.out)
					history.append_text (al_result.out)
					history.append_text ("%N")
				end
			else
				a_operation.call ([Void])
			end
			history.scroll_to_end
		end

	display_and_add (a_char: STRING)
			-- `display_and_add' `a_char'.
		require
			has_one: a_char.count = 1
		do
			readout.set_text (readout.text + a_char)
			history.append_text (a_char)
			history.scroll_to_end
		ensure
			char_added: readout.text [readout.text.count] ~ a_char [1] and
						history.text [history.text.count] ~ a_char [1]
		end

feature {NONE} -- Implementation: Constants

	Default_history_minimum_height: INTEGER = 50
			-- `Default_history_minimum_height' for Current {CALC_DISPLAY}.

	Evaluate_is_requested: BOOLEAN = True
	No_evaluate_requested: BOOLEAN = False
			-- Evaluation constants.

invariant
	Evaluate_is_requested: Evaluate_is_requested
	No_evaluate_requested: not No_evaluate_requested

;end
