# BCH 709 Lecture notes: Week 5, part 1

_September 25, 2018_
When you arrive:

- Grab post-its
- Open our Gitter chatroom
- Find and use the link to open these notes in a web browser
- Log in to our linux server
   - Switch your wifi to my hotspot _("Potrezbie")_ if you have trouble

## Roadmap

### Previously:

- Data Carpentry Genomics Command Line
   - Data Carpentry Navigation lessons
   - Data Carpentry's Working with Files and Directories lesson
   - Data Carpentry's Redirection lesson
   - Data Carpentry's Scripting lesson
   - Data Carpentry's Project Organization lesson


### Today
- [Data Carpentry's Writing Scripts module (Shell Genomics 05)](https://datacarpentry.org/shell-genomics/05-writing-scripts/index.html)
- from Assignment 4:
   - Complete or attempt [Shell Genomics 06 Project Organization](https://datacarpentry.org/shell-genomics/06-organization/index.html)
- [Data Wrangling and Processing for Genomics](https://rltillett.github.io/wrangling-genomics/)
   - The workflow: Identification of sequence variants in individuals
   - from input fastq files --> QC --> aligning to genome --> calling variants --> visualisation
   - [Data Carpentry - Data Wrangling 00: Assessing Read Quality](https://rltillett.github.io/wrangling-genomics/00-quality-control/index.html)
      - this is our fork of the DC Data Wrangling lessons, modified for our setup
      - [Data Roundtripping](https://rltillett.github.io/cloud-genomics/04-data-roundtripping/index.html)

---

## Data Carpentry's Writing Scripts module (Shell Genomics 05)

(https://datacarpentry.org/shell-genomics/05-writing-scripts/index.html)

Estimated time: 40 mins
Motivating question: How to automate a commonly used set of commands?

The lesson introduces these commands and concepts:

- shell commands
   - `nano` a text editor
   - `bash`
   - `chmod +x`

---

## Assignment 4: Shell Genomics 06 Project Organization

[Shell Genomics 06 Project Organization](https://datacarpentry.org/shell-genomics/06-organization/index.html)

---

## Data Wrangling: Quality Control

[Data Carpentry - Data Wrangling 00: Assessing Read Quality](https://rltillett.github.io/wrangling-genomics/00-quality-control/index.html)

Including additional instruction on file transfer from [Data Roundtripping](https://rltillett.github.io/cloud-genomics/04-data-roundtripping/index.html)

---

## Appendix I: Commands & concepts reference

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
