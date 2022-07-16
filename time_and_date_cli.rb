require 'net/http'
require 'net/https'
require'json'

def timedate_api_request
    print "Please enter the wanted location (City, City + Country / State, Coordinates): "
    location = gets.chomp()
    uri = URI('https://timezone.abstractapi.com/v1/current_time/?api_key=ff34cc35c0c644c6b1662706459abf61&location=' << location)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request =  Net::HTTP::Get.new(uri)

    response = http.request(request)

    response_body = "#{ response.body }"
    parsed_response_body = JSON.parse(response_body)
    # Check if the given location exists. If not, halts further execution of the code.
    if not parsed_response_body['requested_location'] then
        puts "Error: Location entered does not exist."
        puts
        print "Press enter to exit..."
        gets
        abort

    end

    system "cls"

    # Here's all of the stuff you see after entering in a location

    puts "Showing information for " << location << "."
    puts
    puts "                      Basic info:                      "
    puts "#######################################################"
    puts
    puts "Date & Time :: " << parsed_response_body['datetime']
    puts "Location :: " << parsed_response_body['requested_location'] << " (Timezone Location: " << parsed_response_body['timezone_location'] << ")"
    2.times{puts}
    puts "                     Advanced info:                    "
    puts "#######################################################"
    puts
    puts "Lat. & Long. :: " << "Latitude: " << parsed_response_body['latitude'].to_s << " | Longitude: " << parsed_response_body['longitude'].to_s
    puts "Is in daylight saving? :: " << if parsed_response_body['is_dst'] == true then "Yes" else "No" end
    puts "Timezone :: " << parsed_response_body['timezone_name'] << ' | Abbreviation: ' << parsed_response_body['timezone_abbreviation']
    puts "GMT Offset :: " << if parsed_response_body['gmt_offset'] >= 0 then "GMT+" else "GMT" end << parsed_response_body['gmt_offset'].to_s << ":00"
    2.times{puts}
    
    print "Press enter to exit..."
    gets
    abort

rescue StandardError => error

    puts "Error (#{ error.message })"

end

timedate_api_request()