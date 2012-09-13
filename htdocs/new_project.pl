use Form;
use N3manager::Projects;
use Data::Dumper;

sub init {
    my $self = shift;
    my $request = N3->request;
    my @fields = (
	{
	    type => 'text',
	    name => 'name',
	    label => 'Name:',
	    required => 1,
	},
	{
	    type => 'text',
	    name => 'port',
	    label => 'Port:',
	    validate => \&validate_port,
	},
	{
	    type => 'dropdown',
	    name => 'type',
	    label => 'Type:',
	    value => 'N3',
	    items => [
		{ label => 'N3', value => 'N3' },
		{ label => 'Other', value => 'static' },
	    ],
	},
    );
    my $form = Form->new(
	{
	    name => 'project',
	    fields => \@fields,
	    label => "New Project",
	    _request => $request,
	}
    );
    if ($form->check) {
	my $projects = N3manager::Projects->new;
	my $project = $projects->create_project({
	    name => $form->val('name'),
	    type => $form->val('type'),
	    port => $form->val('port'),
	});
	if ($project) {
	    $request->data({ url => '' });
	}
	else {
	    $form->error(1);
	    $form->error_text("Unable to create a project!");
	    $request->data($form->hash);
	}	
    }
    else {
	$request->data($form->hash);
    }
    return;
}

sub validate_port {
    my $field = shift;
    my $form = shift;
    return "Must be a number between 1000 and 50000" unless $field->{value} =~ m{^\d+$} && $field->{value} >= 1000 && $field->{value} <= 50000;
    return;
}
