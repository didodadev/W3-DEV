<cf_xml_page_edit fuseact="report.detail_opportunity_report">
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.opp_currency_id" default="">
<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.probability" default="">
<cfparam name="attributes.sales_add_option" default="">
<cfparam name="attributes.sales_county" default="">
<cfparam name="attributes.companycat_id" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.resource" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.sales_partner_company_id" default="">
<cfparam name="attributes.sales_partner_company" default="">
<cfparam name="attributes.sales_emp_id" default="">
<cfparam name="attributes.sales_emp" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ref_member" default="">
<cfparam name="attributes.ref_company" default="">
<cfparam name="attributes.ref_member_id" default="">
<cfparam name="attributes.ref_member_type" default="">
<cfparam name="attributes.ref_company_id" default="">
<cfparam name="attributes.commethod_id" default="">
<cfparam name="attributes.team_id" default="">
<cfparam name="attributes.team_name" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.is_form_submitted" default="">
<cfparam name="attributes.opp_status" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.date_filter" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.process_row_id" default="">
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#"><!--- Müşteri Değeri --->
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#"><!--- Fırsat Kategori --->
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfquery name="SZ" datasource="#DSN#"><!--- Satış Bölgeleri --->
   SELECT SZ_ID, SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_OPP_CURRENCIES" datasource="#DSN3#"><!--- Aşama --->
	SELECT OPP_CURRENCY_ID, OPP_CURRENCY FROM OPPORTUNITY_CURRENCY ORDER BY OPP_CURRENCY
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		(PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.form_upd_opportunity%"> OR PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.form_add_opportunity%">)
	ORDER BY
		PTR.LINE_NUMBER,
		PTR.STAGE
</cfquery>
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#"><!--- Özel Tanım --->
	SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
</cfquery>
<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
		DISTINCT
		CT.COMPANYCAT_ID, 
		CT.COMPANYCAT
	FROM
		COMPANY_CAT CT,
		COMPANY_CAT_OUR_COMPANY CO
	WHERE
		CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
		CO.OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#)
	ORDER BY
		COMPANYCAT
</cfquery>
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset get_country = cmp.getCountry()>
<cfif isdefined('is_form_submitted') and len(attributes.is_form_submitted)>
	<cfif isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
	<cfif isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>
    <cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
    <cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
	<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
		SELECT
        	ISNULL(OPPORTUNITIES.MONEY,'#session.ep.money#') MONEY,
			ISNULL(OPPORTUNITIES.MONEY2,'#session.ep.money#') MONEY2,
			<cfif listfind("2,4,5,6,8,9,10",attributes.report_type,',')><!--- Takım,Kategori,Bolge,Il Bazında --->
				ISNULL(SUM(OPPORTUNITIES.COST),0) COST,
				ISNULL(SUM(OPPORTUNITIES.INCOME),0) INCOME,
			<cfelse>
				OPPORTUNITIES.COST,
				OPPORTUNITIES.INCOME,
                <!---OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID,---><!---SMH--->
			</cfif>
			<cfif not len(attributes.report_type)>
				OPPORTUNITY_TYPE_ID,
                OPP_ID,
				OPP_STAGE,
				PROCESS_TYPE_ROWS.STAGE,
				OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID,
				PROBABILITY,
				PROJECT_ID,
				SALE_ADD_OPTION_ID,
				SALES_EMP_ID,
				COMPANY_ID,
				PARTNER_ID,
				CONSUMER_ID,
				SALES_PARTNER_ID,
				OPP_HEAD,
				REF_PARTNER_ID,
				REF_COMPANY_ID,
				REF_CONSUMER_ID,
				OPP_STATUS,
                OPP_CURRENCY
			<cfelseif attributes.report_type eq 1><!--- Satış Çalışanı Bazında --->
				SALES_EMP_ID,
				COUNT(SALES_EMP_ID) SATIS_CALISAN_TOPLAM
			<cfelseif attributes.report_type eq 2><!--- Takım Bazında --->
				COUNT(OPPORTUNITIES.COMPANY_ID) FIRSAT_SAYISI,
				STP.TEAM_NAME REPORT_GROUP_TYPE
			<cfelseif attributes.report_type eq 3><!--- Satış Ortağı Bazında --->
				SALES_PARTNER_ID,
				COUNT(SALES_PARTNER_ID) SATIS_ORTAGI_TOPLAM
			<cfelseif attributes.report_type eq 4><!--- Kategori Bazında --->
				OPPORTUNITY_TYPE_ID,
				COUNT(OPPORTUNITY_TYPE_ID) KATEGORI_TOPLAM
			<cfelseif attributes.report_type eq 5><!--- Satış Bölgesi Bazında --->			
				COUNT(OPPORTUNITIES.COMPANY_ID) FIRSAT_SAYISI_B,
				SALES_ZONES.SZ_NAME REPORT_GROUP_TYPE
			<cfelseif attributes.report_type eq 6><!--- Il Bazinda --->
				COUNT(SETUP_CITY.CITY_NAME) AS BOLGELER,
				SETUP_CITY.CITY_NAME AS REPORT_GROUP_TYPE
			<cfelseif attributes.report_type eq 7><!--- Urun Kategorisi Bazinda --->
				PC.PRODUCT_CAT
			<cfelseif attributes.report_type eq 8><!--- Surec Bazinda --->
				PTR.PROCESS_ROW_ID,
				COUNT(PTR.PROCESS_ROW_ID) AS SUREC
			<cfelseif attributes.report_type eq 9><!--- Olasılık Bazinda --->
				OPPORTUNITIES.PROBABILITY,
				COUNT(OPPORTUNITIES.PROBABILITY) AS OLASILIK
            <cfelseif attributes.report_type eq 10><!--- Aşama Bazinda--->
				OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID,
				COUNT(OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID) AS ASAMA                   
			</cfif>
            <cfif x_update_date eq 1>
				,OPPORTUNITIES.UPDATE_DATE
			</cfif>
            <cfif x_country eq 1>
				,SETUP_COUNTRY.COUNTRY_NAME
                ,SALES_ZONES.SZ_NAME
			</cfif>
		FROM
            OPPORTUNITIES
            LEFT JOIN #dsn3_alias#.OPPORTUNITY_CURRENCY ON OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID = OPPORTUNITIES.OPP_CURRENCY_ID<!---SMH--->
            LEFT JOIN #dsn_alias#.SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID=OPPORTUNITIES.COUNTRY_ID
			LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID=OPPORTUNITIES.OPP_STAGE
            LEFT JOIN #dsn_alias#.SALES_ZONES ON SALES_ZONES.SZ_ID=OPPORTUNITIES.SZ_ID
			<cfif attributes.report_type eq 2>
				,#dsn_alias#.COMPANY COMPANY
				,#dsn_alias#.SALES_ZONES_TEAM STP
			<cfelseif attributes.report_type eq 5>
				,#dsn_alias#.COMPANY
				
			<cfelseif attributes.report_type eq 6>
				,#dsn_alias#.COMPANY
				,#dsn_alias#.SETUP_CITY AS SETUP_CITY
			<cfelseif attributes.report_type eq 7>
				,PRODUCT_CAT AS PC
			<cfelseif attributes.report_type eq 8>
				,#dsn_alias#.PROCESS_TYPE_ROWS AS PTR    
			</cfif>
		WHERE
			1=1
			<cfif len(attributes.date1) and isdate(attributes.date1)>
				AND OPP_DATE >= #attributes.date1#
			</cfif>
			<cfif len(attributes.date2) and isdate(attributes.date2)>
				AND OPP_DATE <= #attributes.date2#
			</cfif>
            <cfif len(attributes.start_date)>
				AND OPPORTUNITIES.UPDATE_DATE >=#attributes.start_date#
			</cfif>
            <cfif len(attributes.finish_date)>
				AND OPPORTUNITIES.UPDATE_DATE <=#attributes.finish_date#
			</cfif>
			<cfif len(attributes.opp_status)>
				AND OPPORTUNITIES.OPP_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.opp_status#">
			</cfif>
			<cfif isdefined("attributes.project_id") and  len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
				AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
           
			<cfif attributes.report_type eq 2>
				AND STP.SALES_ZONES = COMPANY.SALES_COUNTY
				AND OPPORTUNITIES.COMPANY_ID = COMPANY.COMPANY_ID
				AND STP.TEAM_ID IN (SELECT
										TEAM_ID
									FROM
										#dsn_alias#.SALES_ZONES_TEAM_ROLES
									WHERE
										POSITION_CODE IN(SELECT POSITION_CODE FROM #dsn_alias#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = OPPORTUNITIES.SALES_EMP_ID))
			<cfelseif attributes.report_type eq 4>
				AND OPPORTUNITY_TYPE_ID IS NOT NULL
			<cfelseif attributes.report_type eq 5>
				AND COMPANY.COMPANY_ID = OPPORTUNITIES.COMPANY_ID
				AND SALES_ZONES.SZ_ID = COMPANY.SALES_COUNTY
			<cfelseif attributes.report_type eq 6>
				AND COMPANY.COMPANY_ID = OPPORTUNITIES.COMPANY_ID 
				AND COMPANY.CITY = SETUP_CITY.CITY_ID
				AND COMPANY.CITY IS NOT NULL
				AND COMPANY.CITY <> 0
			<cfelseif attributes.report_type eq 7>
				AND PC.PRODUCT_CATID = OPPORTUNITIES.PRODUCT_CAT_ID
			<cfelseif attributes.report_type eq 8>
				AND PTR.PROCESS_ROW_ID = OPPORTUNITIES.OPP_STAGE
            <cfelseif attributes.report_type eq 10>
				AND OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID = OPPORTUNITIES.OPP_CURRENCY_ID    
			</cfif>
			<cfif len(attributes.opportunity_type_id)>AND OPPORTUNITY_TYPE_ID IN(#attributes.opportunity_type_id#)</cfif>
			<cfif len(attributes.commethod_id)>AND COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> </cfif>
			<cfif len(attributes.opp_currency_id)> AND OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID IN(#attributes.opp_currency_id#)</cfif><!---smh???değiştim OPPORTUNITY_CURRENCY ekledim--->		
			<cfif len(attributes.probability)>AND PROBABILITY IN (#attributes.probability#)</cfif>
			<cfif len(attributes.sales_add_option)>AND SALE_ADD_OPTION_ID IN(#attributes.sales_add_option#)</cfif>
            <cfif len(attributes.process_row_id)>AND OPPORTUNITIES.OPP_STAGE IN(#attributes.process_row_id#)</cfif>
			<!---<cfif len(attributes.sales_county)><!--- Satış Bölgesi --->
				AND OPPORTUNITIES.COMPANY_ID IN
				(
					SELECT 
					  COMPANY.COMPANY_ID
					FROM
						#dsn_alias#.SALES_ZONES AS SALES_ZONES,
						#dsn_alias#.COMPANY AS COMPANY
					WHERE 
						SALES_ZONES.SZ_ID = COMPANY.SALES_COUNTY
						AND SALES_ZONES.SZ_ID IN (#attributes.sales_county#)
				)
			</cfif>--->
           <cfif len(attributes.sales_county)>
                AND OPPORTUNITIES.SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_county#">
            </cfif>
            <cfif isdefined("attributes.country") and len(attributes.country)>
                AND OPPORTUNITIES.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#">
            </cfif>
			<cfif len(attributes.companycat_id)><!--- Müşteri Kategorisi --->
				AND OPPORTUNITIES.COMPANY_ID IN
				(	SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANYCAT_ID IN(#attributes.companycat_id#)	)
			</cfif>
			<cfif len(attributes.customer_value)><!--- Müşteri Değeri --->
				AND OPPORTUNITIES.COMPANY_ID IN
				(	SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_VALUE_ID IN(#attributes.customer_value#)	)
			</cfif>
			<cfif len(attributes.resource)><!--- Iliski Tipi --->
				AND OPPORTUNITIES.COMPANY_ID IN
				(	SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.RESOURCE_ID IN(#attributes.resource#)	)
			</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)><!--- Mikro Bölge Kodu --->
				AND OPPORTUNITIES.COMPANY_ID IN
				(	SELECT C.COMPANY_ID FROM #dsn_alias#.COMPANY C WHERE C.IMS_CODE_ID IN(#attributes.ims_code_id#)	)
			</cfif>
			<cfif len(attributes.team_id) and len(attributes.team_name)><!--- Satış Takımı --->
				AND OPPORTUNITIES.SALES_TEAM_ID IN (#attributes.team_id#)
			</cfif>
			<cfif len(attributes.sales_partner_id) and len(attributes.sales_partner)><!--- Satış Ortağı --->
				AND SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_partner_id#">
			</cfif>
			<cfif len(attributes.sales_partner_company_id) and len(attributes.sales_partner_company)><!--- Satış Ortağı Şirket--->
				AND 
				(
                    SALES_PARTNER_ID IS NOT NULL AND
                    SALES_PARTNER_ID IN (SELECT PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_partner_company_id#">) 
				)
			</cfif>
			<cfif len(attributes.sales_emp_id) and len(attributes.sales_emp)><!--- Satış Çalışanı --->
				AND SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#">
			</cfif>
			<cfif len(attributes.ref_member_type) and len(attributes.ref_member_id)><!--- Referans --->
				<cfif attributes.ref_member_type eq 'partner'>
					AND REF_PARTNER_ID IN(#attributes.ref_member_id#)
				<cfelseif attributes.ref_member_type eq 'consumer'>
					AND REF_CONSUMER_ID IN(#attributes.ref_member_id#)
				</cfif>
			</cfif>
			<cfif attributes.report_type eq 1>
				AND SALES_EMP_ID IS NOT NULL
				GROUP BY SALES_EMP_ID,OPPORTUNITIES.INCOME,OPPORTUNITIES.COST,MONEY,MONEY2 <cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME</cfif> 
				ORDER BY SATIS_CALISAN_TOPLAM DESC
			<cfelseif attributes.report_type eq 2>
				GROUP BY STP.TEAM_NAME,MONEY,MONEY2<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
			<cfelseif attributes.report_type eq 3>
				AND SALES_PARTNER_ID IS NOT NULL
				GROUP BY SALES_PARTNER_ID,OPPORTUNITIES.INCOME,OPPORTUNITIES.COST,MONEY,MONEY2<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY SATIS_ORTAGI_TOPLAM DESC
			<cfelseif attributes.report_type eq 4>
				GROUP BY OPPORTUNITY_TYPE_ID,MONEY,MONEY2<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY KATEGORI_TOPLAM DESC
			<cfelseif attributes.report_type eq 5>
				GROUP BY SALES_ZONES.SZ_NAME,MONEY,MONEY2<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME </cfif>
			<cfelseif attributes.report_type eq 6>
				GROUP BY SETUP_CITY.CITY_NAME,MONEY,MONEY2<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY BOLGELER DESC
			<cfelseif attributes.report_type eq 8>
				AND PTR.PROCESS_ROW_ID IS NOT NULL
				GROUP BY PTR.PROCESS_ROW_ID,ISNULL(OPPORTUNITIES.MONEY,'#session.ep.money#'),ISNULL(OPPORTUNITIES.MONEY2,'#session.ep.money#')<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY PTR.PROCESS_ROW_ID DESC
			<cfelseif attributes.report_type eq 9>
				AND OPPORTUNITIES.OPP_CURRENCY_ID IS NOT NULL
				GROUP BY OPPORTUNITIES.PROBABILITY,ISNULL(OPPORTUNITIES.MONEY,'#session.ep.money#'),ISNULL(OPPORTUNITIES.MONEY2,'#session.ep.money#')<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY OPPORTUNITIES.PROBABILITY DESC
            <cfelseif attributes.report_type eq 10>
				AND OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID IS NOT NULL
				GROUP BY OPPORTUNITY_CURRENCY.OPP_CURRENCY,OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID,ISNULL(OPPORTUNITIES.MONEY,'#session.ep.money#'),ISNULL(OPPORTUNITIES.MONEY2,'#session.ep.money#')<cfif x_update_date eq 1>,OPPORTUNITIES.UPDATE_DATE</cfif><cfif x_country eq 1>,SETUP_COUNTRY.COUNTRY_NAME,SALES_ZONES.SZ_NAME </cfif>
				ORDER BY OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID DESC    
			</cfif>
			<cfif not len(attributes.report_type)>
				<cfif attributes.date_filter eq 1>
                    ORDER BY OPPORTUNITIES.UPDATE_DATE
                <cfelseif attributes.date_filter eq 2>
                    ORDER BY OPPORTUNITIES.UPDATE_DATE DESC
                </cfif>
            </cfif>
	</cfquery>
<cfelse>
	<cfset get_opportunity.recordcount=0>	
</cfif>
<cfset url_str = "">
<cfif len(attributes.companycat_id)>
	<cfset url_str = url_str&"&companycat_id="&attributes.companycat_id>
</cfif>
<cfif len(attributes.customer_value)>
	<cfset url_str = url_str&"&customer_value="&attributes.customer_value>
</cfif>
<cfif len(attributes.ims_code_id)>
	<cfset url_str = url_str&"&ims_code_id="&attributes.ims_code_id>
</cfif>
<cfif len(attributes.ims_code_name)>
	<cfset url_str = url_str&"&ims_code_name="&attributes.ims_code_name>
</cfif>
<cfif len(attributes.is_form_submitted)>
	<cfset url_str = url_str&"&is_form_submitted="&attributes.is_form_submitted>
</cfif>
<cfif len(attributes.opportunity_type_id)>
	<cfset url_str = url_str&"&opportunity_type_id="&attributes.opportunity_type_id>
</cfif>
<cfif len(attributes.opp_currency_id)>
	<cfset url_str = url_str&"&opp_currency_id="&attributes.opp_currency_id>
</cfif>
<cfif len(attributes.probability)>
	<cfset url_str = url_str&"&probability="&attributes.probability>
</cfif>
<cfif len(attributes.ref_company)>
	<cfset url_str = url_str&"&ref_company="&attributes.ref_company>
</cfif>
<cfif len(attributes.ref_company_id)>
	<cfset url_str = url_str&"&ref_company_id="&attributes.ref_company_id>
</cfif>
<cfif len(attributes.ref_member)>
	<cfset url_str = url_str&"&ref_member="&attributes.ref_member>
</cfif>
<cfif len(attributes.ref_member_type)>
	<cfset url_str = url_str&"&ref_member_type="&attributes.ref_member_type>
</cfif>
<cfif len(attributes.report_type)>
	<cfset url_str = url_str&"&report_type="&attributes.report_type>
</cfif>
<cfif len(attributes.resource)>
	<cfset url_str = url_str&"&resource="&attributes.resource>
</cfif>
<cfif len(attributes.sales_add_option)>
	<cfset url_str = url_str&"&sales_add_option="&attributes.sales_add_option>
</cfif>
<cfif len(attributes.sales_county)>
	<cfset url_str = url_str&"&sales_county="&attributes.sales_county>
</cfif>
<cfif len(attributes.sales_emp)>
	<cfset url_str = url_str&"&sales_emp="&attributes.sales_emp>
</cfif>
<cfif len(attributes.sales_emp_id)>
	<cfset url_str = url_str&"&sales_emp_id="&attributes.sales_emp_id>
</cfif>
<cfif len(attributes.sales_partner)>
	<cfset url_str = url_str&"&sales_partner="&attributes.sales_partner>
</cfif>
<cfif len(attributes.sales_partner_id)>
	<cfset url_str = url_str&"&sales_partner_id="&attributes.sales_partner_id>
</cfif>
<cfif len(attributes.team_id)>
	<cfset url_str = url_str&"&team_id="&attributes.team_id>
</cfif>
<cfif len(attributes.team_name)>
	<cfset url_str = url_str&"&team_name="&attributes.team_name>
</cfif>
<cfif len(attributes.date1)>
	<cfset url_str = url_str&"&date1="&DateFormat(attributes.date1,dateformat_style)>
</cfif>
<cfif len(attributes.date2)>
	<cfset url_str = url_str&"&date2="&DateFormat(attributes.date2,dateformat_style)>
</cfif>
<cfif len(attributes.graph_type)>
	<cfset url_str = "#url_str#&graph_type=#attributes.graph_type#">
</cfif>
<cfif len(attributes.is_excel)>
	<cfset url_str = "#url_str#&is_excel=#attributes.is_excel#">
</cfif>
<cfif  len(attributes.project_id) and len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
</cfif>
<cfif len(attributes.country)>
	<cfset url_str = "#url_str#&country=#attributes.country#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.process_row_id)>
	<cfset url_str = "#url_str#&process_row_id=#attributes.process_row_id#">
</cfif>
<cfset url_str = "#url_str#&opp_status=#attributes.opp_status#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_opportunity.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset partner_id_list=''>
<cfset company_id_list=''>
<cfset consumer_id_list=''>
<cfset sales_pcode_list=''>
<cfset sales_add_option_list=''>
<cfset opportunity_type_list = ''>
<cfset opp_currency_id_list = ''>
<cfset sales_team_list = ''>
<cfset probability_rate_list = ''>
<cfset process_row_id_list = ''>
<cfset project_id_list = ''>

<cfform name="report_opportunity" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.detail_opportunity_report">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40293.Detaylı Fırsat Raporu'></cfsavecontent>
<cf_report_list_search id="member_report_" title="#title#">
<cf_report_list_search_area>
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
	<div class="row">
        <div class="col col-12 col-xs-12">
            <div class="row formContent">
				<div class="row" type="row">
                    <div class="col col-3 col-md-6 col-xs-12">
                        <div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39285.Satış Takımı'></label>							
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="team_id" id="team_id" value="<cfoutput>#attributes.team_id#</cfoutput>">
									<input type="text" name="team_name" id="team_name" style="width:153px;" value="<cfoutput>#attributes.team_name#</cfoutput>" onFocus="AutoComplete_Create('team_name','TEAM_NAME','TEAM_NAME,SZ_NAME','get_team','','TEAM_ID','team_id','','3','150');">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zones_team&field_sz_team_id=report_opportunity.team_id&field_sz_team_name=report_opportunity.team_name','list');"></span>
								</div>
							</div>                            
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='38862.Satış Ortağı Şirket'></label>
							<div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="sales_partner_company_id" id="sales_partner_company_id" value="<cfoutput>#attributes.sales_partner_company_id#</cfoutput>">
									<input type="text" name="sales_partner_company" id="sales_partner_company" value="<cfoutput>#attributes.sales_partner_company#</cfoutput>" style="width:153px;" onfocus="AutoComplete_Create('sales_partner_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','sales_partner_company_id','','3','250');" autocomplete="off">					
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=report_opportunity.sales_partner_company_id&field_comp_name=report_opportunity.sales_partner_company&select_list=2','list');"></span>
                                </div>
                            </div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='38860.Satış Ortağı Yetkilisi'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
                                    <input type="hidden" name="sales_partner_id" id="sales_partner_id" value="<cfoutput>#attributes.sales_partner_id#</cfoutput>">
									<input type="text" name="sales_partner" id="sales_partner" value="<cfoutput>#attributes.sales_partner#</cfoutput>" style="width:153px;" onfocus="AutoComplete_Create('sales_partner','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME3,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,CONSUMER_ID','sales_partner_id,sales_partner_id','','3','250');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=report_opportunity.sales_partner_id&field_name=report_opportunity.sales_partner&select_list=2,3','list');"></span>
                                </div>
                            </div>
						</div>						
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='40294.Satış Çalışanı'></label>
							<div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfif isdefined('attributes.sales_emp_id') and len(attributes.sales_emp_id) and isdefined('attributes.sales_emp') and len(attributes.sales_emp)><cfoutput>#attributes.sales_emp_id#</cfoutput></cfif>">
									<input type="text" name="sales_emp" id="sales_emp" value="<cfif isdefined('attributes.sales_emp_id') and len(attributes.sales_emp_id) and isdefined('attributes.sales_emp') and len(attributes.sales_emp)><cfoutput>#attributes.sales_emp#</cfoutput></cfif>" style="width:153px;" onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','add_opp','3','140');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=report_opportunity.sales_emp_id&field_name=report_opportunity.sales_emp&select_list=1','list');"></span>		
                                </div>
                            </div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
							<div class="col col-9 col-xs-12">
                                <div class="input-group">
									<input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfoutput>#attributes.ref_company_id#</cfoutput>">
									<input type="hidden" name="ref_partner_id" id="ref_partner_id" value="">
									<input type="hidden" name="ref_member_type" id="ref_member_type" value="<cfoutput>#attributes.ref_member_type#</cfoutput>">
									<input type="hidden" name="ref_member_id" id="ref_member_id" value="<cfoutput>#attributes.ref_member_id#</cfoutput>">
									<input type="text" name="ref_company" id="ref_company" value="<cfoutput>#attributes.ref_company#</cfoutput>" onfocus="AutoComplete_Create('ref_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,MEMBER_PARTNER_NAME','ref_company_id,ref_member_id,ref_member_id,ref_member_id,ref_member_type,ref_member','add_opp','3','250','return_company()');" autocomplete="off">
									<input type="hidden" name="ref_member" id="ref_member" value="<cfoutput>#attributes.ref_member#</cfoutput>" style="width:153px;">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=report_opportunity.ref_member_id&field_consumer=report_opportunity.ref_member_id&field_comp_id=report_opportunity.ref_company_id&field_comp_name=report_opportunity.ref_company&field_name=report_opportunity.ref_member&field_type=report_opportunity.ref_member_type&select_list=7,8','list');"></span>
                                </div>
                            </div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57416.proje'></label>
							<div class="col col-9 col-xs-12">
                                <div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
									<input type="text" name="project_head"  id="project_head" style="width:153px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                                </div>
                            </div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39080.Mikro Bölge'></label>
							<div class="col col-9 col-xs-12">
                                <div class="input-group">
									<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
									<input type="text" name="ims_code_name" id="ims_code_name" style="width:153px;" passthrough="readonly=yes;" value="<cfoutput>#attributes.ims_code_name#</cfoutput>" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=report_opportunity.ims_code_name&field_id=report_opportunity.ims_code_id&select_list=1','list');return false"></span>
                                </div>
                            </div>
						</div>
					</div>
					<div class="col col-3 col-md-6 col-xs-12">
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39741.Grafik'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<select name="graph_type" id="graph_type" style="width:90px;">
										<option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>                   
										<option value="line"<cfif attributes.graph_type eq 'line'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
										<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
									</select>
									<span class="input-group-addon no-bg"></span>
									<select name="opp_status" id="opp_status" style="width:57px;">
										<option value=""<cfif not len(attributes.opp_status)> selected</cfif>><cf_get_lang dictionary_id='58081.hepsi'>
										<option value="1"<cfif attributes.opp_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.aktif'>
										<option value="0"<cfif attributes.opp_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.pasif'>                
									</select>
								</div>
							</div>				
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39242.Müşteri Kategorisi'></label> 
							<div class="col col-9 col-xs-12">
								<select name="companycat_id" id="companycat_id" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_companycat">
										<option value="#companycat_id#" <cfif attributes.companycat_id eq companycat_id>selected </cfif>>#companycat#</option>
									</cfoutput>
								</select>	
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label> 
							<div class="col col-9 col-xs-12">
								<select name="customer_value" id="customer_value" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_customer_value">
									   <option value="#customer_value_id#" <cfif attributes.customer_value eq customer_value_id>selected</cfif>>#customer_value#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39224.İlişki Tipi'></label> 
							<div class="col col-9 col-xs-12">
								<cf_wrk_combo
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								option_name="resource"
								option_value="resource_id"
								value="#attributes.resource#"
								width="150">
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label> 
							<div class="col col-9 col-xs-12">
								<select name="report_type" id="report_type" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1"<cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39722.Çalışan Bazında'></option>
									<option value="2"<cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='58511.Takım'> <cf_get_lang dictionary_id ='58601.Bazında'></option>
									<option value="3"<cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='40278.Satış Ortağı Bazında'></option>
									<option value="4"<cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='39052.Kategori Bazında'></option>
									<option value="5"<cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id ='57992.Bölge'><cf_get_lang dictionary_id ='58601.Bazında'> </option>
									<option value="6"<cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id ='58608.İl'> <cf_get_lang dictionary_id ='58601.Bazında'></option>
									<option value="7"<cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id ='39723.Ürün Kategorisi Bazında'></option>
									<option value="8"<cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id ='58859.Süreç'> <cf_get_lang dictionary_id ='58601.Bazında'></option>
									<option value="9"<cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang dictionary_id ='58652.Olasılık'> <cf_get_lang dictionary_id ='58601.Bazında'></option>
									<option value="10"<cfif attributes.report_type eq 10>selected</cfif>><cf_get_lang dictionary_id ='57482.Aşama'><cf_get_lang dictionary_id ='58601.Bazında'></option>                    
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="40267.Sıralama Şekli"></label> 
							<div class="col col-9 col-xs-12">
								<cfif isdefined("attributes.date_filter")>
									<select name="date_filter" id="date_filter" style="width:160px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1" <cfif attributes.date_filter eq 1>selected</cfif>><cf_get_lang dictionary_id ='40479.Günceleme Tarihi'> <cf_get_lang dictionary_id ='57925.Artan Tarih'></option>
										<option value="2" <cfif attributes.date_filter eq 2>selected</cfif>><cf_get_lang dictionary_id ='40479.Günceleme Tarihi'> <cf_get_lang dictionary_id ='57926.Azalan Tarih'></option>
									</select>
								</cfif>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label> 
							<div class="col col-9 col-xs-12">
								<select name="sales_county" id="sales_county" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="sz">
										<option value="#sz_id#"<cfif attributes.sales_county eq sz_id>selected</cfif>>#sz_name#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label> 
							<div class="col col-9 col-xs-12">
								<select name="country" id="country" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_country">
										<option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
					</div>
					<div class="col col-3 col-md-6 col-xs-12">
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57486.Kategori"></label>
							<div class="col col-9 col-xs-12">
								<select name="opportunity_type_id" id="opportunity_type_id" style="width:160px;height:60px;" multiple="multiple">
									<cfoutput query="get_opportunity_type">
										<option value="#opportunity_type_id#" <cfif ListFind(attributes.opportunity_type_id,opportunity_type_id,',')>selected</cfif>>#opportunity_type#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-9 col-xs-12">
								<select name="process_row_id" id="process_row_id" style="width:160px;height:60px;" multiple="multiple">
									<cfoutput query="get_process_stage">
										<option value="#process_row_id#"<cfif ListFind(attributes.process_row_id,process_row_id,',')> selected</cfif>>#stage#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-9 col-xs-12">
								<select name="opp_currency_id" id="opp_currency_id" style="width:160px;height:60px;" multiple="multiple">
									<cfoutput query="get_opp_currencies">
										<option value="#opp_currency_id#"<cfif ListFind(attributes.opp_currency_id,opp_currency_id,',')> selected</cfif>>#opp_currency#</option>
									</cfoutput>
								</select>
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='55434.Başvuru Tarihi'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
									<cfinput value="#Dateformat(attributes.date1,dateformat_style)#" type="text" maxlength="10" name="date1" message="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>            
									<span class="input-group-addon no-bg"></span>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput value="#Dateformat(attributes.date2,dateformat_style)#"  type="text" maxlength="10" name="date2" message="#message#" validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span> 
								</div>
							</div>
                        </div>
						<cfif x_update_date eq 1>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='40479.Güncelleme Tarihi'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>            
									<span class="input-group-addon no-bg"></span>
									<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span> 
								</div>
							</div>
                        </div>
						</cfif>
						<div class="form-group" id="item-commethod_id">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='731.İletişim'></label>
							<div class="col col-9 col-xs-12">
								<cf_wrkComMethod width="140" ComMethod_Id="#iif(len(attributes.commethod_id),attributes.commethod_id,DE('commethod_id'))#">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-6 col-xs-12">
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58652.Olasılık'></label>
							<div class="col col-9 col-xs-12">
								<cf_wrk_combo
								name="probability"
								query_name="GET_PROBABILITY_RATE"
								option_name="probability_name"
								option_value="probability_rate_id"
								multiple="1"
								value="#attributes.probability#"
								width="160"
								is_option_text="0"
								height="50">
							</div>
                        </div>
						<div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39282.Özel Tanım'></label>
							<div class="col col-9 col-xs-12">
								<select name="sales_add_option" id="sales_add_option" style="width:160px;height:50px;" multiple>
									<cfoutput query="get_sale_add_option">
										<option value="#sales_add_option_id#" <cfif ListFind(attributes.sales_add_option,sales_add_option_id,',')>selected</cfif>>#sales_add_option_name#</option>
									</cfoutput>
								</select>
							</div>
                        </div>						
					</div>
				</div>
			</div>
            <div class="row ReportContentBorder">
                <div class="ReportContentFooter">
                    <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked="checked"</cfif>></label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
					<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
					<cfelse>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
					</cfif>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
					<cf_wrk_report_search_button search_function='satir_kontrol()' insert_info='#message#' button_type='1' is_excel="1">    
                </div>
            </div>
        </div>
    </div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<!--- <cfset filename = "#createuuid()#"> --->
	<cfset filename = "detayli_firsat_raporu#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_opportunity.recordcount>
</cfif>
<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>	
	<cfoutput query="get_opportunity" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif isdefined('sales_emp_id') and len(sales_emp_id) and not listfind(sales_pcode_list,sales_emp_id)>
        	<cfset sales_pcode_list=listappend(sales_pcode_list,sales_emp_id)>
        </cfif>
        <cfif isdefined('team_id') and  len(team_id) and not listfind(sales_team_list,team_id)>
        	<cfset sales_team_list=listappend(sales_team_list,team_id)>
        </cfif>
        <cfif isdefined('sales_partner_id') and len(sales_partner_id) and not listfind(partner_id_list,sales_partner_id)>
        	<cfset partner_id_list=listappend(partner_id_list,sales_partner_id)>
        </cfif>
        <cfif isdefined('opportunity_type_id') and len(opportunity_type_id) and not listFindnocase(opportunity_type_list,opportunity_type_id,',')>
        	<cfset opportunity_type_list = listAppend(opportunity_type_list,opportunity_type_id)>
        </cfif>
        <cfif isdefined('partner_id') and len(partner_id) and not listfind(partner_id_list,partner_id)>
        	<cfset partner_id_list=listappend(partner_id_list,partner_id)>
        </cfif>
        <cfif isdefined('company_id') and len(company_id) and not listfind(company_id_list,company_id)>
        	<cfset company_id_list=listappend(company_id_list,company_id)>
        </cfif>
        <cfif isdefined('consumer_id') and len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
        	<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
        </cfif>
        <cfif isdefined('sale_add_option_id') and len(sale_add_option_id) and not listfind(sales_add_option_list,sale_add_option_id)>
        	<cfset sales_add_option_list=listappend(sales_add_option_list,sale_add_option_id)>
        </cfif>
        <cfif isdefined('opp_currency_id') and len(opp_currency_id) and not listFindnocase(opp_currency_id_list,opp_currency_id,',')>
        	<cfset opp_currency_id_list = listAppend(opp_currency_id_list,opp_currency_id)>
        </cfif>
        <cfif isdefined('probability') and len(probability) and not listFindnocase(probability_rate_list,probability,',')>
        	<cfset probability_rate_list = listAppend(probability_rate_list,probability)>
        </cfif>
        <cfif isdefined('process_row_id') and len(process_row_id) and not listFindnocase(process_row_id_list,process_row_id,',')>
        	<cfset process_row_id_list = listAppend(process_row_id_list,process_row_id)>
        </cfif>
        <cfif isdefined('project_id_list') and isdefined("project_id") and len(project_id) and not listFindnocase(project_id_list,project_id,',')>
        	<cfset project_id_list = listAppend(project_id_list,project_id)>
        </cfif>
	</cfoutput>
	<cfif listlen(partner_id_list)>
		<cfset partner_id_list = listsort(partner_id_list,"numeric","ASC",",")>	
			<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
				SELECT
					CP.COMPANY_PARTNER_NAME,
					CP.COMPANY_PARTNER_SURNAME,
					CP.PARTNER_ID,						
					C.FULLNAME,
					C.NICKNAME
				FROM 
					COMPANY_PARTNER CP,
					COMPANY C
				WHERE 
					CP.PARTNER_ID IN (#partner_id_list#) AND
					CP.COMPANY_ID = C.COMPANY_ID
				ORDER BY
					CP.PARTNER_ID				
			</cfquery>
		<cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(company_id_list)>
		<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
			<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
				SELECT COMPANY_ID,NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
			</cfquery>
		<cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(consumer_id_list)>
		<cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
				SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
		<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(sales_pcode_list)>
		<cfset sales_pcode_list = listsort(sales_pcode_list,"numeric","ASC",",")>
			<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
				SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#sales_pcode_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
		<cfset main_sales_pcode_list = listsort(listdeleteduplicates(valuelist(get_position_detail.EMPLOYEE_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(sales_team_list)>
		<cfset sales_team_list = listsort(sales_team_list,"numeric","ASC",",")>
			<cfquery name="GET_SALES_TEAM_" datasource="#DSN#">
				SELECT TEAM_ID,TEAM_NAME FROM SALES_ZONES_TEAM ORDER BY TEAM_ID
			</cfquery>
		<cfset main_sales_team_list = listsort(listdeleteduplicates(valuelist(get_sales_team_.team_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(sales_add_option_list)>
		<cfset sales_add_option_list = listsort(sales_add_option_list,"numeric","ASC",",")>
			<cfquery name="GET_SALE_ADD_OPTION_" datasource="#dsn3#"><!--- Özel Tanım --->
				SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID IN(#sales_add_option_list#) ORDER BY SALES_ADD_OPTION_ID
			</cfquery>
		<cfset main_sales_add_option_list = listsort(listdeleteduplicates(valuelist(get_sale_add_option_.sales_add_option_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(opportunity_type_list)>
		<cfset opportunity_type_list = listsort(opportunity_type_list,"numeric","ASC",",")>
			<cfquery name="GET_OPPORTUNITY_TYPES" datasource="#DSN3#">
			SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE OPPORTUNITY_TYPE_ID IN (#opportunity_type_list#) ORDER BY OPPORTUNITY_TYPE_ID
			</cfquery>
		<cfset main_opportunity_type_list = listsort(listdeleteduplicates(valuelist(get_opportunity_types.opportunity_type_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(opp_currency_id_list)>
		<cfset opp_currency_id_list = listsort(opp_currency_id_list,"numeric","ASC",",")>
		<cfquery name="GET_OPP_CURRENCIES_" datasource="#DSN3#">
			SELECT OPP_CURRENCY_ID,OPP_CURRENCY FROM OPPORTUNITY_CURRENCY ORDER BY OPP_CURRENCY_ID
		</cfquery>
		<cfset main_opp_currency_id_list = listsort(listdeleteduplicates(valuelist(get_opp_currencies_.opp_currency_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif Len(probability_rate_list)>
		<cfset probability_rate_list = listsort(probability_rate_list,"numeric","ASC",",")>
		<cfquery name="GET_PROBABILITY_NAME" datasource="#DSN3#">
			SELECT PROBABILITY_RATE_ID,PROBABILITY_NAME FROM SETUP_PROBABILITY_RATE WHERE PROBABILITY_RATE_ID IN (#probability_rate_list#) ORDER BY PROBABILITY_RATE_ID
		</cfquery>
		<cfset probability_rate_list = listsort(listdeleteduplicates(valuelist(get_probability_name.probability_rate_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif Len(process_row_id_list)>
		<cfset process_row_id_list = listsort(process_row_id_list,"numeric","ASC",",")>
		<cfquery name="GET_PROCESS_NAME" datasource="#DSN#">
			SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_row_id_list#) ORDER BY PROCESS_ROW_ID
		</cfquery>      
		<cfset process_row_id_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif Len(project_id_list)>
		<cfset project_id_list  = listsort(project_id_list,"numeric","ASC",",")>
		<cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
			SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
		</cfquery>
		<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cf_report_list>
	<cfif isdefined("attributes.is_form_submitted")>
        <thead>
            <tr>
                <th nowrap><cf_get_lang dictionary_id='57487.No'></th>
                <cfif not len(attributes.report_type)>
                    <th><cf_get_lang dictionary_id='58607.Firma'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                    <th nowrap><cf_get_lang dictionary_id ='58652.Olasılık'></th>
                    <th nowrap><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th nowrap><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th><cf_get_lang dictionary_id ='40294.Satış Çalışanı'></th>
                    <th><cf_get_lang dictionary_id ='38860.Satış Ortağı Yetkilisi'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='39282.Özel Tanım'></th>
                <cfelseif attributes.report_type eq 1>
                    <th><cf_get_lang dictionary_id ='40294.Satış Çalışanı'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 2>
                    <th><cf_get_lang dictionary_id ='58511.Takım'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 3>
                    <th><cf_get_lang dictionary_id ='38860.Satış Ortağı Yetkilisi'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 4>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 5>
                    <th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 6>
                    <th><cf_get_lang dictionary_id ='42529.Bölge Adı'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 7>
                    <th><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></th>
                <cfelseif attributes.report_type eq 8>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                <cfelseif attributes.report_type eq 9>
                    <th><cf_get_lang dictionary_id='58652.Olasılık'></th>
                <cfelseif attributes.report_type eq 10>
                    <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                    <th><cf_get_lang dictionary_id='57492.Toplam'></th>    
                </cfif>
                <th><cf_get_lang dictionary_id ='40296.Tahmini Gelir'></th>
                <th style="text-align:center;"><cf_get_lang dictionary_id='58474.P Birimi'></th>
                <th><cf_get_lang dictionary_id ='40297.Tahmini Maliyet'></th>
                <th style="text-align:center;"><cf_get_lang dictionary_id='58474.P Birimi'></th>
                <cfif x_country eq 1>
                    <th style="text-align:center;"><cf_get_lang dictionary_id='58219.Ülke'></th>
                    <cfif attributes.report_type neq 5>
                        <th style="text-align:center;"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
                    </cfif>
                </cfif>
                <cfif x_update_date eq 1>
                    <th style="text-align:center;"><cf_get_lang dictionary_id='40479.Güncelleme Tarihi'></th>
                </cfif>
            </tr>
        </thead>
            <cfif isdefined('attributes.is_form_submitted') and get_opportunity.recordcount>
                <cfparam name="attributes.page" default=1>
                <cfparam name="attributes.totalrecords" default="#get_opportunity.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <tbody>
                <cfoutput query="get_opportunity" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="25" nowrap>#currentrow#</td>
                        <cfif not len(attributes.report_type)>
                            <td>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    <cfif len(partner_id)>
                                        #get_company_detail.fullname[listfind(main_company_id_list,get_opportunity.company_id,',')]# - #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunity.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunity.partner_id,',')]#
                                    <cfelseif len(consumer_id)>
                                        #get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_opportunity.consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_opportunity.consumer_id,',')]#
                                    </cfif>
                                <cfelse>
                                    <cfif len(partner_id)>
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_opportunity.COMPANY_ID#','medium');">#get_company_detail.fullname[listfind(main_company_id_list,get_opportunity.company_id,',')]#</a> - <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_opportunity.partner_id#','medium');" class="tableyazi">#get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunity.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunity.partner_id,',')]#</a>
                                    <cfelseif len(consumer_id)> <!--- BK Firmalardaki Cari hesap alanlarinin bos olmasindan dolayi yazildi --->
                                        <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_opportunity.consumer_id#','medium');">#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_opportunity.consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_opportunity.consumer_id,',')]#</a>
                                    </cfif>
                                </cfif>
                            </td>
                            <td>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    #opp_head#
                                <cfelse>
                                    <a class="tableyazi" href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#">#opp_head#</a>
                                </cfif>
                            </td>
                            <td nowrap>
								<cfif len(probability) and len(probability_rate_list)>
                                    #get_probability_name.probability_name[Listfind(probability_rate_list,probability,',')]#
                                </cfif>
                            </td>
                            <td nowrap>
								<cfif len(get_opportunity.OPP_STAGE)>
									#get_opportunity.STAGE#
                                </cfif>
                            </td>
                            <td nowrap>	
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    <cfif len(project_id) and len(project_id_list)>
                                        #get_project_name.project_head[Listfind(project_id_list,get_opportunity.project_id,',')]#
                                    </cfif>
                                <cfelse>
                                    <cfif len(project_id) and len(project_id_list)>
                                        <a class="tableyazi" href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#">#get_project_name.project_head[Listfind(project_id_list,get_opportunity.project_id,',')]#</a>
                                    </cfif>
                                </cfif>
                            </td>
                            <td nowrap>
                                <cfif len(get_opportunity.sales_emp_id)>
                                    #get_position_detail.employee_name[listfind(main_sales_pcode_list,get_opportunity.sales_emp_id,',')]# #get_position_detail.employee_surname[listfind(main_sales_pcode_list,get_opportunity.sales_emp_id,',')]#
                                </cfif>
                            </td>
                            <td nowrap>
                                <cfif len(get_opportunity.sales_partner_id)>
                                    #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunity.sales_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunity.sales_partner_id,',')]#
                                </cfif>
                            </td>
                            <td nowrap>
								<cfif len(opportunity_type_id)>
                                    #get_opportunity_types.opportunity_type[listfind(main_opportunity_type_list,get_opportunity.opportunity_type_id,',')]#
                                </cfif>
                            </td>
                            <td nowrap>
								<cfif len(sale_add_option_id)>
                                    #get_sale_add_option_.sales_add_option_name[listfind(main_sales_add_option_list,get_opportunity.sale_add_option_id,',')]#
                                </cfif>
                            </td>
                        <cfelseif attributes.report_type eq 1>
                            <td><cfif len(get_opportunity.sales_emp_id)>
                                    #get_position_detail.employee_name[listfind(main_sales_pcode_list,get_opportunity.sales_emp_id,',')]# #get_position_detail.employee_surname[listfind(main_sales_pcode_list,get_opportunity.sales_emp_id,',')]#
                                </cfif>
                            </td>
                            <td>#satis_calisan_toplam#</td>
                        <cfelseif attributes.report_type eq 2>
                            <td>#report_group_type#</td>
                            <td>#firsat_sayisi#</td>
                        <cfelseif attributes.report_type eq 3>
                            <td>
                                <cfif len(get_opportunity.sales_partner_id)>
                                    #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunity.sales_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunity.sales_partner_id,',')]#
                                </cfif>
                            </td>
                            <td>#satis_ortagi_toplam#</td>
                        <cfelseif attributes.report_type eq 4>
                            <td>
                                <cfif len(opportunity_type_id)>
                                    #get_opportunity_types.opportunity_type[listfind(main_opportunity_type_list,get_opportunity.opportunity_type_id,',')]#
                                </cfif>
                            </td>
                            <td>#kategori_toplam#</td>
                        <cfelseif attributes.report_type eq 5>
                            <td>#report_group_type#</td>
                            <td>#firsat_sayisi_b#</td>
                        <cfelseif attributes.report_type eq 6>
                            <td>#report_group_type#</td>
                            <td>#bolgeler#</td>
                        <cfelseif attributes.report_type eq 7>
                            <td>#product_cat#</td>
                        <cfelseif attributes.report_type eq 8>
                            <td>
								<cfif len(process_row_id)>
                                    #get_process_name.stage[listfind(process_row_id_list,get_opportunity.process_row_id,',')]#
                                </cfif>
                            </td>
                            <td>#surec#</td>
                        <cfelseif attributes.report_type eq 9>
                            <td>
								<cfif len(probability)>
                                    #get_probability_name.probability_name[Listfind(probability_rate_list,probability,',')]#
                                </cfif>
                            </td>
						<cfelseif attributes.report_type eq 10>
                            <td><cfif len(opp_currency_id)>
                                   #get_opp_currencies_.opp_currency[Listfind(main_opp_currency_id_list,get_opportunity.opp_currency_id,',')]#
                                </cfif>                                     
                            </td>
                            <td>#asama#</td>
                        </cfif>	
                        <td style="text-align:right;">#TLFormat(income)#</td>
                        <td style="text-align:center;">#money#</td>
                        <td style="text-align:right;">#TLFormat(cost)#</td>
                        <td style="text-align:center;">#money2#</td>
                        <cfif x_country eq 1>
                            <td style="text-align:center">#country_name#</td>
                            <cfif attributes.report_type neq 5>
                                <td style="text-align:center">#sz_name#</td>
                            </cfif>
                        </cfif>
                        <cfif x_update_date eq 1><td style="text-align:center">#dateformat(update_date,dateformat_style)#</td></cfif>
                    </tr>
                    <cfset currentrow_ = currentrow>
                </cfoutput>
                </tbody>
                <cfif get_opportunity.recordcount eq currentrow_>
                    <tfoot>
                        <tr>
                            <cfset colspan = 1>
                            <cfif not len(attributes.report_type)>
                                <cfset colspan = 10>
                            <cfelseif listfind('1,2,3,4,5,6,8,10',attributes.report_type,',') >
                                <cfset colspan = 3>
                            <cfelseif attributes.report_type eq 7 or attributes.report_type eq 9>
                                <cfset colspan = 2>
                            </cfif>
                            <cfquery name="GET_OPPORTUNITY_COST" dbtype="query">
                                SELECT SUM(COST) TOP_COST, MONEY2 FROM GET_OPPORTUNITY WHERE COST IS NOT NULL GROUP BY MONEY2
                            </cfquery>
                            <cfquery name="GET_OPPORTUNITY_INCOME" dbtype="query">
                                SELECT SUM(INCOME) TOP_INCOME, MONEY FROM GET_OPPORTUNITY WHERE INCOME IS NOT NULL GROUP BY MONEY
                            </cfquery>
                            <td colspan="<cfoutput>#colspan#</cfoutput>" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td style="text-align:right;" class="txtbold"><cfoutput query="get_opportunity_income">#TLFormat(top_income)#<br/></cfoutput></td>
                            <td class="txtbold" style="text-align:center;"><cfoutput query="get_opportunity_income">#money#<br/></cfoutput></td>
                            <td style="text-align:right;" class="txtbold"><cfoutput query="get_opportunity_cost">#TLFormat(top_cost)#<br/></cfoutput></td>
                            <td class="txtbold" style="text-align:center;"><cfoutput query="get_opportunity_cost">#money2#<br/></cfoutput></td>
                            <cfset cols_=0>
                            <cfif x_update_date eq 1>
                                <cfset cols_= cols_ +1>
                            </cfif>
                            <cfif x_country eq 1>
                                <cfset cols_=cols_+2>
                            </cfif>
                            <cfif cols_ neq 0>
                                <td colspan="<cfoutput>#cols_#</cfoutput>"></td>
                            </cfif>
                        </tr>
                    </tfoot>
                </cfif>
            <cfelse>
                <cfset cols_ = 14>
                <cfif x_update_date eq 1>
                    <cfset cols_= cols_ + 1>
                </cfif>
                <cfif x_country eq 1>
                    <cfset cols_=cols_+2>
                </cfif>
                <tbody>
                    <tr>
                        <td colspan="<cfoutput>#cols_#</cfoutput>"><cfif len(attributes.is_form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif>!</td>
                    </tr>	
                </tbody>	
            </cfif>
    </cfif>
</cf_report_list>
<cfif get_opportunity.recordcount and (attributes.totalrecords gt attributes.maxrows) and isdefined('is_form_submitted')>
	<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="report.detail_opportunity_report#url_str#">
</cfif>
<cfif isdefined('attributes.is_form_submitted') and get_opportunity.recordcount and len(attributes.graph_type)>
	<!---  Grafik Başlangıç --->
    <br />
    <table width="98%" cellpadding="2" cellspacing="1" border="0" align="center" class="color-border">
        <tr class="color-row">
            <td style="text-align:center;">
                <cfset graph_type = form.graph_type>
                <cfquery name="GET_GRAPH_QUERY" dbtype="query">
                    SELECT
                        SUM(INCOME) INCOME,
                        <cfif attributes.report_type eq 1> 
                            SALES_EMP_ID
                        <cfelseif listfind('2,5',attributes.report_type,',') >
                            REPORT_GROUP_TYPE
                        <cfelseif attributes.report_type eq 3>
                            SALES_PARTNER_ID
                        <cfelseif attributes.report_type eq 4>
                            OPPORTUNITY_TYPE_ID
                        <cfelseif attributes.report_type eq 6>
                            BOLGELER
                        <cfelseif attributes.report_type eq 7>
                            PRODUCT_CAT
                        <cfelseif attributes.report_type eq 8>
                            PROCESS_ROW_ID
                        <cfelseif attributes.report_type eq 9>
                            PROBABILITY
                        <cfelseif attributes.report_type eq 10>
                            OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID    
                        <cfelse>
                            OPP_HEAD
                        </cfif>,
                        MONEY
                    FROM
                        GET_OPPORTUNITY
                    <cfif attributes.report_type eq 1>
                        GROUP BY SALES_EMP_ID, MONEY
                        ORDER BY  SALES_EMP_ID
                    <cfelseif listfind('2,5',attributes.report_type,',') >
                        GROUP BY REPORT_GROUP_TYPE, MONEY
                        ORDER BY  REPORT_GROUP_TYPE
                    <cfelseif attributes.report_type eq 3>
                        GROUP BY SALES_PARTNER_ID, MONEY
                        ORDER BY  SALES_PARTNER_ID
                    <cfelseif attributes.report_type eq 4>
                        GROUP BY OPPORTUNITY_TYPE_ID, MONEY
                        ORDER BY  OPPORTUNITY_TYPE_ID
                    <cfelseif attributes.report_type eq 6>
                        GROUP BY BOLGELER, MONEY
                        ORDER BY  BOLGELER
                    <cfelseif attributes.report_type eq 7>
                        GROUP BY PRODUCT_CAT, MONEY
                        ORDER BY  PRODUCT_CAT
                    <cfelseif attributes.report_type eq 8>
                        GROUP BY PROCESS_ROW_ID, MONEY
                        ORDER BY  PROCESS_ROW_ID
                    <cfelseif attributes.report_type eq 9>
                        GROUP BY PROBABILITY, MONEY
                        ORDER BY PROBABILITY
                    <cfelseif attributes.report_type eq 10>
                        GROUP BY 
                        	OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID, 
                            OPPORTUNITY_CURRENCY.MONEY
                        ORDER BY  
                        	OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID    
                    <cfelse>
                        GROUP BY OPP_HEAD,MONEY
                        ORDER BY OPP_HEAD
                    </cfif>
                </cfquery>
                <script src="JS/Chart.min.js"></script> 
                        <cfoutput query="get_graph_query">
                            <cfif len(income)><cfset income_ = income><cfelse><cfset income_ = 0></cfif>
                            <!--- Çalışan Bazında --->
                            <cfif attributes.report_type eq 1>
                                <cfif ListFind(main_sales_pcode_list,sales_emp_id,',')>
                                    <cfset item_value = ('#get_position_detail.employee_name[listfind(main_sales_pcode_list,sales_emp_id,',')]# 
                                    #get_position_detail.employee_surname[listfind(main_sales_pcode_list,sales_emp_id,',')]# #money#')>
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>
                            <!--- Takım Bazında --->
                            <cfelseif attributes.report_type eq 2>
                                <cfset item_value = "#report_group_type# #money#">
                                <cfif len(income) and Len(item_value)>
                                    <cfset 'item_#currentrow#'="#item_value#">
						            <cfset 'value_#currentrow#'="#income_#">
                                </cfif>
                            <!--- Satış Ortağı Bazında --->
                            <cfelseif attributes.report_type eq 3>
                                <cfif ListFind(main_partner_id_list,sales_partner_id,',')>
                                    <cfset item_value = "#get_partner_detail.company_partner_name[listfind(main_partner_id_list,sales_partner_id,',')]# &nbsp;
                                    #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,sales_partner_id,',')]# #money#">
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>
                            <!--- Kategori Bazında --->
                            <cfelseif attributes.report_type eq 4>
                                <cfif ListFind(main_opportunity_type_list,opportunity_type_id,',')>
                                    <cfset item_value = "#get_opportunity_types.opportunity_type[listfind(main_opportunity_type_list,opportunity_type_id,',')]# #money#">
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>
                            <!--- Bölge Bazında --->
                            <cfelseif attributes.report_type eq 5>
                                <cfset item_value = "#report_group_type# #money#">
                                <cfif len(income) and Len(item_value)>
                                    <cfset 'item_#currentrow#'="#item_value#">
						            <cfset 'value_#currentrow#'="#income_#">
                                </cfif>
                            <!--- İl Bazında --->
                            <cfelseif attributes.report_type eq 6>
                                <cfset item_value = "#BOLGELER# #money#">
                                <cfif len(income) and Len(item_value)>
                                    <cfset 'item_#currentrow#'="#item_value#">
						            <cfset 'value_#currentrow#'="#income_#">
                                </cfif>
                            <!--- Ürün Kategorisi Bazında --->
                            <cfelseif attributes.report_type eq 7>
                                <cfset item_value = "#PRODUCT_CAT# #money#">
                                <cfif len(income) and Len(item_value)>
                                    <cfset 'item_#currentrow#'="#item_value#">
						            <cfset 'value_#currentrow#'="#income_#">
                                </cfif>
                            <!--- Asama Bazında --->
                            <cfelseif attributes.report_type eq 8>
                                <cfif ListFind(process_row_id_list,process_row_id,',')>
                                    <cfset item_value = "#get_process_name.stage[Listfind(process_row_id_list,process_row_id,',')]# #money#">
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>
                            <!--- Olasılık Bazında --->
                            <cfelseif attributes.report_type eq 9>
                                <cfif ListFind(probability_rate_list,probability,',')>
                                    <cfset item_value = "#get_probability_name.probability_name[Listfind(probability_rate_list,probability,',')]# #money#">
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>
                            <cfelseif attributes.report_type eq 10><!----asama1 smh--->
                                <cfif ListFind(opp_currency_id_list,opp_currency_id,',')>
                                    <cfset item_value = "#GET_OPP_CURRENCIES_.opp_currency[Listfind(opp_currency_id_list,opp_currency_id,',')]# #money#">
                                    <cfif len(income) and Len(item_value)>
                                        <cfset 'item_#currentrow#'="#item_value#">
						                <cfset 'value_#currentrow#'="#income_#">
                                    </cfif>
                                </cfif>    
                            <cfelse>
                                <cfset item_value = "#opp_head# #money#">
                                <cfset 'item_#currentrow#'="#item_value#">
						        <cfset 'value_#currentrow#'="#income_#">
                            </cfif>
                        </cfoutput>
                <canvas id="myChart"  style="max-height:1000px;max-width:1000px"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_graph_query.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Detaylı Fırsat Raporu",
									backgroundColor: [<cfloop from="1" to="#get_graph_query.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_graph_query.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>
            </td>
        </tr>
    </table>
</cfif>
<script type="text/javascript">
	function satir_kontrol()
	{
		if(document.report_opportunity.is_excel.checked == false)
			if(document.report_opportunity.maxrows.value > 1000)
			{
				alert ("<cf_get_lang dictionary_id ='40286.Görüntüleme Sayısı 1000 den fazla olamaz'>!");
				return false;
			}
			
		if(document.report_opportunity.is_excel.checked==false)
		{
			document.report_opportunity.action="<cfoutput>#request.self#?fuseaction=report.detail_opportunity_report</cfoutput>"
			return true;
		}
		else
			document.report_opportunity.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_opportunity_report</cfoutput>"
	}
	
	function return_company()
	{
		if(document.getElementById('ref_member_type').value=='employee')
		{
			var emp_id=document.getElementById('ref_member_id').value;
			var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
			document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
		}
		else
			return false;
	}
</script>