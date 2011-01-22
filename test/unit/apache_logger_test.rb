require File.dirname(__FILE__) + "/../test_helper"

class ApacheLoggerTest < Test::Unit::TestCase

    def test_exists
        assert_nothing_raised do
            ApacheLogger
        end
    end

end

# LogFormat "%v:%p %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined