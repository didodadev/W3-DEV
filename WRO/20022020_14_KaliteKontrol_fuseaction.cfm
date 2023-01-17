<!-- Description : Ürünler Kalite Kontrol fuseaction güncellendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET CONTROLLER_FILE_PATH = 'WBO/controller/ProductQualityControlController.cfm'  WHERE FULL_FUSEACTION = 'product.popup_product_quality'

    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'product.product_quality'  WHERE CONTROLLER_FILE_PATH = 'WBO/controller/ProductQualityControlController.cfm'
    
</querytag>