#!perl

use 5.18.0;
use strict;
use warnings;

use Test::More;
use Test::Deep;
use JSON;
use Data::Dumper;

use PR::CodeDemo::WeatherAggregator;

plan tests => 5;

my $wagg = PR::CodeDemo::WeatherAggregator->new();

my ($latitude, $longitude) = (46.826, -100.800);

my $forecast_url = $wagg->get_forecast_url_from_coordinates($latitude, $longitude);
like $forecast_url, qr{^https://api.weather.gov/gridpoints/}, 'forecast url returned by get_forecast_url_from_coordinates looks right'
    or diag_dump($forecast_url);

my $content = $wagg->get_full_forecast($forecast_url);
is(ref($content), '', 'full forecast data is not a reference') or diag_dump($content);

my $json = decode_json($content);
cmp_deeply($json, superhashof({
    '@context' => isa('ARRAY'),
    type       => 'Feature',
    geometry   => isa('HASH'),
    properties => isa('HASH'),
}), "got full forecast data") or diag_dump($json);

my @keys = qw(latitude longitude utc_time temperature wind_speed wind_direction precipitation_chance);
my %expect = map { $_ => bool(1) } @keys;

my $normalized = $wagg->normalize_data($latitude, $longitude, $content);
cmp_deeply($normalized, \%expect, "normalize_data returns appropriate keys, with true values") or diag_dump($normalized);

# Now all in one with the main method
my $weather = $wagg->get_weather(latitude => $latitude, longitude => $longitude);
cmp_deeply($weather, \%expect, "get_weather returns appropriate keys, with true values") or diag_dump($weather);


sub diag_dump {
    my $data = shift;
    diag(Data::Dumper::Dumper($data));
}
