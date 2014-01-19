App.Scoreboard.BoardView = Backbone.View.extend({
  initialize: function(options) {
    this.views = _.object(_.map(options.views, function(view) { return [view.name, view]; }));
    this.defaultView = options.defaultView || options.views[0];
    this.queue = [];
    this.currentView = null;
    this.$el.children().hide();
    this.sound = null;

    this.listenTo(App.game, "change:state", this.gameStateChanged);

    var self = this;
    _.each(this.views, function(view) {
      self.listenTo(view, "finished", self.onFinished);
      view.board = self;
    });

    this.show(this.defaultView);
  },

  show: function(view) {
    var current = this.currentView;

    if (current == view) return;

    if (current) current.trigger("hiding");
    view.trigger("showing");

    if (current) current.$el.hide();
    if (current) current.trigger("hidden");

    view.$el.show();
    view.trigger("shown");

    this.currentView = view;
    if (this.currentView == this.defaultView)
      this.stopSound();
  },

  onFinished: function(view) {
    if (view == this.currentView) {
      this.showNext();
    }
  },

  showNext: function() {
    this.show(this.queue.shift() || this.defaultView);
  },

  enqueue: function(view) {
    this.queue.push(view);
  },

  reset: function() {
    this.queue = [];
    this.showNext();
  },

  playSound: function(audio) {
    this.sound = audio;
    this.sound.volume = 0;
    this.sound.currentTime = 0;
    this.sound.play();
    $(this.sound).animate( { volume: 1 }, 100); // avoid glitch on restart
  },

  stopSound: function() {
    var self = this;
    if (this.sound) {
      $(this.sound).animate( { volume: 0 }, 1000, function() {
        self.sound.pause();
        self.sound.currentTime = 0;
      });
    }
  },

  gameStateChanged: function(game, state) {
    if (state == "playing")
      this.stopSound();
  }
});

