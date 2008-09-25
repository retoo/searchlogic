require File.dirname(__FILE__) + '/test_helper.rb'

class TestSearchOrdering < Test::Unit::TestCase
  def test_order_as
    search = Account.new_search
    assert_equal nil, search.order
    assert_equal nil, search.order_as
    assert !search.asc?
    
    search.order_as = "DESC"
    assert_equal nil, search.order_as
    assert !search.desc?
    assert_equal nil, search.order
    
    search.order_by = "name"
    assert_equal "\"accounts\".\"name\" DESC", search.order
    
    search.order_as = "ASC"
    assert_equal "\"accounts\".\"name\" ASC", search.order
    assert search.asc?
    
    search.order = "id ASC"
    assert_equal "ASC", search.order_as
    assert search.asc?
    assert_equal "id ASC", search.order
    
    search.order = "id DESC"
    assert_equal "DESC", search.order_as
    assert search.desc?
    assert_equal "id DESC", search.order
    
    search.order_by = "name"
    assert_equal "DESC", search.order_as
    assert search.desc?
    assert_equal "\"accounts\".\"name\" DESC", search.order
  end
  
  def test_order_by
    search = Account.new_search
    assert_equal nil, search.order
    assert_equal nil, search.order_by
    
    search.order_by = "first_name"
    assert_equal "first_name", search.order_by
    assert_equal "\"accounts\".\"first_name\" ASC", search.order
    
    search.order_by = "last_name"
    assert_equal "last_name", search.order_by
    assert_equal "\"accounts\".\"last_name\" ASC", search.order
    
    search.order_by = ["first_name", "last_name"]
    assert_equal ["first_name", "last_name"], search.order_by
    assert_equal "\"accounts\".\"first_name\" ASC, \"accounts\".\"last_name\" ASC", search.order
    
    search.order = "created_at DESC"
    assert_equal "created_at", search.order_by
    assert_equal "created_at DESC", search.order
    
    search.order = "\"users\".updated_at ASC"
    assert_equal({"users" => "updated_at"}, search.order_by)
    assert_equal "\"users\".updated_at ASC", search.order
    
    search.order = "`users`.first_name DESC"
    assert_equal({"users" => "first_name"}, search.order_by)
    assert_equal "`users`.first_name DESC", search.order
    
    search.order = "`accounts`.name DESC"
    assert_equal "name", search.order_by
    assert_equal "`accounts`.name DESC", search.order
    
    search.order = "accounts.name DESC"
    assert_equal "name", search.order_by
    assert_equal "accounts.name DESC", search.order
    
    search.order = "`users`.first_name DESC, name DESC, `accounts`.id DESC"
    assert_equal [{"users" => "first_name"}, "name", "id"], search.order_by
    assert_equal "`users`.first_name DESC, name DESC, `accounts`.id DESC", search.order
    
    search.order = "`users`.first_name DESC, `line_items`.id DESC, `accounts`.id DESC"
    assert_equal [{"users" => "first_name"}, "id"], search.order_by
    assert_equal "`users`.first_name DESC, `line_items`.id DESC, `accounts`.id DESC", search.order
    
    search.order = "`line_items`.id DESC"
    assert_equal nil, search.order_by
    assert_equal "`line_items`.id DESC", search.order
  end
end
