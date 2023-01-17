<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfquery name="get_marketplace" datasource="#DSN2#">
	SELECT
		SHIP_ID,
		DEPARTMENT_IN,
		SHIP_NUMBER,
		COMPANY_ID,
		CONSUMER_ID,
		PARTNER_ID,
		SHIP_DATE,
		LOCATION_IN
	FROM 
		SHIP 
	WHERE 
		SHIP_TYPE = 761 AND 
		IS_SHIP_IPTAL = 0 AND
		SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#session.ep.period_id#)
		<cfif len(attributes.company) and len(attributes.company_id) >
			AND COMPANY_ID=	#attributes.company_id#
		</cfif>
		<cfif  len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
			AND CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif isdate(attributes.start_date)> 
			AND SHIP_DATE >= #attributes.start_date#
		</cfif> 
		<cfif isdate(attributes.finish_date)>
			AND SHIP_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department_txt)>
			AND	DEPARTMENT_IN=#attributes.department_id#
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND SHIP_NUMBER LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND DEPARTMENT_IN IN
				(
					SELECT 
						DEPARTMENT_ID
					FROM 
						#dsn_alias#.DEPARTMENT D
					WHERE
						D.BRANCH_ID=#listgetat(session.ep.user_location,2,'-')#
				)
		</cfif>
	ORDER BY
		SHIP_DATE DESC
</cfquery>
