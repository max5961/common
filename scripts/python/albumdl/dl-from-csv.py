import csv
import sys
import subprocess

csvFile = sys.argv[1]

with open(csvFile, mode = "r") as file:
    for line in csv.reader(file):
        artist, album, URL = line
        subprocess.run(["albumdl", artist, album, URL])
    


