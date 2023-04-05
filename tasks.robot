*** Settings ***
Documentation       Template robot main suite.

Library             Collections
Resource            login.robot
Resource            invoiceJournalCreation.robot
Resource            excelOperations.robot
Suite Setup         Reading Configdata Sheet
Suite Teardown      Logout Portal



*** Tasks ***
Invoice Journal Creation
    
    Wait Until Keyword Succeeds    3x    5s    Launch & Login m365 portal

    Select Legal Entity

    Select Invoice Journal Menu

    Invoice Journal Creation Process


