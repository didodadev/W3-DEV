<cfset select_list="">
<cfloop list="#attributes.process_type#" index="i">
    <cfset select_list=listappend(select_list,listlast(i,'-'))>
</cfloop>  
<cfquery name="add_bills_sheet" datasource="#dsn3#"> 
    INSERT INTO
        BILLS_PROCESS_GROUP
        (
            PROCESS_NAME,
            PROCESS_TYPE,
			ACCOUNT_CODE_1,
			ACCOUNT_CODE_2,
			ACTION_DETAIL,
			IS_DAY_GROUP,
			IS_ACCOUNT_GROUP,
			RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        )
        VALUES
        (
            '#attributes.process_name#',
            '#select_list#',
			<cfif len(attributes.code1)>'#attributes.code1#'<cfelse>NULL</cfif>,
			<cfif len(attributes.code2)>'#attributes.code2#'<cfelse>NULL</cfif>,
			<cfif len(attributes.bill_detail)>'#attributes.bill_detail#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_day_group")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_account_group")>1<cfelse>0</cfif>,
             #now()#,
             #session.ep.userid#,
            '#cgi.remote_addr#'
        )
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
