window.App = window.App || {};

App.Penalty = Backbone.Model.extend({
  toJSON: function() {
    return { penalty: _.clone(this.attributes) };
  },

  defaults: function() {
    return {
      state: "created",
      period: App.game.period,
      elapsed_time: App.game.get("clock").get("elapsedTime"),
      player_id: null,
      serving_player_id: null,
      category: "minor",
      infraction: "boarding",
      minutes: 2
    };
  }
});

