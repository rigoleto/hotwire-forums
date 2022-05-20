class ApplicationComponent < ViewComponent::Base
  include ActionView::RecordIdentifier

  def build_html(&block)
    Markaby::Builder.new(
      {}, # assigns
      self
    ).capture(&block).to_s
  end
end