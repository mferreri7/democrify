module ApplicationHelper
  def voted_by_current_user?(user_votes, track_id)
    return "hidden" if user_votes.include? track_id
    ""
  end
end
