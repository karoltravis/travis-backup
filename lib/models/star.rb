# frozen_string_literal: true

require 'model'

class Star < Model
  belongs_to :repository
  belongs_to :user
end
