<!-- Description :Çalışan Ek ödenek tablosuna sgk durumu ve bordro tipi kolonları eklendi
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE SALARYPARAM_PAY SET SSK_STATUE = 1 WHERE ISNULL(SSK_STATUE,0) = 0
    UPDATE SALARYPARAM_PAY SET STATUE_TYPE = 0 WHERE ISNULL(STATUE_TYPE,0) = 0
</querytag>