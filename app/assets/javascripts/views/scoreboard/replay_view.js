App.Scoreboard.ReplayView = Backbone.View.extend({
  name: "ReplayView",

  initialize: function(options) {
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.playing = false;
    this.listenTo(App.goals, "add", this.goalAdded);
  },

  goalAdded: function(goal) {
    var self = this;

    $.ajax({
      type: "POST",
      url: "http://localhost:4000" + "/games/" + App.game.id + "/goals",
      data: {
        goal: $.extend({}, goal.attributes, { side: App.game.homeOrVisiting(goal.attributes.team_id) })
      },
      statusCode: {
        503: function() {
          console.log("arendad says we're too early; rescheduling");
          setTimeout(function() {
            self.goalAdded(goal);
          }, 1000);
        },
        403: function() {
          console.log("we're not allowed to produce videos; waiting for someone else");
          setTimeout(function() {
            self.goalAdded(goal);
          }, 2000);
        }
      },
      error: function(xhr, status, error) {
        console.log("arenad call returned error: " + status + " " + error);
      },
      success: function(data) {
        self.processPlaylist(data.playlist);
        self.board.enqueue(self);
      }
    });
  },

  processPlaylist: function(playlist) {
    var self = this;
    this.playlist = playlist;
    this.$el.empty();
    playlist.forEach(function(shot) {
      var video = $("<video src='" + shot.file + "'>");
      if (shot.speed) video.attr("playbackRate", shot.speed);
      video.load();
      // BUG: https://code.google.com/p/chromium/issues/detail?id=157543
      video[0].addEventListener("ended", self.playNextVideo.bind(self));
      self.$el.append(video);
    });
  },

  start: function() {
    this.playing = true;
    this.currentVideo = -1;
    this.playNextVideo();
  },

  stop: function() {
    if (this.playing) {
      this.playing = false;
      var video = this.$("video")[this.currentVideo];
      if (video && video.pause) video.pause();
    }
  },

  playNextVideo: function() {
    this.currentVideo += 1;
    if (this.currentVideo >= this.playlist.length) {
      this.trigger("finished", this);
    } else if (this.playing) {
      var video = this.$("video")[this.currentVideo];
      video.currentTime = 0;
      video.play();
      $(video).show().siblings().hide();
    }
  }
});


