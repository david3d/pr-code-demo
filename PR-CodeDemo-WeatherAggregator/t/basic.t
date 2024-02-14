#!perl
use 5.18.0;
use strict;
use warnings;

use Test::More;
use Test::Deep;
use Data::Dumper;

use PR::CodeDemo::WeatherAggregator;

plan tests => 5;

my $wagg = PR::CodeDemo::WeatherAggregator->new();

my $content = $wagg->get_data();
isnt($content, undef, 'get_data got some content data');

$content = $wagg->to_data_structure($content);

cmp_deeply($content, superhashof({type => ignore(),
    properties => superhashof({periods => isa('ARRAY')})}), 'JSON data structure as expected');

$content = $wagg->parse_data($content);
cmp_deeply($content, superhashof({periods => isa('ARRAY')}), "parse_data returns properties only") or diag_dump($content);

my $now = $wagg->get_current_period($content);
cmp_deeply($now, superhashof({number => 1, temperature => ignore()}), "successfully got current period data") or diag_dump($now);

my $weather = $wagg->normalize_data($content);
my @keys = qw(latitude longitude utc_time temperature wind_speed wind_direction precipitation_chance);
my %expect = map { $_ => bool(1) } @keys;
cmp_deeply($weather, \%expect, "weather data has appropriate keys, with true values") or diag_dump($weather);


sub diag_dump {
    my $data = shift;
    diag(Data::Dumper::Dumper($data));
}
