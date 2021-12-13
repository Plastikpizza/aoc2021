#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <set>
#include <list>
#include <utility>

int main(int argc, char** argv) {
    using namespace std;
    std::ifstream file("input.txt");
    std::string line;
    set<pair<int,int>> field;
    list<pair<char, int>> foldings;
    bool readingPoints = true;
    bool firstRound = true;
    while(!file.eof()) {
        getline(file, line);
        if (line == "") {
            readingPoints = false;
            continue;
        }
        if (readingPoints) {
            int i = 0;
            for (; line[i]!=',' && i < line.length(); i++){}
            int x = atoi(line.substr(0,i).c_str());
            int y = atoi(line.substr(i+1, line.length()).c_str());
            field.insert(pair<int, int>(x,y));
        } else {
            int i = 0;
            for (; line[i]!='=' && i < line.length(); i++){}
            foldings.push_back(pair<char, int>(line[i-1], 
                atoi(line.substr(i+1, line.length()).c_str())));
        }
    }
    for (pair<char, int> folding : foldings) {
        set<pair<int,int>> toBeMoved;
        for (pair<int, int> dot : field) {
            if (folding.first == 'y') {
                if (dot.second > folding.second) {
                    toBeMoved.insert(dot);
                }
            }
            if (folding.first == 'x') {
                if (dot.first > folding.second) {
                    toBeMoved.insert(dot);
                }
            }
        }
        for (pair<int, int> dot : toBeMoved) {
            field.erase(dot);
            if (folding.first == 'y') {
                field.insert(pair<int, int>(dot.first, folding.second - (dot.second - folding.second)));
            }
            if (folding.first == 'x') {
                field.insert(pair<int, int>(folding.second - (dot.first - folding.second), dot.second));
            }
        }
        if (firstRound) {
            cout << "part 1: " << field.size() << endl;
            firstRound = false;
        }
    }
    cout << "part 2: " << endl;
    for (int y = 0; y < 6; y++) {
        for (int x = 0; x < 80; x++) {
            if(field.find(pair<int, int>(x,y)) != field.end()) {
                cout << "#";
            } else {
                cout << " ";
            }
        }
        cout << endl;
    }
    return 0;
}