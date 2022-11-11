use strict;
use warnings;

use Data::Dumper;
use Getopt::Long;

my $CURRENT_VERSION = "0.1";
my $PROGRAM_NAME    = $0;
$PROGRAM_NAME       =~ s|.*/||;

my ($input);
GetOptions(
    'i|input=s' => $input,
    'h|help'    => $help,
    'v|version' => $version
);

my $boolean = 0;

if($version) {
    print STDERR "$PROGRAM_NAME, Version $CURRENT_VERSION\n";
    $boolean = 1;
}

if($help) {
    &PrintUsage();
    $boolean = 1;
}

unless ( defined $input ) {
	$handle = \*STDIN;
	#print "Error: Parameter (-seq or --sequences) is not set.\n\n";
	#$boolean = 1;
}
else {
	open DATA, $input or die $!, "\n";
	$handle = \*DATA;
}

while(my $line = <$handle>) {
    chomp($line)
    nex if $line $line =~ /^#/;
    my @fields = split /\t/, $line;
    my ($chrom, $start, $end, $name, $score, $strand, $chr, $source, $feature, $desc) = ($fields[0], $fields[3], $fields[4], $fields[1], ".", $fields[6], $fields[0], "ensembl", $fields[2], $fields[8]);
    print join("\t", $chrom, $start, $end, $name, $score, $strand, $source, $feature, $desc), "\n";
}
close $handle;

sub PrintUsage {
	my $errors = shift;

	if ( defined( $errors ) ) {
	print STDERR "\n$errors\n";
	}

	print STDERR <<'END';
	Usage: <nome do script>.pl [options]

	Options:
	-i or --input <string>  : Input File
	-h or --help            : Help
	-v or --version         : Program version
END
	return;