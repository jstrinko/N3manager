var AboutView = Backbone.View.extend({
    initialize:function() {
    },
    render:function() {
	$(this.el).html(JST['htdocs/scripts/templates/about']);
	$('main').html(this.el);
    }
});
