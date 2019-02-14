module ApplicationHelper
  def voted_by_current_user?(user_votes, track_id)
    return "hidden" if user_votes.include? track_id
    ""
  end

  def relocate_or_delete(relocate_won, delete_won)
    return "relocated" if relocate_won
    return "deleted" if deleted_won
  end
end
