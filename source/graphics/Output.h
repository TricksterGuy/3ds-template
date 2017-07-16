#pragma once

#include "../main.h"

class Output {
public:
	static const int MAX_ROW = 29; // Maximum number of rows that can be displayed on either console.

	static void clear();
	static void print(std::string msg);

	/**
	 * Print some text at the specified position
	 *
	 * Supports CSI Codes. To move the cursor you have to print "\x1b[r;cH" before the string, where r and c are
	 * respectively the row and column where you want the cursor to move. The top screen has 30 rows and 50 columns.
	 * The bottom screen has 30 rows and 40 columns.
	 *
	 * @param text The text that is going to be displayed.
	 * @param row The column number of where the text will be displayed.
	 * @param column The row number of where the text will be displayed.
	 * @param color The color the text will be displayed as
	 *
	 * @see https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
	 */
	static void printAt(std::string text, int row, int column, int color = 37);
};
