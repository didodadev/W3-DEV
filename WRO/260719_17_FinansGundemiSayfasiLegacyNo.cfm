<!-- Description : Legacy Özelliği Kaldırıldı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main  -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_LEGACY = 0 WHERE FULL_FUSEACTION = 'finance.list_finance_agenda'
</querytag>
