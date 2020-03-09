#include <iostream>
#include <string>
#include <sstream>

#include <fstream>

#include <vector>

#include "nlp_utils.h"
#include <set>

#include <iterator>

#include <algorithm>

#include <cmath>


auto word2index(const std::vector<std::string>& words) -> std::vector<size_t>;

auto similarity_score(const std::vector<size_t>& w1, const std::vector<size_t>& w2) -> float;

std::vector<std::string> dictionary;

auto word2index(const std::vector<std::string>& words) -> std::vector<size_t>
{
	std::vector<size_t> indices;
	for(const auto& word : words) {
		auto it = std::find(dictionary.begin(), dictionary.end(), word);
		if(it == dictionary.end()) {
			indices.push_back(dictionary.size());
			dictionary.push_back(word);
		} else {
			indices.push_back(std::distance(dictionary.begin(), it));
		}
	}

	return indices;
}

auto similarity_score(const std::vector<size_t>& w1, const std::vector<size_t>& w2) -> float
{
	std::vector<size_t> intersection;

	std::set_intersection(
			w1.begin(), w1.end(), 
			w2.begin(), w2.end(), 
			std::back_inserter(intersection));

	float c1 = (float)intersection.size();
	float l1 = (float)w1.size();
	float l2 = (float)w2.size();

	return c1 / (std::logf(l1) + std::logf(l2));
}


auto main(int argc, char* argv[]) -> int
{
	if(argc < 3) {
		std::cerr << "ERROR: Not enough arguments!" << std::endl;
		return EXIT_FAILURE;
	}
	
	std::string filename = argv[1];
	std::istringstream iss(argv[2]);
	size_t line_ref;
	iss >> line_ref;
	
	if(iss.fail()) {
		std::cerr << "ERROR: Second argument must be integer!" << std::endl;
		return EXIT_FAILURE;
	}
	
	std::ifstream in(filename);
	if(!in.is_open()) {
		std::cerr << "ERROR: Could not open " << filename << "!" << std::endl;
		return EXIT_FAILURE;
	}
	
	std::vector<std::string> lines;
	std::string line;
	
	while(std::getline(in, line)) {
		lines.push_back(line);
	}
	
	std::vector<std::vector<size_t>> line_words;
	for(const auto& l : lines) {
		auto v = word2index(tokenize(l));
		std::sort(v.begin(), v.end());
		auto last = std::unique(v.begin(), v.end());
		v.erase(last, v.end());
		line_words.emplace_back(v);
	}
	
	if(line_ref < 0 || line_ref >= line_words.size()) {
		std::cerr << "ERROR: Second argument line number " << line_ref << " is not in file number range [0, " << lines.size() << "[" << std::endl;
		return EXIT_FAILURE;
	}
	
	if(line_words[line_ref].size() == 0) {
		std::cerr << "ERROR: Line number " << line_ref << " is empty!" << std::endl;
		return EXIT_FAILURE;
	}
	
	std::vector<float> scores;
	for(size_t i=0; i<line_words.size(); ++i) {
		if(i == line_ref) {
			continue;
		}
		scores.push_back(similarity_score(line_words[i], line_words[line_ref]));
	}
	
	auto best_score = std::max_element(scores.begin(), scores.end());
	std::cout << std::distance(scores.begin(), best_score) << std::endl;
	return 0;
}

