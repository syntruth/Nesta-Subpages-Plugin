# Nesta Subpages Plugin

Add two new methods to the `Nesta::Page` class that finds any subpages
for an index page. A subpage is considered to be a sibling page in the
same directory as the index page and any index pages within immediate
subdirectories. For example:

    /content/pages/parent/
    /content/pages/parent/index.mdown
    /content/pages/parent/page-1.mdown
    /content/pages/parent/page-2.mdown
    /content/pages/parent/subdir-1/
    /content/pages/parent/subdir-1/index.haml
    /content/pages/parent/subdir-2/
    /content/pages/parent/subdir-2/some-other-pages.mdown

    Page.find_by_path('parent').subpages() => [page-1, page-2, subdir-1]

The returned array contains the Page instances themselves, not their
string paths, and they will be sorted based on their titles.

Next, there is also `#has_subpages?` helper method that returns true or
false if the page has any subpages.

Subpages are cached within an instance variable the first time that
`#subpages` is called, but this should not be a problem in most cases.

Also, there is a helper defined called `subpages_for` that takes either
a Page instance or a string path and returns the same array.

Lastly, if for some reason you do *not* want a subpage listed, merely
give it the metadata tag of `skip subpage: true` and it will indeed be
skipped in the list.

## Installation

Add this line to your application's Gemfile:

    gem 'nesta-plugin-subpages'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nesta-plugin-subpages

## Usage

Not much to do! Simply call the `#subpages` method on your Page object
when you want to use the array of subpages! Easy peasy, m'friend. For
example, in the sidebar, you might do this:

    - if @page.has_subpages?
      #nav.subpages
        %h1 Subpages
        - display_menu(@page.subpages, :class => "menu")

        
# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
