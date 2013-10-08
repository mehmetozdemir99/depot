require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be greater than zero" do

    product = Product.new(title:"My book", description: "Description", image_url: "zz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?

  end

  def new_product(image_url)
    Product.new(title:"My product", description:"Description", image_url:image_url, price:2)
  end

  test "image url must be valid" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |file|
      assert new_product(file).valid?, "#{file} should be valid"
    end

    bad.each do |file|
      assert new_product(file).invalid?, "#{file} should be invalid"
    end
  end

  test "product is not valid without unique title" do
    product = Product.new(title:products(:Ruby).title, description:"sample book", image_url:"image.gif", price:11)
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

end
