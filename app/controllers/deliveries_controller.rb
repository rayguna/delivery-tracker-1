class DeliveriesController < ApplicationController
  def index
    matching_deliveries = Delivery.all

    @list_of_deliveries = matching_deliveries.order({ :created_at => :asc })

    render({ :template => "deliveries/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    @the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show" })
  end

  def create # "Log delivery" button
    the_delivery = Delivery.new
    the_delivery.user_id = params.fetch("query_user_id")
    the_delivery.description = params.fetch("query_description")
    the_delivery.details = params.fetch("query_details")
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.arrived = false #params.fetch("query_arrived", false) #the default is false

    if the_delivery.valid?
      the_delivery.save
      #redirect_to("/deliveries", { :notice => "Delivery created successfully." })
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update # "Mark as received" button
    the_id = params.fetch("path_id") #this is the same as the deliveries id
    the_delivery = Delivery.where({ :id => the_id }).at(0) #matches the row of the item

    #the_delivery.user_id = params.fetch("query_user_id")
    #the_delivery.description = params.fetch("query_description")
    #the_delivery.details = params.fetch("query_details")
    

    #the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.arrived = true #params.fetch("query_arrived", false) #change status to arrived

    if the_delivery.valid?
      the_delivery.save
      #redirect_to("/deliveries/#{the_delivery.id}", { :notice => "Delivery updated successfully."} )
      #redirect_to("/deliveries", { :notice => "Delivery updated successfully."} )
      redirect_to("/deliveries", { :notice => "Marked as received."} )

    else
      #redirect_to("/deliveries/#{the_delivery.id}", { :alert => the_delivery.errors.full_messages.to_sentence })
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end

  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.destroy

    redirect_to("/deliveries", { :notice => "Delivery deleted successfully."} )
  end
end
