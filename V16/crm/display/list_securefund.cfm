<cfquery name="Get_Pro_TypeRows" datasource="#dsn#">
	SELECT
	PTR.STAGE,
	PTR.PROCESS_ROW_ID 
FROM
	PROCESS_TYPE_ROWS PTR,
	PROCESS_TYPE_OUR_COMPANY PTO,
	PROCESS_TYPE PT
WHERE
	PT.IS_ACTIVE = 1 AND
	PTR.PROCESS_ID = PT.PROCESS_ID AND
	PT.PROCESS_ID = PTO.PROCESS_ID AND
	PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
	PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.popup_add_securefund%">
ORDER BY 
	PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
SELECT 
	COMPANY_SECUREFUND.SECUREFUND_ID,
	COMPANY_SECUREFUND.SECUREFUND_TOTAL,
	COMPANY_SECUREFUND.FINISH_DATE,
	COMPANY_SECUREFUND.GIVE_TAKE,
	COMPANY_SECUREFUND.MONEY_CAT,
	COMPANY_SECUREFUND.RECORD_EMP,
	COMPANY_SECUREFUND.RECORD_DATE,
	COMPANY_SECUREFUND.IS_ACTIVE,
	COMPANY_SECUREFUND.PROCESS_CAT,
	SETUP_SECUREFUND.SECUREFUND_CAT,
	BRANCH.BRANCH_NAME
FROM 
	COMPANY_SECUREFUND, 
	SETUP_SECUREFUND,
	BRANCH,
	COMPANY_BRANCH_RELATED
WHERE 
	COMPANY_SECUREFUND.IS_CRM = 1 AND
	COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
	<!--- BK kaldirdi 20080818 COMPANY_SECUREFUND.IS_ACTIVE = 1 AND --->
	COMPANY_SECUREFUND.COMPANY_ID = #attributes.cpid# AND
	COMPANY_SECUREFUND.SECUREFUND_CAT_ID  = SETUP_SECUREFUND.SECUREFUND_CAT_ID AND
	COMPANY_SECUREFUND.BRANCH_ID = COMPANY_BRANCH_RELATED.RELATED_ID AND
	BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
	<cfif ListLen(Get_Pro_TypeRows.Process_Row_Id)>
		AND COMPANY_SECUREFUND.PROCESS_CAT IN (#ListDeleteDuplicates(ValueList(Get_Pro_TypeRows.Process_Row_Id,','))#)
	<cfelse>
		AND COMPANY_SECUREFUND.PROCESS_CAT IS NULL
	</cfif>
ORDER BY 
	COMPANY_SECUREFUND.FINISH_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_company_securefund.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cf_box>
<cf_grid_list>
	<thead>
		<tr>
			<th colspan="9"><cf_get_lang_main no='264.Teminatlar'></th>
		</tr>
		<tr>
			<th width="30"><cf_get_lang_main no='70.No'></th>
			<th><cf_get_lang no='738.Depo Adı'></th>
			<th width="150"><cf_get_lang_main no='642.Sürec-Asama'></th>
			<th width="95"><cf_get_lang_main no='218.Tip'></th>
			<th width="150"><cf_get_lang_main no='1277.Teminat'></th>
			<th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
			<th width="65"><cf_get_lang_main no='288.Bitiş Tarihi'></th>
			<th width="200"><cf_get_lang_main no='71.Kayıt'></th>
			<th width="15">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_securefund&cpid=#attributes.cpid#</cfoutput>','longpage','popup_add_securefund')"><i class="fa fa-plus"></i></a>
		</tr>
	</thead>
	<tbody>
		<cfif get_company_securefund.recordcount>
			<cfset Process_List = "">
			<cfoutput query="get_company_securefund" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif Len(Process_Cat) and not ListFind(Process_List,Process_Cat,',')>
					<cfset Process_List = ListAppend(Process_List,Process_Cat,',')> 
				</cfif>
			</cfoutput>
			<cfif ListLen(Process_List)>
				<cfquery name="Get_Process_Cat" datasource="#dsn#">
					SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#Process_List#) ORDER BY PROCESS_ROW_ID
				</cfquery>
				<cfset Process_List = ListSort(ListDeleteDuplicates(ValueList(Get_Process_Cat.Process_Row_Id,',')),'numeric','asc',',')>
			</cfif>
			<cfoutput query="get_company_securefund" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#branch_name#</td>
					<td><cfif Len(Process_Cat)>#Get_Process_Cat.Stage[ListFind(Process_List,Process_Cat,',')]#</cfif></td>
					<td><cfif give_take eq 0><cf_get_lang_main no='1076.Alınan'><cfelse><cf_get_lang_main no='1078.Verilen'></cfif></td>
					<td>#securefund_cat#</td>
					<td style="text-align:right;">#tlformat(securefund_total)# #money_cat#</td>
					<td>#dateformat(finish_date,dateformat_style)#</td>
					<td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_securefund&securefund_id=#securefund_id#','longpage','popup_upd_securefund')"><i class="fa fa-pencil"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
				<tr>
					<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>

			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="crm.popup_list_securefund&cpid=#attributes.cpid#"> 
		
</cfif>
</cf_box>
<cfif isdefined("attributes.is_open_securefund") and len(attributes.is_open_securefund)>
<script type="text/javascript">
	windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_securefund&securefund_id=#attributes.action_id#&cpid=#attributes.cpid#</cfoutput>','longpage');
</script>
<cfset attributes.is_open_securefund = ''>
</cfif>
