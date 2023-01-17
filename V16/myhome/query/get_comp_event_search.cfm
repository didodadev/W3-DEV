<cfquery datasource="#DSN#" name="get_company_partners">
SELECT 
	COMPANY_PARTNER.PARTNER_ID,
	COMPANY.FULLNAME
FROM 
	COMPANY_PARTNER,
	COMPANY
WHERE 
	COMPANY.COMPANY_ID = #attributes.COMPANY_ID#
	AND
	COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
</cfquery>
<cfif isdefined("startdate") and len(startdate)>
	<cf_date tarih="startdate">
</cfif>
<cfif isdefined("finishdate") and len(finishdate)>
	<cf_date tarih="finishdate">
</cfif>
<cfquery name="GET_EVENT_SEARCH" datasource="#dsn#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID
		<cfif isDefined("attributes.eventcat_id") and len(attributes.eventcat_id)>AND EVENT.EVENTCAT_ID = #attributes.EVENTCAT_ID#</cfif>		
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>AND EVENT.EVENT_HEAD LIKE '%#attributes.keyword#%'</cfif>
		<cfif isdefined("STARTDATE") and len(STARTDATE) and isdefined("FINISHDATE") and len(FINISHDATE)>
		AND
		(
			(
			STARTDATE < #STARTDATE# AND
			FINISHDATE >= #STARTDATE#
			)
			OR
			(
			STARTDATE >= #STARTDATE# AND
			STARTDATE <= #FINISHDATE#
			)
		)
			<cfif len(STARTDATE) and len(FINISHDATE)>
				AND STARTDATE <= #FINISHDATE#
			</cfif>
		
			<cfif len(STARTDATE) and len(FINISHDATE)>
				AND FINISHDATE >= #STARTDATE#
			</cfif>
		</cfif>
		<cfif (get_company_partners.recordcount) or(ListLen(ListSort(get_company_partners.partner_id,'numeric'))) or (ListLen(ListSort(get_company_partners.partner_id,'numeric')))>
		AND 
		(
			<cfif get_company_partners.recordcount>
			(
				RECORD_PAR IN (#VALUELIST(get_company_partners.partner_id)#) OR
				UPDATE_PAR IN (#VALUELIST(get_company_partners.partner_id)#)
			)
			</cfif>
			<cfif ListLen(ListSort(get_company_partners.PARTNER_ID,'numeric'))>
				<cfloop list="#ListSort(valuelist(get_company_partners.partner_id),'numeric')#" index="get_company_partners_partner_id">
					OR EVENT_TO_PAR LIKE '%,#get_company_partners_PARTNER_ID#,%'
				</cfloop>
			</cfif>
			<cfif ListLen(ListSort(get_company_partners.PARTNER_ID,'numeric'))>
				<cfloop list="#ListSort(valuelist(get_company_partners.partner_id),'numeric')#" index="get_company_partners_partner_id">
					OR EVENT_CC_PAR LIKE '%,#get_company_partners_PARTNER_ID#,%'
				</cfloop>
			</cfif>
		)
		</cfif>
</cfquery>
