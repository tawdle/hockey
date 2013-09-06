window.App = window.App || {};

App.Players = Backbone.Collection.extend({
  gameId: null,

  model: App.Player,

  initialize: function(models, options) {
    this.gameId = options.gameId;
  },

  url: function() {
    return "/games/" + this.gameId + "/roster";
  }

});


