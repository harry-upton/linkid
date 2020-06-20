# linkid
Creates a reference ID that points to a link/file location.

ID's are in the format 'aaaa' (4 lowercase letters).

The initial use for this was to provide a 4 digit code that could be put in paper notes so that you could reference a website, file on your computer etc, without writing out a full URL.

By default the links.csv file is stored in $HOME/.config/linkid/links, you will need to create this file manually and add a first entry which should look like: aaaa,(something doesn't matter what).

Programs used: grep, sed, tail
