<!-- Description : Çalışan detayından özlük belgeleri sekmesine tıkladığında çalışanın Organizasyon Planlama yetkisi yoksa özlük belgelerine erişemiyordu bu yüzden dolayı modulü değiştirildi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET MODUL = 'çalışan bilgileri' WHERE FULL_FUSEACTION = 'hr.popup_form_upd_emp_employment_assets'

    UPDATE WRK_OBJECTS SET MODUL_SHORT_NAME = 'Employee Information' WHERE FULL_FUSEACTION = 'hr.popup_form_upd_emp_employment_assets'
</querytag>