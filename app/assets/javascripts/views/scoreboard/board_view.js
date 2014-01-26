App.Scoreboard.BoardView = Backbone.View.extend({
  initialize: function(options) {
    this.queue = [];
    this.currentView = null;
    this.$el.children().hide();
    this.sound = null;

    this.listenTo(App.game, "change:state", this.gameStateChanged);

    var config = [
      [App.Scoreboard.GameView, "#game-board"],
      [App.Scoreboard.GoalAnimationView, "#team-goal-animation"],
      [App.Scoreboard.ReplayView, "#goal-replay"],
      [App.Scoreboard.PlayerGoalView, "#player-goal-animation"],
      [App.Scoreboard.PreGameShowView, "#pre-game-show"]
    ];

    var self = this;
    this.views = _.object(
      _.map(config, function(v) {
        var view = new v[0]( { el: v[1], board: self, model: self.model } );
        return [view.name, view];
      })
    );

    this.trigger("available");
  },

  show: function(view) {
    console.log("got request to show " + view.name);

    var current = this.currentView;

    if (current == view) return;

    if (current) current.trigger("hiding");
    view.trigger("showing");

    if (current) current.$el.hide();
    if (current) current.trigger("hidden");

    view.$el.show();
    view.trigger("shown");

    this.currentView = view;
    console.log("currentView is now " + this.currentView.name);
  },

  finished: function(view) {
    if (view == this.currentView) {
      this.showNext();
    }
  },

  showNext: function() {
    if (this.queue[0]) {
      this.show(this.queue.shift());
    } else {
      var view = this.currentView;
      this.trigger("available");
      if (view && view == this.currentView) { // nobody wants the screen
        view.trigger("hiding");
        view.$el.hide();
        view.trigger("hidden");
        this.currentView = null;
      }
    }
  },

  enqueue: function(view) {
    console.log("adding " + view.name + " to queue");
    this.queue.push(view);
    var self = this;
    setTimeout(function() {
      if (!self.currentView) {
        console.log("enqueue: nothing showing, so trying next");
        self.showNext();
      }
    }, 1);
  },

  reset: function() {
    this.queue = [];
    this.stopSound();
    this.showNext();
  },

  playSound: function(audio) {
    this.sound = audio;
    audio.volume = 0;
    audio.currentTime = 0;
    audio.play();
    $(audio).animate( { volume: 1 }, 100); // avoid glitch on restart
  },

  stopSound: function() {
    var sound = this.sound;
    if (sound) {
      $(sound).animate( { volume: 0 }, 1000, function() {
        sound.pause();
        sound.currentTime = 0;
      });
    }
  },

  fadeOutAndReload: function() {
    this.$el.animate( { opacity: 0 }, 10000, function() {
      document.location.reload();
    });
  },

  gameStateChanged: function(game, state) {
    if (state == "playing") {
      this.stopSound();
    } else if (state == "completed") {
      setTimeout(this.fadeOutAndReload.bind(this), 30000);
    }
  }
});

