# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

fix_my_transport = Application.create(:name => "FixMyTransport")

publish_problem = TaskType.create(:name => 'Publish problem', 
                                  :provider => fix_my_transport, 
                                  :start_url => "http://localhost:3000/problems/new")
                
TaskParameterType.create(:name => "location_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the location where the problem is",
                         :task_type => publish_problem)

TaskParameterType.create(:name => "location_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the location where the problem is",
                        :task_type => publish_problem)        
                                                          
write_operator = TaskType.create(:name => 'Write to transport operator', 
                                 :provider => fix_my_transport,
                                 :start_url => "http://localhost:3000/problems/new")
                
TaskParameterType.create(:name => "location_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the location to write about",
                         :task_type => write_operator)

TaskParameterType.create(:name => "location_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the location to write about",
                        :task_type => write_operator)
                        
find_operator = TaskType.create(:name => 'Find transport operator', 
                                :provider => fix_my_transport, 
                                :start_url => "http://localhost:3000/operator/find")
              
TaskParameterType.create(:name => "location_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the location to find the operator of",
                         :task_type => find_operator)

TaskParameterType.create(:name => "location_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the location to find the operator of",
                        :task_type => find_operator)
                        
find_operator_contact = TaskType.create(:name => 'Find transport operator contact details', 
                                        :provider => fix_my_transport,
                                        :start_url => "http://localhost:3000/operator/find_contact")

TaskParameterType.create(:name => "operator_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the operator",
                         :task_type => find_operator_contact)
                                 