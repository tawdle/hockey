App.Marker.GoalEditor = Backbone.View.extend({
  initialize: function() {
    this.teamId = this.options.teamId;
    this.advantageSelect = this.$(".goal-advantage select");
    this.saveButton = this.$("a.save");
    this.listenTo(App.dispatcher, "goal:edit", this.editIf);
    this.createPlayerSelectors();
  },

  tagName: "div",

  events: {
    "change input" : "updateSaveButton",
    "click a.save:not(.disabled)" : "saveAndClose",
    "click a.cancel" : "destroyAndClose"
  },

  createPlayerSelectors: function() {
    var self = this;
    this.selectors = _.map(["player", "assist", "secondary-assist"], function(role) {
      return new App.Marker.GoalPlayerSelector({ role: role, el: self.$(".goal-" + role), teamId: self.teamId, parent: self });
    });
  },

  initializePlayerSelectors: function(ids) {
    _.each(this.selectors, function(selector, index) {
      selector.initializeForm(ids[index], index === 0);
    });
  },

  complete: function() {
    var ids = _.map(this.selectors, function(s) { return s.playerId(); });
    var bits = _.map(ids, function(id) { return id !== undefined ? 1 : 0; } );
    var sum = bits[0] * 1 + bits[1] * 2 + bits[2] * 4;
    if (sum == 1 || sum == 3 || sum == 7) {
      var set = _.filter(ids, function(id) { return id !== undefined; } );
      var uniq = _.uniq(set);
      return (set.length == uniq.length);
    }
    return false;
  },

  updateSaveButton: function() {
    this.saveButton.toggleClass("disabled", !this.complete());
  },

  initializeForm: function() {
    var ids = this.model.get("player_ids");
    this.initializePlayerSelectors(ids);
    this.advantageSelect.val(this.model.get("advantage") || 0);
    this.updateSaveButton();
  },

  close: function() {
    this.$el.modal('hide');
    return this;
  },

  saveAndClose: function(event) {
    event.preventDefault();
    var self = this;
    var player_ids = _.uniq(_.compact(_.map(self.selectors,
      function(selector) { return Number(selector.playerId()); } )));
    var advantage = this.advantageSelect.val();
    this.model.save({player_ids: player_ids, advantage: advantage},
                    { success: function(model, response, options) { self.close(); }});
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

