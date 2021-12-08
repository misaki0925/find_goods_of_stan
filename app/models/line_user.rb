class LineUser < ApplicationRecord
  enum yugo:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum taiga:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum juri:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum hokuto:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum jess:{ necessary: 0, unnecessary: 1 }, _prefix: true
  enum shintarou:{ necessary: 0, unnecessary: 1 }, _prefix: true

  def on
    @user = UserLine.find_by(user_id: user_id)
    if @user.yugo_unnecessary?
      @user.yugo_necessary!
    end
  end

  def off 
    @user = UserLine.find_by(user_id: user_id)
    if @user.yugo_necessary?
      @user.yugo_necessary!
    end
  end
end
