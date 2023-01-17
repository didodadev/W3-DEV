<cfquery name="get_address" datasource="#dsn#">
	<cfif isDefined("attributes.is_group") and Len(attributes.is_group)>
		<!--- Gruplar --->
		SELECT
			1 TYPE,
			GROUP_ID,
			GROUP_NAME GROUP_NAME
		FROM
			USERS
		WHERE 
			<cfif len(attributes.keyword)>
				GROUP_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' AND
			</cfif>
			(RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR TO_ALL = 1)
	UNION ALL
	   SELECT
	   		2 TYPE,
			WORKGROUP_ID AS GROUP_ID, 
			WORKGROUP_NAME GROUP_NAME		
	   FROM 
			WORK_GROUP
		WHERE
			<cfif len(attributes.keyword)>
				WORKGROUP_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' AND
			</cfif>
			1 = 1
		ORDER BY
			GROUP_NAME
	<cfelse>
		<!--- Adres Defteri --->
			SELECT 
				AB_ID,
				EMPLOYEE_ID,
				PARTNER_ID,
				CONSUMER_ID,
				AB_NAME,
				AB_SURNAME,
				AB_COMPANY,
				<!--- Etikette Kullaniliyor --->
				AB_ADDRESS,
				AB_POSTCODE,
				AB_SEMT,
				CASE WHEN ISNULL(AB_COUNTY_ID,0) != 0 THEN (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = AB_COUNTY_ID) ELSE AB_COUNTY END AS AB_COUNTY,
				CASE WHEN ISNULL(AB_CITY_ID,0) != 0 THEN (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = AB_CITY_ID) ELSE AB_CITY END AS AB_CITY,
				CASE WHEN ISNULL(AB_COUNTRY_ID,0) != 0 THEN (SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = AB_COUNTRY_ID) ELSE AB_COUNTRY END AS AB_COUNTRY,
				<!--- //Etikette Kullaniliyor --->
				AB_EMAIL,
				AB_TELCODE,
				AB_TEL1,
				AB_TEL2,
				AB_FAX,
				AB_MOBILCODE,
				AB_MOBIL,
				AB_WEB
			FROM 
				ADDRESSBOOK
			WHERE
				AB_ID IS NOT NULL
				AND IS_ACTIVE = 1
				<cfif isDefined("page_type") and page_type eq 1><!--- Mail Listesi --->
					AND LEN(AB_EMAIL) > 1
				</cfif>
				<cfif Len(attributes.keyword)>
					AND (	
							<cfif isDefined("page_type") and page_type eq 1><!--- Mail Listesi --->
								AB_EMAIL LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
							</cfif>
							AB_COMPANY LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
							AB_NAME <cfif database_type is 'MSSQL'>+' '+<cfelse>||' '||</cfif> AB_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
							OR CONCAT(AB_TELCODE,AB_TEL1) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
							OR CONCAT(AB_TELCODE,AB_TEL2) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
							OR CONCAT(AB_MOBILCODE,AB_MOBIL) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">				 
						)
				</cfif>
				<cfif isDefined("search_type") and Len(attributes.search_type)>
					<cfif attributes.search_type eq 0>
						AND EMPLOYEE_ID IS NULL
						AND CONSUMER_ID IS NULL
						AND PARTNER_ID IS NULL
					<cfelseif attributes.search_type eq 1>
						AND EMPLOYEE_ID IS NOT NULL
					<cfelseif attributes.search_type eq 2>
						AND CONSUMER_ID IS NOT NULL
					<cfelseif attributes.search_type eq 3>
						AND PARTNER_ID IS NOT NULL
					</cfif>
                <cfelse>
                	<cfif IsDefined('is_show_employee_detail') and is_show_employee_detail eq 0>
                    	AND (( CONSUMER_ID IS NOT NULL OR PARTNER_ID IS NOT NULL) OR (EMPLOYEE_ID IS NULL AND CONSUMER_ID IS NULL AND PARTNER_ID IS NULL))
                    </cfif>
				</cfif>
				<cfif isDefined("attributes.member_type") and Len(attributes.member_type)>
					<!--- Etikette Kullaniliyor --->
					<cfif attributes.member_type eq 0>
						AND AB_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					<cfelseif attributes.member_type eq 1>
						<cfif (database_type is 'MSSQL')>
							AND AB_NAME +' '+ AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
						<cfelseif (database_type is 'DB2')>
							AND AB_NAME ||' '|| AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
						</cfif>
					<cfelse>
						AND	(	AB_COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								AB_NAME +' '+ AB_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
							)
					</cfif>
					<!--- //Etikette Kullaniliyor --->
				</cfif>
				<cfif isdefined("attributes.special_emp") and attributes.special_emp eq 1>
					AND SPECIAL_EMP = #session.ep.userid#
				<cfelseif isdefined("attributes.special_emp") and attributes.special_emp eq 0>
					AND ISNULL(SPECIAL_EMP,0) = 0
				<cfelse>
					AND (SPECIAL_EMP = #session.ep.userid# OR ISNULL(SPECIAL_EMP,0) = 0)
				</cfif>
			ORDER BY 
				AB_NAME,
				AB_SURNAME
	</cfif>
</cfquery>
