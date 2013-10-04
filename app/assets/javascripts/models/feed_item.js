App.FeedItem = Backbone.Model.extend({
  initialize: function() {
    this.listenTo(this, 'remove', this.destroy);
  }

});


