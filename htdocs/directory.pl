our $Icons = {
    txt => 'txt',
    pm => 'application_x_perl',
    pl => 'application_x_perl',
    html => 'text_html',
    htm => 'text_html',
    js => 'application_x_javascript',
    json => 'application_x_javascript',
    php => 'application_x_php',
    sh => 'application_x_executable_script',
    xml => 'application_xml',
    nfo => 'info',
    ico => 'image_png',
    jpg => 'image_png',
    jpeg => 'image_png',
    gif => 'image_png',
    png => 'image_png',
    rpm => 'application_x_rpm',
    rb => 'application_x_ruby',
};

sub init {
    my $self = shift;
    my $request = N3->request;
    my $directory = $request->param('directory');
    my @contents = glob $directory;
    my @dir_contents;
    foreach my $element (@contents) {
	if (-d $element) {
	    push @dir_contents, { 
		type => 'directory', 
		location => $element,
		icon => 'folder',
	    };
	}
	elsif (-f $element) {
	    my $extension;
	    ($extension) = $element =~ m{.*(\..*?)$};
	    push @dir_contents, { 
		type => 'file', 
		location => $element,
		icon => $Icons->{lc($extension)} || 'file',
		editable => -T $element ? 1 : 0,
	    };
	}
    }
    $request->data({ content => \@dir_contents });
}
