<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_list_internaldemand.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="10">
<cfparam name="attributes.totalrecords" default="#get_list_internaldemand.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not isdefined("attributes.priority")>
	<cfset attributes.priority="">
</cfif>
<cf_flat_list>
<tbody>
	<cfif get_list_internaldemand.recordcount>
		<cfset internaldemand_stage_list = "">
		<cfoutput query="get_list_internaldemand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif Len(internaldemand_stage) and not ListFind(internaldemand_stage_list,internaldemand_stage)>
				<cfset internaldemand_stage_list = ListAppend(internaldemand_stage_list,internaldemand_stage)>
			</cfif>
		</cfoutput>
		<cfif ListLen(internaldemand_stage_list)>
			<cfquery name="get_internaldemand_stage" datasource="#dsn#">
				SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#internaldemand_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
			<cfset internaldemand_stage_list = ListSort(ListDeleteDuplicates(ValueList(get_internaldemand_stage.process_row_id)),"numeric","asc",",")>
		</cfif>
		<cfoutput query="get_list_internaldemand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif (get_list_internaldemand.internaldemand_status neq 2) and (get_list_internaldemand.is_active eq 1)>
				<tr>
					<cfset id_ = contentEncryptingandDecodingAES(isEncode:1,content:get_list_internaldemand.internal_id,accountKey:'wrk')>
					<td width="40%"> <a href="#request.self#?fuseaction=<cfif demand_type eq 1>myhome.list_purchasedemand&event=upd<cfelse>myhome.list_internaldemand&event=upd</cfif>&id=#id_#" class="tableyazi">#get_list_internaldemand.subject#</a></td>
					<td width="15%">#dateformat(get_list_internaldemand.target_date,dateformat_style)#</td>
					<td width="20%"><cfif Len(internaldemand_stage)>#get_internaldemand_stage.stage[ListFind(internaldemand_stage_list,internaldemand_stage,',')]#</cfif></td>
					<td width="10%" style="text-align:right"><cfif Len(get_list_internaldemand.from_position_code)>Talep Eden<cfelse><cf_get_lang_main no='71.Kayıt'></cfif>:&nbsp;</td>
					<td width="25%"><cfif Len(get_list_internaldemand.from_position_code)>#get_emp_info(get_list_internaldemand.from_position_code,0,1)#<cfelse>#get_emp_info(get_list_internaldemand.record_emp,0,1)#</cfif></td>
				</tr>
			</cfif>
		</cfoutput>
	<cfelse>
		<tr>
			<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
		</tr>
	</cfif>
	</tbody>
</cf_flat_list>
