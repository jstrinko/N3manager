var ProjectsView = Backbone.View.extend({
    initialize:function() {
    },
    render:function(data) {
        $(this.el).html(JST['htdocs/scripts/templates/projects'](data));
        $('main').html(this.el);
    }
});
