<cfif isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
<cfif isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>	
<cfif isdate(attributes.termin_date1)><cf_date tarih = "attributes.termin_date1"></cfif>
<cfif isdate(attributes.termin_date2)><cf_date tarih = "attributes.termin_date2"></cfif>	
<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>
<cfquery name="GET_COMP_PERIOD" datasource="#dsn#">
	SELECT PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif attributes.is_iptal eq 1>
	<cfquery name="get_process_cancel_id" datasource="#dsn#">
		SELECT
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
			(PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%"> OR PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.upd_fast_sale%">)
			AND PTR.STAGE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%iptal%">
	</cfquery>
<cfelse>
	<cfset get_process_cancel_id.recordcount = 0>
</cfif>
<cfset krmsl_uye = ''>
<cfset brysl_uye = ''>
<cfif listlen(attributes.member_cat_type)>
	<cfset uzunluk=listlen(attributes.member_cat_type)>
	<cfloop from="1" to="#uzunluk#" index="katyp">
		<cfset kat_list = listgetat(attributes.member_cat_type,katyp,',')>
		<cfif listlen(kat_list) and listfirst(kat_list,'-') eq 1>
			<cfset krmsl_uye = listappend(krmsl_uye,kat_list)>
		<cfelseif listlen(kat_list) and listfirst(kat_list,'-') eq 2>
			<cfset brysl_uye = listappend(brysl_uye,kat_list)>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="T1" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
	O.ORDER_STAGE,
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		<cfif attributes.is_kdv eq 0>
			<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE  GROSSTOTAL,
				<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE / OM.RATE2  GROSSTOTAL_DOVIZ,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL END AS PRICE,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE ( (1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL )/OM.RATE2 END AS PRICE_DOVIZ,
		<cfelse>
			<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
			<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE*(100+ORD_R.TAX)/100 / OM.RATE2 GROSSTOTAL_DOVIZ,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END AS PRICE,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE ((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100)))) / OM.RATE2 END AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.is_other_money eq 1 and attributes.report_type neq 22>
			ORD_R.OTHER_MONEY,
		</cfif>
	<cfelse>
		<cfif attributes.is_kdv eq 0>
			<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)*ORD_R.PRICE<cfelse>ORD_R.QUANTITY*ORD_R.PRICE</cfif> GROSSTOTAL,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL END AS PRICE,
		<cfelse>
			<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)*ORD_R.PRICE*(100+ORD_R.TAX)/100<cfelse>ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100</cfif> GROSSTOTAL,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END AS PRICE,
		</cfif>
	</cfif>
		( (<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE)-((1- ISNULL(O.SA_DISCOUNT,0)/#dsn_alias#.IS_ZERO((ISNULL(O.NETTOTAL,0)-ISNULL(O.TAXTOTAL,0)+ISNULL(O.SA_DISCOUNT,0)),1)) * ORD_R.NETTOTAL)) AS DISCOUNT,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			((<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*ORD_R.PRICE)-((1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL)) / OM.RATE2 AS DISCOUNT_DOVIZ,
		</cfif>
		O.CANCEL_DATE,
		O.ORDER_STATUS,
		O.ORDER_DATE,
		O.DELIVERDATE,
		O.ORDER_ID,
	<cfif attributes.report_type neq 22>
		ORD_R.PRODUCT_ID,
		ORD_R.STOCK_ID,
	</cfif>
	<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK,
		PC.PRODUCT_CATID,
        (SELECT PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT
        <cfif attributes.report_type eq 24>
           , C.NICKNAME AS MUSTERI,
            C.COMPANY_ID AS MUSTERI_ID,
            1 MEMBER_TYPE
        </cfif>
	<cfelseif ListFind("2",attributes.report_type)>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		S.PRODUCT_CODE_2,
		P.BARCOD,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK,
        <cfif x_show_second_unit>
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
        </cfif>	
        <cfif x_unit_weight eq 1>
            (SELECT TOP 1PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT,
        </cfif>
		<cfif attributes.is_kdv eq 0>
			ISNULL((ORD_R.NETTOTAL/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		<cfelse>
			ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif> QUANTITY,
		ORD_R.UNIT AS BIRIM,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT
	<cfelseif ListFind("3",attributes.report_type)>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PROPERTY,
		P.BARCOD,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK,
        <cfif x_show_second_unit>
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
        </cfif>
        <cfif x_unit_weight eq 1>
            (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT,
        </cfif>	
		<!---<cfif attributes.is_kdv eq 0>
			ISNULL((ORD_R.NETTOTAL/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		<cfelse>
			ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		</cfif>--->
        <cfif attributes.is_kdv eq 0>
			ORD_R.NETTOTAL ROW_LASTTOTAL,
		<cfelse>
			ISNULL((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100))),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif> QUANTITY,
		ORD_R.UNIT AS BIRIM,
		S.STOCK_CODE_2,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT
	<cfelseif attributes.report_type eq 4>
		C.NICKNAME AS MUSTERI,
		C.COMPANY_ID AS MUSTERI_ID,
		1 MEMBER_TYPE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 5>
		CC.COMPANYCAT AS MUSTERI_TYPE,
		CC.COMPANYCAT_ID AS MUSTERI_TYPE_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 6>
		C.NICKNAME,
		C.COMPANY_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 7>
		(SELECT BRANCH_NAME FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = O.DELIVER_DEPT_ID) AS BRANCH_NAME,
		PC.PRODUCT_CAT
	<cfelseif attributes.report_type eq 8>
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 9>
		PB.BRAND_NAME,
		P.BRAND_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 10>
		O.CUSTOMER_VALUE_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 11>
		O.RESOURCE_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 12>
		O.IMS_CODE_ID,
		SIC.IMS_CODE_NAME,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 13>

		O.ZONE_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 14>
		O.PAYMETHOD,
		O.CARD_PAYMETHOD_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 15>
		P.SEGMENT_ID,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 16>
		C.CITY,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 17>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT,
		ORD_R.ORDER_ROW_CURRENCY,
        ORD_R.PRODUCT_NAME2,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif> QUANTITY,
		O.ORDER_NUMBER,
		O.ORDER_ID,
		O.ORDER_HEAD,
		O.REF_NO,
		O.IS_INSTALMENT,
		C.NICKNAME AS MUSTERI,
		C.COMPANY_ID,
		1 MEMBER_TYPE,
		O.ORDER_DATE,
		ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE_,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		S.STOCK_ID,
		P.PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_CODE,
        <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
            S.PRODUCT_CODE_2,
        </cfif>
		P.MANUFACT_CODE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK,
		ORD_R.UNIT AS BIRIM,
		ORD_R.SPECT_VAR_NAME,
		(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WITH (NOLOCK) WHERE SPECTS.SPECT_VAR_ID = ORD_R.SPECT_VAR_ID) AS SPECT_MAIN_ID,
        (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
        <cfif x_unit_weight eq 1>
	        (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
        </cfif>
		<cfif attributes.is_kdv eq 0>
			ORD_R.NETTOTAL ROW_LASTTOTAL,
		<cfelse>
			ISNULL((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100))),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			ORD_R.PRICE / OM.RATE2 BIRIM_FIYAT,
		<cfelse>
			ORD_R.PRICE BIRIM_FIYAT,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		<cfif attributes.is_project eq 1>
			ORD_R.ROW_PROJECT_ID AS ROW_PROJECT_ID,
			O.PROJECT_ID AS PROJECT_ID,
		</cfif>
		ORD_R.WRK_ROW_ID
	<cfelseif attributes.report_type eq 18>
		E.EMPLOYEE_ID,
		(EMPLOYEE_NAME + ' '+ EMPLOYEE_SURNAME) AS EMP_NAME,
		PC.PRODUCT_CAT
	<cfelseif attributes.report_type eq 19>
		ORD_R.PRICE_CAT,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 21>
		ISNULL(O.SALES_PARTNER_ID,O.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
		CASE WHEN O.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 22>
		CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
		O.ORDER_NUMBER,
		O.ORDER_HEAD,
		O.ORDER_ID,
		O.IS_INSTALMENT,
		C.NICKNAME AS MUSTERI,
		C.COMPANY_ID,
		1 MEMBER_TYPE,
		O.ORDER_DATE,
		O.CITY_ID,
		O.COUNTY_ID,
		O.ORDER_EMPLOYEE_ID,
		O.SALES_ADD_OPTION_ID,
		O.SALES_PARTNER_ID,
		O.SALES_CONSUMER_ID,
		O.REF_NO,
		O.SHIP_METHOD,
		O.PAYMETHOD,
		O.SHIP_DATE,
        <cfif attributes.is_kdv eq 1>
			O.NETTOTAL,
        <cfelse>
		CASE WHEN O.DISCOUNTTOTAL IS NOT NULL THEN (O.GROSSTOTAL-O.DISCOUNTTOTAL) ELSE O.GROSSTOTAL END AS NETTOTAL, 
        </cfif>
		O.DELIVERDATE DELIVERDATE_,
		<!--- <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			ORD_R.PRICE / OM.RATE2 BIRIM_FIYAT,
		<cfelse>
			ORD_R.PRICE BIRIM_FIYAT,
		</cfif> --->
		O.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		O.OTHER_MONEY
		<cfif attributes.is_project eq 1>
			,O.PROJECT_ID AS PROJECT_ID
		</cfif>
	<cfelseif attributes.report_type eq 23>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		P.BARCOD,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY </cfif> AS PRODUCT_STOCK,
		<cfif attributes.is_kdv eq 0>
			ISNULL((ORD_R.NETTOTAL/<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*(<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		<cfelse>
			ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>*(<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif>-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		<cfif isdefined("attributes.is_iptal") and len(attributes.is_iptal)>(ORD_R.QUANTITY-ORD_R.CANCEL_AMOUNT)<cfelse>ORD_R.QUANTITY</cfif> QUANTITY,
		ORD_R.UNIT AS BIRIM,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT,
        MONTH(O.ORDER_DATE) AS ORDER_DATE_,
		PBM.MODEL_CODE,
        PBM.MODEL_NAME
	</cfif>
	FROM
		ORDERS O WITH (NOLOCK),
		ORDER_ROW ORD_R WITH (NOLOCK),
		<cfif (attributes.is_other_money eq 1) or (attributes.is_money2 eq 1) or (attributes.is_money_info eq 1)>
			ORDER_MONEY OM WITH (NOLOCK),
		</cfif>
		STOCKS S WITH (NOLOCK),
		<cfif listfind('1,2,3,7,24',attributes.report_type)>
			PRODUCT_CAT PC WITH (NOLOCK),
            <cfif attributes.report_type eq 24>
                #dsn_alias#.COMPANY C WITH (NOLOCK),
            </cfif>
		<cfelseif attributes.report_type eq 20>
			#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
			#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),
		<cfelseif listfind('4,6,16',attributes.report_type)>
			#dsn_alias#.COMPANY C WITH (NOLOCK),
		<cfelseif attributes.report_type eq 5>
			#dsn_alias#.COMPANY C WITH (NOLOCK),
			#dsn_alias#.COMPANY_CAT CC WITH (NOLOCK),
		<cfelseif attributes.report_type eq 8>
			#dsn_alias#.EMPLOYEES E WITH (NOLOCK),
		<cfelseif attributes.report_type eq 9>
			PRODUCT_BRANDS PB WITH (NOLOCK),
		<cfelseif attributes.report_type eq 12>
			#dsn_alias#.SETUP_IMS_CODE SIC WITH (NOLOCK),
		<cfelseif attributes.report_type eq 17>
			#dsn_alias#.COMPANY C WITH (NOLOCK),
			PRODUCT_CAT PC WITH (NOLOCK),
		<cfelseif attributes.report_type eq 18>
			#dsn_alias#.EMPLOYEES E WITH (NOLOCK),
			PRODUCT_CAT PC WITH (NOLOCK),
		<cfelseif attributes.report_type eq 22>
			#dsn_alias#.COMPANY C WITH (NOLOCK),
		<cfelseif attributes.report_type eq 23>
	        PRODUCT_CAT PC WITH (NOLOCK),
			#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM WITH (NOLOCK),
		</cfif>
		PRODUCT P WITH (NOLOCK)
	WHERE
		( (	O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0 )  OR (	O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1 ) )
		AND O.COMPANY_ID IS NOT NULL
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
			AND
			(
				(O.COMPANY_ID IS NULL) OR
				(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
			)
		</cfif>
		<cfif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 1>
			(ORD_R.WRK_ROW_ID IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID) OR
			AND ORD_R.WRK_ROW_ID IN(SELECT GS.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI,GET_ALL_SHIP_ROW GS WHERE GS.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID AND GS.WRK_ROW_ID = GI.WRK_ROW_RELATION_ID))
			<!--- ( 
				(	O.ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS WITH (NOLOCK)
						WHERE 
							OS.ORDER_ID=O.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(	O.ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS WITH (NOLOCK),
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							</cfif>
						WHERE 
							OS.ORDER_ID = O.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND	 --->
		<cfelseif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 0>
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GS.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI,GET_ALL_SHIP_ROW GS WHERE GS.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID AND GS.WRK_ROW_ID = GI.WRK_ROW_RELATION_ID)
			<!--- ( 
				(	O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS WITH (NOLOCK)
						WHERE 
							OS.ORDER_ID=O.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(	O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS WITH (NOLOCK),
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							</cfif>
						WHERE 
							OS.ORDER_ID = O.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND		 --->
		</cfif>
		<!--- Irsaliyelenmis - irsaliyelenmemis hareketleri filtreler FBS 20080508 --->
		<cfif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 1>
			AND ORD_R.WRK_ROW_ID IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_SHIP_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			<!--- O.ORDER_ID IN (
				<cfset count=0>
				<cfloop query="GET_COMP_PERIOD">
					<cfset count=count+1>
					SELECT 
						OS.ORDER_ID 
					FROM 
						ORDERS_SHIP OS WITH (NOLOCK)
					WHERE 
						OS.ORDER_ID=O.ORDER_ID
						AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
					<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
				</cfloop>
					)	AND	 --->
		<cfelseif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 0>
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_SHIP_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			<!--- O.ORDER_ID NOT IN (
				<cfset count=0>
				<cfloop query="GET_COMP_PERIOD">
					<cfset count=count+1>
					SELECT 
						OS.ORDER_ID 
					FROM 
						ORDERS_SHIP OS WITH (NOLOCK)
					WHERE 
						OS.ORDER_ID=O.ORDER_ID
						AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
					<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
				</cfloop>
					)	AND				 --->
		</cfif>
		<cfif attributes.is_prom eq 0>
			AND ORD_R.IS_PROMOTION <> 1
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>
			AND O.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND O.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif isdefined('attributes.sale_add_option') and len(attributes.sale_add_option)>
			AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
		</cfif>
		<cfif attributes.is_other_money eq 1 and attributes.report_type eq 22>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = O.OTHER_MONEY
		<cfelseif attributes.is_other_money eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = ORD_R.OTHER_MONEY
		<cfelseif attributes.is_money2 eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
		</cfif>
		<cfif attributes.is_money_info eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = ORD_R.OTHER_MONEY
		</cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
			AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
		</cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
			AND ORD_R.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">	
		</cfif>
		<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
			AND O.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif len(trim(attributes.row_employee)) and len(attributes.row_employee_id)>
			AND ORD_R.BASKET_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_employee_id#">
		</cfif>
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#">
		</cfif>
		<cfif len(trim(attributes.company)) and len(attributes.company_id)>
			AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		</cfif>
		<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
			AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		</cfif>
		<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
			AND O.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
	</cfif>
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
			AND P.BRAND_ID IN(#attributes.brand_id#)
		</cfif>
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>
			AND P.SHORT_CODE_ID IN (#attributes.model_id#)
		</cfif>
		<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
			AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(P.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		</cfif>
		<cfif len(attributes.termin_date1) and isdate(attributes.termin_date1)>
			AND ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date1#">
		</cfif>
		<cfif len(attributes.termin_date2) and isdate(attributes.termin_date2)>
			AND ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date2#">
		</cfif>
		<cfif len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type)>
			<cfif attributes.sales_member_type eq 'partner'>
				AND O.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
			<cfelse>
				AND O.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
			</cfif>
		</cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
			AND S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%">
		</cfif>
		<cfif len(attributes.segment_id)>
			AND P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#">
		</cfif>
		<cfif isdefined("attributes.city_id") and len(attributes.city_id) and attributes.report_type eq 22>
			AND O.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
		</cfif>
		<cfif isdefined("attributes.county_id") and len(attributes.county_id) and attributes.report_type eq 22>
			AND O.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
		</cfif>
		AND O.ORDER_ID = ORD_R.ORDER_ID
		<cfif listfind('1,2,3,24',attributes.report_type)>
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
		<cfelseif attributes.report_type eq 20>
			AND PC_2.PRODUCT_CATID = P.PRODUCT_CATID
			AND CHARINDEX('.',PC_2.HIERARCHY) <> 0
			AND PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1))			
		<cfelseif listfind('4,16,24',attributes.report_type)>
			AND O.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 5>
			AND O.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
			AND C.COMPANYCAT_ID = CC.COMPANYCAT_ID
		<cfelseif attributes.report_type eq 6>
			AND P.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(P.COMPANY_ID IS NULL) OR
					(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 7>
			AND CHARINDEX('.',PC.HIERARCHY) <> 0
			<cfif len(attributes.department_id)>
				AND O.DELIVER_DEPT_ID IN 
				(<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#">
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1>,</cfif>
				</cfloop>)
			<cfelse>
				AND (O.DELIVER_DEPT_ID IS NULL OR O.DELIVER_DEPT_ID IN (#branch_dep_list#)) 
			</cfif>
		<cfelseif attributes.report_type eq 8>
			AND E.EMPLOYEE_ID =O.ORDER_EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			AND P.BRAND_ID = PB.BRAND_ID
		<cfelseif attributes.report_type eq 12>
			AND O.IMS_CODE_ID = SIC.IMS_CODE_ID
		<cfelseif attributes.report_type eq 17>
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND O.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 18>
			AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY
			AND ORD_R.BASKET_EMPLOYEE_ID = E.EMPLOYEE_ID
		<cfelseif attributes.report_type eq 22>
			AND O.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 23>
	        AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND P.SHORT_CODE_ID = PBM.MODEL_ID
            AND P.SHORT_CODE_ID IS NOT NULL 
		</cfif>
			AND S.PRODUCT_ID = P.PRODUCT_ID
			AND ORD_R.STOCK_ID = S.STOCK_ID
		<cfif len(attributes.customer_value_id)>
			AND O.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
		</cfif>
		<cfif len(attributes.resource_id)>
			AND O.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
		</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
			AND O.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
		</cfif>
		<cfif len(attributes.zone_id)>
			AND O.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
		</cfif>
        <cfif len(attributes.country_id)>
			AND O.COUNTRY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
		</cfif>
		<cfif isdefined("krmsl_uye") and listlen(krmsl_uye)>
			AND O.COMPANY_ID IN
				(
				SELECT 
					C.COMPANY_ID 
				FROM 
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CAT 
				WHERE 
					C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND 
					(
					  <cfloop list="#krmsl_uye#" delimiters="," index="comp_i">
						  (CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(comp_i,'-')#">)
						  <cfif comp_i neq listlast(krmsl_uye,',') and listlen(krmsl_uye,',') gte 1> OR</cfif>
					  </cfloop>  
					)
				)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif isdefined("brysl_uye") and listlen(brysl_uye)>
			AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		</cfif>
        <cfif attributes.report_type eq 17 and (isdefined('xml_order_row_dept') and xml_order_row_dept eq 1)>
        	<cfif len(attributes.department_id)>
                AND(
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (ORD_R.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ORD_R.DELIVER_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                ) 
            <cfelseif len(branch_dep_list)>
                AND	(ORD_R.DELIVER_DEPT IN(#branch_dep_list#) OR ORD_R.DELIVER_DEPT IS NULL)
            </cfif>
		<cfelse>
        	<cfif len(attributes.department_id)>
                AND(
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                ) 
            <cfelseif len(branch_dep_list)>
                AND	(O.DELIVER_DEPT_ID IN(#branch_dep_list#) OR O.DELIVER_DEPT_ID IS NULL)
            </cfif>
        </cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
		</cfif>
		<cfif len(attributes.cancel_type_id)>
			AND ORD_R.CANCEL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cancel_type_id#">
		</cfif>
		<cfif len(attributes.order_stage)>
			AND ORD_R.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
		</cfif>
		<cfif len(attributes.order_process_cat)>
			AND O.ORDER_STAGE IN (#attributes.order_process_cat#)
		</cfif>
		<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
			AND	O.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					O.COMPANY_ID IS NULL
					OR O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#)
				)
			</cfif>
		</cfif>
		<cfif len(attributes.branch_id)>
			AND O.FRM_BRANCH_ID IN (#attributes.branch_id#)
		</cfif>
	<cfif attributes.report_type eq 24 >
		AND O.COMPANY_ID = C.COMPANY_ID
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
			AND
			(
				O.COMPANY_ID IS NULL
				OR O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#)
			)
		</cfif>
    </cfif>
</cfquery>
<cfquery name="T2" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
	O.ORDER_STAGE,
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		<cfif attributes.is_kdv eq 0>
			ORD_R.QUANTITY*ORD_R.PRICE  GROSSTOTAL,
			ORD_R.QUANTITY*ORD_R.PRICE / OM.RATE2  GROSSTOTAL_DOVIZ,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL END AS PRICE,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE ((1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL ) / OM.RATE2 END AS PRICE_DOVIZ,
		<cfelse>
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 / OM.RATE2 GROSSTOTAL_DOVIZ,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END AS PRICE,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE ((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100)))) / OM.RATE2 END AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.is_other_money eq 1 and attributes.report_type neq 22>
			ORD_R.OTHER_MONEY,
		</cfif>
	<cfelse>
		<cfif attributes.is_kdv eq 0>
			ORD_R.QUANTITY*ORD_R.PRICE GROSSTOTAL,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL END AS PRICE,
		<cfelse>
			ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
			CASE WHEN O.NETTOTAL = 0 THEN 0 ELSE (1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT),1)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) END AS PRICE,
		</cfif>
	</cfif>
	((ORD_R.QUANTITY*ORD_R.PRICE)-((1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL)) AS DISCOUNT,
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		((ORD_R.QUANTITY*ORD_R.PRICE)-((1- O.SA_DISCOUNT/#dsn_alias#.IS_ZERO((O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT),1)) * ORD_R.NETTOTAL)) / OM.RATE2 AS DISCOUNT_DOVIZ,
	</cfif>
	O.CANCEL_DATE,
	O.ORDER_STATUS,
	O.ORDER_DATE,
	O.DELIVERDATE,
	O.ORDER_ID,
	<cfif attributes.report_type neq 22>
		ORD_R.PRODUCT_ID,
		ORD_R.STOCK_ID,
	</cfif>
	<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
		PC.PRODUCT_CATID,
        (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT
         <cfif attributes.report_type eq 24>
          ,(CONS.CONSUMER_NAME + ' '+ CONS.CONSUMER_SURNAME)AS MUSTERI,
            CONS.CONSUMER_ID AS MUSTERI_ID,
            2 MEMBER_TYPE
        </cfif>
	<cfelseif ListFind("2",attributes.report_type)>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		S.PRODUCT_CODE_2,
		P.BARCOD,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
        <cfif x_show_second_unit>
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
        </cfif>	
		<cfif x_unit_weight eq 1>
            (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT,
        </cfif>
		<cfif attributes.is_kdv eq 0>
			ISNULL((ORD_R.NETTOTAL/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		<cfelse>
			ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		ORD_R.QUANTITY,
		ORD_R.UNIT AS BIRIM,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT
	<cfelseif ListFind("3",attributes.report_type)>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE,
		S.STOCK_CODE,
		S.STOCK_ID,
		S.PROPERTY,
		P.BARCOD,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
        <cfif x_show_second_unit>
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
        </cfif>
            <cfif x_unit_weight eq 1>
	            (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT,
            </cfif>
		<cfif attributes.is_kdv eq 0>
			ISNULL((ORD_R.NETTOTAL/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		<cfelse>
			ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		ORD_R.QUANTITY,
		ORD_R.UNIT AS BIRIM,
		S.STOCK_CODE_2,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT
	<cfelseif attributes.report_type eq 4>
		(CONS.CONSUMER_NAME + ' '+ CONS.CONSUMER_SURNAME)AS MUSTERI,
		CONS.CONSUMER_ID AS MUSTERI_ID,
		2 MEMBER_TYPE,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 6>
		C.NICKNAME,
		C.COMPANY_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 5>
		CC.CONSCAT AS MUSTERI_TYPE,
		CC.CONSCAT_ID AS MUSTERI_TYPE_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 7>
		(SELECT BRANCH_NAME FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = O.DELIVER_DEPT_ID) AS BRANCH_NAME,
		PC.PRODUCT_CAT
	<cfelseif attributes.report_type eq 8>
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 9>
		PB.BRAND_NAME,
		P.BRAND_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 10>
		O.CUSTOMER_VALUE_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 11>
		O.RESOURCE_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 12>
		O.IMS_CODE_ID,
		SIC.IMS_CODE_NAME,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 13>
		O.ZONE_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 14>
		O.PAYMETHOD,
		O.CARD_PAYMETHOD_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 15>
		P.SEGMENT_ID,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 16>
		CONS.TAX_CITY_ID AS CITY,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 17>
		P.BRAND_ID,
		P.SHORT_CODE_ID,
		CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
		ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT,
		ORD_R.ORDER_ROW_CURRENCY,
        ORD_R.PRODUCT_NAME2,
		ORD_R.QUANTITY,
		O.ORDER_NUMBER,
		O.ORDER_ID,
		O.ORDER_HEAD,
		O.REF_NO,
		O.IS_INSTALMENT,
		C.CONSUMER_NAME+' ' +C.CONSUMER_SURNAME AS MUSTERI,
		C.CONSUMER_ID,
		2 MEMBER_TYPE,
		O.ORDER_DATE,
		ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE_,
		PC.PRODUCT_CAT,
		PC.HIERARCHY,
		PC.PRODUCT_CATID,
		S.PRODUCT_ID,
		S.STOCK_ID,
		P.PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_CODE,
        <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
            S.PRODUCT_CODE_2,
        </cfif>
		P.MANUFACT_CODE,
		ORD_R.QUANTITY AS PRODUCT_STOCK,
		ORD_R.UNIT AS BIRIM,
		ORD_R.SPECT_VAR_NAME,
		(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WITH (NOLOCK) WHERE SPECTS.SPECT_VAR_ID = ORD_R.SPECT_VAR_ID) AS SPECT_MAIN_ID,
        (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
        <cfif x_unit_weight eq 1>
	        (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
        </cfif>
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			ORD_R.NETTOTAL / OM.RATE2 NET_FIYAT,
			ORD_R.PRICE / OM.RATE2 BIRIM_FIYAT,
		<cfelse>
			ORD_R.NETTOTAL NET_FIYAT,
			ORD_R.PRICE BIRIM_FIYAT,
		</cfif>
		<cfif attributes.is_kdv eq 0>
			ORD_R.NETTOTAL ROW_LASTTOTAL,
		<cfelse>
			ISNULL((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100))),0) ROW_LASTTOTAL,
		</cfif>
		ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
			ORD_R.OTHER_MONEY AS OTHER_MONEY,
		</cfif>
		<cfif attributes.is_project eq 1>
			ORD_R.ROW_PROJECT_ID AS ROW_PROJECT_ID,
			O.PROJECT_ID AS PROJECT_ID,
		</cfif>
		ORD_R.WRK_ROW_ID
	<cfelseif attributes.report_type eq 18>
		E.EMPLOYEE_ID,
		(EMPLOYEE_NAME + ' '+ EMPLOYEE_SURNAME) AS EMP_NAME,
		PC.PRODUCT_CAT
	<cfelseif attributes.report_type eq 19>
		ORD_R.PRICE_CAT,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 21>
		ISNULL(O.SALES_PARTNER_ID,O.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
		CASE WHEN O.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE,
		ORD_R.QUANTITY AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 22>
		CAST(O.ORDER_DETAIL AS VARCHAR(200)) AS ORDER_DETAIL,
		O.ORDER_NUMBER,
		O.ORDER_HEAD,
		O.ORDER_ID,
		O.IS_INSTALMENT,
		C.CONSUMER_NAME+' ' +C.CONSUMER_SURNAME AS MUSTERI,
		C.CONSUMER_ID,
		1 MEMBER_TYPE,
		O.ORDER_DATE,
		O.CITY_ID,
		O.COUNTY_ID,
		O.ORDER_EMPLOYEE_ID,
		O.SALES_ADD_OPTION_ID,
		O.SHIP_DATE,
		O.SALES_PARTNER_ID,
		O.SALES_CONSUMER_ID,
		O.REF_NO,
		O.SHIP_METHOD,
		O.PAYMETHOD,
		O.SHIP_DATE,
		<cfif attributes.is_kdv eq 1>
			O.NETTOTAL,
        <cfelse>
        	(O.GROSSTOTAL-O.DISCOUNTTOTAL) NETTOTAL,
        </cfif>
		O.DELIVERDATE DELIVERDATE_,
		<!--- <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			ORD_R.PRICE / OM.RATE2 BIRIM_FIYAT,
		<cfelse>
			ORD_R.PRICE BIRIM_FIYAT,
		</cfif> --->
		O.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		O.OTHER_MONEY
		<cfif attributes.is_project eq 1>
			,O.PROJECT_ID AS PROJECT_ID
		</cfif>
	<cfelseif attributes.report_type eq 23>
        P.BRAND_ID,
        P.SHORT_CODE_ID,
        PC.PRODUCT_CAT,
        PC.HIERARCHY,
        PC.PRODUCT_CATID,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE,
        P.BARCOD,
        ORD_R.QUANTITY AS PRODUCT_STOCK,
        <cfif attributes.is_kdv eq 0>
            ISNULL((ORD_R.NETTOTAL/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
        <cfelse>
            ISNULL(((ORD_R.NETTOTAL + (ORD_R.NETTOTAL*(ORD_R.TAX/100)))/ORD_R.QUANTITY*(ORD_R.QUANTITY-ORD_R.DELIVER_AMOUNT)),0) ROW_LASTTOTAL,
        </cfif>
        <cfif attributes.is_other_money eq 1>
            ORD_R.OTHER_MONEY AS OTHER_MONEY,
        </cfif>
        ORD_R.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
        ORD_R.QUANTITY,
        ORD_R.UNIT AS BIRIM,
        ISNULL(ORD_R.DELIVER_AMOUNT,0) DELIVER_AMOUNT,
		MONTH(O.ORDER_DATE) AS ORDER_DATE_,
		PBM.MODEL_CODE,
        PBM.MODEL_NAME
	</cfif>
	FROM
		ORDERS O WITH (NOLOCK),
		ORDER_ROW ORD_R WITH (NOLOCK),
	<cfif (attributes.is_other_money eq 1) or (attributes.is_money2 eq 1) or (attributes.is_money_info eq 1)>
		ORDER_MONEY OM WITH (NOLOCK),
	</cfif>
		STOCKS S WITH (NOLOCK),
	<cfif listfind('1,2,3,7,24',attributes.report_type)>
		PRODUCT_CAT PC WITH (NOLOCK),
        <cfif attributes.report_type eq 24>
            #dsn_alias#.CONSUMER CONS WITH (NOLOCK),
        </cfif>
	<cfelseif attributes.report_type eq 20>
		#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
		#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),
	<cfelseif listfind('4,16',attributes.report_type)>
		#dsn_alias#.CONSUMER CONS WITH (NOLOCK),
	<cfelseif attributes.report_type eq 6>
		#dsn_alias#.COMPANY C WITH (NOLOCK),
	<cfelseif attributes.report_type eq 5>
		#dsn_alias#.CONSUMER C WITH (NOLOCK),
		#dsn_alias#.CONSUMER_CAT CC WITH (NOLOCK),
	<cfelseif attributes.report_type eq 8>
		#dsn_alias#.EMPLOYEES E WITH (NOLOCK),
	<cfelseif attributes.report_type eq 9>
		PRODUCT_BRANDS PB WITH (NOLOCK),
	<cfelseif attributes.report_type eq 12>
		#dsn_alias#.SETUP_IMS_CODE SIC WITH (NOLOCK),
	<cfelseif attributes.report_type eq 17>
		#dsn_alias#.CONSUMER C WITH (NOLOCK),
		PRODUCT_CAT PC WITH (NOLOCK),
	<cfelseif attributes.report_type eq 18>
		#dsn_alias#.EMPLOYEES E WITH (NOLOCK),
		PRODUCT_CAT PC WITH (NOLOCK),
	<cfelseif attributes.report_type eq 22>
    	#dsn_alias#.CONSUMER C WITH (NOLOCK),
	<cfelseif attributes.report_type eq 23>
    	PRODUCT_CAT PC WITH (NOLOCK),
        #dsn1_alias#.PRODUCT_BRANDS_MODEL PBM WITH (NOLOCK),
	</cfif>
		PRODUCT P WITH (NOLOCK)
	WHERE
		( ( O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0 )  OR ( O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1 ) )
		AND O.CONSUMER_ID IS NOT NULL 
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
			AND
			(
				(O.CONSUMER_ID IS NULL) 
				OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
			)
		</cfif>
		<cfif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 1>
			AND (ORD_R.WRK_ROW_ID IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID) OR
			ORD_R.WRK_ROW_ID IN(SELECT GS.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI,GET_ALL_SHIP_ROW GS WHERE GS.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID AND GS.WRK_ROW_ID = GI.WRK_ROW_RELATION_ID))
			<!--- ( 
				(	O.ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS WITH (NOLOCK)
						WHERE 
							OS.ORDER_ID=O.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(	O.ORDER_ID IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS WITH (NOLOCK),
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							</cfif>
						WHERE 
							OS.ORDER_ID = O.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND	 --->
            <cfif len(attributes.project_id) and len(attributes.project_head)>
				AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfelseif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 0>
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GS.WRK_ROW_RELATION_ID FROM GET_ALL_INVOICE_ROW GI,GET_ALL_SHIP_ROW GS WHERE GS.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID AND GS.WRK_ROW_ID = GI.WRK_ROW_RELATION_ID)
			<!--- ( 
				(	O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_INVOICE OS WITH (NOLOCK)
						WHERE 
							OS.ORDER_ID=O.ORDER_ID
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)
				)
			AND
				(	O.ORDER_ID NOT IN (
					<cfset count=0>
					<cfloop query="GET_COMP_PERIOD">
						<cfset count=count+1>
						SELECT 
							OS.ORDER_ID 
						FROM 
							ORDERS_SHIP OS WITH (NOLOCK),
							<cfif database_type is 'MSSQL'>
								#dsn#_#GET_COMP_PERIOD.PERIOD_YEAR#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							<cfelse>
								#dsn#_#Right(GET_COMP_PERIOD.PERIOD_YEAR,2)#_#session.ep.company_id#.INVOICE_SHIPS AS I_S  WITH (NOLOCK)
							</cfif>
						WHERE 
							OS.ORDER_ID = O.ORDER_ID
							AND OS.SHIP_ID = I_S.SHIP_ID 
							AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
						<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
					</cfloop>
						)	
				)
			) AND		 --->
		</cfif>
		<!--- Irsaliyelenmis - irsaliyelenmemis hareketleri filtreler FBS 20080508 --->
		<cfif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 1>
			AND ORD_R.WRK_ROW_ID IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_SHIP_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			<!--- O.ORDER_ID IN (
				<cfset count=0>
				<cfloop query="GET_COMP_PERIOD">
					<cfset count=count+1>
					SELECT 
						OS.ORDER_ID 
					FROM 
						ORDERS_SHIP OS WITH (NOLOCK)
					WHERE 
						OS.ORDER_ID=O.ORDER_ID
						AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
					<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
				</cfloop>
					)	AND	 --->
		<cfelseif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 0>
			AND ORD_R.WRK_ROW_ID NOT IN(SELECT GI.WRK_ROW_RELATION_ID FROM GET_ALL_SHIP_ROW GI WHERE GI.WRK_ROW_RELATION_ID = ORD_R.WRK_ROW_ID)
			<!--- O.ORDER_ID NOT IN (
				<cfset count=0>
				<cfloop query="GET_COMP_PERIOD">
					<cfset count=count+1>
					SELECT 
						OS.ORDER_ID 
					FROM 
						ORDERS_SHIP OS WITH (NOLOCK)
					WHERE 
						OS.ORDER_ID=O.ORDER_ID
						AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_COMP_PERIOD.PERIOD_ID#">
					<cfif count lt GET_COMP_PERIOD.RECORDCOUNT>UNION ALL</cfif>
				</cfloop>
					)	AND				 --->
		</cfif>
		<cfif attributes.is_prom eq 0>
			AND ORD_R.IS_PROMOTION <> 1
		</cfif>
		<cfif isdefined('attributes.sale_add_option') and len(attributes.sale_add_option)>
			AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
		</cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
			AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif attributes.is_other_money eq 1 and attributes.report_type eq 22>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = O.OTHER_MONEY
		<cfelseif attributes.is_other_money eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = ORD_R.OTHER_MONEY
		<cfelseif attributes.is_money2 eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
		</cfif>
		<cfif attributes.is_money_info eq 1>
			AND OM.ACTION_ID = O.ORDER_ID
			AND OM.MONEY_TYPE = ORD_R.OTHER_MONEY
		</cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
			AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
		</cfif>
		<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>
			AND O.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND O.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
			AND ORD_R.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">	
		</cfif>
		<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
			AND O.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif len(trim(attributes.row_employee)) and len(attributes.row_employee_id)>
			AND ORD_R.BASKET_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_employee_id#">
		</cfif>
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#">
		</cfif>
		<cfif len(trim(attributes.company)) and len(attributes.company_id)>
			AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		</cfif>
		<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
			AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		</cfif>
		<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
			AND O.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(O.COMPANY_ID IS NULL) OR
					(O.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>	
	</cfif>
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
			AND P.BRAND_ID IN(#attributes.brand_id#)
		</cfif>
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>
			AND P.SHORT_CODE_ID IN (#attributes.model_id#)
		</cfif>
		<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
			AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#">
		</cfif>
		<cfif len(attributes.termin_date1) and isdate(attributes.termin_date1)>
			AND ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date1#">
		</cfif>
		<cfif len(attributes.termin_date2) and isdate(attributes.termin_date2)>
			AND ISNULL(ORD_R.DELIVER_DATE,O.DELIVERDATE) <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.termin_date2#">
		</cfif>
		<cfif len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type)>
			<cfif attributes.sales_member_type eq 'partner'>
				AND O.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
			<cfelse>
				AND O.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
			</cfif>
		</cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
			AND S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%">
		</cfif>
		<cfif len(attributes.segment_id)>
			AND P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#">
		</cfif>
		<cfif isdefined("attributes.city_id") and len(attributes.city_id) and attributes.report_type eq 22>
			AND O.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
		</cfif>
		<cfif isdefined("attributes.county_id") and len(attributes.county_id) and attributes.report_type eq 22>
			AND O.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
		</cfif>
		<cfif listfind('1,2,3,24',attributes.report_type)>
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
		<cfelseif attributes.report_type eq 20>
			AND PC_2.PRODUCT_CATID = P.PRODUCT_CATID
			AND CHARINDEX('.',PC_2.HIERARCHY) <> 0
			AND PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1))			
		<cfelseif listfind('4,16,24',attributes.report_type)>
			AND O.CONSUMER_ID = CONS.CONSUMER_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 5>
			AND O.CONSUMER_ID = C.CONSUMER_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
			AND C.CONSUMER_CAT_ID = CC.CONSCAT_ID
		<cfelseif attributes.report_type eq 6>
			AND P.COMPANY_ID = C.COMPANY_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND
				(
					(P.COMPANY_ID IS NULL) OR
					(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 8>
			AND E.EMPLOYEE_ID =O.ORDER_EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			AND P.BRAND_ID = PB.BRAND_ID
		<cfelseif attributes.report_type eq 12>
			AND O.IMS_CODE_ID = SIC.IMS_CODE_ID
		<cfelseif attributes.report_type eq 17>
			AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND O.CONSUMER_ID = C.CONSUMER_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 18>
			AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY
			AND ORD_R.BASKET_EMPLOYEE_ID = E.EMPLOYEE_ID
		<cfelseif attributes.report_type eq 7>
			AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY
			<cfif len(attributes.department_id)>
				AND O.DELIVER_DEPT_ID IN 
				(<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#">
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1>,</cfif>
				</cfloop>)
			<cfelse>
				AND (O.DELIVER_DEPT_ID IS NULL OR O.DELIVER_DEPT_ID IN (#branch_dep_list#)) 
			</cfif>
		<cfelseif attributes.report_type eq 22>
			AND O.CONSUMER_ID = C.CONSUMER_ID
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		<cfelseif attributes.report_type eq 23>
	        AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			AND P.SHORT_CODE_ID = PBM.MODEL_ID
            AND P.SHORT_CODE_ID IS NOT NULL
		</cfif>	
		AND S.PRODUCT_ID = P.PRODUCT_ID
		AND ORD_R.STOCK_ID = S.STOCK_ID
		AND O.ORDER_ID = ORD_R.ORDER_ID
		<cfif len(attributes.customer_value_id)>
			AND O.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
		</cfif>
		<cfif len(attributes.resource_id)>
			AND O.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
		</cfif>
		<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
			AND O.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
		</cfif>
		<cfif len(attributes.zone_id)>
			AND O.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
		</cfif>
        <cfif len(attributes.country_id)>
			AND O.COUNTRY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
		</cfif>
		<cfif isdefined("brysl_uye") and listlen(brysl_uye)>
			AND O.CONSUMER_ID IN
				(
				SELECT 
					C.CONSUMER_ID 
				FROM 
					#dsn_alias#.CONSUMER C,
					#dsn_alias#.CONSUMER_CAT CAT 
				WHERE 
				AND C.CONSUMER_CAT_ID = CAT.CONSCAT_ID
					(
						<cfloop list="#brysl_uye#" delimiters="," index="cons_j">
							(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cons_j,'-')#">)
							<cfif cons_j neq listlast(brysl_uye,',') and listlen(brysl_uye,',') gte 1> OR</cfif>
						</cfloop>  
					) 
				)
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND
					(
						(O.CONSUMER_ID IS NULL) 
						OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					)
				</cfif>
		<cfelseif isdefined("krmsl_uye") and listlen(krmsl_uye)>
			AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		</cfif>
        <cfif attributes.report_type eq 17 and (isdefined('xml_order_row_dept') and xml_order_row_dept eq 1)>
        	<cfif len(attributes.department_id)>
                AND(
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (ORD_R.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ORD_R.DELIVER_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                ) 
            <cfelseif len(branch_dep_list)>
                AND	(ORD_R.DELIVER_DEPT IN(#branch_dep_list#) OR ORD_R.DELIVER_DEPT IS NULL)
            </cfif>
		<cfelse>
			<cfif len(attributes.department_id)>
                AND (
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND O.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                ) 
            <cfelseif len(branch_dep_list)>
                AND	(O.DELIVER_DEPT_ID IN(#branch_dep_list#) OR O.DELIVER_DEPT_ID IS NULL)
            </cfif>
        </cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
		</cfif>
		<cfif len(attributes.cancel_type_id)>
			AND ORD_R.CANCEL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cancel_type_id#"> 
		</cfif>
		<cfif len(attributes.order_stage)>
			AND ORD_R.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
		</cfif>
		<cfif len(attributes.order_process_cat)>
			AND O.ORDER_STAGE IN (#attributes.order_process_cat#)
		</cfif>
		<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
			AND	O.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(O.CONSUMER_ID IS NULL) 
					OR (O.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
		</cfif>
		<cfif len(attributes.branch_id)>
			AND O.FRM_BRANCH_ID IN (#attributes.branch_id#)
		</cfif>
		<cfif attributes.report_type eq 24 >
        	AND CONS.CONSUMER_ID = O.CONSUMER_ID 
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
				AND
				(
					(CONS.CONSUMER_ID IS NULL) 
					OR (CONS.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
			</cfif>
        </cfif>
</cfquery>


<!--- Burdan sonra queryleri birleştirme vs yapılıyor --->
<cfquery name="get_total_purchase_1" dbtype="query">
	SELECT
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
		<cfif attributes.is_kdv eq 0>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE) AS PRICE,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		<cfelse>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE) AS PRICE,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		</cfif>
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
	<cfelse>
		<cfif attributes.is_kdv eq 0>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		<cfelse>
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		</cfif>
	</cfif>
	SUM(DISCOUNT) AS DISCOUNT,
	<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
		PRODUCT_CAT,
		HIERARCHY,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		PRODUCT_CATID,
        MULTIPLIER_AMOUNT
        <cfif attributes.report_type eq 24>
            ,MUSTERI,
            MUSTERI_ID,
            MEMBER_TYPE
        </cfif>
	<cfelseif ListFind("2",attributes.report_type)>
		BRAND_ID,
		SHORT_CODE_ID,
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		PRODUCT_NAME,
		PRODUCT_CODE,		
        PRODUCT_CODE_2,
		BARCOD,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
        <cfif x_show_second_unit>
            UNIT2,
            MULTIPLIER,
        </cfif>	
        <cfif x_unit_weight eq 1>
        	UNIT_WEIGHT,
        </cfif>
		SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
		SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
		SUM(QUANTITY) QUANTITY,
		BIRIM,
		SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
	<cfelseif ListFind("3",attributes.report_type)>
		BRAND_ID,
		SHORT_CODE_ID,
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		PRODUCT_NAME,
		PRODUCT_CODE,
		STOCK_ID,
		STOCK_CODE,
		PROPERTY,
		BARCOD,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
         <cfif x_show_second_unit>
            UNIT2,
            MULTIPLIER,
        </cfif>	
        <cfif x_unit_weight eq 1>
        	UNIT_WEIGHT,
        </cfif>
		SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
		SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
		SUM(QUANTITY) QUANTITY,
		BIRIM,
		STOCK_CODE_2,
		SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
	<cfelseif attributes.report_type eq 4>
		MUSTERI,
		MUSTERI_ID,
		MEMBER_TYPE,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 5>
		MUSTERI_TYPE,
		MUSTERI_TYPE_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 6>
		NICKNAME,
		COMPANY_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 7>
		BRANCH_NAME,
		PRODUCT_CAT
	<cfelseif attributes.report_type eq 8>
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 9>
		BRAND_NAME,
		BRAND_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 10>
		CUSTOMER_VALUE_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 11>
		RESOURCE_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 12>
		IMS_CODE_ID,
		IMS_CODE_NAME,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 13>
		ZONE_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 14>
		PAYMETHOD,
		CARD_PAYMETHOD_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 15>
		SEGMENT_ID,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 16>
		CITY,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 17>
		BRAND_ID,
		SHORT_CODE_ID,
		ORDER_DETAIL,
		DELIVER_AMOUNT,
		ORDER_ROW_CURRENCY,
        PRODUCT_NAME2,
		QUANTITY,
		ORDER_NUMBER,
		ORDER_ID,
		ORDER_HEAD,
		REF_NO,
		IS_INSTALMENT,
		MUSTERI,
		COMPANY_ID,
		MEMBER_TYPE,
		ORDER_DATE,
		DELIVERDATE_,
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		STOCK_ID,
		PRODUCT_NAME,
		PROPERTY,
		STOCK_CODE,
        <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
            PRODUCT_CODE_2,
        </cfif>
		MANUFACT_CODE,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		BIRIM,
		BIRIM_FIYAT,
		OTHER_MONEY_VALUE,
		SPECT_VAR_NAME,
		SPECT_MAIN_ID,
        MULTIPLIER_AMOUNT_1,
        <cfif x_unit_weight eq 1>
        	UNIT_WEIGHT_1,
        </cfif>
		<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
			OTHER_MONEY,
		</cfif>
		<cfif attributes.is_project eq 1>
			ROW_PROJECT_ID,
			PROJECT_ID,
		</cfif>
		ROW_LASTTOTAL,
		ORDER_STAGE,
		WRK_ROW_ID
	<cfelseif attributes.report_type eq 18>
		EMPLOYEE_ID,
		EMP_NAME,
		PRODUCT_CAT
	<cfelseif attributes.report_type eq 19>
		PRICE_CAT,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 21>
		SALES_MEMBER_ID,
		SALES_MEMBER_TYPE,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
	<cfelseif attributes.report_type eq 22>
		ORDER_DETAIL,
		ORDER_NUMBER,
		ORDER_HEAD,
		ORDER_ID,
		IS_INSTALMENT,
		MUSTERI,
		COMPANY_ID,
		MEMBER_TYPE,
		ORDER_DATE,
		CITY_ID,
		COUNTY_ID,
		ORDER_EMPLOYEE_ID,
		SALES_ADD_OPTION_ID,
		SALES_PARTNER_ID,
		SALES_CONSUMER_ID,
		REF_NO,
		SHIP_METHOD,
		PAYMETHOD,
		SHIP_DATE,
		NETTOTAL,
		DELIVERDATE_,
		<!--- BIRIM_FIYAT, --->
		OTHER_MONEY_VALUE,
		OTHER_MONEY,
		<cfif attributes.is_project eq 1>
			PROJECT_ID,
		</cfif>
		ORDER_STAGE
	<cfelseif attributes.report_type eq 23>
		BRAND_ID,
		SHORT_CODE_ID,
		PRODUCT_CAT,
		HIERARCHY,
		PRODUCT_CATID,
		PRODUCT_ID,
		PRODUCT_NAME,
		PRODUCT_CODE,
		BARCOD,
		SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
		SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
		SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
		SUM(QUANTITY) QUANTITY,
		BIRIM,
		SUM(DELIVER_AMOUNT) DELIVER_AMOUNT,
        ORDER_DATE_,
        MODEL_CODE,
        MODEL_NAME
	</cfif>
	FROM
		T1
	WHERE
		<cfif get_process_cancel_id.recordcount neq 0>
			ORDER_STAGE NOT IN (#get_process_cancel_id.PROCESS_ROW_ID#) AND
		</cfif>
		ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
	GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>	
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,                
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			PRODUCT_CODE_2,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
                UNIT_WEIGHT,
            </cfif>
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
			STOCK_CODE_2
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME
		<cfelseif attributes.report_type eq 13>
			ZONE_ID
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID
		<cfelseif attributes.report_type eq 16>
			CITY
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
	<cfif (not len(attributes.status)) and attributes.is_iptal eq 1>
		UNION ALL
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			</cfif>
		</cfif>
		SUM(-1*DISCOUNT) AS DISCOUNT,
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
           <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_CODE_2,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
                UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			STOCK_CODE_2,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 13>
			ZONE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 16>
			CITY,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
		FROM
			T1
		WHERE
			ORDER_STATUS = 0
			<cfif get_process_cancel_id.recordcount neq 0>
				AND ORDER_STAGE NOT IN (#get_process_cancel_id.PROCESS_ROW_ID#)
			</cfif>
			AND ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
		GROUP BY
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>	
			<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
                MULTIPLIER_AMOUNT
                 <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
			<cfelseif ListFind("2",attributes.report_type)>
				BRAND_ID,
				SHORT_CODE_ID,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
                <cfif x_show_second_unit>
                    UNIT2,
                    MULTIPLIER,
                </cfif>	
                <cfif x_unit_weight eq 1>
                    UNIT_WEIGHT,
                </cfif>
				PRODUCT_CODE_2,
				BARCOD,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				BIRIM
			<cfelseif ListFind("3",attributes.report_type)>
				BRAND_ID,
				SHORT_CODE_ID,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
                <cfif x_show_second_unit>
                    UNIT2,
                    MULTIPLIER,
                </cfif>	
                <cfif x_unit_weight eq 1>
                    UNIT_WEIGHT,
                </cfif>
				STOCK_ID,
				STOCK_CODE,
				PROPERTY,
				BARCOD,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				BIRIM,
				STOCK_CODE_2
			<cfelseif attributes.report_type eq 4>
				MUSTERI,
				MUSTERI_ID,
				MEMBER_TYPE
			<cfelseif attributes.report_type eq 6>
				NICKNAME,
				COMPANY_ID
			<cfelseif attributes.report_type eq 5>
				MUSTERI_TYPE,
				MUSTERI_TYPE_ID
			<cfelseif attributes.report_type eq 7>
				BRANCH_NAME,
				PRODUCT_CAT
			<cfelseif attributes.report_type eq 8>
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				EMPLOYEE_ID
			<cfelseif attributes.report_type eq 9>
				BRAND_NAME,
				BRAND_ID
			<cfelseif attributes.report_type eq 10>
				CUSTOMER_VALUE_ID
			<cfelseif attributes.report_type eq 11>
				RESOURCE_ID
			<cfelseif attributes.report_type eq 12>
				IMS_CODE_ID,
				IMS_CODE_NAME
			<cfelseif attributes.report_type eq 13>
				ZONE_ID
			<cfelseif attributes.report_type eq 14>
				PAYMETHOD,
				CARD_PAYMETHOD_ID
			<cfelseif attributes.report_type eq 15>
				SEGMENT_ID
			<cfelseif attributes.report_type eq 16>
				CITY
			<cfelseif attributes.report_type eq 17>
				BRAND_ID,
				SHORT_CODE_ID,
				ORDER_DETAIL,
				DELIVER_AMOUNT,
				ORDER_ROW_CURRENCY,
                PRODUCT_NAME2,
				QUANTITY,
				ORDER_NUMBER,
				ORDER_ID,
				ORDER_HEAD,
				REF_NO,
				IS_INSTALMENT,
				MUSTERI,
				COMPANY_ID,
				MEMBER_TYPE,
				ORDER_DATE,
				DELIVERDATE_,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PROPERTY,
				STOCK_CODE,
                <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                    PRODUCT_CODE_2,
                </cfif>
				MANUFACT_CODE,
				BIRIM,
				BIRIM_FIYAT,
				OTHER_MONEY_VALUE,
				SPECT_VAR_NAME,
				SPECT_MAIN_ID,
                MULTIPLIER_AMOUNT_1,
                <cfif x_unit_weight eq 1>
	                UNIT_WEIGHT_1,
                </cfif>
				<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
					OTHER_MONEY,
				</cfif>
				<cfif attributes.is_project eq 1>
					ROW_PROJECT_ID,
					PROJECT_ID,
				</cfif>
				ROW_LASTTOTAL,
				ORDER_STAGE,
				WRK_ROW_ID
			<cfelseif attributes.report_type eq 18>
				EMPLOYEE_ID,
				EMP_NAME,
				PRODUCT_CAT
			<cfelseif attributes.report_type eq 19>
				PRICE_CAT
			<cfelseif attributes.report_type eq 21>
				SALES_MEMBER_ID,
				SALES_MEMBER_TYPE
			<cfelseif attributes.report_type eq 22>
				ORDER_DETAIL,
				ORDER_NUMBER,
				ORDER_HEAD,
				ORDER_ID,
				IS_INSTALMENT,
				MUSTERI,
				COMPANY_ID,
				MEMBER_TYPE,
				ORDER_DATE,
				CITY_ID,
				COUNTY_ID,
				ORDER_EMPLOYEE_ID,
				SALES_ADD_OPTION_ID,
				SALES_PARTNER_ID,
				SALES_CONSUMER_ID,
				REF_NO,
				SHIP_METHOD,
				PAYMETHOD,
				SHIP_DATE,
				NETTOTAL,
				DELIVERDATE_,
				<!--- BIRIM_FIYAT, --->
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				<cfif attributes.is_project eq 1>
					PROJECT_ID,
				</cfif>
				ORDER_STAGE
			<cfelseif attributes.report_type eq 23>
				BRAND_ID,
				SHORT_CODE_ID,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				BIRIM,
                ORDER_DATE_,
                MODEL_CODE,
                MODEL_NAME
			</cfif>	
	</cfif>
	UNION ALL
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(PRICE) AS PRICE,
				SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
			<cfelse>
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(PRICE) AS PRICE,
				SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(PRICE) AS PRICE,
			<cfelse>
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(PRICE) AS PRICE,
			</cfif>
		</cfif>
			SUM(DISCOUNT) AS DISCOUNT,
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_CODE_2,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			<cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,	
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			<cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
                UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			STOCK_CODE_2,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 13>
			ZONE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 16>
			CITY,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
	FROM
		T2
	WHERE
		<cfif get_process_cancel_id.recordcount neq 0>
			ORDER_STAGE NOT IN (#get_process_cancel_id.PROCESS_ROW_ID#) AND
		</cfif>
		ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
	GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>	
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			<cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
                UNIT_WEIGHT,
            </cfif>
			PRODUCT_CODE_2,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
                UNIT_WEIGHT,
            </cfif>
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
			STOCK_CODE_2
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME
		<cfelseif attributes.report_type eq 13>
			ZONE_ID
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID
		<cfelseif attributes.report_type eq 16>
			CITY
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
	<cfif (not len(attributes.status)) and attributes.is_iptal eq 1>
		UNION ALL
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(-1*PRICE) AS PRICE,
				SUM(-1*PRICE_DOVIZ) AS PRICE_DOVIZ,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			<cfelse>
				SUM(-1*GROSSTOTAL) GROSSTOTAL,
				SUM(-1*PRICE) AS PRICE,
			</cfif>
		</cfif>
		SUM(-1*DISCOUNT) AS DISCOUNT,
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_CODE_2,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			STOCK_CODE_2,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 13>
			ZONE_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 16>
			CITY,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE,
			SUM(-1*PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
	FROM
		T2
	WHERE
		ORDER_STATUS = 0
		<cfif get_process_cancel_id.recordcount neq 0>
			AND ORDER_STAGE NOT IN (#get_process_cancel_id.PROCESS_ROW_ID#)
		</cfif>
		AND ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
	GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>	
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			PRODUCT_CODE_2,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			STOCK_ID,
			STOCK_CODE,
			PROPERTY,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
			STOCK_CODE_2
		<cfelseif listfind('4',attributes.report_type)>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE
		<cfelseif listfind('6',attributes.report_type)>
			NICKNAME,
			COMPANY_ID
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME
		<cfelseif attributes.report_type eq 13>
			ZONE_ID
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID
		<cfelseif attributes.report_type eq 16>
			CITY
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			CONSUMER_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
	</cfif>
</cfquery>
<cfif isdefined("get_total_purchase_1")>
	<cfquery name="get_total_purchase_3"  dbtype="query" >
		SELECT * FROM get_total_purchase_1
	</cfquery>
<cfelse>
	<cfset get_total_purchase_3.recordcount=0>
</cfif>
<cfif get_total_purchase_3.recordcount>
	<cfquery name="get_total_purchase" dbtype="query">
		SELECT 
			SUM(GROSSTOTAL) GROSSTOTAL,
			SUM(PRICE) AS PRICE,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
			SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
		</cfif>
		SUM(DISCOUNT) AS DISCOUNT,
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
			PRODUCT_CODE_2,
			BARCOD,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE,
			SUM(QUANTITY) QUANTITY,
			BIRIM,
			SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			BARCOD,
			PRODUCT_CODE,
			STOCK_CODE,
			STOCK_ID,
			PROPERTY,
			BIRIM,
			SUM(QUANTITY) QUANTITY,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			SUM(ROW_LASTTOTAL) ROW_LASTTOTAL,
			SUM(OTHER_MONEY_VALUE) OTHER_MONEY_VALUE
			<cfif attributes.is_other_money eq 1>
				,OTHER_MONEY
			</cfif>
			,STOCK_CODE_2
			,SUM(DELIVER_AMOUNT) DELIVER_AMOUNT
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 13>
			ZONE_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 16>
			CITY,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			ORDER_STAGE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif isDefined('x_unit_weight') And x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			WRK_ROW_ID,
			BIRIM,
			BIRIM_FIYAT,
			ROW_LASTTOTAL
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE,
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
			BIRIM AS UNIT,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
		FROM 
			get_total_purchase_3
		GROUP BY
		<cfif attributes.is_other_money eq 1>
			OTHER_MONEY,
		</cfif>
		<cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
			PRODUCT_CAT,
			HIERARCHY,
            MULTIPLIER_AMOUNT
             <cfif attributes.report_type eq 24>
                ,MUSTERI,
                MUSTERI_ID,
                MEMBER_TYPE
            </cfif>
		<cfelseif ListFind("2",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			PRODUCT_CODE_2,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM
		<cfelseif ListFind("3",attributes.report_type)>
			BRAND_ID,
			SHORT_CODE_ID,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_ID,
			PRODUCT_NAME,
			PRODUCT_CODE,
            <cfif x_show_second_unit>
                UNIT2,
                MULTIPLIER,
            </cfif>	
            <cfif x_unit_weight eq 1>
            	UNIT_WEIGHT,
            </cfif>
			STOCK_CODE,
			PROPERTY,
			STOCK_ID,
			BARCOD,
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			BIRIM,
			STOCK_CODE_2
		<cfelseif attributes.report_type eq 4>
			MUSTERI,
			MUSTERI_ID,
			MEMBER_TYPE
		<cfelseif attributes.report_type eq 6>
			NICKNAME,
			COMPANY_ID
		<cfelseif attributes.report_type eq 5>
			MUSTERI_TYPE,
			MUSTERI_TYPE_ID
		<cfelseif attributes.report_type eq 7>
			BRANCH_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 8>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID
		<cfelseif attributes.report_type eq 9>
			BRAND_NAME,
			BRAND_ID
		<cfelseif attributes.report_type eq 10>
			CUSTOMER_VALUE_ID
		<cfelseif attributes.report_type eq 11>
			RESOURCE_ID
		<cfelseif attributes.report_type eq 12>
			IMS_CODE_ID,
			IMS_CODE_NAME
		<cfelseif attributes.report_type eq 13>
			ZONE_ID
		<cfelseif attributes.report_type eq 14>
			PAYMETHOD,
			CARD_PAYMETHOD_ID
		<cfelseif attributes.report_type eq 15>
			SEGMENT_ID
		<cfelseif attributes.report_type eq 16>
			CITY
		<cfelseif attributes.report_type eq 17>
			BRAND_ID,
			SHORT_CODE_ID,
			ORDER_DETAIL,
			DELIVER_AMOUNT,
			<cfif attributes.is_project eq 1>
				ROW_PROJECT_ID,
				PROJECT_ID,
			</cfif>
			ORDER_ROW_CURRENCY,
            PRODUCT_NAME2,
			QUANTITY,
			ORDER_NUMBER,
			ORDER_ID,
			ORDER_HEAD,
			REF_NO,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			DELIVERDATE_,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
            <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
                PRODUCT_CODE_2,
            </cfif>
			MANUFACT_CODE,
			BIRIM,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
            MULTIPLIER_AMOUNT_1,
            <cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money_info eq 1>
				OTHER_MONEY,
			</cfif>
			ROW_LASTTOTAL,
			ORDER_STAGE,
			WRK_ROW_ID
		<cfelseif attributes.report_type eq 18>
			EMPLOYEE_ID,
			EMP_NAME,
			PRODUCT_CAT
		<cfelseif attributes.report_type eq 19>
			PRICE_CAT
		<cfelseif attributes.report_type eq 21>
			SALES_MEMBER_ID,
			SALES_MEMBER_TYPE
		<cfelseif attributes.report_type eq 22>
			ORDER_DETAIL,
			ORDER_NUMBER,
			ORDER_HEAD,
			ORDER_ID,
			IS_INSTALMENT,
			MUSTERI,
			COMPANY_ID,
			MEMBER_TYPE,
			ORDER_DATE,
			CITY_ID,
			COUNTY_ID,
			ORDER_EMPLOYEE_ID,
			SALES_ADD_OPTION_ID,
			SALES_PARTNER_ID,
			SALES_CONSUMER_ID,
			REF_NO,
			SHIP_METHOD,
			PAYMETHOD,
			SHIP_DATE,
			NETTOTAL,
			DELIVERDATE_,
			<!--- BIRIM_FIYAT, --->
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			<cfif attributes.is_project eq 1>
				PROJECT_ID,
			</cfif>
			ORDER_STAGE
		<cfelseif attributes.report_type eq 23>
			BIRIM,
            ORDER_DATE_,
            MODEL_CODE,
            MODEL_NAME
		</cfif>
		<cfif attributes.report_type eq 7>
			ORDER BY PRODUCT_CAT,BRANCH_NAME
		<cfelseif attributes.report_type eq 18>
			ORDER BY PRODUCT_CAT,EMP_NAME
		<cfelseif attributes.report_type eq 22 and attributes.report_sort eq 2>
			ORDER BY PRICE DESC
		<cfelseif attributes.kontrol eq 1>
			ORDER BY ORDER_NUMBER
		<cfelseif attributes.report_type eq 23>
	        ORDER BY ORDER_DATE_ ASC
		<cfelseif attributes.report_sort eq 1>
			ORDER BY PRICE DESC
		<cfelse>
			ORDER BY PRICE DESC
		</cfif>
	</cfquery>
	<cfif attributes.report_type neq 22>
		<cfquery name="get_all_total" dbtype="query">
			SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
		</cfquery>
	<cfelse>
		<cfquery name="get_all_total" dbtype="query">
			SELECT SUM(NETTOTAL) AS PRICE FROM get_total_purchase
		</cfquery>
	</cfif>
	<cfif len(get_all_total.PRICE)>
		<cfset butun_toplam = get_all_total.PRICE >
	<cfelse>
		<cfset butun_toplam = 1>
	</cfif>
<cfelse>
	<cfset get_total_purchase.recordcount=0>
	<cfset butun_toplam = 1>
</cfif>
