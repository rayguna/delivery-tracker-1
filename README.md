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

4. The command rake sample_Data populate the users table with the five default users, and youcan login with any of the credentials.

5. Type `rake grade` to get the current score. The score is only 2/22.

### C. Tables relationship

1. Go to app/controllers/models/models/delivery.db and add inside the class.

```
#delivery.db

belongs_to(:user)
```
and
```
#user.db

has_many(:delivery)
```

### D. Work on front end

1. Look at the target.

2. Go to app/views/layouts/application.html.erb and add the contents within the <nav> tag.

```
    <nav>
        <a href="/">Delivery Tracker</a>
        |
        <a href="/users/edit">Edit profile</a>
        |
        <a href="/users/sign_out">Sign out</a>
    </nav>

    <hr>
```

3. Add the following to the <head> of application.html.erb:

```
<!-- app/views/layouts/application.html.erb -->

<link rel="stylesheet" href="/css/my_styles.css">
```

4. Modify the h1 and h2 messages of the views/deliveries/index.html.erb files.

5. Mimic bulletin-board-2 assignment and add to the head the following message displays in the body section:

```
    <% if notice.present? %>
      <div style="color: green">
        <%= notice %>
      </div>
    <% end %>

    <% if alert.present? %>
      <div style="color: red">
        <%= alert %>
      </div>
    <% end %>
```
6. Add validates statements to catch alert and to give notice when forms are submitted.

7. Change button caption from "Create delivery" to "Log delivery".

8. Hide user textbox and default the value to current_user.id.

9. Added to deliveries controller the statement "Added to list"

```
  def create # "Log delivery" button
    the_delivery = Delivery.new
    the_delivery.user_id = params.fetch("query_user_id")
    the_delivery.description = params.fetch("query_description")
    the_delivery.details = params.fetch("query_details")
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.arrived = params.fetch("query_arrived", false)

    if the_delivery.valid?
      the_delivery.save
      #redirect_to("/deliveries", { :notice => "Delivery created successfully." })
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end
```

10. Need to ad validates command to `app/models/delivery.db`, so that the form can be validated.

```
class Delivery < ApplicationRecord
  validates(:supposed_to_arrive_on, presence: true) #make sure the arrival date is set
  validates(:description, presence: true) #make sure description is set
  validates(:details, presence: true) #make sure details is set

  belongs_to(:user)
end
```

11. "Mark as received" button on the index page should be redirected back to the index page!

12. Mimic target and change the route when the "mark as received" button is pressed to return to the main page.

```
#app/controllers/deliveries_controller.rb

    if the_delivery.valid?
      the_delivery.save
      #redirect_to("/deliveries/#{the_delivery.id}", { :notice => "Delivery updated successfully."} )
      redirect_to("/deliveries", { :notice => "Delivery updated successfully."} )

    else
      #redirect_to("/deliveries/#{the_delivery.id}", { :alert => the_delivery.errors.full_messages.to_sentence })
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
```

13. Most of the errors went away after fixing the route for the "mark as received" button and after deleting the default table on the index page.

Tried to sort the received list by updated_at as in the target page, as follows, but it didn't help.

```
<% @list_of_deliveries.sort_by(&:updated_at).reverse!.each do |a_delivery| %>
```

Tried to remove .details validates, but it didn't help. 

***
