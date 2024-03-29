window.App = window.App || {};

App.Goal = Backbone.Model.extend({
  initialize: function() {
  },

  toJSON: function() {
    return { goal: _.clone(this.attributes) };
  },

  defaults: function() {
    return {
      team_id: null,
      player_ids: [],
      elapsed_time: null,
      period: null
    };
  }
});

