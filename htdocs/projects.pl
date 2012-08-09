use base 'N3manager::Projects'

sub init {
    my $self = shift;
    my $projects = N3manager::Projects->new;
    return $projects->hash;
}
