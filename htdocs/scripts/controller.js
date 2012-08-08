var App;
function main() {
    App = new AppRouter();
    Backbone.history.start();
}

var AppRouter = Backbone.Router.extend({
    routes: {
	"": "main",
	"projects": "projects",
	"status": "status",
	"about": "about"
    },
});
