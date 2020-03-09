@*=
@includes

@functions
@global_variables
@define_functions

auto main(int argc, char* argv[]) -> int
{
	@read_arguments
	@open_file
	@read_file
	@tokenize_sentences
	@check_line_ref_in_range
	@compute_scores
	@output_most_similar_sentence
	return 0;
}

@includes=
#include <iostream>
#include <string>
#include <sstream>

@read_arguments=
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

@includes+=
#include <fstream>

@open_file=
std::ifstream in(filename);
if(!in.is_open()) {
	std::cerr << "ERROR: Could not open " << filename << "!" << std::endl;
	return EXIT_FAILURE;
}

@includes+=
#include <vector>

@read_file=
std::vector<std::string> lines;
std::string line;

while(std::getline(in, line)) {
	lines.push_back(line);
}

@includes+=
#include "nlp_utils.h"
#include <set>

@functions=
auto word2index(const std::vector<std::string>& words) -> std::vector<size_t>;

@global_variables=
std::vector<std::string> dictionary;

@includes+=
#include <iterator>

@define_functions=
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

@includes+=
#include <algorithm>

@tokenize_sentences=
std::vector<std::vector<size_t>> line_words;
for(const auto& l : lines) {
	auto v = word2index(tokenize(l));
	std::sort(v.begin(), v.end());
	auto last = std::unique(v.begin(), v.end());
	v.erase(last, v.end());
	line_words.emplace_back(v);
}

@check_line_ref_in_range=
if(line_ref < 0 || line_ref >= line_words.size()) {
	std::cerr << "ERROR: Second argument line number " << line_ref << " is not in file number range [0, " << lines.size() << "[" << std::endl;
	return EXIT_FAILURE;
}

if(line_words[line_ref].size() == 0) {
	std::cerr << "ERROR: Line number " << line_ref << " is empty!" << std::endl;
	return EXIT_FAILURE;
}

@functions+=
auto similarity_score(const std::vector<size_t>& w1, const std::vector<size_t>& w2) -> float;

@includes+=
#include <cmath>

@define_functions+=
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

@compute_scores=
std::vector<float> scores;
for(size_t i=0; i<line_words.size(); ++i) {
	if(i == line_ref) {
		continue;
	}
	scores.push_back(similarity_score(line_words[i], line_words[line_ref]));
}

@output_most_similar_sentence=
auto best_score = std::max_element(scores.begin(), scores.end());
std::cout << std::distance(scores.begin(), best_score) << std::endl;
