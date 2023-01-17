<!-- Description : İthal Mal Girişleri WO düzenlemesi.
Developer: Melek Kocabey
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/FTImportGoodsInController.cfm',DICTIONARY_ID = 29588,HEAD='İthal Mal Girişi(Güncelle)',IS_MENU=1 WHERE FULL_FUSEACTION = 'stock.upd_stock_in_from_customs'  
</querytag>