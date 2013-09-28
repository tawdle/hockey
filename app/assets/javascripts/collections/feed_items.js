App.FeedItems = Backbone.Collection.extend({
  model: App.FeedItem,

  comparator: function(feed_item) {
    return feed_item.id;
  }

});

