# BCH 709 Lecture notes: Week 3, part 1
_September 11, 2018_
## Roadmap
### Previously:
- Data Carpentry Genomics Organization Sessions (metadata)
- Logging in to our classroom server
- Data Carpentry Genomics Command Line
- Assignment 2: Flipped classroom videos & responses (***Due tomorrow***)

### Today
- Logging in to our classroom server
- Data Carpentry's Introducing the Shell
- Data Carpentry's Navigating Files and Directories

---

## Logging in to our remote server (*reminder*)
### Mac OS and linux
Interface with the remote server will be done with an app named Terminal, already on your system

### Windows
Use putty to get an ssh-like terminal login.
get putty here: (https://www.putty.org)

We will `ssh` into a server named `ws-3-0-5.biochem.unr.edu` (or `134.197.51.225` if the DNS is still flaky today.)

Also see these instructions (with modifications for our server's name/number):
 (https://github.com/UNR-HPC/pronghorn/wiki/1.0-Connecting-to-Pronghorn), Note that we will be using the name of our server instead, wherever these  instructions say `pronghorn`.

## Data Carpentry's Introduction to the Command Line (**lesson home**)
Here's the Home page for all their "Shell genomics lessons" [Data Carpentry Shell Genomics](https://datacarpentry.org/shell-genomics/)

---

## Data Carpentry's Introducing the Shell (**Shell Genomics 01**)
(https://datacarpentry.org/shell-genomics/01-introduction/index.html)
Estimated time: 30 min
The lesson covers basics of the look and use of the command line
- commands
	- clear
	- pwd
	- ls
	- cd
	- man
- features
	- modifying your prompt
	- command options/flags
	- tab completion

---

## Data Carpentry's Navigating Files and Directories (**Shell Genomics 02**)
(https://datacarpentry.org/shell-genomics/02-the-filesystem/index.html)
Estimated time: 50 min
The lesson covers file and directory interaction, inside and outside a working directory, full/relative paths, and discovering hidden files
- commands
	- cd
	- pwd
	- ls
	- cd
	- man
- shell shorthand
	- the `..` shorthand for "up one folder"
	- the `/` shorthand for "root"
	- the `~` shorthand for "my home folder"
- concepts
	- paths
		- full paths
		- relative paths
	- tab completion
