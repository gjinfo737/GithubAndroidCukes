require 'time'

RSpec::Matchers.define :be_in_the_right_date_format_for_narrative do
  match do |header_text|
    header_text.match("February 5, 2013 11:34 AM.+") and
    header_text.match("^\\w+ \\d{1,2}, \\d{4} \\d{1,2}:\\d{2} [AP]M")
  end

  failure_message_for_should do |header_text|
  end
end

RSpec::Matchers.define :have_been_created_by_for_narrative do |author|
  match do |header_text|
    header_text.include? "Created by:#{author}"
  end
end


RSpec::Matchers.define :have_been_created_within_for_narrative do |this_many_seconds|
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

