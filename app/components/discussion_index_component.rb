class DiscussionIndexComponent < ApplicationComponent

  with_collection_parameter :discussion

  def initialize(discussion:, user:)
    @discussion = discussion
    @user = user
  end

  def call
    build_html do
      div id: dom_id(@discussion), class: "row mb-4" do
        div class: "col-8" do
          h2 do
            link_to(@discussion.name, discussion, class: "text-decoration-none text-body")
          end
          span(class: "badge rounded-pill text-bg-primary") { posts_count }
          text " post".pluralize(posts_count)
          text " | "
          span do
            create_date
          end
        end
        div class: "col-4" do
          if discussion.pinned?
            i(class: "bi bi-pin-fill") {}
            text "Pinned"
          end
          if discussion.closed?
            i(class: "bi bi-door-closed-fill") {}
            text "Closed"
          end
          if user_can_manage?
            div do
              [
                link_to("Edit", edit_discussion_path(discussion)),
                " | ",
                link_to("Delete", discussion, method: :delete, data: { turbo_method: :delete, confirm: "Are you sure?" })
              ].join
            end
          end
        end
      end
    end
  end

  def user_can_manage?
    @discussion.user = @user || @user.admin?
  end

  def create_date
    @discussion.created_at.to_date.to_formatted_s(:long_ordinal)
  end

  def discussion_category
    @discussion.category&.name || "No category"
  end

  def posts_count
    @discussion.posts_count
  end
end