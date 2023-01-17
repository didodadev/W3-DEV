<cfset attributes.class_attendance_id = attributes.id>
<cfinclude template="../query/get_class_attendance.cfm">
<cfinclude template="../query/get_class_attendance_dt.cfm">
<cfset attributes.class_id = GET_CLASS_ATTENDANCE.class_id>
<cfset start_date = date_add('h', session.ep.time_zone, GET_CLASS_ATTENDANCE.start_date)>
<cfset finish_date = date_add('h', session.ep.time_zone, GET_CLASS_ATTENDANCE.finish_date)>
<cfquery name="get_emp_att" datasource="#dsn#">
SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<br/>
<cfinclude template="../display/view_class.cfm">
<cfform name="upd_class_attendance" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_attendance">
  <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
  <input type="hidden" name="CLASS_ATTENDANCE_ID" id="CLASS_ATTENDANCE_ID" value="<cfoutput>#GET_CLASS_ATTENDANCE.CLASS_ATTENDANCE_ID#</cfoutput>">
  <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td class="headbold" height="35" align="center"><cf_get_lang no='222.Ders Yoklaması'></td>
    </tr>
  </table>
  <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr class="color-border">
      <td>
        <table border="0" cellpadding="2" cellspacing="1" width="100%">
          <tr class="color-header" height="22">
            <td class="form-title" width="150"><cf_get_lang_main no='158.Ad Soyad'></td>
            <td width="70" class="form-title"><cf_get_lang no='174.Yoklama'></td>
            <td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
          </tr>
          <cfoutput query="GET_CLASS_ATTENDANCE_DT">
            <cfset attributes.employee_id = EMP_ID>
            <cfinclude template="../query/get_employee.cfm">
            <tr class="color-row">
              <td>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME# <cfif is_trainer eq 1>(<cf_get_lang no='23.Eğitimci'>)</cfif></td>
              <td align="center">#ATTENDANCE_MAIN#</td>
              <td>#EXCUSE_MAIN#</td>
            </tr>
          </cfoutput>
        </table>
      </td>
    </tr>
  </table>
</cfform>

