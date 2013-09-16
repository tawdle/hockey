App.PenaltyView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#penalty-view").html());
  },

  tagName: "tr",

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON().penalty));
    return this;
  }
});


