<cfscript>
	cmps='';
	if(isdefined("cc_emp_ids")) s_EMPS = ListSort(cc_emp_ids,"Numeric", "Desc"); else s_EMPS = '';
	if(isdefined("cc_par_ids")) s_PARS = ListSort(cc_par_ids,"Numeric", "Desc") ; else s_PARS = '';
	if(isdefined("cc_cons_ids")) s_CONS = ListSort(cc_cons_ids,"Numeric", "Desc") ; else s_CONS = '';
	if(isdefined("cc_grp_ids")) s_GRPS = ListSort(cc_grp_ids,"Numeric", "Desc") ; else s_GRPS = '';
	if(isdefined("cc_wgrp_ids")) s_WRKGROUP = ListSort(cc_wgrp_ids,"Numeric", "Desc") ; else s_WRKGROUP = '';
	if(isdefined("to_emp_ids")) j_EMPS = ListSort(to_emp_ids,"Numeric", "Desc") ; else j_EMPS = '';	
	if(isdefined("form.to_par_ids")) j_PARS = ListSort(to_par_ids,"Numeric", "Desc") ; else j_PARS = '';
	if(isdefined("to_cons_ids")) j_CONS = ListSort(to_cons_ids,"Numeric", "Desc") ; else j_CONS = '';
	if(isdefined("to_grp_ids")) j_GRPS = ListSort(to_grp_ids,"Numeric", "Desc") ; else j_GRPS = '';
	if(isdefined("to_wgrp_ids")) j_WRKGROUP = ListSort(to_wgrp_ids,"Numeric", "Desc"); else j_WRKGROUP = '';	
</cfscript>

<cfif not len(J_EMPS) and not listlen(J_EMPS) and not listlen(j_pars) and not listlen(j_CONS) and not listlen(j_GRPS) and not listlen(j_WRKGROUP)>
	<cfif not isdefined("FORM.VIEW_TO_ALL") and not isdefined("FORM.is_wiew_branch") and not isdefined("FORM.is_wiew_department")>
		<cfset J_EMPS = '#session.ep.userid#'>
	</cfif>
</cfif>

<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%agenda.form_add_event%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfset attributes.start_date = DateAdd('h',-1*session.ep.time_zone,attributes.start_date)>
<cfset attributes.end_date = DateAdd('h',-1*session.ep.time_zone,attributes.end_date)>
	
<cfset start_date = "#DateFormat(attributes.start_date, "yyyy-mm-dd")# #TimeFormat(attributes.start_date, "HH:mm:00")#">
<cfset end_date = "#DateFormat(attributes.end_date, "yyyy-mm-dd")# #TimeFormat(attributes.end_date, "HH:mm:00")#">
	

<cffunction name="create_event" access="public" returnType="numeric" output="no">
	<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
		SELECT 
			<cfif isdefined("session.ep.userid")>
			IS_STANDART = 
			CASE
			  WHEN (SELECT M.EVENTCAT_ID FROM MY_SETTINGS M WHERE M.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND M.EMPLOYEE_ID = #session.ep.userid#) IS NULL THEN '0'
				  ELSE '1'
			 END,
			<cfelse>
			'0' AS IS_STANDART,
			</cfif>
			EVENTCAT_ID 
		FROM 
			EVENT_CAT
		ORDER BY
			IS_STANDART DESC,
			EVENTCAT ASC
	</cfquery>
	
	<cfquery name="create_event_" datasource="#dsn#">
		INSERT INTO
			EVENT 
				(EVENT_HEAD,EVENT_STAGE,EVENTCAT_ID,STARTDATE,FINISHDATE,EVENT_TO_POS,RECORD_IP,RECORD_DATE,RECORD_EMP) 
			VALUES 
				('#attributes.text#',#GET_PROCESS_STAGE.PROCESS_ROW_ID#,#GET_EVENT_CATS.EVENTCAT_ID#,'#start_date#','#end_date#',',#J_EMPS#,','#cgi.remote_addr#',#now()#,#SESSION.EP.USERID#);
	</cfquery>
	<cfquery name="maxid" datasource="#dsn#">
		SELECT 
			MAX(EVENT_ID) AS keyvalue 
		FROM 
			EVENT
	</cfquery>
	<cfreturn maxid.keyvalue>
</cffunction>
