<!-- Description : Lab İşlemleri Print ŞAblonu

Developer: Dilek Özdemir

Company : Workcube

Destination: Main-->

<querytag>

    IF NOT EXISTS(SELECT PRINT_MODULE_ID FROM [SETUP_PRINT_FILES_CATS] WHERE PRINT_MODULE_ID = 15 AND PRINT_MODULE_NAME = 'Laboratuvar İşlemleri' AND PRINT_TYPE=376)

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

            61,

            'Laboratuvar İşlemleri',

            376,

            'Kalite Kontrol- Garanti',

            47136

        )

    END

</querytag>