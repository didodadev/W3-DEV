<!---  <cfdump var="#attributes#"><cfabort>  --->
<cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="GET_SERVICE_REPORT" datasource="#DSN3#">
	SELECT
		SCR.CARE_DATE,
		SCR.COMPANY_PARTNER_TYPE,
		SCR.COMPANY_PARTNER_ID,
		SCR.CARE_CAT,
		SCR.SERVICE_SUBSTATUS,
		SCR.CONTRACT_HEAD,
		SCR.SERIAL_NO,
		SCR.CARE_FINISH_DATE,
		SCR.CARE_REPORT_ID,
		P.PRODUCT_NAME
	FROM
		SERVICE_CARE_REPORT SCR,
		PRODUCT  P
	WHERE
		P.PRODUCT_ID=SCR.PRODUCT_ID
		<cfif len(attributes.keyword)>
			AND (CONTRACT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR P.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI )
		</cfif>
		<cfif len(attributes.service_care)>
			AND SCR.CARE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_care#">
		</cfif>
		<cfif len(attributes.start_date)>
			AND SCR.CARE_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
			AND SCR.CARE_DATE <= #attributes.finish_date#
		</cfif>
		<cfif len(attributes.task_employee_id) and len(attributes.task_person_name)>
			AND	SCR.EMPLOYEE1_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_employee_id#">
		</cfif>
		<cfif len(attributes.task_employee_id2) and len(attributes.task_person_name2)>
			AND	SCR.EMPLOYEE2_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_employee_id2#">
		</cfif>
		<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
			AND SCR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_name") and len(attributes.member_name) and (attributes.member_type is 'partner')> 
			AND SCR.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name) and (attributes.member_type is 'consumer')> 
			AND SCR.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.service_substatus_id") and len(attributes.service_substatus_id)> 
			AND SCR.SERVICE_SUBSTATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_substatus_id#">
		</cfif>
	ORDER BY
		SCR.CONTRACT_HEAD
</cfquery>

