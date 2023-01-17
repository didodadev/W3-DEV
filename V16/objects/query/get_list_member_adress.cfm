<cfif attributes.is_comp eq 1><!--- Kurumsal üye ise --->
	<cfquery name="GET_MEMBER" datasource="#DSN#">
	WITH CTE1 AS (
    SELECT
			C.COMPANY_ID MEMBER_ID,
			C.FULLNAME + ' - ' + CB.COMPBRANCH__NAME FULLNAME,
            CB.COMPBRANCH_CODE CODE,
            CB.COMPBRANCH_ALIAS AS ALIAS,
			CB.COMPBRANCH_ADDRESS ADDRESS,
			CB.COMPBRANCH_POSTCODE POSTCODE,
			CB.COUNTY_ID COUNTY,
			CB.CITY_ID CITY,
			CB.COUNTRY_ID COUNTRY,
			CB.COMPBRANCH_TELCODE TELCODE,
			CB.COMPBRANCH_TEL1 TEL,
			CB.SEMT SEMT,
			'' DISTRICT,
			C.MEMBER_CODE,
			CB.COMPBRANCH_ID BRANCH_ID,
			CB.COMPBRANCH__NAME BRANCH_NAME,
			'' ADDRESS_TYPE,
			CB.COMPBRANCH_ID,
			CB.COORDINATE_1 COORDINATE_1,
			CB.COORDINATE_2 COORDINATE_2,
            CB.SZ_ID,
            SCTRY.COUNTRY_NAME,
			SCITY.CITY_NAME ,
			SCTY.COUNTY_NAME,
			'' DISTRICT_NAME
		FROM	
			COMPANY_BRANCH CB
                LEFT JOIN COMPANY C ON CB.COMPANY_ID = C.COMPANY_ID 
                LEFT JOIN SETUP_COUNTRY SCTRY ON SCTRY.COUNTRY_ID = CB.COUNTRY_ID
                LEFT JOIN SETUP_CITY SCITY ON SCITY.CITY_ID = CB.CITY_ID
                LEFT JOIN SETUP_COUNTY SCTY ON SCTY.COUNTY_ID = CB.COUNTY_ID
		WHERE 
			CB.COMPBRANCH_STATUS = 1
			<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
				AND C.COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_member_id#">
			</cfif>
			<cfif isdefined("attributes.member_type") and (attributes.member_type is 'PARTNER') and len(attributes.member_name) and len(attributes.company_id)>
				AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
					AND (
							C.FULLNAME + ' - ' + CB.COMPBRANCH__NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
							OR
							CB.COMPBRANCH_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
						)
				</cfif>
			<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
				AND C.COMPANY_ID IN 
				(SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					LEFT JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
		   </cfif>			
		UNION ALL 
		SELECT
			C.COMPANY_ID MEMBER_ID,
			C.FULLNAME,
            '' CODE,
            '' ALIAS,
			C.COMPANY_ADDRESS ADDRESS,
			C.COMPANY_POSTCODE POSTCODE,
			C.COUNTY COUNTY,
			C.CITY CITY,
			C.COUNTRY COUNTRY,
			C.COMPANY_TELCODE TELCODE,
			C.COMPANY_TEL1 TEL,	
			C.SEMT SEMT,
			'' DISTRICT,
			C.MEMBER_CODE,
			-1 BRANCH_ID,
			'Merkez' AS BRANCH_NAME,
			'' ADDRESS_TYPE,
			-1 COMPBRANCH_ID,
			C.COORDINATE_1,
			C.COORDINATE_2,
            C.SALES_COUNTY SZ_ID,
            SCTRY.COUNTRY_NAME,
			SCITY.CITY_NAME ,
			SCTY.COUNTY_NAME,
			SDIS.DISTRICT_NAME
		FROM 
			COMPANY C
                LEFT JOIN SETUP_COUNTRY SCTRY ON SCTRY.COUNTRY_ID = C.COUNTRY
                LEFT JOIN SETUP_CITY SCITY ON SCITY.CITY_ID = C.CITY
                LEFT JOIN SETUP_COUNTY SCTY ON SCTY.COUNTY_ID = C.COUNTY
                LEFT JOIN SETUP_DISTRICT SDIS ON SDIS.DISTRICT_ID = C.DISTRICT_ID
		WHERE
			COMPANY_STATUS = 1 
		<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.field_member_id#">
		</cfif>		
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'PARTNER') and len(attributes.member_name) and len(attributes.company_id)>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND (
					FULLNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 
					OR
					COMPANY_ADDRESS LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
				)
		</cfif>
		<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
			AND C.COMPANY_ID IN 
			(SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					LEFT JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
	  	</cfif>	
           ),
        CTE2 AS (
            SELECT
            	CTE1.*,
            	ROW_NUMBER() OVER (ORDER BY FULLNAME ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
            FROM
            	CTE1
            	)
            SELECT
	            CTE2.*
            FROM
    	        CTE2
            WHERE
        	 
 				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+#attributes.maxrows-1#
	</cfquery> 
<cfelse><!--- Bireysel Uye --->
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		WITH CTE1 AS (
        SELECT 
			C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME + ' - ' + CB.CONTACT_NAME FULLNAME,
			C.CONSUMER_ID MEMBER_ID,
            '' CODE,
            '' ALIAS,
			CB.CONTACT_ADDRESS ADDRESS,
			CB.CONTACT_POSTCODE POSTCODE,
			CB.CONTACT_COUNTY_ID COUNTY,
			CB.CONTACT_CITY_ID CITY,
			CB.CONTACT_COUNTRY_ID COUNTRY,
			CB.CONTACT_TELCODE TELCODE,
			CB.CONTACT_TEL1 TEL,
			CB.CONTACT_SEMT SEMT,
			C.MEMBER_CODE,
			CB.CONTACT_ID BRANCH_ID,
			'' AS BRANCH_NAME,
			'' ADDRESS_TYPE,
			CONTACT_ID COMPBRANCH_ID,
			'' COORDINATE_1,
			'' COORDINATE_2,
			'' SZ_ID,
            H_COUNTY.COUNTY_NAME,
			H_COUNTRY.COUNTRY_NAME,
			H_CITY.CITY_NAME,
            S_DIS.DISTRICT_NAME
		FROM
			CONSUMER C
            	LEFT JOIN CONSUMER_BRANCH CB ON CB.CONSUMER_ID = C.CONSUMER_ID
                LEFT JOIN SETUP_COUNTY H_COUNTY ON H_COUNTY.COUNTY_ID = CB.CONTACT_COUNTY_ID
                LEFT JOIN SETUP_CITY H_CITY ON H_CITY.CITY_ID = CB.CONTACT_CITY_ID 
                LEFT JOIN SETUP_COUNTRY H_COUNTRY ON H_COUNTRY.COUNTRY_ID = CB.CONTACT_COUNTRY_ID
                LEFT JOIN SETUP_DISTRICT S_DIS ON S_DIS.DISTRICT_ID=CB.CONTACT_DISTRICT_ID
		WHERE
			CB.STATUS = 1
		<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
			AND C.CONSUMER_ID = #attributes.field_member_id#
		</cfif>		
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND (
					C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME + ' ' + CB.CONTACT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
					OR
					CB.CONTACT_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
		</cfif>
		<cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>
			AND C.TC_IDENTY_NO = '#attributes.tc_num#'
		</cfif>
		<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
			AND C.CONSUMER_ID IN 
			(SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					INNER JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
	  	</cfif>			
		UNION ALL
		SELECT
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
            '' CODE,
            '' ALIAS,
			TAX_ADRESS ADDRESS,
			TAX_POSTCODE POSTCODE,
			TAX_COUNTY_ID COUNTY,
			TAX_CITY_ID CITY,
			TAX_COUNTRY_ID COUNTRY,
			'' TELCODE,
			'' TEL,
			TAX_SEMT SEMT,
			MEMBER_CODE,
			-1 BRANCH_ID,
			'' AS BRANCH_NAME,
			'Fatura Adresi' ADDRESS_TYPE,
			-1 COMPBRANCH_ID,
			COORDINATE_1,
			COORDINATE_2,
			SALES_COUNTY SZ_ID,
            T_COUNTY.COUNTY_NAME,
            T_COUNTRY.COUNTRY_NAME,
            T_CITY.CITY_NAME,
            S_DIS.DISTRICT_NAME
		FROM 
			CONSUMER C
                LEFT JOIN SETUP_COUNTY T_COUNTY ON T_COUNTY.COUNTY_ID = C.TAX_COUNTY_ID
                LEFT JOIN SETUP_CITY T_CITY ON T_CITY.CITY_ID = C.TAX_CITY_ID
                LEFT JOIN SETUP_COUNTRY T_COUNTRY ON T_COUNTRY.COUNTRY_ID = C.TAX_COUNTRY_ID
                LEFT JOIN SETUP_DISTRICT S_DIS ON S_DIS.DISTRICT_ID=C.TAX_DISTRICT_ID
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
			AND CONSUMER_ID = #attributes.field_member_id#
		</cfif>
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND (
					CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
					OR
					TAX_ADRESS LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
		</cfif>
		<cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>
			AND TC_IDENTY_NO = '#attributes.tc_num#'
		</cfif>
		<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
			AND C.CONSUMER_ID IN 
			(SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					INNER JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
	  	</cfif>			
		UNION ALL
		SELECT 
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
            '' CODE,
            '' ALIAS,
			HOMEADDRESS ADDRESS,
			HOMEPOSTCODE POSTCODE,
			HOME_COUNTY_ID COUNTY,
			HOME_CITY_ID CITY,
			HOME_COUNTRY_ID COUNTRY,
			CONSUMER_HOMETELCODE TELCODE,
			CONSUMER_HOMETEL TEL,
			HOMESEMT SEMT,
			MEMBER_CODE MEMBER_CODE,
			-1 BRANCH_ID,
			'' AS BRANCH_NAME,
			'Ev Adresi' ADDRESS_TYPE,
			-2 COMPBRANCH_ID,
			COORDINATE_1,
			COORDINATE_2,
			SALES_COUNTY SZ_ID,
            H_COUNTY.COUNTY_NAME,
			H_COUNTRY.COUNTRY_NAME,
			H_CITY.CITY_NAME,
            S_DIS.DISTRICT_NAME
		FROM 
			CONSUMER C
            	LEFT JOIN SETUP_COUNTY H_COUNTY ON H_COUNTY.COUNTY_ID = C.HOME_COUNTY_ID
				LEFT JOIN SETUP_CITY H_CITY ON H_CITY.CITY_ID = C.HOME_CITY_ID 
				LEFT JOIN SETUP_COUNTRY H_COUNTRY ON H_COUNTRY.COUNTRY_ID = C.HOME_COUNTRY_ID
                LEFT JOIN SETUP_DISTRICT S_DIS ON S_DIS.DISTRICT_ID=C.HOME_DISTRICT_ID
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
			AND CONSUMER_ID = #attributes.field_member_id#
		</cfif>		
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND (
					CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
					OR
					HOMEADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
		</cfif>
		<cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>
			AND TC_IDENTY_NO = '#attributes.tc_num#'
		</cfif>
		<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
			AND C.CONSUMER_ID IN 
                (SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					INNER JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
	  	</cfif>			
		UNION ALL
		SELECT 
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
            '' CODE,
            '' ALIAS,
			WORKADDRESS ADDRESS,
			WORKPOSTCODE POSTCODE,
			WORK_COUNTY_ID COUNTY,
			WORK_CITY_ID CITY,
			WORK_COUNTRY_ID COUNTRY,
			CONSUMER_WORKTELCODE TELCODE,
			CONSUMER_WORKTEL TEL,
			WORKSEMT SEMT,
			--WORK_DISTRICT_ID DISTRICT,
			MEMBER_CODE MEMBER_CODE,
			-1 BRANCH_ID,
			'' AS BRANCH_NAME,
			'Is Adresi' ADDRESS_TYPE,
			-3 COMPBRANCH_ID,
			COORDINATE_1,
			COORDINATE_2,
			SALES_COUNTY SZ_ID,
            W_COUNTY.COUNTY_NAME,
			W_COUNTRY.COUNTRY_NAME,
			W_CITY.CITY_NAME,
            S_DIS.DISTRICT_NAME
		FROM 
			CONSUMER C
            	LEFT JOIN SETUP_COUNTY W_COUNTY ON W_COUNTY.COUNTY_ID = C.WORK_COUNTY_ID 
				LEFT JOIN SETUP_CITY W_CITY ON W_CITY.CITY_ID = C.WORK_CITY_ID 
				LEFT JOIN SETUP_COUNTRY W_COUNTRY ON W_COUNTRY.COUNTRY_ID = C.WORK_COUNTRY_ID
                LEFT JOIN SETUP_DISTRICT S_DIS ON S_DIS.DISTRICT_ID=C.WORK_DISTRICT_ID 
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
			AND CONSUMER_ID = #attributes.field_member_id#
		</cfif>		
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword) gte 1>
			AND (
					CONSUMER_NAME + ' ' + CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
					OR
					WORKADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
				)
		</cfif>
		<cfif isdefined("attributes.tc_num") and len(attributes.tc_num)>
			AND TC_IDENTY_NO = '#attributes.tc_num#'
		</cfif>
		<cfif session.ep.isBranchAuthorization and is_auto_branch_adress eq 1>
			AND C.CONSUMER_ID IN 
			(SELECT 
					COMPANY_BRANCH_RELATED.COMPANY_ID
				FROM 
					EMPLOYEE_POSITION_BRANCHES
					INNER JOIN COMPANY_BRANCH_RELATED ON EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID
				WHERE 
					COMPANY_BRANCH_RELATED.COMPANY_ID IS NOT NULL AND
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
					COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL <!--- CRM den gelen fazla kayıtları engellemekiçin --->)
	  	</cfif>	
            ),
        CTE2 AS (
            SELECT
            	CTE1.*,
            	ROW_NUMBER() OVER (ORDER BY FULLNAME ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
            FROM
            	CTE1
            	)
            SELECT
	            CTE2.*
            FROM
    	        CTE2
            WHERE
        	    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+#attributes.maxrows-1#	
	</cfquery>
</cfif>
