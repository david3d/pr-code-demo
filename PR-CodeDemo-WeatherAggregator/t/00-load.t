#!perl
use 5.18.0;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'PR::CodeDemo::WeatherAggregator' ) || print "Bail out!\n";
}

diag( "Testing PR::CodeDemo::WeatherAggregator $PR::CodeDemo::WeatherAggregator::VERSION, Perl $], $^X" );
