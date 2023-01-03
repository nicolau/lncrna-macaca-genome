#!/usr/bin/perl
#
#INGLES/ENGLISH
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#http://www.gnu.org/copyleft/gpl.html
#
#PORTUGUES/PORTUGUESE                                CITAS,
#COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.  Consulte
#a Licenca Publica Geral GNU para maiores detalhes.
#http://www.gnu.org/copyleft/gpl.html
#
#Copyright (C) 2018
#
#Computational System Biology Laboratory - CSBL
#Faculdade de Ciências Farmacêuticas
#Universidade de São Paulo - USP
#Av. Prof. Lineu Prestes, 580
#Butantã
#São Paulo - SP
#Brasil
#
#Fone: +55 91 8100-7316
#
#Andre Nicolau Aquime Goncalves
#anicolau85@gmail.com
#http://<site do laboratorio>
#$Id$

# Script para <descrever o(s) objetivo(s)>
# Andre Nicolau - <data atual>

use strict;
use warnings;

use Data::Dumper;
use Getopt::Long;

my $CURRENT_VERSION = "0.1";
my $PROGRAM_NAME    = $0;
$PROGRAM_NAME       =~ s|.*/||;

my ($input, $regex, $help, $version, $handle);
GetOptions( 'i|input=s'         => \$input,
            'r|regex=s'           => \$regex,
            'h|help'            => \$help,
            'v|version'         => \$version
          );
my $boolean = 0;
if ( $version ) {
        print STDERR "$PROGRAM_NAME, Version $CURRENT_VERSION\n";
        $boolean = 1;
}
if ( $help ) {
        &PrintUsage();
        $boolean = 1;
}
unless ( defined $input ) {
        $handle = \*STDIN;
        #print "Error: Parameter (-i or --input) is not set.\n\n";
        #$boolean = 1;
}
else {
        open DATA, "gunzip -c $input |" or die $!, "\n";
        $handle = \*DATA;
}
unless ( defined $regex ) {
        print "Error: Parameter (-r or --regex) is not set.\n\n";
        $boolean = 1;
}
if ( $boolean == 1 ) {
        exit;
}

# TODO criar um hash para armazenar os IDs para extrair as sequencias
# O ID na chave e no valor 0 para nao recuperado e 1 para recuperado.
# Dessa forma passaremos apenas uma vez pelo arquivo fastq

my %ids;
open IDS, $regex or die $!, "\n";

while( my $line = <IDS> ) {
        chomp( $line );
        $ids{$line} = 0;
}
close IDS;


while( my $line = <$handle> ) {
        chomp( $line );

        my ($read_id, $read_seq, $qual_id, $qual_seq);
        
        #print $line, "\n";
        my $search_id = $1 if $line =~ /^@(.*)\s.*/;# and $line =~ /^@/;
        
        #print $search_id, "\n";
        #exit;

        #if($line =~ /$regex/) {
        if(defined($ids{$search_id})) {
                if($ids{$search_id} == 0) {
                        $read_id  = $line;
                        $read_seq = <$handle>;
                        $qual_id  = <$handle>;
                        $qual_seq = <$handle>;

                        print $read_id, "\n", $read_seq, $qual_id, $qual_seq;
                        $ids{$search_id} = 1;
                }
        } else {
                <$handle>;
                <$handle>;
                <$handle>;
        }
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
}

