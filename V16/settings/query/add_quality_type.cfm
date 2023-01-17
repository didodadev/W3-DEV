<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
	<cfquery name="upd_quality_control_type" datasource="#dsn3#">
		UPDATE
			QUALITY_CONTROL_TYPE
		SET
			QUALITY_CONTROL_TYPE = <cfif len(attributes.control_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.control_type#">,<cfelse>NULL,</cfif>
			TYPE_DESCRIPTION = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
            PROCESS_CAT_ID = <cfif Len(attributes.process_cat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_cat_id#"><cfelse>NULL</cfif>,
			STANDART_VALUE = <cfif isDefined("attributes.default_value") and len(attributes.default_value)>#filterNum(attributes.default_value,4)#<cfelse>NULL</cfif>,
			TOLERANCE = <cfif isDefined("attributes.tolerans_value") and len(attributes.tolerans_value)>#filterNum(attributes.tolerans_value,4)#<cfelse>NULL</cfif>,
			QUALITY_MEASURE = <cfif isDefined("attributes.meausure_value") and len(attributes.meausure_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.meausure_value#"><cfelse>NULL</cfif>,
			IS_ACTIVE = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
            STOCK_MATERIAL = <cfif isdefined("attributes.STOCK_MATERIAL")>1<cfelse>0</cfif>,
            PROCESS = <cfif isdefined("attributes.PROCESS")>1<cfelse>0</cfif>,
            MACHINE_EQUIPMENT = <cfif isdefined("attributes.MACHINE_EQUIPMENT")>1<cfelse>0</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            CONTENT_ID=<cfif isDefined("attributes.content_id") and len(attributes.content_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#"><cfelse>NULL</cfif>,
            SPECIFIC_WEIGHT=<cfif isDefined("attributes.specific_weight") and len(attributes.specific_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.specific_weight)#"><cfelse>NULL</cfif>,
            CODE=<cfif isDefined("attributes.code") and len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>
		WHERE
			TYPE_ID = #attributes.type_id#
	</cfquery>	
<cfelse>
    
	<cfquery name="add_qualty_control_type" datasource="#dsn3#">
        INSERT INTO 
            QUALITY_CONTROL_TYPE
        (
            QUALITY_CONTROL_TYPE,
            IS_ACTIVE,
            STOCK_MATERIAL ,
			PROCESS,
			MACHINE_EQUIPMENT,
            TYPE_DESCRIPTION,
			PROCESS_CAT_ID,
            STANDART_VALUE,
            QUALITY_MEASURE,
            TOLERANCE,
            RECORD_IP,
            RECORD_DATE,
            RECORD_EMP,
            CONTENT_ID,
            SPECIFIC_WEIGHT,
            CODE
        ) 
        VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.control_type#">,
            <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.STOCK_MATERIAL")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.PROCESS")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.MACHINE_EQUIPMENT")>1<cfelse>0</cfif>,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			<cfif Len(attributes.process_cat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_cat_id#"><cfelse>NULL</cfif>,
            <cfif isDefined("attributes.default_value") and len(attributes.default_value)>#filterNum(attributes.default_value,4)#<cfelse>NULL</cfif>,
            <cfif isDefined("attributes.meausure_value") and len(attributes.meausure_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.meausure_value#"><cfelse>NULL</cfif>,
           <cfif isDefined("attributes.tolerans_value") and len(attributes.tolerans_value)> #filterNum(attributes.tolerans_value,4)#<cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            #now()#,
            #session.ep.userid#,
            <cfif isDefined("attributes.content_id") and len(attributes.content_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#"><cfelse>NULL</cfif>,
            <cfif isDefined("attributes.specific_weight") and len(attributes.specific_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.specific_weight)#"><cfelse>NULL</cfif>,
            <cfif isDefined("attributes.code") and len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>
        )
	</cfquery>	
</cfif>
<script type="text/javascript">
location.href = document.referrer;
</script>

 
	