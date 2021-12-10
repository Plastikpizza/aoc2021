from copy import copy
points = {")":3,"]":57,"}":1197,">":25137,"(":1,"[":2,"{":3,"<":4}
openerOf = {")":"(", "}":"{", ">":"<","]":"["}
with open("input.txt", "r") as file:
    data = file.read()
    data = data.split("\n")
score = 0
autocompleteScores = []
for line in data:
    stack = []
    ill = False
    for letter in line:
        if letter in "({[<":
            stack.append(letter)
        else:
            opener = stack.pop()
            if not opener == openerOf[letter]:
                score+=points[letter]
                ill = True
                stack.append(letter)
                break
    if not ill:
        stack.reverse()
        totalScore = 0
        for letter in stack:
            totalScore*=5
            totalScore+=points[letter]
        autocompleteScores.append(totalScore)
autocompleteScores.sort()
print(score)
print(autocompleteScores[len(autocompleteScores)//2])