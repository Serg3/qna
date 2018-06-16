ThinkingSphinx::Index.define :answer, with: :active_record do
  #fileds
  indexes body
  indexes user.email, sortable: true

  # attributes
  has user_id, created_at, updated_at
end
