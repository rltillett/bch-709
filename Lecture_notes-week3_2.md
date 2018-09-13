# BCH 709 Lecture notes: Week 3, part 2

_September 13, 2018_

## Roadmap

### Previously:

- Data Carpentry Genomics Organization lesson (metadata)
- Data Carpentry Genomics Command Line
- Data Carpentry Navigation lessons
- Assignment 2: Flipped classroom videos & responses

### Today

- Recap of previous lessons (commands, concepts, features)
- Logging in to our classroom server
- Data Carpentry's Working with Files and Directories lesson
- Data Carpentry's Redirection lesson

---

## Data Carpentry's Introducing the Shell (**Shell Genomics 01**) & Navigating Files and Directories (**Shell Genomics 02**) Recap

- (https://datacarpentry.org/shell-genomics/01-introduction/index.html)
- (https://datacarpentry.org/shell-genomics/02-the-filesystem/index.html)

The lessons introduced these commands and concepts

- shell commands
  - `clear` _clears the screen_
  - `pwd` _print working directory (your current dir)_
  - `ls` _list (stuff)_
  - `cd` _change directory_
  - `man` _manual pages for commands/software_
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

---

## Logging in to our remote server (*reminder*)

### Mac OS and linux

Interface with the remote server will be done with an app named Terminal, already on your system, with a command similar to

`ssh yourNetId@134.19751.225`

### Windows

Use putty to get an ssh-like terminal login.
get putty here: (https://www.putty.org)

We will `ssh` into a server by its IP address `134.197.51.225` (though `ws-3-0-5.biochem.unr.edu` may work for some)

Also see these instructions (with modifications for our server's name/number):
 (https://github.com/UNR-HPC/pronghorn/wiki/1.0-Connecting-to-Pronghorn), Note that we will be using the name of our server instead, wherever these  instructions say `pronghorn`.

## Data Carpentry's Introduction to the Command Line (**lesson home**)

Here's the Home page for all their "Shell genomics lessons" [Data Carpentry Shell Genomics](https://datacarpentry.org/shell-genomics/)

---

## Data Carpentry's Working with Files and Directories (**Shell Genomics 03**)

(https://datacarpentry.org/shell-genomics/03-working-with-files/index.html)

Estimated time: 45 min
The lesson covers more on interacting with folders, files, and the content inside

The lesson introduces these commands and concepts:

- shell commands
  - `history`
  - `echo`
  - `cat`
  - `less`
  - `head` and `tail`
  - `cp`
  - `mv`
  - `mkdir`
  - `chmod`
  - `rm`
- concepts / features
  - the `*` wildcard
  - home vs. root
  - CTRL shortcuts
    - CTRL-C
    - CTRL-R
    - CTRL-L
  - file permissions

---

## Data Carpentry's Redirection module

(https://datacarpentry.org/shell-genomics/04-redirection/index.html)

Estimated time: 45 min
The module introduces this powerful shell feature that allows users to combine commands and control the flow of information in and out of programs

The lesson introduces these commands and concepts:

- shell commands
  - `grep`
  - `wc`
  - `cut`
  - `sort`
  - `uniq`
- concepts / features
  - redirection 
    - redirection to file with the `>` command (operator)
    - append to file with the `>>` command (operator)
    - piping data between programs using `|`