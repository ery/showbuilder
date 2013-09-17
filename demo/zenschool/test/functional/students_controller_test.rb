require 'test_helper'

class StudentsControllerTest < ActionController::TestCase

  test "index" do
    group = Group.create(number: "1007", name: "Tim",  grade: 1, department: 'Computer')
    Student.create(group_id: group.id, number: "1001", name: "Tim",  age: 1, sex: 'Computer')
    Student.create(group_id: group.id, number: "1002", name: "Leon", age: 2, sex: 'English')
    get :index
    assert_response :success
    assert_not_nil assigns(:students)
    assert_template :index
    students = assigns(:students)
    assert_equal 2, students.count
    assert_select 'table tbody tr', 2  do |row_list|
      row_list.each_with_index do |row, index|
        student = students[index]
        assert_select row, 'td', 7
        assert_select row, 'td:nth-child(1)', student.id.to_s
        assert_select row, 'td:nth-child(2)', student.group.number
        assert_select row, 'td:nth-child(3)', student.group.name
        assert_select row, 'td:nth-child(4)', student.number
        assert_select row, 'td:nth-child(5)', student.name
        assert_select row, 'td:nth-child(6)', student.age.to_s
        assert_select row, 'td:nth-child(7)', student.sex
      end
    end
  end

  test "new" do
    get :new
    assert_template :new
    assert_response :success
    assert_select 'form#new_student' do
      assert_show_model_form_input 1, '#student_group_id', 'Group ID'
      assert_show_model_form_input 2, '#student_number',   'Number'
      assert_show_model_form_input 3, '#student_name',     'Name'
      assert_show_model_form_input 4, '#student_sex',      'Sex'
      assert_show_model_form_input 5, '#student_age',      'Age'
    end
  end

  test "create" do
    assert_difference('Student.count') do
      post :create, student: {number: 'Some Number'}
    end
    student = assigns(:student)
    assert_redirected_to student_path(student)
  end

  test "show" do
    group = Group.create(number: "1007", name: "Tim",  grade: 1, department: 'Computer')
    student = Student.create(group_id: group.id, number: "1001", name: "Tim",  age: 1, sex: 'Computer')
    get :show, :id => student
    assert_response :success
    assert_select 'table' do
      assert_select 'tr',5
      assert_show_model_view_filed 1, "Id",     group.id
      assert_show_model_view_filed 2, "Number", student.number
      assert_show_model_view_filed 3, "Name",   student.name
      assert_show_model_view_filed 4, "Age",    student.age
      assert_show_model_view_filed 5, "Sex",    student.sex
    end
  end

  test "edit" do
    group = Group.create(number: "1007", name: "Tim",  grade: 1, department: 'Computer')
    student = Student.create(group_id: group.id, number: "1001", name: "Tim",  age: 1, sex: 'Computer')
    get :edit, :id => student
    assert_response :success
    assert_select 'form' do
      assert_show_model_form_input 1, '#student_number', 'Number', '1001'
      assert_show_model_form_input 2, '#student_name',   'Name',   'Tim'
      assert_show_model_form_input 3, '#student_age',    'Age',    '1'
      assert_show_model_form_input 4, '#student_sex',    'Sex',    'Computer'
    end
  end

  test "update" do
    group = Group.create(number: "1007", name: "Tim",  grade: 1, department: 'Computer')
    student = Student.create(group_id: group.id, number: "1001", name: "Tim",  age: 1, sex: 'Computer')
    put :update, :id => student, :student => @update
    assert_redirected_to student_path(assigns(:student))
  end

  test "destroy" do
    group = Group.create(number: "1007", name: "Tim",  grade: 1, department: 'Computer')
    student = Student.create(group_id: group.id, number: "1001", name: "Tim",  age: 1, sex: 'Computer')
    assert_difference('Student.count', -1) do
      delete :destroy, :id => student
    end
    assert_redirected_to students_path
  end

end
