package N3manager::Projects;

use base 'N3::Hashable';

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->populate_projects;
    return $self;
}

sub populate_projects {
    my $self = shift;
    my @files = glob $ENV{PROJECTS_DIR} . "/*.env";
    my @projects;
    foreach my $file (@files) {
	warn $file;
    }
    $self->{projects} = \@projects;
}

1;
