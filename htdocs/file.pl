use N3::Util;

sub init {
    my $self = shift;
    my $request = N3->request;
    my $file = $request->param('file');
    my $content = $request->param('content');
    if ($content) {
	open(DAT, ">$file") or die "Could not open $file: $!";
	print DAT $content;
	close DAT;
    }
    if (-e $file) {
	$request->data({ content => N3::Util::file_contents($file) });
    }
    else {
	$request->data({ error => "No such file $file" });
    }
}
