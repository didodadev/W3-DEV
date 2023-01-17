<cfparam name="attributes.quote_year" default= '#session.ep.period_year#'>
<cfset sub_zone_list="">
<cfquery name="get_quote_teams" datasource="#dsn#">
	SELECT
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES,
		BRANCH B
	WHERE 
		SZ_ID <> #attributes.sales_zone_id#	AND 
		SZ_HIERARCHY+'.' LIKE '#attributes.sz_hierarchy#%' AND
		B.BRANCH_ID=SALES_ZONES.RESPONSIBLE_BRANCH_ID
</cfquery>
<cfoutput query="get_quote_teams">
	<cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
		<cfset sub_zone_list=listappend(sub_zone_list,get_quote_teams.SZ_ID)>
	</cfif>
</cfoutput>
<cfif len(sub_zone_list)>
	<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#dsn#">
		SELECT 
			SQ.SALES_QUOTE_ID
		FROM 
			SALES_QUOTES_GROUP SQ
		WHERE
			QUOTE_TYPE = 1 AND
			<cfif isdefined("attributes.quote_year")>
			SQ.QUOTE_YEAR = #attributes.quote_year# AND
			<cfelse>
			SQ.QUOTE_YEAR = #session.ep.period_year# AND
			</cfif>
			SQ.SALES_ZONE_ID IN (#sub_zone_list#)	
	</cfquery>
	<cfset sales_quotes=valuelist(GET_SALES_QUOTE_ZONE.SALES_QUOTE_ID)>	
<cfelse>
	<cfset GET_SALES_QUOTE_ZONE.recordcount=0>
	<cfset sales_quotes="">
</cfif>
<cfif GET_SALES_QUOTE_ZONE.recordcount>
	<cflocation url="#request.self#?fuseaction=salesplan.popup_upd_sales_quote_sub_zone_based&sales_zone_id=#attributes.sales_zone_id#&sub_zone_ids=#sub_zone_list#&SALES_QUOTES=#sales_quotes#&branch_id=#attributes.branch_id#&sz_hierarchy=#attributes.sz_hierarchy#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=salesplan.popup_add_sales_quote_sub_zone_based&sales_zone_id=#attributes.sales_zone_id#&sub_zone_ids=#sub_zone_list#&branch_id=#attributes.branch_id#&quote_year=#attributes.quote_year#&sz_hierarchy=#attributes.sz_hierarchy#" addtoken="no">
</cfif>
