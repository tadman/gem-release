require 'rubygems/commands/build_command'
require 'rubygems/commands/push_command'
require 'rubygems/commands/tag_command'
require 'gem_release/helpers'

class Gem::Commands::ReleaseCommand < Gem::Command
  include GemRelease::Helpers, Gem::Commands

  attr_reader :arguments, :usage

  def initialize
    super('release', 'Build a gem from a gemspec and push to rubygems.org', :tag => false)
    add_option('-t', '--tag', "Create a git tag and push --tags to origin. Defaults to #{options[:tag]}.") do |tag, options|
      options[:tag] = tag
    end
    @arguments = "gemspec - optional gemspec file, will use the first *.gemspec if not specified"
    @usage = "#{program_name} [gemspec]"
  end

  def execute
    build
    push
    remove
    tag if options[:tag]
    say "All done, thanks buddy.\n"
  end

  protected

    def build
      BuildCommand.new.invoke(gemspec_filename)
    end

    def push
      PushCommand.new.invoke(gem_filename)
    end

    def remove
      `rm #{gem_filename}`
      say "Deleting left over gem file #{gem_filename}"
    end
    
    def tag
      TagCommand.new.invoke
    end
end