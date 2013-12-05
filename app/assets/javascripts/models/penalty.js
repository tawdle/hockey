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

  sameStoppageAs: function(other) {
    return this.get("period") == other.get("period") &&
      this.get("elapsed_time") == other.get("elapsed_time");
  },

  defaults: function() {
    return {
      state: "created",
      period: App.game.get("period"),
      elapsed_time: App.game.lastPausedAt || App.game.get("clock").get("elapsed_time"),
      penalizable_id: null,
      penalizable_type: null,
      serving_player_id: null,
      category: null,
      infraction: null,
      minutes: null
    };
  }
});

