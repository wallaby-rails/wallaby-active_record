# Metadata

Wallaby::ActiveRecord generates the metadata for all the columns and associations found from the ActiveRecord models and use it for different controller actions including `index`, `show` and `form`. Therefore, you can easily customize the metadata to meet your needs based on the generated metadata. For example:

```ruby
class Admin::UserDecorator < Admin::ApplicationDecorator
  # `index_fields[:password]` returns
  index_fields[:password][:type] = 'password'
end
```

In this example, we change the type of field `password` to type `password` so that `index` page displays `********` instead of plain password.

## Options for index page

### sort_disabled

`:sort_disabled` options is to tell Wallaby to disable the sorting for the UI and backend:
- `true` means disable sorting.
- `false` means enable sorting.

> NOTE: by default, sorting is disabled for all association fields.

```ruby
class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:price][:sort_disabled] = true # or false
end
```

### nulls

`:nulls` options is to tell Wallaby to place the rows having `NULL` value:
- `:first` means at the beginning
- `:last` means at the end.

```ruby
class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:price][:nulls] = :last # or `:first`
end
```

## Metadata Examples

We will list the metadata examples for columns and associations as follows:

### General column

```ruby
class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:name]
  # =>
  # {"type"=>"string", "label"=>"Name"}
end
```

NOTE: `show_fields[:name]` and `form_fields[:name]` will be the same as `index_fields[:name]` before they are changed.

### Belongs to

```ruby
class Product < ApplicationRecord
  belongs_to :category
end

class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:category]
  # =>
  # {"type"=>"belongs_to",
  #  "label"=>"Category",
  #  "is_association"=>true,
  #  "sort_disabled"=>true,
  #  "is_through"=>false,
  #  "has_scope"=>false,
  #  "foreign_key"=>"category_id",
  #  "class"=>Category(id: integer, name: string)}
end
```

NOTE: `show_fields[:category]` and `form_fields[:category]` will be the same as `index_fields[:category]` before they are changed.

### Has one

```ruby
class Product < ApplicationRecord
  has_one :product_detail
end

class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:product_detail]
  # =>
  # {"type"=>"has_one",
  #  "label"=>"Product detail",
  #  "is_association"=>true,
  #  "sort_disabled"=>true,
  #  "is_through"=>false,
  #  "has_scope"=>false,
  #  "foreign_key"=>"product_detail_id",
  #  "class"=>ProductDetail(id: integer, product_id: integer, meta_data: text)}
end
```

NOTE: `show_fields[:product_detail]` and `form_fields[:product_detail]` will be the same as `index_fields[:product_detail]` before they are changed.

### Has many

```ruby
class Product < ApplicationRecord
  has_many :order_items, class_name: "Order::Item"
end

class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:order_items]
  # =>
  # {"type"=>"has_many",
  #  "label"=>"Order items",
  #  "is_association"=>true,
  #  "sort_disabled"=>true,
  #  "is_through"=>false,
  #  "has_scope"=>false,
  #  "foreign_key"=>"order_item_ids",
  #  "class"=> Order::Item(id: integer, order_id: integer, product_id: integer, quantity: integer, price: float, total: float)}
end
```

NOTE: `show_fields[:order_items]` and `form_fields[:order_items]` will be the same as `index_fields[:order_items]` before they are changed.

### Has and belongs to many

```ruby
class Product < ApplicationRecord
  has_and_belongs_to_many :tags
end

class Admin::ProductDecorator < Admin::ApplicationDecorator
  index_fields[:tags]
  # =>
  # {"type"=>"has_and_belongs_to_many",
  #  "label"=>"Tags",
  #  "is_association"=>true,
  #  "sort_disabled"=>true,
  #  "is_through"=>false,
  #  "has_scope"=>false,
  #  "foreign_key"=>"tag_ids",
  #  "class"=>Tag(id: integer, name: string)}
end
```

NOTE: `show_fields[:tags]` and `form_fields[:tags]` will be the same as `index_fields[:tags]` before they are changed.

### STI & Polymorphic

```ruby
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
end

class Product < ApplicationRecord
  has_one :picture, as: :imageable
end

class Person < ApplicationRecord
  has_one :picture, as: :imageable
end

class Customer < Person; end

class Staff < Person; end

class Admin::PictureDecorator < Admin::ApplicationDecorator
  index_fields[:imageable]
  # =>
  # {"type"=>"belongs_to",
  #  "label"=>"Imageable",
  #  "is_association"=>true,
  #  "sort_disabled"=>true,
  #  "is_through"=>false,
  #  "has_scope"=>false,
  #  "foreign_key"=>"imageable_id",
  #  "is_polymorphic"=>true,
  #  "polymorphic_type"=>"imageable_type",
  #  "polymorphic_list"=>
  #   [Customer(id: integer, type: string),
  #    Person(id: integer, type: string),
  #    Product(id: integer, category_id: integer, sku: string, name: string, description: text, stock: integer, price: float, featured: boolean, available_to_date: date, available_to_time: time, published_at: datetime),
  #    Staff(id: integer, type: string)]}
end
```

NOTE: `show_fields[:imageable]` and `form_fields[:imageable]` will be the same as `index_fields[:imageable]` before they are changed.

