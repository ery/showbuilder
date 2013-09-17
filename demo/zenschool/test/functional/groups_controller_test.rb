require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  test "index" do
    Group.create(number: "1001", name: "Tim",  grade: 1, department: 'Computer')
    Group.create(number: "1002", name: "Leon", grade: 2, department: 'English')
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
    assert_template :index
    groups = assigns(:groups)
    assert_equal 2, groups.count
    assert_select 'table tbody tr', 2  do |row_list|
      row_list.each_with_index do |row, index|
        group = groups[index]
        assert_select row, 'td', 5
        assert_select row, 'td:nth-child(1)', group.id.to_s
        assert_select row, 'td:nth-child(2)', group.number
        assert_select row, 'td:nth-child(3)', group.name
        assert_select row, 'td:nth-child(4)', group.grade.to_s
        assert_select row, 'td:nth-child(5)', group.department
      end
    end
  end

  test "new" do
    get :new
    assert_template :new
    assert_response :success
    assert_select 'form#new_group' do
      assert_show_model_form_input 1, '#group_number',     'Number'
      assert_show_model_form_input 2, '#group_name',       'Name'
      assert_show_model_form_input 3, '#group_grade',      'Grade'
      assert_show_model_form_input 4, '#group_department', 'Department'
    end
  end

  test "edit" do
    group = Group.create(number: "1001", name: "Tim",  grade: 1, department: 'Computer')
    get :edit, :id => group
    assert_response :success
    assert_select 'form' do
      assert_show_model_form_input 1, '#group_number',     'Number',     '1001'
      assert_show_model_form_input 2, '#group_name',       'Name',       'Tim'
      assert_show_model_form_input 3, '#group_grade',      'Grade',      '1'
      assert_show_model_form_input 4, '#group_department', 'Department', 'Computer'
    end
  end

  test "show" do
    group = Group.create(number: "1001", name: "Tim", grade: 1, department: 'Computer')
    get :show, :id => group
    assert_response :success
    assert_not_nil assigns(:group)
    assert_select 'table' do
      assert_select 'tr',5
      assert_show_model_view_filed 1, "Id",         group.id
      assert_show_model_view_filed 2, "Number",     group.number
      assert_show_model_view_filed 3, "Name",       group.name
      assert_show_model_view_filed 4, "Grade",      group.grade
      assert_show_model_view_filed 5, "Department", group.department
    end
  end

  test "create" do
    assert_difference('Group.count') do
      post :create, group: {number: 'Some Number'}
    end
    group = assigns(:group)
    assert_redirected_to group_path(group)
  end

  test "update" do
    group = Group.create(number: "1001", name: "Tim",  grade: 1, department: 'Computer')
    put :update, :id => group, :group => @update
    assert_redirected_to group_path(assigns(:group))
  end

  test "destroy" do
    group = Group.create(number: "1001", name: "Tim",  grade: 1, department: 'Computer')
    assert_difference('Group.count', -1) do
      delete :destroy, :id => group
    end
    assert_redirected_to groups_path
  end

end