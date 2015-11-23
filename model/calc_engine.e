note
	description: "[
		Representation of a Calculator Engine.
		]"
	synopsis: "[
		The calculator engine is responsible for applying math instructions
		to two or more numeric values. It contains a `registers' item, which is a
		FIFO queue of values and instructions. These are usually entered in
		the sequence of [value]-[instruction]-[value]-... and so on.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	CALC_ENGINE

feature -- Access

	last_result: detachable NUMERIC
			-- What is the `last_result' computed by `evaluate'?

	last_instruction: detachable CHARACTER
			-- What is the `last_instruction' used in `evaluate'?

	top_entry: CALC_ITEM
			-- What is the `top_entry' of `registers' queue?
		do
			Result := registers.item
		end

	last_added_entry: detachable CALC_ITEM
			-- What is the `last_added_entry', if added?

feature -- Add Values

	add_value_as_string (a_value_string: STRING)
			-- `add_value_as_string' with `a_value_string'.
		require
			empty_or_instruction: is_empty_or_last_added_is_instruction
		do
			add_value_entry (create {CALC_VALUE}.make_with_string (a_value_string))
		end

	add_value_entry (a_value: CALC_VALUE)
			-- `add_value_entry' `a_value' to `registers'.
		require
			empty_or_instruction: is_empty_or_last_added_is_instruction
		do
			last_added_entry := a_value
			registers.force (a_value)
		ensure
			forced: registers.has (a_value)
			has_last_added_entry: attached {CALC_VALUE} last_added_entry
		end

	add_engine_entry (a_value: CALC_VALUE)
			-- `add_engine_entry' where `a_value' `is_parenthetical'.
		require
			is_parenthetical: a_value.is_parenthetical
		do
			add_value_entry (a_value)
		end

feature -- Add Instructions

	add_plus_instruction
			-- `add_plus_instruction' instruction to `registers'.
		do
			add_instruction (create {CALC_INSTRUCTION}.make_plus)
		end

	add_minus_instruction
			-- `add_minus_instruction' instruction to `registers'.
		do
			add_instruction (create {CALC_INSTRUCTION}.make_minus)
		end

	add_multiply_instruction
			-- `add_multiply_instruction' instruction to `registers'.
		do
			add_instruction (create {CALC_INSTRUCTION}.make_multiply)
		end

	add_divide_instruction
			-- `add_divide_instruction' instruction to `registers'.
		do
			add_instruction (create {CALC_INSTRUCTION}.make_divide)
		end

feature -- Status Report

	is_empty_or_last_added_is_instruction: BOOLEAN
			-- `is_empty_or_last_added_is_instruction'?
		do
			Result := (entry_count = 0) or (attached {CALC_INSTRUCTION} last_added_entry)
		end

	has_entries: BOOLEAN
		do
			Result := registers.count > 0
		end

	entry_count: like registers.count
			-- `entry_count' of `registers'.
		do
			Result := registers.count
		end

feature -- Basic Operations

	evaluate
			-- `evaluate' `registers'.
		local
			i: INTEGER
		do
			reset
			last_result := 0.0
			from
				i := registers.count
			until
				i = 0
			loop
				if attached {CALC_VALUE} registers.item as al_value then
					check attached_last_result: attached last_result as al_last_result then
						inspect
							last_instruction
						when {CALC_INSTRUCTION}.Plus then
							last_result := al_last_result + al_value.value.to_real
						when {CALC_INSTRUCTION}.Minus then
							last_result := al_last_result - al_value.value.to_real
						when {CALC_INSTRUCTION}.Multiply then
							last_result := al_last_result * al_value.value.to_real
						when {CALC_INSTRUCTION}.Divide then
							last_result := al_last_result / al_value.value.to_real
						else
							last_result := al_value.value.to_real
						end
					end
				elseif attached {CALC_INSTRUCTION} registers.item as al_instruction then
					check at_least_one: al_instruction.value.count = 1 then
						last_instruction := al_instruction.value [1]
					end
				else
					check unknown_CALC_ITEM: False end
				end
				registers.remove
				i := i - 1
			variant
				i
			end
		ensure
			has_result: attached {NUMERIC} last_result
		end

	remove_last_entry
			-- `remove_last_entry' in `registers'.
		do
			registers.remove
		end

	remove_all_entries
			-- `remove_all_entries' in `registers'.
		do
			registers.wipe_out
		end

	reset
			-- `reset' of `last_result', `last_added_entry' and `last_instruction'.
		do
			last_result := Void
			last_instruction := Void_instruction
			last_added_entry := Void
		ensure
			no_result: not attached last_result
			no_instruction: last_instruction ~ Void_instruction
			no_added: not attached last_added_entry
		end

	reset_all
			-- `reset_all' on Current {CALC_ENGINE}.
		do
			reset
			remove_all_entries
		end

feature {NONE} -- Implementation

	add_instruction (a_instruction: CALC_INSTRUCTION)
			-- `add_instruction' `a_instruction' to `registers'.
		require
			last_added_entry_is_value: attached {CALC_VALUE} last_added_entry
		do
			last_added_entry := a_instruction
			registers.force (a_instruction)
		ensure
			has_last_added_instruction: attached {CALC_INSTRUCTION} last_added_entry
		end

	registers: LINKED_QUEUE [CALC_ITEM]
			-- FIFO queued `registers' of {CALC_VALUE} and {CALC_INSTRUCTION} items.
		attribute
			create Result.make
		end

feature {NONE} -- Implementation: Constants

	Void_instruction: CHARACTER = '%U'
			-- Notion of a `Void_instruction' character.

end
