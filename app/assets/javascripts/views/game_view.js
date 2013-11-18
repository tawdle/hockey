window.App = window.App || {};

App.GameView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = this.$("#game-start");
    this.gamePause = this.$("#game-pause");
    this.gameStop = this.$("#game-stop");
    this.gameStatus = this.$("#game-status");
    this.period = this.$("#game-period");
    this.homeView = new App.TeamBoxView({ el: "#home-team", teamId: this.model.get("home_team").id, side: "home_team" });
    this.visitingView = new App.TeamBoxView({ el: "#visiting-team", teamId: this.model.get("visiting_team").id, side: "visiting_team" });
    this.penaltyEditor = new App.PenaltyEditor({el: this.$(".penalty-editor")});

    this.listenTo(this.model, "change", this.render);
    setInterval(function() { App.dispatcher.trigger("clockTick"); }.bind(this), 500);
    var el = $("#game-clock").first();
    this.gameClockView = new App.TimerView({el: el, model: App.game.get("clock"), showTimeRemaining: true});
    this.render();
  },

  events: {
    "click #game-start" : "start",
    "click #game-pause" : "pause",
    "click #game-stop" : "stop",
    "click a.add-penalty" : "addPenalty",
    "ajax:success #new_activity_feed_item" : "clearMessageText",
    "click .swap" : "swapTeamBoxes"
  },

  start: function(e) {
    e.preventDefault();
    this.model.start();
  },

  pause: function(e) {
    e.preventDefault();
    this.model.pause();
  },

  stop: function(e) {
    e.preventDefault();
    if (confirm("End this period now?")) {
      this.model.stop();
    }
  },

  addPenalty: function(e) {
    e.preventDefault();
    App.game.pause();
    var penalty = new App.Penalty({}, {collection: App.penalties});
    this.penaltyEditor.edit(penalty);
  },

  clearMessageText: function() {
    this.$("#activity_feed_item_message").val("");
  },

  swapElements: function(elements) {
    var parent1, next1,
    parent2, next2;

    parent1 = elements[0].parentNode;
    next1   = elements[0].nextSibling;
    parent2 = elements[1].parentNode;
    next2   = elements[1].nextSibling;

    parent1.insertBefore(elements[1], next1);
    parent2.insertBefore(elements[0], next2);
  },

  swapTeamBoxes: function(e) {
    e.preventDefault();
    this.swapElements(this.$(".team-box"));
  },

  render: function() {
    var state = this.model.get("state");
    this.gameStart.toggle(state == "active" || state == "paused");
    this.gamePause.toggle(state == "playing");
    this.gameStop.toggle(state== "playing" || state == "paused");
    $("p[class=" + state + "]", this.gameStatus).toggle(true).siblings().toggle(false);

    this.period.text(this.model.get("period_text"));
    this.gameStatus.removeClass("active playing paused finished").addClass(state);
  }
});
