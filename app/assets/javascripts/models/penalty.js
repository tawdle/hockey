window.App = window.App || {};

App.Penalty = App.EmbeddedModel.extend({
  initialize: function() {
    this.listenTo(this, 'remove', this.destroy);
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

  defaults: function() {
    return {
      state: "created",
      period: App.game.period,
      elapsed_time: App.game.get("clock").get("elapsedTime"),
      player_id: null,
      serving_player_id: null,
      category: null,
      infraction: null,
      minutes: null
    };
  }
});

