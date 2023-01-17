<cfset select_list="">
<cfloop list="#attributes.process_type#" index="i">
    <cfset select_list=listappend(select_list,listlast(i,'-'))>
</cfloop>  
<cfquery name="add_bills_sheet" datasource="#dsn3#">
	UPDATE 
        BILLS_PROCESS_GROUP 
    SET
        PROCESS_NAME='#attributes.process_name#',
        PROCESS_TYPE='#select_list#',
		ACCOUNT_CODE_1 = <cfif len(attributes.code1)>'#attributes.code1#'<cfelse>NULL</cfif>,
		ACCOUNT_CODE_2 = <cfif len(attributes.code2)>'#attributes.code2#'<cfelse>NULL</cfif>,
		ACTION_DETAIL = <cfif len(attributes.bill_detail)>'#attributes.bill_detail#'<cfelse>NULL</cfif>,
		IS_DAY_GROUP = <cfif isdefined("attributes.is_day_group")>1<cfelse>0</cfif>,
		IS_ACCOUNT_GROUP = <cfif isdefined("attributes.is_account_group")>1<cfelse>0</cfif>,
        UPDATE_DATE=#now()#,
        UPDATE_EMP=#session.ep.userid#,
        UPDATE_IP='#cgi.remote_addr#'
    WHERE 
        PROCESS_TYPE_GROUP_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
