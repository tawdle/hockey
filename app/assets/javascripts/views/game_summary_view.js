App.GameSummaryView = Backbone.View.extend({
  initialize: function(options) {
    this.score = this.$(".score");
    this.period = this.$(".period");

    this.listenTo(this.model, "change", this.render);

    this.feedItemsView = new Backbone.CollectionView({
      el: "#feed-items",
      collection: App.feedItems,
      modelView: App.FeedItemView,
      emptyListCaption: "There are no activity feed items yet for this game."
    });
    this.feedItemsView.render();

    this.render();
  },

  events: {
    "ajax:success #new_feed_user_post" : "clearMessageText"
  },

  clearMessageText: function() {
    this.$("#feed_user_post_message").val("");
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

