
use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "write your linewise code for handles; this does the rest",
  "AUTHOR" => "Ricardo SIGNES <rjbs\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Mixin-Linewise",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Mixin::Linewise",
  "PREREQ_PM" => {
    "Carp" => 0,
    "IO::File" => 0,
    "IO::String" => 0,
    "Sub::Exporter" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Encode" => 0,
    "Test::More" => "0.96",
    "lib" => 0,
    "utf8" => 0
  },
  "VERSION" => "0.103",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Encode" => 0,
  "IO::File" => 0,
  "IO::String" => 0,
  "Sub::Exporter" => 0,
  "Test::More" => "0.96",
  "lib" => 0,
  "strict" => 0,
  "utf8" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



