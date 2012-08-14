var App;
function main() {
    App = new AppRouter();
    App.renderHeader();
    App.renderFooter();
    Backbone.history.start();
}

var AppRouter = Backbone.Router.extend({
    routes: {
	"": "main",
	"projects/:command/:project/:vars": "showProjects",
	"projects/:command/:project": "showProjects",
	"projects/:command": "showProjects",
	"projects": "showProjects",
	"about": "about"
    },
    main: function() {
	if (!this.introView) {
	    this.introView = new IntroView();
	}
	this.introView.render();
    },
    showProjects: function(command, project, vars) {
	var app = this;
	$.getJSON('/projects', function(data) {
	    app.projects.reset();
	    app.projects.add(data.projects);
	    app.renderProjects(command, project, vars);
	});
    },
    about: function() {
	if (!this.aboutView) {
	    this.aboutView = new AboutView();
	}
	this.aboutView.render();
    },
    renderHeader: function() {
	if (!this.headerView) {
	    this.headerView = new HeaderView();
	}
	this.headerView.render();
    },
    renderFooter: function() {
	if (!this.footerView) {
	    this.footerView = new FooterView();
	}
	this.footerView.render();
    },
    renderProjects: function(command, project, vars) {
	if (!this.projectsView) {
	    this.projectsView = new ProjectsView();
	}
	this.projectsView.render({ projects: this.projects });
    },
    initialize: function() {
	this.projects = new Projects();
	this.please_wait('#main');
    },
    view_source: function(container, directory) {
	this.please_wait(container);
	var app = this;
	$.getJSON('/directory', { directory: directory }, function(data) {
	    app.view_source_callback(container, directory, data);
	});
    },
    view_source_callback: function(container, directory, data) {
/* WRITE ME */	    
    },
    environment: function(container, project) {
	this.please_wait(container);

    },
    show_file: function(container, file) {
	this.please_wait(container);
	var app = this;
	$.getJSON('/file', { file: file }, function(data) {
	    app.show_file_callback(container, file, data);
	});
    },
    show_file_callback: function(container, file, data) {
	var html = '<section>' + 
		'<a href="#" onclick="App.edit_file(\'' + container + '\', \'' + file + '\'); return false;">Edit</a>' +
		'<scrollable><pre>' + 
		    data.content.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;') + 
		'</pre></scrollable>' +
	    '</section>';
	$(container).html(html);
    },
    edit_file: function(container, file) {
	var content = $(container + ' pre').html();
	var html = '<section>' +
		'<ul><li><a href="#" onclick="App.save_file(\'' + container + '\', \'' + file + '\'); return false;">Save</a></li>' +
		'<li><a href="#" onclick="App.show_file(\'' + container + '\', \'' + file + '\'); return false;">Cancel</a></li>' +
		'<div><textarea>' + content.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&') + '</textarea></div>' +
	    '</section>';
	$(container).html(html);
    },
    save_file: function(container, file) {
	var content = $(container + ' textarea').val();
	this.please_wait(container);
	var app = this;
	$.getJSON('/file', { file: file, content: content }, function(data) {
	    app.show_file_callback(container, file, data);
	});
    },
    show_status: function(container, project) {
	this.please_wait(container);

    },
    please_wait: function(container) {
	$(container).html(JST['htdocs/scripts/templates/please_wait']());
    }
});
