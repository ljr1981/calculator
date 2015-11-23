Calculator

This is an example of a simple calculator program written in Eiffel.

There are four essentail parts to look at:

1. MOCK_APPLICATION
2. MOCK_WINDOW
3. CALC_DISPLAY
4. CALC_ENGINE

MOCK_APPLICATION is the root class and procedure and has the Windows event loop from where the MOCK_WINDOW is launched.

MOCK_WINDOW has both a CALC_DISPLAY and a CALC_ENGINE.

CALC_DISPLAY is where all of the display complexity of the calculator is held.

CALC_ENGINE is where all of the calculations are. This class depends on a CALC_ITEM as the root type of "thing" which can participate in a calculation. From it descends CALC_VALUE and CALC_INSTRUCTION. See these classes for more information about what they are and what they do.

Please let me know if you have any questions. I will help as best I can.
