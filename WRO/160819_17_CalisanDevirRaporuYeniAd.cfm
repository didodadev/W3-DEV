<!-- Description : Çalışan Devir Oranı Raporu sayfa ismi Çalışan Devir Oranı (Turnover) Raporu olarak değiştirildi ve sözlüğe eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Çalışan Devir Oranı (Turnover) Raporu', ITEM_TR='Çalışan Devir Oranı (Turnover) Raporu', ITEM_ENG='Employee Turnover Rate Report' WHERE DICTIONARY_ID = 59148
    UPDATE WRK_OBJECTS SET HEAD = 'Çalışan Devir Oranı (Turnover) Raporu', DICTIONARY_ID = 59148 WHERE FULL_FUSEACTION='report.employee_turnover_report'
</querytag>