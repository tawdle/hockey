App.PenaltyView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#penalty-view").html());
    this.listenTo(this.model, "change", this.render);
  },

  tagName: "tr",

  events: {
    "click a.edit" : "edit"
  },

  edit: function(e) {
    e.preventDefault();
    App.dispatcher.trigger("penalty:edit", this.model);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON().penalty));
    return this;
  }
});


