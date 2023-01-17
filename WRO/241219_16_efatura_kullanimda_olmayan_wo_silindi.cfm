<!-- Description : E-fatura kullanımda olmayan WO silindi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'invoice.popup_dsp_efatura_detail'
</querytag>