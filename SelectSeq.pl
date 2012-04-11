#!/usr/bin/perl -w
# A perlscript written by Joseph Hughes, University of Glasgow
# use this perl script to select individual fasta file based on id or description matching
# or randomly select a file


use strict;
use Getopt::Long; 
use Bio::SeqIO;                    
 

my ($infasta,$outfile,$fid,$fdescr,$rdm,$help,$mid);
&GetOptions(
	    'in:s'      => \$infasta,#fastafile
	    'out:s'   => \$outfile,#output fasta file
	    'fid:s'   => \$fid,#find id
	    'mid:s'  => \$mid,#match id
	    "fdescr:s"  => \$fdescr,  # find descr
	    "rdm"  => \$rdm,  # randomly select a fasta sequence
	    "help"  => \$help,  # provides help with usage
           );

if (($help)&&!($help)||!($infasta)||!($outfile)){
 print "Usage : Consensus.pl <list of arguments>\n";
 print " -in <txt> - the input fasta file\n";
 print " -out <txt> - the name of your output fasta file\n";
 print " -fid <txt> - the id of the fasta file you want to match - exact match\n";
 print " -mid <txt> - the id of the fasta file you want to match - partial match\n";
 print " -fdescr <txt> - the description of a fasta sequence you want to match - partial match\n";
 print " -rdm - randomly select a sequence from a fasta file\n";
 print " -help        - Get this help\n";
 exit();
 }
if ($fid){  
print "Looking for $fid (exact id) in your fasta file $infasta...\n";
my $in  = Bio::SeqIO->new(-file => "$infasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'fasta');
my $hits=0;
  while (my $seq = $in->next_seq()){
    my $id=$seq->id;
    if ($id eq $fid){
     $out->write_seq($seq);
     $hits++;
     }
  }
print "There are $hits matches\n";
}elsif ($mid){  
print "Looking for $mid match in the id of your fasta file $infasta...\n";
my $in  = Bio::SeqIO->new(-file => "$infasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'fasta');
my $hits=0;
  while (my $seq = $in->next_seq()){
    my $id=$seq->id;
    if ($id =~/$mid/){
     $out->write_seq($seq);
     $hits++;
     }
  }
print "There are $hits matches\n";
}elsif($fdescr){
print "Looking for $fdescr in your fasta file $infasta...\n";
my $in  = Bio::SeqIO->new(-file => "$infasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'fasta');
my $hits=0;
  while (my $seq = $in->next_seq()){
    my $desc=$seq->desc;
    if ($desc =~/$fdescr/){
     $out->write_seq($seq);
     $hits++;
    }
  }
print "there are $hits matches\n";
}elsif($rdm){
print "Randomly selecting a sequence...\n";
my (@seqs);
my $in  = Bio::SeqIO->new(-file => "$infasta" ,
                         -format => 'fasta');
my $out = Bio::SeqIO->new(-file => ">$outfile" , '-format' => 'fasta');
  while (my $seq = $in->next_seq()){
    push(@seqs,$seq);
  }
  my $index   = rand @seqs;
  my $rdmseq = $seqs[$index];
  print "$rdmseq\n";
  $out->write_seq($rdmseq);
}