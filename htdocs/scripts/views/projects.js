var ProjectsView = Backbone.View.extend({
    initialize:function() {
    },
    render:function() {
        $(this.el).html(JST['htdocs/scripts/templates/projects']);
        $('main').html(this.el);
    }
});
