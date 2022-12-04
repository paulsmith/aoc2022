import strutils

var most = 0
var tally = 0

for line in stdin.lines:
    if line == "":
        if tally > most:
            echo "new most: ", most
            most = tally
        else:
            echo "less than most: ", tally
        tally = 0
    else:
        tally += parseInt(line)
if tally > most:
    most = tally
echo most
