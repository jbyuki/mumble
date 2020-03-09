all: main.cpp nlp_utils.cpp nlp_utils.h

main.cpp: main.t; letangle.exe main.t > main.cpp
nlp_utils.cpp: nlp_utils.t; letangle.exe nlp_utils.t nlp_utils.cpp > nlp_utils.cpp
nlp_utils.h: nlp_utils.t; letangle.exe nlp_utils.t nlp_utils.h > nlp_utils.h
