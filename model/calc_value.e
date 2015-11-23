note
	description: "[
		Representation of a Calculation Value as a type of Calculation Item.
		]"
	synopsis: "[
		The {CALC_VALUE} will be a string that can be represented
		as some numberic value.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	CALC_VALUE

inherit
	CALC_ITEM
		redefine
			value
		end

create
	make_with_string,
	make_with_engine

feature {NONE} -- Initialization

	make_with_engine (a_engine: like engine)
			-- `make_with_engine' `a_engine'.
		do
			engine := a_engine
		ensure
			engine_set: engine ~ a_engine
			parenthetical: is_parenthetical
		end

	make_with_string (a_value: like value)
			-- `make_with_string' `a_value'.
		do
			value := a_value
		end

feature -- Access

	value: STRING
			-- <Precursor>
		attribute
			if attached engine as al_engine then
				al_engine.evaluate
				check has_last_result: attached al_engine.last_result as al_last_result then
					Result := al_last_result.out
				end
			else
				create Result.make (20)
			end
		end

	engine: detachable CALC_ENGINE
			-- `engine' of Current {CALC_EXPRESSION}.

feature -- Status Report

	is_parenthetical: BOOLEAN
			-- Does Current {CALC_ITEM} have an attached `engine'?
		do
			Result := attached engine
		end

end
