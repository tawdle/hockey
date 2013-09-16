App.TeamBoxView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = Number(this.$el.attr("data-team-id"));
    this.editor = new App.PenaltyEditor({teamId: this.teamId, el: this.$(".penalty-editor")});
    this.penaltiesView = new App.PenaltiesView({teamId: this.teamId, el: this.$(".penalties")});
  },

  events: {
    "click a.add-penalty" : "addPenalty"
  },

  addPenalty: function(e) {
    e.preventDefault();
    var penalty = new App.Penalty({}, {collection: App.penalties});
    this.editor.edit(penalty);
  },

  render: function() {
    this.$(".penalty-editor").toggle(false);
  }

});

