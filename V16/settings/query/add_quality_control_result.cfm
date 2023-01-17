<cfif isdefined("attributes.result_id") and len(attributes.result_id)>
	<cfquery name="upd_quality_control_result" datasource="#DSN3#">
		UPDATE
			QUALITY_CONTROL_ROW
		SET
			QUALITY_CONTROL_ROW = <cfif len(attributes.control_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.control_type#">,<cfelse>NULL,</cfif>
			QUALITY_ROW_DESCRIPTION = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,<cfelse>NULL,</cfif>
			RESULT_TYPE = <cfif isDefined("attributes.result_type") and Len(attributes.result_type)>#result_type#<cfelse>0</cfif>,
			QUALITY_VALUE = <cfif isDefined("attributes.default_value") and len(attributes.default_value)>#filterNum(attributes.default_value,4)#<cfelse>NULL</cfif>,
			TOLERANCE = <cfif isDefined("attributes.tolerance") and len(attributes.tolerance)>#filterNum(attributes.tolerance,4)#<cfelse>NULL</cfif>,
			TOLERANCE_2 = <cfif isDefined("attributes.tolerance_2") and len(attributes.tolerance_2)>#filterNum(attributes.tolerance_2,4)#<cfelse>NULL</cfif>,
			SAMPLE_METHOD= <cfif len(attributes.SAMPLE_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAMPLE_METHOD#">,<cfelse>0,</cfif>
			SAMPLE_NUMBER= <cfif len(attributes.sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.sample_number,4)#">,<cfelse>NULL,</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			CONTROL_OPERATOR= <cfif isDefined("attributes.control_operator") and len(attributes.control_operator)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.control_operator#"><cfelse>NULL</cfif>,
			UNIT= <cfif isDefined("attributes.unit") and len(attributes.unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit#"><cfelse>NULL</cfif>,
			CODE= <cfif isDefined("attributes.code") and len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>
		WHERE
			QUALITY_CONTROL_ROW_ID = #attributes.result_id#
	</cfquery>
<cfelse>
	<cfquery name="quality_control_result" datasource="#DSN3#">
		INSERT INTO 
			QUALITY_CONTROL_ROW
		(
			QUALITY_CONTROL_ROW,
			QUALITY_CONTROL_TYPE_ID,
			QUALITY_ROW_DESCRIPTION,
			RESULT_TYPE,
			QUALITY_VALUE,
            TOLERANCE,
			TOLERANCE_2,
			SAMPLE_METHOD,
			SAMPLE_NUMBER,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP,
			CONTROL_OPERATOR,
			UNIT,
			CODE
		) 
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.control_type#">,
			#attributes.type_id#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
			<cfif isDefined("attributes.result_type") and Len(attributes.result_type)>#result_type#<cfelse>0</cfif>,
			<cfif isDefined("attributes.default_value") and len(attributes.default_value)>#filterNum(attributes.default_value,4)#<cfelse>NULL</cfif>,
           	<cfif isDefined("attributes.tolerance") and len(attributes.tolerance)> #filterNum(attributes.tolerance,4)#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.tolerance_2") and len(attributes.tolerance_2)>#filterNum(attributes.tolerance_2,4)#<cfelse>NULL</cfif>,
			<cfif len(attributes.SAMPLE_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAMPLE_METHOD#">,<cfelse>0,</cfif>
			<cfif len(attributes.sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.sample_number,4)#">,<cfelse>NULL,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#,
			#session.ep.userid#,
			<cfif isDefined("attributes.control_operator") and len(attributes.control_operator)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.control_operator#"><cfelse>NULL</cfif>,
			<cfif isDefined("attributes.unit") and len(attributes.unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit#"><cfelse>NULL</cfif>,
			<cfif isDefined("attributes.code") and len(attributes.code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.code#"><cfelse>NULL</cfif>
		)
	</cfquery>
</cfif>
<script type="text/javascript">
	location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=quality.control_standarts&form_submitted=1';
</script>

