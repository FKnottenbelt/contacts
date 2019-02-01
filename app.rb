require 'sinatra'
require 'tilt/erubis'
require 'sinatra/reloader'
require 'fileutils'
require 'bundler/setup'
require 'pry'
require "yaml"

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, escape_html: true
end

before do
  @contacts ||= load_contacts
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def load_contacts
  contacts_file = File.join(data_path, 'contacts.yml')
  contacts = YAML.load_file(contacts_file)
  contacts['contacts']
end

def get_contact_details(contact)
  @contacts.select{ |person| person['name'] == contact }.first
end

# def write_to_contacts_file(new_content)
#   contacts_file = File.join(data_path, 'contacts.yml')
#   File.write(contacts_file, new_content, mode: 'w')
# end

# def valid_name?(name)
#   !(name.to_s.empty?  || @contacts.include?(name) ||
#     @contacts.include?(name + "\n"))
# end

# def determine_name(old_name, new_name)
#   if name =~ /#{old_name}/
#     name.gsub(old_name, new_name).strip
#   else
#     name
#   end
# end

# def edit_contact(old_name, new_name)
#   contacts = load_contacts

#   new_content = contacts.map do |name|
#     if name =~ /#{old_name}/
#       name.gsub(old_name, new_name).strip
#     else
#       name
#     end
#   end.join

#   write_to_contacts_file(new_content)
# end

# def delete_contact(name)
#   edit_contact(name, "")
# end

# def add_contact(name)
#   file = File.join(data_path, 'contacts.yml')
#   File.write(file, "\n#{name}", mode:'a')
# end

# Index: Display all contacts
get '/' do
  erb :index
end

get '/contacts' do
  redirect '/'
end

# New: go to new contact page
# get '/contacts/new' do
#   erb :new
# end

# Create: add new contact
# post '/contacts' do
#   @new_contact = params[:name]

#   if valid_name?(@new_contact)
#     add_contact(@new_contact)
#     session[:message] = "Added #{@new_contact}"

#     redirect "/contacts/#{@new_contact}"
#   else
#     status 422
#     session[:message] = 'Invalid name'
#     erb :new
#   end

# end

# Show: show individual contact
get '/contacts/:name' do
  @contact = params[:name]
  @contact_info = get_contact_details(@contact)

  erb :show
end

# Edit: get contact edit page
get '/contacts/:name/edit' do
  @contact = params[:name]
  @contact_info = get_contact_details(@contact)

  erb :edit
end

def validate_contact_info(info)

end

def contact_info_valid?
  !session[:message]
end

def update_contact_info(contact, contact_info)

end

# Update: edit a contact
put '/contacts/:old_name' do
  @contact = params[:old_name]

  validate_contact_info(params)

  if contact_info_valid?
    @contact_info = get_contact_details(@contact)
    update_contact_info(@contact, @contact_info)
    session[:message] = "Updated contact info for #{@contact}"

    redirect "/contacts/#{@contact_info['name'].gsub(' ','%20')}"
  else
    status 422
    session[:message] = 'Invalid name'
    #@contact = params[:old_name]

    erb :edit
  end
end

# Delete: get page to delete contact
# get '/contacts/:name/delete' do
#   @contact = params[:name]
#   erb :delete
# end

# Destroy: delete contact
# delete '/contacts/:name' do
#   delete_contact(params[:name])
#   session[:message] = "Deleted #{params[:name]}"
#   redirect "/contacts"
# end