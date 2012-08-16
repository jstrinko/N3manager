use N3manager::Projects;

sub init {
    my $self = shift;
    my $request = N3->request;
    my $project_name = $request->param('project');
    my $type = $request->param('type');
    my $user = $request->param('user');
    my $projects = N3manager::Projects->new;
    my $project = $projects->project($project_name);
    return unless $project;
    my $apache_status = {};
    my $git_status_command = ". '" . $project->project_file . "'; cd $ENV{SRCTOP}/$project_name; git status";
    my $git_status = `$git_status_command`;
    my $env = $project->environment;
    my $pid_file = $env->{APACHE_CONF_DIR} . "/pids/$type.$user-$project_name.pid";
    my $apache_running_command = "ps aux|grep `cat $pid_file`|grep -v grep";
    my $apache_running_output = `$apache_running_command`;
    my $apache_running = $apache_running_output =~ m{^\s*$} ? 0 : 1;
    my $ps_command = "ps aux|grep apache2|grep '$type.$user-$project_name.conf'|grep -v grep";
    my $ps_output = `$ps_command`;
    my @lines = split(/\n/, $ps_output);
    my $process_data;
    foreach my $line (@lines) {
	my $data = {};
	(
	    $data->{uid}, 
	    $data->{pid}, 
	    $data->{cpu}, 
	    $data->{mem}, 
	    $data->{vsz}, 
	    $data->{rss}, 
	    $data->{tty}, 
	    $data->{stat}, 
	    $data->{start}, 
	    $data->{'time'}, 
	    $data->{command}
	) = split(/\s+/, $line);
	$process_data->{$data->{pid}} = $data;
    }
    $apache_status->{running} = $apache_running;
    $apache_status->{processes} = $process_data;
    $apache_status->{log_tail} = `tail -n 50 '$env->{LOGTOP}/$project_name/error_log'`;
    $request->data({ apache_status => $apache_status, git_status => $git_status });
}
