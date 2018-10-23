# Time to troubleshoot the lesson from week 8
## Statement of the problem
When we were attempting to complete the Data Carpentry Variant Calling workflow lesson, we ran into a few problems.

Firstly, the suggested syntax for the samtools sort command was not valid with our version of samtools.

This was odd, given that we installed the version of samtools we were instructed to in the Organizing Genomics lesson page (samtools version 1.3).

We switched to a modern syntax for that command and proceeded.

Second, we encountered another halting error when attempting to call variants with bcftools. It turned out that between whichever version of bcftools shown in the lesson (probably 0.1.19) and the version we installed (1.5), the bcftools call command was born, and should be used for this step.

Then we discovered that the old options (-bvcg) and possible new options don't really line up and we'd have to reason our way through to find options that, at minimum, exist and let us generate some output file.

With some googling and trial and error, we got that far in class. We then filtered the called variants to generate a VCF-format output. We inspected it, and then we attempted the final Exercise in the lesson: parse the vcf (using a cut command) and find the first location with a QUAL value < 4.

We discovered that our VCF was very different than the one quoted in the lesson. Most of our QUAL values were much lower, and the site they list as the answer was not in our file at all.

Something was going wrong, but what exactly was not clear. There were many steps involved in obtaining these variants, and we had no reason to trust our improvised command for the modern `bcftools call`.

So, I went to work on it and started troubleshooting the problems, bit by bit. And it occured to me that this process could be one of the more valuable things I could try to teach this entire semester: what to do when things go wrong and don't work; how to gather clues and test hypotheses; how to apply reason and listen to nagging doubts to make the computer reveal hidden secrets in your data, in your tools, and in the methods/guides/instructions you may be trying to use. Because things DO go wrong. All the time. And it's our job to make them work.

I decided to make this process into today's lesson for the class, tackling our variant-calling problem step by step, with (nearly) every single step documented. Other than two times where I edit my .bashrc file using `nano` and a few times I look at a file using `less`, the commands can be entirely copied and pasted to produce the exact same results. More generally useful, I hope, I also describe my reasoning as I work through the problem towards a solution.

Let's log on to the server, review the expected result, and our not-matching result from Tuesday, and start devising some tests.

Compare the Variant calling lesson and the provided Exercise solution with what we saw on Tuesday now.

### step 0: look at our initial result again.

```bash
cd dc_workshop/
ls
ls results/
ls results/vcf
cut -sf 6,2 results/vcf/SRR097977_final_variants.vcf
```
okay, that kind of floods the screen. lets save that cut output to a file and try again.
```bash
cut -sf 6,2 results/vcf/SRR097977_final_variants.vcf > tuesday_cut_result.txt
head -n 24 tuesday_cut_result.txt
```
still a lot of lines, but just the first 23 or so.

and yep. that does not match the results reported in the lesson. we don't have the site they found and most of our QUAL values are very different.

we know that we aren't exactly confident in the off-lesson way we had to coerce 'bcftools call' into working, so let's make a folder for troubleshooting, run all the steps, and make some reasonable choices on how to run the 'bcftools call' command.

```bash
ls
mkdir trouble
```
### 1st test
test 1. using the trimmed small fastq input, and trying to use 'bcftools call' with options we can defend our use of.
```bash
mkdir trouble/small_fastq_bcf_test
```
run bwa steps to create sai and sam files in our trouble sub-directory
```bash
bwa aln data/ref_genome/ecoli_rel606.fasta data/trimmed_fastq_small/SRR097977.fastq_trim.fastq > trouble/small_fastq_bcf_test/SRR097977.aligned.sai
bwa samse data/ref_genome/ecoli_rel606.fasta trouble/small_fastq_bcf_test/SRR097977.aligned.sai data/trimmed_fastq_small/SRR097977.fastq_trim.fastq > trouble/small_fastq_bcf_test/SRR097977.aligned.sam
```
convert the sam to a bam with samtools
```bash
samtools view -S -b trouble/small_fastq_bcf_test/SRR097977.aligned.sam > trouble/small_fastq_bcf_test/SRR097977.aligned.bam
```
run samtools sort to make a sorted bam file too
```bash
samtools sort trouble/small_fastq_bcf_test/SRR097977.aligned.bam trouble/small_fastq_bcf_test/SRR097977.aligned.sorted
```
Oof. This error again! ^^^^ That's right. Our DON'T work for samtools in version 1.3. good thing the error also told us an acceptable modern syntax.
modern syntax sort command
```bash
samtools sort -o trouble/small_fastq_bcf_test/SRR097977.aligned.sorted.bam trouble/small_fastq_bcf_test/SRR097977.aligned.bam
```
did it work?
```bash
ls -lh trouble/small_fastq_bcf_test/
```
looks like it. now, we mpileup
```bash
samtools mpileup -g -f data/ref_genome/ecoli_rel606.fasta trouble/small_fastq_bcf_test/SRR097977.aligned.sorted.bam > trouble/small_fastq_bcf_test/SRR097977_raw.bcf
```
next bcftools
remember that we have to use 'bcftools call' not 'bcftools view' with our modern version. check the usage first.
```bash
bcftools call
```
clearly the options have changed from what the old 'bcftools view -bvcg' described. old "-b" should now be "-O b"

and in 'bcftools call' '-c' is a switch to use a consensus caller that it says operates similar to the ancient defaults. the implication, though, is that the multi-allelic caller is preferred, so let's use the modern multi-allelic caller, which we set using '-m'.

we should also already be planning to test the impact of using '-c' instead. so we already know what test 2 will be before we are even done with this test.

### more comparing old and new options:

modern '-g' does something ??? with grouping non-variant sites. not clear what that means, though. let's omit it and test it in another round if we have to.

and let's include '-v' because it looks like that option is similar between old and new versions.

modern '-f' requires input values. ancient '-f' did not. so the two options probably do very different things. let's omit it for now or for forever.

```bash
bcftools call -m -v -Ob trouble/small_fastq_bcf_test/SRR097977_raw.bcf > trouble/small_fastq_bcf_test/SRR097977_variants.bcf
```
yay, it worked? we get a warning about ploidy on STDERR, but nothing analogous to the 3 lines of STDERR shown in the lesson. weird, but let's keep working.
final processing step before our 'cut' command now
```bash
bcftools view trouble/small_fastq_bcf_test/SRR097977_variants.bcf | ~/src/bcftools-1.5/misc/vcfutils.pl varFilter -> trouble/small_fastq_bcf_test/SRR097977_final_variants.vcf
ls trouble/small_fastq_bcf_test/ -lh
```

next: a simplified, slick version of the cut command, vs that in the exercise. using the '-s' strict option on this cut obviates the need to do an inverted grep, because none of the '##' commented lines have 6 (or any) tabs. the useful column header line does though. as do all the data lines.

```bash
cut -sf 6,2 trouble/small_fastq_bcf_test/SRR097977_final_variants.vcf
```
two big problems. QUALs do not at all match the "Solution". They're seemingly mostly lower. Bigger problem: we don't even have position 1019082 in this vcf at any quality. It's not below 4 because it doesn't seem to exist (as a variant location. that part of the e.coli genome exists, but we don't have a variant called there).
ok. why?
let's test a few options. maybe moving to the old caller in the 'bcftools call' command will change things?
oh, and lets save that cut output to a file so we can look at it again, before we forget.
```bash
cut -sf 6,2 trouble/small_fastq_bcf_test/SRR097977_final_variants.vcf > trouble/small_fastq_bcf_test/SRR097977_cut62vcf.txt
ls
ls trouble/
```

### test 2, option -c for old-style caller mode

```bash
mkdir trouble/small_fastq_old_caller_test
```
we can copy the sams and bams from the first test, or just reference them. copying wastes space, but it also makes our various test folders start to differ in content and structure. for homogeneity's sake, i'm going to 'cp' the files.

the sai, sam, bam, sorted bam, and the first bcf generated by mpileup
```bash
cp trouble/small_fastq_bcf_test/SRR097977.aligned.s* trouble/small_fastq_old_caller_test/
cp trouble/small_fastq_bcf_test/SRR097977.aligne*bam trouble/small_fastq_old_caller_test/
cp trouble/small_fastq_bcf_test/SRR097977_raw.bcf trouble/small_fastq_old_caller_test/
```
now begin testing the old-style caller '-c'
```bash
bcftools call -c -v -Ob trouble/small_fastq_old_caller_test/SRR097977_raw.bcf > trouble/small_fastq_old_caller_test/SRR097977_variants.bcf
ls trouble/ -R
```
complete test w/ the vcf filterer and cut commands
```bash
bcftools view trouble/small_fastq_old_caller_test/SRR097977_variants.bcf | ~/src/bcftools-1.5/misc/vcfutils.pl varFilter - > trouble/small_fastq_old_caller_test/SRR097977_final_variants.vcf
cut -sf 6,2 trouble/small_fastq_old_caller_test/SRR097977_final_variants.vcf > trouble/small_fastq_old_caller_test/SRR097977_cut62vcf.txt
```
since we remembered to save it to a text file, use cat to look at the contents.
```bash
head -n 24 trouble/small_fastq_old_caller_test/SRR097977_final_variants.vcf
```
hmm. the QUALs are a little different now, but pretty similar to the 1st test. AND still no SNP at all at POS 1019082. what gives?

we could try testing a bunch more options, [Note: I did. With a ton of options. None of which moved the QUALs near '222'. None made the site at 1019082 appear in our cutfile either]. Or, we could try installing the ancient version of samtools that it looks like are in use in the lesson material, run everything with the ancient versions of things, and then we should get the desired result, right?

only one way to find out.

### test 3. using samtools 0.1.11.9

ok, now let's get the old version installed.

that should be 0.1.11.9, or thereabouts. that's the last version (I think) before the syntax and features were completely re-written.
```bash
cd ~
ls
mkdir oldsrc
cd oldsrc/
wget https://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2
ls
tar -xjvf samtools-0.1.19.tar.bz2
ls
cd samtools-0.1.19/
ls
make
ls
ls bcftools/
```
oh look, vcfutils.pl is in the same directory as bcftools in the ancient version. also, bcftools is not a separate download. it just came with samtools back then. let's add this ancient samtools folder and the bcftools subfolder into our path, comment out the paths we had to the newer versions, reload our bash resource file, check that the ancient versions are installed, and then run a 3rd test using all old samtools parts.

note that our system knows where the newer samtools and bcftools executables are
```bash
which samtools
which bcftools
```
and now to add the ancient ones to ~/.bashrc
```bash
ls
pwd
cd bcftools/
pwd
which samtools
which bcftools
echo export 'PATH=~/oldsrc/samtools-0.1.19/bcftools:$PATH' >> ~/.bashrc
echo export 'PATH=~/oldsrc/samtools-0.1.19:$PATH' >> ~/.bashrc
tail ~/.bashrc
```
we see the lines added.

now we must comment out the paths for the new-ish versions and reload the bash resource file. using nano to comment them, which isn't easy to represent in a static webpage

`nano ~/.bashrc`

`<make your edits and save>`
view see the small changes i made near the end of the file.
```bash
tail ~/.bashrc
```
now load it with 'source'
```bash
source ~/.bashrc
```
prove that the ancient ones are the ones the OS will pick.
```bash
which samtools
which bcftools
which vcfutils.pl
```
nice, now i've got the old version installed, and the new versions forgotten because I commented them out. (its easy to switch this if we ever go back too)
now to the ancient version test
```bash
cd ~/dc_workshop/
mkdir trouble/small_fastq_ancient
```
copy the sai and the sam file (made by bwa, not by samtools) in here and run everything with old versions of everything!!
```bash
cp trouble/small_fastq_bcf_test/SRR097977.aligned.sa* trouble/small_fastq_ancient/
ls -Rlh trouble/
```
3 samtools steps now with ancient version. make bam, sort bam, mpileup.
```bash
samtools view -S -b trouble/small_fastq_ancient/SRR097977.aligned.sam > trouble/small_fastq_ancient/SRR097977.aligned.bam
samtools sort trouble/small_fastq_ancient/SRR097977.aligned.bam trouble/small_fastq_ancient/SRR097977.aligned.sorted
```
OH HEY LOOK! THE OLD SYNTAX for `samtools sort` works with the ancient version of samtools! it is a bad syntax though. it's confusing, and leads to dangerous bugs, is non-obvious, can cause you to overwrite files accidentally, etc. I'm glad they moved away from it.
```bash
ls -lh trouble/small_fastq_ancient/
```
there it is. our sorted bam file was made. good enough for testing.

mpileup command is next
```bash
samtools mpileup -g -f data/ref_genome/ecoli_rel606.fasta trouble/small_fastq_ancient/SRR097977.aligned.sorted.bam > trouble/small_fastq_ancient/SRR097977_raw.bcf
```
now ancient 'bcftools view -bvcg' time
```bash
bcftools view -bvcg trouble/small_fastq_ancient/SRR097977_raw.bcf > trouble/small_fastq_ancient/SRR097977_variants.bcf
```
1. Cool. Lesson-provided options worked with the ancient `bcftools view`.
2. however, the STDERR output to the screen still isn't the same as in the lesson. i don't know if that will be important later... [HINT]

time to make the vcf and cut it
```bash
bcftools view trouble/small_fastq_ancient/SRR097977_variants.bcf | vcfutils.pl varFilter - > trouble/small_fastq_ancient/SRR097977_final_variants.vcf
cut -sf 6,2 trouble/small_fastq_ancient/SRR097977_final_variants.vcf > trouble/small_fastq_ancient/SRR097977_cut62vcf.txt
head -n 24 trouble/small_fastq_ancient/SRR097977_cut62vcf.txt
```
HMMMM. Two problems.
Values are still very far away from 222 in the first few lines.
and still no sign of any SNP at site 1019082
It looks like we still aren't getting matching output/outcomes even when we used an ancient version w/ matching syntax...

## another hypothesis altogether
what else could be different between this test and the work shown in our lesson?

I thought about this for a while on Tuesday (while testing another flurry of options, and no significant impact on things). But I wasn't ready to give up.

I said to myself, "ok, at least one of the outputs[STDERR messages] to a command we ran with the ancient versions did not look like the STDERR messages quoted in the lesson."

the one I had noticed was the STDERR msg for 'bcftools view -bvcg'. Ours had only 1 line of output. the numbers printed for (whatever [afs] is) didn't match. And we didn't have a "100000 sites processed" line either.

it's too bad i don't know what these messages mean. were there any other commands with differing STDERR messages?

oh.

YES, there was!

our `samtools sort` command never said `[bam_sort_core] merging from 2 files...` like the lesson command did

and i know a lot more about samtools than i do bcftools. enough to know that when 'samtools sort' is sorting large files, it breaks the sort into chunks, creating mostly-sorted temp files so it doesn't run out of RAM, and then finishes the sort from these tmp files to produce final sorted bam output

so, how could the example 'samtools sort' be sorting a large file but we aren't?

oh no. no. it couldn't. could it be ...?

did the lesson example somehow switch to using a full-sized trimmed fastq instead of the trimmed_small one? we know for sure that the example 'bwa aln' and 'bwa samse' steps in the lesson use a small_trimmed file, because it is right there in the folder names. take a look at the web page and verify.

but after those two steps, we have no evidence that they continued using the small files. could there have been an unknown switch? could the instructions have, say, originally been written using the full-sized files, then later modified to use the small ones (for less downtime during the lesson, presumably), and then either nobody updated the instructions & quoted outputs for the post-bwa steps with the smaller files? or, equivalently, that small and large versions of the lesson co-existed, and then got pasted together incorrectly? like what sometimes happens when you're passing Word docs around with co-authors?

well now we have to find out.

### 4th test time. lets find a trimmed large file somewhere on our server.
if we have a trimmed large file that matches a trimmed large file that DC authors (hypothetically) used to variant-call, it will be somewhere in the /home/public/dc_sample_data_lite folder
```bash
ls /home/public/dc_sample_data_lite
ls /home/public/dc_sample_data_lite/solutions/
ls /home/public/dc_sample_data_lite/solutions/wrangling-solutions/
ls /home/public/dc_sample_data_lite/solutions/wrangling-solutions/trimmed_fastq/
ls /home/public/dc_sample_data_lite/solutions/wrangling-solutions/trimmed_fastq/ -lh
```
ok, we found large trimmed files that were prepared by someone at/with/for the DC folks.

instead of copying it, let's just use the path to the trimmed fastq and tell bwa to read from the existing fastq file where it is, when doing the alignment and sam conversion steps.

we'll still put the .sai and .sam outputs in a folder in our trouble directory, though.
```bash
ls trouble/
```
and lets keep using the ancient samtools
```bash
mkdir trouble/large_fastq_ancient_tools
```
bwa steps now
```bash
bwa aln data/ref_genome/ecoli_rel606.fasta /home/public/dc_sample_data_lite/solutions/wrangling-solutions/trimmed_fastq/SRR097977.fastq_trim.fastq > trouble/large_fastq_ancient_tools/SRR0977.aligned.sai
bwa samse data/ref_genome/ecoli_rel606.fasta trouble/large_fastq_ancient_tools/SRR0977.aligned.sai /home/public/dc_sample_data_lite/solutions/wrangling-solutions/trimmed_fastq/SRR097977.fastq_trim.fastq > trouble/large_fastq_ancient_tools/SRR0977.aligned.sam
```

so i noticed that I didn't write the full name of the SRA library 'SRR097977' on the 'sai' or 'sam' file names. i could rename them using the 'mv' command, but I'm going to keep them this way. It might be a decent visual clue that we're looking at a very different (much larger) input set in this test than in the ones we did with the small fastq input. 'SRR0977' it is, then.
```bash
ls trouble/large_fastq_ancient_tools/
```
now let's do the samtools and bcftools commands, using the ancient versions. we have reason to believe that these ancient versions are the ones DC folks used, from the syntax used in the lesson.
```bash
samtools view -S -b trouble/large_fastq_ancient_tools/SRR0977.aligned.sam > trouble/large_fastq_ancient_tools/SRR0977.aligned.bam
samtools sort trouble/large_fastq_ancient_tools/SRR0977.aligned.bam trouble/large_fastq_ancient_tools/SRR0977.aligned.sorted
```
Aha! we see the "merging from 2 files..." statement on the STDERR. does this bode well for the "didn't use small input" hypothesis? maybe. it is consistent with it, in any event.

now mpileup and bcftools view
```bash
samtools mpileup -g -f data/ref_genome/ecoli_rel606.fasta trouble/large_fastq_ancient_tools/SRR0977.aligned.sorted.bam > trouble/large_fastq_ancient_tools/SRR0977_raw.bcf
bcftools view -bvcg trouble/large_fastq_ancient_tools/SRR0977_raw.bcf > trouble/large_fastq_ancient_tools/SRR0977_variants.bcf
```
ok, now our STDERR on this command matches that reported in the lesson TOO. encouragement increases.

vcfutils and cut commands now
```bash
bcftools view trouble/large_fastq_ancient_tools/SRR0977_variants.bcf | vcfutils.pl varFilter - > trouble/large_fastq_ancient_tools/SRR0977_final_variants.vcf
cut -sf 6,2 trouble/large_fastq_ancient_tools/SRR0977_final_variants.vcf > trouble/large_fastq_ancient_tools/SRR0977_cut62vcf.txt
```
now the moment of truth. let's look at the cut results.
```bash
head -n 24 trouble/large_fastq_ancient_tools/SRR0977_cut62vcf.txt
```
that looks like a perfect match, i think!

so what we thought was one problem (variant calls and scores very very dependent on using ancient version of samtools) turned out to be caused by a 2nd problem -- that the small inputs stopped being used, and the large one was used instead, mid-lesson, un-noted, and un-noticed.

the samtools/bcftools version incompatibilities WERE a true problem for us, however. they did stymie our attempts to run the commands as instructed. but they were not the key to generating the output we were asked to produce.

### test 5. modern samtools with large input
one final test should be done to prove/disprove the effects of software versions. in order to square the circle we must run the modern versions of samtools/bcftools with the large input data. will results be identical? i suspect not quite. will they be close enough to come to the same answer for "what is the first site with QUAL < 4?" let's find out.

gotta uncomment the two lines in our bash resource file, and comment out the lines for the ancient version. I'll do it in nano, as before.

1st, check that we're using ancient versions
```bash
which samtools
which bcftools
tail ~/.bashrc
```
edit the bashrc to uncomment modern version lines. then comment out the ancient version lines.
nano ~/.bashrc
<make your edits and save>
```bash
tail ~/.bashrc
source ~/.bashrc
which samtools
which bcftools
```
ok, modern versions are ready to use again.

make a new folder for large input, modern tools test
```bash
cd ~/dc_workshop
mkdir trouble/large_fastq_modern
```
copy over the large fastq bwa outputs (sai and sam) into the modern dir
```bash
cp trouble/large_fastq_ancient_tools/SRR0977.aligned.sa* trouble/large_fastq_modern/
ls trouble -Rlh
```
run samtools view (make the bam) sort, mpileup

also recall that we'll have to switch back to using modern syntax and options for the 'samtools sort' and 'bcftools call' commands
```bash
samtools view -S -b trouble/large_fastq_modern/SRR0977.aligned.sam > trouble/large_fastq_modern/SRR0977.aligned.bam
samtools sort -o trouble/large_fastq_modern/SRR0977.aligned.sorted.bam trouble/large_fastq_modern/SRR0977.aligned.bam
samtools mpileup -g -f data/ref_genome/ecoli_rel606.fasta trouble/large_fastq_modern/SRR0977.aligned.sorted.bam > trouble/large_fastq_modern/SRR0977_raw.bcf
```
bcftools commands now
```bash
bcftools call -v -Ob -m trouble/large_fastq_modern/SRR0977_raw.bcf > trouble/large_fastq_modern/SRR0977_variants.bcf
bcftools view trouble/large_fastq_modern/SRR0977_variants.bcf | ~/src/bcftools-1.5/misc/vcfutils.pl varFilter - > trouble/large_fastq_modern/SRR0977_final_variants.vcf
```
cut the vcf to text file
```bash
cut -sf 6,2 trouble/large_fastq_modern/SRR0977_final_variants.vcf > trouble/large_fastq_modern/SRR0977_cut62vcf.txt
```
and view it:
```bash
head -n 24 trouble/large_fastq_modern/SRR0977_cut62vcf.txt
```
any hypothesis that tool version doesn't matter is not supported. BOTH old tools AND large inputs were required to duplicate the result in the lesson. modern bcftools does not call a variant at the POS in question, even with the large fastq input.

but what if we ran the modern bcftools call in it's more "old-school" -c mode? yep, we have to do one more test.

### bonus test: modern 'dash c' with large input
```bash
mkdir trouble/large_fastq_bonus_dash_c
```
copy the sam, sai, bam, sorted bam, and raw bcf from previous test in to bonus dir
```bash
cp trouble/large_fastq_modern/SRR0977.aligned.sa* trouble/large_fastq_bonus_dash_c/
cp trouble/large_fastq_modern/SRR0977.aligned*bam trouble/large_fastq_bonus_dash_c/
cp trouble/large_fastq_modern/SRR0977_raw.bcf trouble/large_fastq_bonus_dash_c/
```
recall that the [name]_raw.bcf files were made with 'samtools mpileup' and that's why we reuse them
```bash
ls trouble/large_fastq_bonus_dash_c/ -lh
```
bcftools call -c old-style mode
```bash
bcftools call -v -Ob -c trouble/large_fastq_bonus_dash_c/SRR0977_raw.bcf > trouble/large_fastq_bonus_dash_c/SRR0977_variants.bcf
```
finish it out
```bash
bcftools view trouble/large_fastq_bonus_dash_c/SRR0977_variants.bcf | ~/src/bcftools-1.5/misc/vcfutils.pl varFilter - > trouble/large_fastq_bonus_dash_c/SRR0977_final_variants.vcf
cut -sf 6,2 trouble/large_fastq_bonus_dash_c/SRR0977_final_variants.vcf > trouble/large_fastq_bonus_dash_c/SRR0977_cut62vcf.txt
```
ready to find out? cat to screen
```bash
head -n 24 trouble/large_fastq_bonus_dash_c/SRR0977_cut62vcf.txt
```
and in a final twist, we learn that using the '-c' option in 'bcftools call' generally does approximate the results of the ancient version. none of the QUALs are exactly the same, but most of them look close to the 2nd or 3rd significant digit. Finally, regarding the question in the Exercise: Yes, position 109082 is back, and is again the first position found with a variant called with QUAL < 4.
```bash
grep 1019082 trouble/large_fastq_bonus_dash_c/SRR0977_cut62vcf.txt
```
