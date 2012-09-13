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

sub create_project {
    my $self = shift;
    my $data = shift;
    if ($data->{type} eq 'N3') {
	my $project_file = "$ENV{PROJECTS_DIR}/N3.$ENV{USER}-$data->{name}.env";
	my $apache_conf_file = "$ENV{APACHE_CONF_DIR}/N3.$ENV{USER}-$data->{name}.conf";
	my $apache_pid_file = "$ENV{APACHE_CONF_DIR}/pids/N3.$ENV{USER}-$data->{name}.pid";
my @dirs = (
    $ENV{LOGTOP} . '/' . $data->{name},
    $ENV{SRCTOP} . '/' . $data->{name},
    $ENV{SRCTOP} . '/' . $data->{name} . '/htdocs',
    $ENV{SRCTOP} . '/' . $data->{name} . '/' . $data->{name},
);

foreach my $dir (@dirs) {
    print "Creating directory: $dir\n";
    mkpath $dir;
}

	my $contents = N3::Util::file_contents("$ENV{SRCTOP}/$ENV{PROJECT}/etc/N3.template");
	my $replacements = {
	    LOGTOP => $ENV{LOGTOP},
	    PROJECT => $data->{name},
	    USER => $ENV{USER},
	    SRCTOP => $ENV{SRCTOP},
	    GROUP => $ENV{USER},
	    SERVER_ROOT => $ENV{APACHE_CONF_DIR},
	    PID_FILE => $apache_pid_file,
	    PORT => $data->{port},
	};
	my $new_content = N3::Replace::replace_words($contents, $replacements);
	open(FILE, ">$apache_conf_file") or die $!;
	print FILE $new_content;
	close FILE;

	open(FILE, ">$project_file") or die $!;
	print FILE <<END;
export HOME=$ENV{HOME}
export PERL5LIB=$ENV{SRCTOP}/$data->{name}:$ENV{PERL5LIB}:\$PERL5LIB
export PERLLIB=\$PERL5LIB
export PATH=$ENV{SRCTOP}/$data->{name}/bin:$ENV{SRCTOP}/N3/bin:$ENV{HOME}/bin:\$PATH
export LOGTOP=$ENV{LOGTOP}
export SRCTOP=$ENV{SRCTOP}
export PROJECT=$data->{name}
export STATIC_SERVER=$ENV{STATIC_SERVER}
export ENVIRONMENT_TYPE=dev
export PROJECTS_DIR=$ENV{PROJECTS_DIR}
export APACHE_CONF_DIR=$ENV{APACHE_CONF_DIR}
export APACHE_BIN=$ENV{APACHE_BIN}
export START_DIR=$ENV{HOME}/bin
export ENCRYPTION_KEY=$ENV{ENCRYPTION_KEY}
END
	close FILE;
    }
    else {
	# do something here
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
