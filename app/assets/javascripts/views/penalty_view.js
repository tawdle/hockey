App.PenaltyView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#penalty-view").html());
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.model, "destroy", this.remove, this);
  },

  tagName: "tr",

  events: {
    "click a.edit" : "edit",
    "click a.delete" : "deletePenalty",
  },

  edit: function(e) {
    e.preventDefault();
    App.dispatcher.trigger("penalty:edit", this.model);
  },

  deletePenalty: function(e) {
    e.preventDefault();
    if (confirm("Delete this penalty?")) {
      this.model.destroy({ wait: true });
    }
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON().penalty));
    return this;
  }
});


