require 'rubygems'
require File.dirname(__FILE__) + "/../lib/apache_logger"
require 'mongo'
require 'bson'
require 'uri'

# Set up mongo connection
db          = Mongo::Connection.new.db('apache_log')
requests    = db.collection('requests')
user_agents = db.collection('user_agents')

agent_mapping = {}

user_agents.find().each do |agent|
    agent_mapping[agent['name']] = agent['_id']
end

while line = $stdin.readline
    parser = ApacheLogger::Parser.new line

    referer_url    = parser.referer
    referer_domain = nil
    unless referer_url.nil?
        referer_domain = URI.parse(referer_url).host
    end

    unless agent_mapping.key?(parser.user_agent)
        agent_id = BSON::ObjectId.new
        user_agents.insert({
            '_id' => agent_id,
            'name' => parser.user_agent
        })
        agent_mapping[parser.user_agent] = agent_id
    end

    doc = {
        'time' => parser.time,
        'host' => parser.host,
        'port' => parser.port,
        'request' => {
            'type' => parser.request_type,
            'protocol' => parser.request_protocol,
            'url' => parser.url,
            'size' => parser.size,
            'state' => parser.state
        },
        'referer' => {
            'full_url' => referer_url,
            'domain' => referer_domain
        },
        'ip' => parser.ip,
        'agent' => agent_mapping[parser.user_agent]
    }

    requests.insert(doc)
end