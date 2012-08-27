use Form;
use N3manager::Projects;

sub init {
    my $self = shift;
    my $request = N3->request;
    my @fields = (
	{
	    type => 'text',
	    name => 'project_name',
	    label => 'Name:',
	    required => 1,
	},
	{
	    type => 'dropdown',
	    name => 'project_type',
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
	}
    );
    if ($form->check) {
	my $projects = N3manager::Projects->new;
	$projects->create_project({
	    name => $form->get('project_name'),
	    type => $form->get('project_type'),
	});
    }
    else {
	$request->data($form->hash);
    }
    return;
}
