<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #SESSION.EP.POSITION_CODE#	
					)
	ORDER BY BRANCH_ID
</cfquery>
<cfif get_branchs.recordcount>
	<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfelse>
	<cfset branch_id_list = 0>
</cfif>
<cfif isdefined("attributes.tarih_egitim_for_query")>
	<cf_date tarih="attributes.tarih_egitim_for_query">
</cfif>
<cfquery name="GET_TR" datasource="#DSN#">
	SELECT DISTINCT

		FINISH_DATE = CASE DATEPART(HH,FINISH_DATE) WHEN 22 THEN DATEADD(HH,#session.ep.time_zone#,FINISH_DATE) WHEN 23 THEN DATEADD(hh,#session.ep.time_zone#,FINISH_DATE)
		ELSE FINISH_DATE END,
		ORGANIZATION_ID,
		START_DATE,
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
	(
		ORGANIZATION_ID IS NOT NULL
		AND 
		(
			DATEPART(MM,START_DATE) <=#ay#
			AND DATEPART(yyyy,START_DATE) <=#yil#
			AND DATEPART(dd,START_DATE) <= #gun#
			AND DATEPART(MM,FINISH_DATE) >=#ay#
			AND DATEPART(yyyy,FINISH_DATE) >=#yil#
			
		 )
		 <cfif isdefined("attributes.tarih_egitim_for_query") >
		 OR (
			FINISH_DATE>=#attributes.tarih_egitim_for_query# AND FINISH_DATE < #DATEADD('d',1,attributes.tarih_egitim_for_query)#
			OR
			START_DATE>=#attributes.tarih_egitim_for_query# AND START_DATE < #DATEADD('d',1,attributes.tarih_egitim_for_query)#
			)
		 </cfif>
	 )
	<cfif isdefined("attributes.organization_cat_id") AND len(attributes.organization_cat_id)>
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

<cfoutput query="get_tr">
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
