<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfif not isdefined("new_dsn2_group_alias")><cfset new_dsn2_group_alias = dsn2_alias></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfset session_list="">
<cfset attributes.fis_date_time = createdatetime(year(attributes.fis_date),month(attributes.fis_date),day(attributes.fis_date),attributes.fis_date_h,attributes.fis_date_m,0)>
<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#">
	INSERT INTO
		#new_dsn2_group_alias#.STOCK_FIS
	(
		FIS_TYPE,
		PROCESS_CAT,
	  <cfif not listfind('110,115',attributes.fis_type)>
		DEPARTMENT_OUT,
		LOCATION_OUT,
	  </cfif>
		FIS_NUMBER,
	  <cfif not listfind('111,112',attributes.fis_type)>
		DEPARTMENT_IN,
		LOCATION_IN,
	  </cfif>
	 	PROD_ORDER_NUMBER,
        PARTNER_ID,
        COMPANY_ID,
        CONSUMER_ID,
        EMPLOYEE_ID,
		FIS_DATE,
		DELIVER_DATE,
		REF_NO,
		PROJECT_ID,
        PROJECT_ID_IN,
		IS_PRODUCTION,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		FIS_DETAIL,
		WORK_ID,
        SERVICE_ID,
        SUBSCRIPTION_ID
	)
	VALUES
	(
		#attributes.FIS_TYPE#,
		#attributes.PROCESS_CAT#,
		<cfif not listfind('110,115',attributes.fis_type)>
		 <cfif len(attributes.department_out)>#attributes.department_out#<cfelse>NULL</cfif>,
		 <cfif len(attributes.location_out)>#attributes.location_out#<cfelse>NULL</cfif>,						
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
		<cfif not listfind('111,112',attributes.fis_type)>
		 <cfif len(attributes.department_in)>#attributes.department_in#<cfelse>NULL</cfif>,
		 <cfif len(attributes.location_in)>#attributes.location_in#<cfelse>NULL</cfif>,
		</cfif>
		<cfif len(attributes.prod_order_number)>#attributes.prod_order_number#<cfelse>NULL</cfif>,
		<cfif attributes.member_type is 'partner' and len(attributes.member_name)>
            #attributes.partner_id#,
            #attributes.company_id#,
            NULL,
            NULL,
        <cfelseif attributes.member_type is 'consumer' and len(attributes.member_name)>
            NULL,
            NULL,
            #attributes.consumer_id#,
            NULL,
        <cfelseif attributes.member_type is 'employee' and len(attributes.member_name)>
            NULL,
            NULL,
            NULL,
            #attributes.employee_id#,
        </cfif>
		#attributes.FIS_DATE#,
		#attributes.fis_date_time#,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in)>#attributes.project_id_in#<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.is_productions") and attributes.is_productions eq 1>1<cfelse>0</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.work_id') and len(attributes.work_id) and isdefined('attributes.work_head') and len(attributes.work_head)>#attributes.work_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfquery name="GET_ID" datasource="#dsn2#">
	SELECT MAX(FIS_ID) MAX_ID FROM #new_dsn2_group_alias#.STOCK_FIS 
</cfquery>
