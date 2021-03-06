class QuestionAnswer < ApplicationRecord
  default_scope { order(:created_at, :id ) }

  belongs_to :text_component

  validates :question, length: { maximum: 20, message: 'is too long for a chatfuel button (maximum is %{count} characters)' }
  validates :answer, length: { maximum: 640 }

  [:question, :answer].each do |attribute|
    define_method "rendered_#{attribute}" do |diary_entry|
      string = self.send(attribute)
      renderer = Text::Renderer.new(text_component: self.text_component, diary_entry: diary_entry) 
      renderer.render_string(string)
    end
  end
end
