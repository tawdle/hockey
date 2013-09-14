window.App = window.App || {};

App.Penalty = Backbone.Model.extend({
  toJSON: function() {
    return { penalty: _.clone(this.attributes) };
  },

  defaults: function() {
    return {
      state: "created",
      player_id: null,
      serving_player_id: null,
      period: null,
      category: "minor"
    };
  }
});

