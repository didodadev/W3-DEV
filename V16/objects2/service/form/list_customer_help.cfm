<cfquery name="get_help" datasource="#dsn#">
	SELECT 
		WORKCUBE_ID,
		APPLICANT_NAME,
		SUBJECT,
		RECORD_DATE,
		PROCESS_STAGE,
		SOLUTION_DETAIL,
		CUS_HELP_ID
	FROM
		CUSTOMER_HELP
	WHERE
		1=1
		<cfif len(attributes.app_name) and len(attributes.workcube_id)>
			AND APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.app_name#%"> AND WORKCUBE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.workcube_id#%">
		</cfif>
		<cfif isdefined ("attributes.member_type")>
			<cfif attributes.member_type eq 'partner'>
			AND APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#get_par_info(get_company.partner_id,0,-1,0)#%">
			<cfelse>
			AND APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#get_par_info(attributes.cid,0,-1,0)#%">
			</cfif>
		</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cfset order_stage_list=valuelist(get_help.process_stage,',')>
<cfset order_stage_list=listsort(order_stage_list,"numeric","ASC",",")>
<cfif len(order_stage_list)>
	<cfquery name="PROCESS_TYPE" datasource="#DSN#">
		SELECT
			STAGE,
			PROCESS_ROW_ID
		FROM
			PROCESS_TYPE_ROWS
		WHERE
			PROCESS_ROW_ID IN(#order_stage_list#)
		ORDER BY
			PROCESS_ROW_ID
	</cfquery>
</cfif>
<table width="100%">
	<tr class="color-list" height="22">
		<td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
		<td class="txtboldblue" width="27%"><cf_get_lang_main no='217.Açıklama'></td>
		<td class="txtboldblue" width="33%"><cf_get_lang_main no='1242.Cevap'></td>
		<td class="txtboldblue"><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="txtboldblue"><cf_get_lang_main no='70.Aşama'></td>
	</tr>
	<cfoutput query="get_help" <!--- startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" --->>
	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td>#dateformat(RECORD_DATE,"dd/mm/yyyy")#</td>
		<td>
		<cfquery name="get_sol" datasource="#dsn#">
					SELECT HELP_SOL_ID FROM CUST_HELP_SOLUTIONS WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cus_help_id#">
				</cfquery>
				<cfif get_sol.recordcount>
					<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=call.popup_upd_helpdesk&cus_help_id=#CUS_HELP_ID#&help_sol_id=#get_sol.HELP_SOL_ID#','project');" class="tableyazi"> </a>--->#SUBJECT#
				<cfelse>
					<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=call.popup_upd_helpdesk&cus_help_id=#CUS_HELP_ID#','project');" class="tableyazi"></a>--->#SUBJECT#
				</cfif>
		</td>
		<td>#SOLUTION_DETAIL#</td>
		<td>#APPLICANT_NAME#</td>
		<td>
		<cfif len(order_stage_list) and len(process_stage)>
		<cfquery name="process" dbtype="query">
			SELECT * FROM PROCESS_TYPE WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROCESS_STAGE#">
		</cfquery>
		#PROCESS.STAGE#
		</cfif>
		</td>
	</td>
	</cfoutput>
	<cfif not get_help.recordcount>
		<tr class="color-row">
			<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
</table>
