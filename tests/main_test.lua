require "glucose-test/glucose-test"

ts = TestSuite.new()

function assert_true ()
  return true
end

ts:addTestCase(TestCase:new(assert_true, "Should be true", "Is false."))

function assert_false ()
  return false
end
ts:addTestCase(TestCase:new(assert_false, "Should be true", "Is false."))

ts:run ( )