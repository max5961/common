import csv
import sys
import os

artist = sys.argv[1]
album = sys.argv[2]
URL = sys.argv[3]

csvLog = os.path.expanduser("~/environment/scripts/python/albumdl/dl-log.csv")

with open(csvLog, mode = "r+", newline = "") as file:
    isAlreadyLogged = False
    for row in csv.reader(file):
        if URL in row:
            isAlreadyLogged = True
    
    if not isAlreadyLogged:
        csv.writer(file).writerow([artist, album, URL])
