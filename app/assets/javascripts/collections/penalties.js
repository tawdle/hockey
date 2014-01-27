window.App = window.App || {};

App.Penalties = Backbone.Collection.extend({
  model: App.Penalty,
  gameId: null,

  initialize: function(models, options) {
    this.gameId = options.gameId;
  },

  url: function() {
    return "/marker/games/" + this.gameId + "/penalties";
  },

  comparator: function(penalty) {
    return penalty.id;
  }

});

