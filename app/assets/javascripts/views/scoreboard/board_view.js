App.Scoreboard.BoardView = Backbone.View.extend({
  initialize: function(options) {
    this.gameBoard = options.gameBoard;
    this.goalAnimation = options.goalAnimation;
    this.currentView = null;
    this.$el.children().hide();
    this.show(this.gameBoard);
    this.listenTo(App.goals, "add", this.goalAdded);
  },

  show: function(view, args) {
    var current = this.currentView;

    if (current == view) return;

    if (current) current.trigger("hiding");
    view.trigger("showing", args);

    if (current) current.$el.hide();
    if (current) current.trigger("hidden");

    view.$el.show();
    view.trigger("shown", args);

    this.currentView = view;
  },

  goalAdded: function(goal) {
    var self = this;
    this.show(this.goalAnimation, goal);
    goal.once("change:player_ids remove", function() {
      self.goalCompleted();
    });
  },

  goalCompleted: function() {
    this.show(this.gameBoard);
  }
});

