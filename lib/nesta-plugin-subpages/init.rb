module Nesta
  module Plugin
    module Subpages
      module Helpers

        # Helper that takes a page or a string path to a page
        # and returns any subpages if they exist, or an empty
        # array otherwise.
        def subpages_for(page_or_path)
          case page_or_path
          when Nesta::Page
            return page_or_path.subpages()
          when String
            page = Nesta::Page.find_by_path(page_or_path)
            return page.subpages if page
          end

          return []
        end

      end
    end
  end

  class Page
    # This method grabs any pages that are siblings of an index
    # page and any index pages in immediate subdirectories. If
    # the page is NOT an index page or there are NO subpages, an
    # empty array is returned.
    #
    # The argument is a hash that defines two keys:
    #   :do_sort         -- sort the results by page title.
    #   :include_subdirs -- include index pages in immediate subdirectories.
    #
    # If given a block, the method will yield each page to it and
    # method will return nil. Pages are still cached in @subpages
    # however.
    def subpages(opts={})
      return [] unless self.index_page?
      return @subpages if @subpages

      options = {
        :do_sort         => true,
        :include_subdirs => true
      }.update(opts)

      pth   = File.dirname(self.filename)
      mpth  = Page.model_path   # Just cacheing these two for
      fmts  = FORMATS.join('|') # use below.
      pages = []

      Dir.foreach(pth) do |entry|
        # Skip the dot-dirs and any index page in the current
        # directory.
        next if entry == '.' or entry == '..' or entry.match(/^index/)

        entry = File.join(pth, entry)

        if File.directory?(entry)
          # If we are allowed to include the sub-directory
          # index pages, do so. If no index page is detected, 
          # move on to the next entry.
          next unless options[:include_subdirs]
          idxpth = File.join(entry, 'index.%s')
          next unless FORMATS.detect {|fmt| File.exists?(idxpth % fmt)}
        else
          # Ignore any file that isn't a page.
          next unless entry.match(/\.(#{fmts})$/)
        end

        entry = entry.sub("#{mpth}/", '').sub(/\.(#{fmts})/, '')
        page  = Page.find_by_path(entry)

        # If we have a page and we haven't been asked skip 
        # this page, add it to the list.
        if page and not page.metadata('skip subpage')
          pages.push(page)
        end
      end

      @subpages = pages

      if options[:do_sort]
        @subpages.sort! {|n, m| n.title.downcase <=> m.title.downcase}
      end

      if block_given?
        @subpages.each {|page| yield page}
        return nil
      end

      return @subpages
    end

    # Returns true if the page is an index page AND there are
    # any subpages, false otherwise.
    def has_subpages?
      return false unless self.index_page?
      return self.subpages.empty? ? false : true
    end
  end

  class App
    helpers Nesta::Plugin::Subpages::Helpers
  end
end
