window.App = window.App || {};

App.Game = App.EmbeddedModel.extend({
  // The game subscribes to the faye channel and holds a references to all of the subsidiary models.
  // When changes happen, it delegates to the relevant models to update them, and the views do their things.

  // We need to be supplied with the URI for the Faye server and the id of the game that we are.

  defaults: function() {
    return {
      id: null,
      state: "scheduled",
      clock: null,
      fayeURI: null,
      home_team: { score: 0 },
      visiting_team: { score: 0 }
    };
  },

  models: function() {
    return {
      clock: App.Timer,
      penalties: App.penalties,
      goals: App.goals,
      players: App.players,
      activity_feed_items: App.feedItems
    };
  },

  initialize: function() {
    this.faye = new Faye.Client(this.get("faye_uri"));
    this.faye.subscribe("/games/" + this.get("id"), function(message) {
      this.set(message);
    }.bind(this));
  },

  url: function() {
    return "/marker/games/" + this.id;
  },

  perform: function(action, data) {
    $.ajax({
      type: "POST",
      url: this.url() + "/" + action + ".json",
      data: data
    });
  },

  activate: function() {
    this.perform("activate");
  },

  start: function() {
    var state = this.get("state");
    if (state == "active" || state == "paused") {
      this.set("state", "playing");
    }
    this.perform("start");
    this.lastPausedAt = null;
    this.pausedAtDate = null;
  },

  pause: function() {
    if (this.get("state") == "playing") {
      this.set("state", "paused");
      // These two assignmets suffer from te same bug: they
      // only record local action. So if someone else pauses us,
      // this value won't get set.
      this.lastPausedAt = this.get("clock").get("elapsed_time");
      this.pausedAtDate = new Date();
      this.perform("pause", { elapsed_time: this.lastPausedAt } );
    }
  },

  stop: function() {
    this.perform("finish");
  },

  homeOrVisiting: function(teamId) {
    return this.get("home_team").id == teamId ?
      "home" : this.get("visiting_team").id == teamId ?
      "visiting" : null;
  }
});
