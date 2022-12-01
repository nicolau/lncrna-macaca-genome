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

my ($input, $help, $version, $handle);
GetOptions( 'i|input=s'         => \$input,
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
        open DATA, $input or die $!, "\n";
        $handle = \*DATA;
}
if ( $boolean == 1 ) {
        exit;
}

while( my $line = <$handle> ) {
        chomp( $line );

        my (undef, undef, undef, undef, undef, undef, $readid, undef, undef, undef, $annot) = split /\t/, $line;

        print "$readid\n" if $annot == ".";
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

