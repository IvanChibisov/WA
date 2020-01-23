module Workarea
  module B2bTestCase
    extend ActiveSupport::Concern

    included { teardown :reset_current }

    def reset_current
      Workarea::Current.instance.reset
    end
  end

  TestCase.include(B2bTestCase)
end
