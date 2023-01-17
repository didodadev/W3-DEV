<!-- Description :  Kesintiler tanımına Net Ücretse Brüt Olarak Kesilsin seçeneği eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_PAYMENT_INTERRUPTION' AND COLUMN_NAME='IS_NET_TO_GROSS')
    BEGIN
        ALTER TABLE SETUP_PAYMENT_INTERRUPTION ADD IS_NET_TO_GROSS bit NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SALARYPARAM_GET' AND COLUMN_NAME='IS_NET_TO_GROSS')
    BEGIN
        ALTER TABLE SALARYPARAM_GET ADD IS_NET_TO_GROSS bit NULL
    END;    
</querytag>