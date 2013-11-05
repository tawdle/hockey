App.FeedItemView = Backbone.View.extend({
  initialize: function() {
    this.template = _.template($("#feed-item").html());
    this.listenTo(this.model, "change", this.render);
    this.listenTo(this.model, "remove", this.remove);
  },

  tagName: "tr",

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$("time.timeago").timeago();
    return this;
  }
});



