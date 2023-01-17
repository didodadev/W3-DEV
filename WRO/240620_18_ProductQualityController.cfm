<!-- Description : Kalite Kontrol fuseaction ve controller güncellendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'product.product_quality'  WHERE FULL_FUSEACTION = 'product.popup_product_quality'
    
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ProductQualityControlController.cfm'  WHERE FULL_FUSEACTION = 'product.product_quality'
</querytag>