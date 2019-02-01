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
    assert_includes last_response.body, '/Chris%20Uppen'
  end

  ## Show
  def test_contact_show
    get '/contacts/Chris%20Uppen'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Chris'
    assert_includes last_response.body, '1234567890'
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
    get '/contacts/Chris%20Uppen/edit'

    assert_equal 200, last_response.status
    assert_includes last_response.body, 'Submit'
    assert_includes last_response.body, '1234567890'
  end

  ## Update
  def test_contact_update_valid_name
    put '/contacts/Chris%20Uppen', phone: '1234567891'

    assert_equal 302, last_response.status
    assert_equal "Updated contact info for Chris Uppen", session[:message]
    assert_includes last_response.body, '1234567891'
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