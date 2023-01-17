<!-- Description : Tedaviler/İlaçlar/Uzuvlar Tablolarına yeni alanlar eklendi
Developer: Melek KOCABEY
Company : Workcube
Destination: main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_LIMB' AND COLUMN_NAME = 'MONEY_LIMIT')
        BEGIN
            ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_LIMB ADD 
            MONEY_LIMIT float null
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_LIMB' AND COLUMN_NAME = 'PAYMENT_RATE')
        BEGIN
            ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_LIMB ADD 
            PAYMENT_RATE float null
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION' AND COLUMN_NAME = 'PAYMENT_RATE')
        BEGIN
            ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION ADD 
            PAYMENT_RATE float null
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS' AND COLUMN_NAME = 'PAYMENT_RATE')
        BEGIN
            ALTER TABLE SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS ADD 
            PAYMENT_RATE float null
        END;
</querytag>