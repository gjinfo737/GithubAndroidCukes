require 'time'

RSpec::Matchers.define :be_in_the_uneditable_note_state do
  match do |note|
    note.note_body.should_not be_focusable
    note.delete_view.should_not be_enabled
    note.save_view.should_not be_enabled
    note.email_view.should be_enabled
    note.print_view.should be_enabled
    note.add_view.should be_enabled
    true
  end
end

RSpec::Matchers.define :be_in_the_created_state do
  match do |note|
    @expected = {
      :note_focused => true,
      :print_enabled => false,
      :email_enabled => false,
      :delete_enabled => false,
      :save_enabled => false,
      :add_enabled => false
    }

    @actual = {
     :note_focused => note.note_body.focused?,
      :print_enabled => note.print_view.enabled?,
      :email_enabled => note.email_view.enabled?,
      :delete_enabled => note.delete_view.enabled?,
      :save_enabled => note.save_view.enabled?,
      :add_enabled => note.add_view.enabled?
    }

    @expected == @actual
  end

  failure_message_for_should do |note|
    "Expected to be in the created note state \n\t#{@expected})\n but was not \n\t#{@actual}"
  end

  failure_message_for_should_not do |note|
    "Expected to not be in the created note state \n\t#{@expected})\n but was \n\t#{@actual}"
  end
end

RSpec::Matchers.define :be_in_the_saved_note_state do
  match do |note|
    @expected = {
      :save_enabled => false,
      :delete_enabled => true,
      :email_enabled => true,
      :print_enabled => true,
      :add_enabled => true
    }

    @actual = {
      :save_enabled => note.save_view.enabled?,
      :delete_enabled => note.delete_view.enabled?,
      :email_enabled => note.email_view.enabled?,
      :print_enabled => note.print_view.enabled?,
      :add_enabled => note.add_view.enabled?
    }

    @expected == @actual
  end

  failure_message_for_should do |note|
    "Expected the note to be in the saved state (#{@expected}) but it was not (#{@actual})"
  end

  failure_message_for_should_not do |note|
    "Expected the note to NOT be in the saved state (#{@expected}) but it was (#{@actual})"
  end

end

RSpec::Matchers.define :be_in_the_right_date_format do
  match do |header_text|
    header_text.match("February 5, 2013 11:33 AM.+") and
    header_text.match("^\\w+ \\d{1,2}, \\d{4} \\d{1,2}:\\d{2} [AP]M")
  end

  failure_message_for_should do |header_text|
  end
end

RSpec::Matchers.define :have_been_created_by do |author|
  match do |header_text|
    header_text.include? "Created by:#{author}"
  end
end

RSpec::Matchers.define :be_in_the_unsaved_note_state do
  match do |note|
    note.print_view.should be_enabled
    note.email_view.should be_enabled
    note.save_view.should be_enabled

    note.delete_view.should_not be_enabled
    note.add_view.should be_enabled
    true
  end

  failure_message_for_should do |note|
    "Expected to be in the unsaved note state but was not"
  end

  failure_message_for_should_not do |note|
    "Expected to not be in the unsaved note state but was"
  end
end

RSpec::Matchers.define :have_been_created_within do |this_many_seconds|
  match do |header|
    @this_many_seconds = this_many_seconds
    @header_time = Time.parse(header.match(/^\w+ \d{1,2}, \d{4} \d{1,2}:\d{2} [AP]M/)[0])
    @now = Time.now
    (@now - @header_time).abs < @this_many_seconds
  end

  def message(should_or_should_not)
    "Expected #{@header_time} to #{should_or_should_not} within #{@this_many_seconds} seconds of #{@now}"
  end

  failure_message_for_should do |header|
    message("be")
  end

  failure_message_for_should_not do |header|
    message("not be")
  end
end

