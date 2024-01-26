import os
import subprocess
import sys

artist = sys.argv[1]
album = sys.argv[2]


def removeLeadingName(trackTitle, artist, album):
    if len(trackTitle.split("-")) > 1:
        firstIndex = trackTitle.split("-")[0].strip().casefold()
        if firstIndex == artist.casefold() or firstIndex == album.casefold():
            trackTitle = trackTitle.split("-")
            trackTitle.pop(0)
            trackTitle = "".join(trackTitle).strip()
    return trackTitle


albumDir = os.path.expanduser(f"~/Music/{artist}/{album}")
for song in sorted(os.listdir(albumDir)):
    # track number
    trackNumber = song.split("<<>>")[0]

    # title
    trackTitle = os.path.splitext(song)[0].split("<<>>")[1].strip()
    trackTitle = removeLeadingName(trackTitle, artist, album)

    # absolute path to file
    trackPath = os.path.join(albumDir, song)

    # set the metadata using kid3-cli
    subprocess.run([
        "kid3-cli",
        "-c", f'set track "{trackNumber}"',
        "-c", f'set title "{trackTitle}"',
        "-c", f'set artist "{artist}"',
        "-c", f'set album "{album}"',
        trackPath
    ])
