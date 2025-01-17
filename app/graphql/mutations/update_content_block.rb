module Mutations
  class UpdateContentBlock < GraphQL::Schema::Mutation
    argument :id, ID, required: true
    argument :block_type, String, required: true
    argument :text, String, required: true

    description "Updates a target content block."

    field :success, Boolean, null: false
    field :id, ID, null: false
    field :versions, [Types::DateType], null: false

    def resolve(params)
      mutator = UpdateContentBlockMutator.new(context, params)

      if mutator.valid?
        mutator.notify(:success, "Done!", "Content updated successfully.")
        content_block = mutator.update_content_block
        { success: true, id: content_block.id, versions: mutator.target_versions }
      else
        mutator.notify_errors
        { success: false, errors: mutator.error_messages }
      end
    end
  end
end
