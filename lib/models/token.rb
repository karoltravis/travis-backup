# frozen_string_literal: true

require 'model'

class Token < Model
  belongs_to :user
end
