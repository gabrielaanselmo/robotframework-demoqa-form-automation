*** Settings ***
Library          Browser
Library          FakerLibrary
Test Timeout     30s
Suite Teardown   Close Browser

*** Variables ***
# Configuration Variables
${BROWSER_NAME}      chromium
${FORM_URL}          https://demoqa.com/automation-practice-form

# Field Locators
${NAME_INPUT}        xpath=//input[@id='firstName']
${LAST_NAME_INPUT}   xpath=//input[@id='lastName']
${EMAIL_INPUT}       xpath=//input[@id='userEmail']
${PHONE_INPUT}       xpath=//input[@id='userNumber']
${SUBMIT_BUTTON}     xpath=//button[@id='submit']

# Gender Button Locators
${GENDER_MALE}       xpath=//label[@for='gender-radio-1']
${GENDER_FEMALE}     xpath=//label[@for='gender-radio-2']
${GENDER_OTHER}      xpath=//label[@for='gender-radio-3']
@{GENDER_OPTIONS}    ${GENDER_MALE}    ${GENDER_FEMALE}    ${GENDER_OTHER}

# Date Picker Locators
${DATE_OF_BIRTH_INPUT}    id=dateOfBirthInput
${MONTH_SELECT}           css=.react-datepicker__month-select
${YEAR_SELECT}            css=.react-datepicker__year-select

# Test Data Variables (to store generated data)
${FIRST_NAME} =      ${EMPTY}
${LAST_NAME} =       ${EMPTY}
${EMAIL_DATA} =      ${EMPTY}
${GENDER_CHOSEN} =   ${EMPTY}
${PHONE_DATA} =      ${EMPTY}
${DATE_OF_BIRTH} =   ${EMPTY}


*** Test Cases ***
Scenario: Fill Mandatory Fields and Submit Form
    [Documentation]    Tests filling all mandatory fields and verifies the success modal.
    Given I am on the "Automation Practice Form" page
    When I fill mandatory fields with valid data
    And I click the "Submit" button
    #Then a "Thanks for submitting the form" modal should be displayed


*** Keywords ***

Given I am on the "Automation Practice Form" page
    New Browser      browser=${BROWSER_NAME}    headless=False
    New Page         url=${FORM_URL}
    Set Viewport Size    1920    1080

When I fill mandatory fields with valid data

    ${random_first_name} =    FakerLibrary.First Name
    ${random_last_name} =     FakerLibrary.Last Name
    ${random_email} =        FakerLibrary.Email
    ${random_phone_number} =  FakerLibrary.Phone Number
    
    Set Test Variable   ${FIRST_NAME}   ${random_first_name}
    Fill Text           ${NAME_INPUT}         ${FIRST_NAME}
    
    Set Test Variable    ${LAST_NAME}   ${random_last_name}
    Fill Text       ${LAST_NAME_INPUT}   ${LAST_NAME}
    
    Set Test Variable   ${EMAIL_DATA}  ${random_email}
    Fill Text       ${EMAIL_INPUT}    ${EMAIL_DATA}

    ${gender_locator} =       Evaluate     random.choice(${GENDER_OPTIONS})     random
    Set Test Variable     ${GENDER_CHOSEN}  ${gender_locator}
    Click                 ${GENDER_CHOSEN}
    
    Set Test Variable     ${PHONE_DATA}     ${random_phone_number}
    Fill Text             ${PHONE_INPUT}        ${PHONE_DATA}

    ${BIRTH_YEAR_NUM} =     Evaluate    random.randint(1980, 2000)    random
    ${BIRTH_MONTH_NUM} =    Evaluate    random.randint(1, 12)    random
    ${BIRTH_DAY} =          Evaluate    random.randint(1, 28)    random
    
    ${MONTH_INDEX_NUM} =         Evaluate    ${BIRTH_MONTH_NUM} - 1
    ${BIRTH_YEAR} =         Convert To String     ${BIRTH_YEAR_NUM}
    ${MONTH_INDEX} =        Convert To String     ${MONTH_INDEX_NUM}
    
    Click                 ${DATE_OF_BIRTH_INPUT}
    
    Select Options By   ${YEAR_SELECT}     value     ${BIRTH_YEAR}
    Select Options By   ${MONTH_SELECT}     value     ${MONTH_INDEX}
    
    ${DAY_LOCATOR} =          Set Variable       xpath=//div[contains(@class, 'react-datepicker__day') and not(contains(@class, 'outside-month')) and text()='${BIRTH_DAY}']
    Click                   ${DAY_LOCATOR}
    
    ${MONTH_NAME} =          Evaluate    time.strftime('%b', time.strptime(str(${BIRTH_MONTH_NUM}), '%m'))    time
    ${formatted_date} =      Set Variable       ${BIRTH_DAY} ${MONTH_NAME} ${BIRTH_YEAR}
    Set Test Variable       ${DATE_OF_BIRTH}  ${formatted_date}
    
    Log To Console    Date of Birth Selected: ${DATE_OF_BIRTH}


And I click the "Submit" button
    Click                 ${SUBMIT_BUTTON}

#Then a "Thanks for submitting the form" modal should be displayed