window.App = window.App || {};

App.Goal = Backbone.Model.extend({
  toJSON: function() {
    return { goal: _.clone(this.attributes) };
  },

  defaults: function() {
    return {
      team_id: null,
      player_ids: []
    };
  }
});

