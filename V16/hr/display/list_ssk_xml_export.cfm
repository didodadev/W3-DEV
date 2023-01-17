<cfparam name="attributes.ssk_office_" default="">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfinclude template="../query/get_branch.cfm">

<cfquery name="get_ssk_xml_exports" datasource="#dsn#">
	SELECT 
		EMPLOYEES_SSK_EXPORTS.*,
		BRANCH.BRANCH_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES_SSK_EXPORTS,
		EMPLOYEES,
		BRANCH
	WHERE
		BRANCH.SSK_OFFICE = EMPLOYEES_SSK_EXPORTS.SSK_OFFICE AND
		BRANCH.SSK_NO = EMPLOYEES_SSK_EXPORTS.SSK_OFFICE_NO AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_SSK_EXPORTS.RECORD_EMP 
		<cfif not session.ep.ehesap>
		AND
		BRANCH.BRANCH_ID IN 
					(
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					)
		</cfif>
	<cfif len(attributes.sal_year)>
		AND EMPLOYEES_SSK_EXPORTS.SAL_YEAR = #attributes.sal_year#
	</cfif>
	<cfif len(attributes.sal_mon)>
		AND EMPLOYEES_SSK_EXPORTS.SAL_MON = #attributes.sal_mon#
	</cfif>
	<cfif len(attributes.ssk_office_)>
		<cfif database_type is "MSSQL">
		AND EMPLOYEES_SSK_EXPORTS.SSK_OFFICE + '-' + EMPLOYEES_SSK_EXPORTS.SSK_OFFICE_NO = '#attributes.ssk_office_#'
		<cfelseif database_type is "DB2">
		AND EMPLOYEES_SSK_EXPORTS.SSK_OFFICE || '-' || EMPLOYEES_SSK_EXPORTS.SSK_OFFICE_NO = '#attributes.ssk_office_#'
		</cfif>
	</cfif>
	ORDER BY
		EMPLOYEES_SSK_EXPORTS.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_ssk_xml_exports.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td height="35" class="headbold"><cf_get_lang dictionary_id ='53805.SSK Aylık E-Bildirge XML Dosya Listesi'></td>
			<!-- sil -->
			<td  valign="bottom" style="text-align:right;">
			<table>
			<cfform name="search" action="#request.self#?fuseaction=ehesap.list_ssk_xml_export" method="post">
				<tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
					<td>
					<select name="ssk_office_" id="ssk_office_">
						<option value=""><cf_get_lang dictionary_id ='53806.İşyeri'></option>
						<cfoutput query="get_branch">
							<cfif len("#ssk_office##ssk_no#")>
							<option value="#ssk_office#-#ssk_no#"<cfif attributes.ssk_office_ is '#ssk_office#-#ssk_no#'> selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
							</cfif>
						</cfoutput>
					</select>
					</td>
					<td>
					<select name="sal_year" id="sal_year">
						<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
							<cfloop from="-5" to="5" index="i">
								<cfoutput><option value="#session.ep.period_year + i#"<cfif session.ep.period_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
							</cfloop>
					</select>
					</td>
					<td>
					<select name="sal_mon" id="sal_mon">
						<option value=""><cf_get_lang dictionary_id='58724.Ay'></option>
						<cfloop from="1" to="12" index="i">
							<cfoutput><option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#i#</option></cfoutput>
						</cfloop>
					</select>
					</td>
					<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
				</tr>
			</cfform>
			</table>
			</td>
			<!-- sil -->
        </tr>
      </table>
<table cellspacing="1" cellpadding="2" border="0" align="center" width="98%" class="color-border">
  <tr class="color-header" height="22">
	<td class="form-title"><cf_get_lang dictionary_id ='53806.İşyeri'></td>
	<td class="form-title"><cf_get_lang dictionary_id ='53807.SSK Şube Adı SSK Şube İşyeri No'></td>
	<td width="80" class="form-title"><cf_get_lang dictionary_id ='53808.Yıl  Ay'></td>
	<td width="100" class="form-title"><cf_get_lang dictionary_id='57899.Kaydeden'></td>
	<td width="95" class="form-title"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></td>
	<td width="40" class="form-title">5073</td>
	<td width="40" class="form-title">5084</td>
	<td width="40" class="form-title">5615</td>
	<td width="40" class="form-title">5763</td>
	<td width="40" class="form-title">5921</td>
	<td width="40" class="form-title">5746</td>
	<td width="40" class="form-title">6111</td>
	<!-- sil -->
	<td width="33" align="center">
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_export_ssk_xml','medium');"><img src="/images/plus_square.gif" title="<cf_get_lang no ='866.E-Bildirde Ekle'> !" border="0"></a>
	</td>
	
	<!-- sil -->
  </tr>
  <cfoutput query="get_ssk_xml_exports" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
	  <td>#branch_name#<!--- aaa#file_web_path#hr#dir_seperator#ebildirge#dir_seperator##file_name# ---></td>
	  <td>#ssk_office# / #ssk_office_no#</td>
	  <td>#sal_year# / #ListGetAt(ay_list(),sal_mon)#</td>
	  <td>#employee_name# #employee_surname#</td>
	  <td>#dateformat(record_date,dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
	  <td align="center"><cfif is_5073 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_5084 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_5615 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_5510 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_5921 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_5746 eq 1>+<cfelse>-</cfif></td>
	  <td align="center"><cfif is_6111 eq 1>+<cfelse>-</cfif></td>
	  <!-- sil -->
	  <td align="center">
	 <!--- <cfoutput>#file_name#</cfoutput> --->
	  <cfif session.ep.ehesap>
	  	<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53809.Kayıtlı E-Bildirgeyi Siliyorsunuz  Emin misiniz'></cfsavecontent>
	  	<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=ehesap.emptypopup_del_export_ssk_xml&ese_id=#ese_id#','medium');"><img src="/images/delete_list.gif" title="<cf_get_lang no ='864.E-Bildirge Sil'> !" border="0"></a>
	  </cfif>
	  <a href="#file_web_path#hr#dir_seperator#ebildirge#dir_seperator##file_name#"><img src="/images/download.gif" title="<cf_get_lang no ='865.E-Bildirge XML Dosyası '>!" border="0"></a>
	  </td>
	 <!-- sil -->
	</tr>
  </cfoutput>
  <cfif not get_ssk_xml_exports.recordcount>
	<tr class="color-row">
        <td height="20" colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'> ! </td>
	</tr>
  </cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%">
    <tr>
      <td>
        <cfset adres=attributes.fuseaction>
       	<cfset adres = "#adres#&sal_year=#attributes.sal_year#">
       	<cfset adres = "#adres#&sal_mon=#attributes.sal_mon#">
        <cfif isdefined("attributes.ssk_office") and len(attributes.ssk_office)>
        	<cfset adres = "#adres#&ssk_office=#attributes.ssk_office#">
        </cfif>
        <cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#"> </td>
      <!-- sil --><td height="30"  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
