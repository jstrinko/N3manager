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
    showProjects: function() {
	if (!this.projects) {
	    $.getJSON('/projects', function(data) {
		this.projects.add(data.projects);
		this.renderProjects();
	    });
	}
	else {
	    this.renderProjects();
	}
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
    renderProjects: function() {
	if (!this.projectsView) {
	    this.projectsView = new ProjectsView();
	}
	this.projectsView.render({ projects: this.projects });
    }
});
