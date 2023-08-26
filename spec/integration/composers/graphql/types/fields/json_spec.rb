# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Types::Fields::Json do
  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      create_class "Users::UserModel", PlatformModel do
        json_field :my_json
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Types::CreateTypes.rerun
      Platformer::Composers::GraphQL::Types::Fields::Json.rerun

      expect(Types::Users::User.fields["myJson"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myJson"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myJson"].type.of_type).to eq GraphQL::Types::String
    end
  end
end
