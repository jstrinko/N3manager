use N3::Util;
use N3manager::Projects;

our $Signal_Map = {
    TERM => 15,
    QUIT => 3,
    KILL => 9,
    USR1 => 10,
    USR2 => 12,
};

sub init {
    my $self = shift;
    my $request = N3->request;
    my $signal = $request->param('signal');
    my $project_name = $request->param('project');
    my $projects = N3manager::Projects->new;
    my $project = $projects->project($project_name);
    if (!$project) {
        $request->data({ error => "No such project $project_name" });
    }
    else {
	my $environment = $project->environment;
	my $pid_file = $environment->{APACHE_CONF_DIR} . "/pids/" . $project->type . "." . $project->user . "-$project_name.pid";
	my $pid = N3::Util::file_contents($pid_file);
	chomp $pid;
	kill $Signal_Map->{$signal}, $pid;
        $request->data(
            { status => 'OK' },
        );  
    }
    return;
}
