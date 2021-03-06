# BCH 709 Lecture notes: Week 12, part 1

_November 13, 2018_
When you arrive:

- Open our Gitter chatroom
- Find and use the link to open _these_ notes
- Open Rstudio on your laptops

---
## Today: R - data manipulation, ggplot

I've slightly modified a data carpentry lesson on R for social scientists for our work on getting started, installing packages, loading packages, and importing data using R today. The exact kinds of data tables are less important today, than having the lesson flow well, and I liked the way the R for Social Scientists folks put theirs together best. [Original lessons found here](https://datacarpentry.org/r-socialsci/), but don't use this. It lacks my changes that ensure the data is available).

Today we'll continue on where we left off with the modified Data Carpentry R for Social Science lessons. If there is more time after that, we will re-visit the methods used in Greg Martin's R video, aiming to recreate his results and improve the style for clarity, rather than speed.

### Very useful links

- 3 installation methods instructions: [https://github.com/rltillett/bch-709/blob/master/R_three_installs.md](https://github.com/rltillett/bch-709/blob/master/R_three_installs.md)
- R for Social Scientists, formatted and forked (modified) lesson [https://rltillett.github.io/r-socialsci/](https://rltillett.github.io/r-socialsci/)
   - Repo containing raw files for lesson [https://github.com/rltillett/r-socialsci/tree/gh-pages/files/](https://github.com/rltillett/r-socialsci/tree/gh-pages/files/)
   - Specific raw data file needed for data import instructions [https://raw.githubusercontent.com/rltillett/r-socialsci/gh-pages/files/SAFI_clean.csv](https://raw.githubusercontent.com/rltillett/r-socialsci/gh-pages/files/SAFI_clean.csv)
- Chapter in R for Data Science: [Data import](https://r4ds.had.co.nz/data-import.html)
- Greg Martin's R intro youtube video [https://youtu.be/ANMuuq502rE](https://youtu.be/ANMuuq502rE)
   - An R script revisiting Dr. Martin's tutorial, with explanations and alternative methods I prefer [https://github.com/rltillett/bch-709/blob/master/greg.R](https://github.com/rltillett/bch-709/blob/master/greg.R)
---

## Appendix I: Shell Commands & concepts reference

### Data Carpentry's Introducing the Shell (Shell Genomics 01), Navigating Files and Directories (Shell Genomics 02), (Shell Genomics 03) cheatsheet

- Here's the Home page for all their "Shell genomics lessons" [Data Carpentry Shell Genomics](https://datacarpentry.org/shell-genomics/)
   - (https://datacarpentry.org/shell-genomics/01-introduction/index.html)
   - (https://datacarpentry.org/shell-genomics/02-the-filesystem/index.html)
   - (https://datacarpentry.org/shell-genomics/03-working-with-files/index.html)

The lessons introduced these commands and concepts

- shell commands
   - `clear` _clears the screen_
   - `pwd` _print working directory (your current dir)_
   - `ls` _list (stuff)_
   - `cd` _change directory_
   - `man` _manual pages for commands/software_
   - `history` _view your recent commands_
   - `echo` _print specified text out to the screen_
   - `cat` _print contents of a file out to the screen_
   - `less` _view, scroll through, & search contents of file_
   - `head` and `tail` _print the first and last n lines of file_
   - `cp` _copy a file_
   - `mv` _move (and rename) files_
   - `mkdir` _make directory_
   - `chmod` _change mode (set file permissions)_
   - `rm` _remove file permanently_
   - `grep`
   - `wc`
   - `cut`
   - `sort`
   - `uniq`
- concepts / features
   - modifying your prompt
      - by setting shell variable `PS1` with this statement: `PS1='$ '`
      - revert this modification is to log out and back in.
   - command can use options & flags
      - `ls -F`
      - using `man` to discover options & syntax
   - tab completion
      - type the first few letters of a command, folder or file to let the OS finish it. Saves typing and ensures that file exists & reduces typos
      - type a few characters and hit tab twice to be shown all possible matches if those characters aren't 100% unique for one file/folder/command
   - paths
      - full paths _(these always start with a `/` and are the full description of a file or folder's location, starting from the root dir)_
      - relative paths _(these never start with a `/` and specify a file or folder in relation to the current working directory)_
   - shell shorthand for paths
      - the `..` or `../` shorthand for "up one folder"
      - the `/` symbol, which means "root" when at the front of a path (or as the entire path, as in `cd /`)
      - the `~` shorthand for "my home folder"
   - hidden files
      - discoverable via `ls -a`
   - the `*` wildcard
   - CTRL shortcuts
   - CTRL-C (clear current command line AND kill running command)
   - CTRL-R (reverse-search of history)
   - CTRL-L (same as `clear`)
   - file permissions
   - redirection
      - redirection command output to a file with the `>` command (operator)
      - append-redirect to file with the `>>` command (operator)
      - piping data from program1 to program2 directly using `|`

---

## Appendix II

### Logging in to our remote server (*reminder*)

#### Mac OS and linux

Interface with the remote server will be done with an app named Terminal, already on your system, with a command similar to

`ssh yourNetId@134.197.51.225`

#### Windows

Use putty to get an ssh-like terminal login.
get putty here: (https://www.putty.org)

We will `ssh` into a server by its IP address `134.197.51.225` (though `ws-3-0-5.biochem.unr.edu` may work for some)

Also see these instructions (with modifications for our server's name/number):
 (https://github.com/UNR-HPC/pronghorn/wiki/1.0-Connecting-to-Pronghorn), Note that we will be using the name of our server instead, wherever these  instructions say `pronghorn`.

## Appendix III Tips for using tmux

- Using the `tmux` command to avoid headaches
   - `tmux` to launch a "terminal multiplexer" and intercept HUP(hangup) signals that might otherwise interrupt work when you close your laptop or lose internet
   - use any time a bioinformatics command/tool/workflow/whatever might run longer than a few minutes (or as soon as you log in to server is generally fine)
   - you should always use `tmux list-sessions` or `tmux ls` to see if you have any old tmux sessions running on a server
   - use `tmux attach` or `tmux a` to re-connect to an old session. i.e. `tmux a -t 0` to reconnect to a session "session 0" (known to you because you ran `tmux list-sessions` moments before)
   - easily/safely kill old sessions by re-attaching to them `tmux a -t <name or number>` and then issuing the `exit` command once re-connected and satisfied that whatever you were doing before is good and done.
   - `exit` is another Unix command, and it does what you'd guess -- logs out the session you're running at that moment. Inside of a tmux session, running `exit` detaches and turns off that tmux session, leaving you back in a normal terminal window.

## Appendix III Copying and Pasting
This is honestly harder than it should be. Blame stubborn geniuses from the '80s for this one...

### On OSX laptops (and the OSX terminal)

OSX Case 1: works all the time

   1. Highlight the text you want to copy from any program
   2. Copy it with "Command+C" `⌘ C`
   3. Paste it wherever you want with "Command+V" `⌘ V`

### On linux laptops (and the linux terminal)

Linux Case 1: copying from a webpage or document; pasting into the Terminal

   1. Highlight the text you want to copy
   2. Copy it with "Control+C" `Ctrl C`
   3. To paste into the terminal, "Control+Shift+V"

Linux Case 2: copying from terminal; pasting somewhere not-a-Terminal
   1. Highlight the text you want to copy in the terminal
   2. **CAREFULLY** Copy it with "Control+Shift+C"
   3. Paste it into a document (not a terminal) with "Control+V" `Ctrl V`

### On Windows machines (extra weird, of course)

Windows Case 1: copying from a webpage/document to Putty

   1. In the document, highlight the text you want to copy
   2. Copy it with "Control+C" `Ctrl C`
   3. In Putty, simply right-click your mouse/trackpad to paste

Windows Case 2: copying from Putty to a document

   1. Highlight the text in Putty
   2. (no need to copy. Putty automatically puts highlighted text on the clipboard)
   3. Paste it into a document (not Putty) with "Control+V" `Ctrl V`

Windows Case 3: copying from Putty to CMD.EXE (e.g. for pasting pieces of a pscp command)

   1. Highlight the text in Putty
   2. (It gets added to the clipboard automatically)
   3. System Menu > Edit > Paste (this way works on Win 7, 8, 10)

Windows Case 4: copying from CMD.EXE to Putty (e.g. for pasting pieces _from_ a pscp command into some command you're re-writing to run on our server)

   1. Highlight the text in CMD.EXE
   2. System Menu > Edit > Copy (this way works on Win 7, 8, 10)
   3. In Putty, just right-click to paste, just like in Windows Case 2.
