module Evm
  class Recipe
    RECIPES_PATH = File.join(Evm::ROOT_PATH, 'recipes')

    attr_reader :name

    class Dsl
      attr_reader :name

      def recipe(name, &block)
        @name = name
      end
    end

    def initialize(recipe_file)
      @recipe_file = recipe_file

      dsl = Dsl.new
      dsl.instance_eval(read)

      @name = dsl.name
    end

    def read
      File.read(@recipe_file)
    end

    class << self
      def find(name)
        all.find { |recipe| recipe.name == name }
      end

      def all
        Dir.glob(File.join(RECIPES_PATH, '*.rb')).map do |recipe_file|
          Recipe.new(recipe_file)
        end
      end
    end
  end
end
