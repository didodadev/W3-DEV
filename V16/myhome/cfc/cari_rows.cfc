<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="CARI_ROWS" access="public" returntype="query">
        <cfargument name="date_1" default="">
        <cfargument name="date_2" default="">
        <cfargument name="company_id" default="">
        <cfargument name="company" default="">
        <cfargument name="member_cat_type" default="">
        <cfargument name="pos_code" default="">
        <cfargument name="pos_code_text" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="acc_type_id" default="">
        <cfquery name="GET_CARI_ROWS" datasource="#dsn2#">
        SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			0 AS BORC,
			CR.ACTION_VALUE ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			<cfif (isdefined('arguments.company_id') and len(arguments.company_id) and len(arguments.company) and member_type is 'partner') or (isdefined("arguments.member_cat_type") and len(arguments.member_cat_type) and listfirst(arguments.member_cat_type,'-') eq 1) or (isdefined("arguments.pos_code") and len(arguments.pos_code) and len(arguments.pos_code_text))>
				FROM_CMP_ID = #arguments.COMPANY_ID# AND
			<cfelseif (isdefined('arguments.consumer_id') and  len(arguments.consumer_id) and len(arguments.company) and member_type is 'consumer') or (isdefined("arguments.member_cat_type") and len(arguments.member_cat_type) and listfirst(arguments.member_cat_type,'-') eq 2)>
				FROM_CONSUMER_ID = #arguments.consumer_id# AND
			<cfelseif isdefined('arguments.employee_id') and  len(arguments.employee_id) and len(arguments.company) and member_type is 'employee'>
				FROM_EMPLOYEE_ID = #arguments.employee_id# AND
			</cfif>
			<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
				ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
			<cfelseif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
				ACC_TYPE_ID = #arguments.acc_type_id# AND
            </cfif>
            <cfif (isdefined('arguments.date1') and len(arguments.date1))>
			    CR.ACTION_DATE  >= #arguments.date1# AND 
            </cfif>  
            <cfif (isdefined('arguments.date2') and len(arguments.date2))>  
                CR.ACTION_DATE <= #arguments.date2#
            </cfif>
		     CR.FROM_EMPLOYEE_ID = #session.ep.userid#
		UNION ALL
		SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			CR.ACTION_VALUE AS BORC,
			0 AS ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			<cfif (isdefined('arguments.company_id') and len(arguments.company_id) and len(arguments.company) and member_type is 'partner') or (isdefined("arguments.member_cat_type") and len(arguments.member_cat_type) and listfirst(arguments.member_cat_type,'-') eq 1) or (isdefined("arguments.pos_code") and len(arguments.pos_code) and len(arguments.pos_code_text))>
				TO_CMP_ID = #arguments.COMPANY_ID# AND
			<cfelseif (isdefined('arguments.consumer_id') and  len(arguments.consumer_id) and len(arguments.company) and member_type is 'consumer') or (isdefined("arguments.member_cat_type") and len(arguments.member_cat_type) and listfirst(arguments.member_cat_type,'-') eq 2)>
				TO_CONSUMER_ID = #arguments.consumer_id# AND
			<cfelseif isdefined('arguments.employee_id') and  len(arguments.employee_id) and len(arguments.company) and member_type is 'employee'>
				TO_EMPLOYEE_ID = #arguments.employee_id# AND
			</cfif>
			<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
				ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
			<cfelseif isdefined("arguments.acc_type_id") and len(arguments.acc_type_id) and arguments.acc_type_id neq 0>
				ACC_TYPE_ID = #arguments.acc_type_id# 
            </cfif>
            <cfif (isdefined('arguments.date1') and len(arguments.date1))>
                AND  CR.ACTION_DATE >= #arguments.date1# 
            </cfif> 
            <cfif (isdefined('arguments.date2') and len(arguments.date2))>
                AND CR.ACTION_DATE <= #arguments.date2#
            </cfif>     
			 CR.TO_EMPLOYEE_ID = #session.ep.userid#
		ORDER BY 
			ACTION_DATE
        </cfquery>
        
        <cfreturn GET_CARI_ROWS>
    </cffunction>
</cfcomponent>