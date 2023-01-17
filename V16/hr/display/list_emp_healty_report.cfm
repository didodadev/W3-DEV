<cfquery NAME="GET_EMP_HEALTY_REPORT" DATASOURCE="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_HEALTY_REPORT 
	WHERE
		EMPLOYEE_ID=#attributes.EMPLOYEE_ID# AND
		(DOCTOR_NAME IS NOT NULL OR DOCTOR_SURNAME IS NOT NULL)
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_EMP_HEALTY_REPORT.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="txt">
    <cf_get_lang dictionary_id='55828.İşçi Sağlık Raporu'> : <cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput>
</cfsavecontent>
<cf_box title="#txt#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
  <cf_flat_list>
    <thead>      
          <tr>
              <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
              <th><cf_get_lang dictionary_id ='56628.Doktor İsim/Soyisim'></th>
              <th width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_add_personal_healty_report&employee_id=#attributes.employee_id#</cfoutput>','','ui-draggable-box-medium')"><i class="fa fa-plus"></i></a></th>
          </tr>
      </thead>  
      <tbody>
      <cfif GET_EMP_HEALTY_REPORT.RECORDCOUNT>
      <cfoutput QUERY="GET_EMP_HEALTY_REPORT"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          <tr>
              <td width="150">#dateformat(REPORT_DATE,dateformat_style)#</td>
              <td>#DOCTOR_NAME#&nbsp;#DOCTOR_SURNAME#</td>
              <td width="15">&nbsp;<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_personal_healty_report&healty_report_id=#get_emp_healty_report.healty_report_id#&employee_id=#attributes.employee_id#','','ui-draggable-box-medium')"><i class="fa fa-pencil"></i></a></td>
          </tr>
          </cfoutput>
      <cfelse>
          <tr>
              <td colspan="7">
              <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
              </td>
          </tr>
      </cfif>
      </tbody>
  </cf_flat_list>
  <cfif attributes.totalrecords gt attributes.maxrows>
  <table width="97%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
    <td><cf_pages page="#attributes.page#"
      maxrows="#attributes.maxrows#"
      totalrecords="#attributes.totalrecords#"
      startrow="#attributes.startrow#"
      adres="hr.GET_EMP_HEALTY_REPORT"> </td>
    <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
  </cfif>
</cf_box>