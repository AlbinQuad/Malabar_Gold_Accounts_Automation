*** Settings ***
Documentation       Template robot main suite.     # ROBOT REUSABLES

Library             Collections
Library             RPA.Excel.Files
Library             ../libraries/updateStatus.py
Library             RPA.Browser.Selenium
Variables           ../global variables/globalVariables.py
Variables           ../page objects/page_selectors.py
Library             RPA.Tables

*** Variables ***
&{config_datas}


*** Keywords ***
Reading Configdata Sheet
    #-------------------- READING CONFIG SHEET -----------------------------
    Open Workbook      ${CONFIG_SHEET_LOC}
    ${data}  Read Worksheet As Table      Config_Sheet      ${True}
    Close Workbook
    FOR    ${row}    IN    @{data}       
        Set To Dictionary    ${config_datas}      ${row['Name']}      ${row['Value']}
    END

    Set Global Variable    ${config}    ${config_datas}
    #Log To Console    ${config}


    #----------------------- READING INVOICE_DETAILS SHEET -----------------------------
    Open Workbook      ${INVOICE_DETAILS_SHEET_LOC}
    ${inv_data}  Read Worksheet As Table      Invoice_Sheet      ${True}
    
    Close Workbook
    Set Global Variable    ${invoice_details}   ${inv_data}


*** Keywords ***
Save Button Status
    ${errmsg_popup_visible}=  RPA.Browser.Selenium.Is Element Visible    ${el_save_err_msg}

    ${get_err_msg}=    Set Variable  ${EMPTY}

    IF   ${errmsg_popup_visible}

        #${get_err_msg}=    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Text    ${el_save_err_msg}

        ${errmsg_close_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_errmsg_close_btn}

        IF    '${errmsg_close_btn_present}'=='True'

            Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_errmsg_close_btn}
            Sleep    ${SHORT_WAIT}

            ${statusbar_present}=  RPA.Browser.Selenium.Is Element Enabled    ${el_statusbar}

            IF    '${statusbar_present}'=='True'

               ${get_err_msg}=    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Text    ${el_statusbar} 

            END

            # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Press Keys    ${offset_account}     CTRL+a   DELETE
            # Sleep    ${SHORT_WAIT}
            # ${window_cls_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_window_cls_btn}
            # IF    '${window_cls_btn_present}'=='True'
            #     Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_window_cls_btn}
            # END
            
            Sleep    ${SHORT_WAIT}

        END

    END

    Return From Keyword    ${get_err_msg}


Write Status To Run Report
    #----------------  Code to write status to run report ----------------------------------
    [Arguments]    ${each_invoice}    ${status}  ${message}
    update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Run Status     ${status}
    update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Remark    ${message}
    # ${length}=    Get Length    ${error_message}
    # IF    ${length} > 0
    #     update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Run Status     FAIL
    #     update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Remark    ${error_message}
    # ELSE
    #     update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Run Status     PASS
    #     update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Remark    Journal Created Successfully.
    # END

Write Amount Validation Message To Run Report
    [Arguments]    ${each_invoice}    ${message}    ${category}

        ${excel_column_heading} =    Set Variable    ${EMPTY}
        
        IF    '${category}' == 'gst'
            ${excel_column_heading} =    Set Variable    GST Validation Message
        END
        IF    '${category}' == 'tax'
            ${excel_column_heading} =    Set Variable    Withhold Tax Validation Message
        END
        update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Run Status     PASS
        update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    Remark    Journal Completed.
        update_excel_value    ${INVOICE_DETAILS_SHEET_LOC}    Invoice Number    ${each_invoice}[Invoice Number]    ${excel_column_heading}    ${message}

    