# delivery-tracker-1

Target: https://delivery-tracker-1.matchthetarget.com

Lesson: https://learn.firstdraft.com/lessons/205-delivery-tracker-1

Grading: https://grades.firstdraft.com/resources/c0def4b5-99fa-408b-abd6-1f0b1ac67b68 

<hr>

Notes

### A. Create and populate tables

1. Review the file called lib/tasks/dev.rake. Here is what I see:

```
usernames.each do |username|
    user = User.new
    user.email = "#{username}@example.com"
    user.password = "password"
    user.save

    10.times do
      delivery = Delivery.new
      delivery.user_id = user.id
      delivery.description = Faker::Commerce.product_name
      delivery.details = "#{["FedEx", "UPS", "USPS"].sample} tracking ##{rand(1000000000000)}" if rand < 0.5
      delivery.supposed_to_arrive_on = Faker::Date.between(from: 1.month.ago, to: 2.weeks.from_now)

      if delivery.supposed_to_arrive_on < Time.now
        delivery.arrived = [true, false].sample
      else
        delivery.arrived = false
      end
```

2. The above script tells me that the rake sample_data command will populate two tables called User and Delivery. The fields are as follows:

```
User:
- email (string)
- password (string)

Delivery:
- user_id (integer)
- description (text)
- details (text)
- supposed_to_arrive_on (date)
- arrived (boolean)

The two tables are associated with one-to-many relationships. One user has_many(deliveries). 
```

3. Generate the two tables (delivery and user tables) using the following commands:
- `rails generate draft:resource Delivery user_id:integer description:text details:text supposed_to_arrive_on:date arrived:boolean`
- `rails generate devise user`

For reference, watch the must see movies with generators 22.30 min.

4. The corresponding migrate files for each table are created.

5. Then, type `rails db:migrate` to execute the databases.

6. Finally, type `rake sample_data` to populate the tables.

Check that tables exist: https://psychic-meme-j4jv9vpq79g25q5r-3000.app.github.dev/rails/db/

### B. Check sign_in page

1. Visit: https://psychic-meme-j4jv9vpq79g25q5r-3000.app.github.dev/users/sign_in. Yes, the page exists.

2. Make the page default by modifying the following file.

```
# app/controller/application_controller.rb

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # ...
```

3. Also, modify config/routes.db as follows:

```
Rails.application.routes.draw do
  devise_for :users
  #for devise gem
  #root to: "home#index"

  root "deliveries#index"
```

Note that the name deliveries must match with the class name. In this case, the command root "deliveries#index" replaces `get("/", { :controller => "deliveries", :action => "index" })`.
