<!--- Fuseactionla ilişkili çağrıları getirir. Dev wo için oluşturuldu. EIY. --->
<cfquery name="get_service" datasource="#dsn#">
    SELECT  
        S.SERVICE_ID,
        S.SERVICE_NO,
        S.SERVICE_HEAD,
        S.RESP_EMP_ID,
		S.RESP_PAR_ID,
		S.RESP_CONS_ID,
        CONVERT(VARCHAR(30), S.APPLY_DATE, 103)+' '+CONVERT(VARCHAR(30), S.APPLY_DATE, 108) APPLY_DATE
        ,S.SUBSCRIPTION_ID
		,PTR.STAGE,
		SP.COLOR
    FROM 
        G_SERVICE S,
		PROCESS_TYPE_ROWS PTR,
		SETUP_PRIORITY SP
    WHERE 
        S.SERVICE_ID IS NOT NULL
		AND S.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID
		AND SP.PRIORITY_ID = S.PRIORITY_ID 
        AND S.SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfif isdefined("attributes.Workfuse") and len(attributes.Workfuse)>
            AND S.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.Workfuse#%">
        </cfif>
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='34405.Call Center'></cfsavecontent>
	<cf_box title=#head#>
		<cf_ajax_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='32417.Başvuru No'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th> 
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_service&event=add" target="_blank"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_service.recordcount>
					<cfoutput query="get_service">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" target="_blank">#service_no#</a></td>
                            <td>#service_head#</td>
                            <td>
								<cfif len(RESP_EMP_ID)>
									#get_emp_info(RESP_EMP_ID,0,0)#
								<cfelseif len(RESP_PAR_ID)>
									#get_par_info(resp_par_id,0,0,0)#
								<cfelseif len(RESP_CONS_ID)>
									#get_cons_info(resp_cons_id,0,0)#
								</cfif>
							</td>
							<td><font color="#color#">#stage#</font></td>
                            <td>#dateformat(apply_date,dateformat_style)#</td>
                            <td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" target="_blank"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
						<tr>
							<td colspan="6"><cf_get_lang dictionary_id='57484.Kayit Yok'> !</td>
						</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
	
	</cf_box>
</div>

