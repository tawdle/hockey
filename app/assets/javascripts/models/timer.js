window.App = window.App || {};

App.Timer = Backbone.Model.extend({
  defaults: {
    state: "created"
  },

  initialize: function() {
    this.pausedAt = null;
    this.secondsPaused = 0.0;
    this.on("change:state", this.stateChanged, this);
    this.trigger("change:state");
  },

  get: function(key) {
    return  key == "elapsedTime" ?
      this.getElapsedTime() :
      Backbone.Model.prototype.get.apply(this, arguments);
  },

  set: function(key, val, options) {
    var attrs;

    if (key === null) return this;
    if (typeof key === 'object') {
      attrs = key;
      options = val;
    } else {
      (attrs = {})[key] = val;
    }

    options = options || {};

    if (attrs.elapsedTime !== undefined) {
      this.setElapsedTime(attrs.elapsedTime);
      delete attrs.elapsedTime;
    }

    return Backbone.Model.prototype.set.apply(this, arguments);
  },

  setElapsedTime: function(val) {
    var et = Number(val) * 1000.0;
    this.baseTime = (this.pausedAt ? this.pausedAt : Date.now()) - (this.secondsPaused || 0.0) - et;
  },

  getElapsedTime: function() {
    var et = 0.0;

    switch (this.get("state")) {
      case "created":
        break;
      case "finished":
        break;
      case "running":
      case "finished":
        et = (Date.now() - this.secondsPaused - this.baseTime) / 1000.0;
        break;
      case "paused":
        et = (this.pausedAt - this.secondsPaused - this.baseTime) / 1000.0;
        break;
    }
    return et;
  },

  stateChanged: function() {
    switch(this.get("state")) {
      case "created":
        break;
      case "running":
        if (this.pausedAt) {
          this.secondsPaused += (Date.now() - this.pausedAt);
          this.pausedAt = null;
        } else {
          this.baseTime = this.baseTime || Date.now();
        }
        break;
      case "paused":
        this.pausedAt = this.pausedAt || Date.now();
        break;
      case "finished":
        break;
    }
  },

  elapsedTimeHMS: function() {
    var seconds = this.getElapsedTime();
    return {
      "hours" : Math.floor(seconds / 3600),
      "minutes": Math.floor(seconds / 60) % 60,
      "seconds": Math.floor(seconds % 60)
    };
  }
});
