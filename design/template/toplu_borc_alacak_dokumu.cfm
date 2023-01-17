<!--- Toplu Borc/Alacak Dokumu  --->
<!--- Müşteri ve Çalışanlara göre filtreleme eklendi. 20150421 SK --->
<cfset tarih_ = now()>
<cfif isDefined("attributes.startdate") and len(attributes.startdate2)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif isDefined("attributes.startdate2") and len(attributes.startdate2)>
	<cf_date tarih="attributes.startdate2">
</cfif>
<cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
	<cf_date tarih="attributes.finishdate2">
	<cfset tarih_ = attributes.finishdate2>
</cfif>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 	
		ALL_ROWS.FULLNAME AS FULLNAME,
		ALL_ROWS.COMP_ID AS COMPANY_ID,	
		SUM(BORC1-ALACAK1) AS BAKIYE,
		SUM(BORC1) AS BORC,
		SUM(ALACAK1) AS ALACAK,
        ALL_ROWS.MEMBER_TYPE AS MEMBER_TYPE
	FROM 
	(	
    	<cfif isdefined('company_ids') and len(#company_ids#)>
            SELECT
                SUM(CRS.ACTION_VALUE) AS BORC1,
                0 as ALACAK1,
                CRS.TO_CMP_ID AS COMP_ID,
                CRS.ACTION_DATE AS TARIH,
                C.FULLNAME AS FULLNAME,
                0 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS CRS,
                COMPANY C
            WHERE
                CRS.TO_CMP_ID IS NOT NULL
                AND C.COMPANY_ID = CRS.TO_CMP_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif>
                AND	C.COMPANY_ID IN (#company_ids#)
             <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
                        CRS.DUE_DATE IS NULL
                    )
                    AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
                        CRS.DUE_DATE IS NULL
                    )
                    AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>

            GROUP BY 
                C.FULLNAME,
                CRS.TO_CMP_ID,
                CRS.ACTION_DATE
    
            UNION ALL
            
            SELECT
                0 AS BORC1,		
                SUM(CRS.ACTION_VALUE) AS ALACAK1,                         
                CRS.FROM_CMP_ID AS COMP_ID,
                CRS.ACTION_DATE,
                C.FULLNAME,
                0 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS CRS,
                COMPANY C
            WHERE
                CRS.FROM_CMP_ID IS NOT NULL AND
                C.COMPANY_ID = CRS.FROM_CMP_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif>
                AND	C.COMPANY_ID IN (#company_ids#)
            <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS.DUE_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.DUE_DATE END OR
                        CRS.DUE_DATE IS NULL
                    )
                    AND (CRS.ACTION_DATE >= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS.DUE_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.DUE_DATE END OR
                        CRS.DUE_DATE IS NULL
                    )
                    AND (CRS.ACTION_DATE <= CASE WHEN (CRS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>
            
            GROUP BY 
                C.FULLNAME,
                CRS.FROM_CMP_ID,
                CRS.ACTION_DATE
          </cfif> 
          <cfif isdefined('consumer_ids') and len(#consumer_ids#)> 
          	<cfif isdefined('company_ids') and len(#company_ids#)>    
            	UNION ALL
		  	</cfif>
            SELECT
                SUM(CRS_CONS.BORC) AS BORC1,
                0 as ALACAK1,
                CRS_CONS.TO_CONSUMER_ID AS COMP_ID,
                CRS_CONS.ACTION_DATE AS TARIH,
                CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME AS FULLNAME,
                1 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS_CONSUMER CRS_CONS,
                CONSUMER CONS
                
            WHERE
                CRS_CONS.TO_CONSUMER_ID IS NOT NULL
                AND CONS.CONSUMER_ID = CRS_CONS.TO_CONSUMER_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif> 
                AND CONS.CONSUMER_ID IN (#consumer_ids#)
             <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS_CONS.DUE_DATE >= CASE WHEN (CRS_CONS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_CONS.DUE_DATE END OR
                        CRS_CONS.DUE_DATE IS NULL
                    )
                    AND (CRS_CONS.ACTION_DATE >= CASE WHEN (CRS_CONS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_CONS.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS_CONS.DUE_DATE <= CASE WHEN (CRS_CONS.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_CONS.DUE_DATE END OR
                        CRS_CONS.DUE_DATE IS NULL
                    )
                    AND (CRS_CONS.ACTION_DATE <= CASE WHEN (CRS_CONS.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_CONS.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS_CONS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS_CONS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>  
  			  
            GROUP BY 
                CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME,
                CRS_CONS.TO_CONSUMER_ID,
                CRS_CONS.ACTION_DATE
    
            UNION ALL
    
            SELECT
                0 AS BORC1,
                SUM(CRS_CONS.ALACAK) as ALACAK1,
                CRS_CONS.FROM_CONSUMER_ID AS COMP_ID,
                CRS_CONS.ACTION_DATE AS TARIH,
                CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME AS FULLNAME,
                1 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS_CONSUMER CRS_CONS,
                CONSUMER CONS
                
            WHERE
                CRS_CONS.FROM_CONSUMER_ID IS NOT NULL
                AND CONS.CONSUMER_ID = CRS_CONS.FROM_CONSUMER_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND CONSUMER_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif>
                AND CONS.CONSUMER_ID IN (#consumer_ids#)
            <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS_CONS.DUE_DATE >= CASE WHEN (CRS_CONS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_CONS.DUE_DATE END OR
                        CRS_CONS.DUE_DATE IS NULL
                    )
                    AND (CRS_CONS.ACTION_DATE >= CASE WHEN (CRS_CONS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_CONS.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS_CONS.DUE_DATE <= CASE WHEN (CRS_CONS.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_CONS.DUE_DATE END OR
                        CRS_CONS.DUE_DATE IS NULL
                    )
                    AND (CRS_CONS.ACTION_DATE <= CASE WHEN (CRS_CONS.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_CONS.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS_CONS.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS_CONS.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>
                
            GROUP BY 
                CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME,
                CRS_CONS.FROM_CONSUMER_ID,
                CRS_CONS.ACTION_DATE
    	</cfif>
        <cfif isdefined('employee_ids') and len(#employee_ids#)>
            <cfif (isdefined('company_ids') and len(#company_ids#)) or (isdefined('consumer_ids') and len(#consumer_ids#))> 
            	UNION ALL
			</cfif>
        
            SELECT
                SUM(CRS_EMP.ACTION_VALUE) AS BORC1,
                0 as ALACAK1,
                CRS_EMP.TO_EMPLOYEE_ID AS COMP_ID,
                CRS_EMP.ACTION_DATE AS TARIH,
                EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS FULLNAME,
                2 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS CRS_EMP,
                EMPLOYEES EMP
                
            WHERE
                CRS_EMP.TO_EMPLOYEE_ID IS NOT NULL
                AND EMP.EMPLOYEE_ID = CRS_EMP.TO_EMPLOYEE_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif>
                AND EMP.EMPLOYEE_ID IN (#employee_ids#)
             <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS_EMP.DUE_DATE >= CASE WHEN (CRS_EMP.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_EMP.DUE_DATE END OR
                        CRS_EMP.DUE_DATE IS NULL
                    )
                    AND (CRS_EMP.ACTION_DATE >= CASE WHEN (CRS_EMP.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_EMP.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS_EMP.DUE_DATE <= CASE WHEN (CRS_EMP.ACTION_TYPE_ID NOT IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_EMP.DUE_DATE END OR
                        CRS_EMP.DUE_DATE IS NULL
                    )
                    AND (CRS_EMP.ACTION_DATE <= CASE WHEN (CRS_EMP.ACTION_TYPE_ID IN (91,94,98,101,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_EMP.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS_EMP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS_EMP.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>
                
            GROUP BY 
                EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME,
                CRS_EMP.TO_EMPLOYEE_ID,
                CRS_EMP.ACTION_DATE
    
            UNION ALL
    
            SELECT
                0 AS BORC1,
                SUM(CRS_EMP.ACTION_VALUE) as ALACAK1,
                CRS_EMP.FROM_EMPLOYEE_ID AS COMP_ID,
                CRS_EMP.ACTION_DATE AS TARIH,
                EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS FULLNAME,
                2 AS MEMBER_TYPE
            FROM
                #dsn2#.CARI_ROWS CRS_EMP,
                EMPLOYEES EMP
                
            WHERE
                CRS_EMP.FROM_EMPLOYEE_ID IS NOT NULL
                AND EMP.EMPLOYEE_ID = CRS_EMP.FROM_EMPLOYEE_ID
            <cfif isdefined("attributes.comp_status") and len(attributes.comp_status)>
                AND EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.comp_status#">
            </cfif>
                AND EMP.EMPLOYEE_ID IN (#employee_ids#)
           <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            	AND
                    (
                        CRS_EMP.DUE_DATE >= CASE WHEN (CRS_EMP.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_EMP.DUE_DATE END OR
                        CRS_EMP.DUE_DATE IS NULL
                    )
                    AND (CRS_EMP.ACTION_DATE >= CASE WHEN (CRS_EMP.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ELSE CRS_EMP.ACTION_DATE END)
            </cfif>
			<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            	AND
                    (
                        CRS_EMP.DUE_DATE <= CASE WHEN (CRS_EMP.ACTION_TYPE_ID NOT IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_EMP.DUE_DATE END OR
                        CRS_EMP.DUE_DATE IS NULL
                    )
                    AND (CRS_EMP.ACTION_DATE <= CASE WHEN (CRS_EMP.ACTION_TYPE_ID IN (90,95,97,108,241)) THEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ELSE CRS_EMP.ACTION_DATE END)
            </cfif>
            <cfif isdefined("attributes.startdate2") and len(attributes.startdate2)>
            	AND CRS_EMP.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#">
            </cfif>
            <cfif isdefined("attributes.finishdate2") and len(attributes.finishdate2)>
            	AND CRS_EMP.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#">
            </cfif>
                
            GROUP BY 
                EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME,
                CRS_EMP.FROM_EMPLOYEE_ID,
                CRS_EMP.ACTION_DATE
        </cfif>
        
	) AS ALL_ROWS
	GROUP BY 
		ALL_ROWS.COMP_ID,
		ALL_ROWS.FULLNAME,
        ALL_ROWS.MEMBER_TYPE
	<cfif isDefined("attributes.duty_claim") and len(attributes.duty_claim)>
		<cfif attributes.duty_claim eq 1>
			<cfif isdefined("attributes.is_zero_bakiye")>
				HAVING ROUND(SUM(BORC1-ALACAK1),2) >= 0
			<cfelse>
				HAVING ROUND(SUM(BORC1-ALACAK1),2) >= 0	
			</cfif>
		<cfelseif attributes.duty_claim eq 2>
			HAVING ROUND(SUM(BORC1-ALACAK1),2)  < 0
		</cfif>
	<cfelseif isdefined("attributes.is_zero_bakiye")>
		HAVING ROUND(SUM(BORC1-ALACAK1),2) <> 0 
	</cfif>
	ORDER BY 
		ALL_ROWS.FULLNAME
</cfquery>
<cfif len(get_company.company_id)>
	<cfquery name="get_our_company_info" datasource="#dsn#">
		SELECT ASSET_FILE_NAME3,COMPANY_NAME,ADDRESS,TAX_OFFICE,TAX_NO,TEL_CODE,TEL,TEL2,FAX,FAX2,EMAIL FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
	</cfquery>
</cfif>
<cfoutput query="GET_COMPANY">
	<table style="width:195mm; height:290mm;" border="0" cellpadding="0" cellspacing="0">
		<tr align="left">
			<td style="width:7mm;">&nbsp;</td>
			<td colspan="2" style="height:40mm;width:188mm; text-align:center;">
				<cfif len(get_our_company_info.asset_file_name3)>
					<img src="#user_domain##file_web_path#settings/#get_our_company_info.asset_file_name3#" alt="" border="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td style="width:7mm;text-align:right;">&nbsp;</td>
			<td valign="top" style="width:188mm;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align:right;">
				<tr style="height:10mm;">
					<td>&nbsp;</td>
					<td class="txtbold" style="text-align:right;">Tarih: #dateformat(now(),dateformat_style)#</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr style="height:10mm;">
					<cfif len(get_company.company_id)>
						<cfquery name="get_company_name" datasource="#dsn#">
                            SELECT
                                C.COMPANY_ID,
                                C.FULLNAME MEMBER_NAME,
                                C.TAXOFFICE TAXOFFICE,
                                C.TAXNO TAXNO,
                                (SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
                                C.COMPANY_ADDRESS MEMBER_ADDRESS,
                                C.COMPANY_TELCODE MEMBER_TELCODE,
                                C.COMPANY_TEL1 MEMBER_TEL,
                                C.COMPANY_FAX MEMBER_FAKS,
                                ISNULL(SETUP_COUNTY.COUNTY_NAME,0) MEMBER_COUNTY,
                                ISNULL(SETUP_CITY.CITY_NAME,0) MEMBER_CITY,
                                ISNULL(SETUP_COUNTRY.COUNTRY_NAME,0) MEMBER_COUNTRY,
                                C.SEMT MEMBER_SEMT
                            FROM
                                COMPANY C
                                LEFT JOIN SETUP_CITY ON SETUP_CITY.CITY_ID=C.CITY
                                LEFT JOIN SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID=C.COUNTY
                                LEFT JOIN SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID=C.COUNTRY
                            WHERE 
                                C.COMPANY_ID = #company_id#
            			</cfquery>
                        <cfquery name="get_consumer_name" datasource="#dsn#">
                        	SELECT
                                CONS.CONSUMER_ID,
                                CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME AS MEMBER_NAME,
                                CONS.TAX_OFFICE TAXOFFICE,
                                CONS.TAX_NO TAXNO,
                                CONS.TC_IDENTY_NO TC_IDENTY_NO,
                                CONS.WORKADDRESS MEMBER_ADDRESS,
                                CONS.CONSUMER_WORKTELCODE MEMBER_TELCODE,
                                CONS.CONSUMER_WORKTEL MEMBER_TEL,
                                CONS.CONSUMER_FAX MEMBER_FAKS,
                                ISNULL(SETUP_COUNTY.COUNTY_NAME,'') MEMBER_COUNTY,
                                ISNULL(SETUP_CITY.CITY_NAME,'') MEMBER_CITY,
                                ISNULL(SETUP_COUNTRY.COUNTRY_NAME,'') MEMBER_COUNTRY,
                                CONS.WORKSEMT MEMBER_SEMT
                            FROM
                                CONSUMER CONS
                                LEFT JOIN SETUP_CITY ON SETUP_CITY.CITY_ID=CONS.WORK_CITY_ID
                                LEFT JOIN SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID=CONS.WORK_COUNTY_ID
                                LEFT JOIN SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID=CONS.WORK_COUNTRY_ID
                            WHERE CONS.CONSUMER_ID=#company_id#
                        </cfquery>
                        <cfquery name="get_employee_name" datasource="#dsn#">
                            SELECT
                                EMP.EMPLOYEE_ID,
                                EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS MEMBER_NAME,
                                EI.TAX_OFFICE AS TAXOFFICE,
                                EI.TAX_NUMBER AS TAXNO,
                                EI.TC_IDENTY_NO AS TC_IDENTY_NO,
                                ED.HOMEADDRESS AS MEMBER_ADDRESS,
                                EMP.MOBILCODE AS MEMBER_TELCODE,
                                EMP.MOBILTEL AS MEMBER_TEL,
                                '' AS MEMBER_FAKS,
                                ISNULL(SETUP_COUNTY.COUNTY_NAME,'') MEMBER_COUNTY,
                                ISNULL(SETUP_CITY.CITY_NAME,'') MEMBER_CITY,
                                ISNULL(SETUP_COUNTRY.COUNTRY_NAME,'') MEMBER_COUNTRY,
                                '' AS MEMBER_SEMT
                            FROM 
                                EMPLOYEES EMP
                                LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID=EMP.EMPLOYEE_ID
                                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID=EMP.EMPLOYEE_ID
                                LEFT JOIN SETUP_CITY ON SETUP_CITY.CITY_ID=ED.HOMECITY
                                LEFT JOIN SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID=ED.HOMECOUNTY
                                LEFT JOIN SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID=ED.HOMECOUNTRY
                            WHERE EMP.EMPLOYEE_ID=#company_id#
                        </cfquery>
					</cfif>
					<td style="height:45mm;">
						<br><br><br>
						Sayın,<br><br>
                        <cfif get_company.member_type eq 0>
                            <b>#get_company_name.member_name#</b><br>
                            #get_company_name.member_address# #get_company_name.member_semt#<br>
                            <cfif len(get_company.company_id) and len(get_company_name.member_county)>#get_company_name.member_county# /</cfif>
                            <cfif len(get_company.company_id) and len(get_company_name.member_city)>#get_company_name.member_city# /</cfif>
                            <cfif len(get_company.company_id) and len(get_company_name.member_country)>#get_company_name.member_country#</cfif><br>
                            Vergi D : #get_company_name.taxoffice# - Vergi No : <cfif len(get_company_name.taxno)>#get_company_name.taxno#<cfelse>#get_company_name.tc_identy_no#</cfif><!---#get_member_name.taxno#---><br>
                            Tel : #get_company_name.member_telcode# #get_company_name.member_tel# - Fax : #get_company_name.member_faks#<br>
                        <cfelseif get_company.member_type eq 1>
                        	<b>#get_consumer_name.member_name#</b><br>
                            #get_consumer_name.member_address# #get_consumer_name.member_semt#<br>
                            <cfif len(get_company.company_id) and len(get_consumer_name.member_county)>#get_consumer_name.member_county# /</cfif>
                            <cfif len(get_company.company_id) and len(get_consumer_name.member_city)>#get_consumer_name.member_city# /</cfif>
                            <cfif len(get_company.company_id) and len(get_consumer_name.member_country)>#get_consumer_name.member_country#</cfif><br>
                            Vergi D : #get_consumer_name.taxoffice# - Vergi No : <cfif len(get_consumer_name.taxno)>#get_consumer_name.taxno#<cfelse>#get_consumer_name.tc_identy_no#</cfif><!---#get_member_name.taxno#---><br>
                            Tel : #get_consumer_name.member_telcode# #get_consumer_name.member_tel# - Fax : #get_consumer_name.member_faks#<br>
                        <cfelse>
                        	<b>#get_employee_name.member_name#</b><br>
                            #get_employee_name.member_address# #get_employee_name.member_semt#<br>
                            <cfif len(get_company.company_id) and len(get_employee_name.member_county)>#get_employee_name.member_county# /</cfif>
                            <cfif len(get_company.company_id) and len(get_employee_name.member_city)>#get_employee_name.member_city# /</cfif>
                            <cfif len(get_company.company_id) and len(get_employee_name.member_country)>#get_employee_name.member_country#</cfif><br>
                            Vergi D : #get_employee_name.taxoffice# - Vergi No : <cfif len(get_employee_name.taxno)>#get_employee_name.taxno#<cfelse>#get_employee_name.tc_identy_no#</cfif><!---#get_member_name.taxno#---><br>
                            Tel : #get_employee_name.member_telcode# #get_employee_name.member_tel# - Fax : #get_employee_name.member_faks#<br>
                        </cfif>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" style="height:70mm;" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td><cfset myNumber = abs(filterNum(tlformat(bakiye)))>
						<cf_n2txt number="myNumber">
						Nezdimizdeki Cari Hesabınız <strong>&nbsp;#DateFormat(tarih_,dateformat_style)#&nbsp;</strong> tarihi itibari ile <strong>#TLFormat(abs(bakiye))#
						#session.ep.money# <cfif len(bakiye) and bakiye neq 0>(#myNumber#)</cfif>&nbsp;&nbsp;<cfif BORC gt ALACAK>Borç<cfelseif BORC lt ALACAK>Alacak</cfif>&nbsp;&nbsp;</strong> bakiye göstermektedir.<br>
						<br>
						Mutabık olup olmadığımızı bildirmenizi rica ederiz.
						<br><br>
					</td>
				</tr>
				<tr align="left">
					<td valign="top">
					<table border="0" width="100%">
						<tr>
							<td align="left">
								<cfquery name="get_position" datasource="#dsn#">
									SELECT
										EP.EMPLOYEE_NAME,
										EP.EMPLOYEE_SURNAME,
										PC.POSITION_CAT
									FROM
										EMPLOYEE_POSITIONS EP,
										SETUP_POSITION_CAT PC
									WHERE
										EP.POSITION_CAT_ID = PC.POSITION_CAT_ID AND
										EP.IS_MASTER = 1 AND
										EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
								</cfquery>
								<cfif Len(get_position.position_cat)>
									<br>
									<strong>
									#get_position.employee_name# #get_position.employee_surname# <br>
									#get_position.position_cat#
									</strong>
								</cfif>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td>
                        <p><u><strong>HATA VE UNUTMA İSTİSNADIR</strong></u><br><br>
                        1-) Mutabakat veya itirazınızı 7 gün içerisinde bildirmediğiniz takdirde T.T.K. nun 92. maddesi gereğince bakiyede mutabıksayılacağımızı hatırlatırız.<br>
                        2-) Bakiyede Mutabık olmadığınız takdirde hesap ekstrenizi 0 #get_our_company_info.tel_code# #get_our_company_info.fax# nolu faksa veya #get_our_company_info.email# mail adresine göndermenizi rica ederiz.<br>
                    </td>
                </tr>
			</table>
			<br><hr style="border-style:groove;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="text-align:right;">....../....../............</td>
				</tr>
				<tr>
					<td>Sayın, <br><br>
						<strong>#get_our_company_info.company_name#</strong><br>
						#get_our_company_info.address#<br>
						Vergi D: #get_our_company_info.tax_office# - Vergi No: #get_our_company_info.tax_no#<br>
						Tel: #get_our_company_info.tel_code# #get_our_company_info.tel# - #get_our_company_info.tel2#<br>
						Fax: #get_our_company_info.tel_code# #get_our_company_info.fax# - #get_our_company_info.fax2#<br>
						E-Mail : #get_our_company_info.email#
						<br><br>
						Nezdimizdeki cari hesabınız ....../....../............ tarihi itibariyle ........................................... #session.ep.money# Borç/Alacak bakiye vermektedir.
						Mutabık olduğumuzu/olmadığımızı bildiririz.
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<cfif currentrow neq recordcount>
		<div style="page-break-after: always"></div>
	</cfif>
</cfoutput>
