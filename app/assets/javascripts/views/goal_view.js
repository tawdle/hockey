window.App = window.App || {};

App.GoalView = Backbone.View.extend({
  initialize: function() {
  },

  tagName: "div",

  events: {
    "change #player0": "revealAssist",
    "change #player1": "revealSecondaryAssist",
    "click input[type=submit]" : "saveAndClose",
    "click #goal-cancel" : "destroyAndClose"
  },

  revealAssist: function() {
    this.$("#goal-assist").slideDown();
  },

  revealSecondaryAssist: function() {
    this.$("#goal-secondary-assist").slideDown();
  },

  render: function() {
    var players = App.players.where({team_id: Number(this.model.get("team_id"))});
    var form = _.template($("#goal-form").html(), {players: players, ids: this.model.get("player_ids") });
    this.$el.html(form);
    var lenPlayers = this.model.get("player_ids");
    this.$("#goal-assist").toggle(lenPlayers > 0);
    this.$("#goal-secondary-assist").toggle(lenPlayers > 1);
    return this;
  },

  saveAndClose: function(event) {
    event.preventDefault();
    var player_ids = _.uniq(_.compact(_.map(this.$("select"), function(select) { return Number($(select).val()); } )));
    var self = this;
    this.model.save({player_ids: player_ids}, { success: function(model, response, options) { self.$el.slideUp(); }});
    return false;
  },

  destroyAndClose: function(event) {
    event.preventDefault();
    var self = this;
    this.model.destroy({success: function() { self.$el.slideUp(); }});
  }
});

