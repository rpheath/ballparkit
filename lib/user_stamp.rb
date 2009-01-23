# simplified version of http://github.com/jnunemaker/user_stamp

module UserStamp
  module ClassMethods
    def user_stamp(*models)
      models.each { |klass| klass.add_observer(UserStampSweeper.instance) }

      class_eval do
        cache_sweeper :user_stamp_sweeper
      end
    end
  end
end

class UserStampSweeper < ActionController::Caching::Sweeper
  def before_save(record)
    return unless current_user
    
    # set the user_id to the currently logged in user
    if record.respond_to?(:user_id) && record.new_record?
      record.send(:user_id=, current_user.id)
    end
  end
end