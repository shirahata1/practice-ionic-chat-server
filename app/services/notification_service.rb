require 'net/http'
require 'uri'
require 'json'

class NotificationService
  PARTITION = 1000

  class << self
    def notify!(users: nil, body: nil)
      new.notify!(users: users, body: body)
    end
  end

  def notify!(users: nil, body: nil)
    (0..Float::INFINITY).each do |i|
      offset = 1000 * i
      tokens = users.limit(PARTITION).offset(offset).pluck(:notification_token)
      break if tokens.blank?
      tokens.compact!
      params = build_params(tokens, body)
      request(params)
    end
  end

  private

  def build_params(tokens, body)
    {
      registration_ids: tokens,
      priority: :high,
      notification: {
        body: body
      }
    }
  end

  def request(params)
    uri = URI.parse("https://fcm.googleapis.com/fcm/send")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "key=#{ENV["FCM_ACCESS_TOKEN"]}"
    req.body = params.to_json

    Rails.logger.debug("---------------------------- FCM request ----------------------------")
    Rails.logger.debug("body: #{req.body}")
    Rails.logger.debug("---------------------------- FCM request ----------------------------")

    res = https.request(req)

    Rails.logger.debug("---------------------------- FCM response ----------------------------")
    Rails.logger.debug("status code: #{res.code}")
    Rails.logger.debug("header: #{res.header.inspect}")
    Rails.logger.debug("body: #{res.body}")
    Rails.logger.debug("---------------------------- FCM response ----------------------------")

    # raise unless http status = 2xx
    res.value

    res
  end
end
