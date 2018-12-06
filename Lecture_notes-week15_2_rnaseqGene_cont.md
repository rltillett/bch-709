# BCH 709 Lecture notes: Week 15, part 2

_December 6, 2018_
When you arrive:

- Open our Gitter chatroom
- Find and use the link to open _these_ notes
- Open Rstudio and the project and script from Tuesday

---

## Continuing the rnaseqGene workflow

We'll return to the rnaseqGene workflow for DESeq2 analysis.

- [http://master.bioconductor.org/packages/release/workflows/html/rnaseqGene.html](http://master.bioconductor.org/packages/release/workflows/html/rnaseqGene.html)
- Previously, we explored the data import methods, and we'll continue from there.
- After demoing how to add experiment information to a summarized experiment, the workflow will switch over to using a larger dataset as input.
- Then exploratory data analysis
- And finally, tests for differential gene expression

The material in this workflow is also presented in the following publication: (Lowe, et al 2016) [https://f1000research.com/articles/4-1070](https://f1000research.com/articles/4-1070)

There is also the main DeSeq2 vignette you might wish to consult, though it is not quite as user-friendly: [https://bioconductor.org/packages/3.8/bioc/vignettes/DESeq2/inst/doc/DESeq2.html](https://bioconductor.org/packages/3.8/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)


---
## Homework 9 (last homework, 30 points, due Dec 17th)

To learn more about PCA and other dimensional reductions, watch these two StatQuest videos:
- [The 5 minute version](https://www.youtube.com/watch?v=HMOI_lkzW08)
- [The 20 minute version, updated for 2018](https://www.youtube.com/watch?v=FgakZw6K1QQ)

**Question 1:** After watching those two videos, consider the way our rnaseqGene workflow describes PCA and the way the DESeq2 package's PCA function presents PCA results. Are there any potential dangers in data interpretation if we simply use the PCA as shown in our lesson (with no screeplot)?

Watch at least StatQuest video of your choice. [Here's a link to all his videos](https://www.youtube.com/playlist?list=PLblh5JKOoLUIcdlgu78MnlATeyx4cEVeR). You might wish to bookmark [his channel](https://www.youtube.com/channel/UCtYLUTtgS3k1Fg4y5tAhLbw) too.

**Question 2:** Which one did you watch? Paste in the link to that video too, please. Why did you pick it? What did you learn or like or desire to learn even more about? (just a few sentences is fine).

---

## Notes for the final:

Due date for final turn in is: **Weds Dec 19th.** Have you started? Are you stuck?

### Format

Your final project should be written, with your code, and possibly your figures added as supplemental files.

- Recycle your introduction if you wish, but add to it (at the end) a summary of your findings/results
- Methods: describe what you did, feel free to include or make reference to troubleshooting and alternate steps taken
- Results: I don't expect a full and total results section like you would submit for publication, but here is where your figures and tables "go" and where you talk about them, and about how your methods became your findings. You can be less formal than for a publication too (use of first-person not prohibited), especially if you did a lot of troubleshooting.
- Discussion: Discuss. What worked? What didn't? What next?


### Instructions

- Open a new session in Rstudio
   - name it rnaseqGene
- Do not make a new R script yet
- Instead, attempt to install the rnaseqGene workflow as given

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("rnaseqGene", version = "3.8")
```

This will take a while. Keep an eye open for it asking you `a/s/n?` or `yes/no` questions.

If you need a refresher on RNA-seq methodology basics, consult this video from StatQuest [https://youtu.be/tlf6wYJrwKY](https://youtu.be/tlf6wYJrwKY).

Once it is all installed, we then open up an R script or R notebook for the project, and we will follow along with this Bioconductor vignette [http://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html](http://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html).


### Not Today: B.A.D. Days of bioinformatics tutorials on R stats and visualizations

Now we're going to use and follow a tutorial on R with a bioinformatics focus, with elements of data viz, basic, and fairly advanced statistics. I've forked, and modified the materials from [https://bitsandchips.me/BAD_days/](https://bitsandchips.me/BAD_days/). Let's take a look at their site first.

We'll start from their "Day 1" lesson, which I've rebuilt for us to update the Bioconductor instructions and so the images don't 404 ERROR. Our copy of Day 1 is here: [https://rltillett.github.io/BAD_days/Day1/Tutorial.html](https://rltillett.github.io/BAD_days/Day1/Tutorial.html)
There are additional pages for this section I've also re-rendered, and we'll cover these today too, if time permits:

* [https://rltillett.github.io/BAD_days/Day1/Frequency.html](https://rltillett.github.io/BAD_days/Day1/Frequency.html)
* [https://rltillett.github.io/BAD_days/Day1/Ttest.html](https://rltillett.github.io/BAD_days/Day1/Frequency.html)
* [Extended comments on distributions and statistics](https://rltillett.github.io/BAD_days/Day1/Comments.html)

The github repo (the source files, not the published pages) of our BAD Days fork can be found here: [https://github.com/rltillett/BAD_days](https://github.com/rltillett/BAD_days)



### Very useful R links

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
