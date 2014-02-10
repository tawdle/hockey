require 'spec_helper'

describe Stats::Team do
  let(:team) { FactoryGirl.create(:team) }
  let(:league) { FactoryGirl.create(:league) }
  let!(:games) { [
    FactoryGirl.create(:game, :active, :with_players, league: league, home_team: team),
    FactoryGirl.create(:game, :active, league: league, visiting_team: team),
    FactoryGirl.create(:game, :active, league: league)
  ] }

  subject { Stats::Team.new(team, Game) }

  describe "#games_played" do
    its(:games_played) { should == [games[0], games[1]] }
  end

  describe "#victories" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: team)
    end

    its(:num_victories) { should == 1 }
  end

  describe "#overtime_victories" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: team)
      FactoryGirl.create(:goal, game: games[1], team: team)
      games[0].update_attribute(:period, 3)
    end

    its(:num_overtime_victories)  { should == 1 }
  end

  describe "#shoutout_victories" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: team)
      FactoryGirl.create(:goal, game: games[1], team: team)
      games[0].update_attribute(:period, 4)
    end

    its(:num_shootout_victories) { should == 1 }
  end

  describe "#defeats" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
    end

    its(:num_defeats) { should == 1 }
  end

  describe "#overtime_defeats" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
      FactoryGirl.create(:goal, game: games[1], team: games[0].home_team)
      games[0].update_attribute(:period, 3)
    end

    its(:num_overtime_defeats) { should == 1 }
  end

  describe "#shootout_defeats" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
      FactoryGirl.create(:goal, game: games[1], team: games[0].home_team)
      games[0].update_attribute(:period, 4)
    end

    its(:num_shootout_defeats) { should == 1 }
  end

  describe "#goals_scored" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: team)
    end
    its(:num_goals_scored) { should == 1 }
  end

  describe "#goals_yielded" do
    before do
      FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
    end
    its(:num_goals_yielded) { should == 1 }
  end

  describe "#differential" do
    context "when positive" do
      before do
        FactoryGirl.create(:goal, game: games[0], team: team)
      end
      its(:differential) { should == 1 }
    end
    context "when negative" do
      before do
        FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
      end
      its(:differential) { should == -1 }
    end
  end

  describe "#percentage" do
    context "with 1 for and 1 against" do
      before do
        FactoryGirl.create(:goal, game: games[0], team: games[0].visiting_team)
        FactoryGirl.create(:goal, game: games[0], team: team)
      end
      its(:percentage) { should == 50 }
    end
    context "with no goals" do
      its(:percentage) { should be_NAN }
    end
  end

  describe "#performance_points" do
    context "with a victory" do
      before do
        FactoryGirl.create(:goal, game: games[0], team: team)
      end
      its(:performance_points) { should == 2 }
      context "with an overtime defeat" do
        before do
          FactoryGirl.create(:goal, game: games[1], team: games[1].opposing_team(team) )
          games[1].update_attribute(:period, 3)
        end
        its(:performance_points) { should == 3 }
      end
    end
  end

  describe "#franc_jeu_points" do
    context "with no penalties" do
      its(:franc_jeu_points) { should == 2 }
    end
    context "with a few penalties" do
      before do
        3.times do
          FactoryGirl.create(:penalty, game: games[0], team: team)
        end
      end
      its(:franc_jeu_points) { should == 2 }
    end
    context "with lots of penalties" do
      before do
        10.times do
          FactoryGirl.create(:penalty, game: games[0], team: team)
        end
      end
      its(:franc_jeu_points) { should == 1 }
    end
  end
end
