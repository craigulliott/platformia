# frozen_string_literal: true

require "spec_helper"

RSpec.describe Platformer::Composers::GraphQL::Schema::Fields::Integer do
  describe "for a new UserModel which defines a simple new model with an integer field" do
    before(:each) do
      create_class "Users::UserModel", Platformer::BaseModel do
        integer_field :my_integer
      end
      create_class "Users::UserSchema", Platformer::BaseSchema do
        fields [
          :my_integer
        ]
      end
    end

    after(:each) do
      destroy_class Types::Users::User
    end

    it "creates the expected GraphQL Type class" do
      # now that the UserModel has been created, we rerun the composer
      Platformer::Composers::GraphQL::Schema::CreateTypes.rerun
      Platformer::Composers::GraphQL::Schema::Fields::Integer.rerun

      expect(Types::Users::User.fields["myInteger"]).to be_a GraphQL::Schema::Field

      expect(Types::Users::User.fields["myInteger"].type).to be_a GraphQL::Schema::NonNull
      expect(Types::Users::User.fields["myInteger"].type.of_type).to eq GraphQL::Types::Int
    end
  end
end
