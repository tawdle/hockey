window.App = window.App || {};

App.PenaltyEditor = Backbone.View.extend({
  initialize: function() {
    this.infractionSelect = this.$(".penalty-infraction select");
    this.template = _.template($("#player-radio").html());
    this.title = this.$("h3 span.title");
    this.saveButton = this.$("a.save");
    App.dispatcher.on("penalty:edit", this.edit, this);
  },

  tagName: "div",

  events: {
    "change .penalty-team input" : "showTeamPlayers",
    "change .penalty-category input" : "setInfractionOptions",
    "click a.save" : "saveAndClose",
    "click a.cancel" : "cancel"
  },

  getSetValue: function(cls, id) {
    return id === undefined ?
      this.$(cls + " input:checked").val() :
      this.$(cls + " input[value='" + id + "']").prop("checked", true);
  },

  teamId: function(id) {
    return this.getSetValue(".penalty-team", id);
  },

  playerId: function(id) {
    return this.getSetValue(".penalty-player", id);
  },

  category: function(cat) {
    return this.getSetValue(".penalty-category", cat);
  },

  optionPrompt: function(prompt) {
    return '<option selected disabled value="">' + prompt + '</option>';
  },

  optionString: function(value, text) {
    return '<option value="' + value + '">' + text + '</option>';
  },

  setInfractionOptions: function() {
    var category = this.category();
    var infractions = App.infractions[category];
    this.oldInfraction = this.infractionSelect.val() || this.oldInfraction;
    var self = this;
    var options = _.map(infractions, function(s) { return self.optionString(s, self.humanize(s)); }).join("");
    this.infractionSelect.html(self.optionPrompt("Infraction") + options);
    if (infractions.indexOf(this.oldInfraction) >= 0) this.infractionSelect.val(this.oldInfraction);
  },

  radiosFor: function(teamId) {
    var self = this;
    var radios = App.players.where({team_id: teamId}).map(function(player) {
      return self.template(player.toJSON());
    });
    return radios.join("");
  },

  createPlayerRadios: function() {
    var homeTeamId = App.game.get("home_team").id;
    var visitingTeamId = App.game.get("visiting_team").id;

    this.$("#penalty-players-team-" + homeTeamId).html(this.radiosFor(homeTeamId));
    this.$("#penalty-players-team-" + visitingTeamId).html(this.radiosFor(visitingTeamId));
  },

  showTeamPlayers: function(e) {
    this.$("#penalty-players-team-" + this.teamId()).toggle(true).siblings().toggle(false);
  },

  humanize: function(property) {
    return property.replace(/_/g, ' ').replace(/(\w+)/g, function(match) {
        return match.charAt(0).toUpperCase() + match.slice(1);
    });
  },

  initializeForm: function() {
    var player_id = this.model.get("player_id");
    var team_id = (player_id && App.players.get(player_id).get("team_id")) || App.game.get("home_team").id;

    this.createPlayerRadios();
    this.teamId(team_id);
    this.showTeamPlayers();
    this.playerId(player_id);
    this.category(this.model.get("category") || "minor");

    this.setInfractionOptions();
    this.infractionSelect.val(this.model.get("infraction"));

    this.title.text(this.model.isNew() ? "Create Penalty" : "Edit Penalty");
    this.saveButton.text(this.model.isNew() ? "Create" : "Update");
  },

  saveAndClose: function(e) {
    e.preventDefault();
    var self = this;
    var values = {
      player_id: this.playerId(),
      category: this.category(),
      infraction: this.infractionSelect.val()
    };

    this.model.save(values, { 
      success: function() {
        self.close();
      }
    });
  },

  cancel: function(e) {
    e.preventDefault();
    this.close();
  },

  close: function() {
    this.$el.modal('hide');
  },

  edit: function(penalty) {
    this.model = penalty;
    this.initializeForm();
    this.$el.modal();
    return this;
  }
});

