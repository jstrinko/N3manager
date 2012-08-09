var FooterView = Backbone.View.extend({
    initialize: function() {
	this.el = $('footer');
    },
    render: function() {
	$(this.el).html(JST['htdocs/scripts/templates/footer']);
    }
});
