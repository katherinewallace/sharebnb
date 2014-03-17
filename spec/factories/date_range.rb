FactoryGirl.define do
  
   factory :date_range do
     start_date Date.today
     end_date Date.today + 2.weeks
   end
  
end
