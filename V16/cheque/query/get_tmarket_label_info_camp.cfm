<cfif Len(attributes.company_id_list)>
	<cfset liste_com = attributes.company_id_list>
</cfif>
 <cfif Len(attributes.consumer_id_list)>
	<cfset liste_con = attributes.consumer_id_list>
</cfif>
<cfif isdefined("attributes.consumer_id_list") and Len(attributes.consumer_id_list)>
<cfquery name="get_camp_list_label_info" datasource="#dsn#">
		SELECT
			CONSUMER.CONSUMER_NAME AS NAME,
			CONSUMER.CONSUMER_SURNAME SURNAME,
			CONSUMER.COMPANY AS COMPANY,
			CONSUMER.HOMEADDRESS ADDRESS,
			CONSUMER.HOMEPOSTCODE AS POSCODE,
			CONSUMER.HOME_COUNTY_ID AS COUNTY,
			CONSUMER.HOME_CITY_ID AS CITY,
			CONSUMER.HOME_COUNTRY_ID AS COUNTRY,
			CONSUMER.HOMESEMT AS SEMT,
			CONSUMER.CONSUMER_HOMETELCODE TELCODE,
			CONSUMER.CONSUMER_HOMETEL TEL,
			CONSUMER.WORKADDRESS WORK_ADDRESS,
			CONSUMER.WORKPOSTCODE WORK_POSCODE,
			CONSUMER.WORK_COUNTY_ID WORK_COUNTY,
			CONSUMER.WORK_CITY_ID WORK_CITY,
			CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
			CONSUMER.WORKSEMT WORK_SEMT,
			CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
			CONSUMER.CONSUMER_WORKTEL WORK_TEL
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID IN (#liste_con#)
	</cfquery>
</cfif>	
<cfif isdefined("attributes.company_id_list") and Len(attributes.company_id_list)>
	<cfquery name="get_camp_list_label_info" datasource="#dsn#">
		SELECT
			COMPANY.FULLNAME AS NAME,
			COMPANY.COMPANY_ADDRESS ADDRESS,
			COMPANY.COMPANY_POSTCODE POSCODE,
			COMPANY.COUNTY COUNTY,
			COMPANY.CITY CITY,
			COMPANY.COUNTRY COUNTRY,
			COMPANY.SEMT SEMT,
			COMPANY.COMPANY_TELCODE TELCODE,
			COMPANY.COMPANY_TEL1 TEL,
			' ' SURNAME,
			' ' COMPANY,
			' ' WORK_ADDRESS,
			' ' WORK_POSCODE,
			' ' WORK_COUNTY,
			' ' WORK_CITY,
			' ' WORK_COUNTRY,
			' ' WORK_SEMT,
			' ' WORK_TELCODE,
			' ' WORK_TEL
		FROM
			COMPANY
		WHERE
			COMPANY.COMPANY_ID IN(#liste_com#)
	</cfquery>
</cfif>	  
<!--- <cfif isdefined("attributes.cont")>
	<cfif isdefined('attributes.consumer_ids') and len(attributes.consumer_ids) or isdefined('attributes.partner_ids') and len(attributes.partner_ids)>
    	<cfquery name="get_camp_list_label_info" datasource="#dsn#">
			<cfif len(attributes.consumer_ids)>
				SELECT
					CONSUMER.CONSUMER_NAME AS NAME,
					CONSUMER.CONSUMER_SURNAME SURNAME,
					CONSUMER.COMPANY AS COMPANY,
					CONSUMER.HOMEADDRESS ADDRESS,
					CONSUMER.HOMEPOSTCODE AS POSCODE,
					CONSUMER.HOME_COUNTY_ID AS COUNTY,
					CONSUMER.HOME_CITY_ID AS CITY,
					CONSUMER.HOME_COUNTRY_ID AS COUNTRY,
					CONSUMER.HOMESEMT AS SEMT,
					CONSUMER.CONSUMER_HOMETELCODE TELCODE,
					CONSUMER.CONSUMER_HOMETEL TEL,
					
					CONSUMER.WORKADDRESS WORK_ADDRESS,
					CONSUMER.WORKPOSTCODE WORK_POSCODE,
					CONSUMER.WORK_COUNTY_ID WORK_COUNTY,
					CONSUMER.WORK_CITY_ID WORK_CITY,
					CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
					CONSUMER.WORKSEMT WORK_SEMT,
					CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
					CONSUMER.CONSUMER_WORKTEL WORK_TEL
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID IN (#attributes.consumer_ids#)
			</cfif>
			<cfif len(attributes.partner_ids) and len(attributes.consumer_ids)>
				UNION
			</cfif>	  
			<cfif len(attributes.partner_ids)>
				SELECT
					COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
					COMPANY.FULLNAME AS COMPANY,
					COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS ADDRESS,
					COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS POSCODE,
					COMPANY_PARTNER.COUNTY AS COUNTY,
					COMPANY_PARTNER.CITY AS CITY,
					COMPANY_PARTNER.COUNTRY AS COUNTRY,
					COMPANY_PARTNER.SEMT AS SEMT,
					COMPANY_PARTNER.COMPANY_PARTNER_TELCODE TELCODE,
					COMPANY_PARTNER.COMPANY_PARTNER_TEL TEL,
					
					COMPANY.COMPANY_ADDRESS WORK_ADDRESS,
					COMPANY.COMPANY_POSTCODE WORK_POSCODE,
					COMPANY.COUNTY WORK_COUNTY,
					COMPANY.CITY WORK_CITY,
					COMPANY.COUNTRY WORK_COUNTRY,
					COMPANY.SEMT WORK_SEMT,
					COMPANY.COMPANY_TELCODE WORK_TELCODE,
					COMPANY.COMPANY_TEL1 WORK_TEL
				FROM
					COMPANY_PARTNER,
					COMPANY
				WHERE
					COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
					COMPANY_PARTNER.PARTNER_ID IN (#attributes.partner_ids#)
		  </cfif>	  
	</cfquery>
  </cfif> 
<cfelse>
	<cfquery name="get_camp_list_label_info" datasource="#dsn#">
		SELECT
			CONSUMER.CONSUMER_NAME AS NAME,
			CONSUMER.CONSUMER_SURNAME SURNAME,
			CONSUMER.HOMEADDRESS ADDRESS,
			CONSUMER.COMPANY AS COMPANY,
			CONSUMER.HOMEPOSTCODE AS POSCODE,
			CONSUMER.HOME_COUNTY_ID AS COUNTY,
			CONSUMER.HOME_CITY_ID AS CITY,
			CONSUMER.HOME_COUNTRY_ID AS COUNTRY,
			CONSUMER.HOMESEMT AS SEMT,
			CONSUMER.CONSUMER_HOMETELCODE TELCODE,
			CONSUMER.CONSUMER_HOMETEL TEL,
			CONSUMER.WORKADDRESS WORK_ADDRESS,
			CONSUMER.WORKPOSTCODE WORK_POSCODE,
			CONSUMER.WORK_COUNTY_ID WORK_COUNTY,
			CONSUMER.WORK_CITY_ID WORK_CITY,
			CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
			CONSUMER.WORKSEMT WORK_SEMT,
			CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
			CONSUMER.CONSUMER_WORKTEL WORK_TEL
		FROM
			CONSUMER
		WHERE
		<cfif isdefined("attributes.consumer_ids") and len(attributes.consumer_ids)>
			CONSUMER_ID IN (#attributes.consumer_ids#)
		<cfelse>	
			CONSUMER_ID IN (SELECT 
								CON_ID
							FROM 
								#dsn3_alias#.CAMPAIGN_TARGET_PEOPLE
							WHERE
								CAMP_ID = #attributes.CAMP_ID# AND
								CON_ID IS NOT NULL AND
								PAR_ID IS NULL
							<cfif isdefined("attributes.employee") and isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
								AND RECORD_EMP = #attributes.employee_id#
							</cfif>
							<cfif isdefined("attributes.date1") and len(attributes.date1)>
								AND RECORD_DATE >  #dateadd("d",0,attributes.date1)#
							</cfif>
							<cfif isdefined("attributes.date2") and len(attributes.date2)>
								AND RECORD_DATE <= #dateadd("d",1,attributes.date2)#
							</cfif>
							)
		</cfif>
	UNION ALL
		SELECT
			COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS ADDRESS,
			COMPANY.FULLNAME AS COMPANY,
			COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS POSCODE,
			COMPANY_PARTNER.COUNTY AS COUNTY,
			COMPANY_PARTNER.CITY AS CITY,
			COMPANY_PARTNER.COUNTRY AS COUNTRY,
			COMPANY_PARTNER.SEMT AS SEMT,
			COMPANY_PARTNER.COMPANY_PARTNER_TELCODE TELCODE,
			COMPANY_PARTNER.COMPANY_PARTNER_TEL TEL,
			COMPANY.COMPANY_ADDRESS WORK_ADDRESS,
			COMPANY.COMPANY_POSTCODE WORK_POSCODE,
			COMPANY.COUNTY WORK_COUNTY,
			COMPANY.CITY WORK_CITY,
			COMPANY.COUNTRY WORK_COUNTRY,
			COMPANY.SEMT WORK_SEMT,
			COMPANY.COMPANY_TELCODE WORK_TELCODE,
			COMPANY.COMPANY_TEL1 WORK_TEL
		FROM
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
	   <cfif isdefined("attributes.partner_ids") and len(attributes.partner_ids)>
			COMPANY_PARTNER.PARTNER_ID IN (#attributes.partner_ids#)
	   <cfelse>
			COMPANY_PARTNER.PARTNER_ID IN (SELECT
												PAR_ID
											FROM
												#dsn3_alias#.CAMPAIGN_TARGET_PEOPLE
											WHERE
												CAMP_ID = #attributes.CAMP_ID# AND
												CON_ID IS NULL AND 
												PAR_ID IS NOT NULL
											<cfif isdefined("attributes.employee") and isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
												AND RECORD_EMP = #attributes.employee_id#
											</cfif>
											<cfif isdefined("attributes.date1") and len(attributes.date1)>
												AND RECORD_DATE > #dateadd("d",0,attributes.date1)#
											</cfif>
											<cfif isdefined("attributes.date2") and len(attributes.date2)>
												AND RECORD_DATE <= #dateadd("d",1,attributes.date2)# 
											</cfif>)
	   </cfif>
	</cfquery>	
</cfif> --->
