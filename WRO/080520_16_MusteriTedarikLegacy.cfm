<!-- Description : Müşteri Tedarikçi Stok Kodu Legacy Özelliği Kaldırıldı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION='product.add_company_stock_code'        
</querytag>