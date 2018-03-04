class ContactsController < ApplicationController
   
   def new
      @contact = Contact.new
   end
   
   def create
      @contact = Contact.new(contact_params)
      
      respond_to do |format|
        if @contact.save
          name = params[:contact][:name]
          email = params[:contact][:email]
          body = params[:contact][:comments]
          
          ContactMailer.contact_email(name, email, body).deliver
          
          format.html { redirect_to new_contact_path, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @contact }          
        else
          format.html { redirect_to new_contact_path, notice: 'Post was invalid.' }
          format.json { render json: @contact.errors, status: :unprocessable_entity }          
        end
      end      
   end
   
   private
   def contact_params
      params.require(:contact).permit(:name, :email, :comments) 
   end
end