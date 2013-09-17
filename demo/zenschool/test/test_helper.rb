ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def assert_show_model_view_filed(index, label, value)
    assert_select "tr:nth-child(#{index}) td", 2 do
      assert_select 'td:nth-child(1)', label
      assert_select 'td:nth-child(2)', value.to_s
    end
  end

  def assert_show_model_form_input(index, input_id, label, value = nil)
    assert_select "div.control-group" do |group_list|
      group = group_list[index-1]
      assert group
      assert_select group, 'label.control-label', label
      assert_select group, "div.controls input#{input_id}"
      if value
        assert_select group, "div.controls input#{input_id}[value=?]", value
      end
    end
  end

end
