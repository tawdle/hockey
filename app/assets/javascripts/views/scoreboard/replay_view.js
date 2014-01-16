App.Scoreboard.ReplayView = Backbone.View.extend({
  name: "ReplayView",

  initialize: function(options) {
    this.video = this.$("video");
    this.listenTo(this, "showing", this.start);
    this.listenTo(this, "hidden", this.stop);
    this.playing = false;
    this.video[0].addEventListener("ended", this.playNextVideo.bind(this));  // BUG: https://code.google.com/p/chromium/issues/detail?id=157543
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
      error: function(xhr, status, error) {
        console.log("arenad call returned error: " + error);
      },
      success: function(data) {
        self.playlist = data.playlist;
        self.board.enqueue(self);
      }
    });
  },

  start: function() {
    this.playing = true;
    this.currentVideo = -1;
    this.playNextVideo();
  },

  stop: function() {
    this.playing = false;
    this.video[0].pause();
  },

  playNextVideo: function() {
    var video = this.video;
    this.currentVideo += 1;
    if (this.currentVideo >= this.playlist.length) {
      this.trigger("finished", this);
    } else if (this.playing) {
      video.attr("src", this.playlist[this.currentVideo].file);
      video.one("canplay", function() {
        video[0].currentTime = 0;
        video[0].play();
      });
    }
  }
});


