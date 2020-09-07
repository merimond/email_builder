require 'minitest/autorun'
require 'email_builder'

describe EmailBuilder do

  ALL_ATTS = {
    first:  "Michael",
    middle: "Joseph",
    last:   "Jackson",
  }

  it "parses `first` format" do
    format = EmailBuilder.parse("michael@example.org", ALL_ATTS)
    assert_equal "first", format
  end

  it "parses `last` format" do
    format = EmailBuilder.parse("jackson@example.org", ALL_ATTS)
    assert_equal "last", format
  end

  it "parses `fl` format" do
    format = EmailBuilder.parse("mj@example.org", ALL_ATTS)
    assert_equal "fl", format
  end

  it "parses `flast` format" do
    format = EmailBuilder.parse("mjackson@example.org", ALL_ATTS)
    assert_equal "flast", format
  end

  it "parses `fmlast` format" do
    format = EmailBuilder.parse("mjjackson@example.org", ALL_ATTS)
    assert_equal "fmlast", format
  end

  it "parses `first.last` format" do
    format = EmailBuilder.parse("michael.jackson@example.org", ALL_ATTS)
    assert_equal "first.last", format
  end

  it "parses `f.last` format" do
    format = EmailBuilder.parse("m.jackson@example.org", ALL_ATTS)
    assert_equal "f.last", format
  end

  it "parses `first.m.last` format" do
    format = EmailBuilder.parse("michael.j.jackson@example.org", ALL_ATTS)
    assert_equal "first.m.last", format
  end

  it "parses `first_last` format" do
    format = EmailBuilder.parse("michael_jackson@example.org", ALL_ATTS)
    assert_equal "first_last", format
  end

  it "parses `first_m_last` format" do
    format = EmailBuilder.parse("michael_j_jackson@example.org", ALL_ATTS)
    assert_equal "first_m_last", format
  end

  it "parses `fml` format" do
    format = EmailBuilder.parse("mjj@example.org", ALL_ATTS)
    assert_equal "fml", format
  end

  it "parses `lastf` format" do
    format = EmailBuilder.parse("jacksonm@example.org", ALL_ATTS)
    assert_equal "lastf", format
  end

  it "parses `first.l` format" do
    format = EmailBuilder.parse("michael.j@example.org", ALL_ATTS)
    assert_equal "first.l", format
  end

end
