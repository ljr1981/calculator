note
	description: "[
		Abstract notion of a Calculation Item.
		]"
	synopsis: "[
		The {CALC_ITEM} is recursive. You may treat it as either
		]"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	CALC_ITEM

feature -- Access

	value: STRING
			-- `value' as a STRING, which can be converted to {NUMERIC}.
		deferred
		end

end
