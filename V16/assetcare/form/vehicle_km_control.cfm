<cfparam name="attributes.usage_purpose_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfquery name="GET_KMS" datasource="#dsn#">
		SELECT 
			ASSET_P_KM_CONTROL.*, 
			ASSET_P.ASSETP,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
		FROM
			ASSET_P_KM_CONTROL,
			ASSET_P,
			BRANCH,
			DEPARTMENT,
			EMPLOYEES
		WHERE
			ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID AND
			ASSET_P.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND		
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
			ASSET_P_KM_CONTROL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
	<cfif len(attributes.employee_id) and len(attributes.employee_name)>AND ASSET_P_KM_CONTROL.EMPLOYEE_ID = #attributes.employee_id#</cfif>
			AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
	ORDER BY 
		KM_CONTROL_ID
	DESC
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_kms.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td  height="35" class="headbold"><cf_get_lang no='718.KM Giriş'></td>
     <!-- sil -->
	<td style="text-align:right;">
      <!--- Arama ---> 
	  <table>
        <cfform name="search_kms" action="" method="post">
          <tr>
            <td><cf_get_lang_main no='1463.Çalışanlar'></td>
				<td><input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
				<input type="text" name="employee_name" id="employee_name" style="width:135px;" maxlength="255">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_kms.employee_id&field_name=search_kms.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1463.Çalışanlar'>" border="0" align="absmiddle"></a></td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
            <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
	  <!--- Arama ---> 
    </td>
	<!-- sil -->
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
	  <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
        <tr class="color-header">
		   <td width="150" class="form-title"><cf_get_lang_main no='1656.Plaka'> </td>
           <td width="150" class="form-title"><cf_get_lang_main no='132.Sorumlu'></td>
           <td width="100" class="form-title"><cf_get_lang_main no='89.Başlangıç'></td>
           <td width="100" class="form-title"><cf_get_lang_main no='90.Bitiş'></td>
           <td width="100" class="form-title" style="text-align:right;"><cf_get_lang no='219.Son Km'></td>
        </tr>
		<cfif get_kms.recordcount>
        <cfoutput query="get_kms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				   <td>#assetp#</td>
				  <td>#employee_name# #employee_surname#</td>
				  <td>#dateformat(start_date,dateformat_style)#</td>
				  <td>#dateformat(finish_date,dateformat_style)#</td>
				  <td style="text-align:right;">#tlformat(km_finish)#</td>
			</tr>
          </cfoutput>
		  <cfelse>
          <tr height="20" class="color-row">
            <td colspan="10"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
          </tr>
	    </cfif>
      </table>
	  <!-- sil -->	
    </td>
  </tr>
</table>
<!-- sil -->	
<cfif (attributes.totalrecords gt attributes.maxrows)> 
	<cfset url_str = "">
	<cfif len(attributes.usage_purpose_id)>
	  <cfset url_str = "#url_str#&usage_purpose_id=#attributes.usage_purpose_id#">
	</cfif>
	<cfif len(attributes.employee_name)>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif len(attributes.employee_id)>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif len(attributes.assetp_id)>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr>
      <td><cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="assetcare.popup_list_km_control_detail#url_str#"></td>
      <!-- sil --><td height="35" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
</cfif>
