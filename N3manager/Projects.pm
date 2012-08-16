package N3manager::Projects;

use base 'N3::Hashable';
use N3::Util;

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
    my @projects = ();
    foreach my $file (@files) {
	my $project = N3manager::Project->new(
	    {
		project_file => $file
	    }
	);
	push @projects, $project;
    }
    $self->projects(\@projects);
}

sub projects {
    my $self = shift;
    $self->{projects} = shift if @_;
    return wantarray ? @{$self->{projects}} : $self->{projects};
}

sub project {
    my $self = shift;
    my $name = shift;
    foreach my $project ($self->projects) {
	return $project if $project->name eq $name;
    }
}

package N3manager::Project;

use base 'N3::Hashable';

sub new {
    my $class = shift;
    my $self = shift;
    bless $self, $class;
    $self->init;
    return $self;
}

sub project_file {
    my $self = shift;
    $self->{project_file} = shift if @_;
    return $self->{project_file};
}

sub apache_conf_file {
    my $self = shift;
    $self->{apache_conf_file} = shift if @_;
    return $self->{apache_conf_file};
}

sub startup_script {
    my $self = shift;
    $self->{startup_script} = shift if @_;
    return $self->{startup_script};
}

sub environment {
    my $self = shift;
    $self->{environment} = shift if @_;
    return $self->{environment};
}

sub user {
    my $self = shift;
    $self->{user} = shift if @_;
    return $self->{user};
}

sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}

sub type {
    my $self = shift;
    $self->{type} = shift if @_;
    return $self->{type};
}

sub init {
    my $self = shift;
    my $file = $self->project_file;
    my ($type, $uid_project, $ext) = split(/\./, $file);
    my ($user, $name) = split(/-/, $uid_project);
    return unless $ext eq 'env';
    return unless $file && -e $file;
    $type =~ s{.*\/}{}g;
    $self->user($user);
    $self->name($name);
    $self->type($type);
    my $contents = N3::Util::file_contents($file);
    my $env_vars = {};
    while ($contents =~ m{export (\S+)(\s+)?=(\s+)?(\S+)(\s+)?(\n|$)}gis) {
	$env_vars->{$1} = $4;
    }
    $self->environment($env_vars);
    my $apache_conf = "$ENV{APACHE_CONF_DIR}/$type.$uid_project.conf";
    $self->apache_conf_file($apache_conf) if -e $apache_conf;
    my $startup_script = "$ENV{START_DIR}/start-$name";
    $self->startup_script($startup_script) if -e $startup_script;
}

1;
