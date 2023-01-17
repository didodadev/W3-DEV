<cfset bu_sene=dateformat(now(),'yyyy')>
<cfif len(attributes.month_id)>
	<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
		<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
		<cfset attributes.finishdate="#DaysInMonth(createdate(attributes.yil_src,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
	<cfelse>
		<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#bu_sene#">
		<cfset attributes.finishdate="#DaysInMonth(createdate(bu_sene,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#bu_sene#">
	</cfif>
<cfelse>
<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
	<cfset attributes.startdate="01/01/#attributes.yil_src#">
	<cfset attributes.finishdate="31/12/#attributes.yil_src#">
<cfelse>
	<cfset attributes.startdate="01/01/#bu_sene#">
	<cfset attributes.finishdate="31/12/#bu_sene#">
</cfif>
</cfif>
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>

<cfquery name="GET_ORGANIZATION" datasource="#DSN#">
	SELECT
		ORGANIZATION_ID,
		START_DATE,
		FINISH_DATE,
		ORGANIZATION_HEAD,
		PP.CONSUMER_ID,
		PP.COMPANY_ID,
		PP.OUTSRC_PARTNER_ID,
		PP.PARTNER_ID
	FROM
		ORGANIZATION
			LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = ORGANIZATION.PROJECT_ID
	WHERE
	<cfif len(attributes.is_active)>
        ORGANIZATION.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#"> AND
	</cfif>
		START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">		
	<cfif isDefined("attributes.organization_id") and len(attributes.organization_id)>
		AND ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND (ORGANIZATION_HEAD LIKE '%#attributes.keyword#%' OR CLASS_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
	</cfif>
	 <cfif isdefined("attributes.organization_cat_id") and len(attributes.organization_cat_id)>
	 	AND ORGANIZATION_CAT_ID = #attributes.organization_cat_id#
	</cfif>
	<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and len(attributes.emp_par_name)>
		AND ORGANIZER_EMP = #attributes.emp_id#
	 <cfelseif isdefined("attributes.par_id") and len(attributes.par_id) and len(attributes.emp_par_name)>
		AND ORGANIZER_PAR = #attributes.par_id#
	 <cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id) and len(attributes.emp_par_name)>
		AND ORGANIZER_CONS = #attributes.cons_id#
	 </cfif>
</cfquery>

<cfset company_id_list = "">
<cfset consumer_id_list = "">

<cfoutput query="get_organization">
	<cfif len(partner_id) and not listfind(company_id_list,partner_id)>
		<cfset company_id_list=listappend(company_id_list,partner_id)>
	<cfelseif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
		<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
	</cfif>
	<cfif len(outsrc_partner_id) and not listfind(company_id_list,outsrc_partner_id)>
		<cfset company_id_list=listappend(company_id_list,outsrc_partner_id)>
	</cfif>
</cfoutput>

<cfif len(company_id_list)>
	<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
		SELECT
			C.NICKNAME,
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			CP.PARTNER_ID
		FROM 
			COMPANY_PARTNER CP,
			COMPANY C
		WHERE 
			CP.PARTNER_ID IN (#company_id_list#) 
			AND CP.COMPANY_ID = C.COMPANY_ID
		ORDER BY
			CP.PARTNER_ID
	</cfquery>
	<cfset company_id_list=listsort(listdeleteduplicates(valuelist(GET_PARTNER_DETAIL.PARTNER_ID,',')),'numeric','ASC',',')>
</cfif>

<cfif len(consumer_id_list)>
	<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
		SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
	</cfquery>
	<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(GET_CONSUMER_DETAIL.CONSUMER_ID,',')),'numeric','ASC',',')>
</cfif>
