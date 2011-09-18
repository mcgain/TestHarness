class TestBase
  @children = []
  def self.inherited(child)
    @children << child
  end

  def setup
  end

  def teardown
  end

  def self.run
    @testable_methods = []
    test_results = []
    for child in @children do
      begin
        class_results = TestResult.new
        child_class = child.new
        child_class.setup
        run_methods_for(child_class, class_results)
        child_class.teardown
      rescue
        class_results.errors << "Error: #{$!}"
      end
    end
    print "#{class_results.count} tests ran\n#{class_results.errors.count} failed   
      "
    print class_results.errors.to_s
  end
  
  def self.run_methods_for(object_to_test, class_results)
    object_to_test.methods.grep(/test_/) do |testable_method|
      begin
        class_results.count += 1
        object_to_test.send(testable_method)
      rescue
        class_results.errors << "Error: #{$!}"  
      end
    end
  end 
  
end

class TestResult
  attr_accessor :errors, :count
  def initialize
    @errors = []
    @count = 0
  end
end

class TestAddition < TestBase
  def setup
    print "setting up\n"
  end
  def teardown
    print "tearing down \n"
  end
  def test_one_plus_one
    print "tested 1\n"
  end
  def test_something
    print "tesdted 2\n"
  end
  def random_method
    print "WHOOPS!"
  end
  def test_fail
    raise "delibverate failure"
  end
  def test_fail2
    raise "more deliberate failures"
  end
end

TestBase.run
