App.ScoreboardView = Backbone.View.extend({
  initialize: function() {
    this.left = $("#left");
    this.center = $("#center");
    this.right = $("#right");

    this.home = new App.TeamPanelView({homeOrVisiting: "home", el: this.left});
    this.visiting = new App.TeamPanelView({homeOrVisiting: "visiting", el: this.right});
  }
});

