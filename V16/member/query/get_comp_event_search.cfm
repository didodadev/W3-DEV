<cfquery name="get_company_partners" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY.FULLNAME
	FROM 
		COMPANY_PARTNER,
		COMPANY
	WHERE 
		COMPANY.COMPANY_ID = #attributes.COMPANY_ID# AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
</cfquery>
<cfif isdate(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif isdate(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
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
	<cfif len(attributes.eventcat_id)>
		AND EVENT.EVENTCAT_ID = #attributes.EVENTCAT_ID#
	</cfif>		
	<cfif len(attributes.keyword)>
		AND EVENT.EVENT_HEAD LIKE '%#attributes.keyword#%'
	</cfif>
	<!---<cfif isdate(attributes.startdate)>
		AND #createdate(year(startdate),month(startdate),day(startdate))# <= #attributes.startdate#
	</cfif>
	<cfif isdate(attributes.finishdate)>
		AND #createdate(year(finishdate),month(finishdate),day(finishdate))# >= #attributes.finishdate#
	</cfif>--->
		<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE) and isdate(attributes.STARTDATE) AND isdate(attributes.FINISHDATE)>
		AND
		(
			(
			STARTDATE >= #attributes.STARTDATE# AND
			STARTDATE < #DATEADD("d",1,attributes.FINISHDATE)#
			)
		OR
			(
			STARTDATE<= #attributes.STARTDATE# AND
			FINISHDATE>= #attributes.STARTDATE#
			)
		)
		<cfelseif len(attributes.STARTDATE) and isdate(attributes.STARTDATE)>
		AND
		(
		STARTDATE  >= #attributes.STARTDATE#
		OR
			(
			STARTDATE < #attributes.STARTDATE# AND
			FINISHDATE  >= #attributes.STARTDATE#
			)
		)
		<cfelseif len(attributes.FINISHDATE)>
		AND
		(
		FINISHDATE < #DATEADD("d",1,attributes.FINISHDATE)#
		OR
			(
			STARTDATE  <= #DATEADD("d",1,attributes.FINISHDATE)# AND
			FINISHDATE > #DATEADD("d",1,attributes.FINISHDATE)#
			)
		)
		</cfif>
	<cfif len(valuelist(get_company_partners.PARTNER_ID))>
		AND 
		(
			RECORD_PAR IN (#valuelist(get_company_partners.PARTNER_ID)#)
			OR
			UPDATE_PAR IN (#valuelist(get_company_partners.PARTNER_ID)#)
		<cfloop list="#valuelist(get_company_partners.PARTNER_ID)#" index="get_company_partners_PARTNER_ID">
			OR EVENT_TO_PAR LIKE '%,#get_company_partners_PARTNER_ID#,%'
			OR EVENT_CC_PAR LIKE '%,#get_company_partners_PARTNER_ID#,%'
		</cfloop>
		)
	</cfif>
	ORDER BY
		STARTDATE DESC
</cfquery>
