#----------------------------------------- Ui elements in Login page----------------------------------------

el_username = '//div[@data-test-id="v_mafna@malabargroup.com"]'
el_username_field = '//input[@type="email" and @name="loginfmt"]'
el_next_btn = '//input[@value="Next"]'
el_password = '//input[@name="passwd"]'
el_signin_btn = '//input[@type="submit" and @data-report-value="Submit"]'
el_yes_btn = '//input[@value="Yes"]'

#----------------------------------------------------------------------------------------------------------

#-------------------------------------- Ui elements of menu -----------------------------------------------

el_company_btn = '//button[@id="CompanyButton"]'
el_company_field = '//input[@name="DataArea_id"]'
el_module_link = '//div[@aria-label="Modules" and @id="navPaneModuleID"]'
el_acctns_payable_lnk = '//a[@data-dyn-title="Accounts payable" and contains(text(),"Accounts payable")]'
el_inv_journal_lnk = '//a[@data-dyn-title="Invoice journal" and contains(text(),"Invoice journal")]'

#----------------------------------------------------------------------------------------------------------

#------------------------------------- Ui elements in Invoice Journal creation page -----------------------

el_new_btn = '//button[@command="New" and @name="SystemDefinedNewButton"]'
el_jrnl_name = '(//input[@aria-label="Name"])[1]'
el_save_btn = '//button[@name="SystemDefinedSaveButton"]'

#---------------------------------------------------------------------------------------------------------

#--------Ui elements in Vendor Invoice Journal creation page (After clicking the Line tab)----------------

lines_tab = '//span[text()="Lines"]'
account_id = '//input[@aria-label="Account"]'
invoice_date = '//input[@aria-label="Invoice date"]'
invoice_id = '//input[@aria-label="Invoice"]'
desription = '//input[@aria-label="Invoice"]//following::input[1]'
credit = '//input[@aria-label="Credit"]'
offset_account = '//input[@aria-label="Offset account"]//following::div[@title="Open"][1]'
main_account = '//div[@title="MainAccount"]//following::input[1]'
legal_entity = '//div[@title="LegalEntity"]//following::input[1]'
cost_center = '//div[@title="CostCenter"]//following::input[1]'
save_button = '(//button[@name="SystemDefinedSaveButton"])[2]'
blocking_message = '//*[@id="blockingMessage"]'
offset_input_field = '//input[@aria-label="Offset account"]'

#---------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Tax information page ---------------------------------

tax_document_disabled = '//*[@name="TaxDocumentLauncher" and @disabled="disabled"]'
tax_document = '//span[text()="Tax information"]'
company_loc = '//input[@name="CompanyLocation_Description"]'
gst_hsn_code = '//input[@name="HSNCodeTable_IN_Code"]'
vendor_loc = '//input[@name="VendorLocation_Description"]'
ok_button = '//span[text()="OK"]'
cancel_btn = '//button[@name="Cancel"]'

#---------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Tax documents page ---------------------------------

el_taxdocument_btn = '//button[@name="TaxDocumentLauncher"]'
el_cgst_amount = '(//input[@aria-label="Tax Amount"])[1]'
el_sgst_amount = '(//input[@aria-label="Tax Amount"])[2]'
el_igst_amount = '//input[@aria-label="Rate"]'
el_close_btn = '(//button[@name="SystemDefinedCloseButton"])[3]'
el_gst_amount_field = '(//span[contains(text(),"Total")]//following::input[@dir="ltr"])[2]'

#--------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Withhold Tax page -----------------------------------

el_withhold_tax_tab = '//button[@name="TaxWithholdTrans_IN"]'
el_percent = '//input[@aria-label="Percent"]'
el_amntorigin = '(//input[@aria-label="Amount origin"])[1]'
el_wthhldtax_amnt = '//input[@aria-label="Withholding tax amount"]'

#--------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Attachment page ------------------------------------

attachment_button = '(//button[@name="SystemDefinedAttachButton"])[2]'
new_btn = '(//span[@class="button-commandRing New-symbol"])[3]'
file_option = '//button[@name="DocumentType_File"]'
browse_button = '//button[@name="UploadControlBrowseButton"]'
#close_button = '(//span[@class="button-commandRing Cancel-symbol"])[3]'
close_button = '(//button[@aria-label="Close" and @name="SystemDefinedCloseButton"])[3]'

#--------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Invoice Approval page -------------------------------

el_inv_tab = '//li[@data-dyn-mappedtab="InvoiceTab" and @title="Invoice"]'
el_approvedby_drpdwn = '(//input[@name="Approve_Approver_PersonnelNumber"]//following::div[@class="lookupButton"])[1]'
el_approvar_name = '//input[@aria-label="Name" and @title="Arundas J"]'
el_select_btn = '//button//*[contains(text(),"Select")]'
el_save_btn_second = '(//button[@name="SystemDefinedSaveButton"])[2]'
#--------------------------------------------------------------------------------------------------------

#----------------------------------- Ui elements in Validate Invoice Journal page -----------------------

el_validate_tab = '//button[@name="buttonCheckJournal"]'
el_validate_option = '//button[@name="CheckJournal"]'
el_msgdetails_lnk = '//span[@data-dyn-qtip-title="Message details"]'
el_msg_details = '//aside[@id="asidePane"]'

#--------------------------------------------------------------------------------------------------------


#el_save_err_msg = '//div[@data-dyn-controlname="TextGroup"]//*[contains(text(),"Some of the information that you entered is not valid. You must enter valid information before you can continue.")]'
el_errmsg_close_btn = '//button[@data-dyn-controlname="Close"]'
el_window_cls_btn = '(//button[@data-dyn-controlname="SystemDefinedCloseButton"])[2]'
el_save_err_msg = '//*[@class="titleField staticText layout-ignoreArrange"]'
el_statusbar = '(//span[@class="messageBar-message"])[2]'
el_user_button = '//button[@id="UserBtn"]'
el_signout_link = '//a[@data-dyn-controlname="SignOut"]'
el_delete_btn = '//button[@name="Delete"]'



