<cfcomponent>  
    <cfset dsn = application.systemParam.systemParam().dsn>
	  <!--- Arıza Bildirimi Güncelleme --->
<cffunction name="UPD_FAILURE_FNC" returntype="any"> 
            <cfargument name="failure_emp_id" default="">
            <cfargument name="failure_emp" default="">
            <cfargument name="failure_date" default="">
            <cfargument name="care_type_id" default="">
            <cfargument name="care_type" default="">
            <cfargument name="assetp_id" default="">
            <cfargument name="station_id" default="">
            <cfargument name="station_name" default="">                    
            <cfargument name="subject" default="">
            <cfargument name="send_to_id" default="">
            <cfargument name="project_id" default="">
            <cfargument name="project_head" default="">
            <cfargument name="document_no" default="">
            <cfargument name="head" default="">
            <cfargument name="failure_id" default="">
            <cfargument name="failure_code" default="">
           <cfargument name="process_stage" default="">
<cfquery name="upd_asset_failure" datasource="#this.dsn#">
	UPDATE 
		ASSET_FAILURE_NOTICE
	SET
      FAILURE_EMP_ID=<cfif len(arguments.failure_emp_id) and isdefined("arguments.failure_emp")><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failure_emp_id#"><cfelse>NULL</cfif>,
      FAILURE_DATE=<cfif len(arguments.failure_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.failure_date#"><cfelse>NULL</cfif>,
      ASSET_CARE_ID=<cfif len(arguments.care_type_id) and len(care_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.care_type_id#"><cfelse>NULL</cfif>,
      FAILURE_STAGE=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
      ASSETP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#">,
      STATION_ID=<cfif isdefined("arguments.station_id") and len(arguments.station_id) and len(station_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#"><cfelse>NULL</cfif>,
      DETAIL=<cfif isdefined("arguments.subject") and len(arguments.subject)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#"><cfelse>NULL</cfif>,
      SEND_TO_ID= <cfif isdefined("arguments.send_to_id") and len(arguments.send_to_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.send_to_id#"><cfelse>NULL</cfif>,
      PROJECT_ID= <cfif isdefined("arguments.project_id") and len(arguments.project_id) and isdefined("arguments.project_head") and len(arguments.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
      DOCUMENT_NO=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.document_no#">,
      UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
      UPDATE_DATE= #now()#,	
      UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
      NOTICE_HEAD=<cfif  isdefined("arguments.head") and len(arguments.head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.head#"><cfelse>NULL</cfif>
	WHERE
		FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failure_id#">
</cfquery>
<cfquery name="del_defected_code" datasource="#this.dsn#">
	DELETE FROM FAILURE_CODE_ROWS WHERE FAILURE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failure_id#">
</cfquery>
<cfif isdefined("arguments.failure_code") and listlen(arguments.failure_code)>
	<cfloop list="#arguments.failure_code#" index="m">
			<cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#this.dsn#">
				INSERT INTO
					FAILURE_CODE_ROWS
				(
					FAILURE_CODE_ID,
					FAILURE_ID
				)				
				VALUES
				(
					#m#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failure_id#">
				)
			</cfquery>
	</cfloop>
</cfif>
            <cfreturn true>
</cffunction> 	
       <!--- Arıza Bildirimi Listeleme --->
      <cffunction name="GET_FAILURE_FNC" returntype="query"> 
            <cfargument name="official_emp_id" default="">
            <cfargument name="official_emp" default="">
            <cfargument name="service_code" default="">
            <cfargument name="service_code_id" default="">
            <cfargument name="assetp_id" default="">
            <cfargument name="keyword" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="station_id" default="">                    
            <cfargument name="start_date" default="">
            <cfargument name="finish_date" default="">
            <cfargument name="fuseaction" default="">
            <cfargument name="asset_id" default="">
            <cfargument name="station_name" default="">
             <cfargument name="asset_name" default="">
            <cfargument name="process_stage" default="">
           <cfquery name="get_asset_failure_list" datasource="#this.DSN#">
	SELECT
		AFN.FAILURE_ID,
		AFN.STATION_ID,
        AFN.FAILURE_STAGE,
        ASSET_P.ASSETP,
        AFN.FAILURE_DATE,
        AFN.FAILURE_EMP_ID,
        AFN.NOTICE_HEAD
	FROM
		ASSET_FAILURE_NOTICE AFN,
		ASSET_P,
		ASSET_CARE_CAT
	WHERE
		ASSET_P.STATUS IS NOT NULL
		AND ASSET_CARE_CAT.ASSET_CARE_ID = AFN.ASSET_CARE_ID
		AND ASSET_P.ASSETP_ID = AFN.ASSETP_ID
		<cfif isdefined("arguments.process_stage")>
               <cfif len(arguments.process_stage)>
                AND FAILURE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
            </cfif>
        </cfif>
		<cfif len(arguments.official_emp_id) and len(arguments.official_emp)>
        	AND AFN.FAILURE_EMP_ID = #arguments.official_emp_id#
		<cfelseif not len(arguments.official_emp) and listfind(arguments.fuseaction,'correspondence','.')>
        	AND AFN.FAILURE_EMP_ID = #session.ep.userid#
		</cfif>
		<cfif isdefined("arguments.service_code") and len(arguments.service_code) and isdefined("arguments.service_code_id") and len(arguments.service_code_id)>
			AND AFN.FAILURE_ID IN (SELECT FAILURE_ID FROM FAILURE_CODE_ROWS WHERE FAILURE_CODE_ID =#arguments.service_code_id#)
		</cfif>
		<cfif isDefined("arguments.assetp_id") and len(arguments.assetp_id)>AND ASSET_P.ASSETP_ID = #arguments.assetp_id#</cfif>
		<cfif len(arguments.keyword)>AND ASSET_P.ASSETP LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
		<cfif len(arguments.branch_id)and len(arguments.branch)>AND BRANCH.BRANCH_ID =#arguments.branch_id#</cfif>
		<cfif len(arguments.asset_id)and len(arguments.asset_name)>AND AFN.ASSETP_ID =#arguments.asset_id#</cfif>
		<cfif len(arguments.station_id) and len(arguments.station_name)>AND AFN.STATION_ID=#arguments.station_id#</cfif>
		<cfif len(arguments.official_emp_id) and len(arguments.official_emp)>AND AFN.FAILURE_EMP_ID =#arguments.official_emp_id#</cfif>
		<cfif len(arguments.start_date)>AND AFN.FAILURE_DATE >= #arguments.start_date#</cfif>
		<cfif len(arguments.finish_date)>AND AFN.FAILURE_DATE <= #arguments.finish_date#</cfif>
		ORDER BY 
			AFN.FAILURE_DATE DESC
        </cfquery>
            <cfreturn get_asset_failure_list>
    </cffunction> 

    <cffunction name="get_module_temp" access="public" returntype="query">
        <cfargument name="template_id">
        <cfargument name="module_id" default="">
        <cfquery name="get_module_temp" datasource="#dsn#">
            SELECT
                TEMPLATE_CONTENT
            FROM
                TEMPLATE_FORMS
            WHERE
                TEMPLATE_MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#"> AND
                TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.template_id#">
        </cfquery>
        <cfreturn get_module_temp>
    </cffunction>
    
</cfcomponent> 
