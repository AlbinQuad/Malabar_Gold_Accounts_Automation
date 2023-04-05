*** Settings ***
Library             RPA.Browser.Selenium
Library             Screenshot
Library             RPA.Windows
Library             ../libraries/updateStatus.py
Library             DateTime
Variables           ../global variables/globalVariables.py
Variables           ../page objects/page_selectors.py
Resource            excelOperations.robot


*** Keywords ***
Select Legal Entity
    #-------------------------  Select the legal entity -------------------------------
    ${cmpny_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_company_btn}
    IF    '${cmpny_btn_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_company_btn}

        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${el_company_field}    ${config}[Legal Entity]
        Sleep    ${SHORT_WAIT}

        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Press Keys    ${el_company_field}    ENTER
        Sleep    ${LONG_WAIT}
    END


Select Invoice Journal Menu
    

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_module_link}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_acctns_payable_lnk}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_acctns_payable_lnk}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_inv_journal_lnk}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_inv_journal_lnk}
    Sleep    ${LONG_WAIT}


Invoice Journal Creation Process
    #-----------  Invoice Journal Creation Process started --------------------------------------

    # ---------- Iterate the invoice details -------------------------------------------------------
        FOR    ${each_invoice}    IN    @{invoice_details} 

            ${invoice_data}=    Set Variable  ${each_invoice}    
            
            TRY
            
                Select Journal Name    ${invoice_data}[Journal No]

                Create Vendor Invoice Journal   ${invoice_data}

                Create Tax Information    ${invoice_data}

                Verify Tax Amount    ${invoice_data}

                Withholding Tax Process    ${invoice_data}

                Attach Invoice 

                Invoice Approval    ${invoice_data}

                Validate Invoice Journal Created    ${invoice_data}

                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_window_cls_btn}
                Sleep    ${MEDIUM_WAIT}

                # ${status_message}=    Validate Invoice Journal Created    ${invoice_data}

                # IF    '${status_message}' != 'Journal Completed'

                #     Capture Validation Message Screenshot

                # ELSE
                #     Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_window_cls_btn}
                #     Sleep    ${MEDIUM_WAIT}
                # END

            EXCEPT   AS    ${error_message}
                Log To Console    Error:${error_message}

                Write Status To Run Report    ${invoice_data}   FAIL   ${error_message}

                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_module_link}

                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_acctns_payable_lnk}
                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_acctns_payable_lnk}

                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_inv_journal_lnk}
                Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_inv_journal_lnk}

            ELSE
                Write Status To Run Report    ${invoice_data}   PASS   Journal Completed
            END
        END



Select Journal Name
    #----------------- Keyword containing the code for, 
    #    Select the new button.
    #    type the journal name from invoice_details excel.
    #    click save button. ------------------------------- #

    [Arguments]    ${journal_no}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_new_btn}
    ${new_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_new_btn}
    IF    '${new_btn_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}  Click Element    ${el_new_btn}
    END

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_jrnl_name}
    ${jrnl_name_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_jrnl_name}
    IF    '${jrnl_name_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${el_jrnl_name}    ${journal_no}
    END

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_save_btn}
    ${jrnl_name_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_save_btn}
    IF    '${jrnl_name_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_save_btn}
    END
    Sleep    ${MEDIUM_WAIT}

    # ${get_err_msg}    Save Button Status

    # IF    """${get_err_msg}""" != """${EMPTY}"""
    #     Fail  ${get_err_msg}  
    # END


Create Vendor Invoice Journal

    #----------------- Keyword containing the code for,
    #    Click on Line tab.
    #    Type the Account, Invoice_date, Invoice_number, TDS value,
    #    Desc, Credit amount, Offset account details from invoice_details excel.
    #    Click save button. ---------------------------------------------------#

    [Arguments]    ${each_invoice}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${lines_tab}
     
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text When Element Is Visible    ${account_id}    ${each_invoice}[Account] 
    
    ${inv_date}    Convert Date    ${each_invoice}[Invoice Date]    result_format=%#d/%#m/%Y

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text    ${invoice_date}     ${inv_date}
    
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text    ${invoice_id}    ${each_invoice}[Invoice Number]

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text    ${desription}     ${each_invoice}[Description]
     
    Scroll Element Into View    ${credit}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text      ${credit}    ${each_invoice}[Credit Amount] 
    Sleep    ${MEDIUM_WAIT}    
    
    Scroll Element Into View     ${offset_account}
    Sleep    ${SHORT_WAIT}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Clear Element Text    ${offset_input_field}

    ${offset_acc_details} =     Set Variable   ${each_invoice}[Main Account]-${each_invoice}[Legal Entity]-${each_invoice}[Cost Center]
    Log To Console     ${offset_acc_details}
     
    Sleep    ${SHORT_WAIT}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Input Text     ${offset_input_field}      ${offset_acc_details}

    # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${offset_account}
    # Sleep    ${SHORT_WAIT}

    # ${full_offset_value}=    Set Variable  ${each_invoice}[Main Account]-${each_invoice}[Legal Entity]-${each_invoice}[Cost Center]

    # Log    ${full_offset_value}

    # Click Element    ${main_account}
    # Sleep    ${SHORT_WAIT}
    # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Clear Element Text    ${main_account}
    # Sleep    ${SHORT_WAIT}
    # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${main_account}       ${each_invoice}[Main Account]
    
    # Sleep    ${SHORT_WAIT}
    # Click Element    ${legal_entity}
    # Sleep    ${SHORT_WAIT}
    # Press Keys  ${legal_entity}     CTRL+a   DELETE
    # Sleep    ${SHORT_WAIT}
    # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${legal_entity}       ${each_invoice}[Legal Entity]
 
    # Sleep    ${SHORT_WAIT}
    # Click Element    ${cost_center}
    # Sleep    ${SHORT_WAIT}
    # Press Keys  ${cost_center}     CTRL+a   DELETE
    # Sleep    ${SHORT_WAIT}
    # Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${cost_center}        ${each_invoice}[Cost Center]
    
    Sleep    ${SHORT_WAIT}
    Click Element    ${save_button}
    Sleep    ${SHORT_WAIT}

    ${get_err_msg}    Save Button Status

    IF    """${get_err_msg}""" != """${EMPTY}"""
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Click Element    ${el_delete_btn}
        Sleep    ${MEDIUM_WAIT}
        Fail  ${get_err_msg}  
    END
    

    
    
Create Tax Information

    #----------------- Keyword containing the code for,
    #    Click on Tax information tab.
    #    Select the Location, Sub location & HSN codes.
    #    Click OK button, then SAVE. ---------------------#

    [Arguments]    ${each_invoice}

    #--------------here checking that Tax document option is enabled or not--------------------------

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Wait Until Element Is Not Visible    ${tax_document_disabled}     
    # above command is to check with the selectors of the disabled option which is not existing
    
    ${tax_doc_enabled} =     Run Keyword And Return Status      ${tax_document_disabled}

    IF    ${tax_doc_enabled} == False
        Log To Console   enables_tax
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${tax_document}
    ELSE
        Log To Console  'Data is not saved properly'
    END
    
    #Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${company_loc}    Malabar Gold Palace Pvt Ltd

    Sleep    ${SHORT_WAIT}    
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${gst_hsn_code}    ${each_invoice}[HSN Code]
    
    Sleep    ${SHORT_WAIT} 
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Input Text    ${vendor_loc}    ${each_invoice}[Sub Location]

    Sleep    ${SHORT_WAIT} 
    Click Element    ${ok_button}

    Sleep    ${SHORT_WAIT} 
    ${get_err_msg}    Save Button Status

    IF    """${get_err_msg}""" != """${EMPTY}"""
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Click Element    ${cancel_btn}
        Sleep    ${SHORT_WAIT}
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Click Element    ${el_window_cls_btn}
        Sleep    ${SHORT_WAIT}
        Fail  ${get_err_msg}  
    END


Verify Tax Amount

    #----------------- Keyword containing the code for,
    #    Click on Tax Document tab.
    #    Getting the CGST & SGST value.
    #    Comparing these values with invoice_details CGST & SGST values.
    #    Click close button. ---------------------#

    [Arguments]    ${each_invoice}

    ${gst_match_status}=  Set Variable  ${EMPTY}
    # ${sgst_match_status}=  Set Variable  ${EMPTY}
    # ${igst_match_status}=  Set Variable  ${EMPTY}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_taxdocument_btn}
    ${taxdocument_tab_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_taxdocument_btn}

    IF    '${taxdocument_tab_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_taxdocument_btn}
    END
    Sleep    ${MEDIUM_WAIT}


    ${gst_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_gst_amount_field}

    IF    '${gst_present}'=='True'
        ${gst_amount_insite}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Value    ${el_gst_amount_field}

        ${gst_amt_insheet}=    Set Variable    ${each_invoice}[GST Amount]
        
        IF    '${gst_amount_insite}' == '${gst_amt_insheet}'
            ${gst_match_status} =    Set Variable    GST value matched.
        ELSE
            ${gst_match_status} =    Set Variable    GST value not matched.
        END      
    END

    # ${sgst_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_sgst_amount}

    # IF    '${sgst_present}'=='True'
    #     ${sgst_amount}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Text    ${el_sgst_amount}

    #     ${sgst_amt}=    Set Variable    ${each_invoice}[Sgst Amount]

    #     IF    '${sgst_amount}' == '${sgst_amt}'
    #         ${sgst_match_status} =    Set Variable    SGST value value matched.
    #     ELSE
    #         ${sgst_match_status} =    Set Variable    SGST value not matched.
    #     END 
    
    # END

    # ${igst_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_igst_amount}

    # IF    '${igst_present}'=='True'
    #     ${igst_amount}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Text    ${el_igst_amount}

    #     ${igst_amt}=    Set Variable    ${each_invoice}[Igst Amount]

    #     IF    '${igst_amount}' == '${igst_amt}'
    #         ${igst_match_status} =    Set Variable    IGST value matched.
    #     ELSE
    #         ${igst_match_status} =    Set Variable    IGST value not matched.
    #     END 

    # END

    Write Amount Validation Message To Run Report    ${each_invoice}     ${gst_match_status}    gst

    Sleep    ${MEDIUM_WAIT}

    ${close_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_close_btn}
    IF    '${close_btn_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_close_btn}
    END



Withholding Tax Process

    #----------------- Keyword containing the code for,
    #    Click on Withholding Tax tab.
    #    Comparing values with invoice_details values.
    #    Click close button. ---------------------#

    [Arguments]    ${each_invoice}

    ${percent_match_status}=  Set Variable  ${EMPTY}
    ${amtorigin_match_status}=  Set Variable  ${EMPTY}
    ${withholdtaxamnt_match_status}=  Set Variable  ${EMPTY}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_withhold_tax_tab}
    ${withhold_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_withhold_tax_tab}
    IF    '${withhold_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_withhold_tax_tab}
    END
    Sleep    ${MEDIUM_WAIT}

    ${percent_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_percent}
    
    IF    '${percent_present}'=='True'
        ${percent_amount}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Value    ${el_percent}

        ${percent}=    Set Variable    ${each_invoice}[Percent]

        IF    '${percent_amount}' == '${percent}'
            ${percent_match_status} =    Set Variable    Percent value matched.
        ELSE
            ${percent_match_status} =    Set Variable    Percent value not matched.
        END
    END

    Sleep    ${MEDIUM_WAIT}
    ${amtorigin_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_amntorigin}
    
    IF    '${amtorigin_present}'=='True'
        ${amntorigin_amount}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Value    ${el_amntorigin}
        
        ${amt_org}=    Set Variable    ${each_invoice}[Amount Origin]
        
        IF    '${amntorigin_amount}' == '${amt_org}'
            ${amtorigin_match_status} =    Set Variable    Amount Origin value matched.
        ELSE
            ${amtorigin_match_status} =    Set Variable    Amount Origin value not matched.
        END
    END

    Sleep    ${MEDIUM_WAIT}
    ${wthhldtax_amnt_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_wthhldtax_amnt}
    
    IF    '${wthhldtax_amnt_present}'=='True'
        ${wthhldtax_amount}=  Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    RPA.Browser.Selenium.Get Value    ${el_wthhldtax_amnt}
        
        ${wth_hldng_tax}=    Set Variable    ${each_invoice}[Withhold Tax Amount]

        IF    '${wthhldtax_amount}' == '${wth_hldng_tax}'
            ${withholdtaxamnt_match_status} =    Set Variable    Withhold Tax Amount matched.
        ELSE
            ${withholdtaxamnt_match_status} =    Set Variable    Withhold Tax Amount not matched.
        END
    END

    Sleep    ${MEDIUM_WAIT}
    ${close_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_close_btn}
    IF    '${close_btn_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_close_btn}
    END

    Write Amount Validation Message To Run Report    ${each_invoice}     ${percent_match_status}-${amtorigin_match_status}-${withholdtaxamnt_match_status}    tax
    
    Sleep    ${SHORT_WAIT}


Attach Invoice
    
    #----------------- Keyword containing the code for,
    #    Click on Attachments button.
    #    Click on the New-> File-> Browse.
    #    Select the given invoices.
    #    Click select-> save. ---------------------#

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${attachment_button}
    
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${new_btn}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${file_option}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${browse_button}

    #Choose File    ${browse_button}    ${attachment_file_path}

    Send Keys    id:1148      ${INVOICE_ATTACHMENT_FILE_PATH}    send_enter=${True}

    #Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${save_button}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${close_button}

    Log To Console    "Done"


Invoice Approval

    #----------------- Keyword containing the code for,
    #    Select the Approved by dropdown-> Select the name.
    #    Click select-> save. -----------------------------#

    [Arguments]    ${each_invoice}
    
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_inv_tab}
    ${inv_tab_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_inv_tab}
    IF    '${inv_tab_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_inv_tab}
    END
    Sleep    ${MEDIUM_WAIT}

    ${approvedby_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_approvedby_drpdwn}
    IF    '${approvedby_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_approvedby_drpdwn}
    END
    Sleep    ${SHORT_WAIT}

    ${approvar_nme_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_approvar_name}
    IF    '${approvar_nme_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_approvar_name}
    END
    Sleep    ${SHORT_WAIT}

    ${select_btn_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_select_btn}
    IF    '${select_btn_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_select_btn}
    END
    Sleep    ${MEDIUM_WAIT}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_save_btn_second}

    ${get_err_msg}    Save Button Status

    IF    """${get_err_msg}""" != """${EMPTY}"""
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}   Click Element    ${el_window_cls_btn}
        Fail  ${get_err_msg}  
    END
    Sleep    ${MEDIUM_WAIT}




Validate Invoice Journal Created
    #----------------- Keyword containing the code for,
    #    Select the Validate tab-> validate option.----------#

    [Arguments]    ${each_invoice}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}   ${GLOBAL_RETRY_INTERVAL}     Wait Until Element Is Visible        ${el_validate_tab}
    ${validate_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_validate_tab}
    IF    '${validate_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_validate_tab}
    END
    Sleep    ${MEDIUM_WAIT}

    ${validate_option_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_validate_option}
    IF    '${validate_option_present}'=='True'
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_validate_option}
    END

    Sleep    ${LONG_WAIT}
    # ${status_completed}=    Set Variable    ${EMPTY}
    ${status}   Run Keyword And Return Status    Wait Until Element Is Visible    ${el_msgdetails_lnk}

    IF    ${status}
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_msgdetails_lnk}
        Capture Validation Message Screenshot
        RETURN  FAIL
    ELSE
        RETURN  ${True}
    END

    # ${validate_option_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_msgdetails_lnk}

    # IF    '${validate_option_present}'=='True'
    #     Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_msgdetails_lnk}
    #     Sleep    ${MEDIUM_WAIT}
    # ELSE
    #     ${status_completed}=    Set Variable    Journal Completed
    # END
    # Return From Keyword    ${status_completed}
    


Capture Validation Message Screenshot
    #-------------------------- Capture validation message screenshot -------------------------------

    ${msg_details_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_msg_details}
    IF    '${msg_details_present}'=='True'
        
        Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_msg_details}
        Sleep    ${MEDIUM_WAIT}
        Take Screenshot    images/validation_message.jpg    80%
    END
    Sleep    ${MEDIUM_WAIT}
    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_window_cls_btn}


Logout Portal
    #----------------------------- Logout ----------------------------------------------------------
    
    ${msg_details_present}=  RPA.Browser.Selenium.Is Element Visible    ${el_user_button}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_user_button}

    Wait Until Keyword Succeeds    ${GLOBAL_RETRY}    ${GLOBAL_RETRY_INTERVAL}    Click Element    ${el_signout_link}

    Sleep    ${SHORT_WAIT}

    Close All Browsers


    
    
    




    
    
    

    











    














