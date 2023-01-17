<!-- Description : promosyon, detaylı ve aksiyon promosyon Sayfalarına Controller Eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/salesListPromsController.cfm',HEAD = 'Promosyon Ekle',DICTIONARY_ID = '31987' WHERE FULL_FUSEACTION = 'product.form_add_prom'
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/PromotionController.cfm',HEAD = 'Promosyon Ekle(Detaylı)',DICTIONARY_ID = '31987' WHERE FULL_FUSEACTION = 'product.form_add_detail_prom'  
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ActionPruchaseSaleController.cfm',HEAD = 'Aksiyon Ekle',DICTIONARY_ID = '49395' WHERE FULL_FUSEACTION = 'product.form_add_catalog_promotion'
</querytag>