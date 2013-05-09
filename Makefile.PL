use 5.014;
use ExtUtils::MakeMaker;

WriteMakefile(
    PREREQ_PM => {
        'Imager' => 0,
        'Plack' => 0,
    },
);
