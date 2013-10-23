window.App = window.App || {};

App.Players = Backbone.Collection.extend({
  gameId: null,

  model: App.Player,

  initialize: function(models, options) {
    this.gameId = options.gameId;
  },

  url: function() {
    return "/games/" + this.gameId + "/roster";
  },

  comparator: function(a, b) {
    var aJersey = Number(a.get("jersey_number"));
    var bJersey = Number(b.get("jersey_number"));

    if (aJersey == bJersey) {
      return (a.get("name") < b.get("name")) ? -1 : 1;
    } else {
      return (aJersey < bJersey) ? -1: 1;
    }
  }

});


