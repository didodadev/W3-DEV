<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.BRANCH_ID")>
<cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
<cfelse>
<cfset attributes.BRANCH_ID = "">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID")>
<cfset url_str = "#url_str#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
<cfelse>
<cfset attributes.POSITION_CAT_ID = "">
</cfif>
<cfinclude template="../query/get_class.cfm">
<cfquery name="get_emp_att" datasource="#dsn#">
  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp_att.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.trail")>
<cfinclude template="view_class.cfm">
</cfif>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top"> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold"><cf_get_lang no='185.Eğitim Değerlendirme Formları'> : <cfoutput>#get_class.CLASS_NAME#</cfoutput></td>
		   <!-- sil --> <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> <!-- sil -->
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
		<tr class="color-border"> 
          <td> 		  
            <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
              <tr class="color-header" height="22"> 
                <td class="form-title"><cf_get_lang_main no='1983.Katılımcı'></td>
                <td width="15" class="form-title" style="text-align:right;"><cf_get_lang_main no='280.İşlem'></td>
              </tr>
			 <cfif get_emp_att.RECORDCOUNT>
			  <cfoutput query="get_emp_att"> 
				  <cfset attributes.employee_id = EMP_ID>	
				  <cfinclude template="../query/get_employee.cfm">
				  <cfinclude template="../query/get_class_eval_emp.cfm">
			  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td nowrap>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#attributes.employee_id#','project');" class="tableyazi">#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</a>(#GET_EMPLOYEE.POSITION_NAME#) - #GET_EMPLOYEE.DEPARTMENT_HEAD#</td>
				<td align="center">
				<cfif GET_CLASS_EVAL_EMP.RecordCount>
					<a href="#request.self#?fuseaction=training_management.popup_form_upd_class_eval&class_id=#attributes.class_id#&employee_id=#EMP_ID#"><img src="/images/update_list.gif" align="absbottom" title="<cf_get_lang_main no='52.Güncelle'>" border="0"></a>
				<cfelse>
					<a href="#request.self#?fuseaction=training_management.popup_form_add_class_eval&class_id=#attributes.class_id#&employee_id=#EMP_ID#"><img src="/images/plus_list.gif" align="absbottom" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
				</cfif>
				</td>
			  </tr>
			  </cfoutput>
			 <cfelse>
			  <tr class="color-list">
				<td colspan="2">
				<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
				</td> 
			  </tr>
			 </cfif> 
            </table>
		
          </td>
        </tr>
      </table>
	<cfif get_emp_att.recordcount and (attributes.totalrecords gt attributes.maxrows)>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.list_class#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>
    </td>
  </tr>
</table>
