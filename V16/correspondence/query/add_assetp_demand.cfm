<cfquery name="get_validator_pos_code" datasource="#dsn#">
	SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
</cfquery>
<cfif len(attributes.request_date)>
	<cf_date tarih='attributes.request_date'>
</cfif>
<cfquery name="add_assetp_demand" datasource="#dsn#" result="get_max_demand">
	INSERT INTO
		ASSET_P_DEMAND
	(
		ASSETP_CATID,
		<!---DEPARTMENT_ID,--->
		EMPLOYEE_ID,
		VALIDATOR_POS_CODE,
		USAGE_PURPOSE_ID,		
		BRAND_TYPE_ID,
		MAKE_YEAR,
		REQUEST_DATE,
		DETAIL,		
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
        ASSETP_SUB_CATID,
        STAGE,
		ASSET_P_STATUS
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">,
		<!---<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,--->
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
		<cfif len(get_validator_pos_code.UPPER_POSITION_CODE)><cfqueryparam value="#get_validator_pos_code.UPPER_POSITION_CODE#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.usage_purpose_id#">,		
		<cfif len(attributes.brand_type_id)>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_type_id#">
		<cfelse>
			<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
		</cfif>,
		<cfif len(attributes.make_year)>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.make_year#">
		<cfelse>
			<cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer">
		</cfif>,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.request_date#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        <cfif isdefined('attributes.assetp_sub_catid') and len(attributes.assetp_sub_catid)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_sub_catid#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_integer"></cfif>,
        <cfif isdefined('attributes.process_stage')>#attributes.process_stage#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.asset_p_status")>1<cfelse>0</cfif>
	)

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
	action_id='#get_max_demand.identitycol#'
	action_page='#request.self#?fuseaction=assetcare.list_assetp_demands' 
	warning_description='Varlık Talebi: #get_max_demand.identitycol#'>

<script type="text/javascript">
	location.href = document.referrer;
  </script>



<!---
	Bunlar Çalışmıyor :/
	<cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelse>
		<cflocation url="#request.self#?fuseaction=myhome.list_assetp_demand" addtoken="no">
	</cfif>
--->
