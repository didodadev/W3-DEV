<cfif len(attributes.request_date)>
	<cf_date tarih='attributes.request_date'>
</cfif> 

<cfquery name="UPD_ASSET_P_DEMAND" datasource="#DSN#">
    UPDATE
        ASSET_P_DEMAND
    SET
		ASSET_P_STATUS = <cfif isdefined("attributes.asset_p_status")>1<cfelse>0</cfif>,
		ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">,
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
        <cfif attributes.valid_state eq 1>
             RESULT_ID = 1,
            VALID_DATE = #now()#,
       	<cfelseif attributes.valid_state eq 2>
        	RESULT_ID = 0,
            VALID_DATE = #now()#,
		</cfif>
		<!---VALIDATOR_POS_CODE = <cfif len(attributes.validator_pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_pos_code#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,--->
		USAGE_PURPOSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.usage_purpose_id#">,		
		BRAND_TYPE_ID = <cfif len(attributes.brand_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_type_id#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
		MAKE_YEAR = <cfif len(attributes.make_year)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.make_year#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
		REQUEST_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.request_date#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,		
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        ASSETP_SUB_CATID = <cfif isdefined('attributes.assetp_sub_catid') and len(attributes.assetp_sub_catid)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_sub_catid#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
        STAGE = <cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>
    WHERE
        DEMAND_ID = #attributes.demand_id#				
</cfquery>

		<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='ASSET_P_DEMAND'
		action_column='DEMAND_ID'
		action_id='#attributes.demand_id#'
		action_page='#request.self#?fuseaction=assetcare.list_assetp_demands' 
		warning_description='Varlık Talebi: #attributes.demand_id#'>
  
	<script>
	<cfif listFirst(pageFuseaction,'.') is 'myhome'>
		window.document.location.href='<cfoutput>/index.cfm?fuseaction=myhome.list_assetp&event=upd&demand_id=#attributes.demand_id#</cfoutput>';
		<cfelse>
			window.document.location.href='<cfoutput>/index.cfm?fuseaction=assetcare.list_assetp_demands&event=upd&demand_id=#attributes.demand_id#</cfoutput>';
			
		</cfif>
	</script>
	