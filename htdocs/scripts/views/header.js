var HeaderView = Backbone.View.extend({
    initialize: function() {
    },
    render: function() {
	$(this.el).html(JST['htdocs/scripts/templates/header']);
	$('header').html(this.el);
    }
});
