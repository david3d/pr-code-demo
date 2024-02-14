package PR::CodeDemo::WeatherAggregator;

use 5.18.0;
use strict;
use warnings;

use LWP::UserAgent;
use JSON;

=head1 NAME

PR::CodeDemo::WeatherAggregator - Gather and normalize weather data from different sources

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use PR::CodeDemo::WeatherAggregator;

    my $wa = PR::CodeDemo::WeatherAggregator->new();
    ...


=head1 METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    my %args = @_;
    return bless { %args }, $class;
}


=head2 get_data

=cut

sub get_data {
    my $self = shift;

    my $base_url = 'https://api.weather.gov';
    my $endpoint = 'gridpoints/TOP/31,80/forecast';
    my $req_url = join '/', $base_url, $endpoint;

    my $ua = LWP::UserAgent->new('weather-agg-audition-pr/0.1', 'dierauer@gmail.com');

    my $response = $ua->get($req_url);

    if ($response->is_success) {
        return $response->decoded_content;
    }
    else {
        return $response->as_string;
    }
}

sub to_data_structure {
    my $self = shift;
    my $text = shift;

    return eval { decode_json($text) };
}

=head2 parse_data

=cut

sub parse_data {
    my $self = shift;
    my ($rawdata) = @_;
    my $properties = $rawdata->{properties};

    return $properties;
}

sub get_current_period {
    my $self = shift;
    my $parsed = shift;
    return $parsed->{periods}[0];
}

=head2 normalize_data

* Latitude
* Longitude
* UTC Time
* Temperature
* Wind Speed
* Wind Direction
* Precipitation Chance

=cut

sub normalize_data {
    my $self = shift;
    my $parsed = shift;

    my $current_period_hr = $self->get_current_period($parsed);

    my @keys = qw(latitude longitude utc_time temperature wind_speed wind_direction precipitation_chance);
    my %return = map { $_ => undef } @keys;

#     $return{latitude} =
#     $return{longitude} =
    $return{utc_time} = $parsed->{updated};
    $return{temperature} = $current_period_hr->{temperature};
    $return{wind_speed} = $current_period_hr->{windSpeed};
    $return{wind_direction} = $current_period_hr->{windDirection};
    $return{precipitation_chance} = ($current_period_hr->{probabilityOfPrecipitation}{value} || 0) . '%';

    return \%return;
}

=head1 AUTHOR

David Dierauer, C<< <dierauer at gmail.com> >>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc PR::CodeDemo::WeatherAggregator


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2024 by David Dierauer.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of PR::CodeDemo::WeatherAggregator


__END__

Sample weather data from api.weather.gov for: 'gridpoints/TOP/31,80/forecast'
( {
                 '_headers' => bless( {
                                        'access-control-allow-origin' => '*',
                                        'strict-transport-security' => 'max-age=31536000 ; includeSubDomains ; preload',
                                        'connection' => 'close',
                                        'vary' => 'Accept,Feature-Flags,Accept-Language',
                                        'date' => 'Wed, 14 Feb 2024 17:01:07 GMT',
                                        'x-request-id' => 'a24e0a9b-fadc-4538-a29f-116174bdbf1e',
                                        'x-edge-request-id' => 'be91e344',
                                        'content-length' => '17420',
                                        'x-server-id' => 'vm-lnx-nids-apiapp7.ncep.noaa.gov',
                                        '::std_case' => {
                                                          'client-ssl-version' => 'Client-SSL-Version',
                                                          'x-server-id' => 'X-Server-ID',
                                                          'client-ssl-socket-class' => 'Client-SSL-Socket-Class',
                                                          'x-edge-request-id' => 'X-Edge-Request-ID',
                                                          'client-ssl-cert-issuer' => 'Client-SSL-Cert-Issuer',
                                                          'client-ssl-cert-subject' => 'Client-SSL-Cert-Subject',
                                                          'client-date' => 'Client-Date',
                                                          'x-request-id' => 'X-Request-ID',
                                                          'client-peer' => 'Client-Peer',
                                                          'x-correlation-id' => 'X-Correlation-ID',
                                                          'client-response-num' => 'Client-Response-Num',
                                                          'client-ssl-cipher' => 'Client-SSL-Cipher',
                                                          'access-control-allow-origin' => 'Access-Control-Allow-Origin',
                                                          'access-control-expose-headers' => 'Access-Control-Expose-Headers',
                                                          'strict-transport-security' => 'Strict-Transport-Security'
                                                        },
                                        'client-ssl-cert-issuer' => '/C=US/O=DigiCert Inc/CN=DigiCert TLS RSA SHA256 2020 CA1',
                                        'access-control-expose-headers' => 'X-Correlation-Id, X-Request-Id, X-Server-Id',
                                        'client-ssl-cipher' => 'ECDHE-RSA-AES256-GCM-SHA384',
                                        'server' => 'nginx/1.20.1',
                                        'client-response-num' => 1,
                                        'client-ssl-cert-subject' => '/C=US/ST=Maryland/L=College Park/O=National Oceanic and Atmospheric Administration/CN=weather.gov',
                                        'client-date' => 'Wed, 14 Feb 2024 17:01:07 GMT',
                                        'client-peer' => '23.59.246.16:443',
                                        'cache-control' => 'public, max-age=3555, s-maxage=3600',
                                        'x-correlation-id' => '45922702',
                                        'expires' => 'Wed, 14 Feb 2024 18:00:22 GMT',
                                        'client-ssl-socket-class' => 'IO::Socket::SSL',
                                        'client-ssl-version' => 'TLSv1_2',
                                        'content-type' => 'application/geo+json'
                                      }, 'HTTP::Headers' ),
                 '_request' => bless( {
                                        '_uri' => bless( do{\(my $o = 'https://api.weather.gov/gridpoints/TOP/31,80/forecast')}, 'URI::https' ),
                                        '_content' => '',
                                        '_uri_canonical' => $VAR1->{'_request'}{'_uri'},
                                        '_method' => 'GET',
                                        '_headers' => bless( {
                                                               'user-agent' => 'libwww-perl/6.76'
                                                             }, 'HTTP::Headers' ),
                                        '_max_body_size' => undef
                                      }, 'HTTP::Request' ),
                 '_msg' => 'OK',
                 '_rc' => '200',
                 '_max_body_size' => undef,
                 '_content' => '{
    "@context": [
        "https://geojson.org/geojson-ld/geojson-context.jsonld",
        {
            "@version": "1.1",
            "wx": "https://api.weather.gov/ontology#",
            "geo": "http://www.opengis.net/ont/geosparql#",
            "unit": "http://codes.wmo.int/common/unit/",
            "@vocab": "https://api.weather.gov/ontology#"
        }
    ],
    "type": "Feature",
    "geometry": {
        "type": "Polygon",
        "coordinates": [
            [
                [
                    -97.137207000000004,
                    39.7444372
                ],
                [
                    -97.1367549,
                    39.7223799
                ],
                [
                    -97.108080900000004,
                    39.722725199999999
                ],
                [
                    -97.108527000000009,
                    39.744782499999999
                ],
                [
                    -97.137207000000004,
                    39.7444372
                ]
            ]
        ]
    },
    "properties": {
        "updated": "2024-02-14T13:40:48+00:00",
        "units": "us",
        "forecastGenerator": "BaselineForecastGenerator",
        "generatedAt": "2024-02-14T17:01:07+00:00",
        "updateTime": "2024-02-14T13:40:48+00:00",
        "validTimes": "2024-02-14T07:00:00+00:00/P7DT18H",
        "elevation": {
            "unitCode": "wmoUnit:m",
            "value": 456.89519999999999
        },
        "periods": [
            {
                "number": 1,
                "name": "Today",
                "startTime": "2024-02-14T11:00:00-06:00",
                "endTime": "2024-02-14T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 62,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 3.8888888888888888
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 68
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "S",
                "icon": "https://api.weather.gov/icons/land/day/sct?size=medium",
                "shortForecast": "Mostly Sunny",
                "detailedForecast": "Mostly sunny, with a high near 62. South wind 10 to 15 mph, with gusts as high as 25 mph."
            },
            {
                "number": 2,
                "name": "Tonight",
                "startTime": "2024-02-14T18:00:00-06:00",
                "endTime": "2024-02-15T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 29,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 4.4444444444444446
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 85
                },
                "windSpeed": "10 to 20 mph",
                "windDirection": "NW",
                "icon": "https://api.weather.gov/icons/land/night/sct?size=medium",
                "shortForecast": "Partly Cloudy",
                "detailedForecast": "Partly cloudy, with a low around 29. Northwest wind 10 to 20 mph, with gusts as high as 30 mph."
            },
            {
                "number": 3,
                "name": "Thursday",
                "startTime": "2024-02-15T06:00:00-06:00",
                "endTime": "2024-02-15T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 45,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -2.7777777777777777
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 88
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "NE",
                "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                "shortForecast": "Sunny",
                "detailedForecast": "Sunny, with a high near 45. Northeast wind 10 to 15 mph, with gusts as high as 25 mph."
            },
            {
                "number": 4,
                "name": "Thursday Night",
                "startTime": "2024-02-15T18:00:00-06:00",
                "endTime": "2024-02-16T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 29,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": 20
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -2.7777777777777777
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 84
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "E",
                "icon": "https://api.weather.gov/icons/land/night/bkn/snow,20?size=medium",
                "shortForecast": "Mostly Cloudy then Slight Chance Rain And Snow",
                "detailedForecast": "A slight chance of rain and snow after midnight. Mostly cloudy, with a low around 29. East wind 10 to 15 mph, with gusts as high as 20 mph. Chance of precipitation is 20%."
            },
            {
                "number": 5,
                "name": "Friday",
                "startTime": "2024-02-16T06:00:00-06:00",
                "endTime": "2024-02-16T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 37,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": 20
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -2.7777777777777777
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 89
                },
                "windSpeed": "15 mph",
                "windDirection": "N",
                "icon": "https://api.weather.gov/icons/land/day/snow,20/bkn?size=medium",
                "shortForecast": "Slight Chance Light Snow then Partly Sunny",
                "detailedForecast": "A slight chance of snow before noon. Partly sunny, with a high near 37. North wind around 15 mph, with gusts as high as 25 mph. Chance of precipitation is 20%. Little or no snow accumulation expected."
            },
            {
                "number": 6,
                "name": "Friday Night",
                "startTime": "2024-02-16T18:00:00-06:00",
                "endTime": "2024-02-17T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 18,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -6.666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 77
                },
                "windSpeed": "15 mph",
                "windDirection": "N",
                "icon": "https://api.weather.gov/icons/land/night/few?size=medium",
                "shortForecast": "Mostly Clear",
                "detailedForecast": "Mostly clear, with a low around 18. North wind around 15 mph, with gusts as high as 25 mph."
            },
            {
                "number": 7,
                "name": "Saturday",
                "startTime": "2024-02-17T06:00:00-06:00",
                "endTime": "2024-02-17T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 41,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -8.3333333333333339
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 76
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "W",
                "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                "shortForecast": "Sunny",
                "detailedForecast": "Sunny, with a high near 41. West wind 10 to 15 mph, with gusts as high as 25 mph."
            },
            {
                "number": 8,
                "name": "Saturday Night",
                "startTime": "2024-02-17T18:00:00-06:00",
                "endTime": "2024-02-18T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 25,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -6.666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 79
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "W",
                "icon": "https://api.weather.gov/icons/land/night/skc?size=medium",
                "shortForecast": "Clear",
                "detailedForecast": "Clear, with a low around 25. West wind 10 to 15 mph, with gusts as high as 20 mph."
            },
            {
                "number": 9,
                "name": "Sunday",
                "startTime": "2024-02-18T06:00:00-06:00",
                "endTime": "2024-02-18T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 51,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -1.6666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 83
                },
                "windSpeed": "10 mph",
                "windDirection": "SW",
                "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                "shortForecast": "Sunny",
                "detailedForecast": "Sunny, with a high near 51. Southwest wind around 10 mph."
            },
            {
                "number": 10,
                "name": "Sunday Night",
                "startTime": "2024-02-18T18:00:00-06:00",
                "endTime": "2024-02-19T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 31,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": -1.6666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 87
                },
                "windSpeed": "10 mph",
                "windDirection": "S",
                "icon": "https://api.weather.gov/icons/land/night/sct?size=medium",
                "shortForecast": "Partly Cloudy",
                "detailedForecast": "Partly cloudy, with a low around 31."
            },
            {
                "number": 11,
                "name": "Washington\'s Birthday",
                "startTime": "2024-02-19T06:00:00-06:00",
                "endTime": "2024-02-19T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 53,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 2.2222222222222223
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 87
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "SW",
                "icon": "https://api.weather.gov/icons/land/day/sct?size=medium",
                "shortForecast": "Mostly Sunny",
                "detailedForecast": "Mostly sunny, with a high near 53."
            },
            {
                "number": 12,
                "name": "Monday Night",
                "startTime": "2024-02-19T18:00:00-06:00",
                "endTime": "2024-02-20T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 31,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 2.2222222222222223
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 87
                },
                "windSpeed": "10 mph",
                "windDirection": "W",
                "icon": "https://api.weather.gov/icons/land/night/few?size=medium",
                "shortForecast": "Mostly Clear",
                "detailedForecast": "Mostly clear, with a low around 31."
            },
            {
                "number": 13,
                "name": "Tuesday",
                "startTime": "2024-02-20T06:00:00-06:00",
                "endTime": "2024-02-20T18:00:00-06:00",
                "isDaytime": true,
                "temperature": 57,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 1.6666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 89
                },
                "windSpeed": "10 to 15 mph",
                "windDirection": "SW",
                "icon": "https://api.weather.gov/icons/land/day/few?size=medium",
                "shortForecast": "Sunny",
                "detailedForecast": "Sunny, with a high near 57."
            },
            {
                "number": 14,
                "name": "Tuesday Night",
                "startTime": "2024-02-20T18:00:00-06:00",
                "endTime": "2024-02-21T06:00:00-06:00",
                "isDaytime": false,
                "temperature": 36,
                "temperatureUnit": "F",
                "temperatureTrend": null,
                "probabilityOfPrecipitation": {
                    "unitCode": "wmoUnit:percent",
                    "value": null
                },
                "dewpoint": {
                    "unitCode": "wmoUnit:degC",
                    "value": 1.6666666666666667
                },
                "relativeHumidity": {
                    "unitCode": "wmoUnit:percent",
                    "value": 83
                },
                "windSpeed": "10 mph",
                "windDirection": "S",
                "icon": "https://api.weather.gov/icons/land/night/sct?size=medium",
                "shortForecast": "Partly Cloudy",
                "detailedForecast": "Partly cloudy, with a low around 36."
            }
        ]
    }
}',
                 '_protocol' => 'HTTP/1.1'
               }, 'HTTP::Response' );
