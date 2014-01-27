window.App = window.App || {};

App.Goals = Backbone.Collection.extend({
  model: App.Goal,
  gameId: null,

  initialize: function(models, options) {
    this.gameId = options.gameId;
  },

  url: function() {
    return "/marker/games/" + this.gameId + "/goals";
  }

});

