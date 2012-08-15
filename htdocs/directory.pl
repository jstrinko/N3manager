our $Icons = {
    txt => 'txt',
    pm => 'application_x_perl',
    pl => 'application_x_perl',
    html => 'text_html',
    htm => 'text_html',
    js => 'application_x_javascript',
    jst => 'text_html',
    json => 'application_x_javascript',
    php => 'application_x_php',
    sh => 'application_x_executable_script',
    xml => 'application_xml',
    nfo => 'info',
    md => 'info',
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
    my @contents = glob $directory . '/*';
    my @dir_contents;
    my $up_one;
    ($up_one) = $directory =~ m{^(.*)/};
    push @dir_contents, { 
	type => 'directory',
	location => $up_one,
	icon => 'folder',
	name => '..',
    } if $up_one;
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
	    ($extension) = $element =~ m{.*\.(.*?)$};
	    push @dir_contents, { 
		type => 'file', 
		location => $element,
		icon => $Icons->{lc($extension)} || 'txt',
		editable => -T $element ? 1 : 0,
	    };
	}
    }
    @dir_contents = sort { $a->{type} cmp $b->{type}  } @dir_contents;
    $request->data({ content => \@dir_contents });
}
