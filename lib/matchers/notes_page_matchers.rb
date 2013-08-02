RSpec::Matchers.define :be_on_the_notes_page do
  match do |notes|
    notes.should have_text 'Note Description'
    notes.should have_view 'create_item_button'
  end
end

