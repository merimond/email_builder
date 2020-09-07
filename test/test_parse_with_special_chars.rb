require 'minitest/autorun'
require 'email_builder'

describe EmailBuilder do

  it "parses names with apostrophes" do
    format = EmailBuilder.parse("ojackson@example.org", {
      first:  "Michael",
      middle: "Joseph",
      last:   "O'Jackson",  
    })
    assert_equal "last", format
  end

end
