<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP WITH (NOLOCK),
		SETUP_PERIOD SP WITH (NOLOCK),
		EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK),
		OUR_COMPANY O WITH (NOLOCK)
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID 
		<cfif isdefined('session.ep.userid')>
			AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
</cfquery>
<cfquery name="GET_COMP_CAT" datasource="#DSN#">
	SELECT 
		DISTINCT
		CT.COMPANYCAT_ID, 
		CT.COMPANYCAT
	FROM
		GET_MY_COMPANYCAT CT WITH (NOLOCK),
		COMPANY_CAT_OUR_COMPANY CO WITH (NOLOCK)
	WHERE
		<cfif isdefined('session.ep.userid')>
			CT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			CT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfelseif isDefined('session.pp.userid')>
			CT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND	
		<cfelseif isDefined('session.pda.userid')>
			CT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND	
		</cfif>
		CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
		<cfif get_our_companies.recordcount>
			CO.OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
		<cfelse>
			1 = 2	
		</cfif>
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_PARTNERS" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER.TITLE,
		COMPANY.FULLNAME,
		COMPANY.NICKNAME,
		COMPANY.COMPANY_ID,
		COMPANY_CAT.COMPANYCAT,
		COMPANY.COMPANY_POSTCODE,
		COMPANY.COMPANY_ADDRESS,
		COMPANY.COUNTY,
		COMPANY.CITY,
		COMPANY.MEMBER_CODE
	FROM 
		COMPANY WITH (NOLOCK),
		COMPANY_PARTNER WITH (NOLOCK),
		COMPANY_CAT WITH (NOLOCK)
	WHERE
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
		COMPANY.COMPANY_STATUS = 1
        <cfif isDefined("attributes.type") and attributes.type eq 2>
            AND 
            COMPANY.COMPANY_ID IN 
            (
                SELECT 
                    CP.COMPANY_ID
                FROM
                    COMPANY_PERIOD CP
                WHERE
                    CP.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">) AND
                    COMPANY.COMPANY_ID = CP.COMPANY_ID
            ) AND
			(
            	COMPANY.HIERARCHY_ID = <cfif isdefined("session.ww.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif> 
				<cfif isdefined('session.pp.userid') >
					OR COMPANY.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM WORKGROUP_EMP_PAR WEP WHERE WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
				</cfif>
			) 
		<cfelse>
			<cfif get_comp_cat.recordcount>
                AND COMPANY.COMPANYCAT_ID IN (#valuelist(get_comp_cat.companycat_id,',')#)
            </cfif>
            <cfif isDefined("attributes.type") and (attributes.type eq 1)>
                AND COMPANY.ISPOTANTIAL = 1
            <cfelseif isDefined("attributes.type") and (attributes.type eq 0)>
                AND COMPANY.ISPOTANTIAL = 0
            </cfif>
            <cfif isdefined('attributes.companycat') and len(attributes.companycat)>
                AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat#">
            <cfelseif isDefined("attributes.companycat_id") and len(attributes.companycat_id)>
                AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
            </cfif>
            <cfif isdefined('attributes.company_sector') and len(attributes.company_sector)>AND COMPANY.SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_sector#"></cfif>
            <cfif isdefined('attributes.customer_value') and len(attributes.customer_value)>AND COMPANY.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#"></cfif>
            <cfif isdefined('attributes.sales_county') and len(attributes.sales_county)>AND COMPANY.SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#"></cfif>
            <cfif isDefined("attributes.company_id") >AND COMPANY_PARTNER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND 
                (	
                	COMPANY.FULLNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
                    COMPANY.NICKNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
                    COMPANY.OZEL_KOD LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' OR
                    COMPANY.MEMBER_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#'
                )
            </cfif>
            <cfif len(attributes.keyword_partner)>
                AND COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%'
            </cfif>
            <!--- satinalma teklifi-basketteki urunlerin iliskili uyeleri --->
            <cfif isdefined("attributes.comp_id_list") and len(attributes.comp_id_list) and isdefined("attributes.related_comp_id") and attributes.related_comp_id eq 1>
                AND COMPANY.COMPANY_ID IN (#attributes.comp_id_list#)
            <!---<cfelseif isdefined("attributes.related_comp_id") and attributes.related_comp_id eq 1>
                1 = 0 AND--->
			</cfif>
        </cfif>
	ORDER BY
		COMPANY.NICKNAME,			
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
</cfquery>
