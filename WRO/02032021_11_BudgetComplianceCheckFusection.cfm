<!-- Description : Bütçe Uygunluk Kontrol box'ı fusection güncelleme 
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET FULL_FUSEACTION = 'objects.budget_compliance_check' WHERE FULL_FUSEACTION = 'budget.budget_compliance_check'  
</querytag>