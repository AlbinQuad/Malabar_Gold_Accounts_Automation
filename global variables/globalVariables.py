import os
#------------------GLOBAL WAIT and RETRY FOR WEB ELEMENTS--------------------

GLOBAL_RETRY=                '5x'
GLOBAL_RETRY_INTERVAL=       '5s'
SHORT_WAIT=                  '2s'
MEDIUM_WAIT=                 '5s'
LONG_WAIT=                   '10s'

#-------------INPUT FILES LOCATIONS--------------
relpath = os.getcwd()
CONFIG_SHEET_LOC=    'input/config.xlsx'
INVOICE_DETAILS_SHEET_LOC=    'input/invoice_details.xlsx'
INVOICE_ATTACHMENT_FILE_PATH = relpath+'\\input\\test_info.pdf'