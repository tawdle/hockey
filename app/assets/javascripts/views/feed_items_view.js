App.FeedItemsView = Backbone.View.extend({
  initialize: function(options, other) {
    this.listenTo(App.feedItems, 'add', this.addOne);
    this.listenTo(App.feedItems, 'reset', this.reset);
    this.listenTo(App.feedItems, 'remove', this.showHideTable);
    this.addAll();
  },

  events: {
  },

  addOne: function(feed_item, collection, options) {
    var view = new App.FeedItemView({model: feed_item});
    view.render();
    this.$el.prepend(view.el);
    if (!options.bulk) {
      view.$el.hide().fadeIn();
      this.showHideTable();
    }
  },

  addAll: function() {
    App.feedItems.each(function(item) { this.addOne(item, this.collection, {bulk: true}); }, this);
    this.showHideTable();
  },

  reset: function() {
    console.log("got a reset!");
    this.$el.empty();
    this.addAll();
  },

  showHideTable: function() {
    this.$el.parent().toggle(App.feedItems.length > 0);
  },

  render: function() {
  }
});


