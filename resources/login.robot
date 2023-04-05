*** Settings ***
Library             Collections
Library             DateTime
Library             String
Library             RPA.Browser.Selenium    auto_close=${False}
Variables           ../global variables/globalVariables.py
Variables           ../page objects/page_selectors.py
Resource            excelOperations.robot

*** Keywords ***
Launch & Login m365 portal
    #------------- launch m365 portal in the Chrome browser"--------
    
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}       Open Available Browser    ${config}[Portal Url]    browser_selection=${config}[Browser]
    Maximize Browser Window
    Sleep  ${SHORT_WAIT}

    # ----------- Login m365 portal --------------------------------

    ${login_username_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_username}
        IF    '${login_username_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_username}
        END

    ${login_username_field_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_username_field}
        IF    '${login_username_field_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${el_username_field}    ${config}[User Name]
        END

    ${next_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_next_btn}
        IF    '${next_btn_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_next_btn}
        END

    Sleep    ${SHORT_WAIT}
    ${login_pwd_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_password}
        IF    '${login_pwd_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Input Text    ${el_password}    ${config}[Password]    
        END

    ${signin_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_signin_btn}
        IF    '${signin_btn_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_signin_btn}
        END

    Sleep    ${SHORT_WAIT}
    ${yes_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_yes_btn}
        IF    '${yes_btn_present}'=='True'
            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_yes_btn}
        END
    

    
    