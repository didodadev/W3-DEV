<cfinclude template="../query/get_empapp.cfm">
<cfquery name="get_app" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_POS WHERE APP_POS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#"> AND EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
</cfquery>
<cfif get_app.recordcount>
<cfquery name="get_position" datasource="#dsn#">
	SELECT NOTICE_HEAD,POSITION_NAME,POSITION_CAT_NAME FROM NOTICES WHERE NOTICE_ID=<cfif len(get_app.NOTICE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.NOTICE_ID#"><cfelse>0</cfif>
</cfquery>
<cfquery name="get_mails" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_APP_MAILS
	WHERE
		EMPLOYEES_APP_MAILS.APP_POS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_pos_id#">
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr bgcolor="#FFB74A" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center" cellspacing="1" cellpadding="2">
              <tr> 
                <td valign="bottom" class="txtbold"><cf_get_lang no='808.Başvurularım'> \ <cfoutput>#get_position.NOTICE_HEAD#</cfoutput>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="3"></td>
			<td><a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_dsp_mails&app_pos_id=#attributes.app_pos_id#</cfoutput>','small')"  title="<cf_get_lang no='914.Cevap Mektupları'>"><img src="objects2/image/mail.gif" border="0" alt="<cf_get_lang no='914.Cevap Mektupları'>" /></a></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang no='468.Başvuru Tarihi'></td>
			<td><cfoutput>#dateformat(get_app.app_date,'dd/mm/yyyy')#</cfoutput></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='344.Durumu'></td>
			<td><cfif get_app.app_pos_status eq 1><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></td>
			<td><cfoutput>#get_position.POSITION_NAME#</cfoutput></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='160.Departman'></td>
			<td><cfif len(get_app.department_id) and len(get_app.our_company_id)>
				<cfquery name="get_our_company" datasource="#dsn#">
				SELECT BRANCH.BRANCH_NAME, BRANCH.BRANCH_ID, DEPARTMENT.DEPARTMENT_HEAD, DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT, BRANCH WHERE BRANCH.COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.our_company_id#"> AND BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID AND BRANCH.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.branch_id#"> AND DEPARTMENT.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.department_id#">
				</cfquery>
			  </cfif>
			  <cfif isdefined('get_our_company') and get_our_company.recordcount><cfoutput>#get_our_company.department_head#</cfoutput></cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1237.Ön Yazı'></td>
			<td colspan="3">
				<cfif len(get_app.detail)><cfoutput>#get_app.detail#</cfoutput></cfif>
			</td>
		</tr>
			<td class="txtbold"><cf_get_lang no='906.İşe Başlama Tarihi'></td>
			<td><cfif len(get_app.startdate_if_accepted)> <cfoutput>#dateformat(get_app.STARTDATE_IF_ACCEPTED,'dd/mm/yyyy')#</cfoutput></cfif></td>
		<tr>
			<td class="txtbold"><cf_get_lang no='753.İstenen Ücret'></td>
			<td><cfif len(get_app.salary_wanted)><cfoutput>#TLFormat(get_app.salary_wanted)# #get_app.salary_wanted_money#</cfoutput></cfif></td>
		</tr>
		<tr height="35"> 
			<td colspan="2"  class="txtbold" style="text-align:right;"><a href="javascript:window.close();">&laquo; <cf_get_lang_main no='141.Kapat'> &raquo;</a></td>
		</tr>
		</table>
        	</table>
        	</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.list_app_pos" addtoken="no">
</cfif>
