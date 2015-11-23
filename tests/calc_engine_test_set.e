note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	CALC_ENGINE_TEST_SET

inherit
	EQA_TEST_SET

	EQA_COMMONLY_USED_ASSERTIONS
		rename
			assert as common_assert
		undefine
			default_create
		end

feature -- Test routines

	calc_engine_test
			-- {CALC_ENGINE} test.
		note
			testing: "covers/{CALC_ENGINE}.add_value_as_string",
						"covers/{CALC_ENGINE}.add_plus_instruction",
						"covers/{CALC_ENGINE}.remove_last_entry",
						"covers/{CALC_ENGINE}.add_value_entry",
						"covers/{CALC_ENGINE}.is_empty_or_last_added_is_instruction",
						"covers/{CALC_ENGINE}.add_instruction",
						"covers/{CALC_VALUE}.make_with_string",
						"covers/{CALC_INSTRUCTION}.make_plus"
		local
			l_eng: CALC_ENGINE
		do
			create l_eng
			l_eng.add_value_as_string ("1")
			l_eng.add_plus_instruction
			l_eng.add_value_as_string ("2")
			assert_equal ("has_3_items", 3, l_eng.entry_count)
			assert_equal ("is_digit_1", "1", l_eng.top_entry.value)
			l_eng.remove_last_entry
			assert_equal ("has_2_items", 2, l_eng.entry_count)
			assert_equal ("is_digit_+", "+", l_eng.top_entry.value)
			l_eng.remove_last_entry
			assert_equal ("has_1_items", 1, l_eng.entry_count)
			assert_equal ("is_digit_2", "2", l_eng.top_entry.value)
		end

	decimal_test
			-- Test to ensure engine can take decimals.
		do
			(create {CALC_ENGINE}).add_value_as_string ("0.0")
		end

	calc_engine_evaluate_test
			-- {CALC_ENGINE}.evaluate test.
		note
			testing: "covers/{CALC_ENGINE}.add_value_as_string",
						"covers/{CALC_ENGINE}.add_plus_instruction",
						"covers/{CALC_ENGINE}.add_multiply_instruction",
						"covers/{CALC_ENGINE}.add_divide_instruction",
						"covers/{CALC_ENGINE}.add_minus_instruction",
						"covers/{CALC_ENGINE}.add_instruction",
						"covers/{CALC_ENGINE}.evaluate",
						"covers/{CALC_ENGINE}.last_result",
						"covers/{CALC_ENGINE}.add_value_entry",
						"covers/{CALC_ENGINE}.is_empty_or_last_added_is_instruction",
						"covers/{CALC_ENGINE}.last_instruction",
						"covers/{CALC_ENGINE}.registers",
						"covers/{CALC_ENGINE}.reset",
						"covers/{CALC_INSTRUCTION}.make_plus",
						"covers/{CALC_INSTRUCTION}.Divide",
						"covers/{CALC_INSTRUCTION}.Minus",
						"covers/{CALC_INSTRUCTION}.Multiply",
						"covers/{CALC_INSTRUCTION}.Plus",
						"covers/{CALC_INSTRUCTION}.value",
						"covers/{CALC_VALUE}.make_with_string"
		local
			l_eng: CALC_ENGINE
		do
			create l_eng
			l_eng.add_value_as_string ("1")
			l_eng.add_plus_instruction
			l_eng.add_value_as_string ("2")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_3", {REAL_32} 3.0, al_last_result)
			end
			l_eng.reset_all
			l_eng.add_value_as_string ("1024")
			l_eng.add_plus_instruction
			l_eng.add_value_as_string ("1024")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_2_048", {REAL_32} 2_048.0, al_last_result)
			end
			l_eng.reset_all
			l_eng.add_value_as_string ("1024")
			l_eng.add_multiply_instruction
			l_eng.add_value_as_string ("1024")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_1_048_576", {REAL_32} 1_048_576.0, al_last_result)
			end
			l_eng.reset_all
			l_eng.add_value_as_string ("1024")
			l_eng.add_divide_instruction
			l_eng.add_value_as_string ("1024")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_1", {REAL_32} 1.0, al_last_result)
			end
			l_eng.reset_all
			l_eng.add_value_as_string ("1024")
			l_eng.add_minus_instruction
			l_eng.add_value_as_string ("1024")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_0", {REAL_32} 0.0, al_last_result)
			end
		end

	complex_calc_test
		local
			l_eng: CALC_ENGINE
		do
			create l_eng
			-- 45+21.32*56=5.92143
			l_eng.add_value_as_string ("45")
			l_eng.add_plus_instruction
			l_eng.add_value_as_string ("21.32")
			l_eng.add_multiply_instruction
			l_eng.add_value_as_string ("56")
			l_eng.evaluate
			check attached l_eng.last_result as al_result then
				assert_equal ("3_713.92", {REAL_32} 3713.92, al_result)
			end
		end

	calc_engine_evaluate_incomplete_test
			-- {CALC_ENGINE}.evaluate with incomplete values and instructions test.
		note
			testing: "covers/{CALC_ENGINE}.add_value_as_string",
						"covers/{CALC_ENGINE}.evaluate",
						"covers/{CALC_ENGINE}.last_result"
		local
			l_eng: CALC_ENGINE
		do
			create l_eng
			l_eng.add_value_as_string ("1")
			l_eng.evaluate
			check has_result: attached {NUMERIC} l_eng.last_result as al_last_result then
				assert_equal ("answer_is_1", {REAL_32} 1.0, al_last_result)
			end
		end

	paren_test
			-- Test of parenthetical engines.
		note
			testing: "covers/{CALC_ENGINE}.add_value_as_string",
						"covers/{CALC_ENGINE}.add_plus_instruction",
						"covers/{CALC_ENGINE}.add_engine_entry",
						"covers/{CALC_ENGINE}.evaluate",
						"covers/{CALC_ENGINE}.last_result",
						"covers/{CALC_VALUE}.make_with_engine"
		local
			l_eng_1,
			l_eng_2,
			l_eng_3: CALC_ENGINE
		do
			create l_eng_3
			l_eng_3.add_value_as_string ("150")

			create l_eng_2
			l_eng_2.add_value_as_string ("100")
			l_eng_2.add_plus_instruction
			l_eng_2.add_value_as_string ("200")
			l_eng_2.add_plus_instruction
			l_eng_2.add_engine_entry (create {CALC_VALUE}.make_with_engine (l_eng_3))

			create l_eng_1
			l_eng_1.add_value_as_string ("1")
			l_eng_1.add_plus_instruction
			l_eng_1.add_engine_entry (create {CALC_VALUE}.make_with_engine (l_eng_2))

			l_eng_1.evaluate
			check has_result: attached {NUMERIC} l_eng_1.last_result as al_last_result then
				assert_equal ("answer_is_451", {REAL_32} 451.0, al_last_result)
			end
		end

end


