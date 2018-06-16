class Search < ApplicationRecord
  CATEGORIES = %w(Questions Answers Comments Users)

  def self.find(query, category)
    query = ThinkingSphinx::Query.escape(query) if query.present?
    
    if CATEGORIES.include?(category)
      category.classify.constantize.search(query)
    else
      ThinkingSphinx.search(query)
    end
  end
end
