FactoryGirl.define do 

  factory :user do 
    sequence(:first_name) { |n| "John-#{n}" }
    last_name   "Doe"
    sequence(:email) { |n| "john-#{n}.doe@gmail.com" }
    password "secret"
    password_confirmation "secret"
    
    factory :user_with_canvas do 
      after(:create) do |user|
        user.canvases << FactoryGirl.create(:canvas_with_component_items)
      end
    end

    factory :user_that_sent_canvas_invite do
      after(:create) do |user|
        user.canvases << FactoryGirl.create(:canvas_with_invites)
      end
    end
  end  
  
  factory :canvas do 
    sequence(:name) { |n| "canvas-#{n}" }

    factory :canvas_with_component_items do 
      after(:create) do |canvas|
        canvas.problems << FactoryGirl.create(:problem)
      end
    end

    factory :canvas_with_invites do 
      after(:create) do |canvas|
        canvas.invites << FactoryGirl.create(:invite, canvas_id: canvas.id, name: "John-2 Doe", email: "john-2.doe@gmail.com")
      end
    end
  end

  factory :problem do 
    content    "Has a need to simply complex things."
    tag_color  "#3ba1bf"
  end

  factory :invite do 
    user_id "1"
    status  "Invite Pending"
  end

end
