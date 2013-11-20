window.App = window.App || {};

App.Penalty = App.EmbeddedModel.extend({
  initialize: function() {
  },

  toJSON: function() {
    return { penalty: _.clone(this.attributes) };
  },

  models: function() {
    return {
      timer: App.Timer
    };
  },

  teamId: function() {
    var player_id = this.get("player_id");
    if (!player_id) return null;

    var player = App.players.get(player_id);
    if (!player) return null;

    return player.get("team_id");
  },

  sameStoppageAs: function(other) {
    return this.get("period") == other.get("period") &&
      this.get("elapsed_time") == other.get("elapsed_time");
  },

  defaults: function() {
    return {
      state: "created",
      period: App.game.get("period"),
      elapsed_time: App.game.lastPausedAt || App.game.get("clock").get("elapsed_time"),
      player_id: null,
      serving_player_id: null,
      category: null,
      infraction: null,
      minutes: null
    };
  }
});

