class CategoryComponent < ApplicationComponent

  def initialize(category:)
    @category = category
  end

  # <div id="<%= dom_id(category) %>" class="d-flex align-items-start justify-content-between">
  #   <h4><%= link_to category.name, category_discussions_path(category) %></h4>
  #   <span class="badge bg-secondary rounded-pill text-light"><%= category.discussions_count %></span>
  # </div>
  def call
    build_html do
      div id: dom_id(@category), class: "d-flex align-items-start justify-content-between" do
        h4 do
          link_to @category.name, category_discussions_path(@category), class: "text-decoration-none text-body"
        end
        span class: "badge bg-secondary rounded-pill text-light" do
          @category.discussions_count
        end
      end
    end
  end
end