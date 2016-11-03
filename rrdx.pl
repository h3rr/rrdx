#!/usr/bin/perl
### rrdx by Hernan Lucero
### V0.1 Agrega un DS al file
### V0.2 Cambia owner/id a file.rrd a nagios.nagios
### V0.3 Usa command line arguments 
### V0.4 Agregue HELP!!!!!
### V0.5 MEGA OPCIONES y cambios internos ( FULLINFO, INFO y ADD )
### V0.6 Se cambia tipo de DS fieldname default GAUGE
#
use strict;
use warnings;
use RRD::Simple();
use Data::Dumper;
use Scalar::Util qw(looks_like_number);

my ($rrd_op, $rrd_file, $rrd_ds) = @ARGV;
my $rrd = RRD::Simple->new();


defined(my $user = getpwnam "nagios") or die "nagios user not found";
defined(my $group = getgrnam "nagios") or die "nagios group not found";


if (!defined $ARGV[0] )
{
	prginfo();
exit 0;
}

if (!defined $ARGV[1]) {
	prginfo();
}

if (!defined $ARGV[2] && $ARGV[1] eq "add") {
	prginfo();
}


if ($ARGV[0] eq "fullinfo") {
       my $info = RRD::Simple->info($rrd_file);
       print Data::Dumper::Dumper($info);

exit 0;
}


if ($ARGV[0] eq "info") {
	my @dsnames = $rrd->sources($rrd_file);
	print("RRDx 0.5  Copyright 2016 by Hernan Lucero\n");
	print "\nAvailable data sources: " . join(", ", @dsnames) . "\n";
	print "\n";
exit 0;
}


if ($ARGV[0] eq "add" && looks_like_number($ARGV[2])) {
	$rrd->add_source($rrd_file, $rrd_ds => 'GAUGE');
    	chmod 0664, $rrd_file or die "No se pudo cambiar los permisos a $rrd_file: $!";      
    	chown $user, $group, "$rrd_file" or die "No se pudo cambiar el id a $rrd_file: $!";
exit 0;
} ## END


sub prginfo{
	print("RRDx 0.5  Copyright 2016 by Hernan Lucero
\nUsage: rrdx [options] file.rrd ds_fielnumber\n
Valid options: add, fullinfo, info\n 
\nRRDx is distributed under the Terms of the GNU General
Public License Version 2. (www.gnu.org/copyleft/gpl.html)\n\n");
}

