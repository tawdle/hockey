window.App = window.App || {};

App.Game = Backbone.Model.extend({
  defaults: function() {
    return { state: "scheduled", elapsed_time: 0 }
  },

  timer: null,
  lastTick: null,

  initialize: function() {
    this.on("change:state", this.stateChanged, this);
  },

  stateChanged: function() {
    switch(this.get("state")) {
      case "active":
        this.timer = setInterval(this.tick.bind(this), 500);
        this.lastTick = Date.now();
      break;
      case "paused":
        clearInterval(this.timer);
      break;
      case "finished":
        clearInterval(this.timer);
    }
  },

  start: function() {
    this.set("state", "active");
  },

  pause: function() {
    this.set("state", "paused");
  },

  finish: function() {
    this.set("state", "finished");
  },

  tick: function() {
    var now = Date.now();
    this.set("elapsed_time", this.get("elapsed_time") + (now - this.lastTick) / 1000.0);
    this.lastTick = now;
  }
});
