note
	description: "[
		Representation of a Calculation Instruction as a type of Calculation Item.
		]"
	synopsis: "[
		The {CALC_INSTRUCTION} is an instruction operating on a {CALC_VALUE}.
		as some numberic value.
		]"
	date: "$Date: $"
	revision: "$Revision: $"

class
	CALC_INSTRUCTION

inherit
	CALC_ITEM

create
	make_plus,
	make_minus,
	make_multiply,
	make_divide

feature {NONE} -- Initialization

	make_plus
			-- `make_plus'.
		do
			make_with_operation (Plus)
		end

	make_minus
			-- `make_minus'.
		do
			make_with_operation (Minus)
		end

	make_multiply
			-- `make_multiply'.
		do
			make_with_operation (Multiply)
		end

	make_divide
			-- `make_divide'.
		do
			make_with_operation (Divide)
		end

	make_with_operation (a_op_character: CHARACTER_8)
			-- `make_with_operation' as `a_op_character' applied to `value'.
		do
			value := a_op_character.out
		end

feature -- Access

	value: STRING
			-- <Precursor>
		attribute
			create Result.make (20)
		end

	Plus: CHARACTER = '+'
			-- `Plus' constant.

	Minus: CHARACTER = '-'
			-- `Minus' constant.

	Multiply: CHARACTER = '*'
			-- `Multiply' constant.

	Divide: CHARACTER = '/'
			-- `Divide' constant.

feature {NONE} -- Implementation: Constants

	Operation_characters: STRING
			-- `Operation_characters' constant
		once
			create Result.make (4)
			Result.append_character (Plus)
			Result.append_character (Minus)
			Result.append_character (Multiply)
			Result.append_character (Divide)
		ensure
			four: Result.count = 4
		end

invariant
	numeric: value.count = 1 and then (attached value [1] as al_character and then Operation_characters.has (al_character))

end
