class User::UnlocksController < Devise::UnlocksController
  prepend_before_action :require_no_authentication
end
