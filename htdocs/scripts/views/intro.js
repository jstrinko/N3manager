var IntroView = Backbone.View.extend({
    initialize:function() {
    },
    render:function() {
	$(this.el).html(JST['htdocs/scripts/templates/intro']);
	$('main').html(this.el);
    }
});
