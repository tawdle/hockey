App.GameSummaryView = Backbone.View.extend({
  initialize: function(options) {
    this.score = this.$(".score");
    this.period = this.$(".period");

    this.listenTo(this.model, "change", this.render);
    this.render();
  },

  render: function() {
    var state = this.model.get("state");

    if (state == "scheduled") {
      this.score.html("VS");
      this.period.html("");
    } else {
      this.score.html("" + this.model.get("visiting_team").score + " - " + this.model.get("home_team").score);
      this.period.html(state == "completed" ? "Final" : App.translations.activerecord.attributes.game.period + " " + this.model.get("period_text"));
    }
  }
});

