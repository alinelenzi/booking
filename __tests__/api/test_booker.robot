# *** Variables *** ---> resources/variables.py
# *** Settings *** ---> resources/common.resource
# *** Test Cases *** ---> resources/continuam no arquivo .robot
# *** Keywords *** ---> resources/common.resource

# Casos de Teste

*** Settings ***
Library    RequestsLibrary
Resource    ../../resources/common.resource
Variables    ../../resources/variables.py
Suite Setup    Steps    ${url}


*** Test Cases ***
Create Booking
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())

    ${response}    POST    url=${url}/booking    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]    ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]    ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[booking][additionalneeds]    ${additionalneeds}

Get Booking Id
    Get Booking Id    ${url}    ${firstname }   ${lastname}
    ${response}    GET    url=${url}/booking/${booking_id}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}


    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${totalprice}
    Should Be Equal    ${response_body}[depositpaid]    ${depositpaid}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}

Update Booking Id
    Get Booking Id    ${url}    ${firstname}    ${lastname}
    ${headers}    Create Dictionary    Content-Type=${content_type}    Cookie=token=${token}
    ${body}    Create Dictionary    firstname=${firstname}    lastname=${lastname}    totalprice=120    depositpaid=${depositpaid}    bookingdates=${bookingdates}    adadditionalneeds=${additionalneeds}

    ${response}    PUT    url=${url}/booking/${booking_id}    json=${body}    headers=${headers}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${{int(120)}}
    Should Be Equal    ${response_body}[depositpaid]    ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    ${additionalneeds}

Partial Update Booking
    Get Booking Id    ${url}   ${firstname}    ${lastname}
    ${headers}   Create Dictionary    Cookie=token=${token}    Content-Type=${content_type}
    ${body}    Create Dictionary    additionalneeds=Dinner

    ${response}     PATCH    url=${url}/booking/${booking_id}    headers=${headers}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[firstname]    ${firstname}
    Should Be Equal    ${response_body}[lastname]    ${lastname}
    Should Be Equal    ${response_body}[totalprice]    ${{int(120)}}
    Should Be Equal    ${response_body}[depositpaid]    ${{bool(True)}}
    Should Be Equal    ${response_body}[bookingdates][checkin]    ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[bookingdates][checkout]    ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[additionalneeds]    Dinner


Delete Booking
    Get Booking Id    ${url}   ${firstname}    ${lastname}
    ${headers}   Create Dictionary    Cookie=token=${token}    Content-Type=${content_type}
    
    ${response}    DELETE    url=${url}/booking/${booking_id}    headers=${headers}

    Status Should Be    201


