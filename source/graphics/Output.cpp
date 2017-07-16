#include "Output.h"

void Output::clear() {
	consoleClear();
}

void Output::print(std::string msg) {
	std::cout << msg << std::endl;
}

void Output::printAt(std::string text, int row, int column, int color) {
	column = (column < 0 || column > 50) ? 0 : column;
	row = (row < 0 || row > 50) ? 0 : row;
	std::stringstream ss;
	ss << "\x1b[" << row << ";" << column << "H";
	ss << "\x1b[" << color << "m"; // change the text cursor to specified color
	ss << text;
	ss << "\x1b[" << 37 << "m"; // reset the text cursor to white
	std::cout << ss.str() << std::endl;
}
