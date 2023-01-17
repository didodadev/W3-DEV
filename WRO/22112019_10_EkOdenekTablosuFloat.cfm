<!-- Description : Ek Ödenek Tablosuoran kolonları float'a çevirildi. 
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    ALTER TABLE SETUP_PAYMENT_INTERRUPTION ALTER COLUMN SSK_EXEMPTION_RATE float
    ALTER TABLE SETUP_PAYMENT_INTERRUPTION ALTER COLUMN TAX_EXEMPTION_RATE float 
    ALTER TABLE SETUP_PAYMENT_INTERRUPTION ALTER COLUMN TAX_EXEMPTION_VALUE float
</querytag>