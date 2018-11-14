# AdministrateExportable

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/administrate_exportable`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

Add to your `Admin::ApplicationController` the following line.
```ruby
 helper AdministrateExportable::ExporterHelper
```

For each resource you want to be exportable, add the following line the their respective Administrate controller.
```ruby
include AdministrateExportable::Exporter
```
and the following on the `routes` file, correctly nested on resources
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


By default the gem, already adds the export button on the view `views/admin/application/index.html.erb`. But if you have your owns administrate `index` views, you can use the helper `export_button`, to display the button.

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
    <%= export_button %>
  </div>
....
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/administrate_exportable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
