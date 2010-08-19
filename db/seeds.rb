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
                                                          
write_organization = TaskType.create(:name => 'Write to transport organization', 
                                 :provider => fix_my_transport,
                                 :start_url => "http://localhost:3000/problems/new")
                
TaskParameterType.create(:name => "location_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the location to write about",
                         :task_type => write_organization)

TaskParameterType.create(:name => "location_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the location to write about",
                        :task_type => write_organization)
                        
find_organization = TaskType.create(:name => 'Find transport organization', 
                                :provider => fix_my_transport, 
                                :start_url => "http://localhost:3000/organization/find")
              
TaskParameterType.create(:name => "location_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the location to find the organization responsible for",
                         :task_type => find_organization)

TaskParameterType.create(:name => "location_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the location to find the organization responsible for",
                        :task_type => find_organization)
                        
find_organization_contact = TaskType.create(:name => 'Find transport organization contact details', 
                                        :provider => fix_my_transport,
                                        :start_url => "http://localhost:3000/organization/find_contact")

TaskParameterType.create(:name => "organization_id", 
                         :required => true, 
                         :description => "The FixMyTransport id of the organization",
                         :task_type => find_organization_contact)
                         
TaskParameterType.create(:name => "organization_type", 
                        :required => true, 
                        :description => "The FixMyTransport type of the organization",
                        :task_type => find_organization_contact)