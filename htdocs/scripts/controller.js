var App;
function main() {
    App = new AppRouter();
    App.renderHeader();
    App.renderFooter();
    Backbone.history.start();
}

var AppRouter = Backbone.Router.extend({
    routes: {
	"": "showProjects",
	"about": "about"
    },
    showProjects: function() {
	var app = this;
	$.getJSON('/projects', function(data) {
	    app.projects.reset();
	    app.projects.add(data.projects);
	    app.renderProjects();
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
    renderProjects: function() {
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
	$(container).html(JST['htdocs/scripts/templates/directory']({ container: container, directory: directory, data: data }));
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
	$(container).html(JST['htdocs/scripts/templates/show_file']({ container: container, file: file, data: data }));
    },
    edit_file: function(container, file) {
	this.please_wait(container);
	var app = this;
	$.getJSON('/file', { file: file }, function(data) {
	    app.edit_file_callback(container, file, data);
	});
    },
    edit_file_callback: function(container, file, data) {
	$(container).html(JST['htdocs/scripts/templates/edit_file']({ container: container, file: file, data: data }));
	$(container + ' textarea').val(data.content);
    },
    save_file: function(container, file) {
	var content = $(container + ' textarea').val();
	this.please_wait(container);
	var app = this;
	$.getJSON('/file', { file: file, content: content }, function(data) {
	    app.show_file_callback(container, file, data);
	});
    },
    show_status: function(container, project, type, user) { 
	this.please_wait(container);
	var app = this;
	$.getJSON('/status', { project: project, type: type, user: user }, function(data) {
	    app.show_status_callback(container, data);
	});
    },
    show_status_callback: function(container, data) {
	$(container).html(JST['htdocs/scripts/templates/status']({ container: container, data: data }));
    },
    please_wait: function(container) {
	$(container).html(JST['htdocs/scripts/templates/please_wait']());
    }
});
