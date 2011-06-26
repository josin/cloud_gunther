require 'spec_helper'

describe "tasks/new.html.erb" do
  before(:each) do
    assign(:task, stub_model(Task,
      :params => "MyText",
      :inputs => "MyText",
      :state => "MyString",
      :user_id => 1,
      :algorithm_binary_id => 1
    ).as_new_record)
    assign(:algorithms, [])
  end
  
  it "renders new task form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path, :method => "post" do
      # assert_select "textarea#task_params", :name => "task[params]"
      # assert_select "textarea#task_inputs", :name => "task[inputs]"
      # assert_select "input#task_state", :name => "task[state]"
      # assert_select "input#task_user_id", :name => "task[user_id]"
      # assert_select "select#task_algorithm_binary_id", :name => "task[algorithm_binary_id]"
    end
  end
end
