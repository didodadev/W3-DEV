<!-- Description : Atama Terfi İşlemleri Print Şablonu

Developer: Mahmut Aslan

Company : Workcube

Destination: Main-->

<querytag>

    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 81 AND PRINT_MODULE_NAME = 'İşe Alım' AND PRINT_TYPE=256)

    BEGIN

        INSERT INTO

        SETUP_PRINT_FILES_CATS

        (

            PRINT_MODULE_ID,

            PRINT_NAME,

            PRINT_TYPE,

            PRINT_MODULE_NAME,

            PRINT_DICTIONARY_ID

        )

        VALUES

        (

            81,

            'Atama Terfi İşlemleri',

            256,

            'İşe Alım',

            47067

        )

    END

</querytag>