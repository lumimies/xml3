#!/usr/bin/perl -w
use strict;
use warnings;

use XML::Parser;

my @stack = () ;
my @contentstack = ();
my $content = "";
my $dbg = 0;
sub DEBUG { print STDERR "DEBUG: ", @_, "\n"  if $dbg }
sub path { "/".join "/",@stack }
sub flush_content {
	DEBUG("flush_content");
	return if $content =~ /^\s*$/;
	for my $line (split /\n/, $content) {
		$contentstack[0]= 1;
		print path . "=$line\n" unless $line =~ /^\s*$/ 
	}
	$content = "";
}
sub start_elt {
	my ($expat, $eltname, @attrs) = @_;
	DEBUG("start_elt",@_);
	flush_content;
	push @stack, $eltname;
	$contentstack[0]=1 if +@contentstack;
	unshift @contentstack, 0;
	while (@attrs) {
		my $key = shift @attrs;
		my $value = shift @attrs;
		print path . "/\@$key=$value\n";
	}
}
sub end_elt {
	my ($expat, $eltname) = @_;
	flush_content;
	my $had_content = shift @contentstack;
	print path . "\n" unless $had_content;
	my $popped = pop @stack;
	die "Element stack mismatch: Expected $popped, got $eltname" unless $popped eq $eltname;
}
sub handle_char {
	DEBUG("handle_char",@_);
	my ($expat, $c) = @_;
	$content .= $c;
}
my $parser = new XML::Parser(Handlers => { Start => \&start_elt, End => \&end_elt, Char => \&handle_char });
$parser->parse(*STDIN);
#while(<>) { $parser->parse(*ARGV); }
