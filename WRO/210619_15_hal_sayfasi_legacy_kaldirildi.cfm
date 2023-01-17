<!-- Description : hal irsaliye ve hal faturası Legacy Özelliği Kaldırıldı.
Developer: Murat Can Aygüneş
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'invoice.marketplace_commands'
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'stock.add_marketplace_ship'
</querytag>