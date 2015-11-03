use 5.012;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'bgimg',
    PREREQ_PM => {
        'Imager' => 0,
        'Plack' => 0,
        'Starman' => 0,
    },
);
