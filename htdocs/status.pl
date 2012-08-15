sub init {
    my $self = shift;
    my $request = N3->request;
    my $project = $request->param('project');
    my $git_status = {};
    my $apache_status = {};
    # WRITE ME
    $request->data({ apache_status => $apache_status, git_status => $git_status });
}
