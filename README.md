## Installation

Add this line to your application's Gemfile:

```ruby
gem 'administrate_exportable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install administrate_exportable

## Usage

For each resource you want to be exportable, add the following line to the their respective Administrate controller.
```ruby
include AdministrateExportable::Exporter
```
and the following line in the `db/routes.rb` file, correctly nested on resources
```ruby
get :export, on: :collection
```

Example:
```ruby
namespace :admin do
  resources :organizations do
    get :export, on: :collection
  end
....
```

By default all the attributes from `ATTRIBUTE_TYPES` will be exported. If you want to exclude an attribute, you can use the option: `export: false`.

Example:
```ruby
class BusinessDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number.with_options(export: false),
    name: Field::String,
    description: Field::Text,
...
```

For the default field types from Administrate, we export the values you got from the partial `views/fields/index`. And if it is a custom field, we just run `field.to_s`.
But if you want to specify the value to be exported, you can use the option `transform_on_export`, to pass a `Proc` that receives the `field`.
Example:
```ruby
ATTRIBUTE_TYPES = {
 created_at: Field::DateTime.with_options(transform_on_export: -> (field) { field.data.strftime("%F") })
```

By default the gem adds the Export button to the view `views/admin/application/index.html.erb`. But if you have your own Administrate `index` views, you can add the link manually:
```ruby
 link_to 'Export', [:export, namespace, page.resource_path], class: 'button'
```

Example:

```rails
....
 <div>
    <%= link_to(
      t(
        "administrate.actions.new_resource",
        name: page.resource_name.titleize.downcase
      ),
      [:new, namespace, page.resource_path],
      class: "button",
    ) if valid_action?(:new) && show_action?(:new, new_resource) %>
    <%= link_to 'Export', [:export, namespace, page.resource_path], class: 'button' %>
  </div>
....
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SourceLabsLLC/administrate_exportable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
