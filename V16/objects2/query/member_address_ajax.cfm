<cfsetting showdebugoutput="no">
<cfif attributes._type is 'partner'>
	<cfquery name="GET_ADDRESS_" datasource="#DSN#">
		SELECT
			CB.COMPBRANCH__NAME AS ADRESS_NAME,
			CB.COMPBRANCH_ADDRESS ADDRESS,
			CB.COMPBRANCH_POSTCODE POSTCODE,
			CB.COUNTY_ID COUNTY,
			CB.CITY_ID CITY,
			CB.COUNTRY_ID COUNTRY,
			CB.SEMT SEMT,
			'' DISTRICT,
			'' MAIN_STREET,
			'' STREET,
			'' ADDRESS_DETAIL
		FROM	
			COMPANY_BRANCH CB,
			COMPANY C
		WHERE 
			CB.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes._id#"> AND
			CB.COMPANY_ID = C.COMPANY_ID AND
			CB.COMPBRANCH_STATUS = 1 AND
			CB.COMPBRANCH_ADDRESS IS NOT NULL AND
            (
            CB.COMPBRANCH__NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
            CB.COMPBRANCH_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
			CB.COMPBRANCH_POSTCODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
            CB.SEMT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> 
            )
	UNION ALL

		SELECT
			'' ADRESS_NAME,
			COMPANY_ADDRESS ADDRESS,
			COMPANY_POSTCODE POSTCODE,
			COUNTY COUNTY,
			CITY CITY,
			COUNTRY COUNTRY,
			SEMT SEMT,
			'' DISTRICT,		
			'' MAIN_STREET,
			'' STREET,
			'' ADDRESS_DETAIL
		FROM 
			COMPANY
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes._id#"> AND
			COMPANY_STATUS = 1 AND
            (
            COMPANY_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
			COMPANY_POSTCODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
            SEMT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
            )
	</cfquery>
<cfelse>
	<cfquery name="GET_ADDRESS_" datasource="#DSN#">
		SELECT 
			*
		FROM
		(
			SELECT
				CB.CONTACT_NAME AS ADRESS_NAME,
				CB.CONTACT_ADDRESS ADDRESS,
				CB.CONTACT_POSTCODE POSTCODE,
				CB.CONTACT_COUNTY_ID COUNTY,
				CB.CONTACT_CITY_ID CITY,
				CB.CONTACT_COUNTRY_ID COUNTRY,
				CB.CONTACT_SEMT SEMT,
				CB.CONTACT_DISTRICT_ID DISTRICT,			
				CONTACT_MAIN_STREET  MAIN_STREET,
				CONTACT_STREET  STREET,
				CONTACT_DOOR_NO ADDRESS_DETAIL,												
				1 AS ADR_TYPE
			FROM	
				CONSUMER_BRANCH CB,
				CONSUMER C
			WHERE 
				CB.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes._id#"> AND
				CB.CONSUMER_ID = C.CONSUMER_ID AND
				CB.STATUS = 1 AND
				CB.CONTACT_ADDRESS IS NOT NULL AND
                (
                CB.CONTACT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CONTACT_DOOR_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CB.CONTACT_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CB.CONTACT_POSTCODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CB.CONTACT_SEMT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CONTACT_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                CONTACT_MAIN_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
                )
		UNION ALL		
			SELECT
				'Ev' AS ADRESS_NAME,
				HOMEADDRESS ADDRESS,
				HOMEPOSTCODE POSTCODE,
				HOME_COUNTY_ID COUNTY,
				HOME_CITY_ID CITY,
				HOME_COUNTRY_ID COUNTRY,
				HOMESEMT SEMT,
				HOME_DISTRICT_ID DISTRICT,
				HOME_MAIN_STREET  MAIN_STREET,
				HOME_STREET  STREET,
				HOME_DOOR_NO ADDRESS_DETAIL,	
				2 AS ADR_TYPE
			FROM 
				CONSUMER
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes._id#"> AND
				CONSUMER_STATUS = 1 AND
                (
                HOME_DOOR_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                HOMEADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                HOMEPOSTCODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                HOMESEMT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR 
                HOME_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR 
                HOME_MAIN_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
                )
		UNION ALL
			SELECT
				'Is' AS ADRESS_NAME,
				WORKADDRESS ADDRESS,
				WORKPOSTCODE POSTCODE,
				WORK_COUNTY_ID COUNTY,
				WORK_CITY_ID CITY,
				WORK_COUNTRY_ID COUNTRY,
				WORKSEMT SEMT,
				WORK_DISTRICT_ID DISTRICT,
				WORK_MAIN_STREET  MAIN_STREET,
				WORK_STREET  STREET,
				WORK_DOOR_NO ADDRESS_DETAIL,
				3 AS ADR_TYPE
			FROM 
				CONSUMER
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes._id#"> AND
				CONSUMER_STATUS = 1 AND
                (
                WORK_DOOR_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                WORKADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                WORKPOSTCODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR
                WORKSEMT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR 
                WORK_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%"> OR 
                WORK_MAIN_STREET LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_#%">
                )
		)T1 
		ORDER BY
			ADRESS_NAME
	</cfquery>
</cfif>

<cfquery name="GET_CITY_ALL" datasource="#dsn#">
	SELECT * FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfquery name="GET_COUNTRY_ALL" datasource="#dsn#">
	SELECT * FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfset city_id_list="">
<cfset county_id_list="">
<cfset country_id_list="">
<table>
<cfif GET_ADDRESS_.RECORDCOUNT>
	<cfset city_id_list=listsort(valuelist(GET_ADDRESS_.CITY,','),'numeric','ASC',',')>
	<cfset county_id_list=listsort(valuelist(GET_ADDRESS_.COUNTY,','),'numeric','ASC',',')>
	<cfset country_id_list=listsort(valuelist(GET_ADDRESS_.COUNTRY,','),'numeric','ASC',',')>
	<cfif listlen(city_id_list)>
		<cfquery name="GET_CITY" dbtype="query">
			SELECT CITY_ID,CITY_NAME FROM GET_CITY_ALL WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
		</cfquery>
		<cfset city_list_id=valuelist(GET_CITY.CITY_ID,',')>
		<cfset city_name_list=valuelist(GET_CITY.CITY_NAME,',')>
	</cfif>
	<cfif listlen(county_id_list)>
		<cfquery name="GET_COUNTY" datasource="#dsn#">
			SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
		</cfquery>
		<cfset county_list_id=valuelist(GET_COUNTY.COUNTY_ID,',')>
		<cfset county_name_list=valuelist(GET_COUNTY.COUNTY_NAME,',')>
	</cfif>
	<cfif listlen(country_id_list)>
		<cfquery name="GET_COUNTRY" dbtype="query">
			SELECT COUNTRY_ID,COUNTRY_NAME FROM GET_COUNTRY_ALL WHERE COUNTRY_ID IN (#country_id_list#) ORDER BY COUNTRY_ID
		</cfquery>
		<cfset country_list_id=valuelist(GET_COUNTRY.COUNTRY_ID,',')>
		<cfset country_name_list=valuelist(GET_COUNTRY.COUNTRY_NAME,',')>
	</cfif>

	<cfoutput query="GET_ADDRESS_">
    <tr>
        <td>
          <cfif len(address_detail)>
            <cfif len(main_street)>
                <cfset main_street_ = '#main_street# Cad.'>
            <cfelse>
                <cfset main_street_ =''>
            </cfif>
            <cfif len(street)>
                <cfset street_ = '#street# Sok.'>
            <cfelse>
                <cfset street_ =''>
            </cfif>
            <cfset address_ = '#main_street_# #street_# #address_detail#'>
          <cfelse>
            <cfset address_ = ADDRESS>
          </cfif>
          <cfif len(trim(address_))>
            <cfif len(district)>
                <cfquery name="GET_DIS" datasource="#DSN#">
                    SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#district#">
                </cfquery>
                <cfset home_dis = '#get_dis.district_name# '>
            <cfelse>
                <cfset home_dis = ''>
            </cfif>
          <cfset adres_var_ = 1>
            <input type="radio" name="ship_address_row" id="ship_address_row" class="radio_frame" value="#currentrow#" onClick="yeni_adres(this);" <cfif currentrow eq 1>checked</cfif>>
            <input type="hidden" name="ship_address#currentrow#" id="ship_address#currentrow#" value="<cfif len(adress_name)>(#adress_name#)-</cfif>#address_# #POSTCODE# #SEMT# <cfif len(COUNTY)>#listgetat(county_name_list,listfind(county_list_id,COUNTY,','),',')# / </cfif><cfif len(CITY)>#listgetat(city_name_list,listfind(city_list_id,CITY,','),',')#</cfif> <cfif len(COUNTRY)>#listgetat(country_name_list,listfind(country_list_id,COUNTRY,','),',')#</cfif>">
            <input type="hidden" name="ship_address_city#currentrow#" id="ship_address_city#currentrow#" value="#CITY#">
            <input type="hidden" name="ship_address_county#currentrow#" id="ship_address_county#currentrow#" value="#COUNTY#">
            <cfif len(adress_name)><b>(#adress_name#)&nbsp;&nbsp;&nbsp;</b></cfif><cfif len(home_dis)>#home_dis# </cfif>#address_# #POSTCODE# #SEMT# <cfif len(COUNTY)>#listgetat(county_name_list,listfind(county_list_id,COUNTY,','),',')# / </cfif><cfif len(CITY)>#listgetat(city_name_list,listfind(city_list_id,CITY,','),',')#</cfif> <cfif len(COUNTRY)>#listgetat(country_name_list,listfind(country_list_id,COUNTRY,','),',')#</cfif>
         </cfif>
        </td>
    </tr>
    </cfoutput>
<cfelse>
	<tr>
    	<td><cf_get_lang_main no='72.Kayit Yok'>!</td>
    </tr>
</cfif>
</table>

