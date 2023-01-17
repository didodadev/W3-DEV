<cf_xml_page_edit fuseact="myhome.welcome">
<cfif not isdefined("attributes.to_day") or not len(attributes.to_day)>
	<cfset attributes.to_day= now()>
	<cfset attributes.to_day1=dateadd("D",-7,attributes.to_day)>
</cfif>

<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>

<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
	SELECT 
		O.ORDER_ID,
		O.COMPANY_ID,
        O.PARTNER_ID,
        O.CONSUMER_ID,
        O.IS_INSTALMENT,
        O.ORDER_HEAD,
        O.ORDER_DATE,
		O.ORDER_NUMBER,
		ISNULL(O.TAXTOTAL,0) as TAXTOTAL,
		ISNULL(O.GROSSTOTAL,0) as GROSSTOTAL,
		ISNULL(O.NETTOTAL,0) as NETTOTAL,
		ISNULL(O.OTHER_MONEY_VALUE,0) AS OTHER_MONEY_VALUE,
		ISNULL(O.OTHER_MONEY,'#session.ep.money#') AS OTHER_MONEY,
		CMP.NICKNAME,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CNS.CONSUMER_NAME,
		CNS.CONSUMER_SURNAME
	FROM 
		ORDERS O
		LEFT JOIN #dsn_alias#.COMPANY CMP ON CMP.COMPANY_ID = O.COMPANY_ID
		LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = O.PARTNER_ID
		LEFT JOIN #dsn_alias#.CONSUMER CNS ON CNS.CONSUMER_ID = O.CONSUMER_ID
	WHERE 
		O.ORDER_STATUS = 1 AND
        <cfif isdefined("x_select_order") and x_select_order eq 2>
			O.IS_PROCESSED = 1 AND
        <cfelseif isdefined("x_select_order") and x_select_order eq 1>
        	O.IS_PROCESSED = 0 AND
        </cfif>
		(( O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0 ) OR ( O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1 )) AND
        <cfif isdefined("x_select_order") and x_select_order neq 0>
			O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND 
			O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day1#"> AND
        <cfelse>
        	O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.to_day)#"> AND
			O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,attributes.to_day)#"> AND
        </cfif>  
        ISNULL(O.IS_INSTALMENT,0) = 0 
		<cfif session.ep.their_records_only eq 1>
			AND O.ORDER_EMPLOYEE_ID = #session.ep.userid#
		</cfif>
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				(O.CONSUMER_ID IS NULL AND O.COMPANY_ID IS NULL) 
				OR (O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
		</cfif>
	ORDER BY
		O.ORDER_DATE DESC
</cfquery>