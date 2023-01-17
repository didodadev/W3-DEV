<cfquery name="get_payment_request" datasource="#dsn#">
	SELECT 
		*
	FROM 
		CORRESPONDENCE_PAYMENT
	<cfif isdefined('attributes.search_liste')>
	WHERE
		ID IS NOT NULL AND
		PERIOD_ID = #session.ep.period_id#
		<cfif (attributes.status eq 0) or (attributes.status eq 1)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
		<cfelseif len(attributes.status) and (attributes.status eq 2)>
			AND STATUS IS NULL 
		</cfif>	
		<cfif len(attributes.keyword)>AND SUBJECT LIKE '%#attributes.keyword#%'</cfif>
		<cfif isdate(attributes.tarih_)>AND DUEDATE >= #attributes.tarih_#</cfif>	
		<cfif isdate(attributes.tarih2_)>AND DUEDATE <= #attributes.tarih2_#</cfif>	
		<cfif isdate(attributes.startdate)>AND RECORD_DATE >= #attributes.startdate#</cfif>
		<cfif isdate(attributes.finishdate)>AND RECORD_DATE < #CreateODBCDateTime(DATEADD("d",1,attributes.finishdate))#</cfif>			
		<cfif len(attributes.cari_emp) and (attributes.cari_emp eq 1)>AND TO_EMPLOYEE_ID IS NULL
		<cfelseif len(attributes.cari_emp) and (attributes.cari_emp eq 2)>AND TO_EMPLOYEE_ID IS NOT NULL
		</cfif>
	<cfelseif isdefined('attributes.id') and isnumeric(attributes.id)>
		WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	</cfif>
	<cfif attributes.fuseaction contains 'correspondence' and isdefined("attributes.is_userid")><!--- yazismalardan geliyorsa kaydedene gore getiriyor FB 20080219 --->
		AND RECORD_EMP = #session.ep.userid#
	</cfif>
	<cfif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "employee") and len(attributes.search_name) and isdefined("attributes.search_name")>
	AND TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#">
	<cfelseif isdefined("attributes.search_type") and len(attributes.search_type) and (attributes.search_type is "partner") and len(attributes.search_name) and isdefined("attributes.search_name")>
	AND TO_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_id#">
	</cfif>
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
