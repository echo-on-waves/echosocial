require File.dirname(__FILE__) + '/../test_helper'

class TrackingTest < Test::Unit::TestCase

  fixtures :users, :groups, :memberships, :relationships, :pages

  def setup
  end

  def test_group_view_tracked
    user = users(:blue)
    group = groups(:rainbow)
    assert membership = user.memberships.find_by_group_id(group.id)
    Tracking.insert_delayed(:current_user => user, :group => group)
    Tracking.process
    visits = membership.reload.total_visits
    Tracking.insert_delayed(:current_user => user.id, :group => group.id)
    Tracking.process
    assert_equal visits+1, membership.reload.total_visits, 'total_visits should increment'
  end

  def test_user_visit_tracked
    current_user = users(:blue)
    user = users(:orange)

    assert_difference 'Tracking.count', 3 do
      3.times { Tracking.insert_delayed(:current_user => current_user, :user => user) }
    end
    assert_difference 'Tracking.count', -3 do
      Tracking.process
    end
    assert_equal 3, current_user.relationships.with(user).total_visits
  end

  def test_page_view_tracked_fully
    user = users(:blue)
    page = pages(:wiki) #id = 210
    group = groups(:rainbow)
    action = :view
    # let's clean things up first so they do not get in the way...
    Tracking.process
    Daily.update
    Hourly.find(:all).each{|h| h.destroy}
    assert_difference 'Hourly.count' do
      # 1, "hourly should be created for the tracked view" do
      assert_tracking(user, group, page, action)
      Tracking.process
    end
    assert_difference 'Daily.count' do
    #, 1, "daily should be created from the existing hourlies" do
      Daily.update
    end
  end

  # Testing the user seen functionality. We are tracking users this way in order
  # to avoid the database access for every action.

  def test_seeing_users
    Tracking.saw_user(4)
    Tracking.update_last_seen_users
    assert_not_nil old_timestamp=User.find(4).last_seen_at, "blue should have last_seen updated."
    sleep(1)
    Tracking.saw_user(4)
    Tracking.update_last_seen_users
    assert ( old_timestamp<User.find(4).last_seen_at), "blue should have last_seen updated."
  end

  def test_most_active_groups
    user = users(:blue)
    group1 = groups(:rainbow)
    group2 = groups(:animals)
    group3 = groups(:true_levellers)
    3.times { Tracking.insert_delayed(:current_user => user, :group => group1) }
    2.times { Tracking.insert_delayed(:current_user => user, :group => group2) }
    1.times { Tracking.insert_delayed(:current_user => user, :group => group3) }
    Tracking.process
    assert_equal [group1, group2, group3], user.primary_groups.most_active[0..2]
  end

  private

  # This can theoretically fail because of te insert_delayed not having inserted
  # anything yet - how ever this would only happen if the database table was locked
  # at that very moment. This would be rare for the testing db. I haven't seen it
  # happening as of now.
  def assert_tracking(user, group, page, action)
    Tracking.insert_delayed(:current_user => user, :group => group, :page => page, :action => action)
    track=Tracking.last
    assert_equal track.current_user_id, user.id, "User not stored correctly in Tracking"
    assert_equal track.group_id, group.id, "Group not stored correctly in Tracking"
    assert_equal track.page_id, page.id, "Page not stored correctly in Tracking"
    if action != :unstar
      assert_equal "#{action.to_s}s", ["views", "edits", "stars"].find{|a| Tracking.last.send a},
        'Tracking did not count the right action.'
      assert_equal 1, ["views", "edits", "stars"].select{|a| Tracking.last.send a}.count,
        'There shall be exactly one action counted.'
    else
      # TODO: check this before ActiveRecord gets in the way.
      assert_equal 0, ["views", "edits", "stars"].select{|a| Tracking.last.send a}.count,
        'For :unstar all values should evaluate to false.'
    end
  end

end
