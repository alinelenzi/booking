# Settings ans Keywords
*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Keywords *** 
# no keywords só validações técnicas, a equipe q combina, não fica aqui as validações funcionais
Create Token
    [Arguments]    ${url}

    ${body}    Create Dictionary    username=admin    password=password123
    ${response}    POST    url=${url}/auth    json=${body}

    Status Should Be    200
    ${token}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${token}
    Log To Console    ${token}

Get Booking Id
    [Arguments]    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking?firstname=${firstname}&lastname=${lastname} 
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    ${booking_id}    Set Variable    ${response_body}[0][bookingid]
    Set Suite Variable    ${booking_id}

Get Ping
    [Arguments]    ${url}

    ${response}    GET    url=${url}/ping

    Status Should Be    201

Steps
    [Arguments]    ${url}
    Create Token    ${url}
    Get Ping    ${url}