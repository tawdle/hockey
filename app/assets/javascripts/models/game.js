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
    return "/games/" + this.id;
  },

  perform: function(action, data) {
    $.ajax({
      type: "POST",
      url: this.url() + "/" + action + ".json",
      data: data
    });
  },

  start: function() {
    this.perform("start");
  },

  pause: function() {
    if (this.get("state") == "playing") {
      this.perform("pause", { elapsed_time: this.get("clock").get("elapsed_time") } );
    }
  },

  stop: function() {
    this.perform("stop");
  }
});
