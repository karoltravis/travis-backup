# frozen_string_literal: true

require 'factory_bot'
require 'models/user'

FactoryBot.define do
  factory :user do
    factory :user_with_repos do
      transient do
        repos_count { 3 }
      end
      after(:create) do |user, evaluator|
        create_list(
          :repository_with_builds_jobs_and_logs,
          evaluator.repos_count,
          owner_id: user.id,
          owner_type: 'User'
        )
      end
    end

    factory :user_with_all_dependencies do
      after(:create) do |user|
        create_list(:email, 3,
          user_id: user.id,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(:token, 3,
          user_id: user.id,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(:star, 3,
          user_id: user.id,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(:membership, 3,
          user_id: user.id,
        )
        create_list(:user_beta_feature, 3,
          user_id: user.id,
        )
        create_list(:permission, 3,
          user_id: user.id,
        )
        create_list(
          :repository_with_all_dependencies, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :build_with_all_dependencies, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :build_with_all_dependencies, 2,
          sender_id: user.id,
          sender_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :request_with_all_dependencies, 2,
          sender_id: user.id,
          sender_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :request_with_all_dependencies, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :job_with_all_dependencies, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :subscription_with_invoices, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :trial_with_allowances, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :trial_allowance, 2,
          creator_id: user.id,
          creator_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :owner_group, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :broadcast, 2,
          recipient_id: user.id,
          recipient_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
        create_list(
          :abuse, 2,
          owner_id: user.id,
          owner_type: 'User',
          created_at: user.created_at,
          updated_at: user.updated_at
        )
      end
    end
  end
end
