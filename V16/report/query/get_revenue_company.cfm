<cfif attributes.main_report_type eq 1>
	<cfset FROM_TO_CMP_ID = 'FROM_CMP_ID'>
    <cfset FROM_TO_ACCOUNT_ID = 'TO_ACCOUNT_ID'>
    <cfset FROM_TO_CASH_ID = 'TO_CASH_ID'>
<cfelse><!--- ödeme --->
	<cfset FROM_TO_CMP_ID = 'TO_CMP_ID'>
    <cfset FROM_TO_ACCOUNT_ID = 'FROM_ACCOUNT_ID'>
    <cfset FROM_TO_CASH_ID = 'FROM_CASH_ID'>
</cfif>
<cfquery name="GET_CARI_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	<cfif attributes.report_type eq 1>
		SELECT
			CR.PAPER_NO,
			CR.ACTION_NAME,
			CR.ACTION_DATE,
			CR.ACTION_VALUE,
			CR.DUE_DATE,
			CR.OTHER_CASH_ACT_VALUE,
			CR.#FROM_TO_CMP_ID#,
			CR.OTHER_MONEY,
            CR.CARI_ACTION_ID,
            CR.ACTION_DETAIL,
            PP.PROJECT_HEAD,
            ISNULL(A.ACCOUNT_NAME,'') + ISNULL(C.CASH_NAME,'') AS COLLECTION_LOCATION
		FROM
			CARI_ROWS CR
            	LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = CR.PROJECT_ID
                LEFT JOIN #dsn3_alias#.ACCOUNTS A ON A.ACCOUNT_ID = CR.#FROM_TO_ACCOUNT_ID#
                LEFT JOIN CASH C ON C.CASH_ID = CR.#FROM_TO_CASH_ID#
		WHERE
			CR.ACTION_TYPE_ID IN (30,32,33,34,35,37,38,39,31,310,20,21,22,23,24,240,25,250,260,251,26,27,29,245,242,246,243,244,90,91,92,93,94,95,96,1040,1041,1042,1043,1044,1045,1046,105,106,97,98,99,100,101,102,103,1050,1051,1052,1053,1054,1055,1056,104,107,108,241,2410) AND
			CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
			CR.#FROM_TO_CMP_ID# IS NOT NULL
			<cfif len(trim(attributes.company)) and len(attributes.company_id)>
				AND CR.#FROM_TO_CMP_ID# = #attributes.company_id#
			</cfif>
			<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
				AND	CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
			</cfif>
			<cfif len(attributes.customer_value_id)>
				AND CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
			</cfif>
			<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
				AND CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
			</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
				AND CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id# )
			</cfif>
			<cfif len(attributes.zone_id)>
				AND CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id# )
			</cfif>
			<cfif len(attributes.resource_id)>
				AND CR.#FROM_TO_CMP_ID# IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id# )
			</cfif>
			<cfif len(attributes.project_head) and len(attributes.project_id)>
				AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
		ORDER BY
			CR.ACTION_DATE
	<cfelseif listfind("2,3,4,5,6,7,11",attributes.report_type)>
		SELECT
		<cfif listfind("2,3,4,5",attributes.report_type)>
			PROCESS_ID,
			<cfif isdefined("attributes.is_group_date")>MONTH_DUE,YEAR_DUE,</cfif>
		</cfif>
			DSP_REPORT_TYPE,
			SUM(GET_CASH_ACTIONS) GET_CASH_ACTIONS,<!--- KASA HAREKETLERİ --->
			SUM(GET_CASH_ACTIONS2) GET_CASH_ACTIONS2,<!--- KASA HAREKETLERİ --->
			SUM(GET_BANK_ACTIONS) GET_BANK_ACTIONS,<!--- BANKA HAREKETLERİ --->
			SUM(GET_BANK_ACTIONS2) GET_BANK_ACTIONS2,<!--- BANKA HAREKETLERİ --->
			SUM(GET_CHEQUE_ACTIONS) GET_CHEQUE_ACTIONS,<!--- ÇEK HAREKETLERİ --->
			SUM(GET_CHEQUE_ACTIONS2) GET_CHEQUE_ACTIONS2,<!--- ÇEK HAREKETLERİ --->
			SUM(GET_VOUCHER_ACTIONS) GET_VOUCHER_ACTIONS,<!--- SENET HAREKETLERİ --->
			SUM(GET_VOUCHER_ACTIONS2) GET_VOUCHER_ACTIONS2,<!--- SENET HAREKETLERİ --->
			SUM(GET_CC_REVENUE) GET_CC_REVENUE,<!--- KREDI KARTI TAHSİLATLARI --->
			SUM(GET_CC_REVENUE2) GET_CC_REVENUE2<!--- KREDI KARTI TAHSİLATLARI --->
		FROM (
				<cfif attributes.main_report_type eq 2>
					SELECT
					<cfif attributes.report_type eq 2><!--- Üye Kategorisi Bazında--->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında--->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında--->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,	
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						SUM(CR.ACTION_VALUE) GET_CASH_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.TO_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (30,32,33,34,35,37,38,39,31,310) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.TO_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.TO_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 1>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						SUM(CR.ACTION_VALUE) GET_CASH_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.FROM_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (30,32,33,34,35,37,38,39,31,310) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.FROM_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.FROM_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 2>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,	
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_BANK_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.TO_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (20,21,22,23,24,240,25,250,260,251,26,27,29,245,246,243,244) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.TO_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.TO_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 1>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_BANK_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.FROM_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (20,21,22,23,24,240,25,250,260,251,26,27,29,245,246,243,244) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.FROM_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.FROM_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 2>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_CHEQUE_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.TO_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (90,91,92,93,94,95,96,1040,1041,1042,1043,1044,1045,1046,105,106) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.TO_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.TO_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 1>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_CHEQUE_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.FROM_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (90,91,92,93,94,95,96,1040,1041,1042,1043,1044,1045,1046,105,106) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.FROM_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.FROM_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL	
				</cfif>
				<cfif attributes.main_report_type eq 2>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_VOUCHER_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.TO_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (97,98,99,100,101,102,103,1050,1051,1052,1053,1054,1055,1056,104,107,108) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.TO_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.TO_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL
				</cfif>
				<cfif attributes.main_report_type eq 1>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CR.DUE_DATE) AS MONTH_DUE,YEAR(CR.DUE_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						SUM(CR.ACTION_VALUE) GET_VOUCHER_ACTIONS,
						SUM(CR.ACTION_VALUE_2) GET_VOUCHER_ACTIONS2,
						0 GET_CC_REVENUE,
						0 GET_CC_REVENUE2
					FROM
						CARI_ROWS CR
					<cfif attributes.report_type eq 2><!--- üye kategorisi  Bazında--->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.FROM_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (97,98,99,100,101,102,103,1050,1051,1052,1053,1054,1055,1056,104,107,108) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.FROM_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.FROM_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CR.DUE_DATE),YEAR(CR.DUE_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				UNION ALL
				</cfif>
				<cfif attributes.main_report_type eq 2>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.ACC_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.ACC_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.ACC_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.ACC_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.ACC_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.ACC_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.ACC_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.ACC_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						SUM(CCR.INSTALLMENT_AMOUNT) GET_CC_REVENUE,
						SUM(CCR.INSTALLMENT_AMOUNT / (CR.ACTION_VALUE/#dsn_alias#.IS_ZERO(CR.ACTION_VALUE_2,1))) GET_CC_REVENUE2
					FROM
						CARI_ROWS CR,
						#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CC,
						#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.TO_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (242) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
						CC.CREDITCARD_EXPENSE_ID = CCR.CREDITCARD_EXPENSE_ID AND
						CC.CREDITCARD_EXPENSE_ID = CR.ACTION_ID
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.TO_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.TO_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.TO_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.ACC_ACTION_DATE),YEAR(CCR.ACC_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.ACC_ACTION_DATE),YEAR(CCR.ACC_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi  Bazında--->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.ACC_ACTION_DATE),YEAR(CCR.ACC_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.ACC_ACTION_DATE),YEAR(CCR.ACC_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				</cfif>
				<cfif attributes.main_report_type eq 1>
					SELECT
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT DSP_REPORT_TYPE,
						C.COMPANYCAT_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.BANK_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.BANK_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME DSP_REPORT_TYPE,
						C.SALES_COUNTY PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.BANK_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.BANK_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME DSP_REPORT_TYPE,
						WEP.POSITION_CODE PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.BANK_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.BANK_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						C.NICKNAME DSP_REPORT_TYPE,
						C.COMPANY_ID PROCESS_ID,
						<cfif isdefined("attributes.is_group_date")>MONTH(CCR.BANK_ACTION_DATE) AS MONTH_DUE,YEAR(CCR.BANK_ACTION_DATE) AS YEAR_DUE,</cfif>
					<cfelseif attributes.report_type eq 6><!---Bankalar Bazında --->
						ACC.ACCOUNT_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 7><!---Kasalar Bazında --->
						CH.CASH_NAME DSP_REPORT_TYPE,	
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD DSP_REPORT_TYPE,
					</cfif>
						0 GET_CASH_ACTIONS,
						0 GET_CASH_ACTIONS2,
						0 GET_BANK_ACTIONS,
						0 GET_BANK_ACTIONS2,
						0 GET_CHEQUE_ACTIONS,
						0 GET_CHEQUE_ACTIONS2,
						0 GET_VOUCHER_ACTIONS,
						0 GET_VOUCHER_ACTIONS2,
						SUM(CCR.AMOUNT) GET_CC_REVENUE,
						SUM(CCR.AMOUNT / (CR.ACTION_VALUE/#dsn_alias#.IS_ZERO(CR.ACTION_VALUE_2,1))) GET_CC_REVENUE2
					FROM
						CARI_ROWS CR,
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CC,
						#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CCR
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						,#dsn_alias#.COMPANY_CAT CT
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						,#dsn_alias#.SALES_ZONES SZ
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
						,#dsn_alias#.WORKGROUP_EMP_PAR WEP
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						,#dsn_alias#.COMPANY C
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						,#dsn3_alias#.ACCOUNTS ACC
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						,CASH CH
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						,#dsn_alias#.PRO_PROJECTS P
					</cfif>
					WHERE
						CR.FROM_CMP_ID IS NOT NULL AND
						CR.ACTION_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="241,2410" list="yes">) AND
						CR.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
						CC.CREDITCARD_PAYMENT_ID = CCR.CREDITCARD_PAYMENT_ID AND
						CC.CREDITCARD_PAYMENT_ID = CR.ACTION_ID AND
                        ISNULL(CC.IS_VOID,0) <> 1 AND	<!--- bir kredi karti tahsilat islemine ait iptal varsa, hem o tahsilat isleminin hem de iptal isleminin gelmemesi saglandi --->
						ISNULL(CC.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						AND C.COMPANYCAT_ID = CT.COMPANYCAT_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						AND C.SALES_COUNTY = SZ.SZ_ID
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 4><!--- Müşteri Temsilcisi Bazında --->
						AND WEP.POSITION_CODE = EP.POSITION_CODE AND WEP.IS_MASTER=1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#
						AND CR.FROM_CMP_ID = WEP.COMPANY_ID
					<cfelseif attributes.report_type eq 5><!--- Müşteri Bazında --->
						AND CR.FROM_CMP_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 6><!--- Bankalar Bazında --->
						AND
						(
							CR.TO_ACCOUNT_ID = ACC.ACCOUNT_ID OR
							CR.FROM_ACCOUNT_ID = ACC.ACCOUNT_ID
						)
					<cfelseif attributes.report_type eq 7><!--- Kasalar Bazında --->
						AND
						(
							CR.TO_CASH_ID = CH.CASH_ID OR
							CR.FROM_CASH_ID = CH.CASH_ID
						)
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						AND CR.PROJECT_ID = P.PROJECT_ID
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						AND CR.FROM_CMP_ID = #attributes.company_id#
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
					</cfif>
					<cfif len(attributes.customer_value_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
					</cfif>
					<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
					</cfif>
					<cfif len(attributes.zone_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
					</cfif>
					<cfif len(attributes.resource_id)>
						AND CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
					</cfif>
					<cfif len(attributes.project_head) and len(attributes.project_id)>
						AND CR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					GROUP BY
					<cfif attributes.report_type eq 2><!--- üye kategorisi Bazında --->
						CT.COMPANYCAT,
						C.COMPANYCAT_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.BANK_ACTION_DATE),YEAR(CCR.BANK_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 3><!--- Satış Bölgesi Bazında --->
						SZ.SZ_NAME,
						C.SALES_COUNTY
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.BANK_ACTION_DATE),YEAR(CCR.BANK_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 4><!---  Müşteri Temsilcisi Bazında --->
						EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME,
						WEP.POSITION_CODE
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.BANK_ACTION_DATE),YEAR(CCR.BANK_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 5><!---  Müşteri Bazında --->
						C.NICKNAME,
						C.COMPANY_ID
						<cfif isdefined("attributes.is_group_date")>,MONTH(CCR.BANK_ACTION_DATE),YEAR(CCR.BANK_ACTION_DATE)</cfif>
					<cfelseif attributes.report_type eq 6><!---  Bankalar Bazında --->
						ACC.ACCOUNT_NAME
					<cfelseif attributes.report_type eq 7><!---  Kasalar Bazında --->
						CH.CASH_NAME
					<cfelseif attributes.report_type eq 11><!---Proje Bazında --->
						P.PROJECT_HEAD
					</cfif>
				</cfif>
		) GET_CARI_ROWS
		GROUP BY
		<cfif listfind("2,3,4,5",attributes.report_type)>
			PROCESS_ID,
			<cfif isdefined("attributes.is_group_date")>MONTH_DUE,YEAR_DUE,</cfif>
		</cfif>
			DSP_REPORT_TYPE
	<cfelseif attributes.report_type eq 8>
		<cfif attributes.main_report_type eq 1>
        	<!--- kredi karti tahsilat --->
            SELECT
                C.NICKNAME,
                C.MEMBER_CODE,
                SUM(CP.SALES_CREDIT) ACTION_VALUE,
                SUM(CP.COMMISSION_AMOUNT) COMMISSION_AMOUNT,
                SUM(CP.OTHER_CASH_ACT_VALUE) OTHER_CASH_ACT_VALUE,
                CP.OTHER_MONEY,
                CP.ACTION_CURRENCY_ID,
                1 TYPE
            FROM
                #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CP,
                #dsn_alias#.COMPANY C
            WHERE
                CP.ACTION_FROM_COMPANY_ID IS NOT NULL AND
                CP.ACTION_FROM_COMPANY_ID = C.COMPANY_ID AND
                CP.OTHER_MONEY IS NOT NULL AND
                CP.OTHER_CASH_ACT_VALUE IS NOT NULL AND
                CP.STORE_REPORT_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
                ISNULL(CP.IS_VOID,0) <> 1 AND	<!--- bir kredi karti tahsilat islemine ait iptal varsa, hem o tahsilat isleminin hem de iptal isleminin gelmemesi saglandi --->
                ISNULL(CP.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
            <cfif len(trim(attributes.company)) and len(attributes.company_id)>
                AND CP.ACTION_FROM_COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
            </cfif>
            <cfif len(attributes.customer_value_id)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
            </cfif>
            <cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
            </cfif>
            <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
            </cfif>
            <cfif len(attributes.zone_id)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
            </cfif>
            <cfif len(attributes.resource_id)>
                AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
            </cfif>
            <cfif len(attributes.project_head) and len(attributes.project_id)>
                AND CP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfif>
            GROUP BY
                C.NICKNAME,
                C.MEMBER_CODE,
                CP.OTHER_MONEY,
                CP.ACTION_CURRENCY_ID
            ORDER BY
                C.NICKNAME
		<cfelseif attributes.main_report_type eq 2>
			SELECT
				C.NICKNAME,
				C.MEMBER_CODE,
				SUM(CP.TOTAL_COST_VALUE) ACTION_VALUE,
				0 COMMISSION_AMOUNT,
				SUM(CP.OTHER_COST_VALUE) OTHER_CASH_ACT_VALUE,
				CP.OTHER_MONEY,
				CP.ACTION_CURRENCY_ID
			FROM
				#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CP,
				#dsn_alias#.COMPANY C
			WHERE
				CP.ACTION_TO_COMPANY_ID IS NOT NULL AND
				CP.ACTION_TO_COMPANY_ID = C.COMPANY_ID AND
				CP.OTHER_MONEY IS NOT NULL AND
				CP.OTHER_COST_VALUE IS NOT NULL AND
				CP.ACTION_DATE BETWEEN #attributes.date1# AND #attributes.date2#
			<cfif len(trim(attributes.company)) and len(attributes.company_id)>
				AND CP.ACTION_TO_COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
			</cfif>
			<cfif len(attributes.customer_value_id)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
			</cfif>
			<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
			</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
			</cfif>
			<cfif len(attributes.zone_id)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
			</cfif>
			<cfif len(attributes.resource_id)>
				AND CP.ACTION_TO_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
			</cfif>
			<cfif len(attributes.project_head) and len(attributes.project_id)>
				AND CP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			GROUP BY
				C.NICKNAME,
				C.MEMBER_CODE,
				CP.OTHER_MONEY,
				CP.ACTION_CURRENCY_ID
			ORDER BY
				C.NICKNAME
		</cfif>
	<cfelseif listfind("9,10",attributes.report_type)>
		SELECT
			C.NICKNAME,
			C.MEMBER_CODE,
			C.COMPANY_ID,
		<cfif attributes.report_type eq 10>
			F_I_ROW.PROCESS_DATE,
		</cfif>
			SUM(CP.SALES_CREDIT) ACTION_VALUE,
			SUM(CP.SALES_CREDIT/MONEY2_MULTIPLIER) ACTION_VALUE2,
			CP.ACTION_CURRENCY_ID,
			F_I_ROW.BANK_TYPE
		FROM
			FILE_IMPORT_BANK_POS_ROWS F_I_ROW,
			#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CP,
			#dsn_alias#.COMPANY C
		WHERE
			CP.CREDITCARD_PAYMENT_ID = F_I_ROW.CC_REVENUE_ID AND
			CP.ACTION_FROM_COMPANY_ID = C.COMPANY_ID AND
			CP.ACTION_PERIOD_ID = #session.ep.period_id# AND
			CP.ACTION_FROM_COMPANY_ID IS NOT NULL AND
			CP.OTHER_MONEY IS NOT NULL AND
			CP.OTHER_CASH_ACT_VALUE IS NOT NULL AND
			CP.ACTION_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="241,2410" list="yes">) AND
			F_I_ROW.PROCESS_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
            ISNULL(CP.IS_VOID,0) <> 1 AND	<!--- bir kredi karti tahsilat islemine ait iptal varsa, hem o tahsilat isleminin hem de iptal isleminin gelmemesi saglandi --->
			ISNULL(CP.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
		<cfif len(trim(attributes.company)) and len(attributes.company_id)>
			AND CP.ACTION_FROM_COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER = 1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
		</cfif>
		<cfif len(attributes.customer_value_id)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_VALUE_ID = #attributes.customer_value_id#)
		</cfif>
		<cfif isdefined ('attributes.companycat_id') and len(attributes.companycat_id)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID IN (#attributes.companycat_id#))
		</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE IMS_CODE_ID = #attributes.ims_code_id#)
		</cfif>
		<cfif len(attributes.zone_id)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SALES_COUNTY = #attributes.zone_id#)
		</cfif>
		<cfif len(attributes.resource_id)>
			AND CP.ACTION_FROM_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE RESOURCE_ID = #attributes.resource_id#)
		</cfif>
		<cfif len(attributes.project_head) and len(attributes.project_id)>
			AND CP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		GROUP BY
			C.NICKNAME,
			C.MEMBER_CODE,
			C.COMPANY_ID,
		<cfif attributes.report_type eq 10>
			F_I_ROW.PROCESS_DATE,
		</cfif>
			CP.ACTION_CURRENCY_ID,
			F_I_ROW.BANK_TYPE
		ORDER BY
			C.NICKNAME
	</cfif>
</cfquery>
<cfif isdefined("attributes.is_group_date") and listfind("2,3,4,5",attributes.report_type)>
	<cfquery name="get_cari_rows_due" dbtype="query">
		SELECT
			MONTH_DUE,
			YEAR_DUE,
			DSP_REPORT_TYPE,
			PROCESS_ID,
			SUM(GET_CHEQUE_ACTIONS + GET_CASH_ACTIONS + GET_BANK_ACTIONS + GET_VOUCHER_ACTIONS + GET_CC_REVENUE) AS TUTAR
		FROM
			get_cari_rows
		GROUP BY
			MONTH_DUE,
			YEAR_DUE,
			PROCESS_ID,
			DSP_REPORT_TYPE
	</cfquery>
	<cfquery name="get_cari_rows" dbtype="query">
		SELECT
			DSP_REPORT_TYPE,
			PROCESS_ID,
			SUM(GET_CHEQUE_ACTIONS + GET_CASH_ACTIONS + GET_BANK_ACTIONS + GET_VOUCHER_ACTIONS + GET_CC_REVENUE) AS TUTAR
		FROM
			get_cari_rows
		GROUP BY
			PROCESS_ID,
			DSP_REPORT_TYPE
	</cfquery>
</cfif> 
