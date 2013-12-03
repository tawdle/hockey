window.App = window.App || {};

App.Timer = Backbone.Model.extend({
  defaults: {
    state: "created",
    duration: 0.0
  },

  initialize: function() {
    this.pausedAt = null;
    this.secondsPaused = 0.0;
    this.on("change:state", this.stateChanged, this);
    this.trigger("change:state");
    this.synced = false;
  },

  get: function(key) {
    return  key == "elapsed_time" ?
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

    if (attrs.elapsed_time !== undefined) {
      this.setElapsedTime(attrs.elapsed_time);
      delete attrs.elapsed_time;
    }

    return Backbone.Model.prototype.set.apply(this, arguments);
  },

  setElapsedTime: function(val) {
    var et = Number(val) * 1000.0;
    this.baseTime = (this.pausedAt ? this.pausedAt : Date.now()) - (this.secondsPaused || 0.0) - et;
  },

  getElapsedTime: function() {
    var et = 0.0;
    var duration = this.get("duration");

    switch (this.get("state")) {
      case "created":
        break;
      case "running":
        et = (Date.now() - this.secondsPaused - this.baseTime) / 1000.0;
        if (!this.synced && duration && et >= duration) {
          this.sync();
        }
        break;
      case "paused":
        et = (this.pausedAt - this.secondsPaused - this.baseTime) / 1000.0;
        break;
      case "expired":
        et = duration;
        break;
    }
    return duration ? Math.min(et, this.get("duration")) : et;
  },

  getTimeRemaining: function() {
    return Math.max(0, this.get("duration") - this.getElapsedTime());
  },

  stateChanged: function() {
    this.synced = false;
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
      case "expired":
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
  },

  sync: function() {
    $.ajax({
      type: "POST",
      url: App.game.url() + "/sync.json"
    });
    this.synced = true;
  }
});
