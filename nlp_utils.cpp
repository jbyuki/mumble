#include "nlp_utils.h"

auto tokenize(const std::string& s) -> std::vector<std::string>
{
	std::vector<std::string> words;
	std::string word;
	for(char c : s) {
		if(std::isspace(c)) {
			if(word.size() > 0) {
				words.push_back(word);
				word = "";
			}
		} else {
			word += c;
		}
	}
	if(word.size() > 0) {
		words.push_back(word);
		word = "";
	}
	return words;
}


