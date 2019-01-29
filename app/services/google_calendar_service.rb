require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class GoogleCalendarService

  def initialize
    @oob_uri = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    @application_name = 'Google Calendar API Ruby Quickstart'.freeze
    @credentials_path = 'credentials.json'.freeze
    @token_path = 'token.yaml'.freeze
    @scope = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
  end

  def authorize
    client_id = Google::Auth::ClientId.new("12681802719-p1hdil4j803bge7tguobpgcap91979jh.apps.googleusercontent.com", "ZYxljgYJy-GzpLgBzIlORzae")
    token_store = Google::Auth::Stores::FileTokenStore.new(file: @token_path)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, @scope, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    p credentials
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: @oob_uri)
      puts 'Open the following URL in the browser and enter the ' \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: @oob_uri
      )
    end
    credentials
  end

  def call
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = @application_name
    service.authorization = authorize
    calendar_id = '03v3jem57rb6jqdvg593s65gv4@group.calendar.google.com'
    response = service.list_events(calendar_id,
                                   max_results: 10,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: Time.now.iso8601)
    puts 'Upcoming events:'
    puts 'No upcoming events found' if response.items.empty?
    response.items
  end



end
