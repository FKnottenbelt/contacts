ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
require_relative '../app.rb'

class AppTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    FileUtils.mkdir_p(data_path)
    contents = {"contacts"=>
                [{"name"=>"Chris Uppen",
                  "phone"=>"1234567890",
                  "email"=>"chris.uppen@mymail.com"},
                 {"name"=>"Christina Uppen",
                  "phone"=>"2234567890",
                  "email"=>"christina.uppen@mymail.com"}]}

    create_document('contacts.yml',contents)
  end

  def teardown
    FileUtils.rm_rf(data_path)
  end

  def create_document(name, content)
    new_doc = File.join(data_path, name)
    File.write(new_doc, content.to_yaml, mode:'w')
  end

  def session
    last_request.env["rack.session"]
  end

  ## Index
  def test_contact_index
    get '/'

    assert_equal 200, last_response.status
    assert_includes last_response.body, '/Chris Uppen'
  end

  ## Show
  def test_contact_show
    get '/contacts/Johnny'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Johnny'
  end

  ## New
  def test_contact_new
    skip
    get '/contacts/new'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Submit'
  end

  ## Create
  def test_contact_create_valid_contact
    skip
    post '/contacts', name: 'Carl'

    assert_equal 302, last_response.status
    assert_equal "Added Carl", session[:message]
  end

  def test_contact_create_invalid_contact_fails
    skip
    post '/contacts', name: 'Johnny'

    assert_equal 422, last_response.status
    assert_includes last_response.body, "Invalid name"
  end

  ## Edit
  def test_contact_edit
    skip
    get '/contacts/Johnny/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Submit'
  end

  ## Update
  def test_contact_update_valid_name
    skip
    put '/contacts/Johnny', name: 'Johannes'

    assert_equal 302, last_response.status
    assert_equal "Changed name to: Johannes", session[:message]
  end

  def test_contact_update_invalid_name_fails
    skip
    put '/contacts/Johnny', name: ''

    assert_equal 422, last_response.status
    assert_includes last_response.body, "Invalid name"
  end

  ## Delete
  def test_contact_delete
    skip
    get '/contacts/Johnny/delete'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Remove contact'
  end

  ## Destroy
  def test_contact_destroy
    skip
    delete '/contacts/Johnny'

    assert_equal 302, last_response.status
    assert_equal "Deleted Johnny", session[:message]
  end
end