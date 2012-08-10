use base 'N3manager::Projects';

sub init {
    my $self = shift;
    my $projects = N3manager::Projects->new;
    N3->request->data($projects->hash);
}
