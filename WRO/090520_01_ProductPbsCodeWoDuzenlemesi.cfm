<!-- Description : Product Pbs Code WRO update...
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0,LICENCE=1,TYPE=0, CONTROLLER_FILE_PATH = 'WBO/controller/ProductPBSCodeController.cfm',DICTIONARY_ID=32834,HEAD='PBS Kodları',EVENT_ADD=1,EVENT_LIST=1,EVENT_UPD=1 WHERE FULL_FUSEACTION='product.list_pbs_code'        
</querytag>