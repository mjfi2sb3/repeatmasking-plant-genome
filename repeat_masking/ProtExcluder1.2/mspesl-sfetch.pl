#! /usr/bin/perl -w

$usage = "mspesl-sfetch.pl database msp_file integer output_file\nwhere integer is how far away you'd like to extend from the match region\n";

# to fetch sequences from a list 

# call esl-sfetch from hmmer-3.1

if (@ARGV < 4) {die "$usage";}

open(TEST, "$ARGV[0]") || die "Can not open the database $ARGV[0]\n$usage";
close TEST;
open(MSP, "$ARGV[1]") || die "Can not open the input MSP file $ARGV[1]\n$usage";

`rm -f $ARGV[3]`;

 `/cbrc/software/hmmer/v31b1.app/binaries/esl-sfetch --index $ARGV[0]`;

while (<MSP>) {
	print;
    @line = split;
    if ($line[2] < $line[3]) {$from=$line[5]-$ARGV[2]; $to=$line[6]+$ARGV[2];}
    else {$from=$line[6]+$ARGV[2]; $to=$line[5]-$ARGV[2];}
	print @line;
    if ($from < 1) {$from=1;}
    if ($to < 1) {$to=1;}
    if ($line[2] < $line[3]) {
    `/cbrc/software/hmmer/v31b1.app/binaries/esl-sfetch -c $from..$to $ARGV[0] $line[7] >> $ARGV[3]`;
    }
    else { 
`/cbrc/software/hmmer/v31b1.app/binaries/esl-sfetch -c $from..$to -r $ARGV[0] $line[7] >> $ARGV[3]`;
    }

 if ($?) {print $_, "failure\n\n"; $failure++;}
}
close MSP;

if ($failure) {
    print "Total failed case: ", $failure;
}
