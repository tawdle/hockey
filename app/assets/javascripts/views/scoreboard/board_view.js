App.Scoreboard.BoardView = Backbone.View.extend({
  initialize: function(options) {
    this.views = options.views;
    this.defaultView = options.defaultView || options.views[0];
    this.queue = [];
    this.currentView = null;
    this.$el.children().hide();

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
  }
});

