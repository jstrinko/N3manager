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
	"status": "appStatus",
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
    appStatus: function() {

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
	if (command) {
	    if (project) {
		if (command == 'view_source') {
		    this.view_source('#workarea_' + project, vars.replace(/\|/, '/'));
		}
		else if (command == 'environment') {
		    this.environment('#workarea_' + project, project);
		}
		else if (command == 'file') {
		    this.file('#workarea_' + project, vars.replace(/\|/, '/'));
		}
		else if (command == 'restart_apache') {
		    this.restart_apache('#workarea_' + project, project)
		}
	    }
	    else {
		/* none of these yet */
	    }
	}
    },
    initialize: function() {
	this.projects = new Projects();
	this.please_wait('#main');
    },
    view_source: function(container, directory) {
	this.please_wait(container);
    },
    environment: function(container, project) {

    },
    file: function(container, file) {
	this.please_wait(container);

    },
    restart_apache: function(container, project) {
	this.please_wait(container);

    },
    please_wait: function(container) {
	$(container).html(JST['htdocs/scripts/templates/please_wait']());
    }
});
