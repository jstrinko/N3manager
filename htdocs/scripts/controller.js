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
	"projects": "projects",
	"status": "app_status",
	"about": "about"
    },
    main: function() {
	if (!App.introView) {
	    App.introView = new IntroView();
	}
	App.introView.render();
    },
    projects: function() {

    },
    app_status: function() {

    },
    about: function() {
	if (!App.aboutView) {
	    App.aboutView = new AboutView();
	}
	App.aboutView.render();
    },
    renderHeader: function() {
	if (!App.headerView) {
	    App.headerView = new HeaderView();
	}
	App.headerView.render();
    },
    renderFooter: function() {
	if (!App.footerView) {
	    App.footerView = new FooterView();
	}
	App.footerView.render();
    }
});
