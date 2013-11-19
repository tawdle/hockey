App.Marker.GoalEditor = Backbone.View.extend({
  initialize: function() {
    this.teamId = this.options.teamId;
    this.playerSelect = this.$(".goal-player select");
    this.assistSelect = this.$(".goal-assist select");
    this.secondaryAssistSelect = this.$(".goal-secondary-assist select");
    this.listenTo(App.dispatcher, "goal:edit", this.editIf);
  },

  tagName: "div",

  events: {
    "change .goal-player select": "playerChanged",
    "change .goal-assist select": "assistChanged",
    "click a.save" : "saveAndClose",
    "click a.cancel" : "destroyAndClose"
  },

  playerChanged: function() {
    this.$(".goal-assist").slideDown();
  },

  assistChanged: function() {
    this.$(".goal-secondary-assist").slideDown();
  },

  optionPrompt: function(prompt) {
    return '<option selected disabled value="">' + prompt + '</option>';
  },

  optionString: function(value, text) {
    return '<option value="' + value + '">' + text + '</option>';
  },

  setPlayerOptions: function() {
    var self = this;
    var options = App.players.where({team_id: this.teamId}).map(function(player) { return self.optionString(player.id, player.get("name_and_number")); }).join("");
    this.playerSelect.html(self.optionPrompt("Player who scored goal") + options);
    this.assistSelect.html(self.optionPrompt("Player who assisted") + options);
    this.secondaryAssistSelect.html(self.optionPrompt("Other player who assisted") + options);
  },

  initializeForm: function() {
    var ids = this.model.get("player_ids");
    this.setPlayerOptions();
    this.playerSelect.val(ids[0]);
    this.assistSelect.val(ids[1]);
    this.secondaryAssistSelect.val(ids[2]);
    this.$(".goal-assist").toggle(ids.length > 0);
    this.$(".goal-secondary-assist").toggle(ids.length > 1);
  },

  close: function() {
    this.$el.modal('hide');
    return this;
  },

  saveAndClose: function(event) {
    event.preventDefault();
    var player_ids = _.uniq(_.compact(_.map(this.$("select"), function(select) { return Number($(select).val()); } )));
    var self = this;
    this.model.save({player_ids: player_ids}, { success: function(model, response, options) { self.close(); }});
    return false;
  },

  destroyAndClose: function(event) {
    event.preventDefault();
    if (!this.model.get("player_ids").length) {
      var self = this;
      this.model.destroy({success: function() { self.close(); }});
    } else {
      this.close();
    }
  },

  editIf: function(goal) {
    if (goal.get("team_id") == this.teamId) {
      this.edit(goal);
    }
  },

  edit: function(goal) {
    this.model = goal;
    this.initializeForm();
    this.$el.modal();
    return this;
  }
});

