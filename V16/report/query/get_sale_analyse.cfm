<!---process_type_select Yazar Kasa ve Z Raporu işlem tipi için kullanılıyor. (670,690)--->
<cfset kurumsal = ''>
<cfset bireysel = ''>
<cfif listlen(attributes.member_cat_type)>
	<cfset uzunluk=listlen(attributes.member_cat_type)>
	<cfloop from="1" to="#uzunluk#" index="catyp">
		<cfset eleman = listgetat(attributes.member_cat_type,catyp,',')>
		<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
        	<cfset kurumsal = listappend(kurumsal,listlast(eleman,'-'))>
		<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
	       	<cfset bireysel = listappend(bireysel,listlast(eleman,'-'))>
		</cfif>
	</cfloop>
</cfif>
<cfset all_process_type = attributes.process_type_>
<cfset return_process_type=""><!--- iadeler --->
<cfset give_process_type=""><!--- verilen fiyat farkı v.s. miktara etki etmez --->
<cfset take_process_type=""><!--- alınan fiyat farkı v.s. miktara etki etmez --->
<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>
<cfif listlen(attributes.process_type_)>
	<cfquery name="get_process_types" datasource="#dsn3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type_#) ORDER BY PROCESS_CAT
	</cfquery>
	<cfoutput query="get_process_types">
		<cfif listfind("54,55",get_process_types.process_type)>
			<cfset return_process_type=listappend(return_process_type,get_process_types.process_cat_id)>
			<cfset all_process_type=listdeleteat(all_process_type,listfind(all_process_type,get_process_types.process_cat_id))>
		</cfif>
		<cfif listfind("49,51,63",get_process_types.process_type)>
			<cfset take_process_type=listappend(take_process_type,get_process_types.process_cat_id)>
			<cfset all_process_type=listdeleteat(all_process_type,listfind(all_process_type,get_process_types.process_cat_id))>
		</cfif>
		<cfif listfind("48,50,58",get_process_types.process_type)>
			<cfset give_process_type=listappend(give_process_type,get_process_types.process_cat_id)>
			<cfset all_process_type=listdeleteat(all_process_type,listfind(all_process_type,get_process_types.process_cat_id))>
		</cfif>
	</cfoutput>
</cfif>
<!--- Aşağıda queryleri karıştırmasın diye yukarda değişken olarak tanımlandı----Select Bloğu --->
<cfif attributes.report_type eq 1 or attributes.report_type eq 32>
	<cfif x_show_second_unit>
		<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,BIRIM,BIRIM2'>
	<cfelse>
		<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,BIRIM'>
	</cfif>
<cfelseif attributes.report_type eq 2>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BARCOD,BIRIM,MIN_MARGIN,BRAND_ID,SHORT_CODE_ID,UNIT2,MULTIPLIER,UNIT_WEIGHT,MULTIPLIER_AMOUNT_1'>
<cfelseif attributes.report_type eq 3>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_NAME,STOCK_CODE,PROPERTY,BARCOD,STOCK_ID,BIRIM AS BIRIM,MIN_MARGIN,STOCK_CODE_2,BRAND_ID,SHORT_CODE_ID,UNIT2,MULTIPLIER,UNIT_WEIGHT'>
<cfelseif attributes.report_type eq 4>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MUSTERI,MUSTERI_ID,MUSTERI_CITY,TYPE AS TYPE,TAXOFFICE,TAXNO,MEMBER_CODE,SALES_COUNTY,ZONE_ID'>
<cfelseif attributes.report_type eq 6>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MUSTERI,MUSTERI_ID,TYPE AS TYPE,MEMBER_CODE'>
<cfelseif attributes.report_type eq 5>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MUSTERI_TYPE,MUSTERI_TYPE_ID'>
<cfelseif attributes.report_type eq 7>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BRANCH_NAME,BRANCH_ID'>
<cfelseif attributes.report_type eq 8>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID'>
<cfelseif attributes.report_type eq 9>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BRAND_NAME,BRAND_ID'>
<cfelseif attributes.report_type eq 10>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,CUSTOMER_VALUE_ID'>
<cfelseif attributes.report_type eq 11>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,RESOURCE_ID'>
<cfelseif attributes.report_type eq 12>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,IMS_CODE_ID,IMS_CODE_NAME'>
<cfelseif attributes.report_type eq 13>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,ZONE_ID'>
<cfelseif attributes.report_type eq 33>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SECTOR_CAT_ID'>
<cfelseif attributes.report_type eq 14>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PAY_METHOD,CARD_PAYMETHOD_ID'>
<cfelseif attributes.report_type eq 15>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SEGMENT_ID'>
<cfelseif attributes.report_type eq 16>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,CITY'>
<cfelseif attributes.report_type eq 17>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PROJECT_ID AS PROJECT_ID'>
<cfelseif attributes.report_type eq 18>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,POSITION_CODE AS POSITION_CODE'>
<cfelseif attributes.report_type eq 19>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BIRIM,MIN_MARGIN,INVOICE_NUMBER,SERIAL_NUMBER,SERIAL_NO,INVOICE_CAT,INVOICE_ID,PURCHASE_SALES,MUSTERI AS MUSTERI,COMPANY_ID,UYE_NO,ACCOUNT_CODE,CONSUMER_ID,EMPLOYEE_ID,INVOICE_DATE,PRODUCT_CAT,BRAND_ID,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PROPERTY,STOCK_CODE,MANUFACT_CODE,PRICELESS_AMOUNT,PRICE_CAT,DUE_DATE,PRICE_ROW,PRICE_ROW_OTHER,OTHER_MONEY_VALUE,OTHER_MONEY,NETTOTAL_ROW,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10,NOTE,COST_PRICE_2,COST_PRICE,COST_PRICE_OTHER,COST_PRICE_MONEY,SPECT_VAR_NAME,SPECT_MAIN_ID,MARGIN,INVOICE_ROW_ID,KATEGORI,PROJECT_ID,ROW_PROJECT_ID,DEPARTMENT_ID,ORDER_BRANCH_ID,PRODUCT_CODE_2,SHORT_CODE_ID,UNIT_WEIGHT_1,MULTIPLIER_AMOUNT_2,UNIT2,LOT_NO,BARCOD,EXPENSE_CENTER'>
<cfif not attributes.process_type_select eq 690>
	<cfset col = col&',OZEL_KOD_2'>   
</cfif>
<cfelseif attributes.report_type eq 20>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PROM_ID,PROM_NO,PROM_HEAD'>
<cfelseif attributes.report_type eq 21>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE'>
<cfelseif attributes.report_type eq 22>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRODUCT_ID,PRODUCT_NAME'>
<cfelseif attributes.report_type eq 34>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID'>
<cfelseif attributes.report_type eq 35>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID'>
<cfelseif attributes.report_type eq 39>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,COUNTRY_NAME'>    
<cfelseif attributes.report_type eq 36>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,MUSTERI_TYPE,MUSTERI_TYPE_ID'>
<cfelseif attributes.report_type eq 23>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRODUCT_ID,PRODUCT_NAME,MUSTERI,MUSTERI_ID,TYPE AS TYPE,STOCK_CODE'>
<cfelseif attributes.report_type eq 41>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MUSTERI,MUSTERI_ID,TYPE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,UNIT2,MULTIPLIER'>
<cfelseif attributes.report_type eq 40>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE,MUSTERI,MUSTERI_ID,TYPE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,UNIT2,MULTIPLIER'>
<cfelseif attributes.report_type eq 24>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,TYPE AS TYPE,TAXOFFICE,TAXNO'>
<cfelseif attributes.report_type eq 25>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SALE_EMP,PRODUCT_ID,PRODUCT_NAME,MUSTERI,MUSTERI_ID,TYPE AS TYPE'>
<cfelseif attributes.report_type eq 26>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SALES_MEMBER_ID,SALES_MEMBER_TYPE'>
<cfelseif attributes.report_type eq 27>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MEMBER_REFERENCE_CODE,MUSTERI,MUSTERI_ID,TYPE AS TYPE'>
<cfelseif attributes.report_type eq 28>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRICE_CAT'>
<cfelseif attributes.report_type eq 42>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CODE_2'>
<cfelseif attributes.report_type eq 29>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,WP_POSITION_CODE AS WP_POSITION_CODE,PRICE_CAT'>
<cfelseif attributes.report_type eq 30>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BARCOD,PRICE_CAT'>
<cfelseif attributes.report_type eq 31>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,COUNTRY_ID'>
<cfelseif attributes.report_type eq 37>
	<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
		<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK, t_1, t_2,t_3, t_4, t_5,t_6,t_7, t_8, t_9, t_10,t_11, t_12, t_13,t_14, t_15,t_16'>    
	<cfelse>
		<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK, t_'&attributes.product_types>    
	</cfif>
<cfelseif attributes.report_type eq 38>
	<cfset col = 'SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MODEL_NAME,MODEL_CODE,INVOICE_DATE,UNIT'>
</cfif>    
<!--- Aşağıda queryleri karıştırmasın diye yukarda değişken olarak tanımlandı----Group by Bloğu --->
<cfif attributes.report_type eq 1 or attributes.report_type eq 32>
	<cfif x_show_second_unit>
		<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,BIRIM,BIRIM2'>
	<cfelse>
		<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,BIRIM'>
	</cfif>
<cfelseif attributes.report_type eq 2 >
	<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BARCOD,BIRIM,MIN_MARGIN,BRAND_ID,SHORT_CODE_ID,UNIT2,MULTIPLIER,UNIT_WEIGHT,MULTIPLIER_AMOUNT_1'>
<cfelseif attributes.report_type eq 3 >
	<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_NAME,STOCK_CODE,PROPERTY,BARCOD,STOCK_ID,BIRIM,MIN_MARGIN,STOCK_CODE_2,BRAND_ID,SHORT_CODE_ID,UNIT2,MULTIPLIER,UNIT_WEIGHT'>
<cfelseif attributes.report_type eq 4 >
	<cfset col2 = 'MUSTERI,TYPE,MUSTERI_ID,MUSTERI_CITY,TAXOFFICE,TAXNO,MEMBER_CODE,SALES_COUNTY,ZONE_ID'>
<cfelseif attributes.report_type eq 5>
	<cfset col2 = 'MUSTERI_TYPE,MUSTERI_TYPE_ID'>
<cfelseif attributes.report_type eq 6 >
	<cfset col2 = 'MUSTERI,TYPE,MUSTERI_ID,MEMBER_CODE'>	
<cfelseif attributes.report_type eq 7>
	<cfset col2 = 'BRANCH_NAME,BRANCH_ID'>
<cfelseif attributes.report_type eq 8>
	<cfset col2 = 'EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID'>
<cfelseif attributes.report_type eq 9>
	<cfset col2 = 'BRAND_NAME,BRAND_ID'>
<cfelseif attributes.report_type eq 10>
	<cfset col2 = 'CUSTOMER_VALUE_ID'>
<cfelseif attributes.report_type eq 11>
	<cfset col2 = 'RESOURCE_ID'>
<cfelseif attributes.report_type eq 12>
	<cfset col2 = 'IMS_CODE_ID,IMS_CODE_NAME'>
<cfelseif attributes.report_type eq 13>
	<cfset col2 = 'ZONE_ID'>
<cfelseif attributes.report_type eq 33>
	<cfset col2 = 'SECTOR_CAT_ID'>
<cfelseif attributes.report_type eq 14>
	<cfset col2 = 'PAY_METHOD,CARD_PAYMETHOD_ID'>
<cfelseif attributes.report_type eq 15>
	<cfset col2 = 'SEGMENT_ID'>
<cfelseif attributes.report_type eq 16>
	<cfset col2 = 'CITY'>
<cfelseif attributes.report_type eq 17>
	<cfset col2 = 'PROJECT_ID'>
<cfelseif attributes.report_type eq 18>
	<cfset col2 = 'POSITION_CODE'>
<cfelseif attributes.report_type eq 19>
	<cfset col2 = 'INVOICE_NUMBER,SERIAL_NUMBER,SERIAL_NO,INVOICE_CAT,INVOICE_ID,PURCHASE_SALES,MUSTERI,COMPANY_ID,UYE_NO,ACCOUNT_CODE,CONSUMER_ID,EMPLOYEE_ID,INVOICE_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PROPERTY,STOCK_CODE,MANUFACT_CODE,BIRIM,BRAND_ID,MIN_MARGIN,PRICELESS_AMOUNT,PRICE_CAT,DUE_DATE,PRICE_ROW,PRICE_ROW_OTHER,OTHER_MONEY_VALUE,OTHER_MONEY,NETTOTAL_ROW,DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10,NOTE,COST_PRICE_2,COST_PRICE,COST_PRICE_OTHER,COST_PRICE_MONEY,SPECT_VAR_NAME,SPECT_MAIN_ID,MARGIN,INVOICE_ROW_ID,KATEGORI,PROJECT_ID,ROW_PROJECT_ID,DEPARTMENT_ID,ORDER_BRANCH_ID,PRODUCT_CODE_2,SHORT_CODE_ID,UNIT_WEIGHT_1,MULTIPLIER_AMOUNT_2,UNIT2,LOT_NO,BARCOD,EXPENSE_CENTER'>
	<cfif not attributes.process_type_select eq 690>
		<cfset col2 = col2&',OZEL_KOD_2'>   
	</cfif>
<cfelseif attributes.report_type eq 20>
	<cfset col2 = 'PROM_ID,PROM_NO,PROM_HEAD'>
<cfelseif attributes.report_type eq 21>
	<cfset col2 = 'WP_POSITION_CODE'>
<cfelseif attributes.report_type eq 22>
	<cfset col2 = 'WP_POSITION_CODE,PRODUCT_ID,PRODUCT_NAME'>
<cfelseif attributes.report_type eq 23>
	<cfset col2 = 'WP_POSITION_CODE,PRODUCT_ID,PRODUCT_NAME,MUSTERI,TYPE,MUSTERI_ID,STOCK_CODE'>
<cfelseif attributes.report_type eq 40>
	<cfset col2 = 'WP_POSITION_CODE,MUSTERI,TYPE,MUSTERI_ID,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,UNIT2,MULTIPLIER'>
<cfelseif attributes.report_type eq 41>
<cfset col2 = 'MUSTERI,TYPE,MUSTERI_ID,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,UNIT2,MULTIPLIER'>
<cfelseif attributes.report_type eq 24>
	<cfset col2 = 'TYPE,TAXOFFICE,TAXNO'>
<cfelseif attributes.report_type eq 25>
	<cfset col2 = 'SALE_EMP,PRODUCT_ID,PRODUCT_NAME,MUSTERI,MUSTERI_ID,TYPE'>
<cfelseif attributes.report_type eq 26>
	<cfset col2 = 'SALES_MEMBER_ID,SALES_MEMBER_TYPE'>
<cfelseif attributes.report_type eq 27>
	<cfset col2 = 'MEMBER_REFERENCE_CODE,MUSTERI,MUSTERI_ID,TYPE'>
<cfelseif attributes.report_type eq 28>
	<cfset col2 = 'PRICE_CAT'>
<cfelseif attributes.report_type eq 42>
	<cfset col2 = 'PRODUCT_CODE_2'>
<cfelseif attributes.report_type eq 29>
	<cfset col2 = 'WP_POSITION_CODE,PRICE_CAT'>
<cfelseif attributes.report_type eq 30>
	<cfset col2 = 'PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,BARCOD,PRICE_CAT'>
<cfelseif attributes.report_type eq 31>
	<cfset col2 = 'COUNTRY_ID'>
<cfelseif attributes.report_type eq 34>
	<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,WP_POSITION_CODE'>
<cfelseif attributes.report_type eq 35>
	<cfset col2 = 'WP_POSITION_CODE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID'>
<cfelseif attributes.report_type eq 39>
	<cfset col2 = 'PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,WP_POSITION_CODE,COUNTRY_NAME'>    
<cfelseif attributes.report_type eq 36>
	<cfset col2 = 'WP_POSITION_CODE,MUSTERI_TYPE,MUSTERI_TYPE_ID'>
<cfelseif attributes.report_type eq 37>
	<cfset col2 = ' t_1, t_2,t_3, t_4, t_5,t_6,t_7, t_8, t_9, t_10,t_11, t_12, t_13,t_14, t_15,t_16'>
   
    <cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
	<cfset col2 = ' t_1, t_2,t_3, t_4, t_5,t_6,t_7, t_8, t_9, t_10,t_11, t_12, t_13,t_14, t_15,t_16'>
	<cfelse>
		<cfset col2 = 't_'&attributes.product_types>    
	</cfif>
<cfelseif attributes.report_type eq 38>
	<cfset col2 = 'MODEL_CODE,MODEL_NAME,INVOICE_DATE,UNIT'>
</cfif>
<cfif attributes.report_type eq 37>
	<cfquery name="check_table" datasource="#dsn2#">
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_company_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_company_#session.ep.userid#
        
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_company_1_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_company_1_#session.ep.userid#
        
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_company_2_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_company_2_#session.ep.userid#
        
         IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_consumer_#session.ep.userid#')
         DROP TABLE ####sale_analyse_report_consumer_#session.ep.userid#
         
         IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_consumer_1_#session.ep.userid#')
         DROP TABLE ####sale_analyse_report_consumer_1_#session.ep.userid#
         
         IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_consumer_2_#session.ep.userid#')
         DROP TABLE ####sale_analyse_report_consumer_2_#session.ep.userid#
               
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_employee_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_employee_#session.ep.userid#
         
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_employee_1_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_employee_1_#session.ep.userid#
         
        IF EXISTS (select * from tempdb.sys.tables where name='####sale_analyse_report_employee_2_#session.ep.userid#')
        DROP TABLE ####sale_analyse_report_employee_2_#session.ep.userid#
    
    	IF EXISTS (select * from tempdb.sys.tables where name='####get_total_purchase_1_#session.ep.userid#')
        DROP TABLE ####get_total_purchase_1_#session.ep.userid#
    
    	IF EXISTS (select * from tempdb.sys.tables where name='####get_total_purchase_2_#session.ep.userid#')
        DROP TABLE ####get_total_purchase_2_#session.ep.userid#
	
        IF EXISTS (select * from tempdb.sys.tables where name='####get_total_purchase_3_#session.ep.userid#')
        DROP TABLE ####get_total_purchase_3_#session.ep.userid#        
    </cfquery>
</cfif>
<cfif len(attributes.process_type_) and not listfind(attributes.process_type_select,670) and not listfind(attributes.process_type_select,690)><!--- yazarkasa ve zraporu(670,690) için type lardan çalıştığndan yeni typer larla bölümler ayrılmış --->
	<cfquery name="T1" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
       		I.INVOICE_NUMBER,<!---smh--->
        	<!---C.COUNTRY,---><!---smh--->       
        	IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				IR.AMOUNT*IR.PRICE GROSSTOTAL,
				IR.AMOUNT*IR.PRICE / IM.RATE2 GROSSTOTAL_DOVIZ,
				(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
				( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) / IM.RATE2 AS PRICE_DOVIZ,
			<cfelse>
				IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
				IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
				(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
				((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) / IM.RATE2 AS PRICE_DOVIZ,
			</cfif>
			<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
					ISNULL((
						<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
							<cfif attributes.is_money2 eq 1>
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
								<cfelse>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
								</cfif>
							<cfelse>
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
								<cfelse>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
								</cfif>
							</cfif>
						<cfelse>
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
							<cfelse>
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
							</cfif>
						</cfif>
						)+ISNULL(PROM_COST,0)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
						<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
							ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
						</cfif>
						<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
							PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
						</cfif>
						PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
							AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
						</cfif>
						<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1 and attributes.is_other_money eq 1>
							AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
						</cfif>
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.PRODUCT_COST_ID DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0) <cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1>/ <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
				,0) AS NET_KAR_DOVIZ,
				<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
			<cfelse>
				ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
				<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
			</cfif>
			<cfif attributes.is_other_money eq 1>
				IR.OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				IR.AMOUNT*IR.PRICE GROSSTOTAL,
				(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
			<cfelse>
				IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
				(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
			</cfif>
		</cfif>
		<cfif attributes.is_discount eq 1>
			((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS DISCOUNT,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / IM.RATE2 AS DISCOUNT_DOVIZ,
			</cfif>
		</cfif>
		<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
			ISNULL(IR.MARGIN,((IR.NETTOTAL - ISNULL((XXX.IN_COLUMN),0))*100)/ISNULL((XXX.IN_COLUMN),0)) AS NET_KAR,
		<cfelse>
			ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
		</cfif>
			I.PROCESS_CAT,            
            (IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
		<cfif attributes.report_type eq 1 or attributes.report_type eq 32>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			IR.AMOUNT AS PRODUCT_STOCK,
            IR.UNIT AS BIRIM,
            IR.UNIT2 AS BIRIM2,
            (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
		<cfelseif attributes.report_type eq 37>
        	IR.AMOUNT AS PRODUCT_STOCK,
		  <cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
				CASE
					WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
				 ,CASE   
					WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
				,CASE    
					WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
				,CASE    
					WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
				,CASE    
					WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
				,CASE    
					WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
				,CASE    
					WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
				,CASE    
					WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
				,CASE    
					WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
				,CASE    
					WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
				,CASE    
					WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
				,CASE    
					WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
				,CASE    
					WHEN P.IS_COST = 1 THEN 13 END AS t_13
				,CASE    
					WHEN P.IS_SALES = 1 THEN 14 END AS t_14
				,CASE    
					WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
				,CASE    
					WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
			<cfelse>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				CASE
					WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
				 </cfif>
				 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				 CASE   
					WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
				 </cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				CASE    
					WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				CASE    
					WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				CASE    
					WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				CASE    
					WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				CASE    
					WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				CASE    
					WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				CASE    
					WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				CASE    
					WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
				CASE    
					WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
				CASE    
					WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
				CASE    
					WHEN P.IS_COST = 1 THEN 13 END AS t_13
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
				CASE    
					WHEN P.IS_SALES = 1 THEN 14 END AS t_14
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
				CASE    
					WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
				CASE    
					WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
				</cfif>
			</cfif>
		<cfelseif attributes.report_type eq 2>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			IR.AMOUNT AS PRODUCT_STOCK,
			IR.UNIT AS BIRIM,
			P.MIN_MARGIN,
			S.BRAND_ID,
			S.SHORT_CODE_ID,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
            (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
            (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
		<cfelseif attributes.report_type eq 3>
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			P.PRODUCT_NAME,
			S.STOCK_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_ID,
			IR.AMOUNT AS PRODUCT_STOCK,
			IR.UNIT AS BIRIM,
			P.MIN_MARGIN,
			S.STOCK_CODE_2,
			S.BRAND_ID,
			S.SHORT_CODE_ID,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
            (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
		<cfelseif attributes.report_type eq 4>
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			C.CITY AS MUSTERI_CITY,
			1 AS TYPE,
			IR.AMOUNT AS PRODUCT_STOCK,
			C.TAXOFFICE,
			ISNULL(C.TAXNO,(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = C.COMPANY_ID AND COMP_PART.PARTNER_ID = C.MANAGER_PARTNER_ID )) AS TAXNO,
			C.MEMBER_CODE,
			I.INVOICE_ID,
			C.SALES_COUNTY,
            I.ZONE_ID
		<cfelseif attributes.report_type eq 6>
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE,
			IR.AMOUNT AS PRODUCT_STOCK,
			C.MEMBER_CODE
		<cfelseif attributes.report_type eq 5>
			CC.COMPANYCAT AS MUSTERI_TYPE,
			CC.COMPANYCAT_ID AS MUSTERI_TYPE_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 7>
			B.BRANCH_NAME,
			B.BRANCH_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 8>
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 9>
			PB.BRAND_NAME,
			P.BRAND_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 10>
			I.CUSTOMER_VALUE_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 11>
			I.RESOURCE_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 12>
			I.IMS_CODE_ID,
			SIC.IMS_CODE_NAME,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 13>
			I.ZONE_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 33>
			<!---C.SECTOR_CAT_ID,--->
			COMPANY_SECTOR_RELATION.SECTOR_ID AS SECTOR_CAT_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 14>
			I.PAY_METHOD,
			I.CARD_PAYMETHOD_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 15>
			P.SEGMENT_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 16>
			C.CITY AS CITY,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 17>
			PR.PROJECT_ID AS PROJECT_ID,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 18>
			EP.POSITION_CODE AS POSITION_CODE,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 19>
			S.SHORT_CODE_ID,
			I.INVOICE_NUMBER,
			I.SERIAL_NUMBER,
			I.SERIAL_NO,
			I.INVOICE_CAT,
			I.INVOICE_ID,
			I.PURCHASE_SALES,
			I.PROJECT_ID,
			C.FULLNAME AS MUSTERI,
			C.COMPANY_ID,
			C.OZEL_KOD_2,
			C.MEMBER_CODE AS UYE_NO,
			(SELECT TOP 1 ACCOUNT_CODE FROM #dsn_alias#.COMPANY_PERIOD CP WHERE CP.COMPANY_ID = C.COMPANY_ID) ACCOUNT_CODE,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
            (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
			(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
			0 AS CONSUMER_ID,
			0 AS EMPLOYEE_ID,
			I.INVOICE_DATE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			S.STOCK_ID,
			P.PRODUCT_NAME,
			S.PROPERTY,
			S.STOCK_CODE,
			P.MANUFACT_CODE,
			IR.AMOUNT AS PRODUCT_STOCK,
			IR.UNIT AS BIRIM,
			P.BRAND_ID,
			P.MIN_MARGIN,
			IR.INVOICE_ROW_ID,
			ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0)PRICELESS_AMOUNT,
			(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
			IR.PRICE_CAT,
			IR.DUE_DATE,
			IR.ROW_PROJECT_ID,
			I.DEPARTMENT_ID,
			<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
				ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
			<cfelse>
				'' ORDER_BRANCH_ID,
			</cfif>
			IR.PRICE PRICE_ROW,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
			<cfelse>
				IR.PRICE PRICE_ROW_OTHER,
			</cfif>
				IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
				IR.OTHER_MONEY OTHER_MONEY,
			<cfif attributes.is_kdv eq 1>
				(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
			<cfelse>
				IR.NETTOTAL NETTOTAL_ROW,
			</cfif>
			IR.DISCOUNT1,
			IR.DISCOUNT2,
			IR.DISCOUNT3,
			IR.DISCOUNT4,
			IR.DISCOUNT5,
			IR.DISCOUNT6,
			IR.DISCOUNT7,
			IR.DISCOUNT8,
			IR.DISCOUNT9,
			IR.DISCOUNT10,
			I.NOTE,
            S.PRODUCT_CODE_2,
			<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
				ISNULL((XXX.COST_PRICE_OTHER),0) COST_PRICE_OTHER,
				ISNULL((XXX.PURCHASE_NET_MONEY),0) COST_PRICE_MONEY,
				ISNULL((XXX.COST_PRICE),0) COST_PRICE,
				ISNULL((xxx.COST_PRICE_2),0) COST_PRICE_2,
			<cfelse>
				IR.COST_PRICE+IR.EXTRA_COST COST_PRICE_OTHER,
				'#session.ep.money#' COST_PRICE_MONEY,
				IR.COST_PRICE+IR.EXTRA_COST COST_PRICE,
				0 AS COST_PRICE_2,
			</cfif>
			IR.SPECT_VAR_NAME,
			(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
			MARGIN,
			CC.COMPANYCAT AS KATEGORI,
			IR.ROW_PROJECT_ID,
			I.DEPARTMENT_ID,
			IR.LOT_NO,
			P.BARCOD
		<cfelseif attributes.report_type eq 20>
			PROM.PROM_ID AS PROM_ID,
			PROM.PROM_NO AS PROM_NO,
			PROM.PROM_HEAD AS PROM_HEAD,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 21>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE
		<cfelseif attributes.report_type eq 22>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			S.PRODUCT_ID,
			P.PRODUCT_NAME
		<cfelseif attributes.report_type eq 34 or attributes.report_type eq 35>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
        <cfelseif attributes.report_type eq 39>
        	SC.COUNTRY_ID,
			SC.COUNTRY_NAME,
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		<cfelseif attributes.report_type eq 36>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			CC.COMPANYCAT AS MUSTERI_TYPE,
			CC.COMPANYCAT_ID AS MUSTERI_TYPE_ID
		<cfelseif attributes.report_type eq 23>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE,
			S.STOCK_CODE,
			IR.AMOUNT AS PRODUCT_STOCK
        <cfelseif attributes.report_type eq 40>
			WP.POSITION_CODE AS WP_POSITION_CODE,
			IR.AMOUNT AS PRODUCT_STOCK, 
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE,
            PC.PRODUCT_CAT,
            PC.HIERARCHY,
			PC.PRODUCT_CATID,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
        <cfelseif  attributes.report_type eq 41>
        	IR.AMOUNT AS PRODUCT_STOCK, 
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE,
            PC.PRODUCT_CAT,
            PC.HIERARCHY,
			PC.PRODUCT_CATID,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
		<cfelseif attributes.report_type eq 24>
			IR.AMOUNT AS PRODUCT_STOCK,
			1 AS TYPE,
			C.TAXOFFICE,
			ISNULL(C.TAXNO,(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = C.COMPANY_ID AND COMP_PART.PARTNER_ID = C.MANAGER_PARTNER_ID )) AS TAXNO,
			I.INVOICE_ID
		<cfelseif attributes.report_type eq 25>
			IR.AMOUNT AS PRODUCT_STOCK, 
			I.SALE_EMP,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE
		<cfelseif attributes.report_type eq 26>
			IR.AMOUNT AS PRODUCT_STOCK,
			ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
			CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
		<cfelseif attributes.report_type eq 27>
			IR.AMOUNT AS PRODUCT_STOCK,
			I.PARTNER_REFERENCE_CODE AS MEMBER_REFERENCE_CODE,
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE
		<cfelseif attributes.report_type eq 28>
			IR.AMOUNT AS PRODUCT_STOCK,
			IR.PRICE_CAT
		<cfelseif attributes.report_type eq 29>
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			IR.PRICE_CAT
		<cfelseif attributes.report_type eq 30>
			IR.AMOUNT AS PRODUCT_STOCK, 
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			IR.PRICE_CAT
		<cfelseif attributes.report_type eq 42>
			P.PRODUCT_CODE_2,
			IR.AMOUNT AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 4>
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			C.CITY AS MUSTERI_CITY,
			1 AS TYPE,
			IR.AMOUNT AS PRODUCT_STOCK,
			C.TAXOFFICE,
			ISNULL(C.TAXNO,(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = C.COMPANY_ID COMP_PART.PARTNER_ID = C.MANAGER_PARTNER_ID)) AS TAXNO,			
			C.MEMBER_CODE,
			I.INVOICE_ID,
            I.ZONE_ID
		<cfelseif attributes.report_type eq 31>
			IR.AMOUNT AS PRODUCT_STOCK,
			C.COUNTRY AS COUNTRY_ID
		<cfelseif attributes.report_type eq 38>
        	P.PRODUCT_NAME,
            MONTH(I.INVOICE_DATE) AS INVOICE_DATE,
            I.INVOICE_ID,
            P.PRODUCT_ID,
			IR.AMOUNT AS PRODUCT_STOCK,
            IR.UNIT,
			PBM.MODEL_CODE,
            PBM.MODEL_NAME
		</cfif>
        <cfif attributes.report_type eq 37>
            INTO ####sale_analyse_report_company_1_#session.ep.userid#
		</cfif>
        FROM
			INVOICE I WITH (NOLOCK) 
            LEFT JOIN  #dsn_alias#.COMPANY CO WITH (NOLOCK) ON CO.COMPANY_ID = I.COMPANY_ID
			LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = CO.COUNTRY
            inner join                        
			INVOICE_ROW IR WITH (NOLOCK) on I.INVOICE_ID = IR.INVOICE_ID
            <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
                        outer apply
                        (
                   								
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                                    SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                                    <cfelse>
                                    SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                                    </cfif>
                                    )+ISNULL(PROM_COST,0) AS IN_COLUMN
                                    <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										,(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS COST_PRICE_OTHER
									<cfelse>
										,(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS COST_PRICE_OTHER 
									</cfif>
                                    	,PURCHASE_NET_MONEY
                                   	<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                                         ,(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                                    <cfelse>
                                         ,(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                                    </cfif>
                                    )+ISNULL(PROM_COST,0) AS COST_PRICE
                                   	<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                                        , (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
                                    <cfelse>
                                       , (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
                                    </cfif>
                                    ) AS  COST_PRICE_2
                                    FROM 
                                        #dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
                                    WHERE 
                                        PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                            ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                                        </cfif>
                                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1>
                                            PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
                                        </cfif>
                                        PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
                                        <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                                            AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
                                            AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
                                        </cfif>
                                    ORDER BY
                                        PRODUCT_COST.START_DATE DESC,
										PRODUCT_COST.PRODUCT_COST_ID DESC,
                                        PRODUCT_COST.RECORD_DATE DESC,
                                        PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                ) as xxx
            </cfif>
            ,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				INVOICE_MONEY IM WITH (NOLOCK),
			</cfif>
			#dsn3_alias#.STOCKS S WITH (NOLOCK),
			<cfif listfind('1,2,3,30',attributes.report_type)>
				#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn_alias#.COMPANY C WITH (NOLOCK),
			<cfelseif listfind('32',attributes.report_type)>
				#dsn_alias#.COMPANY C WITH (NOLOCK),
				#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),
			<cfelseif listfind('34',attributes.report_type)>
				#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
			<cfelseif listfind('35',attributes.report_type)>
				#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
            <cfelseif listfind('39',attributes.report_type)>
				#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
			<cfelseif listfind('36',attributes.report_type)>
				#dsn_alias#.COMPANY C WITH (NOLOCK),
				#dsn_alias#.COMPANY_CAT CC WITH (NOLOCK),
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
			<cfelseif listfind('4,6,16,24,27,31,33',attributes.report_type)>
				#dsn_alias#.COMPANY C WITH (NOLOCK)
				<cfif attributes.report_type eq 4>,<cfelse>LEFT JOIN #dsn_alias#.COMPANY_SECTOR_RELATION ON COMPANY_SECTOR_RELATION.COMPANY_ID = C.COMPANY_ID,</cfif>
			<cfelseif attributes.report_type eq 5>
				#dsn_alias#.COMPANY C WITH (NOLOCK),
				#dsn_alias#.COMPANY_CAT CC WITH (NOLOCK),
			<cfelseif attributes.report_type eq 7>
				#dsn_alias#.DEPARTMENT D WITH (NOLOCK),
				#dsn_alias#.BRANCH B WITH (NOLOCK),
			<cfelseif attributes.report_type eq 8>
				#dsn_alias#.EMPLOYEES E WITH (NOLOCK),
			<cfelseif attributes.report_type eq 9>
				#dsn3_alias#.PRODUCT_BRANDS PB WITH (NOLOCK),
			<cfelseif attributes.report_type eq 12>
				#dsn_alias#.SETUP_IMS_CODE SIC WITH (NOLOCK),
			<cfelseif attributes.report_type eq 17>
				#dsn_alias#.PRO_PROJECTS PR WITH (NOLOCK),
			<cfelseif attributes.report_type eq 19>
			    #dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
				#dsn_alias#.COMPANY C WITH (NOLOCK),
				#dsn_alias#.COMPANY_CAT CC WITH (NOLOCK),
			<cfelseif attributes.report_type eq 18>
				#dsn_alias#.EMPLOYEE_POSITIONS EP WITH (NOLOCK),
			<cfelseif attributes.report_type eq 20>
				#dsn3_alias#.PROMOTIONS PROM WITH (NOLOCK),
			<cfelseif listfind('21,22',attributes.report_type)>
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
			<cfelseif listfind('23,29',attributes.report_type)>
				#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),	
				#dsn_alias#.COMPANY C WITH (NOLOCK),
             <cfelseif listfind('40,41',attributes.report_type)>
                #dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
                #dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
                #dsn_alias#.COMPANY C WITH (NOLOCK),
			<cfelseif attributes.report_type eq 25>
				#dsn_alias#.COMPANY C WITH (NOLOCK),
			<cfelseif attributes.report_type eq 38>
				#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM WITH (NOLOCK),
			</cfif>
			<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and len(attributes.use_efatura)>
				#dsn_alias#.COMPANY C WITH (NOLOCK),
			</cfif>
			#dsn3_alias#.PRODUCT P WITH (NOLOCK)
		WHERE
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                I.DEPARTMENT_ID IN(
                        SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="yes">)
                    ) AND
            </cfif>
			<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 1>
				C.USE_EFATURA = 1 AND
				C.EFATURA_DATE <= I.INVOICE_DATE AND
			<cfelseif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 0>
				(C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE ) AND
			</cfif>
			I.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
			I.NETTOTAL > 0 AND
			<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                P.IS_PURCHASE = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                P.IS_INVENTORY = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                P.IS_TERAZI = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                P.IS_PURCHASE = 0 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                P.IS_PRODUCTION = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                P.IS_SERIAL_NO = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                P.IS_KARMA = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                P.IS_INTERNET = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                P.IS_PROTOTYPE = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                P.IS_ZERO_STOCK = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                P.IS_EXTRANET = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                P.IS_COST = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                P.IS_SALES = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                P.IS_QUALITY = 1 AND
            <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                P.IS_INVENTORY = 1 AND
            </cfif>
			<cfif attributes.is_prom eq 0>
				ISNULL(IR.IS_PROMOTION,0) <> 1 AND
			</cfif>
			<cfif attributes.is_other_money eq 1>
				IM.ACTION_ID = I.INVOICE_ID AND
				IM.MONEY_TYPE = IR.OTHER_MONEY AND
			<cfelseif attributes.is_money2 eq 1>
				IM.ACTION_ID = I.INVOICE_ID AND
				IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
			</cfif>
			<cfif isdefined("attributes.is_sale_product")>
				P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
				P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
				IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
			</cfif>
			<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
				I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			</cfif>
			<cfif len(attributes.sales_member)>
				<cfif attributes.sales_member_type eq "consumer">
					I.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
				<cfelse>
					I.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
				</cfif> AND
			</cfif>
			<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
				P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
			</cfif>
			<cfif len(trim(attributes.company)) and len(attributes.company_id)>
				I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			</cfif>
			<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
				I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
			</cfif>
			<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
				I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					(
						(I.CONSUMER_ID IS NULL) 
						OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					) AND
				</cfif>
			</cfif>
			<cfif isdefined('attributes.employee_id2') and len(trim(attributes.company)) and len(attributes.employee_id2)>
				I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id2#"> AND
			</cfif>
			<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
				I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND COMPANY_ID IS NOT NULL) AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
		</cfif>
			<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
				P.BRAND_ID IN (#attributes.brand_id#) AND
			</cfif>
			<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
				P.SHORT_CODE_ID IN (#attributes.model_id#) AND
			</cfif>
			<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
				P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(P.COMPANY_ID IS NULL) OR
						(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			</cfif>
			<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
				S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
			</cfif>
			<cfif len(attributes.city_id)>
				I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			</cfif>
			<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
				I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			</cfif>
			<cfif isdefined("attributes.county_id") and len(attributes.county_id)>
				I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			</cfif>
			<cfif len(attributes.process_type_)>
				I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69) AND 
			</cfif>
			<cfif len(attributes.price_catid)>
				IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			</cfif>
			<cfif len(attributes.department_id)>
				(
				<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
				</cfloop>  
				) AND
			<cfelseif len(branch_dep_list)>
				I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
			</cfif>
			<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
				<cfif attributes.report_type eq 3>
                    S.STOCK_ID IN (
                                        SELECT
                                            STOCK_ID
                                        FROM
                                            #dsn1_alias#.STOCKS_PROPERTY
                                        WHERE
                                            PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                            <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                            </cfif>
                                            
                                    ) AND
                <cfelse>
                    P.PRODUCT_ID IN (
                                        SELECT
                                            PRODUCT_ID
                                        FROM
                                            #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                        WHERE
                                            PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                            <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                            </cfif>
                                            
                                    ) AND
            	</cfif>
			</cfif>
			<cfif len(attributes.segment_id)>
				P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
			</cfif>
			I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			I.INVOICE_ID = IR.INVOICE_ID AND
			<cfif listfind('1,2,3,30',attributes.report_type)>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			<cfelseif listfind('32',attributes.report_type)>
				PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
				(
					(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
					PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
					OR
					(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
					PC.HIERARCHY = PC_2.HIERARCHY)
				) AND			
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			<cfelseif listfind('34',attributes.report_type)>
				PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
				(
					(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
					PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
					OR
					(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
					PC.HIERARCHY = PC_2.HIERARCHY)
				) AND		
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND  
			<cfelseif listfind('36',attributes.report_type)>
				I.COMPANY_ID = C.COMPANY_ID AND
				C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfelseif listfind('35',attributes.report_type)>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            <cfelseif listfind('39',attributes.report_type)>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND      
			<cfelseif listfind('4,16,24,27,31,33',attributes.report_type)>
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			<cfelseif attributes.report_type eq 5>
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
			<cfelseif attributes.report_type eq 6>
				P.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(P.COMPANY_ID IS NULL) OR
						(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			<cfelseif attributes.report_type eq 7>
				<cfif x_show_order_branch_type eq 1>
					ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) = B.BRANCH_ID AND
				<cfelse>
					I.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				</cfif>
				D.BRANCH_ID = B.BRANCH_ID AND
			<cfelseif attributes.report_type eq 8>
				E.EMPLOYEE_ID = I.SALE_EMP AND
			<cfelseif attributes.report_type eq 9>
				P.BRAND_ID = PB.BRAND_ID AND
			<cfelseif attributes.report_type eq 12>
				I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
			<cfelseif attributes.report_type eq 17>
				I.PROJECT_ID = PR.PROJECT_ID AND
			<cfelseif attributes.report_type eq 18>
				P.PRODUCT_MANAGER = EP.POSITION_CODE AND
			<cfelseif attributes.report_type eq 19>
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
			<cfelseif attributes.report_type eq 20>
				IR.PROM_ID = PROM.PROM_ID AND
			<cfelseif listfind('21,22',attributes.report_type)>
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfelseif listfind('23,29',attributes.report_type)>
				C.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(C.COMPANY_ID IS NULL) OR
						(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            <cfelseif listfind('40,41',attributes.report_type)>
            	PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				C.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(C.COMPANY_ID IS NULL) OR
						(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				I.COMPANY_ID = WP.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				WP.IS_MASTER = 1 AND
				WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
			<cfelseif attributes.report_type eq 25>
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			<cfelseif attributes.report_type eq 38>
				P.SHORT_CODE_ID = PBM.MODEL_ID AND
				P.SHORT_CODE_ID IS NOT NULL AND
			</cfif>
			<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and len(attributes.use_efatura)>
				I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
			</cfif>
			S.PRODUCT_ID = P.PRODUCT_ID AND
			IR.STOCK_ID = S.STOCK_ID
			<cfif len(attributes.customer_value_id)>
				AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
			</cfif>
			<cfif len(attributes.resource_id)>
				AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
			</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
				AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
			</cfif>
			<cfif len(attributes.zone_id)>
				AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
			</cfif>
			<cfif isdefined("kurumsal") and listlen(kurumsal)>
				AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
					(
					SELECT 
						C.COMPANY_ID 
					FROM 
						#dsn_alias#.COMPANY C,
						#dsn_alias#.COMPANY_CAT CAT 
					WHERE 
						C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
						CAT.COMPANYCAT_ID IN (#kurumsal#)                   
					)
				AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						)
					</cfif>
			</cfif>
			<cfif isdefined("bireysel") and listlen(bireysel)>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
					(
					SELECT 
						C.CONSUMER_ID 
					FROM 
						#dsn_alias#.CONSUMER C,
						#dsn_alias#.CONSUMER_CAT CAT 
					WHERE 
						C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
						CAT.CONSCAT_ID IN (#bireysel#) 
					)
				AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(C.CONSUMER_ID IS NULL) OR
						(C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					)
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
				AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
				AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
			</cfif>
			<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
				AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
			</cfif>
			<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
				AND	I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_SECTOR_RELATION WHERE SECTOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				AND (
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					)
				</cfif>
			</cfif>
			<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
				AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
			<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
				AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
			</cfif>
			<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
				AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
			</cfif>
	</cfquery>
	<!--- 2 QUERY TEK YAZINCA UNION NEDENİ İLE MSSQL 2000 DE HATA VERİYOR --->
	<cfif isdefined("attributes.is_zero_value")>
		<cfquery name="T1_0" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT  
            	I.INVOICE_NUMBER,          	
				IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				<cfif attributes.is_kdv eq 0>
					IR.AMOUNT*IR.PRICE GROSSTOTAL,
					IR.AMOUNT*IR.PRICE / IM.RATE2 GROSSTOTAL_DOVIZ,
					0 AS PRICE,
					0 PRICE_DOVIZ,
				<cfelse>
					IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
					IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
					0 AS PRICE,
					0 AS PRICE_DOVIZ,
				</cfif>
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
						ISNULL((
							<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
								<cfif attributes.is_money2 eq 1>
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
									<cfelse>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
									</cfif>
								<cfelse>
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
									<cfelse>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
									</cfif>
								</cfif>
							<cfelse>
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
								<cfelse>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
								</cfif>
							</cfif>
							)+ISNULL(PROM_COST,0)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
							<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1 and attributes.is_other_money eq 1>
								AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0) <cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1>/ <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
					,0) AS NET_KAR_DOVIZ,
					<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
				<cfelse>
					ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
					<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
				</cfif>
				<cfif attributes.is_other_money eq 1>
					IR.OTHER_MONEY,
				</cfif>
			<cfelse>
				<cfif attributes.is_kdv eq 0>
					IR.AMOUNT*IR.PRICE GROSSTOTAL,
					0 AS PRICE,
				<cfelse>
					IR.AMOUNT*IR.PRICE GROSSTOTAL,
					0 AS PRICE,
				</cfif>
			</cfif>
			<cfif attributes.is_discount eq 1>
				(IR.AMOUNT*IR.PRICE) AS DISCOUNT,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				(IR.AMOUNT*IR.PRICE) / IM.RATE2 AS DISCOUNT_DOVIZ,
				</cfif>
			</cfif>
			<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
				ISNULL(0 - 
					ISNULL((
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
							<cfelse>
								SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
							</cfif>
							)+ISNULL(PROM_COST,0)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0)
				,0) AS NET_KAR,
			<cfelse>
				ISNULL(0 - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
			</cfif>
				I.PROCESS_CAT,
				(IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
			<cfif listfind('1,32',attributes.report_type)>
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				IR.AMOUNT AS PRODUCT_STOCK,
                IR.UNIT AS BIRIM,
                IR.UNIT2 AS BIRIM2,
               (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
			<cfelseif attributes.report_type eq 2>
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.BARCOD,
				IR.AMOUNT AS PRODUCT_STOCK,
				IR.UNIT AS BIRIM,
				P.MIN_MARGIN,
				S.BRAND_ID,
				S.SHORT_CODE_ID,
                (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
                (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
			<cfelseif attributes.report_type eq 3>
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				P.PRODUCT_NAME,
				S.STOCK_CODE,
				S.PROPERTY,
				S.BARCOD,
				S.STOCK_ID,
				IR.AMOUNT AS PRODUCT_STOCK,
				IR.UNIT AS BIRIM,
				P.MIN_MARGIN,
				S.STOCK_CODE_2,
				S.BRAND_ID,
				S.SHORT_CODE_ID,
                (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
			<cfelseif attributes.report_type eq 4>
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				C.CITY AS MUSTERI_CITY,
				1 AS TYPE,
				IR.AMOUNT AS PRODUCT_STOCK,
				C.TAXOFFICE,
				ISNULL(C.TAXNO,(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = C.COMPANY_ID AND COMP_PART.PARTNER_ID = C.MANAGER_PARTNER_ID )) AS TAXNO,
				C.MEMBER_CODE,
				I.INVOICE_ID,
				C.SALES_COUNTY,
                I.ZONE_ID
			<cfelseif attributes.report_type eq 6>
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				1 AS TYPE,
				IR.AMOUNT AS PRODUCT_STOCK,
				C.MEMBER_CODE
			<cfelseif attributes.report_type eq 5>
				CC.COMPANYCAT AS MUSTERI_TYPE,
				CC.COMPANYCAT_ID AS MUSTERI_TYPE_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 7>
				B.BRANCH_NAME,
				B.BRANCH_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 8>
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 9>
				PB.BRAND_NAME,
				P.BRAND_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 10>
				I.CUSTOMER_VALUE_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 11>
				I.RESOURCE_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 12>
				I.IMS_CODE_ID,
				SIC.IMS_CODE_NAME,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 13>
				I.ZONE_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 33>
				<!---C.SECTOR_CAT_ID,--->
                COMPANY_SECTOR_RELATION.SECTOR_ID AS SECTOR_CAT_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 14>
				I.PAY_METHOD,
				I.CARD_PAYMETHOD_ID,
				IR.AMOUNT AS PRODUCT_STOCK

			<cfelseif attributes.report_type eq 15>
				P.SEGMENT_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 16>
				C.CITY AS CITY,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 17>
				PR.PROJECT_ID AS PROJECT_ID,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 18>
				EP.POSITION_CODE AS POSITION_CODE,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 19>
				S.SHORT_CODE_ID,
				I.INVOICE_NUMBER,
				I.SERIAL_NUMBER,
				I.SERIAL_NO,
				I.INVOICE_CAT,
				I.INVOICE_ID,
				I.PURCHASE_SALES,
				I.PROJECT_ID,
				C.FULLNAME AS MUSTERI,
				C.COMPANY_ID,
				C.OZEL_KOD_2,
				C.MEMBER_CODE AS UYE_NO,
				(SELECT TOP 1 ACCOUNT_CODE FROM #dsn_alias#.COMPANY_PERIOD CP WHERE CP.COMPANY_ID = C.COMPANY_ID) ACCOUNT_CODE,
                (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
                (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
				(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
				0 AS CONSUMER_ID,
				0 AS EMPLOYEE_ID,
				I.INVOICE_DATE,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				S.PRODUCT_ID,
				S.STOCK_ID,
				P.PRODUCT_NAME,
				S.PROPERTY,
				S.STOCK_CODE,
				P.MANUFACT_CODE,
				IR.AMOUNT AS PRODUCT_STOCK,
				IR.UNIT AS BIRIM,
				P.BRAND_ID,
				P.MIN_MARGIN,
				IR.INVOICE_ROW_ID,
				ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0)PRICELESS_AMOUNT,
				(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
				IR.PRICE_CAT,
				IR.DUE_DATE,
				IR.ROW_PROJECT_ID,
				I.DEPARTMENT_ID,
				<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
					ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
				<cfelse>
					'' ORDER_BRANCH_ID,
				</cfif>
				IR.PRICE PRICE_ROW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
				<cfelse>
					IR.PRICE PRICE_ROW_OTHER,
				</cfif>
				IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
				IR.OTHER_MONEY OTHER_MONEY,
				<cfif attributes.is_kdv eq 1>
					(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
				<cfelse>
					IR.NETTOTAL NETTOTAL_ROW,
				</cfif>
				IR.DISCOUNT1,
				IR.DISCOUNT2,
				IR.DISCOUNT3,
				IR.DISCOUNT4,
				IR.DISCOUNT5,
				IR.DISCOUNT6,
				IR.DISCOUNT7,
				IR.DISCOUNT8,
				IR.DISCOUNT9,
				IR.DISCOUNT10,
				I.NOTE,
                S.PRODUCT_CODE_2,
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					ISNULL((
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								SELECT TOP 1 (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
							<cfelse>
								SELECT TOP 1 (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
							</cfif>
							)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0) COST_PRICE_OTHER,
					ISNULL((
							SELECT TOP 1 PURCHASE_NET_MONEY
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0) COST_PRICE_MONEY,
					ISNULL((
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								SELECT TOP 1 (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
							<cfelse>
								SELECT TOP 1 (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
							</cfif>
							)+ISNULL(PROM_COST,0)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0) COST_PRICE,
					ISNULL((
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								SELECT TOP 1 (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
							<cfelse>
								SELECT TOP 1 (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2
							</cfif>
							)
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0) COST_PRICE_2,
				<cfelse>
					IR.COST_PRICE+IR.EXTRA_COST COST_PRICE_OTHER,
					'#session.ep.money#' COST_PRICE_MONEY,
					IR.COST_PRICE+IR.EXTRA_COST,
					0 AS COST_PRICE_2,
				</cfif>
				IR.SPECT_VAR_NAME,
				(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
				MARGIN,
				CC.COMPANYCAT AS KATEGORI,
				IR.ROW_PROJECT_ID,
				I.DEPARTMENT_ID,
				IR.LOT_NO,
				P.BARCOD
			<cfelseif attributes.report_type eq 20>
				PROM.PROM_ID AS PROM_ID,
				PROM.PROM_NO AS PROM_NO,
				PROM.PROM_HEAD AS PROM_HEAD,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 21>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE
			<cfelseif attributes.report_type eq 22>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				S.PRODUCT_ID,
				P.PRODUCT_NAME
			<cfelseif attributes.report_type eq 34 or attributes.report_type eq 35>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID
            <cfelseif attributes.report_type eq 39>
				SC.COUNTRY_ID,
				SC.COUNTRY_NAME,
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID
			<cfelseif attributes.report_type eq 36>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				CC.COMPANYCAT AS MUSTERI_TYPE,
				CC.COMPANYCAT_ID AS MUSTERI_TYPE_ID
			<cfelseif attributes.report_type eq 23>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				1 AS TYPE,
                S.STOCK_CODE,
            	IR.AMOUNT AS PRODUCT_STOCK
             <cfelseif attributes.report_type eq 40 or attributes.report_type eq 41>
				WP.POSITION_CODE AS WP_POSITION_CODE,
				IR.AMOUNT AS PRODUCT_STOCK, 
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				1 AS TYPE,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				(SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
				(SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
			<cfelseif attributes.report_type eq 24>
				IR.AMOUNT AS PRODUCT_STOCK,
				1 AS TYPE,
				C.TAXOFFICE,
			ISNULL(C.TAXNO,(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = C.COMPANY_ID AND COMP_PART.PARTNER_ID = C.MANAGER_PARTNER_ID )) AS TAXNO,
				
				I.INVOICE_ID
			<cfelseif attributes.report_type eq 25>
				IR.AMOUNT AS PRODUCT_STOCK, 
				I.SALE_EMP,
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				1 AS TYPE
			<cfelseif attributes.report_type eq 26>
				IR.AMOUNT AS PRODUCT_STOCK,
				ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
				CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
			<cfelseif attributes.report_type eq 27>
				IR.AMOUNT AS PRODUCT_STOCK,
				I.PARTNER_REFERENCE_CODE AS MEMBER_REFERENCE_CODE,
				C.NICKNAME AS MUSTERI,
				C.COMPANY_ID AS MUSTERI_ID,
				1 AS TYPE
			<cfelseif attributes.report_type eq 28>
				IR.AMOUNT AS PRODUCT_STOCK,
				IR.PRICE_CAT
			<cfelseif attributes.report_type eq 29>
				IR.AMOUNT AS PRODUCT_STOCK, 
				WP.POSITION_CODE AS WP_POSITION_CODE,
				IR.PRICE_CAT
			<cfelseif attributes.report_type eq 30>
				IR.AMOUNT AS PRODUCT_STOCK, 
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.BARCOD,
				IR.PRICE_CAT
			<cfelseif attributes.report_type eq 42>
				P.PRODUCT_CODE_2,
				IR.AMOUNT AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 31>
				IR.AMOUNT AS PRODUCT_STOCK,
				C.COUNTRY AS COUNTRY_ID
			<cfelseif attributes.report_type eq 38>
                P.PRODUCT_NAME,
                MONTH(I.INVOICE_DATE) AS INVOICE_DATE,
                I.INVOICE_ID,
                P.PRODUCT_ID,
                IR.AMOUNT AS PRODUCT_STOCK,
                IR.UNIT,
                PBM.MODEL_CODE,
                PBM.MODEL_NAME
			<cfelseif attributes.report_type eq 37>
              IR.AMOUNT AS PRODUCT_STOCK,
		  	  <cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
					CASE
						WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
					 ,CASE   
						WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
					,CASE    
						WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
					,CASE    
						WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
					,CASE    
						WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
					,CASE    
						WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
					,CASE    
						WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
					,CASE    
						WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
					,CASE    
						WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
					,CASE    
						WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
					,CASE    
						WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
					,CASE    
						WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
					,CASE    
						WHEN P.IS_COST = 1 THEN 13 END AS t_13
					,CASE    
						WHEN P.IS_SALES = 1 THEN 14 END AS t_14
					,CASE    
						WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
					,CASE    
						WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
				<cfelse>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
					CASE
						WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
					 </cfif>
					 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
					 CASE   
						WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
					 </cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
					CASE    
						WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
					CASE    
						WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
					CASE    
						WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
					CASE    
						WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
					CASE    
						WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
					CASE    
						WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
					CASE    
						WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
					CASE    
						WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
					CASE    
						WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
					CASE    
						WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
					CASE    
						WHEN P.IS_COST = 1 THEN 13 END AS t_13
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
					CASE    
						WHEN P.IS_SALES = 1 THEN 14 END AS t_14
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
					CASE    
						WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
					CASE    
						WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
					</cfif>
				</cfif>
            </cfif>
			<cfif attributes.report_type eq 37>
            	INTO ####sale_analyse_report_company_2_#session.ep.userid#
            </cfif>
            FROM
				INVOICE I
				LEFT JOIN  #dsn_alias#.COMPANY CO WITH (NOLOCK) ON CO.COMPANY_ID = I.COMPANY_ID
				LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = CO.COUNTRY,
				INVOICE_ROW IR,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					INVOICE_MONEY IM,
				</cfif>
				#dsn3_alias#.STOCKS S,
				<cfif listfind('1,2,3,30',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.COMPANY C,
				<cfelseif listfind('32',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT_CAT PC_2,				
					#dsn_alias#.COMPANY C,
				<cfelseif listfind('34',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT_CAT PC_2,				
					#dsn_alias#.WORKGROUP_EMP_PAR WP,
				<cfelseif listfind('35',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.WORKGROUP_EMP_PAR WP,
               <cfelseif listfind('39',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.WORKGROUP_EMP_PAR WP,                   
				<cfelseif listfind('36',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.WORKGROUP_EMP_PAR WP,
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CC,
				<cfelseif listfind('4,6,16,24,27,31,33',attributes.report_type)>
					#dsn_alias#.COMPANY C
					<cfif attributes.report_type eq 4>,<cfelse>LEFT JOIN #dsn_alias#.COMPANY_SECTOR_RELATION ON COMPANY_SECTOR_RELATION.COMPANY_ID = C.COMPANY_ID,</cfif>
				<cfelseif attributes.report_type eq 5>
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CC,
				<cfelseif attributes.report_type eq 7>
					#dsn_alias#.DEPARTMENT D,
					#dsn_alias#.BRANCH B,
				<cfelseif attributes.report_type eq 8>
					#dsn_alias#.EMPLOYEES E,
				<cfelseif attributes.report_type eq 9>
					#dsn3_alias#.PRODUCT_BRANDS PB,
				<cfelseif attributes.report_type eq 12>
					#dsn_alias#.SETUP_IMS_CODE SIC,
				<cfelseif attributes.report_type eq 17>
					#dsn_alias#.PRO_PROJECTS PR,
				<cfelseif attributes.report_type eq 19>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.COMPANY C,
					#dsn_alias#.COMPANY_CAT CC,
				<cfelseif attributes.report_type eq 18>
					#dsn_alias#.EMPLOYEE_POSITIONS EP,
				<cfelseif attributes.report_type eq 20>
					#dsn3_alias#.PROMOTIONS PROM,
				<cfelseif listfind('21,22',attributes.report_type)>
					#dsn_alias#.WORKGROUP_EMP_PAR WP,
				<cfelseif listfind('23,29',attributes.report_type)>
					#dsn_alias#.WORKGROUP_EMP_PAR WP,	
					#dsn_alias#.COMPANY C,
                <cfelseif listfind('40,41',attributes.report_type)>
                    #dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
                    #dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
                    #dsn_alias#.COMPANY C WITH (NOLOCK),
				<cfelseif attributes.report_type eq 25>
					#dsn_alias#.COMPANY C,
				<cfelseif attributes.report_type eq 38>
					#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM WITH (NOLOCK),
				</cfif>
				<cfif listfind('34,35,39,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and len(attributes.use_efatura)>
					#dsn_alias#.COMPANY C WITH (NOLOCK),
				</cfif>
				#dsn3_alias#.PRODUCT P
			WHERE
				<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 1>
					C.USE_EFATURA = 1 AND
					C.EFATURA_DATE <= I.INVOICE_DATE AND
				<cfelseif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 0>
					(C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE ) AND
				</cfif>
				I.IS_IPTAL = 0 AND
				I.NETTOTAL = 0 AND
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				<cfif attributes.is_prom eq 0>
					ISNULL(IR.IS_PROMOTION,0) <> 1 AND
				</cfif>
				<cfif attributes.is_other_money eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = IR.OTHER_MONEY AND
				<cfelseif attributes.is_money2 eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
				</cfif>
				<cfif isdefined("attributes.is_sale_product")>
					P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(I.COMPANY_ID IS NULL) OR
						(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				</cfif>
				<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
					I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					(
						(I.CONSUMER_ID IS NULL) 
						OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					) AND
				</cfif>
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND COMPANY_ID IS NOT NULL) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					P.BRAND_ID IN(#attributes.brand_id#) AND
				</cfif>
				<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
					P.SHORT_CODE_ID IN (#attributes.model_id#) AND
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					(
						(P.COMPANY_ID IS NULL) OR
						(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
					) AND
				</cfif>
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
					S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
				</cfif>
				<cfif len(attributes.city_id)>
					I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
					I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
					I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(attributes.process_type_)>
					I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69) AND 
				</cfif>
				<cfif len(attributes.price_catid)>
					IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				</cfif>
				<cfif len(attributes.department_id)>
					(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					) AND
				<cfelseif len(branch_dep_list)>
					I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
				</cfif>
				<cfif len(attributes.segment_id)>
					P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
				</cfif>
				<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
					<cfif attributes.report_type eq 3>
                        S.STOCK_ID IN (
                                            SELECT
                                                STOCK_ID
                                            FROM
                                                #dsn1_alias#.STOCKS_PROPERTY
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                    <cfelse>
                        P.PRODUCT_ID IN (
                                            SELECT
                                                PRODUCT_ID
                                            FROM
                                                #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                    </cfif>
				</cfif>
				<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and len(attributes.use_efatura)>
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				<cfif listfind('1,2,3,30',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				<cfelseif listfind('32',attributes.report_type)>
					PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
					(
						(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
						PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
						OR
						(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
						PC.HIERARCHY = PC_2.HIERARCHY)
					) AND		
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				<cfelseif listfind('34',attributes.report_type)>
					PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
					(
						(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
						PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
						OR
						(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
						PC.HIERARCHY = PC_2.HIERARCHY)
					) AND			
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND  
				<cfelseif listfind('35',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfelseif listfind('39',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND  
				<cfelseif listfind('36',attributes.report_type)>
					I.COMPANY_ID = C.COMPANY_ID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND  
				<cfelseif listfind('4,16,24,27,31,33',attributes.report_type)>
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				<cfelseif attributes.report_type eq 5>
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
				<cfelseif attributes.report_type eq 6>
					P.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(P.COMPANY_ID IS NULL) OR
							(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				<cfelseif attributes.report_type eq 7>
					<cfif x_show_order_branch_type eq 1>
						ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) = B.BRANCH_ID AND
					<cfelse>
						I.DEPARTMENT_ID = D.DEPARTMENT_ID AND
					</cfif>
					D.BRANCH_ID = B.BRANCH_ID AND
				<cfelseif attributes.report_type eq 8>
					E.EMPLOYEE_ID = I.SALE_EMP AND
				<cfelseif attributes.report_type eq 9>
					P.BRAND_ID = PB.BRAND_ID AND
				<cfelseif attributes.report_type eq 12>
					I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
				<cfelseif attributes.report_type eq 17>
					I.PROJECT_ID = PR.PROJECT_ID AND
				<cfelseif attributes.report_type eq 18>
					P.PRODUCT_MANAGER = EP.POSITION_CODE AND
				<cfelseif attributes.report_type eq 19>
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
				<cfelseif attributes.report_type eq 20>
						IR.PROM_ID = PROM.PROM_ID AND
				<cfelseif listfind('21,22',attributes.report_type)>
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				<cfelseif listfind('23,29',attributes.report_type)>
					C.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(C.COMPANY_ID IS NULL) OR
							(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfelseif listfind('40,41',attributes.report_type)>
                    PC.PRODUCT_CATID = P.PRODUCT_CATID AND
                    C.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(C.COMPANY_ID IS NULL) OR
							(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
                    I.COMPANY_ID = WP.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
                    WP.IS_MASTER = 1 AND
                    WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
				<cfelseif attributes.report_type eq 25>
					I.COMPANY_ID = C.COMPANY_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				<cfelseif attributes.report_type eq 38>
					P.SHORT_CODE_ID = PBM.MODEL_ID AND
					P.SHORT_CODE_ID IS NOT NULL AND
				</cfif>
					S.PRODUCT_ID = P.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID
				<cfif len(attributes.customer_value_id)>
					AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.zone_id)>
					AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							CAT.COMPANYCAT_ID IN (#kurumsal#)
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						)
					</cfif>
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							CAT.CONSCAT_ID IN (#bireysel#)                         
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.CONSUMER_ID IS NULL) OR
							(I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						)
					</cfif>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
					AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
					AND	I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY_SECTOR_RELATION WHERE SECTOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
					AND (
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						)
					</cfif>
				</cfif>
				<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
					AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
					AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				</cfif>
				<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
					AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
				</cfif>
		</cfquery>
	</cfif>
	<cfif attributes.report_type neq 37>
        <cfquery name="T1" dbtype="query">
                SELECT * FROM T1
            <cfif isdefined("attributes.is_zero_value")>
                UNION ALL
                    SELECT * FROM T1_0
            </cfif>
        </cfquery>
	<cfelse>
    	<cfquery name="T1" datasource="#dsn2#">
              SELECT * 
              INTO ####sale_analyse_report_company_#session.ep.userid#
              FROM
              (
              
                SELECT * FROM ####sale_analyse_report_company_1_#session.ep.userid#
            <cfif isdefined("attributes.is_zero_value")>
                UNION ALL
                SELECT * FROM ####sale_analyse_report_company_2_#session.ep.userid#
            </cfif>
              ) AS XXX
        </cfquery>
    </cfif>
	<cfif listfind('4,5,16,1,2,3,19,24,21,27,10,11,13,30,31,32,36,25',attributes.report_type) and len(attributes.process_type_select) and not listfind(attributes.process_type_select,670) and not listfind(attributes.process_type_,690)>
		<cfquery name="T2" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<cfif attributes.is_kdv eq 0>
						IR.AMOUNT*IR.PRICE GROSSTOTAL,
						IR.AMOUNT*IR.PRICE / IM.RATE2 GROSSTOTAL_DOVIZ,
						(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
						( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) / IM.RATE2 AS PRICE_DOVIZ,
					<cfelse>
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
						(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
						((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) / IM.RATE2 AS PRICE_DOVIZ,
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
							ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
							ISNULL((
								<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
									<cfif attributes.is_money2 eq 1>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
										</cfif>
									<cfelse>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
										</cfif>
									</cfif>
								<cfelse>
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
									<cfelse>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
									</cfif>
								</cfif>
								)+ISNULL(PROM_COST,0)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
								<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1 and attributes.is_other_money eq 1>
									AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) <cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1>/ <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
						,0) AS NET_KAR_DOVIZ,
						<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
					<cfelse>
						ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
						<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
					</cfif>
					<cfif attributes.is_other_money eq 1>
						IR.OTHER_MONEY,
					</cfif>
				<cfelse>
					<cfif attributes.is_kdv eq 0>
						IR.AMOUNT*IR.PRICE GROSSTOTAL,
						(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
					<cfelse>
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
						(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
					</cfif>
				</cfif>
				<cfif attributes.is_discount eq 1>
					((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / IM.RATE2 AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - 
						ISNULL((xxx.IN_COLUMN),0)
					),0) AS NET_KAR,
				<cfelse>
					ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
				</cfif>
					I.PROCESS_CAT,                    
            		(IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
				<cfif listfind('1,32',attributes.report_type)>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					IR.UNIT AS BIRIM,
					IR.UNIT2 AS BIRIM2,
					IR.AMOUNT AS PRODUCT_STOCK,
					(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 3>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					P.PRODUCT_NAME,
					S.STOCK_CODE,
					S.PROPERTY,
					S.BARCOD,
					S.STOCK_ID,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.STOCK_CODE_2,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 4>
					(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
					C.CONSUMER_ID AS MUSTERI_ID,
					<cfif x_show_work_city_info eq 1>C.WORK_CITY_ID<cfelse>C.HOME_CITY_ID</cfif> AS MUSTERI_CITY,
					0 AS TYPE,
					IR.AMOUNT AS PRODUCT_STOCK,
					C.TAX_OFFICE TAXOFFICE,
					C.TAX_NO TAXNO,
					C.MEMBER_CODE,
					I.INVOICE_ID,
					C.SALES_COUNTY,
                    I.ZONE_ID
				<cfelseif attributes.report_type eq 5>
					CC.CONSCAT AS MUSTERI_TYPE,
					CC.CONSCAT_ID  AS MUSTERI_TYPE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 36>
					CC.CONSCAT AS MUSTERI_TYPE,
					CC.CONSCAT_ID  AS MUSTERI_TYPE_ID,
					IR.AMOUNT AS PRODUCT_STOCK, 
					WP.POSITION_CODE AS WP_POSITION_CODE
				<cfelseif attributes.report_type eq 10>
					I.CUSTOMER_VALUE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 11>
					I.RESOURCE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 13>
					I.ZONE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 16>
					ISNULL(C.TAX_CITY_ID,C.HOME_CITY_ID) AS CITY,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 19>
					S.SHORT_CODE_ID,
					I.INVOICE_NUMBER,
					I.SERIAL_NUMBER,
					I.SERIAL_NO,
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.PURCHASE_SALES,
					I.PROJECT_ID,
					(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
					0 AS COMPANY_ID,
					'' AS OZEL_KOD_2,
					C.MEMBER_CODE AS UYE_NO,
					(SELECT TOP 1 ACCOUNT_CODE FROM #dsn_alias#.CONSUMER_PERIOD CP WHERE CP.CONSUMER_ID = C.CONSUMER_ID) ACCOUNT_CODE,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
                    (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
					(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
					C.CONSUMER_ID,
					0 AS EMPLOYEE_ID,
					I.INVOICE_DATE,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					S.STOCK_ID,
					P.PRODUCT_NAME,
					S.PROPERTY,
					S.STOCK_CODE,
					P.MANUFACT_CODE,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.BRAND_ID,
					P.MIN_MARGIN,
					IR.INVOICE_ROW_ID,
					IR.ROW_PROJECT_ID,
					ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0) PRICELESS_AMOUNT,
					(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
					IR.PRICE_CAT,
					IR.DUE_DATE,
					I.DEPARTMENT_ID,
					S.PRODUCT_CODE_2,
					<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
						ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
					<cfelse>
						'' ORDER_BRANCH_ID,
					</cfif>
					IR.PRICE PRICE_ROW,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
					<cfelse>
						IR.PRICE PRICE_ROW_OTHER,
					</cfif>
					IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
					IR.OTHER_MONEY OTHER_MONEY,
				<cfif attributes.is_kdv eq 1>
					(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
				<cfelse>
					IR.NETTOTAL NETTOTAL_ROW,
				</cfif>
					IR.DISCOUNT1,
					IR.DISCOUNT2,
					IR.DISCOUNT3,
					IR.DISCOUNT4,
					IR.DISCOUNT5,
					IR.DISCOUNT6,
					IR.DISCOUNT7,
					IR.DISCOUNT8,
					IR.DISCOUNT9,
					IR.DISCOUNT10,
					I.NOTE,
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL((xxx.COST_PRICE_OTHER),0) COST_PRICE_OTHER,
						ISNULL((xxx.PURCHASE_NET_MONEY),0) COST_PRICE_MONEY,
						ISNULL((xxx.COST_PRICE),0) COST_PRICE,
						ISNULL((xxx.COST_PRICE_2),0) COST_PRICE_2,
					<cfelse>
						IR.COST_PRICE COST_PRICE_OTHER,
						'#session.ep.money#' COST_PRICE_MONEY,
						IR.COST_PRICE,
						0 AS COST_PRICE_2,
					</cfif>
					IR.SPECT_VAR_NAME,
					(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
					IR.MARGIN,
					CSC.CONSCAT AS KATEGORI,
					IR.ROW_PROJECT_ID,
					I.DEPARTMENT_ID,
					IR.LOT_NO,
					P.BARCOD
				<cfelseif attributes.report_type eq 21>
					IR.AMOUNT AS PRODUCT_STOCK, 
					WP.POSITION_CODE AS WP_POSITION_CODE
				<cfelseif attributes.report_type eq 24>
					IR.AMOUNT AS PRODUCT_STOCK,
					0 AS TYPE,
					C.TAX_OFFICE TAXOFFICE,
					C.TAX_NO TAXNO,
					I.INVOICE_ID
				<cfelseif attributes.report_type eq 25>
					IR.AMOUNT AS PRODUCT_STOCK, 
					I.SALE_EMP,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
					C.CONSUMER_ID AS MUSTERI_ID,
					0 AS TYPE
				<cfelseif attributes.report_type eq 26>
					IR.AMOUNT AS PRODUCT_STOCK,
					ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
					CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
				<cfelseif attributes.report_type eq 27>
					IR.AMOUNT AS PRODUCT_STOCK,
					I.CONSUMER_REFERENCE_CODE AS MEMBER_REFERENCE_CODE,
					(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
					C.CONSUMER_ID AS MUSTERI_ID,
					0 AS TYPE
				<cfelseif attributes.report_type eq 28>
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 30>
					IR.AMOUNT AS PRODUCT_STOCK, 
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 42>
					P.PRODUCT_CODE_2,
					IR.AMOUNT AS PRODUCT_STOCK
                <cfelseif attributes.report_type eq 39>
                	SC.COUNTRY_ID,
					SC.COUNTRY_NAME,
					IR.AMOUNT AS PRODUCT_STOCK, 
					WP.POSITION_CODE AS WP_POSITION_CODE,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID
				<cfelseif attributes.report_type eq 31>
					IR.AMOUNT AS PRODUCT_STOCK,
					C.TAX_COUNTRY_ID AS COUNTRY_ID
				<cfelseif attributes.report_type eq 37>
					IR.AMOUNT AS PRODUCT_STOCK,
					<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
					CASE
						WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
					 ,CASE   
						WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
					,CASE    
						WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
					,CASE    
						WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
					,CASE    
						WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
					,CASE    
						WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
					,CASE    
						WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
					,CASE    
						WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
					,CASE    
						WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
					,CASE    
						WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
					,CASE    
						WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
					,CASE    
						WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
					,CASE    
						WHEN P.IS_COST = 1 THEN 13 END AS t_13
					,CASE    
						WHEN P.IS_SALES = 1 THEN 14 END AS t_14
					,CASE    
						WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
					,CASE    
						WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
				<cfelse>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
					CASE
						WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
					 </cfif>
					 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
					 ,CASE   
						WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
					 </cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
					,CASE    
						WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
					,CASE    
						WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
					,CASE    
						WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
					,CASE    
						WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
					,CASE    
						WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
					,CASE    
						WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
					,CASE    
						WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
					,CASE    
						WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
					,CASE    
						WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
					,CASE    
						WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
					,CASE    
						WHEN P.IS_COST = 1 THEN 13 END AS t_13
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
					,CASE    
						WHEN P.IS_SALES = 1 THEN 14 END AS t_14
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
					,CASE    
						WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
					</cfif>
					<cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
					,CASE    
						WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
					</cfif>
				</cfif>
				</cfif>
			<cfif attributes.report_type eq 37>
				INTO ####sale_analyse_report_consumer_1_#session.ep.userid#
			</cfif>
			FROM
				INVOICE I WITH (NOLOCK)            
                inner join 
				INVOICE_ROW IR WITH (NOLOCK) on I.INVOICE_ID = IR.INVOICE_ID 
				LEFT JOIN  #dsn_alias#.DEPARTMENT D WITH (NOLOCK) ON D.DEPARTMENT_ID = I.DEPARTMENT_ID
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					outer apply 
					(
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
						<cfelse>
							SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						</cfif>
						)+ISNULL(PROM_COST,0) AS IN_COLUMN 
						
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
						   ,(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
						<cfelse>
							,(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
						</cfif>
								) AS  COST_PRICE_OTHER
						   ,
						   PURCHASE_NET_MONEY
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							 ,(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
						<cfelse>
							,(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						</cfif>
						)+ISNULL(PROM_COST,0) AS COST_PRICE     
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							, (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
						<cfelse>
						   , (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
						</cfif>
						)as COST_PRICE_2
						FROM 
							#dsn3_alias#.PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
							</cfif>
							<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
								PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
							</cfif>
							PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
							<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
								AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
							</cfif>
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					) AS XXX
				</cfif>
				,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					INVOICE_MONEY IM WITH (NOLOCK),
				</cfif>
				#dsn3_alias#.STOCKS S WITH (NOLOCK),
				<cfif listfind('1,2,3,30',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
				<cfelseif listfind('32',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),				
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
				<cfelseif attributes.report_type eq 19>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
					#dsn_alias#.CONSUMER_CAT CSC WITH (NOLOCK),
				<cfelseif listfind('4,16,24,27,10,11,13,31',attributes.report_type)>
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
				<cfelseif attributes.report_type eq 5>
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
					#dsn_alias#.CONSUMER_CAT CC WITH (NOLOCK),
				<cfelseif attributes.report_type eq 21>
					#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
				<cfelseif attributes.report_type eq 25>
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
				<cfelseif attributes.report_type eq 36>
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
					#dsn_alias#.CONSUMER_CAT CC WITH (NOLOCK),
					#dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
				</cfif>
				<cfif listfind('21',attributes.report_type) and len(attributes.use_efatura)>
					#dsn_alias#.CONSUMER C WITH (NOLOCK),
				</cfif>
				#dsn3_alias#.PRODUCT P WITH (NOLOCK)
			WHERE
				<cfif len(attributes.branch_id)>
					D.BRANCH_ID IN (#attributes.branch_id#) AND
				</cfif>
				<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type)and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 1>
					C.USE_EFATURA = 1 AND
					C.EFATURA_DATE <= I.INVOICE_DATE AND
				<cfelseif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 0>
					(C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE ) AND
				</cfif>
				I.IS_IPTAL = 0 AND
				I.NETTOTAL > 0 AND
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
					P.IS_PURCHASE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
					P.IS_INVENTORY = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
					P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
					P.IS_TERAZI = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
					P.IS_PURCHASE = 0 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
					P.IS_PRODUCTION = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
					P.IS_SERIAL_NO = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
					P.IS_KARMA = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
					P.IS_INTERNET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
					P.IS_PROTOTYPE = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
					P.IS_ZERO_STOCK = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
					P.IS_EXTRANET = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
					P.IS_COST = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
					P.IS_SALES = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
					P.IS_QUALITY = 1 AND
				<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
					P.IS_INVENTORY = 1 AND
				</cfif>
				<cfif attributes.is_prom eq 0>
					ISNULL(IR.IS_PROMOTION,0) <> 1 AND
				</cfif>
				<cfif attributes.is_other_money eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = IR.OTHER_MONEY AND
				<cfelseif attributes.is_money2 eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
				</cfif>
				<cfif isdefined("attributes.is_sale_product")>
					P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					(
						(I.CONSUMER_ID IS NULL) 
						OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
					) AND
				</cfif>
				</cfif>
				<cfif isdefined('attributes.employee_id2') and len(trim(attributes.company)) and len(attributes.employee_id2)>
					I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id2#"> AND
				</cfif>
				<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
					I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					P.BRAND_ID IN(#attributes.brand_id#) AND
				</cfif>
				<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
					P.SHORT_CODE_ID IN (#attributes.model_id#) AND
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(P.COMPANY_ID IS NULL) OR
							(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
					S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
				</cfif>
				<cfif len(attributes.price_catid)>
					IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				</cfif>
				<cfif len(attributes.city_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(attributes.process_type_)>
					I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69)AND
				</cfif>
				<cfif len(attributes.department_id)>
					(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					) AND
				<cfelseif len(branch_dep_list)>
					I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
				</cfif>
				<cfif listfind('21',attributes.report_type) and len(attributes.use_efatura)>
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(attributes.segment_id)>
					P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
				</cfif>
				<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
					<cfif attributes.report_type eq 3>
                        S.STOCK_ID IN (
                                            SELECT
                                                STOCK_ID
                                            FROM
                                                #dsn1_alias#.STOCKS_PROPERTY
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                    <cfelse>
						P.PRODUCT_ID IN (
										SELECT
											PRODUCT_ID
										FROM
											#dsn1_alias#.PRODUCT_DT_PROPERTIES
										WHERE
											PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
											<cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
												AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
											</cfif>
											
									) AND
                	</cfif>
				</cfif>
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				<cfif listfind('1,2,3,30',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				<cfelseif listfind('32',attributes.report_type)>
					PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
					((CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
					PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
					OR
					(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
					PC.HIERARCHY = PC_2.HIERARCHY)
					) AND		
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				<cfelseif listfind('4,16,24,27,10,11,13,31',attributes.report_type)>
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				<cfelseif attributes.report_type eq 5>	
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
				<cfelseif attributes.report_type eq 36>	
					I.CONSUMER_ID = C.CONSUMER_ID AND
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
					I.CONSUMER_ID = WP.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				<cfelseif attributes.report_type eq 19>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
					CSC.CONSCAT_ID = C.CONSUMER_CAT_ID AND
				<cfelseif attributes.report_type eq 21>
					I.CONSUMER_ID = WP.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
					WP.IS_MASTER = 1 AND
					WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				<cfelseif attributes.report_type eq 25>
					I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
					S.PRODUCT_ID = P.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID
				<cfif len(attributes.customer_value_id)>
					AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.zone_id)>
					AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
				AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>
					I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							CAT.COMPANYCAT_ID IN (#kurumsal#)
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
							(
								(I.COMPANY_ID IS NULL) OR
								(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
							)
						</cfif>
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> 
					I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							CAT.CONSCAT_ID IN (#bireysel#)                                 
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
							(
								(I.CONSUMER_ID IS NULL) OR
								(I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
							)
						</cfif>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
					AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
					AND	I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
					AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
					AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				</cfif>
				<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
					AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
				</cfif>
		</cfquery>
		<cfif isdefined("attributes.is_zero_value")>
			<cfquery name="T2_0" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				SELECT
					IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<cfif attributes.is_kdv eq 0>
							IR.AMOUNT*IR.PRICE GROSSTOTAL,
							IR.AMOUNT*IR.PRICE / IM.RATE2 GROSSTOTAL_DOVIZ,
							(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
							( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) / IM.RATE2 AS PRICE_DOVIZ,
						<cfelse>
							IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
							IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
							(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
							((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) / IM.RATE2 AS PRICE_DOVIZ,
						</cfif>
						<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
								ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
								ISNULL((
									<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
										<cfif attributes.is_money2 eq 1>
											<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
												SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
											<cfelse>
												SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
											</cfif>
										<cfelse>
											<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
												SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
											<cfelse>
												SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
											</cfif>
										</cfif>
									<cfelse>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
										</cfif>
									</cfif>
									)+ISNULL(PROM_COST,0)
								FROM 
									#dsn3_alias#.PRODUCT_COST PRODUCT_COST
								WHERE 
									PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
									</cfif>
									<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
										PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
									</cfif>
									PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
										AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
									</cfif>
									<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1 and attributes.is_other_money eq 1>
										AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
									</cfif>
								ORDER BY
									PRODUCT_COST.START_DATE DESC,
									PRODUCT_COST.PRODUCT_COST_ID DESC,
									PRODUCT_COST.RECORD_DATE DESC,
									PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
								),0) <cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1>/ <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
							,0) AS NET_KAR_DOVIZ,
							<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
						<cfelse>
							ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
							<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
						</cfif>
						<cfif attributes.is_other_money eq 1>
							IR.OTHER_MONEY,
						</cfif>
					<cfelse>
						<cfif attributes.is_kdv eq 0>
							IR.AMOUNT*IR.PRICE GROSSTOTAL,
							(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
						<cfelse>
							IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
							(1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO(((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
						</cfif>
					</cfif>
					<cfif attributes.is_discount eq 1>
						((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS DISCOUNT,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / IM.RATE2 AS DISCOUNT_DOVIZ,
						</cfif>
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - 
							ISNULL((xxx.IN_COLUMN),0)
						),0) AS NET_KAR,
					<cfelse>
						ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
					</cfif>
						I.PROCESS_CAT,
						(IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
					<cfif listfind('1,32',attributes.report_type)>
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
                        IR.UNIT AS BIRIM,
                        IR.UNIT2 AS BIRIM2,
						IR.AMOUNT AS PRODUCT_STOCK,
                        (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
					<cfelseif attributes.report_type eq 2>
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
						S.PRODUCT_ID,
						P.PRODUCT_NAME,
						P.PRODUCT_CODE,
						P.BARCOD,
						IR.AMOUNT AS PRODUCT_STOCK,
						IR.UNIT AS BIRIM,
						P.MIN_MARGIN,
						S.BRAND_ID,
						S.SHORT_CODE_ID,
                        (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                        (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                        (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
                        (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
					<cfelseif attributes.report_type eq 3>
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
						P.PRODUCT_NAME,
						S.STOCK_CODE,
						S.PROPERTY,
						S.BARCOD,
						S.STOCK_ID,
						IR.AMOUNT AS PRODUCT_STOCK,
						IR.UNIT AS BIRIM,
						P.MIN_MARGIN,
						S.STOCK_CODE_2,
						S.BRAND_ID,
						S.SHORT_CODE_ID,
                        (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                        (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                        (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
					<cfelseif attributes.report_type eq 4>
						(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
						C.CONSUMER_ID AS MUSTERI_ID,
						<cfif x_show_work_city_info eq 1>C.WORK_CITY_ID<cfelse>C.HOME_CITY_ID</cfif> AS MUSTERI_CITY,
						0 AS TYPE,
						IR.AMOUNT AS PRODUCT_STOCK,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						C.MEMBER_CODE,
						I.INVOICE_ID,
						C.SALES_COUNTY,
                        I.ZONE_ID
					<cfelseif attributes.report_type eq 5>
						CC.CONSCAT AS MUSTERI_TYPE,
						CC.CONSCAT_ID  AS MUSTERI_TYPE_ID,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 36>
						CC.CONSCAT AS MUSTERI_TYPE,
						CC.CONSCAT_ID  AS MUSTERI_TYPE_ID,
						IR.AMOUNT AS PRODUCT_STOCK, 
						WP.POSITION_CODE AS WP_POSITION_CODE
					<cfelseif attributes.report_type eq 10>
						I.CUSTOMER_VALUE_ID,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 11>
						I.RESOURCE_ID,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 13>
						I.ZONE_ID,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 16>
						ISNULL(C.TAX_CITY_ID,C.HOME_CITY_ID) AS CITY,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 19>
						S.SHORT_CODE_ID,
						I.INVOICE_NUMBER,
						I.SERIAL_NUMBER,
						I.SERIAL_NO,
						I.INVOICE_CAT,
						I.INVOICE_ID,
						I.PURCHASE_SALES,
						I.PROJECT_ID,
						(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
						0 AS COMPANY_ID,
						'' AS OZEL_KOD_2,
						C.MEMBER_CODE AS UYE_NO,
						(SELECT TOP 1 ACCOUNT_CODE FROM #dsn_alias#.CONSUMER_PERIOD CP WHERE CP.CONSUMER_ID = C.CONSUMER_ID) ACCOUNT_CODE,
                        (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                        (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
                        (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
						(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
						C.CONSUMER_ID,
						0 AS EMPLOYEE_ID,
						I.INVOICE_DATE,
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
						S.PRODUCT_ID,
						S.STOCK_ID,
						P.PRODUCT_NAME,
						S.PROPERTY,
						S.STOCK_CODE,
						P.MANUFACT_CODE,
						IR.AMOUNT AS PRODUCT_STOCK,
						IR.UNIT AS BIRIM,
						P.BRAND_ID,
						P.MIN_MARGIN,
						IR.INVOICE_ROW_ID,
						IR.ROW_PROJECT_ID,
						ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0) PRICELESS_AMOUNT,
						(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
						IR.PRICE_CAT,
						IR.DUE_DATE,
						I.DEPARTMENT_ID,
						S.PRODUCT_CODE_2,
						<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
							ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
						<cfelse>
							'' ORDER_BRANCH_ID,
						</cfif>
						IR.PRICE PRICE_ROW,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
						<cfelse>
							IR.PRICE PRICE_ROW_OTHER,
						</cfif>
						IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
						IR.OTHER_MONEY OTHER_MONEY,
					<cfif attributes.is_kdv eq 1>
						(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
					<cfelse>
						IR.NETTOTAL NETTOTAL_ROW,
					</cfif>
						IR.DISCOUNT1,
						IR.DISCOUNT2,
						IR.DISCOUNT3,
						IR.DISCOUNT4,
						IR.DISCOUNT5,
						IR.DISCOUNT6,
						IR.DISCOUNT7,
						IR.DISCOUNT8,
						IR.DISCOUNT9,
						IR.DISCOUNT10,
						I.NOTE,
						<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
							ISNULL((xxx.COST_PRICE_OTHER),0) COST_PRICE_OTHER,
							ISNULL((xxx.PURCHASE_NET_MONEY),0) COST_PRICE_MONEY,
							ISNULL((xxx.COST_PRICE),0) COST_PRICE,
							ISNULL((xxx.COST_PRICE_2),0) COST_PRICE_2,
						<cfelse>
							IR.COST_PRICE COST_PRICE_OTHER,
							'#session.ep.money#' COST_PRICE_MONEY,
							IR.COST_PRICE,
							0 AS COST_PRICE_2,
						</cfif>
						IR.SPECT_VAR_NAME,
						(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
						IR.MARGIN,
						CSC.CONSCAT AS KATEGORI,
						IR.ROW_PROJECT_ID,
						I.DEPARTMENT_ID,
						IR.LOT_NO,
						P.BARCOD
					<cfelseif attributes.report_type eq 21>
						IR.AMOUNT AS PRODUCT_STOCK, 
						WP.POSITION_CODE AS WP_POSITION_CODE
					<cfelseif attributes.report_type eq 24>
						IR.AMOUNT AS PRODUCT_STOCK,
						0 AS TYPE,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						I.INVOICE_ID
					<cfelseif attributes.report_type eq 25>
						IR.AMOUNT AS PRODUCT_STOCK, 
						I.SALE_EMP,
						S.PRODUCT_ID,
						P.PRODUCT_NAME,
						(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
						C.CONSUMER_ID AS MUSTERI_ID,
						0 AS TYPE
					<cfelseif attributes.report_type eq 26>
						IR.AMOUNT AS PRODUCT_STOCK,
						ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
						CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
					<cfelseif attributes.report_type eq 27>
						IR.AMOUNT AS PRODUCT_STOCK,
						I.CONSUMER_REFERENCE_CODE AS MEMBER_REFERENCE_CODE,
						(C.CONSUMER_NAME+ ' ' + C.CONSUMER_SURNAME) AS MUSTERI,
						C.CONSUMER_ID AS MUSTERI_ID,
						0 AS TYPE
					<cfelseif attributes.report_type eq 28>
						IR.AMOUNT AS PRODUCT_STOCK,
						IR.PRICE_CAT
					<cfelseif attributes.report_type eq 30>
						IR.AMOUNT AS PRODUCT_STOCK, 
						S.PRODUCT_ID,
						P.PRODUCT_NAME,
						P.PRODUCT_CODE,
						P.BARCOD,
						IR.PRICE_CAT
					<cfelseif attributes.report_type eq 42>
						P.PRODUCT_CODE_2,
						IR.AMOUNT AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 31>
						IR.AMOUNT AS PRODUCT_STOCK,
						C.TAX_COUNTRY_ID AS COUNTRY_ID
					<cfelseif attributes.report_type eq 37>
						IR.AMOUNT AS PRODUCT_STOCK,
						<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
						CASE
							WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
						 ,CASE   
							WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
						,CASE    
							WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
						,CASE    
							WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
						,CASE    
							WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
						,CASE    
							WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
						,CASE    
							WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
						,CASE    
							WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
						,CASE    
							WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
						,CASE    
							WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
						,CASE    
							WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
						,CASE    
							WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
						,CASE    
							WHEN P.IS_COST = 1 THEN 13 END AS t_13
						,CASE    
							WHEN P.IS_SALES = 1 THEN 14 END AS t_14
						,CASE    
							WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
						,CASE    
							WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
					<cfelse>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
						CASE
							WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
						 </cfif>
						 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
						 ,CASE   
							WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
						 </cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
						,CASE    
							WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
						,CASE    
							WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
						,CASE    
							WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
						,CASE    
							WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
						,CASE    
							WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
						,CASE    
							WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
						,CASE    
							WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
						,CASE    
							WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
						,CASE    
							WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
						,CASE    
							WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
						,CASE    
							WHEN P.IS_COST = 1 THEN 13 END AS t_13
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
						,CASE    
							WHEN P.IS_SALES = 1 THEN 14 END AS t_14
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
						,CASE    
							WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
						</cfif>
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
						,CASE    
							WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
						</cfif>
					</cfif>
					</cfif>
				<cfif attributes.report_type eq 37>
					INTO ####sale_analyse_report_consumer_2_#session.ep.userid#
				</cfif>
					FROM
						INVOICE I inner join 
						INVOICE_ROW IR on  I.INVOICE_ID = IR.INVOICE_ID
						LEFT JOIN  #dsn_alias#.DEPARTMENT D WITH (NOLOCK) ON D.DEPARTMENT_ID = I.DEPARTMENT_ID
						<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
							outer apply 
							(
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
								<cfelse>
									SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
								</cfif>
								)+ISNULL(PROM_COST,0) AS IN_COLUMN 
								
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
								   ,(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
								<cfelse>
									,(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
								</cfif>
										) AS  COST_PRICE_OTHER
								   ,
								   PURCHASE_NET_MONEY
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									 ,(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
								<cfelse>
									,(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
								</cfif>
								)+ISNULL(PROM_COST,0) AS COST_PRICE     
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									, (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
								<cfelse>
								   , (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
								</cfif>
								)as COST_PRICE_2
								FROM 
									#dsn3_alias#.PRODUCT_COST PRODUCT_COST
								WHERE 
									PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
									</cfif>
									<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
										PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
									</cfif>
									PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
										AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
									</cfif>
								ORDER BY
									PRODUCT_COST.START_DATE DESC,
									PRODUCT_COST.PRODUCT_COST_ID DESC,
									PRODUCT_COST.RECORD_DATE DESC,
									PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							) AS XXX
						</cfif>
						,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							INVOICE_MONEY IM,
						</cfif>
						#dsn3_alias#.STOCKS S,
						<cfif listfind('1,2,3,30',attributes.report_type)>
							#dsn3_alias#.PRODUCT_CAT PC,
							#dsn_alias#.CONSUMER C,
						<cfelseif listfind('32',attributes.report_type)>
							#dsn3_alias#.PRODUCT_CAT PC,
							#dsn3_alias#.PRODUCT_CAT PC_2,				
							#dsn_alias#.CONSUMER C,
						<cfelseif attributes.report_type eq 19>
							#dsn3_alias#.PRODUCT_CAT PC,
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CSC,
						<cfelseif listfind('4,16,24,27,10,11,13,31',attributes.report_type)>
							#dsn_alias#.CONSUMER C,
						<cfelseif attributes.report_type eq 5>
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CC,
						<cfelseif attributes.report_type eq 25>
							#dsn_alias#.CONSUMER C WITH (NOLOCK),
						<cfelseif attributes.report_type eq 36>
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CC,
							#dsn_alias#.WORKGROUP_EMP_PAR WP,
						<cfelseif attributes.report_type eq 21>
							#dsn_alias#.WORKGROUP_EMP_PAR WP,
						</cfif>
						<cfif listfind('21',attributes.report_type) and len(attributes.use_efatura)>
							#dsn_alias#.CONSUMER C WITH (NOLOCK),
						</cfif>
						#dsn3_alias#.PRODUCT P
					WHERE
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="yes">) AND
						</cfif>
						<cfif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 1>
							C.USE_EFATURA = 1 AND
							C.EFATURA_DATE <= I.INVOICE_DATE AND
						<cfelseif listfind('34,35,7,8,9,12,17,18,20,21,22,38',attributes.report_type) and isdefined('attributes.use_efatura') and len(attributes.use_efatura) and attributes.use_efatura eq 0>
							(C.USE_EFATURA = 0 OR C.EFATURA_DATE > I.INVOICE_DATE ) AND
						</cfif>
						I.IS_IPTAL = 0 AND
						I.NETTOTAL = 0 AND
						<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
							P.IS_PURCHASE = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
							P.IS_INVENTORY = 0 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
							P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
							P.IS_TERAZI = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
							P.IS_PURCHASE = 0 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
							P.IS_PRODUCTION = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
							P.IS_SERIAL_NO = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
							P.IS_KARMA = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
							P.IS_INTERNET = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
							P.IS_PROTOTYPE = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
							P.IS_ZERO_STOCK = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
							P.IS_EXTRANET = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
							P.IS_COST = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
							P.IS_SALES = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
							P.IS_QUALITY = 1 AND
						<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
							P.IS_INVENTORY = 1 AND
						</cfif>
						<cfif attributes.is_prom eq 0>
							ISNULL(IR.IS_PROMOTION,0) <> 1 AND
						</cfif>
						<cfif attributes.is_other_money eq 1>
							IM.ACTION_ID = I.INVOICE_ID AND
							IM.MONEY_TYPE = IR.OTHER_MONEY AND
						<cfelseif attributes.is_money2 eq 1>
							IM.ACTION_ID = I.INVOICE_ID AND
							IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
						</cfif>
						<cfif isdefined("attributes.is_sale_product")>
							P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
						</cfif>
						<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
							IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
						</cfif>
						<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
							I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
						</cfif>
						<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
							P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
						</cfif>
						<cfif len(trim(attributes.company)) and len(attributes.company_id)>
							I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
								(
									(I.COMPANY_ID IS NULL) OR
									(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
							I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif isdefined('attributes.employee_id2') and len(trim(attributes.company)) and len(attributes.employee_id2)>
							I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id2#"> AND
						</cfif>
						<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
							I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
						</cfif>
						<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
							I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL) AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
							P.BRAND_ID IN(#attributes.brand_id#) AND
						</cfif>
						<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
							P.SHORT_CODE_ID IN (#attributes.model_id#) AND
						</cfif>
						<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
							P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
								(
									(P.COMPANY_ID IS NULL) OR
									(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
							S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
						</cfif>
						<cfif len(attributes.price_catid)>
							IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
						</cfif>
						<cfif len(attributes.city_id)>
							<cfif x_show_work_city_info eq 1>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
							<cfelse>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
							</cfif>
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
							<cfif x_show_work_city_info eq 1>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
							<cfelse>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
							</cfif>
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
							<cfif x_show_work_city_info eq 1>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
							<cfelse>
								I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
							</cfif>
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif len(attributes.process_type_)>
							I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69)AND
						</cfif>
						<cfif len(attributes.department_id)>
						(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
								(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
								<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
						) AND
						<cfelseif len(branch_dep_list)>
							I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
						</cfif>
						<cfif listfind('21',attributes.report_type) and len(attributes.use_efatura)>
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif len(attributes.segment_id)>
							P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
						</cfif>
						<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
							<cfif attributes.report_type eq 3>
                                S.STOCK_ID IN (
                                                    SELECT
                                                        STOCK_ID
                                                    FROM
                                                        #dsn1_alias#.STOCKS_PROPERTY
                                                    WHERE
                                                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                        <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                            AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                        </cfif>
                                                        
                                                ) AND
                            <cfelse>
                                P.PRODUCT_ID IN (
                                                    SELECT
                                                        PRODUCT_ID
                                                    FROM
                                                        #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                                    WHERE
                                                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                        <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                            AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                        </cfif>
                                                        
                                                ) AND
                        	</cfif>
						</cfif>
						I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
						I.INVOICE_ID = IR.INVOICE_ID AND
						<cfif listfind('1,2,3,30',attributes.report_type)>
							PC.PRODUCT_CATID = P.PRODUCT_CATID AND
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						<cfelseif listfind('32',attributes.report_type)>
							PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
							(
								(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
								PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
								OR
								(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
								PC.HIERARCHY = PC_2.HIERARCHY)
							) AND			
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						<cfelseif listfind('4,16,24,27,10,11,13,31',attributes.report_type)>
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						<cfelseif attributes.report_type eq 5>	
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
							C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
						<cfelseif attributes.report_type eq 25>
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						<cfelseif attributes.report_type eq 36>	
							I.CONSUMER_ID = C.CONSUMER_ID AND
							C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
							I.CONSUMER_ID = WP.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
							WP.IS_MASTER = 1 AND
							WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						<cfelseif attributes.report_type eq 19>
							PC.PRODUCT_CATID = P.PRODUCT_CATID AND
							I.CONSUMER_ID = C.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
							C.CONSUMER_CAT_ID = CSC.CONSCAT_ID AND
						<cfelseif attributes.report_type eq 21>
							I.CONSUMER_ID = WP.CONSUMER_ID AND
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
							WP.IS_MASTER = 1 AND
							WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						</cfif>
							S.PRODUCT_ID = P.PRODUCT_ID AND
							IR.STOCK_ID = S.STOCK_ID
						<cfif len(attributes.customer_value_id)>
							AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
						</cfif>
						<cfif len(attributes.resource_id)>
							AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
						</cfif>
						<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
							AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
						</cfif>
						<cfif len(attributes.zone_id)>
							AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
						</cfif>
						<cfif isdefined("kurumsal") and listlen(kurumsal)>
							AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>
							I.COMPANY_ID IN
								(
								SELECT 
									C.COMPANY_ID 
								FROM 
									#dsn_alias#.COMPANY C,
									#dsn_alias#.COMPANY_CAT CAT 
								WHERE 
									C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
									CAT.COMPANYCAT_ID IN (#kurumsal#)
								)
							AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
									(
										(I.COMPANY_ID IS NULL) OR
										(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
									)
								</cfif>
						</cfif>
						<cfif isdefined("bireysel") and listlen(bireysel)>
							<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> 
							I.CONSUMER_ID IN
								(
								SELECT 
									C.CONSUMER_ID 
								FROM 
									#dsn_alias#.CONSUMER C,
									#dsn_alias#.CONSUMER_CAT CAT 
								WHERE 
									C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
									CAT.CONSCAT_ID IN (#bireysel#) 
								)
							AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
									(
										(I.CONSUMER_ID IS NULL) OR
										(I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
									)
								</cfif>
							<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
						</cfif>
						<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
							AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
						</cfif>
						<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
							AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
						</cfif>
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
							AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
						</cfif>
						<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
							AND	I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
							<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
								(
									(I.CONSUMER_ID IS NULL) 
									OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
								) AND
							</cfif>
						</cfif>
						<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
							AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
						<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
							AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
						</cfif>
						<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
							AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
						</cfif>
				</cfquery>
		</cfif>		
		<cfif attributes.report_type neq 37>
            <cfquery name="T2" dbtype="query">
                    SELECT * FROM T2
                <cfif isdefined("attributes.is_zero_value")>
                    UNION ALL
                        SELECT * FROM T2_0
                </cfif>
            </cfquery>
        <cfelse>
        	<cfquery name="T2" datasource="#dsn2#">
                  SELECT * 
                  INTO ####sale_analyse_report_consumer_#session.ep.userid#
                  FROM
                  (
                  
                    SELECT * FROM ####sale_analyse_report_consumer_1_#session.ep.userid#
                <cfif isdefined("attributes.is_zero_value")>
                    UNION ALL
                    SELECT * FROM ####sale_analyse_report_consumer_2_#session.ep.userid#
                </cfif>
                  ) AS XXX
        	</cfquery>		
        </cfif>
	</cfif>
	<cfif listfind('1,32,2,3,4,19,10,11,13,26,28,30',attributes.report_type) and len(attributes.process_type_) and not listfind(attributes.process_type_select,670) and not listfind(attributes.process_type_select,690)>
		<cfquery name="T3" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			SELECT
				IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<cfif attributes.is_kdv eq 0>
						IR.AMOUNT*IR.PRICE GROSSTOTAL,
						(IR.AMOUNT*IR.PRICE) / IM.RATE2 GROSSTOTAL_DOVIZ,
						(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
						( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) / IM.RATE2 AS PRICE_DOVIZ,
					<cfelse>
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
						(1- (I.SA_DISCOUNT)/((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
						((1- (I.SA_DISCOUNT)/((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0))) / IM.RATE2 AS PRICE_DOVIZ,
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
							ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
							ISNULL((
								<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
									<cfif attributes.is_money2 eq 1>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
										</cfif>
									<cfelse>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
										</cfif>
									</cfif>
								<cfelse>
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
									<cfelse>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
									</cfif>
								</cfif>
								)+ISNULL(PROM_COST,0)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
								<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1 and attributes.is_other_money eq 1>
									AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) <cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1>/ <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
						,0) AS NET_KAR_DOVIZ,
						<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
					<cfelse>
						ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
						<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
					</cfif>
					<cfif attributes.is_other_money eq 1>
						IR.OTHER_MONEY,
					</cfif>
				<cfelse>
					<cfif attributes.is_kdv eq 0>
						IR.AMOUNT*IR.PRICE GROSSTOTAL,
						(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL AS PRICE,
					<cfelse>
						IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
						(1- (I.SA_DISCOUNT)/((I.NETTOTAL)-I.TAXTOTAL+I.SA_DISCOUNT)) * (IR.NETTOTAL) + (((((1- (I.SA_DISCOUNT)/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1))*( IR.NETTOTAL)*IR.TAX)/100)*ISNULL(I.TEVKIFAT_ORAN/100,1))) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0)) AS PRICE,
					</cfif>
				</cfif>
				<cfif attributes.is_discount eq 1>
					((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / IM.RATE2 AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - 
						ISNULL((XXX.IN_COLS),0)
					),0) AS NET_KAR,
				<cfelse>
					ISNULL( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
				</cfif>
					I.PROCESS_CAT,                    
            		(IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
				<cfif listfind('1,32',attributes.report_type)>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					IR.AMOUNT AS PRODUCT_STOCK,
                    IR.UNIT AS BIRIM,
                    IR.UNIT2 AS BIRIM2,
                    (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 3>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					P.PRODUCT_NAME,
					S.STOCK_CODE,
					S.PROPERTY,
					S.BARCOD,
					S.STOCK_ID,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.STOCK_CODE_2,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 4>
					(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI,
					EMP.EMPLOYEE_ID AS MUSTERI_ID,
					0 AS MUSTERI_CITY,
					-1 AS TYPE,
					IR.AMOUNT AS PRODUCT_STOCK,
					'' TAXOFFICE,
					'' TAXNO,
					EMP.MEMBER_CODE,
					I.INVOICE_ID,
					0 SALES_COUNTY,
                    I.ZONE_ID
				<cfelseif attributes.report_type eq 10>
					I.CUSTOMER_VALUE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 11>
					I.RESOURCE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 13>
					I.ZONE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 19>
					S.SHORT_CODE_ID,
					I.INVOICE_NUMBER,
					I.SERIAL_NUMBER,
					I.SERIAL_NO,
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.PURCHASE_SALES,
					I.PROJECT_ID,
					(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI,
                    (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
					0 AS COMPANY_ID,
					'' AS UYE_NO,
					'' AS ACCOUNT_CODE,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
					(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
					0 AS CONSUMER_ID,
					EMP.EMPLOYEE_ID,
					I.INVOICE_DATE,
					'' AS OZEL_KOD_2,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					S.STOCK_ID,
					P.PRODUCT_NAME,
					S.PROPERTY,
					S.STOCK_CODE,
					P.MANUFACT_CODE,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.BRAND_ID,
					P.MIN_MARGIN,
					IR.INVOICE_ROW_ID,
					ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0) PRICELESS_AMOUNT,
					(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
					IR.PRICE_CAT,
					IR.DUE_DATE,
					IR.ROW_PROJECT_ID,
					I.DEPARTMENT_ID,
					IR.PRICE PRICE_ROW,
                    S.PRODUCT_CODE_2,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
					<cfelse>
						IR.PRICE PRICE_ROW_OTHER,
					</cfif>
					IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
					IR.OTHER_MONEY OTHER_MONEY,
					<cfif attributes.is_kdv eq 1>
						(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
					<cfelse>
						IR.NETTOTAL NETTOTAL_ROW,
					</cfif>
					IR.DISCOUNT1,
					IR.DISCOUNT2,
					IR.DISCOUNT3,
					IR.DISCOUNT4,
					IR.DISCOUNT5,
					IR.DISCOUNT6,
					IR.DISCOUNT7,
					IR.DISCOUNT8,
					IR.DISCOUNT9,
					IR.DISCOUNT10,
					I.NOTE,
					<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
						ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
					<cfelse>
						'' ORDER_BRANCH_ID,
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL((XXX.COST_PRICE_OTHER),0) COST_PRICE_OTHER,
						ISNULL((XXX.PURCHASE_NET_MONEY),0) COST_PRICE_MONEY,
						ISNULL((xxx.COST_PRICE),0) COST_PRICE,
						ISNULL((xxx.COST_PRICE_2),0) COST_PRICE_2,
					<cfelse>
						IR.COST_PRICE COST_PRICE_OTHER,
						'#session.ep.money#' COST_PRICE_MONEY,
						IR.COST_PRICE,
						0 AS COST_PRICE_2,
					</cfif>
					IR.SPECT_VAR_NAME,
					(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
					IR.MARGIN,
					'' AS KATEGORI,
					IR.ROW_PROJECT_ID,
					I.DEPARTMENT_ID,
					IR.LOT_NO,
					P.BARCOD
				<cfelseif attributes.report_type eq 26>
					IR.AMOUNT AS PRODUCT_STOCK,
					ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
					CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
				<cfelseif attributes.report_type eq 28>
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 30>
					IR.AMOUNT AS PRODUCT_STOCK, 
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 42>
					P.PRODUCT_CODE_2,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 37>
                	IR.AMOUNT AS PRODUCT_STOCK,
					<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                        CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5

                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                    <cfelse>
                    	<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         </cfif>
                         <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                         </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
						</cfif>
					</cfif>
                </cfif>
            <cfif attributes.report_type eq 37>
                INTO ####sale_analyse_report_employee_1_#session.ep.userid#
            </cfif>
            FROM
				INVOICE I WITH (NOLOCK)inner join 
				INVOICE_ROW IR WITH (NOLOCK) on I.INVOICE_ID = IR.INVOICE_ID
				LEFT JOIN  #dsn_alias#.DEPARTMENT D WITH (NOLOCK) ON D.DEPARTMENT_ID = I.DEPARTMENT_ID
                <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					outer apply 
					(
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                        <cfelse>
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                        </cfif>
                        )+ISNULL(PROM_COST,0) AS IN_COLS
                        <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                            ,(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
                        <cfelse>
                            ,(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
                        </cfif>
                        ) AS  COST_PRICE_OTHER
                        ,PURCHASE_NET_MONEY
                        
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                            ,(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                        <cfelse>
                            ,(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                        </cfif>
                        )+ISNULL(PROM_COST,0) as COST_PRICE
                      	<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							, (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
						<cfelse>
						   , (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
						</cfif>
                        ) as COST_PRICE_2
                        
                        FROM 
                            #dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
                        WHERE 
                            PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                            <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                            </cfif>
                            <cfif session.ep.our_company_info.is_stock_based_cost eq 1>
                                PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
                            </cfif>
                            PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
                            <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                                AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
                                AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
                            </cfif>
                        ORDER BY
                            PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.PRODUCT_COST_ID DESC,
                            PRODUCT_COST.RECORD_DATE DESC,
                            PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                   ) AS XXX
                   </cfif>
                ,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					INVOICE_MONEY IM WITH (NOLOCK),
				</cfif>
				#dsn3_alias#.STOCKS S WITH (NOLOCK),
				<cfif listfind('1,2,3,30',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn_alias#.EMPLOYEES EMP WITH (NOLOCK),
				<cfelseif listfind('32',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn3_alias#.PRODUCT_CAT PC_2 WITH (NOLOCK),				
					#dsn_alias#.EMPLOYEES EMP WITH (NOLOCK),
				<cfelseif attributes.report_type eq 19>
					#dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
					#dsn_alias#.EMPLOYEES EMP WITH (NOLOCK),
				<cfelseif listfind('4,10,11,13,26,28',attributes.report_type)>
					#dsn_alias#.EMPLOYEES EMP WITH (NOLOCK),
				</cfif>
				#dsn3_alias#.PRODUCT P WITH (NOLOCK)
			WHERE
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					D.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="yes">) AND
				</cfif>
				I.IS_IPTAL = 0 AND
				I.NETTOTAL > 0 AND
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				<cfif attributes.is_prom eq 0>
					ISNULL(IR.IS_PROMOTION,0) <> 1 AND
				</cfif>
				<cfif attributes.is_other_money eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = IR.OTHER_MONEY AND
				<cfelseif attributes.is_money2 eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
				</cfif>
				<cfif isdefined("attributes.is_sale_product")>
					P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.employee_id2') and len(trim(attributes.company)) and len(attributes.employee_id2)>
					I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id2#"> AND
				</cfif>
				<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
					I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					P.BRAND_ID IN(#attributes.brand_id#) AND
				</cfif>
				<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
					P.SHORT_CODE_ID IN (#attributes.model_id#) AND
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(P.COMPANY_ID IS NULL) OR
							(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
                    S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
                </cfif>
				<cfif len(attributes.price_catid)>
					IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				</cfif>
				<cfif len(attributes.city_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(attributes.process_type_)>
					I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69)AND
				</cfif>
				<cfif len(attributes.department_id)>
				(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
				) AND
				<cfelseif len(branch_dep_list)>
					I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
				</cfif>
				<cfif len(attributes.segment_id)>
					P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
				</cfif>
			   	<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
					<cfif attributes.report_type eq 3>
                        S.STOCK_ID IN (
                                            SELECT
                                                STOCK_ID
                                            FROM
                                                #dsn1_alias#.STOCKS_PROPERTY
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                    <cfelse>
                    	P.PRODUCT_ID IN (
                                        SELECT
                                            PRODUCT_ID
                                        FROM
                                            #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                        WHERE
                                            PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                            <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                            </cfif>
                                            
                                    ) AND
                	</cfif>
                </cfif>

				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				<cfif listfind('1,2,3,30',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif listfind('32',attributes.report_type)>
					PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
					(
						(CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
						PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
						OR
						(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
						PC.HIERARCHY = PC_2.HIERARCHY)
					) AND		
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif listfind('4,10,11,13,26,28',attributes.report_type)>
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif attributes.report_type eq 19>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				</cfif>
					S.PRODUCT_ID = P.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID
				<cfif len(attributes.customer_value_id)>
					AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.zone_id)>
					AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
				AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>
					I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
		                    CAT.COMPANYCAT_ID IN (#kurumsal#)
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
							(
								(I.COMPANY_ID IS NULL) OR
								(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
							)
						</cfif>
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> 
					I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
		                    CAT.CONSCAT_ID IN (#bireysel#)
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.CONSUMER_ID IS NULL) OR
							(I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
					AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
					AND	I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
					AND	(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						)
					</cfif>	
				</cfif>
				<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
					AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
					AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				</cfif>
				<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
					AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
				</cfif>
		</cfquery>
		<cfif isdefined("attributes.is_zero_value")>
			<cfquery name="T3_0" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				SELECT
					IR.AMOUNT*IR.PRICE GROSSTOTAL_NEW,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<cfif attributes.is_kdv eq 0>
							IR.AMOUNT*IR.PRICE GROSSTOTAL,
							IR.AMOUNT*IR.PRICE / IM.RATE2 GROSSTOTAL_DOVIZ,
							0 AS PRICE,
							0 PRICE_DOVIZ,
						<cfelse>
							IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 GROSSTOTAL,
							IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2 GROSSTOTAL_DOVIZ,
							0 AS PRICE,
							0 AS PRICE_DOVIZ,
						</cfif>
						<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
							ISNULL(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif>) - 
							ISNULL((
									<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
										</cfif>
									<cfelse>
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
										<cfelse>
											SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
										</cfif>
									</cfif>
									)+ISNULL(PROM_COST,0)
								FROM 
									#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
								WHERE 
									PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
									</cfif>
									<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
										PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
									</cfif>
									PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
										AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
									</cfif>
									<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet eq 1>
										AND PRODUCT_COST.MONEY = IR.OTHER_MONEY
									</cfif>
								ORDER BY
									PRODUCT_COST.START_DATE DESC,
									PRODUCT_COST.PRODUCT_COST_ID DESC,
									PRODUCT_COST.RECORD_DATE DESC,
									PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
								),0)<cfif isdefined("x_net_kar_doviz_maliyet") and x_net_kar_doviz_maliyet neq 1> / <cfif attributes.is_money2 eq 1>IM.RATE2<cfelse>(SELECT (RATE2/RATE1) FROM INVOICE_MONEY WHERE ACTION_ID=I.INVOICE_ID AND MONEY_TYPE=IR.OTHER_MONEY)</cfif></cfif>
							,0) AS NET_KAR_DOVIZ,
							<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
						<cfelse>
							ISNULL(  0 - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) / IM.RATE2 AS NET_KAR_DOVIZ,
							<cfif attributes.is_money2 eq 1>'#session.ep.money2#'<cfelse>IR.OTHER_MONEY</cfif> NET_KAR_DOVIZ_MONEY,
						</cfif>
						<cfif attributes.is_other_money eq 1>
							IR.OTHER_MONEY,
						</cfif>
					<cfelse>
						<cfif attributes.is_kdv eq 0>
							0 GROSSTOTAL,
							0 AS PRICE,
						<cfelse>
							0 GROSSTOTAL,
							0 AS PRICE,
						</cfif>
					</cfif>
					<cfif attributes.is_discount eq 1>
						(IR.AMOUNT*IR.PRICE) AS DISCOUNT,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							(IR.AMOUNT*IR.PRICE) / IM.RATE2 AS DISCOUNT_DOVIZ,
						</cfif>
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL((0- 
							ISNULL((
									<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
									<cfelse>
										SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
									</cfif>
									)+ISNULL(PROM_COST,0)
									FROM 
										#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
									WHERE 
										PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
										</cfif>
										<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
											PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
										</cfif>
										PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
										<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
											AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
											AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
										</cfif>
									ORDER BY
										PRODUCT_COST.START_DATE DESC,
										PRODUCT_COST.PRODUCT_COST_ID DESC,
										PRODUCT_COST.RECORD_DATE DESC,
										PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
									),0)
						),0) AS NET_KAR,
					<cfelse>
						ISNULL(0 - (IR.AMOUNT*(IR.COST_PRICE+EXTRA_COST)+ISNULL(PROM_COST,0)),0) AS NET_KAR,
					</cfif>
					I.PROCESS_CAT,
					(IR.AMOUNT/(SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID)) AS AMOUNT2,
				<cfif listfind('1,32',attributes.report_type)>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					IR.AMOUNT AS PRODUCT_STOCK,
                    IR.UNIT AS BIRIM,
                    IR.UNIT2 AS BIRIM2,
                    (SELECT TOP 1 PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_1,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 3>
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					P.PRODUCT_NAME,
					S.STOCK_CODE,
					S.PROPERTY,
					S.BARCOD,
					S.STOCK_ID,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.MIN_MARGIN,
					S.STOCK_CODE_2,
					S.BRAND_ID,
					S.SHORT_CODE_ID,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
                    (SELECT TOP 1 PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
				<cfelseif attributes.report_type eq 4>
					(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI,
					EMP.EMPLOYEE_ID AS MUSTERI_ID,
					0 AS MUSTERI_CITY,
					-1 AS TYPE,
					IR.AMOUNT AS PRODUCT_STOCK,
					'' TAXOFFICE,
					'' TAXNO,
					EMP.MEMBER_CODE,
					I.INVOICE_ID,
					0 SALES_COUNTY,
                    I.ZONE_ID
				<cfelseif attributes.report_type eq 10>
					I.CUSTOMER_VALUE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 11>
					I.RESOURCE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 13>
					I.ZONE_ID,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 19>
					S.SHORT_CODE_ID,
					I.INVOICE_NUMBER,
					I.SERIAL_NUMBER,
					I.SERIAL_NO,
					I.INVOICE_CAT,
					I.INVOICE_ID,
					I.PURCHASE_SALES,
					I.PROJECT_ID,
					(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI,
                    (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
					0 AS COMPANY_ID,
					'' AS UYE_NO,
					'' AS ACCOUNT_CODE,
                    (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
                    (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
					(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
					0 AS CONSUMER_ID,
					EMP.EMPLOYEE_ID,
					I.INVOICE_DATE,
					'' AS OZEL_KOD_2,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					S.STOCK_ID,
					P.PRODUCT_NAME,
					S.PROPERTY,
					S.STOCK_CODE,
					P.MANUFACT_CODE,
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.UNIT AS BIRIM,
					P.BRAND_ID,
					P.MIN_MARGIN,
					IR.INVOICE_ROW_ID,
					ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0) PRICELESS_AMOUNT,
					(SELECT COUNT(INVOICE_ROW_ID) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID) ROW_COUNT,
					IR.PRICE_CAT,
					IR.DUE_DATE,
					IR.ROW_PROJECT_ID,
					I.DEPARTMENT_ID,
					IR.PRICE PRICE_ROW,
                    S.PRODUCT_CODE_2,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
					<cfelse>
						IR.PRICE PRICE_ROW_OTHER,
					</cfif>
					IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
					IR.OTHER_MONEY OTHER_MONEY,
					<cfif attributes.is_kdv eq 1>
						(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
					<cfelse>
						IR.NETTOTAL NETTOTAL_ROW,
					</cfif>
					IR.DISCOUNT1,
					IR.DISCOUNT2,
					IR.DISCOUNT3,
					IR.DISCOUNT4,
					IR.DISCOUNT5,
					IR.DISCOUNT6,
					IR.DISCOUNT7,
					IR.DISCOUNT8,
					IR.DISCOUNT9,
					IR.DISCOUNT10,
					I.NOTE,
					<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
						ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) ORDER_BRANCH_ID,
					<cfelse>
						'' ORDER_BRANCH_ID,
					</cfif>
					<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
						ISNULL((
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 (PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION
								<cfelse>
									SELECT TOP 1 (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST
								</cfif>
								)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) COST_PRICE_OTHER,
						ISNULL((
								SELECT TOP 1 PURCHASE_NET_MONEY
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) COST_PRICE_MONEY,
						ISNULL((
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 (PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
								<cfelse>
									SELECT TOP 1 (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
								</cfif>
								)+ISNULL(PROM_COST,0)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) COST_PRICE,
						ISNULL((
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									SELECT TOP 1 (PURCHASE_NET_SYSTEM_2_LOCATION+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
								<cfelse>
									SELECT TOP 1 (PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2
								</cfif>
								)
							FROM 
								#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
							WHERE 
								PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
								</cfif>
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									PRODUCT_COST.STOCK_ID = IR.STOCK_ID AND
								</cfif>
								PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
								<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
									AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
									AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
								</cfif>
							ORDER BY
								PRODUCT_COST.START_DATE DESC,
								PRODUCT_COST.PRODUCT_COST_ID DESC,
								PRODUCT_COST.RECORD_DATE DESC,
								PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
							),0) COST_PRICE_2,
					<cfelse>
						IR.COST_PRICE COST_PRICE_OTHER,
						'#session.ep.money#' COST_PRICE_MONEY,
						IR.COST_PRICE,
						0 AS COST_PRICE_2,
					</cfif>
					IR.SPECT_VAR_NAME,
					(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
					IR.MARGIN,
					'' AS KATEGORI,
					IR.ROW_PROJECT_ID,
					I.DEPARTMENT_ID,
					IR.LOT_NO,
					P.BARCOD
				<cfelseif attributes.report_type eq 26>
					IR.AMOUNT AS PRODUCT_STOCK,
					ISNULL(I.SALES_PARTNER_ID,I.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
					CASE WHEN I.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
				<cfelseif attributes.report_type eq 28>
					IR.AMOUNT AS PRODUCT_STOCK,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 30>
					IR.AMOUNT AS PRODUCT_STOCK, 
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BARCOD,
					IR.PRICE_CAT
				<cfelseif attributes.report_type eq 42>
					P.PRODUCT_CODE_2,
					IR.AMOUNT AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 37>
                	IR.AMOUNT AS PRODUCT_STOCK,
					<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                        CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                    <cfelse>
                    	<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         </cfif>
                         <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                         </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
						</cfif>
					</cfif>
                </cfif>
            <cfif attributes.report_type eq 37>
                INTO ####sale_analyse_report_employee_2_#session.ep.userid#
            </cfif>
			FROM
				INVOICE I,
				INVOICE_ROW IR,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					INVOICE_MONEY IM,
				</cfif>
				#dsn3_alias#.STOCKS S,
				<cfif listfind('1,2,3,30',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.EMPLOYEES EMP,
				<cfelseif listfind('32',attributes.report_type)>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT_CAT PC_2,				
					#dsn_alias#.EMPLOYEES EMP,
				<cfelseif attributes.report_type eq 19>
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn_alias#.EMPLOYEES EMP,
				<cfelseif listfind('4,10,11,13,26,28',attributes.report_type)>
					#dsn_alias#.EMPLOYEES EMP,
				</cfif>
				#dsn3_alias#.PRODUCT P
			WHERE
				I.IS_IPTAL = 0 AND
				I.NETTOTAL = 0 AND
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				<cfif attributes.is_prom eq 0>
					ISNULL(IR.IS_PROMOTION,0) <> 1 AND
				</cfif>
				<cfif attributes.is_other_money eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = IR.OTHER_MONEY AND
				<cfelseif attributes.is_money2 eq 1>
					IM.ACTION_ID = I.INVOICE_ID AND
					IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND
				</cfif>
				<cfif isdefined("attributes.is_sale_product")>
					P.IS_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					IR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND	
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
				</cfif>
				<cfif len(trim(attributes.company)) and len(attributes.company_id)>
					I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(I.COMPANY_ID IS NULL) OR
							(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(trim(attributes.company)) and len(attributes.consumer_id)>
					I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.employee_id2') and len(trim(attributes.company)) and len(attributes.employee_id2)>
					I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id2#"> AND
				</cfif>
				<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
					I.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#"> AND
				</cfif>
				<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
					I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND CONSUMER_ID IS NOT NULL) AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					P.BRAND_ID IN(#attributes.brand_id#) AND
				</cfif>
				<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
					P.SHORT_CODE_ID IN (#attributes.model_id#) AND
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
						(
							(P.COMPANY_ID IS NULL) OR
							(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
                    S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
                </cfif>
				<cfif len(attributes.price_catid)>
					IR.PRICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
				</cfif>
				<cfif len(attributes.city_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
					<cfif x_show_work_city_info eq 1>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.WORK_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					<cfelse>
						I.CONSUMER_ID IN(SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER CON WHERE CON.HOME_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
					</cfif>
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif len(attributes.process_type_)>
					I.PROCESS_CAT IN (#attributes.process_type_#) AND I.INVOICE_CAT NOT IN(67,69)AND
				</cfif>
				<cfif len(attributes.department_id)>
				(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
				) AND
				<cfelseif len(branch_dep_list)>
					I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
				</cfif>
				<cfif len(attributes.segment_id)>
					P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
				</cfif>
				<cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
					<cfif attributes.report_type eq 3>
                        S.STOCK_ID IN (
                                            SELECT
                                                STOCK_ID
                                            FROM
                                                #dsn1_alias#.STOCKS_PROPERTY
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                    <cfelse>
                        P.PRODUCT_ID IN (
                                            SELECT
                                                PRODUCT_ID
                                            FROM
                                                #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                            WHERE
                                                PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                                <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                                    AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                                </cfif>
                                                
                                        ) AND
                	</cfif>
                </cfif>
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				<cfif listfind('1,2,3,30',attributes.report_type)>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif listfind('32',attributes.report_type)>
					PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
					((CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
					PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
					OR
					(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
					PC.HIERARCHY = PC_2.HIERARCHY)
					) AND		
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif listfind('4,10,11,13,26,28',attributes.report_type)>
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				<cfelseif attributes.report_type eq 19>
					PC.PRODUCT_CATID = P.PRODUCT_CATID AND
					I.EMPLOYEE_ID = EMP.EMPLOYEE_ID AND
				</cfif>
					S.PRODUCT_ID = P.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID
				<cfif len(attributes.customer_value_id)>
					AND I.CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					AND I.RESOURCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
					AND I.IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.zone_id)>
					AND I.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
				</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>
						I.COMPANY_ID IN
							(
							SELECT 
								C.COMPANY_ID 
							FROM 
								#dsn_alias#.COMPANY C,
								#dsn_alias#.COMPANY_CAT CAT 
							WHERE 
								C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
                   				CAT.COMPANYCAT_ID IN (#kurumsal#)
							)
						AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
								(
									(I.COMPANY_ID IS NULL) OR
									(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
								)
							</cfif>
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> 
					I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							CAT.CONSCAT_ID IN (#bireysel#)
						)
					AND <cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
							(
								(I.CONSUMER_ID IS NULL) OR
								(I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
							)
						</cfif>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif isdefined('attributes.project_id') and len(attributes.project_head)>
					AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
					AND IR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
					AND	I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
					<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>			
						(
							(I.CONSUMER_ID IS NULL) 
							OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
						) AND
					</cfif>
				</cfif>
				<cfif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'partner'>
					AND	'.'+I.PARTNER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				<cfelseif isdefined('attributes.ref_member_id') and len(attributes.ref_member) and ref_member_type is 'consumer'>
					AND	'.'+ I.CONSUMER_REFERENCE_CODE+'.' LIKE '%.#attributes.ref_member_id#.%'
				</cfif>
				<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
					AND(IR.PRICE >= (SELECT TOP 1 PP.PRICE FROM #dsn3_alias#.PRICE_HISTORY PP WHERE PP.PRICE_CATID = IR.PRICE_CAT AND PP.PRODUCT_ID = IR.PRODUCT_ID AND I.INVOICE_DATE>=PP.STARTDATE AND I.INVOICE_DATE <= ISNULL(PP.FINISHDATE,I.INVOICE_DATE)))
				</cfif>
			</cfquery>
		</cfif>
		<cfif attributes.report_type neq 37>
            <cfquery name="T3" dbtype="query">
                    SELECT * FROM T3
                <cfif isdefined("attributes.is_zero_value")>
                    UNION ALL
                        SELECT * FROM T3_0
                </cfif>
            </cfquery>
        <cfelse>
        	<cfquery name="T2" datasource="#dsn2#">
                  SELECT * 
                  INTO ####sale_analyse_report_employee_#session.ep.userid#
                  FROM
                  (
                  
                    SELECT * FROM ####sale_analyse_report_employee_1_#session.ep.userid#
                <cfif isdefined("attributes.is_zero_value")>
                    UNION ALL
                    SELECT * FROM ####sale_analyse_report_employee_2_#session.ep.userid#
                </cfif>
                  ) AS XXX
        	</cfquery>
        </cfif>
	</cfif>
	<!--- Burdan sonra queryleri birleştirm vs yapılıyor --->
    <cfif attributes.report_type neq 37>
		<cfquery name="get_total_purchase_1" dbtype="query">
		<cfif len(all_process_type)>
		SELECT
			SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(PRICE) AS PRICE,
				SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
				SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
				NET_KAR_DOVIZ_MONEY,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
			<cfelse>
				SUM(GROSSTOTAL) GROSSTOTAL,

				SUM(PRICE) AS PRICE,
			</cfif>
			SUM(NET_KAR) AS NET_KAR,
			<cfif attributes.is_discount eq 1>
				SUM(DISCOUNT) AS DISCOUNT,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
				</cfif>
			</cfif>
            SUM(AMOUNT2) AS AMOUNT2,
			#col#<!--- Yukarda tanımlanan select bloğu --->
		FROM
			T1	
		WHERE
			PROCESS_CAT IN (#all_process_type#)
			<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
				AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
			</cfif>
            <cfif attributes.report_type eq 33>
            <cfif len(attributes.SECTOR_CAT_ID)>
				AND SECTOR_CAT_ID =#attributes.SECTOR_CAT_ID#
			</cfif></cfif>
		GROUP BY
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				NET_KAR_DOVIZ_MONEY,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
			</cfif>
			#col2#<!--- Yukarda tanımlanan group by bloğu --->
			<cfif isdefined('attributes.negative_product')>
			HAVING 
				SUM(NET_KAR) < 0
			</cfif>
		</cfif>
		<cfif listlen(return_process_type) and len(all_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(return_process_type)>
			SELECT
				-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					-1*SUM(PRICE) AS PRICE,
					-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					-1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(PRICE) AS PRICE,
				</cfif>
				-1*SUM(NET_KAR) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					-1*SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                -1*SUM(AMOUNT2) AS AMOUNT2,
				-1*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T1	
			WHERE
				PROCESS_CAT IN (#return_process_type#)	
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(give_process_type)>
			SELECT
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
				SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T1	
			WHERE
				PROCESS_CAT IN (#give_process_type#)	
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(take_process_type)>
			SELECT
				-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					-1*SUM(PRICE) AS PRICE,
					-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					-1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(PRICE) AS PRICE,
				</cfif>
				-1*SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					-1*SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T1	
			WHERE
				PROCESS_CAT IN (#take_process_type#)	
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
	<cfif listfind('4,5,16,1,2,3,19,24,21,27,30,31,32,36,25',attributes.report_type)>
		UNION ALL
		<cfif len(all_process_type)>
			SELECT
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
				SUM(NET_KAR) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                SUM(AMOUNT2) AS AMOUNT2,
				#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM 
				T2
			WHERE
				PROCESS_CAT IN (#all_process_type#)
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
			<cfif isdefined('attributes.negative_product')>
			HAVING 
				SUM(NET_KAR) < 0
			</cfif>
		</cfif>
		<cfif listlen(return_process_type) and len(all_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(return_process_type)>
				SELECT
					-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						-1*SUM(GROSSTOTAL) GROSSTOTAL,
						-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
						-1*SUM(PRICE) AS PRICE,
						-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
						-1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
						NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
					<cfelse>
						-1*SUM(GROSSTOTAL) GROSSTOTAL,
						-1*SUM(PRICE) AS PRICE,
					</cfif>
					-1*SUM(NET_KAR) AS NET_KAR,
					<cfif attributes.is_discount eq 1>
						-1*SUM(DISCOUNT) AS DISCOUNT,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
						</cfif>
					</cfif>
                    <cfif attributes.report_type neq 1>-1*</cfif>SUM(AMOUNT2) AS AMOUNT2,
					<cfif attributes.report_type neq 1>-1*</cfif>#col#<!--- Yukarda tanımlanan select bloğu --->
				FROM 
					T2
				WHERE
					PROCESS_CAT IN (#return_process_type#)	
					<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
						AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
					</cfif>
				GROUP BY
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						NET_KAR_DOVIZ_MONEY,
						<cfif attributes.is_other_money eq 1>
							OTHER_MONEY,
						</cfif>
					</cfif>
					#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(give_process_type)>
			SELECT
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
				SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T2	
			WHERE
				PROCESS_CAT IN (#give_process_type#)	
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(take_process_type)>
			SELECT
				-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					-1*SUM(PRICE) AS PRICE,
					-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					-1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(PRICE) AS PRICE,
				</cfif>
				-1*SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					-1*SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T2
			WHERE
				PROCESS_CAT IN (#take_process_type#)
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>	
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
	</cfif>
	<cfif listfind('1,32,2,3,4,19,10,11,13,26,28,30',attributes.report_type)>
		UNION ALL
		<cfif len(all_process_type)>
			SELECT
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
				SUM(NET_KAR) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                SUM(AMOUNT2) AS AMOUNT2,
				#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM 
				T3
			WHERE
				PROCESS_CAT IN (#all_process_type#)
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
			<cfif isdefined('attributes.negative_product')>
			HAVING 
				SUM(NET_KAR) < 0
			</cfif>
		</cfif>
		<cfif listlen(return_process_type) and len(all_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(return_process_type)>
				SELECT
					-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						-1*SUM(GROSSTOTAL) GROSSTOTAL,
						-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
						-1*SUM(PRICE) AS PRICE,
						-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
						-1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
						NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
					<cfelse>
						-1*SUM(GROSSTOTAL) GROSSTOTAL,
						-1*SUM(PRICE) AS PRICE,
					</cfif>
					-1*SUM(NET_KAR) AS NET_KAR,
					<cfif attributes.is_discount eq 1>
						-1*SUM(DISCOUNT) AS DISCOUNT,
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
						</cfif>
					</cfif>
                    <cfif attributes.report_type neq 1>-1*</cfif>SUM(AMOUNT2) AS AMOUNT2,
					<cfif attributes.report_type neq 1>-1*</cfif>#col#<!--- Yukarda tanımlanan select bloğu --->
				FROM 
					T3
				WHERE
					PROCESS_CAT IN (#return_process_type#)	
					<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
						AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
					</cfif>
				GROUP BY
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						NET_KAR_DOVIZ_MONEY,
						<cfif attributes.is_other_money eq 1>
							OTHER_MONEY,
						</cfif>
					</cfif>
					#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(give_process_type)>
			SELECT
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE) AS PRICE,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) AS PRICE,
				</cfif>
				SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T3	
			WHERE
				PROCESS_CAT IN (#give_process_type#)	
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
		<cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
			UNION ALL
		</cfif>	
		<cfif listlen(take_process_type)>
			SELECT
				-1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					-1*SUM(PRICE) AS PRICE,
					-1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					-1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				<cfelse>
					-1*SUM(GROSSTOTAL) GROSSTOTAL,
					-1*SUM(PRICE) AS PRICE,
				</cfif>
				-1*SUM(PRICE) AS NET_KAR,
				<cfif attributes.is_discount eq 1>
					-1*SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					-1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
                0*SUM(AMOUNT2) AS AMOUNT2,
				0*#col#<!--- Yukarda tanımlanan select bloğu --->
			FROM
				T3
			WHERE
				PROCESS_CAT IN (#take_process_type#)
				<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
					AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
				</cfif>	
			GROUP BY
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
					<cfif attributes.is_other_money eq 1>
						OTHER_MONEY,
					</cfif>
				</cfif>
				#col2#<!--- Yukarda tanımlamam group by bloğu --->
				<cfif isdefined('attributes.negative_product')>
				HAVING 
					SUM(NET_KAR) < 0
				</cfif>
		</cfif>
	</cfif>
	</cfquery>
    <cfelse>
    	<cfquery name="get_total_purchase_1" datasource="#dsn2#">
            SELECT * 
            <cfif attributes.report_type eq 37>
            INTO ####get_total_purchase_1_#session.ep.userid#
            </cfif>
            FROM (
            <cfif len(all_process_type)>
            SELECT
                SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                    SUM(GROSSTOTAL) GROSSTOTAL,
                    SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                    SUM(PRICE) AS PRICE,
                    SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                    SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                    NET_KAR_DOVIZ_MONEY,
                    <cfif attributes.is_other_money eq 1>
                        OTHER_MONEY,
                    </cfif>
                <cfelse>
                    SUM(GROSSTOTAL) GROSSTOTAL,
                    SUM(PRICE) AS PRICE,
                </cfif>
                SUM(NET_KAR) AS NET_KAR,
                <cfif attributes.is_discount eq 1>
                    SUM(DISCOUNT) AS DISCOUNT,
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                    SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                    </cfif>
                </cfif>
                #col#<!--- Yukarda tanımlanan select bloğu --->
            FROM
                <cfif attributes.report_type neq 37>
                T1	
                <cfelse>
                ####sale_analyse_report_company_#session.ep.userid#
                </cfif>
            WHERE
                PROCESS_CAT IN (#all_process_type#)
                <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                    AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                </cfif>
            GROUP BY
                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                    NET_KAR_DOVIZ_MONEY,
                    <cfif attributes.is_other_money eq 1>
                        OTHER_MONEY,
                    </cfif>
                </cfif>
                #col2#<!--- Yukarda tanımlanan group by bloğu --->
                <cfif isdefined('attributes.negative_product')>
                HAVING 
                    SUM(NET_KAR) < 0
                </cfif>
            </cfif>
            <cfif listlen(return_process_type) and len(all_process_type)>
                UNION ALL
            </cfif>	
            <cfif listlen(return_process_type)>
                SELECT
                    -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        -1*SUM(GROSSTOTAL) GROSSTOTAL,
                        -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                        -1*SUM(PRICE) AS PRICE,
                        -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                        -1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    <cfelse>
                        -1*SUM(GROSSTOTAL) GROSSTOTAL,
                        -1*SUM(PRICE) AS PRICE,
                    </cfif>
                    -1*SUM(NET_KAR) AS NET_KAR,
                    <cfif attributes.is_discount eq 1>
                        -1*SUM(DISCOUNT) AS DISCOUNT,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                        </cfif>
                    </cfif>
                    -1*#col#<!--- Yukarda tanımlanan select bloğu --->
                FROM
                    <cfif attributes.report_type neq 37>
                    T1	
                    <cfelse>
                    ####sale_analyse_report_company_#session.ep.userid#
                    </cfif>	
                WHERE
                    PROCESS_CAT IN (#return_process_type#)	
                    <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                        AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                    </cfif>
                GROUP BY
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    </cfif>
                    #col2#<!--- Yukarda tanımlamam group by bloğu --->
                    <cfif isdefined('attributes.negative_product')>
                    HAVING 
                        SUM(NET_KAR) < 0
                    </cfif>
            </cfif>
            <cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
                UNION ALL
            </cfif>	
            <cfif listlen(give_process_type)>
                SELECT
                    SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        SUM(GROSSTOTAL) GROSSTOTAL,
                        SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                        SUM(PRICE) AS PRICE,
                        SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                        SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    <cfelse>
                        SUM(GROSSTOTAL) GROSSTOTAL,
                        SUM(PRICE) AS PRICE,
                    </cfif>
                    SUM(PRICE) AS NET_KAR,
                    <cfif attributes.is_discount eq 1>
                        SUM(DISCOUNT) AS DISCOUNT,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                        </cfif>
                    </cfif>
                   
                    0*#col#<!--- Yukarda tanımlanan select bloğu --->
                  
                FROM
                    <cfif attributes.report_type neq 37>
                    T1	
                    <cfelse>
                    ####sale_analyse_report_company_#session.ep.userid#
                    </cfif>		
                WHERE
                    PROCESS_CAT IN (#give_process_type#)	
                    <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                        AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                    </cfif>
                GROUP BY
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    </cfif>
                    #col2#<!--- Yukarda tanımlamam group by bloğu --->
                    <cfif isdefined('attributes.negative_product')>
                    HAVING 
                        SUM(NET_KAR) < 0
                    </cfif>
            </cfif>
            <cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
                UNION ALL
            </cfif>	
            <cfif listlen(take_process_type)>
                SELECT
                    -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        -1*SUM(GROSSTOTAL) GROSSTOTAL,
                        -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                        -1*SUM(PRICE) AS PRICE,
                        -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                        -1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    <cfelse>
                        -1*SUM(GROSSTOTAL) GROSSTOTAL,
                        -1*SUM(PRICE) AS PRICE,
                    </cfif>
                    -1*SUM(PRICE) AS NET_KAR,
                    <cfif attributes.is_discount eq 1>
                        -1*SUM(DISCOUNT) AS DISCOUNT,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                        </cfif>
                    </cfif>
                    0*#col#<!--- Yukarda tanımlanan select bloğu --->
                FROM
                    <cfif attributes.report_type neq 37>
                    T1	
                    <cfelse>
                    ####sale_analyse_report_company_#session.ep.userid#
                    </cfif>	
                WHERE
                    PROCESS_CAT IN (#take_process_type#)	
                    <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                        AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                    </cfif>
                GROUP BY
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                    </cfif>
                    #col2#<!--- Yukarda tanımlamam group by bloğu --->
                    <cfif isdefined('attributes.negative_product')>
                    HAVING 
                        SUM(NET_KAR) < 0
                    </cfif>
            </cfif>
			<cfif listfind('4,5,16,1,2,3,19,24,21,27,30,31,32,36,25',attributes.report_type)>
                UNION ALL
                <cfif len(all_process_type)>
                    SELECT
                        SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            SUM(PRICE) AS PRICE,
                            SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                            NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                        <cfelse>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(PRICE) AS PRICE,
                        </cfif>
                        SUM(NET_KAR) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                        #col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM 
                        <cfif attributes.report_type neq 37>
                        T2
                        <cfelse>
                        ####sale_analyse_report_consumer_#session.ep.userid#
                        </cfif>
                    WHERE
                        PROCESS_CAT IN (#all_process_type#)
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                        #col2#<!--- Yukarda tanımlamam group by bloğu --->
                    <cfif isdefined('attributes.negative_product')>
                    HAVING 
                        SUM(NET_KAR) < 0
                    </cfif>
                </cfif>
                <cfif listlen(return_process_type) and len(all_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(return_process_type)>
                        SELECT
                            -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                -1*SUM(GROSSTOTAL) GROSSTOTAL,
                                -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                                -1*SUM(PRICE) AS PRICE,
                                -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                                -1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                                NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                            <cfelse>
                                -1*SUM(GROSSTOTAL) GROSSTOTAL,
                                -1*SUM(PRICE) AS PRICE,
                            </cfif>
                            -1*SUM(NET_KAR) AS NET_KAR,
                            <cfif attributes.is_discount eq 1>
                                -1*SUM(DISCOUNT) AS DISCOUNT,
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                                </cfif>
                            </cfif> 
                                <cfif attributes.report_type neq 1>-1*</cfif>
                                #col#
                           <!--- Yukarda tanımlanan select bloğu --->
                        FROM 
                            <cfif attributes.report_type neq 37>
                            T2
                            <cfelse>
                            ####sale_analyse_report_consumer_#session.ep.userid#
                            </cfif>
                        WHERE
                            PROCESS_CAT IN (#return_process_type#)	
                            <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                                AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                            </cfif>
                        GROUP BY
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                NET_KAR_DOVIZ_MONEY,
                                <cfif attributes.is_other_money eq 1>
                                    OTHER_MONEY,
                                </cfif>
                            </cfif>
                            #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
                <cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(give_process_type)>
                    SELECT
                        SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            SUM(PRICE) AS PRICE,
                            SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        <cfelse>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(PRICE) AS PRICE,
                        </cfif>
                        SUM(PRICE) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                        0*#col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM
                        <cfif attributes.report_type neq 37>
                        T2
                        <cfelse>
                        ####sale_analyse_report_consumer_#session.ep.userid#
                        </cfif>	
                    WHERE
                        PROCESS_CAT IN (#give_process_type#)	
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                        #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
                <cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(take_process_type)>
                    SELECT
                        -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            -1*SUM(GROSSTOTAL) GROSSTOTAL,
                            -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            -1*SUM(PRICE) AS PRICE,
                            -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            -1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        <cfelse>
                            -1*SUM(GROSSTOTAL) GROSSTOTAL,
                            -1*SUM(PRICE) AS PRICE,
                        </cfif>
                        -1*SUM(PRICE) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            -1*SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                        0*#col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM
                        <cfif attributes.report_type neq 37>
                        T2
                        <cfelse>
                        ####sale_analyse_report_consumer_#session.ep.userid#
                        </cfif>	
                    WHERE
                        PROCESS_CAT IN (#take_process_type#)
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>	
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                        #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
            </cfif>
            <cfif listfind('1,32,2,3,4,19,10,11,13,26,28,30',attributes.report_type)>
                UNION ALL
                <cfif len(all_process_type)>
                    SELECT
                        SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            SUM(PRICE) AS PRICE,
                            SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                            NET_KAR_DOVIZ_MONEY,
                        <cfif attributes.is_other_money eq 1>
                            OTHER_MONEY,
                        </cfif>
                        <cfelse>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(PRICE) AS PRICE,
                        </cfif>
                        SUM(NET_KAR) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                        #col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM 
                        <cfif attributes.report_type neq 37>
                        T3
                        <cfelse>
                        ####sale_analyse_report_employee_#session.ep.userid#
                        </cfif>
                    WHERE
                        PROCESS_CAT IN (#all_process_type#)
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                        #col2#<!--- Yukarda tanımlamam group by bloğu --->
                    <cfif isdefined('attributes.negative_product')>
                    HAVING 
                        SUM(NET_KAR) < 0
                    </cfif>
                </cfif>
                <cfif listlen(return_process_type) and len(all_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(return_process_type)>
                        SELECT
                            -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                -1*SUM(GROSSTOTAL) GROSSTOTAL,
                                -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                                -1*SUM(PRICE) AS PRICE,
                                -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                                -1*SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                                NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                            <cfelse>
                                -1*SUM(GROSSTOTAL) GROSSTOTAL,
                                -1*SUM(PRICE) AS PRICE,
                            </cfif>
                            -1*SUM(NET_KAR) AS NET_KAR,
                            <cfif attributes.is_discount eq 1>
                                -1*SUM(DISCOUNT) AS DISCOUNT,
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                                </cfif>
                            </cfif>
                                <cfif attributes.report_type neq 1>-1*</cfif>#col#<!--- Yukarda tanımlanan select bloğu --->
                        FROM 
                            <cfif attributes.report_type neq 37>
                            T3
                            <cfelse>
                            ####sale_analyse_report_employee_#session.ep.userid#
                            </cfif>
                        WHERE
                            PROCESS_CAT IN (#return_process_type#)	
                            <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                                AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                            </cfif>
                        GROUP BY
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                NET_KAR_DOVIZ_MONEY,
                                <cfif attributes.is_other_money eq 1>
                                    OTHER_MONEY,
                                </cfif>
                            </cfif>
                                #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
                <cfif (listlen(return_process_type) or len(all_process_type)) and len(give_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(give_process_type)>
                    SELECT
                        SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            SUM(PRICE) AS PRICE,
                            SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,

                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        <cfelse>
                            SUM(GROSSTOTAL) GROSSTOTAL,
                            SUM(PRICE) AS PRICE,
                        </cfif>
                        SUM(PRICE) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                            0*#col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM
                        <cfif attributes.report_type neq 37>
                        T3
                        <cfelse>
                        ####sale_analyse_report_employee_#session.ep.userid#
                        </cfif>	
                    WHERE
                        PROCESS_CAT IN (#give_process_type#)	
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                            #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
                <cfif (listlen(return_process_type) or listlen(all_process_type) or listlen(give_process_type)) and len(take_process_type)>
                    UNION ALL
                </cfif>	
                <cfif listlen(take_process_type)>
                    SELECT
                        -1*SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            -1*SUM(GROSSTOTAL) GROSSTOTAL,
                            -1*SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                            -1*SUM(PRICE) AS PRICE,
                            -1*SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                            -1*SUM(PRICE_DOVIZ) AS NET_KAR_DOVIZ,
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        <cfelse>
                            -1*SUM(GROSSTOTAL) GROSSTOTAL,
                            -1*SUM(PRICE) AS PRICE,
                        </cfif>
                        -1*SUM(PRICE) AS NET_KAR,
                        <cfif attributes.is_discount eq 1>
                            -1*SUM(DISCOUNT) AS DISCOUNT,
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            -1*SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                            </cfif>
                        </cfif>
                            0*#col#<!--- Yukarda tanımlanan select bloğu --->
                    FROM
                        <cfif attributes.report_type neq 37>
                        T3
                        <cfelse>
                        ####sale_analyse_report_employee_#session.ep.userid#
                        </cfif>
                    WHERE
                        PROCESS_CAT IN (#take_process_type#)
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            AND ((ROW_COUNT >1 AND PRICE >0) OR (ROW_COUNT = 1))
                        </cfif>	
                    GROUP BY
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            NET_KAR_DOVIZ_MONEY,
                            <cfif attributes.is_other_money eq 1>
                                OTHER_MONEY,
                            </cfif>
                        </cfif>
                            #col2#<!--- Yukarda tanımlamam group by bloğu --->
                        <cfif isdefined('attributes.negative_product')>
                        HAVING 
                            SUM(NET_KAR) < 0
                        </cfif>
                </cfif>
            </cfif>
            ) AS XXX
		</cfquery>
        <cfquery name="get_total_purchase_1" datasource="#DSN2#">
            SELECT TOP 1 * from  ####get_total_purchase_1_#session.ep.userid#
        </cfquery>
    </cfif>
</cfif>
<cfif len(attributes.process_type_select) and ( listfind(attributes.process_type_select,670) and listfind(attributes.process_type_select,690) )>
	<cfif len(attributes.department_id) >
		<cfset dep_list = ''>
		<cfloop from="1" to="#listlen(attributes.department_id,',')#" index="dept_i">
			<cfif not listfind( dep_list, listfirst(listgetat(attributes.department_id,dept_i,','),'-') )>
				<cfset dep_list = listappend(dep_list,listfirst(listgetat(attributes.department_id,dept_i,','),'-'),',')>
			</cfif>
		</cfloop>
	</cfif>
	<cfquery name="get_total_purchase_2" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#" >
		SELECT
			IRS.GROSSTOTAL GROSSTOTAL_NEW,
			IRS.GROSSTOTAL GROSSTOTAL,
            IRS.AMOUNT AS PRODUCT_STOCK,
            EP.EMPLOYEE_NAME,
            EP.EMPLOYEE_SURNAME,
            EP.EMPLOYEE_ID,
		<cfif attributes.is_kdv eq 0>
			IRS.NETTOTAL AS PRICE,
		<cfelse>
			IRS.GROSSTOTAL-IRS.DISCOUNTTOTAL AS PRICE,
		</cfif>
		<cfif attributes.is_discount eq 1>
				IRS.DISCOUNTTOTAL AS DISCOUNT,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				IRS.DISCOUNTTOTAL AS DISCOUNT_DOVIZ,
			</cfif>
		</cfif>
		<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
			ISNULL(IRS.NETTOTAL - 
				ISNULL((
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							SELECT TOP 1 IRS.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
						<cfelse>
							SELECT TOP 1 IRS.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						</cfif>
						)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
					WHERE 
						PRODUCT_COST.PRODUCT_ID=IRS.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
						<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
							AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
							AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
						</cfif>
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.PRODUCT_COST_ID DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0)
			,0) AS NET_KAR,
		<cfelse>
			0 AS NET_KAR
		</cfif>
		
		<cfif listfind('1,32',attributes.report_type)>
			,IRS.AMOUNT AS PRODUCT_STOCK,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			<cfif attributes.process_type_select neq 690>
            IR.UNIT AS BIRIM,
            IR.UNIT2 AS BIRIM2,
			<cfelse>
			IRS.UNIT AS BIRIM,
			'' AS BIRIM2, 
			</cfif>
            (SELECT PT_1.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_1 WHERE PT_1.IS_ADD_UNIT = 1 AND PT_1.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT
		<cfelseif attributes.report_type eq 2 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			IRS.UNIT AS BIRIM,
			P.MIN_MARGIN,
			P.BRAND_ID,
			P.SHORT_CODE_ID,
            (SELECT PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
            (SELECT PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
		<cfelseif attributes.report_type eq 3 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			P.PRODUCT_NAME,
			S.STOCK_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_ID,			
			IRS.UNIT AS BIRIM,
			P.MIN_MARGIN,
			S.STOCK_CODE_2,
			P.BRAND_ID,
			P.SHORT_CODE_ID,
            (SELECT PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER,
            (SELECT PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
		<cfelseif attributes.report_type eq 6 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			C.NICKNAME AS MUSTERI,
			1 AS TYPE,
			C.COMPANY_ID AS MUSTERI_ID,
			C.MEMBER_CODE
		<cfelseif attributes.report_type eq 7>
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			B.BRANCH_NAME,
			B.BRANCH_ID
		<cfelseif attributes.report_type eq 9 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			PB.BRAND_NAME,
			P.BRAND_ID
		<cfelseif attributes.report_type eq 15 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			P.SEGMENT_ID
		<cfelseif attributes.report_type eq 17 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			PR.PROJECT_ID
		<cfelseif attributes.report_type eq 18 >
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			EP.POSITION_CODE AS POSITION_CODE
		<cfelseif attributes.report_type eq 19>
        	,IRS.AMOUNT AS PRODUCT_STOCK,
            0 AS NETTOTAL_ROW,
			I.INVOICE_NUMBER,
			I.SERIAL_NUMBER,
			I.SERIAL_NO,
			I.INVOICE_CAT,			
			I.INVOICE_ID,
			I.PURCHASE_SALES,
            ISNULL((SELECT SUM(AMOUNT) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID=I.INVOICE_ID AND IR.PRODUCT_ID=INVOICE_ROW.PRODUCT_ID AND INVOICE_ROW.PRICE=0 AND INVOICE_ROW.INVOICE_ROW_ID <> IR.INVOICE_ROW_ID),0)PRICELESS_AMOUNT,
            <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
				ISNULL((XXX.COST_PRICE_OTHER),0) COST_PRICE_OTHER,
				ISNULL((XXX.PURCHASE_NET_MONEY),0) COST_PRICE_MONEY,
				ISNULL((XXX.COST_PRICE),0) COST_PRICE,
				ISNULL((xxx.COST_PRICE_2),0) COST_PRICE_2,
			<cfelse>
				'' COST_PRICE_OTHER,
				'' COST_PRICE_MONEY,
				'' COST_PRICE,
				0 AS COST_PRICE_2,
			</cfif>
			<cfif attributes.process_type_select neq 690>
                C.FULLNAME AS MUSTERI,
                C.COMPANY_ID,
				C.OZEL_KOD_2,
                C.MEMBER_CODE AS UYE_NO,
                (SELECT TOP 1 ACCOUNT_CODE FROM #dsn_alias#.COMPANY_PERIOD CP WHERE CP.COMPANY_ID = C.COMPANY_ID) ACCOUNT_CODE,
			<cfelse>
				'' AS MUSTERI,
                '' AS COMPANY_ID,
                '' AS UYE_NO,
                '' AS ACCOUNT_CODE,            	                
            </cfif>
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT_3.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_3 WHERE PT_3.IS_ADD_UNIT = 1 AND PT_3.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT_2,
            (SELECT TOP 1 PRDUNT_1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT_1 WHERE PRDUNT_1.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1,
			(SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = IR.ROW_EXP_CENTER_ID) AS EXPENSE_CENTER,
			0 AS CONSUMER_ID,
			I.INVOICE_DATE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			S.STOCK_ID,
			P.PRODUCT_NAME,
			S.PROPERTY,
			S.STOCK_CODE,
			P.MANUFACT_CODE,
			IRS.UNIT AS BIRIM,
			P.BRAND_ID,
			P.MIN_MARGIN,
			IRS.INVOICE_ROW_ID,
			'' PRICE_CAT,
			0 DUE_DATE,
			IR.PRICE PRICE_ROW,
            S.PRODUCT_CODE_2,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				IR.PRICE / IM.RATE2 PRICE_ROW_OTHER,
			<cfelse>
				IR.PRICE PRICE_ROW_OTHER,
			</cfif>
			IR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE,
			IR.OTHER_MONEY OTHER_MONEY,
			<cfif attributes.is_kdv eq 1>
				(IR.NETTOTAL + (IR.NETTOTAL*(IR.TAX/100))) NETTOTAL_ROW,
			<cfelse>
				IR.NETTOTAL NETTOTAL_ROW,
			</cfif>
			0 DISCOUNT1,
			0 DISCOUNT2,
			0 DISCOUNT3,
			0 DISCOUNT4,
			0 DISCOUNT5,
			0 DISCOUNT6,
			0 DISCOUNT7,
			0 DISCOUNT8,
			0 DISCOUNT9,
			0 DISCOUNT10,
			'' NOTE,
			0 COST_PRICE,
			0 COST_PRICE_2,
			IR.SPECT_VAR_NAME,
			(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID,
			0 MARGIN,
            <cfif attributes.process_type_select neq 690>
				CC.COMPANYCAT AS KATEGORI,
			<cfelse>
            	'' AS KATEGORI,               
            </cfif>
            '' AS PROJECT_ID,
            '' ORDER_BRANCH_ID,
            '' SHORT_CODE_ID,
			IR.ROW_PROJECT_ID,
			I.DEPARTMENT_ID,
			IR.LOT_NO,
			P.BARCOD
		<cfelseif attributes.report_type eq 20>
        	,IRS.AMOUNT AS PRODUCT_STOCK,
			PROM.PROM_ID AS PROM_ID,
			PROM.PROM_NO AS PROM_NO,
			PROM.PROM_HEAD AS PROM_HEAD
		<cfelseif attributes.report_type eq 21>
	  		,IRS.AMOUNT AS PRODUCT_STOCK,
			WP.POSITION_CODE AS WP_POSITION_CODE
		<cfelseif attributes.report_type eq 22>
	  		,IRS.AMOUNT AS PRODUCT_STOCK,
			WP.POSITION_CODE AS WP_POSITION_CODE,
			S.PRODUCT_ID,
			P.PRODUCT_NAME
		<cfelseif attributes.report_type eq 34 or attributes.report_type eq 35>
			,IRS.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		<cfelseif attributes.report_type eq 39>
			SC.COUNTRY_ID,
			SC.COUNTRY_NAME,
			IR.AMOUNT AS PRODUCT_STOCK, 
			WP.POSITION_CODE AS WP_POSITION_CODE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID
		<cfelseif attributes.report_type eq 23>
			,IRS.AMOUNT AS PRODUCT_STOCK,
			WP.POSITION_CODE AS WP_POSITION_CODE,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE,
            S.STOCK_CODE
        <cfelseif attributes.report_type eq 40>
            ,WP.POSITION_CODE AS WP_POSITION_CODE
            <cfelseif attributes.report_type eq 40 or attributes.report_type eq 41>
            C.NICKNAME AS MUSTERI,
            C.COMPANY_ID AS MUSTERI_ID,
            1 AS TYPE,
            PC.PRODUCT_CAT,
            PC.HIERARCHY,
            PC.PRODUCT_CATID,
            (SELECT TOP 1 PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2,
            (SELECT TOP 1 PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
		<cfelseif attributes.report_type eq 25>
			,IRS.AMOUNT AS PRODUCT_STOCK,
			I.SALE_EMP,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			C.NICKNAME AS MUSTERI,
			C.COMPANY_ID AS MUSTERI_ID,
			1 AS TYPE
		<cfelseif attributes.report_type eq 37>
        	,IRS.AMOUNT AS PRODUCT_STOCK
			<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
				,CASE
					WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
				 ,CASE   
					WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
				,CASE    
					WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
				,CASE    
					WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
				,CASE    
					WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
				,CASE    
					WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
				,CASE    
					WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
				,CASE    
					WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
				,CASE    
					WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
				,CASE    
					WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
				,CASE    
					WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
				,CASE    
					WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
				,CASE    
					WHEN P.IS_COST = 1 THEN 13 END AS t_13
				,CASE    
					WHEN P.IS_SALES = 1 THEN 14 END AS t_14
				,CASE    
					WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
				,CASE    
					WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
			<cfelse>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				,CASE
					WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
				 </cfif>
				 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				 ,CASE   
					WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
				 </cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				,CASE    
					WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				,CASE    
					WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				,CASE    
					WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				,CASE    
					WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				,CASE    
					WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				,CASE    
					WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				,CASE    
					WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				,CASE    
					WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
				,CASE    
					WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
				,CASE    
					WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
				,CASE    
					WHEN P.IS_COST = 1 THEN 13 END AS t_13
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
				,CASE    
					WHEN P.IS_SALES = 1 THEN 14 END AS t_14
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
				,CASE    
					WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
				</cfif>
				<cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
				,CASE    
					WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
				</cfif>
			</cfif>
        </cfif>
		<cfif attributes.report_type eq 37>
        	INTO ####get_total_purchase_2_#session.ep.userid#
        </cfif>
        FROM
			INVOICE_ROW_POS IRS,
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT P,
		<cfif listfind('1,2,3,30',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
		<cfelseif listfind('32',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT_CAT PC_2,
		<cfelseif listfind('34',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT_CAT PC_2,
			#dsn_alias#.WORKGROUP_EMP_PAR WP,
		<cfelseif listfind('35',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn_alias#.WORKGROUP_EMP_PAR WP,
        <cfelseif listfind('39',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn_alias#.WORKGROUP_EMP_PAR WP,    
		<cfelseif attributes.report_type eq 6>
			#dsn_alias#.COMPANY C
			<cfif attributes.process_type_select neq 690>
                LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = C.COUNTRY
			</cfif>,
		<cfelseif attributes.report_type eq 7>
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.BRANCH B,
		<cfelseif attributes.report_type eq 9>
			#dsn3_alias#.PRODUCT_BRANDS PB,
		<cfelseif attributes.report_type eq 17>
			#dsn_alias#.PRO_PROJECTS PR,
		<cfelseif attributes.report_type eq 18>
			#dsn_alias#.EMPLOYEE_POSITIONS EP,
		<cfelseif attributes.report_type eq 19>
			<cfif attributes.process_type_select neq 690>
                #dsn_alias#.COMPANY C,
                #dsn_alias#.COMPANY_CAT CC,
            </cfif>
			#dsn3_alias#.PRODUCT_CAT PC,
		<cfelseif attributes.report_type eq 20>
			#dsn3_alias#.PROMOTIONS PROM,
		<cfelseif listfind('21,22',attributes.report_type)>
			#dsn_alias#.WORKGROUP_EMP_PAR WP,
		<cfelseif attributes.report_type eq 23>
			#dsn_alias#.WORKGROUP_EMP_PAR WP,
			#dsn_alias#.COMPANY C
			<cfif attributes.process_type_select neq 690>
                LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = C.COUNTRY
			</cfif>,
         <cfelseif listfind('40,41',attributes.report_type)>
            #dsn3_alias#.PRODUCT_CAT PC WITH (NOLOCK),
            #dsn_alias#.WORKGROUP_EMP_PAR WP WITH (NOLOCK),
            #dsn_alias#.COMPANY C WITH (NOLOCK)
			<cfif attributes.process_type_select neq 690>
                LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = C.COUNTRY
			</cfif>,
		<cfelseif attributes.report_type eq 25>
			#dsn_alias#.COMPANY C
			<cfif attributes.process_type_select neq 690>
                LEFT JOIN  #dsn_alias#.SETUP_COUNTRY SC WITH (NOLOCK) ON SC.COUNTRY_ID = C.COUNTRY
			</cfif>,
		</cfif>
			INVOICE I
			LEFT JOIN  #dsn_alias#.DEPARTMENT D WITH (NOLOCK) ON D.DEPARTMENT_ID = I.DEPARTMENT_ID
            LEFT JOIN  #dsn_alias#.EMPLOYEES EP ON EP.EMPLOYEE_ID = I.SALE_EMP
            <cfif attributes.report_type eq 19 or attributes.process_type_select eq 690 >
				LEFT JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID<!---INNER JOIN ifadesi LEFT yapıldı. Z raporu kayıtları atılırken INVOICE_ROW kayıt atmadığı için rapora veri gelmiyordu. 16022016 MT iş ID #96467--->
            <cfelse>
            	INNER JOIN INVOICE_ROW IR ON IR.INVOICE_ID = I.INVOICE_ID
            </cfif>
            <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1>
                outer apply
                (
					<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                    SELECT TOP 1 IRS.AMOUNT*(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                    <cfelse>
                    SELECT TOP 1 IRS.AMOUNT*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                    </cfif>
                    )+ISNULL(PROM_COST,0) AS IN_COLUMN
                    <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                        ,(PURCHASE_NET_LOCATION_ALL+PURCHASE_EXTRA_COST_LOCATION) AS COST_PRICE_OTHER
                    <cfelse>
                        ,(PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS COST_PRICE_OTHER 
                    </cfif>
                        ,PURCHASE_NET_MONEY
                    <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                         ,(PURCHASE_NET_SYSTEM_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_LOCATION
                    <cfelse>
                         ,(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
                    </cfif>
                    )+ISNULL(PROM_COST,0) AS COST_PRICE
                    <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                        , (PURCHASE_NET_SYSTEM_2_LOCATION_ALL+PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION
                    <cfelse>
                       , (PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM_2
                    </cfif>
                    ) AS  COST_PRICE_2
                    FROM 
                        #dsn3_alias#.PRODUCT_COST PRODUCT_COST WITH (NOLOCK)
                    WHERE 
                        PRODUCT_COST.PRODUCT_ID=IRS.PRODUCT_ID AND
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IRS.SPECT_VAR_ID),0) AND
                        </cfif>
                        <cfif session.ep.our_company_info.is_stock_based_cost eq 1>
                            PRODUCT_COST.STOCK_ID = IRS.STOCK_ID AND
                        </cfif>
                        PRODUCT_COST.START_DATE <dateadd(day,1,I.INVOICE_DATE)
                        <cfif session.ep.isBranchAuthorization or isdefined("attributes.is_location_cost")>
                            AND PRODUCT_COST.DEPARTMENT_ID = I.DEPARTMENT_ID
                            AND PRODUCT_COST.LOCATION_ID = I.DEPARTMENT_LOCATION
                        </cfif>
                    ORDER BY
                        PRODUCT_COST.START_DATE DESC,
                        PRODUCT_COST.PRODUCT_COST_ID DESC,
                        PRODUCT_COST.RECORD_DATE DESC,
                        PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                ) as xxx
            </cfif>
		WHERE
			<cfif len(attributes.branch_id)>
				D.BRANCH_ID IN (#attributes.branch_id#) and
			</cfif>
			I.IS_IPTAL = 0 AND
			I.NETTOTAL > 0 AND
			I.INVOICE_CAT IN (67,69) AND
			I.INVOICE_ID = IRS.INVOICE_ID AND 
			<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
				P.IS_PURCHASE = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
				P.IS_INVENTORY = 0 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
				P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
				P.IS_TERAZI = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
				P.IS_PURCHASE = 0 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
				P.IS_PRODUCTION = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
				P.IS_SERIAL_NO = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
				P.IS_KARMA = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
				P.IS_INTERNET = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
				P.IS_PROTOTYPE = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
				P.IS_ZERO_STOCK = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
				P.IS_EXTRANET = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
				P.IS_COST = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
				P.IS_SALES = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
				P.IS_QUALITY = 1 AND
			<cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
				P.IS_INVENTORY = 1 AND
			</cfif>
		<cfif isdefined("attributes.is_sale_product")>
			P.IS_SALES = 1 AND
		</cfif>
		<cfif isdefined("attributes.is_sale_product")>
			P.IS_SALES = 1 AND
		</cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
			P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		</cfif>
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			P.PRODUCT_MANAGER =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"> AND
		</cfif>
		<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
			P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sup_company_id#"> AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(P.COMPANY_ID IS NULL) OR
					(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		</cfif>
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
			P.BRAND_ID IN(#attributes.brand_id#) AND
		</cfif>
		<cfif len(trim(attributes.model_id)) and len(attributes.model_name)>
			P.SHORT_CODE_ID IN (#attributes.model_id#) AND
		</cfif>
		<cfif len(attributes.city_id)>
			I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">) AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.country_id") and len(attributes.country_id)>
			I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">) AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.county_id") and len(attributes.county_id) and len(attributes.county_name)>
			I.COMPANY_ID IN(SELECT COMPANY_ID FROM #dsn_alias#.COMPANY COM WHERE COM.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">) AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		</cfif>
		<cfif len(attributes.department_id) >
			I.DEPARTMENT_ID IN (#dep_list#) AND
		<cfelseif len(branch_dep_list)>
			I.DEPARTMENT_ID IN(#branch_dep_list#) AND	
		</cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
            S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#.%"> AND
        </cfif>
		<cfif len(attributes.segment_id)>
			P.SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.segment_id#"> AND
		</cfif>
        <cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
			<cfif attributes.report_type eq 3>
                S.STOCK_ID IN (
                                    SELECT
                                        STOCK_ID
                                    FROM
                                        #dsn1_alias#.STOCKS_PROPERTY
                                    WHERE
                                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                        <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                            AND PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                        </cfif>
                                        
                                ) AND
            <cfelse>
                P.PRODUCT_ID IN (
                                    SELECT
                                        PRODUCT_ID
                                    FROM
                                        #dsn1_alias#.PRODUCT_DT_PROPERTIES
                                    WHERE
                                        PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#"> 
                                        <cfif isDefined('attributes.main_dt_properties') and len(attributes.main_dt_properties)>
                                            AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_dt_properties#">	
                                        </cfif>
                                        
                                ) AND
        	</cfif>
        </cfif>

			I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
		<cfif listfind('1,2,3,30',attributes.report_type)>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
		<cfelseif listfind('32',attributes.report_type)>
			PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
			((CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
			PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
			OR
			(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
			PC.HIERARCHY = PC_2.HIERARCHY)
			) AND		
		<cfelseif listfind('34',attributes.report_type)>
			PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND
			((CHARINDEX('.',PC_2.HIERARCHY) > 0 AND
			PC.HIERARCHY = LEFT(PC_2.HIERARCHY,ABS(CHARINDEX('.',PC_2.HIERARCHY)-1)))
			OR
			(CHARINDEX('.',PC_2.HIERARCHY) <= 0 AND
			PC.HIERARCHY = PC_2.HIERARCHY)
			) AND			
			I.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
			WP.IS_MASTER = 1 AND
			WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
		<cfelseif listfind('34',attributes.report_type)>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			I.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
			WP.IS_MASTER = 1 AND
			WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
		<cfelseif attributes.report_type eq 6>
			P.COMPANY_ID = C.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(P.COMPANY_ID IS NULL) OR
					(P.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		<cfelseif attributes.report_type eq 7>
			<cfif x_show_order_branch_type eq 1>
				ISNULL((SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SRR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID),(SELECT TOP 1 O.FRM_BRANCH_ID FROM #dsn3_alias#.ORDERS O,#dsn3_alias#.ORDER_ROW ORR WHERE O.ORDER_ID = ORR.ORDER_ID AND ORR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID)) = B.BRANCH_ID AND
			<cfelse>
				I.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			</cfif>
			D.BRANCH_ID = B.BRANCH_ID AND		
		<cfelseif attributes.report_type eq 9>
			P.BRAND_ID = PB.BRAND_ID AND
		<cfelseif attributes.report_type eq 18>
			P.PRODUCT_MANAGER = EP.POSITION_CODE AND
		<cfelseif attributes.report_type eq 19>
			<cfif attributes.process_type_select neq 690>
                I.COMPANY_ID = C.COMPANY_ID AND
				<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            </cfif>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
		<cfelseif attributes.report_type eq 17>
			I.PROJECT_ID = PR.PROJECT_ID AND
		<cfelseif attributes.report_type eq 20>
			IRS.PROM_ID = PROM.PROM_ID AND
		<cfelseif listfind('21,22',attributes.report_type)>
			I.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
			WP.IS_MASTER = 1 AND
			WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
		<cfelseif attributes.report_type eq 23>
			C.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(C.COMPANY_ID IS NULL) OR
					(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
			I.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
			WP.IS_MASTER = 1 AND
			WP.OUR_COMPANY_ID = #session.ep.company_id# AND
        <cfelseif listfind('40,41',attributes.report_type)>
            PC.PRODUCT_CATID = P.PRODUCT_CATID AND
            C.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(C.COMPANY_ID IS NULL) OR
					(C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
            I.COMPANY_ID = WP.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
            WP.IS_MASTER = 1 AND
            WP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
		<cfelseif attributes.report_type eq 23>
			I.COMPANY_ID = C.COMPANY_ID AND
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and  session.ep.our_company_info.sales_zone_followup eq 1>		
				(
					(I.COMPANY_ID IS NULL) OR
					(I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				) AND
			</cfif>
		</cfif>
		<cfif isdefined('attributes.promotion_id') and len(attributes.promotion_id) and len(prom_head)>
			IRS.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.promotion_id#"> AND
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#"> AND 
		</cfif>
			S.PRODUCT_ID = P.PRODUCT_ID AND
			IRS.STOCK_ID = S.STOCK_ID
	</cfquery>
    <cfif attributes.report_type eq 37>
        <cfquery name="get_total_purchase_2" datasource="#DSN2#">
            SELECT top 1 PRODUCT_STOCK  FROM   ####get_total_purchase_2_#session.ep.userid#
        </cfquery>
    </cfif>
</cfif>
<cfif isdefined("get_total_purchase_1") or isdefined("get_total_purchase_2")>
	<cfif attributes.report_type neq  37>
        <cfquery name="get_total_purchase_3" dbtype="query" >
            <cfif isdefined("get_total_purchase_1")>
                SELECT * FROM get_total_purchase_1
                    <cfif isdefined("get_total_purchase_2")> UNION ALL</cfif>
            </cfif>
            <cfif isdefined("get_total_purchase_2")>
                SELECT * FROM get_total_purchase_2
            </cfif>
        </cfquery>
    <cfelse>
        <cfquery name="get_total_purchase_3" datasource="#dsn2#">
            SELECT * 
            INTO ####get_total_purchase_3_#session.ep.userid#
            FROM (
			<cfif isdefined("get_total_purchase_1")>
                SELECT * FROM ####get_total_purchase_1_#session.ep.userid#
                    <cfif isdefined("get_total_purchase_2")> UNION ALL</cfif>
            </cfif>
            <cfif isdefined("get_total_purchase_2")>
                SELECT * FROM ####get_total_purchase_2_#session.ep.userid#
            </cfif>
            ) AS XXX
        </cfquery>	
    </cfif>
<cfelse>
	<cfset get_total_purchase_3.recordcount=0>
</cfif>

<cfif attributes.report_type neq 37>
	<cfif get_total_purchase_3.recordcount>
        <cfquery name="get_total_purchase" dbtype="query">
            SELECT
                SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                SUM(GROSSTOTAL) GROSSTOTAL,
                SUM(PRICE) AS PRICE,
                SUM(NET_KAR) AS NET_KAR,
            <cfif attributes.is_discount eq 1>
                SUM(DISCOUNT) AS DISCOUNT,
                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                </cfif>
            </cfif>
            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                NET_KAR_DOVIZ_MONEY,
            </cfif>
            	<cfif not len(attributes.process_type_select)>
	            	SUM(AMOUNT2) AS AMOUNT2,
                </cfif>
				<cfif attributes.is_other_money eq 1>
                    OTHER_MONEY,
               	</cfif>
                #col#
            FROM
                get_total_purchase_3
            GROUP BY
            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                NET_KAR_DOVIZ_MONEY,
                <cfif attributes.is_other_money eq 1>
                    OTHER_MONEY,
                </cfif>
            </cfif>			
            #col2#
            <cfif len(attributes.process_type_) and (listfind(attributes.process_type_select,670) or listfind(attributes.process_type_select,690))>
                <!--- Yazar Kasa ve Z Raporlarinda Iadeler icin - stock olusuyor, kalani 0 olan kayitlarin gorunmesi istenmiyor FBS 20120510 --->
                HAVING
                    SUM(PRODUCT_STOCK) != 0
            </cfif>
            <cfif attributes.report_sort eq 1>
                ORDER BY 
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                        <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP,
                        MUSTERI,
                    <cfelseif attributes.report_type eq 38>
                        INVOICE_DATE,
                        MODEL_NAME,
                    </cfif>
                    PRICE DESC
            <cfelseif attributes.report_sort eq 2>
                ORDER BY
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                        <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40  or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP,
                        MUSTERI,
                    <cfelseif attributes.report_type eq 38>
                        INVOICE_DATE,
                        MODEL_NAME,
                    </cfif>
                    PRODUCT_STOCK DESC
            <cfelse>
                ORDER BY
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP, 
                        MUSTERI,
                    <cfelseif attributes.report_type eq 38>
                        INVOICE_DATE,	
                        MODEL_NAME,
                    </cfif>
                    NET_KAR DESC
            </cfif>
        </cfquery>
        <cfquery name="get_all_total" dbtype="query">
            SELECT
                SUM(PRICE) AS PRICE,
                SUM(NET_KAR) AS NET_KAR
            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                ,SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ
            </cfif>
            <cfif attributes.is_discount eq 1>
                ,SUM(DISCOUNT) AS DISCOUNT
                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                ,SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ
                </cfif>
            </cfif>
            FROM get_total_purchase
        </cfquery>
        <cfif len(get_all_total.PRICE)>
            <cfset butun_toplam = get_all_total.PRICE>
        <cfelse>
            <cfset butun_toplam = 1>
        </cfif>
        <cfif len(get_all_total.NET_KAR)>
            <cfset butun_kar = get_all_total.NET_KAR>
        <cfelse>
            <cfset butun_kar = 1>
        </cfif>
        <cfif isdefined('get_all_total.NET_KAR_DOVIZ') and len(get_all_total.NET_KAR_DOVIZ) >
            <cfset diger_butun_kar = get_all_total.NET_KAR_DOVIZ >
        <cfelse>
            <cfset diger_butun_kar = 1 >
        </cfif>
    <cfelse>
        <cfset get_total_purchase.recordcount=0>
        <cfset butun_toplam = 1 >
        <cfset butun_kar = 1 >
        <cfset diger_butun_kar = 1 >
    </cfif>
<cfelse>
	<cfif isdefined("get_total_purchase_1") or isdefined("get_total_purchase_2")>
	<cfquery name="get_total_purchase" datasource="#dsn2#">
            SELECT
                SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
                SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
                SUM(GROSSTOTAL) GROSSTOTAL,
                SUM(PRICE) AS PRICE,
                SUM(NET_KAR) AS NET_KAR,
            <cfif attributes.is_discount eq 1>
                SUM(DISCOUNT) AS DISCOUNT,
                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
                </cfif>
            </cfif>
            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
                SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
                SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
                NET_KAR_DOVIZ_MONEY,
            </cfif>

                U.PRODUCT_TYPE	
               <cfif attributes.is_other_money eq 1>
                    ,OTHER_MONEY
               </cfif>
            FROM
            (SELECT *
                 FROM  ####get_total_purchase_3_#session.ep.userid#) t
                UNPIVOT
                (PRODUCT_TYPE FOR ALAN IN
                    (	<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                    	 t_1,
                         t_2, 
                         t_3, 
                         t_4,
                         t_5,
                         t_6,
                         t_7,
                         t_8,
                         t_9,
                         t_10,
                         t_11,
                         t_12,
                         t_13,
                         t_14,
                         t_15,
                         t_16
                         <cfelse>
							 	 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                                 	t_1
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                                 	t_2
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)> 
                                 	t_3
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                                 	t_4
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                                 	t_5
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                                 	t_6
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                                 	t_7
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                                 	t_8

                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                                 	t_9
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                                 	t_10
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                                 	t_11
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                                 	t_12
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                                 	t_13
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                                 	t_14
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                                 	t_15
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                                 	t_16
                         		 </cfif>
						 </cfif>
                     )
                ) AS u            
            GROUP BY
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                NET_KAR_DOVIZ_MONEY,
                <cfif attributes.is_other_money eq 1>
                    OTHER_MONEY,
                </cfif>
            </cfif>
            u.PRODUCT_TYPE			
            <cfif len(attributes.process_type_) and (listfind(attributes.process_type_,670) or listfind(attributes.process_type_,690))>
                <!--- Yazar Kasa ve Z Raporlarinda Iadeler icin - stock olusuyor, kalani 0 olan kayitlarin gorunmesi istenmiyor FBS 20120510 --->
                HAVING
                    SUM(PRODUCT_STOCK) != 0
            </cfif>
            <cfif attributes.report_sort eq 1>
                ORDER BY 
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                        <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP,
                        MUSTERI,
                    </cfif>
                    PRICE DESC
            <cfelseif attributes.report_sort eq 2>
                ORDER BY
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP,
                        MUSTERI,
                    </cfif>
                    PRODUCT_STOCK DESC
            <cfelse>
                ORDER BY
                    <cfif attributes.report_type eq 22>
                        WP_POSITION_CODE,
                    <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40>
                        WP_POSITION_CODE,
                      <cfelseif attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41>
                        MUSTERI,
                    <cfelseif attributes.report_type eq 25>
                        SALE_EMP,
                        MUSTERI,	
                    </cfif>
                    NET_KAR DESC
            </cfif>
        </cfquery>
    </cfif>    
</cfif>
<cfif isdefined("get_total_purchase")and get_total_purchase.recordcount> 
	<cfquery name="get_all_total" dbtype="query">
		SELECT
			SUM(PRICE) AS PRICE,
			SUM(NET_KAR) AS NET_KAR
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			,SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ
		</cfif>
		<cfif attributes.is_discount eq 1>
			,SUM(DISCOUNT) AS DISCOUNT
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			,SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ
			</cfif>
		</cfif>
		FROM get_total_purchase
	</cfquery>
	<cfif len(get_all_total.PRICE)>
		<cfset butun_toplam = get_all_total.PRICE>
	<cfelse>
		<cfset butun_toplam = 1>
	</cfif>
	<cfif len(get_all_total.NET_KAR)>
		<cfset butun_kar = get_all_total.NET_KAR>
	<cfelse>
		<cfset butun_kar = 1>
	</cfif>
	<cfif isdefined('get_all_total.NET_KAR_DOVIZ') and len(get_all_total.NET_KAR_DOVIZ) >
		<cfset diger_butun_kar = get_all_total.NET_KAR_DOVIZ >
	<cfelse>
		<cfset diger_butun_kar = 1 >
	</cfif>	
<cfelse>
	<cfset get_total_purchase.recordcount = 0 >
	<cfset butun_toplam = 1>
	<cfset butun_kar = 1>
	<cfset diger_butun_kar = 1 >
</cfif>
<cfif attributes.report_type eq 4>
	<cfif get_total_purchase.recordcount>
		<cfquery name="get_total_purchase" dbtype="query">
			SELECT 
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(GROSSTOTAL_NEW) GROSSTOTAL_NEW,
				SUM(NET_KAR) NET_KAR,
				SUM(PRICE) PRICE,
				SUM(PRODUCT_STOCK) PRODUCT_STOCK,
				MEMBER_CODE,
				MUSTERI,
				MUSTERI_CITY,
				MUSTERI_ID,
				SALES_COUNTY,
				TAXNO,
				TAXOFFICE,
				ZONE_ID,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
					SUM(NET_KAR_DOVIZ) AS NET_KAR_DOVIZ,
					NET_KAR_DOVIZ_MONEY,
				</cfif>
				<cfif attributes.is_discount eq 1>
					SUM(DISCOUNT) AS DISCOUNT,
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					SUM(DISCOUNT_DOVIZ) AS DISCOUNT_DOVIZ,
					</cfif>
				</cfif>
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				TYPE					
			FROM 
				get_total_purchase 
			GROUP BY
				MEMBER_CODE,
				MUSTERI,
				MUSTERI_CITY,
				MUSTERI_ID,
				SALES_COUNTY,
				TAXNO,
				TAXOFFICE,
				ZONE_ID,
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					NET_KAR_DOVIZ_MONEY,
				</cfif>
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				TYPE
			ORDER BY 
				PRICE DESC
		</cfquery>
	</cfif>
</cfif>