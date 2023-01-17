<cf_xml_page_edit fuseact="salesplan.popup_add_sales_zones_team" is_multi_page="1">
<cfif xml_select_upper_team>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT DISTINCT
            UST_TAKIM.TEAM_ID, 
            UST_TAKIM.TEAM_NAME, 
            UST_TAKIM.SALES_ZONES, 
            UST_TAKIM.OZEL_KOD, 
            UST_TAKIM.RESPONSIBLE_BRANCH_ID, 
            UST_TAKIM.LEADER_POSITION_CODE, 
            UST_TAKIM.LEADER_POSITION_ROLE_ID, 
            UST_TAKIM.COUNTRY_ID, 
            UST_TAKIM.CITY_ID,
            UST_TAKIM.COUNTY_ID, 
            UST_TAKIM.DISTRICT_ID, 
            UST_TAKIM.RECORD_DATE, 
            UST_TAKIM.RECORD_EMP, 
            UST_TAKIM.RECORD_IP, 
            UST_TAKIM.UPDATE_DATE, 
            UST_TAKIM.UPDATE_EMP, 
            UST_TAKIM.UPDATE_IP, 
            UST_TAKIM.COMPANY_CAT_IDS, 
            UST_TAKIM.CONSUMER_CAT_IDS,
            UST_TAKIM.UPPER_TEAM_ID
            <cfif isdefined("attributes.upper_filter") and attributes.upper_filter neq 1>
            ,ALT_TAKIM.TEAM_ID AS TEAM_ID2, 
            ALT_TAKIM.TEAM_NAME AS TEAM_NAME2, 
            ALT_TAKIM.SALES_ZONES AS SALES_ZONES2, 
            ALT_TAKIM.OZEL_KOD AS OZEL_KOD2, 
            ALT_TAKIM.RESPONSIBLE_BRANCH_ID AS RESPONSIBLE_BRANCH_ID2, 
            ALT_TAKIM.LEADER_POSITION_CODE AS LEADER_POSITION_CODE2, 
            ALT_TAKIM.LEADER_POSITION_ROLE_ID AS LEADER_POSITION_ROLE_ID2, 
            ALT_TAKIM.COUNTRY_ID AS COUNTRY_ID2, 
            ALT_TAKIM.CITY_ID AS CITY_ID2,
            ALT_TAKIM.COUNTY_ID AS COUNTY_ID2, 
            ALT_TAKIM.DISTRICT_ID AS DISTRICT_ID2, 
            ALT_TAKIM.RECORD_DATE AS RECORD_DATE2, 
            ALT_TAKIM.RECORD_EMP AS RECORD_EMP2, 
            ALT_TAKIM.RECORD_IP AS RECORD_IP2, 
            ALT_TAKIM.UPDATE_DATE AS UPDATE_DATE2, 
            ALT_TAKIM.UPDATE_EMP AS UPDATE_EMP2, 
            ALT_TAKIM.UPDATE_IP AS UPDATE_IP2, 
            ALT_TAKIM.COMPANY_CAT_IDS AS COMPANY_CAT_IDS2, 
            ALT_TAKIM.CONSUMER_CAT_IDS AS CONSUMER_CAT_IDS2,
            ALT_TAKIM.UPPER_TEAM_ID AS UPPER_TEAM_ID2
            </cfif> 
         FROM 
            SALES_ZONES_TEAM ALT_TAKIM RIGHT JOIN
            SALES_ZONES_TEAM UST_TAKIM
        ON
            ALT_TAKIM.UPPER_TEAM_ID = UST_TAKIM.TEAM_ID
        WHERE 
            UST_TAKIM.SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND UST_TAKIM.UPPER_TEAM_ID IS NULL 
        ORDER BY 
            UST_TAKIM.TEAM_NAME
    </cfquery>
<cfelse>
    <cfquery name="GET_SALES_ZONES_TEAM" datasource="#DSN#">
        SELECT
            TEAM_ID, 
            TEAM_NAME, 
            SALES_ZONES, 
            OZEL_KOD, 
            RESPONSIBLE_BRANCH_ID, 
            LEADER_POSITION_CODE, 
            LEADER_POSITION_ROLE_ID, 
            COUNTRY_ID, 
            CITY_ID,
            COUNTY_ID, 
            DISTRICT_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            COMPANY_CAT_IDS, 
            CONSUMER_CAT_IDS,
            UPPER_TEAM_ID
        FROM 
            SALES_ZONES_TEAM
        WHERE 
            SALES_ZONES = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> 
        ORDER BY 
            TEAM_NAME
    </cfquery>
</cfif>
<cfinclude template="../query/get_sales_zone.cfm">
<cfquery name="GET_SALES_SUB_ZONE" datasource="#DSN#">
	SELECT 
		SZ_NAME, 
		SZ_ID,
		SZ_HIERARCHY,
		IS_ACTIVE,
		RESPONSIBLE_BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SALES_ZONES,
		BRANCH B
	WHERE 
		SZ_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#"> AND 
		SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_zone.sz_hierarchy#.%"> AND
		B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID
</cfquery>
<cf_ajax_list>
    <tbody>
		<cfif get_sales_sub_zone.recordcount and not listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_sub_zone_based')>
        	<tr><td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_check_sales_quote_sub_zone_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#&sz_hierarchy=#get_sales_zone.sz_hierarchy#</cfoutput>');"><cf_get_lang dictionary_id='41468.Alt Bölge ve Şube Satış Hedefleri'></a></td></tr>
        </cfif>
        <cfif get_sales_zones_team.recordcount>
			<cfif not listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_team_based')>
                <tr><td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_check_sales_quote_team_based&team_id=#sz_id#-#get_sales_zone.responsible_branch_id#&is_submit=1</cfoutput>','wide');"><cf_get_lang dictionary_id='41467.Takım Hedefleri'></a></td></tr>
            </cfif>
            <cfif not listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_ims_based')>
                <tr><td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#</cfoutput>','wide');"><cf_get_lang dictionary_id='41466.Mikro Bölge Hedefleri'></a></td></tr>
            </cfif>
            <cfif not listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_employee_based')>
                <tr><td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_check_sales_quote_employee_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#</cfoutput>','wide');"><cf_get_lang dictionary_id='41465.Satıcı Hedefleri'></a></td></tr>
            </cfif>
            <cfif not listfindnocase(denied_pages,'salesplan.popup_check_sales_quote_customer_based')>
                <tr><td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=salesplan.popup_check_sales_quote_customer_based&sales_zone_id=#sz_id#&branch_id=#get_sales_zone.responsible_branch_id#</cfoutput>','wide');"><cf_get_lang dictionary_id='41470.Müşteri Hedefleri'></a></td></tr>
            </cfif>
        </cfif>
    </tbody>
</cf_ajax_list>
