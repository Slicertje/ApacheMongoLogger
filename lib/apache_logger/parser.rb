require 'time'
require 'date'

module ApacheLogger

    class Parser

        attr_reader :host, :port, :ip, :time,
                    :request_type, :url, :request_protocol,
                    :state, :size, :referer, :user_agent

        def initialize str
            colon = str.index(':')
            @host = str[0, colon]
            first_space = str.index(' ', colon)
            @port = str[colon + 1, first_space - colon - 1]
            @ip   = str[first_space + 1, str.index(' ', first_space + 1) - first_space - 1]

            first_bracket = str.index('[')
            @time = Time.parse(DateTime.strptime(str[first_bracket + 1, str.index(']') - first_bracket - 1], "%d/%b/%Y:%H:%M:%S %z").to_s).utc

            start_quote = str.index('"')
            end_quote   = str.index('"', start_quote + 1)
            request = str[start_quote + 1, end_quote - start_quote - 1].split(' ')
            @request_type     = request[0]
            @url              = request[1]
            @request_protocol = request[2]

            start_state = end_quote + 2
            end_state   = str.index(' ', start_state)
            @state = str[start_state, end_state - start_state]

            start_size = end_state + 1
            end_size   = str.index(' ', start_size)
            @size = str[start_size, end_size - start_size].to_i

            start_referer = str.index('"', end_size)
            end_referer   = str.index('"', start_referer + 1)
            @referer = str[start_referer + 1, end_referer - start_referer - 1]
            @referer = nil if @referer == '-'

            start_user_agent = str.index('"', end_referer + 1)
            end_user_agent   = str.index('"', start_user_agent + 1)
            @user_agent = str[start_user_agent + 1, end_user_agent - start_user_agent - 1]
        end

    end

end