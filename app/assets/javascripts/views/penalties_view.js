window.App = window.App || {};

App.PenaltiesView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = Number(this.$el.attr("data-team-id"));
  },

  events: {
    "click a.add-penalty" : "addPenalty"
  },

  addPenalty: function(e) {
    e.preventDefault();
    var penalty = new App.Penalty({}, {collection: this.collection});
    var view = new App.PenaltyView({ model: penalty, teamId: this.teamId });
    this.$(".penalty-editor").hide().html(view.render().el).slideDown();
  },

  render: function() {
    this.$(".penalty-editor").toggle(false);
  }

});

