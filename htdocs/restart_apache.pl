use N3manager::Projects;

sub init {
    my $self = shift;
    my $request = N3->request;
    my $project_name = $request->param('project');
    if ($project_name eq $ENV{PROJECT}) {
	$request->data({ error => "Cannot restart current project" });
	return;
    }
    my $projects = N3manager::Projects->new;
    my $project = $projects->project($project_name);
    if (!$project) {
	$request->data({ error => "No such project $project_name" });
    }
    else {
        my $script = $project->startup_script;
	exec $script;
	$request->data(
	    { status => 'OK' },
	);
    }
    return;
}
