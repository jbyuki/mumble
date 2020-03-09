@nlp_utils.h=
#pragma once
@includes

@functions

@nlp_utils.cpp=
#include "nlp_utils.h"

@define_functions

@includes=
#include <string>
#include <vector>
#include <cctype>

@functions=
auto tokenize(const std::string& s) -> std::vector<std::string>;

@define_functions=
auto tokenize(const std::string& s) -> std::vector<std::string>
{
	std::vector<std::string> words;
	std::string word;
	for(char c : s) {
		if(std::isspace(c)) {
			@add_word_to_words
		} else if(std::ispunct(c)) {
		} else {
			word += std::tolower(c);
		}
	}
	@add_word_to_words
	return words;
}

@add_word_to_words=
if(word.size() > 0) {
	words.push_back(word);
	word = "";
}
