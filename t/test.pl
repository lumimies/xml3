use Test::More;
use File::Basename;

my (undef,$basedir,undef) = fileparse($0);
$basedir =~ s|/$||;
my @tests = <$basedir/cases/*.xml>;
plan  tests => 0+@tests;

for my $test (@tests) {
	$test =~ /(^.*)\.xml/;
	my $resultfile = "$1.txt";
	my $actual = `cat $test | $basedir/../xml3.pl`;
	my $expected = `cat $resultfile`;
	is($actual, $expected, $test);
}
