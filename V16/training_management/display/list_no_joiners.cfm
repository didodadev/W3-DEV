<cfquery name="get_list" datasource="#DSN#">
	SELECT
		DISTINCT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		TRAINING_CLASS_ATTENDANCE_DT TCADT,
		TRAINING_CLASS_ATTENDANCE TCA,
		EMPLOYEES E
	WHERE
			E.EMPLOYEE_ID=TCADT.EMP_ID
		AND
			TCADT.CLASS_ATTENDANCE_ID IS NOT NULL
		AND
			TCA.CLASS_ID = #attributes.CLASS_ID#
		AND
			TCADT.ATTENDANCE IS NULL
		AND
			TCADT.IS_EXCUSE=0
		AND
			TCADT.CLASS_ATTENDANCE_ID=TCA.CLASS_ATTENDANCE_ID	
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_list.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold"><cf_get_lang no='209.Devamsızlıklar ve Derse Katılmayanlar'></td>
		  <!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil -->
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
		<tr class="color-border"> 
          <td> 		  
            <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
              <tr class="color-header" height="22"> 
                <td class="form-title" width="150"><cf_get_lang no='210.Derse Katılmayanlar'></td>
              </tr>
			 <cfif get_list.RECORDCOUNT>
				  <cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					  </tr>
				  </cfoutput>
			 <cfelse>
				  <tr class="color-list">
					<td colspan="4">
					<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					</td> 
				  </tr>
			 </cfif> 
            </table>
		
          </td>
        </tr>
      </table>
	<cfif get_list.recordcount and (attributes.totalrecords gt attributes.maxrows)>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_no_joiners&class_id=#attributes.CLASS_ID#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>
    </td>
  </tr>
</table>

