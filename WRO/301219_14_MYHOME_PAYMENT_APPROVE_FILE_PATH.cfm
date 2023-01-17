<!-- Description : Sadece Avans talep edenlerin listelenmesi için sayfa ikiye bölündü. Bu yüzden file path değiştirildi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
   UPDATE WRK_OBJECTS SET FILE_PATH = 'myhome/display/list_payment_request_approve.cfm' WHERE FULL_FUSEACTION = 'myhome.payment_request_approve'
 
</querytag>