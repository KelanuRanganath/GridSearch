clear
clc

headers = generateHeaders(airyIP);
B = replace(split(A(1),"&quot;")," ","+")
C = strcat("classroom=",B(end-1))


%Sends HTTP request and returns the response data
function response = generateResponse(requestType,airyIP,headers)
    %Generate the method and URI needed for HTTP request
    [method, uri] = generateMethodUri(requestType,airyIP);
    %Builds HTTP request
    request = matlab.net.http.RequestMessage(method,headers);
    %Sends HTTP request
    response = send(request,uri);
    response = response.Body.Data;
end

%Generates the HTTP method and request URL with query parameter
function [method,uri] = generateMethodUri(requestType,airyIP)
    %Generates query string parameter
    key = ['x=', char(compose("%0.16f",rand()))];
    
    %Builds method header
    method = matlab.net.http.RequestLine;
    method.Method = 'GET';
    method.ProtocolVersion = 'HTTP/1.1';
    
    %This section generates the URL depending on which file is being
    %requested
    uri = ['http://',airyIP];
    
    if(requestType == 'S')
        param = ['/getStatus.iwx?',key];
        method.RequestTarget = param;
        uri = [uri,param];
    elseif(requestType == 'C')
        param = ['/getCounts.iws?cmd=GetCounts&',key];
        method.RequestTarget = param;
        uri = [uri,param];
    end
        
end

function url = generateClassroom(term, building, room)
    
    url = "https://sa.ucla.edu/ro/Public/SOC/Results/ClassroomDetail?",term,"&",classroom;
end

%Generates the HTTP headers for the response, this function only needs to
%be evaluated once since the headers, except for the method, don't change
function header = generateHeaders(url)
    %HTTP Headers
    %User Agent is included in the Airy source code but isn't necessary
    %Host Header
    host = matlab.net.http.field.HostField;
    host.Value = airyIP;

    %Connection Header
    connection = matlab.net.http.field.ConnectionField;
    connection.Value = 'keep-alive';

    %Language Header
    lang = matlab.net.http.field.GenericField;
    lang.Value = 'en-US,en;q=0.9';
    lang.Name = 'Accept-Language';

    %Encoding Header
    encoding = matlab.net.http.field.GenericField;
    encoding.Name = 'Accept-Encoding';
    encoding.Value = 'gzip, deflate';

    %Referer Header
    referer = matlab.net.http.field.GenericField;
    referer.Name = 'Referer';
    referer.Value = ['https://sa.ucla.edu/RO/Public/SOC/Search/ClassroomGridSearch'];

    %File requestType Header
    accept = matlab.net.http.field.AcceptField;
    accept.Value = matlab.net.http.MediaType('*/*');

    %Combines Headers
    header = [host, connection, accept, referer, encoding, lang];
end
