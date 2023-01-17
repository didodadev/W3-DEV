<cfif len(attributes.promotion_start)>
	<cf_date tarih="attributes.promotion_start">
</cfif>
<cfif len(attributes.promotion_finish)>
	<cf_date tarih="attributes.promotion_finish">
</cfif>
<cfquery name="upd_rank" datasource="#DSN#">
	UPDATE
		EMPLOYEES_RANK_DETAIL
	SET
		GRADE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.grade#">,
		STEP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.step#">,
		PROMOTION_START = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.promotion_start#">,
		PROMOTION_FINISH = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.promotion_finish#">,
		PROMOTION_REASON = <cfif len(attributes.promotion_reason)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_reason#"><cfelse>NULL</cfif>,
		RECORD_EMP = #SESSION.EP.USERID#,
		RECORD_IP = '#CGI.REMOTE_ADDR#',
		RECORD_DATE = #NOW()#
	WHERE
		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>	
<cflocation addtoken="no" url="#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_rank&employee_id=#attributes.employee_id#">
