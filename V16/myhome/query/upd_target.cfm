<cfif isdefined('attributes.update_type') and attributes.update_type eq 1>
	<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
	<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
	<cfquery name="UPP_TARGET" datasource="#dsn#">
		UPDATE 
			TARGET
		SET 
			TARGETCAT_ID = #attributes.targetcat_id#,
			STARTDATE = <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
			FINISHDATE  = <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
			TARGET_HEAD  = '#attributes.target_head#',
			TARGET_NUMBER =  <cfif len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
			TARGET_DETAIL = '#attributes.target_detail#',
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#',
			CALCULATION_TYPE = <cfif isdefined("attributes.calculation_type") and len(attributes.calculation_type)>#attributes.calculation_type#<cfelse>NULL</cfif>,
			TARGET_MONEY = <cfif isdefined("attributes.money_type") and len(attributes.money_type)>'#attributes.money_type#'<cfelse>NULL</cfif>,
			TARGET_EMP = #attributes.target_emp_id#,
			TARGET_WEIGHT=<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>
		WHERE 
			TARGET_ID = #attributes.target_id#
	</cfquery>

<cfelseif isdefined('attributes.update_type') and update_type eq 2>
	<cfquery name="UPD_TARGET_PERF" datasource="#dsn#">
		UPDATE
			TARGET
		SET
			PERFORM_COMMENT = '#attributes.PERFORM_COMMENT#',
			<cfif IsDefined("attributes.PERFORM_POINT_ID")>
			PERFORM_POINT_ID = #attributes.PERFORM_POINT_ID#,
			</cfif>
			PERFORM_REC_EMP = #Session.ep.userid#,
			PERFORM_REC_DATE = #now()#
		WHERE
			TARGET_ID = #attributes.TARGET_ID#
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
