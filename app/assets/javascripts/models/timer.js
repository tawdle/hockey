window.App = window.App || {};

App.Timer = Backbone.Model.extend({
  defaults: {
    state: "created", 
    elapsedTime: 0.0
  },

  timerId: null,
  lastTick: null,

  initialize: function() {
    this.on("change:state", this.stateChanged, this);
    this.trigger("change:state", this);
  },

  stateChanged: function() {
    switch(this.get("state")) {
      case "created":
        break;
      case "running":
        this.lastTick = Date.now();
        this.timerId = setInterval(this.tick.bind(this), 500);
        break;
      case "paused":
      case "finished":
        if (this.timerId) {
          clearInterval(this.timerId);
          this.timerId = null;
        }
        break;
    }
  },

  tick: function() {
    var now = Date.now();
    this.set("elapsedTime", Number(this.get("elapsedTime")) + (now - this.lastTick) / 1000.0);
    this.lastTick = now;
  },

  elapsedTimeHMS: function() {
    var seconds = this.get("elapsedTime");
    return {
      "hours" : Math.floor(seconds / 3600),
      "minutes": Math.floor(seconds / 60) % 60,
      "seconds": Math.floor(seconds % 60)
    }
  }
});
