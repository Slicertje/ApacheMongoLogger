require File.dirname(__FILE__) + "/../../test_helper"

module ApacheLogger

    class ParserTest < Test::Unit::TestCase

        def setup
            @parser1 = Parser.new 'admin.local.comicwatcher.com:80 127.0.0.1 - - [05/Jan/2011:21:14:04 +0100] "GET /media/4d21dde7344f863755000001/96x138/rails.png HTTP/1.1" 304 - "-" "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Ubuntu/10.04 Chromium/8.0.552.224 Chrome/8.0.552.224 Safari/534.10"'
            @parser2 = Parser.new 'admin.local.comicwatcher.com:80 127.0.0.1 - - [05/Jan/2011:21:14:04 +0100] "GET /static/images/folder_edit.png?1266605321 HTTP/1.1" 304 - "http://admin.local.comicwatcher.com/medias?parent=4d21d4a8344f861b09000009" "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Ubuntu/10.04 Chromium/8.0.552.224 Chrome/8.0.552.224 Safari/534.10"'
            @parser3 = Parser.new 'admin.local.comicwatcher.com:80 127.0.0.1 - - [07/Jan/2011:17:15:38 +0100] "GET /pages HTTP/1.1" 200 1792 "http://admin.local.comicwatcher.com/pages" "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Ubuntu/10.04 Chromium/8.0.552.224 Chrome/8.0.552.224 Safari/534.10"'
        end

        # Format:
        # "%v:%p %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""
        # %v ->  admin.local.comicwatcher.com
        # %p -> 80
        # %h -> 127.0.0.1
        # %l -> -
        # %u -> -
        # %t -> [05/Jan/2011:21:14:04 +0100]
        # %r -> "GET /media/4d21dde7344f863755000001/96x138/rails.png HTTP/1.1"
        # %>s 304
        # %b -
        # %Referer "http://admin.local.comicwatcher.com/medias?parent=4d21d4a8344f861b09000009"
        # %User-Agent "Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Ubuntu/10.04 Chromium/8.0.552.224 Chrome/8.0.552.224 Safari/534.10"

        def test_host
            assert_equal 'admin.local.comicwatcher.com', @parser1.host
        end

        def test_port
            assert_equal '80', @parser1.port
        end

        def test_ip
            assert_equal '127.0.0.1', @parser1.ip
        end

        def test_time
            time = Time.mktime(2011, 1, 5, 21, 14, 4)
            assert_equal time.utc, @parser1.time
        end

        def test_request_type
            assert_equal 'GET', @parser1.request_type
        end

        def test_url
            assert_equal '/media/4d21dde7344f863755000001/96x138/rails.png', @parser1.url
            assert_equal '/static/images/folder_edit.png?1266605321', @parser2.url
        end

        def test_request_protocol
            assert_equal 'HTTP/1.1', @parser1.request_protocol
        end

        def test_state
            assert_equal '304', @parser1.state
            assert_equal '200', @parser3.state
        end

        def test_size
            assert_equal 0, @parser1.size
            assert_equal 1792, @parser3.size
        end

        def test_referer
            assert_equal nil, @parser1.referer
            assert_equal 'http://admin.local.comicwatcher.com/pages', @parser3.referer
        end

        def test_user_agent
            assert_equal 'Mozilla/5.0 (X11; U; Linux x86_64; en-US) AppleWebKit/534.10 (KHTML, like Gecko) Ubuntu/10.04 Chromium/8.0.552.224 Chrome/8.0.552.224 Safari/534.10', @parser1.user_agent
        end

    end

end