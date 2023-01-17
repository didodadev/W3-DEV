<cfsetting showdebugoutput="no">
<cfif session.ep.isBranchAuthorization>
<cfelse>
    <cfparam name="attributes.module_id_control" default="13,11,20"><!---stok,satış,fatura--->
    <cfinclude template="report_authority_control.cfm">
</cfif>
<cfparam name="attributes.process_type_select" default="">
<cfparam name="attributes.main_properties" default="">
<cfparam name="attributes.main_dt_properties" default="">
<!--- Excel alırken sorun oluyordu diye kapattım.  M.E.Y 20120810--->
<cf_xml_page_edit fuseact="report.sale_analyse_report">
<cfif isdefined('attributes.ajax')><!--- Kümüle Raporlar için Dönem ve şirket farklı gönderilebilir! --->
	<cfif isdefined('attributes.new_sirket_data_source')>
		<cfset dsn3 = attributes.new_sirket_data_source>
	</cfif>
	<cfif isdefined('attributes.new_donem_data_source')>
		<cfset dsn2 = attributes.new_donem_data_source>
	</cfif>
</cfif>
<!---
 ! ! !  Habersiz dokanmayınız ! ! !
Create Date GecmisGunHatirlamiyorum
Modified : 20060531
Modified : 20060603
Modified : TolgaS20070402 kayıtlı maliyetten getirsin(query tamamen değişti!!!!) ve zarar eden eklendi
Modified : SM20070507 Satış iade tipli işlem tipleri de hesaba eklendi(- olarak) ve query düzenlendi ve ayrıca şube yetkisine göre çalışması sağlandı..
Modified : TolgaS20080726 0 tutarlı faturaların gelmesi sağlandı
sale_analyse_report.cfm (detayli satis analizi raporu)
	attributes.report_type 1 : Kategori Bazında
	attributes.report_type 2 : Ürün Bazında
	attributes.report_type 3 : Stok Bazında
	attributes.report_type 4 : Müşteri Bazında
	attributes.report_type 5 : Müşteri Tipi Bazında
	attributes.report_type 6 : Tedarikçi Bazında
	attributes.report_type 7 : Şube Bazında
	attributes.report_type 8 : Satış Yapan Bazında
	attributes.report_type 9 : Marka Bazında
	attributes.report_type 10 : Musteri Degeri Bazında
	attributes.report_type 11 : Iliski Tipi Bazında
	attributes.report_type 12 : Mikro Bolge Kodu Bazında
	attributes.report_type 13 : Satis Bolgesi Bazında
	attributes.report_type 14 : Odeme Yontemi Bazında
	attributes.report_type 15 : Hedef Pazar Bazında
	attributes.report_type 16 : İl Bazında
	attributes.report_type 17 : Proje Bazında
	attributes.report_type 18 : Ürün Sorumlusu Bazında
	attributes.report_type 19 : Belge ve Stok Bazında
	attributes.report_type 20 : Promosyon Bazında
	attributes.report_type 21 : Müşteri Temsilcisi Bazında
	attributes.report_type 22 : Müşteri Temsilcisi ve Ürün Bazında
	attributes.report_type 23 : Müşteri Temsilcisi,Müşteri ve Ürün Bazında
	attributes.report_type 25 : Satış Yapan,Müşteri ve Ürün Bazında
	attributes.report_type 24 : vergi no bazında
	attributes.report_type 26 : Satış Ortağı Bazında
	attributes.report_type 27 : Referans Kod Bazında
	attributes.report_type 28 : Fiyat Listesi Bazında
	attributes.report_type 29 : Müşteri Temsilcisi ve Fiyat Listesi Bazında
	attributes.report_type 30 : Ürün ve Fiyat Listesi bazında
	attributes.report_type 31 : Ülke bazında
	attributes.report_type 32 : Ana Kategori bazında
	attributes.report_type 33 : Sektör bazında
	attributes.report_type 34 : M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'>
	attributes.report_type 35 : M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'>
	attributes.report_type 36 : M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='627.Müşteri Tipi Bazında'>
	attributes.report_type 37 : Ürün grubu bazında
	attributes.report_type 40 : Müşteri Temsilcisi,Müşteri ve Kategori Bazında
	attributes.report_type 41 : Müşteri ve Kategori Bazında
--->
<cf_get_lang_set module_name="report">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.process_type_" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.is_kdv" default="0">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.sup_company" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id2" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.model_name" default="">
<cfparam name="attributes.model_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_prom" default="0">
<cfparam name="attributes.is_profit" default="0">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_spect_info" default="0">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.resource_id" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.is_discount" default="0">
<cfparam name="attributes.segment_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.commethod_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.promotion_id" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.prom_head" default="">
<cfparam name="attributes.is_priceless" default="">
<cfparam name="attributes.ref_member_id" default="">
<cfparam name="attributes.ref_member_type" default="">
<cfparam name="attributes.ref_member" default="">
<cfparam name="attributes.price_catid" default="">
<cfparam name="attributes.is_price_change" default="">
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.county_name" default="">
<cfparam name="attributes.exp_discounts" default="">
<cfparam name="attributes.is_cost_price" default="">
<cfparam name="attributes.is_project" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.sales_member_id" default= "">
<cfparam name="attributes.sales_member_type" default= "">
<cfparam name="attributes.sales_member" default="">

<cfset rapor = StructNew()>
<cfset rapor.money_array["money_total"] = StructNew()>
<cfset rapor.money_array["money_type"] = StructNew()>
<cfset money_total = 0.0>
<cfset money_counter = 0>
<cfset money_type_counter = 0>

<cfset product_cat_list = "50,79,412,55,159,46,546,456,667,52,547,607,545,48,164,44">
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>
<cfif attributes.report_type eq 19>
	<cfset project_id_list=''>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	</cfquery>
	<cfset project_id_list = valuelist(get_project.project_id,',')>
</cfif>
<cfset all_process_type_list="">
<cfset all_process_cat_list="">
<cfset all_process_cat_list_1="">
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (50,52,53,531,532,56,58,62,561,54,55,51,63,48,49,533,640,680,5311) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="GET_PROCESS_CAT_1" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (50,52,53,531,532,56,58,561,54,55,51,63,48,49,533,5311) ORDER BY PROCESS_CAT
</cfquery>
<cfif isdefined("attributes.is_from_report")>
	<cfif session.ep.our_company_info.workcube_sector is 'per'>
		<cfset attributes.process_type_ =  '670'>
	<cfelse>
		<cfset attributes.process_type_ = all_process_cat_list_1>
	</cfif>
</cfif>
<cfset new_process_type=''>
<cfif (listfind(attributes.process_type_,670) or listfind(attributes.process_type_,690)) and (listfind('4,5,8,10,11,12,13,14,16,19,24,26,27,28,29,30,31,34,35,36',attributes.report_type) and attributes.is_other_money eq 1 and attributes.is_money2 eq 1 and isdefined("attributes.negative_product"))>
	<cfloop from="1" to="#listlen(attributes.process_type_)#" index="i">
		<cfif listgetat(attributes.process_type_,i) neq 670 and listgetat(attributes.process_type_,i) neq 690>
			<cfset new_process_type= listappend(new_process_type,listgetat(attributes.process_type_,i))>
		</cfif>
	</cfloop>
	<cfset attributes.process_type_ = new_process_type>
</cfif>
<cfquery name="GET_PROPERTIES" datasource="#DSN1#">
	SELECT PROPERTY_ID, PROPERTY FROM PRODUCT_PROPERTY WHERE IS_ACTIVE = 1
</cfquery>

<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <>2 AND
		<cfif x_show_pasive_departments eq 0>
            D.DEPARTMENT_STATUS = 1 AND
        </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN#">
	SELECT UNIT_ID,UNIT FROM SETUP_UNIT
</cfquery>
<cfquery name="get_cost_type" datasource="#dsn#">
	SELECT INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>

<cfset unit_kontr = valuelist(get_product_units.unit,',')>
<cfoutput query="get_product_units">
	<cfset unit_ = filterSpecialChars(get_product_units.unit)>
	<cfset 'toplam_#unit_#' = 0>
    <cfset 'toplam_miktar_#unit_#' = 0>
</cfoutput>

<cfquery name="GET_PRODUCT_UNITS_" datasource="#DSN3#">
	SELECT MAIN_UNIT FROM PRODUCT_UNIT
</cfquery>
<cfoutput query="GET_PRODUCT_UNITS_">
	<cfset unit_weight_ = filterSpecialChars(trim(GET_PRODUCT_UNITS_.main_unit))>
	<cfset 'toplam_1#unit_weight_#' = 0>
    <cfset 'toplam_ikinci_#unit_weight_#' = 0>
</cfoutput>

<cfset toplam_Kilogram=0>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdate(attributes.date1)><cf_date tarih = "attributes.date1"></cfif>
	<cfif isdate(attributes.date2)><cf_date tarih = "attributes.date2"></cfif>	
	<!--- Query bloğu --->
	<cfinclude template="../query/get_sale_analyse.cfm">
</cfif>


<cfset toplam_satis = 0>
<cfset toplam_miktar = 0>
<cfset toplam_ikinci_miktar = 0>
<cfset toplam_unit_weıght = 0>
<cfset toplam_unit_weıght_1 = 0>
<cfset unit2_list = "">
<cfset toplam_brut = 0>
<cfset toplam_brut_doviz = 0>
<cfset toplam_doviz = 0>
<cfset toplam_isk_doviz = 0>
<cfset toplam_doviz_kar= 0>
<cfset toplam_karlilik= 0>
<cfset toplam_karlilik_2= 0>
<cfset toplam_isk_tutar= 0>
<cfset toplam_bedelsiz=0>
<cfset toplam_cost_price=0>
<cfset toplam_cost_price_all=0>
<cfset toplam_cost_price_2=0>
<cfset toplam_cost_price_all_2=0>
<cfset toplam_marj_all=0>
<cfset toplam_net_fiyat=0>
<cfset toplam_multiplier_amount_1 = 0>
<cfset toplam_multiplier_amount_2 = 0>
<cfset toplam_multiplier = 0>

<cfquery name="GET_CUSTOMER_VALUE_2" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfif attributes.report_type eq 10>
	<!---<cfquery name="GET_CUSTOMER_VALUE_2" datasource="#DSN#">
		SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE_ID
	</cfquery>--->
	<cfset list_customer_val_ids = valuelist(GET_CUSTOMER_VALUE_2.customer_value_id,',')>
</cfif>

<cfif attributes.report_type eq 11>
	<cfquery name="GET_RESOURCE_2" datasource="#DSN#">
		SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE_ID
	</cfquery>
	<cfset list_resource_ids = valuelist(get_resource_2.resource_id,',')>
</cfif>
<cfquery name="GET_PROMOTIONS" datasource="#DSN3#">
	SELECT PROM_ID,PROM_HEAD FROM PROMOTIONS
</cfquery>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfif attributes.report_type eq 13 or attributes.report_type eq 4>
	<cfquery name="SZ_2" datasource="#DSN#">
		SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_ID
	</cfquery>
	<cfset list_zone_ids = valuelist(sz_2.sz_id,',')>
</cfif>
<cfif attributes.report_type eq 33>
	<cfquery name="GET_SECTOR" datasource="#DSN#">
		SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT_ID
	</cfquery>
	<cfset list_sector_ids = valuelist(get_sector.sector_cat_id,',')>
</cfif>
<cfif attributes.report_type eq 14>
	<cfquery name="GET_PAY_METHOD" datasource="#DSN#">
		SELECT 
			SP.PAYMETHOD_ID,
			SP.PAYMETHOD
		FROM 
			SETUP_PAYMETHOD SP,
			SETUP_PAYMETHOD_OUR_COMPANY SPOC
		WHERE 
			SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		ORDER BY 
			SP.PAYMETHOD_ID
	</cfquery>
	<cfset list_pay_ids = valuelist(get_pay_method.paymethod_id,',')>
	<cfquery name="GET_CC_METHOD" datasource="#DSN3#">
		SELECT CARD_NO,PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE ORDER BY PAYMENT_TYPE_ID
	</cfquery>
	<cfset list_cc_pay_ids = valuelist(get_cc_method.payment_type_id,',')>
</cfif>
<cfquery name="GET_SEGMENTS" datasource="#DSN1#">
	SELECT PRODUCT_SEGMENT_ID, PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
</cfquery>
<cfquery name="GET_SEGMENTS_2" datasource="#DSN1#">
	SELECT PRODUCT_SEGMENT_ID, PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT_ID
</cfquery>
<cfset list_segment_ids = valuelist(get_segments_2.product_segment_id,',')>
<cfif attributes.report_type eq 16>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY 
	</cfquery>
	<cfset city_id_list = valuelist(get_city.city_id,',')>
</cfif>
<cfif attributes.report_type eq 17>
	<cfquery name="get_project" datasource="#DSN#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	</cfquery>
	<cfset project_id_list = valuelist(get_project.project_id,',')>
</cfif>
<cfif listfind('18,21,22,23,25,29,34,35,36,39,40,41',attributes.report_type)>
	<cfquery name="get_position" datasource="#DSN#">
		SELECT POSITION_CODE,EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS
	</cfquery>
	<cfset position_code_list = valuelist(get_position.position_code,',')>
	<cfset employee_id_list = valuelist(get_position.employee_id,',')>
</cfif>
<cfif listfind('25',attributes.report_type)>
	<cfquery name="get_employee" datasource="#DSN#">
		SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES
	</cfquery>
	<cfset employee_id_list = valuelist(get_employee.employee_id,',')>
</cfif>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		BRANCH_STATUS = 1 AND
		BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		CONSCAT		
</cfquery>
<cfquery name="GET_COMMETHOD_CATS" datasource="#DSN#">
	SELECT COMMETHOD_ID,COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<!--- <cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT
		COUNTRY_ID,
		CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE COUNTRY_NAME
		END AS COUNTRY_NAME,
		COUNTRY_PHONE_CODE,
		COUNTRY_CODE,
		IS_DEFAULT
	FROM
		SETUP_COUNTRY
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTRY.COUNTRY_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTRY_NAME">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTRY">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY
		COUNTRY_NAME
</cfquery> --->
<cfquery name="GET_MONEY" datasource="#DSN2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset "toplam_#money#" = 0>
</cfoutput>
<cfquery name="Get_Category" datasource="#dsn3#">
	SELECT PRODUCT_CAT,PRODUCT_CATID,HIERARCHY,IS_SUB_PRODUCT_CAT FROM PRODUCT_CAT ORDER BY HIERARCHY,PRODUCT_CAT
</cfquery>
<cfsavecontent variable="title"><cf_get_lang no='308.Satış Analiz Raporu Fatura'></cfsavecontent>
<cfform name="rapor" action="#request.self#?fuseaction=#fusebox.circuit#.sale_analyse_report" method="post">
    <cf_report_list_search id="analyse_report_" title="#title#">
	    <cf_report_list_search_area>   
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
                                            <input type="text" name="product_name" id="product_name"  value="<cfoutput>#attributes.product_name#</cfoutput>"  onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>				
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='722.Mikro Bölge Kodu'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
                                                <cfquery name="GET_IMS" datasource="#DSN#">
                                                    SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
                                                </cfquery>
                                                <input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                                                <cfinput type="text" name="ims_code_name" id="ims_code_name" value="#get_ims.ims_code# #get_ims.ims_code_name#" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off" >
                                            <cfelse>
                                                <input type="hidden" name="ims_code_id" id="ims_code_id">
                                                <cfinput type="text" name="ims_code_name" id="ims_code_name" value="" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');" autocomplete="off" >
                                            </cfif>
                                            <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=rapor.ims_code_name&field_id=rapor.ims_code_id','list');"></span>			  
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1736.Tedarikçi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif len(attributes.sup_company)><cfoutput>#attributes.sup_company_id#</cfoutput></cfif>">
                                            <input type="text" name="sup_company" id="sup_company"  onfocus="AutoComplete_Create('sup_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','sup_company_id','','3','250');" value="<cfif len(attributes.sup_company)><cfoutput>#UrlDecode(attributes.sup_company)#</cfoutput></cfif>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.sup_company&field_comp_id=rapor.sup_company_id&select_list=2<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>				  
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1036.Ürün Sorumlusu'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
                                            <input type="text" name="employee_name" id="employee_name"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','product_employee_id','','3','130');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>					
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                                            <input type="text" name="pos_code_text" id="pos_code_text"  value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text&select_list=1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list')"></span>			
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='45.Müşteri'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                            <input type="hidden" name="employee_id2" id="employee_id2" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id2#</cfoutput>"</cfif>>
                                            <input type="text" name="company" id="company"  onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id2','','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_emp_id=rapor.employee_id2&field_name=rapor.company&field_member_name=rapor.company&select_list=2,3,1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='643.Satışı Yapan'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                            <input type="text" name="employee" id="employee" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','130');" autocomplete="off" >
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.employee_id&field_name=rapor.employee&select_list=1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>					
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='502.Satis Ortagi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" id="sales_member_id" name="sales_member_id" value="<cfoutput>#attributes.sales_member_id#</cfoutput>">
                                            <input type="hidden" id="sales_member_type" name="sales_member_type" value="<cfoutput>#attributes.sales_member_type#</cfoutput>">
                                            <input type="text" id="sales_member" name="sales_member" value="<cfoutput>#attributes.sales_member#</cfoutput>" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','form','3','250');">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=rapor.sales_member_id&field_name=rapor.sales_member&field_type=rapor.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                                    <cf_wrk_list_items table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='110' datasource ="#dsn1#">
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='813.Model'></label>
                                    <cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='110' datasource ="#dsn1#">
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no="1353.Ürün Grubu"></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_get_lang_set module_name="product">
                                        <select name="product_types">
                                            <option value=""><cf_get_lang_main no='322.Seciniz'></option>
                                            <option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang no='159.Tedarik Edilmiyor'></option>
                                            <option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang no='50.Tedarik Ediliyor'></option>
                                            <option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang no='79.Hizmetler'></option>
                                            <option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang no='44.Envantere Dahil'></option>
                                            <option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang no='412.Mallar'></option>
                                            <option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang no='55.Terazi'></option>
                                            <option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang no='46.Üretiliyor'></option>
                                            <option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang no='545.Maliyet Takip Ediliyor'></option>
                                            <option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>>Kalite <cf_get_lang no="164.Takip Ediliyor"></option>
                                            <option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang no='546.Seri No Takip'></option>
                                            <option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang no='456.Karma Koli'></option>
                                            <option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang_main no='667.İnternet'></option>
                                            <option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang_main no='607.Extranet'></option>
                                            <option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang no='52.Özelleştirilebilir'></option>
                                            <option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang no='547.Sıfır Stok İle Çalış'></option>
                                            <option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang no='48.Satışta'></option>
                                        </select>
                                        <cf_get_lang_set module_name="report">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
                                            <input type="text" name="product_cat" id="product_cat" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','search_product_catid','','3','250');" value="<cfif len(attributes.product_cat)><cfoutput>#UrlDecode(attributes.product_cat)#</cfoutput></cfif>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>');"></span>
                                        </div>
                                    </div>
                                </div>
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no ='1224.Referans Üye'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="ref_member_id" id="ref_member_id" value="<cfif len(attributes.ref_member_id) and len(attributes.ref_member)><cfoutput>#attributes.ref_member_id#</cfoutput></cfif>">
                                                <input type="hidden" name="ref_member_type" id="ref_member_type" value="<cfif len(attributes.ref_member_type) and len(attributes.ref_member)><cfoutput>#attributes.ref_member_type#</cfoutput></cfif>">
                                                <input type="text" name="ref_member" id="ref_member"  value="<cfif len(attributes.ref_member_id) and len(attributes.ref_member)><cfoutput>#attributes.ref_member#</cfoutput></cfif>" onfocus="AutoComplete_Create('ref_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','MEMBER_TYPE,MEMBER_ID','ref_member_type,ref_member_id','','3','250');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=rapor.ref_member_id&field_name=rapor.ref_member&field_type=rapor.ref_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"></span>	
                                            </div>
                                        </div>    
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                            <input type="text" name="project_head" id="project_head"  value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>                   
                                        </div>
                                    </div>
                                </div>
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='956.Promosyon'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="promotion_id" id="promotion_id" value="<cfif isdefined('attributes.promotion_id') and len(attributes.prom_head)><cfoutput>#attributes.promotion_id#</cfoutput></cfif>">
                                                <input type="text" name="prom_head" id="prom_head"  value="<cfif len(attributes.prom_head)><cfoutput>#attributes.prom_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('prom_head','PROM_HEAD','PROM_HEAD,PROM_NO','get_promotions','','PROM_ID','promotion_id','','3','200');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_promotions&prom_id=rapor.promotion_id&prom_head=rapor.prom_head','small');"></span>				
                                            </div>
                                        </div>
                                    </div>        
                                </cfif>
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
                                                <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=rapor.ship_method_name&field_id=rapor.ship_method_id','list');"></span>				
                                            </div>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no ='167.Sektör'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="sector_cat_id" id="sector_cat_id">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_company_sector">
                                            <option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='649.Hedef Pazar'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="SEGMENT_ID" id="SEGMENT_ID">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_segments">
                                            <option value="#product_segment_id#" <cfif attributes.segment_id eq product_segment_id>Selected</cfif>>#product_segment#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>          
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no ='807.Ülke'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="country_id" id="country_id" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0);">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfquery name="GET_COUNTRY" datasource="#DSN#">
                                                SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY 
                                            </cfquery>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1196.İl'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfif isdefined('attributes.city_id') and len(attributes.city_id)>
			                            <cfquery name="GET_CITY" datasource="#DSN#">
			                                SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
			                            </cfquery>
			                            <select name="city_id" id="city_id" tabindex="26" onchange="LoadCounty(this.value,'county_id','telcod')">
			                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			                                <cfoutput query="GET_CITY">
			                                    <option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
			                                </cfoutput>
			                            </select>
			                        <cfelse>
			                            <select name="city_id" id="city_id" tabindex="27" onchange="LoadCounty(this.value,'county_id','telcod')">
			                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			                            </select>
			                        </cfif>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no ='1226.İlçe'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="county_id" id="county_id" tabindex="28" >
			                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>						
			                            <cfif isdefined('attributes.county_id') and len(attributes.county_id)>
			                                <cfquery name="GET_COUNTY" datasource="#DSN#">
			                                    SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
			                                </cfquery>
			                                <cfoutput query="get_county">
			                                    <option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
			                                </cfoutput>
			                            </cfif>
			                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='678.İletişim Yöntemi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="commethod_id" id="commethod_id">
                                            <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                            <cfoutput query="get_commethod_cats">
                                                <option value="#commethod_id#" <cfif commethod_id eq attributes.commethod_id>selected</cfif>>#commethod#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <cfif isDefined('x_prod_prop_filter') and len(x_prod_prop_filter)>
                                    <cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
                                        <cfquery name="GET_SUB_PROPERTIES" datasource="#DSN1#">
                                            SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_properties#">
                                        </cfquery>
                                    </cfif>
                                    <div class="form-group">
                                        <label id="main_prop3" class="col col-12 col-xs-12">Varyasyon</label>
                                        <div id="main_prop4" class="col col-12 col-xs-12">
                                            <select name="main_dt_properties" id="main_dt_properties">
                                                <option value="">Seçiniz</option>
                                                <cfif isDefined('attributes.main_properties') and len(attributes.main_properties)>
                                                    <cfoutput query="get_sub_properties">
                                                        <option value="#property_detail_id#" <cfif isDefined('attributes.main_dt_properties') and attributes.main_dt_properties eq property_detail_id>selected</cfif>>#property_detail#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </div>
                                    </div>
                                </cfif>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <cfif session.ep.isBranchAuthorization eq 0>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="zone_id" id="zone_id">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="sz">
                                                    <option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </cfif>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12" id="discount1" <cfif not (isdefined("attributes.is_discount") and attributes.is_discount eq 1 and attributes.report_type eq 19)>style="display:none;"</cfif>><cf_get_lang_main no='229.İskonto'></label>
                                        <div class="col col-12 col-xs-12" id="discount2" <cfif not (isdefined("attributes.is_discount") and attributes.is_discount eq 1 and attributes.report_type eq 19)>style="display:none;"</cfif>>
                                            <cfoutput>
                                                <select name="exp_discounts" id="exp_discounts" multiple>
                                                    <cfloop from="1" to="10" index="disc_indx">
                                                        <option value="#disc_indx#" <cfif listfind(attributes.exp_discounts,disc_indx,',')>selected</cfif>>&nbsp;&nbsp;<cf_get_lang_main no='229.İskonto'> #disc_indx#</option>
                                                    </cfloop>
                                                </select>
                                            </cfoutput>
                                        </div>
                                    </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='521.Müşteri Kategorisi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="member_cat_type" id="member_cat_type" multiple>
                                        <optgroup label="<cf_get_lang_main no='627.Kurumsal Üye Kategorileri'>">
                                            <cfoutput query="get_company_cat">
                                            <option value="1-#companycat_id#" <cfif listfind(attributes.member_cat_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
                                            </cfoutput>
                                        </optgroup>
                                        <optgroup label="<cf_get_lang_main no='628.Bireysel Üye Kategorileri'>">
                                            <cfoutput query="get_consumer_cat">
                                            <option value="2-#conscat_id#" <cfif listfind(attributes.member_cat_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;#conscat#</option>
                                            </cfoutput>
                                        </optgroup>
                                        </select>
                                    </div>
                                </div> 
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1351.Depo'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
                                            SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
                                        </cfquery>						
                                        <select name="department_id" id="department_id" multiple>
                                        <cfoutput query="get_department">
                                            <optgroup label="#department_head#">
                                            <cfquery name="GET_LOCATION" dbtype="query">
                                                SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #get_department.department_id[currentrow]# ORDER BY COMMENT
                                            </cfquery>
                                            <cfif get_location.recordcount>
                                                <cfloop from="1" to="#get_location.recordcount#" index="s">
                                                    <option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
                                                </cfloop>
                                            </cfif>
                                            </optgroup>					  
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='41.şube'></label>
                                    <div class="col col-12 col-xs-12">	
                                        <cfoutput>				
                                            <select name="branch_id" id="branch_id" multiple>
                                                <cfloop query="get_branch">
                                                <option value="#branch_id#"<cfif listfind(attributes.branch_id,branch_id)> selected</cfif>>#branch_name#</option>
                                                </cfloop>
                                            </select>
                                        </cfoutput>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
                                    <div class="col col-12 col-xs-12">
                                        <input type="hidden" name="process_type_select" id="process_type_select" value="<cfoutput>#attributes.process_type_select#</cfoutput>"/>
                                        <select name="process_type_" id="process_type_" multiple>
                                        <option value="670" <cfif listfind(attributes.process_type_select, 670)>selected</cfif>><cf_get_lang no='623.Yazar Kasa'></option>
                                        <option value="690" <cfif listfind(attributes.process_type_select, 690)>selected</cfif>><cf_get_lang_main no ='1026.Z Raporu'></option>
                                        <cfoutput query="get_process_cat">
                                            <option value="#process_cat_id#" <cfif listfind(attributes.process_type_,process_cat_id,',')>selected</cfif>>#process_cat#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1552.Fiyat Listesi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="price_catid" id="price_catid">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_price_cat">
                                            <option value="#price_catid#" <cfif attributes.price_catid eq price_catid> selected</cfif>>#price_cat#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div> 
                                <div class="form-group">
                                    <cfif isDefined('x_prod_prop_filter') and len(x_prod_prop_filter)>
                                        <label id="main_prop1" style="vertical-align:top;" class="col col-12 col-xs-12">Özellik</label>
                                            <div id="main_prop2" style="vertical-align:top;" class="col col-12 col-xs-12">
                                                <select name="main_properties" id="main_properties" onchange="get_sub_properties(this.value);">
                                                    <option value="">Seçiniz</option>
                                                    <cfoutput query="get_properties">
                                                        <option value="#property_id#" <cfif isDefined('attributes.main_properties') and attributes.main_properties eq property_id>selected</cfif>>#property#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        <cfelse>
                                    </cfif>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='503.İlişki Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_wrk_combo
                                        name="resource_id"
                                        query_name="GET_PARTNER_RESOURCE"
                                        option_name="resource"
                                        option_value="resource_id"
                                        value="#attributes.resource_id#"
                                        width="130">
                                    </div>			  
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="customer_value_id" id="customer_value_id">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="GET_CUSTOMER_VALUE_2">
                                            <option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value_id>selected</cfif>>#customer_value#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="report_type" id="report_type" onchange="degistir_report();">
                                            <option value="32" <cfif attributes.report_type eq 32>selected</cfif>><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'></option>
                                            <option value="19" <cfif attributes.report_type eq 19>selected</cfif>><cf_get_lang no ='964.Belge ve Stok Bazında'></option>
                                            <option value="28" <cfif attributes.report_type eq 28>selected</cfif>><cf_get_lang no ='1559.Fiyat Listesi Bazında'></option>
                                            <option value="15" <cfif attributes.report_type eq 15>selected</cfif>><cf_get_lang no='635.Hedef Pazar Bazında'></option>
                                            <option value="11" <cfif attributes.report_type eq 11>selected</cfif>><cf_get_lang no='631.İlişki Tipi Bazında'></option>
                                            <option value="16" <cfif attributes.report_type eq 16>selected</cfif>><cf_get_lang no='754.İl Bazında'></option>
                                            <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang no='331.Kategori Bazında'></option>
                                            <option value="9" <cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang no='374.Marka Bazında'></option>
                                            <cfif session.ep.isBranchAuthorization eq 0><option value="12" <cfif attributes.report_type eq 12>selected</cfif>><cf_get_lang no='632.Mikro Bölge Bazında'></option></cfif>
                                            <option value="38" <cfif attributes.report_type eq 38>selected</cfif>>Model Bazında</option>
                                            <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang no='536.Müşteri Bazında'></option>
                                            <option value="10" <cfif attributes.report_type eq 10>selected</cfif>><cf_get_lang no='538.Müşteri Değeri Bazında'></option>
                                            <option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang no='627.Müşteri Tipi Bazında'></option>
                                            <option value="41" <cfif attributes.report_type eq 41>selected</cfif>><cf_get_lang_main no='45.Müşteri'> ve <cf_get_lang no='331.Kategori Bazında'></option>
                                            <option value="21" <cfif attributes.report_type eq 21>selected</cfif>><cf_get_lang no ='1016.Müşteri Temsilcisi Bazında'></option>
                                            <option value="22" <cfif attributes.report_type eq 22>selected</cfif>><cf_get_lang no ='957.Mştr Temsilcisi ve Ürün Bazında'></option>
                                            <option value="23" <cfif attributes.report_type eq 23>selected</cfif>><cf_get_lang no='958.M Temsilcisi Müşteri ve Ürün Bazında'></option>
                                            <option value="40" <cfif attributes.report_type eq 40>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'> <cf_get_lang_main no='45.Müşteri'> ve <cf_get_lang no='331.Kategori Bazında'></option>
                                            <option value="29" <cfif attributes.report_type eq 29>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'><cf_get_lang_main no='577.ve'><cf_get_lang no ='1559.Fiyat Listesi Bazında'> </option>
                                            <option value="34" <cfif attributes.report_type eq 34>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'><cf_get_lang_main no='577.ve'><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'> </option>
                                            <option value="35" <cfif attributes.report_type eq 35>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'><cf_get_lang_main no='577.ve'><cf_get_lang no='331.Kategori Bazında'> </option>
                                            <option value="36" <cfif attributes.report_type eq 36>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'><cf_get_lang_main no='577.ve'><cf_get_lang no='627.Müşteri Tipi Bazında'> </option>
                                            <option value="39" <cfif attributes.report_type eq 39>selected</cfif>><cf_get_lang_main no='1383.Müşteri tem'> <cf_get_lang_main no='74.Kategori'><cf_get_lang_main no='577.ve'><cf_get_lang_main no ='807.Ülke Bazında'><cf_get_lang_main no='1189.Bazında'></option>
                                            <option value="14" <cfif attributes.report_type eq 14>selected</cfif>><cf_get_lang no='634.Ödeme Yontemi Bazında'></option>
                                            <option value="17" <cfif attributes.report_type eq 17>selected</cfif>><cf_get_lang_main no='2022.Proje Bazında'></option>
                                            <cfif session.ep.isBranchAuthorization eq 0><option value="20" <cfif attributes.report_type eq 20>selected</cfif>><cf_get_lang no ='965.Promosyon Bazında'></option></cfif>
                                            <option value="27" <cfif attributes.report_type eq 27>selected</cfif>><cf_get_lang no ='1558.Referans Kod Bazında'></option>
                                            <option value="25" <cfif attributes.report_type eq 25>selected</cfif>><cf_get_lang no ='1018.Satış Yapan,Müşteri ve Ürün Bazında'></option>
                                            <cfif session.ep.isBranchAuthorization eq 0><option value="13" <cfif attributes.report_type eq 13>selected</cfif>><cf_get_lang no='541.Satış Bölgesi Bazında'></option></cfif>
                                            <option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang no='630. Satış Yapan Bazında'></option>
                                            <option value="26" <cfif attributes.report_type eq 26>selected</cfif>><cf_get_lang no ='1557.Satış Ortağı Bazında'></option>
                                            <option value="33" <cfif attributes.report_type eq 33>selected</cfif>><cf_get_lang_main no ='167.Sektör'><cf_get_lang_main no='1189.Bazında'></option>
                                            <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang no='333.Stok Bazında'></option>
                                            <option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang no='629.Şube Bazında'></option>
                                            <option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang no='628.Tedarikçi Bazında'></option>
                                            <option value="31" <cfif attributes.report_type eq 31>selected</cfif>><cf_get_lang_main no ='807.Ülke Bazında'><cf_get_lang_main no='1189.Bazında'></option>
                                            <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
                                            <option value="30" <cfif attributes.report_type eq 30>selected</cfif>><cf_get_lang_main no ='245.Ürün'><cf_get_lang_main no='577.ve'><cf_get_lang no ='1559.Fiyat Listesi Bazında'></option>
                                            <option value="37" <cfif attributes.report_type eq 37>selected</cfif>><cf_get_lang no='1353.Ürün Grubu'><cf_get_lang_main no='1189.Bazında'></option>
                                            <option value="18" <cfif attributes.report_type eq 18>selected</cfif>><cf_get_lang_main no='1036.Ürün sorumlusu'><cf_get_lang_main no='1189.Bazında'></option>
											<option value="42" <cfif attributes.report_type eq 42>selected</cfif>><cfoutput>#getLang('product',976)#</cfoutput></option>
                                            <option value="24" <cfif attributes.report_type eq 24>selected</cfif>><cf_get_lang no ='1017.Vergi No Bazında'></option>
                                        </select>					
                                    </div>
                                </div>
                                <cfif session.ep.our_company_info.is_efatura>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="use_efatura" id="use_efatura">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang_main no='1695.Kullanıyor'></option>
                                                <option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang_main no='1696.Kullanmıyor'></option>
                                            </select>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='49450.Grafik'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="graph_type" id="graph_type">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <option value="radar" <cfif attributes.graph_type eq 'radar'> selected</cfif>>Radar</option>
                                            <option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang_main no='1316.Pasta'></option>
                                            <option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
                                        <cfsavecontent variable="message1"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no ='641.Başlangıç Tarihi'></cfsavecontent>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" required="yes" message="#message1#" validate="#validate_style#">
                                            <cfif not isdefined('attributes.ajax')> 
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                            </cfif>           
                                        </div>
                                    </div>
                                    <div class="col col-6">
                                        <div class="input-group">                                   
                                                <cfsavecontent variable="message2"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no ='288.Bitiş Tarihi'></cfsavecontent>
                                                <cfinput type="text" name="date2" id="date2" value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" required="yes" message="#message2#" validate="#validate_style#">
                                            <cfif not isdefined('attributes.ajax')>
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                                            </cfif>    
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang no='334.Rapor Sıra'></label>
                                    <div class="col col-12 col-xs-12">
                                        <label><cf_get_lang no='640.Ciro ya Göre'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1>checked</cfif>></label>
                                        <label><cf_get_lang no='959.Net Kâra Göre'><input type="radio" name="report_sort" id="report_sort" value="3"  <cfif attributes.report_sort eq 3>checked</cfif>></label>
                                        <label><cf_get_lang no='641.Miktara Göre'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2>checked</cfif>></label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <label><cf_get_lang no='638.Bedava Promosyonları Say'><input name="is_prom" id="is_prom" value="1" type="checkbox" <cfif attributes.is_prom eq 1 >checked</cfif>></label>
                                        <label><cf_get_lang no ='1019.Sadece Satıştaki Ürünler'><input name="is_sale_product" id="is_sale_product" value="1" type="checkbox" <cfif isdefined("attributes.is_sale_product")>checked</cfif>></label>
                                        <label><cf_get_lang no='647.İskonto Göster'><input name="is_discount" id="is_discount" value="1" onclick="show_discount();" type="checkbox" <cfif attributes.is_discount eq 1>checked</cfif>></label>
                                        <label><cf_get_lang no='338.KDV Dahil'><input name="is_kdv" id="is_kdv" value="1" type="checkbox" <cfif attributes.is_kdv eq 1 >checked</cfif>></label>
                                        <label <cfif attributes.report_type neq 19>style="display:none;"</cfif> id="is_priceless_page"><cf_get_lang no ='1560.Mal Fazlası Göster'><input name="is_priceless" id="is_priceless" value="1" type="checkbox" <cfif attributes.is_priceless eq 1 >checked</cfif>></label>
                                        <label <cfif attributes.report_type neq 29>style="display:none;"</cfif> id="is_price_change_page"><cf_get_lang no ='1561.Düşük Fiyatlar Gelmesin'><input name="is_price_change" id="is_price_change" value="1" type="checkbox" <cfif attributes.is_price_change eq 1 >checked</cfif>></label>
                                        <label <cfif attributes.report_type neq 19>style="display:none;"</cfif>  id="is_project"><cf_get_lang_main no='4.Proje'> <cf_get_lang_main no='1184.Göster'><input name="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked</cfif>></label>
                                        <label><input type="checkbox" name="is_other_money" id="is_other_money" value="1" <cfif attributes.is_other_money eq 1>checked</cfif> onclick="dissable_check(1);"><cf_get_lang_main no='383.İşlem Dovizli'></label>
                                        <cfif isdefined("session.ep.money2")><label><cf_get_lang_main no='1184.Göster'><input name="is_money2" id="is_money2" value="1" type="checkbox" onclick="dissable_check(2);" <cfif attributes.is_money2 eq 1>checked</cfif>><cfoutput>#session.ep.money2#</cfoutput></label></cfif>
                                        <cfif session.ep.cost_display_valid eq 0>
                                            <label <cfif attributes.report_type neq 19>style="display:none;"</cfif> id="is_cost_page"><cf_get_lang no='365.Maliyet Göster'><input type="checkbox" name="is_cost_price" id="is_cost_price" value="1" <cfif attributes.is_cost_price eq 1 >checked</cfif>></label>
                                        <cfelse>
                                            <div id="is_cost_page"></div>
                                        </cfif>
                                        <label style="<cfif attributes.report_type neq 19>display:none;</cfif>" id="spect_info_2"><cf_get_lang no='1889.Spec Göster'><input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif attributes.is_spect_info eq 1>checked</cfif>></label>
										<label><cf_get_lang no='687.Karlılık'><input type="checkbox" name="is_profit" id="is_profit" value="1" <cfif attributes.is_profit eq 1 >checked</cfif>></label>
                                        <cfif not session.ep.cost_display_valid>                                        
											<cfif get_cost_type.inventory_calc_type eq 3>
												<label><cf_get_lang no='960.Kayıtlı Maliyetlerden'><input type="checkbox" name="cost_type" id="cost_type" onclick="change_cost();" value="1" <cfif isdefined('attributes.cost_type')>checked</cfif>></label>
											</cfif>
											<div id="location_cost">
												<cfif get_cost_type.inventory_calc_type eq 3>
													<label><cf_get_lang no='66.Lokasyon Bazında Maliyet'><input type="checkbox" name="is_location_cost" id="is_location_cost" value="1" <cfif isdefined('attributes.is_location_cost')>checked</cfif>></label>
												</cfif>
											</div>
                                        </cfif>
                                        <label><cf_get_lang no='961.Zarar Edenler'><input type="checkbox" name="negative_product" id="negative_product" value="1" <cfif isdefined('attributes.negative_product')>checked</cfif>></label>
                                        <label><cf_get_lang no ='121.Sıfır Tutarlı Faturalar Dahil'><input type="checkbox" name="is_zero_value" id="is_zero_value" value="1" <cfif isdefined("attributes.is_zero_value")>checked</cfif>></label>
                                        <label id="model_month_td" <cfif isdefined("attributes.report_type") and attributes.report_type neq 38>style="display:none;"</cfif>><cf_get_lang dictionary_id='33509.Modelleri Satır Olarak Listele'><input type="checkbox" name="model_month" id="model_month" value="0" <cfif isdefined("attributes.model_month")>checked</cfif>/></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>       
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
                            <input type="hidden" name="form_submitted" id="form_submitted" value="">
                            <cf_wrk_report_search_button button_type='1' is_excel='1' search_function='satir_kontrol()'>
                        </div>
                    </div>
                </div>
            </div>
            <cfif isdefined("attributes.form_submitted") and not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
                <cf_seperator title="#getLang('main',388)#" id="transaction_type">
                <table class="color-border" width="100%" cellpadding="2" cellspacing="1" style="display:none;" id="transaction_type">
                    <tr class="color-row">
                        <td valign="top" nowrap="nowrap" style="width:400px;">
                            <cfif listfind(attributes.process_type_, 670)><cf_get_lang no='623.Yazar Kasa'><br></cfif>
                            <cfif listfind(attributes.process_type_, 690)><cf_get_lang_main no ='1026.Z Raporu'><br></cfif>
                            <cfif len(attributes.process_type_)>
                                <cfquery name="get_process_cat" datasource="#DSN3#">
                                    SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_#" list="yes">) AND PROCESS_TYPE IN (50,52,53,531,532,56,58,62,561,54,55,51,63,48,49,533,5311) ORDER BY PROCESS_CAT
                                </cfquery>
                            <cfelse>
                                <cfset get_process_cat.recordcount = 0>
                            </cfif>
                            <cfif get_process_cat.recordcount>
                                <cfoutput query="get_process_cat">#process_cat#<br></cfoutput>
                            </cfif>
                        </td>
                    <cfif len(attributes.department_id)>
                        <td valign="top" style="width:400px;">
                            <b><cf_get_lang_main no='1351.Depo'></b><br /><br />
                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                <cfquery name="GET_LOCATION" dbtype="query">
                                    SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">
                                </cfquery>
                                <cfoutput>#get_location.comment#<br></cfoutput>			
                            </cfloop> 					  
                        </td>
                    </cfif>
                    <cfif len(attributes.member_cat_type)>
                        <td valign="top" style="width:400px;">
                            <b><cf_get_lang no='521.Müşteri Kategorisi'></b><br /><br />
                            <cfif len(kurumsal)>
                                <cfquery name="GET_COMPANY_CAT_MAIN" dbtype="query">
                                    SELECT COMPANYCAT FROM GET_COMPANY_CAT WHERE COMPANYCAT_ID IN (#kurumsal#) ORDER BY COMPANYCAT
                                </cfquery>
                                <cfoutput query="get_company_cat_main">#companycat#<br></cfoutput><br>
                            </cfif>
                            <cfif len(bireysel)>
                                <cfquery name="GET_CONSUMER_CAT_MAIN" dbtype="query">
                                    SELECT CONSCAT FROM GET_CONSUMER_CAT WHERE CONSCAT_ID IN (#bireysel#) ORDER BY CONSCAT
                                </cfquery>
                                <cfoutput query="get_consumer_cat_main">#conscat#<br></cfoutput>
                            </cfif>                                
                        </td>
                    </cfif>                           
                        <td valign="top" style="width:400px;"><cf_get_lang_main no='1548.Rapor Tipi'>:
                            <cfif attributes.report_type eq 1><cf_get_lang no='331.Kategori Bazında'>
                            <cfelseif attributes.report_type eq 2><cf_get_lang no='332.Ürün Bazında'>
                            <cfelseif attributes.report_type eq 3><cf_get_lang no='333.Stok Bazında'>
                            <cfelseif attributes.report_type eq 4><cf_get_lang no='536.Müşteri Bazında'>
                            <cfelseif attributes.report_type eq 24><cf_get_lang no ='1017.Vergi No Bazında'>
                            <cfelseif attributes.report_type eq 5><cf_get_lang no='627.Müşteri Tipi Bazında'>
                            <cfelseif attributes.report_type eq 41><cf_get_lang_main no='45.Müşteri'> ve <cf_get_lang no='331.Kategori Bazında'>
                            <cfelseif attributes.report_type eq 21><cf_get_lang no ='1016.Müşteri Temsilcisi Bazında'>
                            <cfelseif attributes.report_type eq 22><cf_get_lang no='957.M  Temisilcisi ve Ürün Bazında'>
                            <cfelseif attributes.report_type eq 23><cf_get_lang no='958.M Temsilcisi Müşteri ve Ürün Bazında'>
                            <cfelseif attributes.report_type eq 40>M.Temsilcisi <cf_get_lang_main no='45.Müşteri'> ve <cf_get_lang no='331.Kategori Bazında'>
                            <cfelseif attributes.report_type eq 6><cf_get_lang no='628.Tedarikçi Bazında'>
                            <cfelseif attributes.report_type eq 7><cf_get_lang no='629.Şube Bazında'>
                            <cfelseif attributes.report_type eq 8><cf_get_lang no='630.Satış Yapan Bazında'>
                            <cfelseif attributes.report_type eq 9><cf_get_lang no='374.Marka Bazında'>
                            <cfelseif attributes.report_type eq 10><cf_get_lang no='538.Müşteri Değeri Bazında'>
                            <cfelseif attributes.report_type eq 11><cf_get_lang no='631.İlişki Tipi Bazında'>
                            <cfelseif attributes.report_type eq 12><cf_get_lang no='632.Mikro Bölge Bazında'>
                            <cfelseif attributes.report_type eq 13><cf_get_lang no='541.Satış Bölgesi Bazında'>
                            <cfelseif attributes.report_type eq 14><cf_get_lang no='653.Ödeme Yöntemi Bazında'>
                            <cfelseif attributes.report_type eq 15><cf_get_lang no='635.Hedef Pazar Bazında'>
                            <cfelseif attributes.report_type eq 16><cf_get_lang no='754.İl Bazında'>
                            <cfelseif attributes.report_type eq 17><cf_get_lang_main no='2022.Proje Bazında'>
                            <cfelseif attributes.report_type eq 18><cf_get_lang_main no='1036.Ürün sorumlusu'><cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 19><cf_get_lang no='964.Belge ve Stok Bazında'>
                            <cfelseif attributes.report_type eq 25><cf_get_lang no ='1018.Satış Yapan,Müşteri ve Ürün Bazında'>
                            <cfelseif attributes.report_type eq 26><cf_get_lang no ='1557.Satış Ortağı Bazında'>
                            <cfelseif attributes.report_type eq 27><cf_get_lang no ='1558.Referans Kod Bazında'>
                            <cfelseif attributes.report_type eq 28><cf_get_lang no ='1559.Fiyat Listesi Bazında'>
                            <cfelseif attributes.report_type eq 29><cf_get_lang_main no='1383.Müşteri Temsilcisi'><cf_get_lang_main no='577.ve'><cf_get_lang no ='1559.Fiyat Listesi Bazında'>
                            <cfelseif attributes.report_type eq 30><cf_get_lang_main no ='245.Ürün'><cf_get_lang_main no='577.ve'><cf_get_lang no ='1559.Fiyat Listesi Bazında'>
                            <cfelseif attributes.report_type eq 31><cf_get_lang_main no ='807.Ülke Bazında'><cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 32><cf_get_lang no ='1835.Ana Kategori'><cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 33><cf_get_lang_main no ='167.Sektör'><cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 34>M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 35>M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='331.Kategori Bazında'>
                            <cfelseif attributes.report_type eq 36>M.Temsilcisi<cf_get_lang_main no='577.ve'><cf_get_lang no='627.Müşteri Tipi Bazında'>
                            <cfelseif attributes.report_type eq 37>Ürün Grubu<cf_get_lang_main no='1189.Bazında'>
                            <cfelseif attributes.report_type eq 42><cfoutput>#getLang('product',976)#</cfoutput>
                            <cfelseif attributes.report_type eq 39>M.Temsilcisi Kategori<cf_get_lang_main no='577.ve'><cf_get_lang_main no ='807.Ülke Bazında'><cf_get_lang_main no='1189.Bazında'>
                            </cfif>
                            <cfif attributes.is_kdv eq 1><cf_get_lang no='338.KDV Dahil'></cfif><hr>
                            <cf_get_lang_main no='74.Kategori'>:<cfoutput>#attributes.product_cat#</cfoutput><hr>
                            <cf_get_lang_main no='45.Müşteri'>:<cfoutput>#attributes.company#</cfoutput><hr>
                            <cf_get_lang_main no='1383.Müşteri Temsilcisi'>:<cfoutput>#attributes.pos_code_text#</cfoutput>
                        </td>
                        <cfoutput>
                        <td valign="top" style="width:400px;">
                            <cf_get_lang_main no='330.Tarih'>:#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#<hr>
                            <cf_get_lang_main no='245.Ürün'>:#attributes.product_name#<cfif isdefined("attributes.list_area_name")>#attributes.list_area_name#</cfif><hr>
                            <cf_get_lang_main no='1435.Marka'>:#left(attributes.BRAND_NAME,50)#<hr>
                            <cf_get_lang_main no='1036.Ürün Sorumlu'>:#attributes.employee_name#
                        </td>
                        <td valign="top"  style="width:400px;">
                            <cf_get_lang no='334.Rapor Sıra'>:<cfif attributes.report_sort eq 1><cf_get_lang_main no='2213.Ciro'><cfelseif attributes.report_sort eq 2><cf_get_lang_main no='223.Miktar'><cfelse><cf_get_lang no ='832.Kar'></cfif><hr>
                            <cf_get_lang_main no='1736.Tedarikçi'>:#attributes.sup_company#<hr>
                            <cf_get_lang no='643.Satışı Yapan'>:#attributes.employee#<hr>
                            <cf_get_lang no='649.Hedef Pazar'>:
                            <cfif len(attributes.segment_id) and listfind(list_segment_ids,attributes.segment_id,',')>
                                #GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,attributes.segment_id,',')]#
                            </cfif>
                        </td>
                        </cfoutput>
                    </tr>
                </table>
            </cfif>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<!--- 
<cfset filename="sale_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="application/vnd.msexcel;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
<meta http-equiv="content-type" content="text/plain; charset=utf-8">--->
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset type_ = 1 >
<cfelse>
    <cfset type_ = 0 >
</cfif> 
<div id="sales_list">
    <cfif isdefined("attributes.form_submitted")>
        <cfif isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
            <cfloop from="1" to="10" index="disc_indx_nw">
                <cfset "total_discount_#disc_indx_nw#" = 0>
            </cfloop>
        </cfif> 
            <cf_report_list>
                <cfparam name="attributes.page" default=1>
                <cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
                    <cfset attributes.startrow=1>
                    <cfset attributes.maxrows=get_total_purchase.recordcount>
                </cfif>
                <cfset company_list = ''>
                <cfset consumer_list = ''>
                <cfset partner_list = ''>
                <cfset price_cat_list = ''>
                <cfset country_id_list = ''>
                <cfset branch_id_list = ''>
                <cfset branch_id_list2 = ''>
                <cfset musteri_city_list = ''>
				<cfset brand_id_list_new=''>
             	<cfset short_code_id_list=''>
     
               <cfif get_total_purchase.recordcount and ListFind("2,3,19",attributes.report_type,",")>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif attributes.report_type eq 19>
							<cfif len(company_id) and company_id gt 0 and not listfind(company_list,company_id)>
								<cfset company_list = listappend(company_list,company_id)>
							</cfif>	
							<cfif len(consumer_id) and consumer_id gt 0 and not listfind(consumer_list,consumer_id)>
								<cfset consumer_list = listappend(consumer_list,consumer_id)>
							</cfif>	
							<cfif len(price_cat) and not listfind(price_cat_list,price_cat)>
								<cfset price_cat_list = listappend(price_cat_list,price_cat)>
							</cfif>
							<cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1>
								<cfif len(department_id) and not listfind(branch_id_list,department_id)>
									<cfset branch_id_list = listappend(branch_id_list,department_id)>
								</cfif>
							</cfif>
							<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
								<cfif len(order_branch_id) and not listfind(branch_id_list2,order_branch_id)>
									<cfset branch_id_list2 = listappend(branch_id_list2,order_branch_id)>
								</cfif>
							</cfif>
						</cfif>
						<cfif len(brand_id) and not listfind(brand_id_list_new,brand_id)>
							<cfset brand_id_list_new=listappend(brand_id_list_new,brand_id)>
						</cfif>
						<cfif len(short_code_id) and not listfind(short_code_id_list,short_code_id)>
							<cfset short_code_id_list=listappend(short_code_id_list,short_code_id)>
						</cfif>
                    </cfoutput>
					<cfif len(brand_id_list_new) and is_brand_show eq 1>
						<cfset brand_id_list_new=listsort(brand_id_list_new,"numeric","ASC",",")>
						<cfquery name="get_brand" datasource="#DSN1#">
							SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list_new#) ORDER BY BRAND_ID
						</cfquery>
						<cfset brand_id_list_new = listsort(listdeleteduplicates(valuelist(get_brand.BRAND_ID,',')),"numeric","ASC",",")>
					</cfif>
					<cfif len(short_code_id_list) and is_short_code_show eq 1>
						<cfset short_code_id_list=listsort(short_code_id_list,"numeric","ASC",",")>
						<cfquery name="get_model" datasource="#DSN1#">
							SELECT MODEL_NAME,MODEL_ID FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID IN (#short_code_id_list#) ORDER BY MODEL_ID
						</cfquery>
						<cfset short_code_id_list = listsort(listdeleteduplicates(valuelist(get_model.MODEL_ID,',')),"numeric","ASC",",")>
					</cfif>
                <cfelseif get_total_purchase.recordcount and attributes.report_type eq 26>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(sales_member_id) and sales_member_type eq 1 and not listfind(partner_list,sales_member_id)>
                            <cfset partner_list = listappend(partner_list,sales_member_id)>
                        </cfif>	
                        <cfif len(sales_member_id) and sales_member_type eq 2 and not listfind(consumer_list,sales_member_id)>
                            <cfset consumer_list = listappend(consumer_list,sales_member_id)>
                        </cfif>		
                    </cfoutput>
                <cfelseif get_total_purchase.recordcount and listfind('28,29,30',attributes.report_type)>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(price_cat) and not listfind(price_cat_list,price_cat)>
                            <cfset price_cat_list = listappend(price_cat_list,price_cat)>
                        </cfif>	
                    </cfoutput>
                <cfelseif get_total_purchase.recordcount and listfind('31',attributes.report_type)>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(country_id) and not listfind(country_id_list,country_id)>
                            <cfset country_id_list = listappend(country_id_list,country_id)>
                        </cfif>	
                    </cfoutput>
                <cfelseif get_total_purchase.recordcount and listfind('4',attributes.report_type)>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(musteri_city) and not listfind(musteri_city_list,musteri_city)>
                            <cfset musteri_city_list = listappend(musteri_city_list,musteri_city)>
                        </cfif>	
                    </cfoutput>
                </cfif>
                <cfif attributes.report_type eq 19>
                    <cfif len(company_list)>
                        <cfset company_list=listsort(company_list,"numeric","ASC",",")>
                        <cfquery name="get_pos_name" datasource="#DSN#">
                            SELECT
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                WEB.COMPANY_ID,
                                WEB.POSITION_CODE
                            FROM
                                WORKGROUP_EMP_PAR WEB,
                                EMPLOYEE_POSITIONS
                            WHERE
                                WEB.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
                                WEB.COMPANY_ID IN (#company_list#) AND
                                WEB.COMPANY_ID IS NOT NULL AND
                                WEB.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                WEB.IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                            ORDER BY 
                                WEB.COMPANY_ID
                        </cfquery>
                        <cfset company_list = listsort(listdeleteduplicates(valuelist(get_pos_name.company_id,',')),'numeric','ASC',',')>
                    </cfif> 
                    <cfif len(consumer_list)>
                        <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
                        <cfquery name="get_pos_name_2" datasource="#DSN#">
                            SELECT
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                WEB.CONSUMER_ID,
                                WEB.POSITION_CODE
                            FROM
                                WORKGROUP_EMP_PAR WEB,
                                EMPLOYEE_POSITIONS
                            WHERE
                                WEB.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND
                                WEB.CONSUMER_ID IN (#consumer_list#) AND
                                WEB.CONSUMER_ID IS NOT NULL AND
                                WEB.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                                WEB.IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                            ORDER BY 
                                WEB.COMPANY_ID
                        </cfquery>
                        <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_pos_name_2.consumer_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(price_cat_list)>
                        <cfset price_cat_list=listsort(price_cat_list,"numeric","ASC",",")>
                        <cfquery name="get_price_cat" datasource="#DSN3#">
                            SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN (#price_cat_list#) ORDER BY PRICE_CATID
                        </cfquery>
                        <cfset price_cat_list = listsort(listdeleteduplicates(valuelist(get_price_cat.price_catid,',')),'numeric','ASC',',')>
                    </cfif>	
                    <cfif ListLen(branch_id_list)>
                        <cfset branch_id_list = ListSort(branch_id_list,"numeric","asc",",")>
                        <cfquery name="get_invoice_branch" datasource="#DSN#">
                            SELECT D.DEPARTMENT_ID,B.BRANCH_ID,B.BRANCH_NAME FROM BRANCH B, DEPARTMENT D WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID IN (#branch_id_list#) ORDER BY D.DEPARTMENT_ID
                        </cfquery>
                        <cfset branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_invoice_branch.department_id,',')),"numeric","asc",",")>
                    </cfif>
                    <cfif ListLen(branch_id_list2)>
                        <cfset branch_id_list2 = ListSort(branch_id_list2,"numeric","asc",",")>
                        <cfquery name="get_invoice_branch2" datasource="#DSN#">
                            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list2#) ORDER BY BRANCH_ID
                        </cfquery>
                        <cfset branch_id_list2 = ListSort(ListDeleteDuplicates(ValueList(get_invoice_branch2.branch_id,',')),"numeric","asc",",")>
                    </cfif>
                <cfelseif attributes.report_type eq 26>
                    <cfif len(partner_list)>
                        <cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
                        <cfquery name="get_partner_name" datasource="#DSN#">
                            SELECT
                                CP.COMPANY_PARTNER_NAME,
                                CP.COMPANY_PARTNER_SURNAME,
                                CP.PARTNER_ID,
                                C.NICKNAME,
                                C.COMPANY_ID
                            FROM
                                COMPANY_PARTNER CP,
                                COMPANY C
                            WHERE
                                CP.COMPANY_ID = C.COMPANY_ID AND
                                CP.PARTNER_ID IN (#partner_list#)
                            ORDER BY 
                                CP.PARTNER_ID
                        </cfquery>
                        <cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partner_name.partner_id,',')),'numeric','ASC',',')>
                    </cfif> 
                    <cfif len(consumer_list)>
                        <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
                        <cfquery name="get_consumer_name" datasource="#DSN#">
                            SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
                        </cfquery>
                        <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
                    </cfif>	
                <cfelseif listfind('28,29,30',attributes.report_type)>
                    <cfif len(price_cat_list)>
                        <cfset price_cat_list=listsort(price_cat_list,"numeric","ASC",",")>
                        <cfquery name="get_price_cat" datasource="#DSN3#">
                            SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN (#price_cat_list#) ORDER BY PRICE_CATID
                        </cfquery>
                        <cfset price_cat_list = listsort(listdeleteduplicates(valuelist(get_price_cat.price_catid,',')),'numeric','ASC',',')>
                    </cfif>
                <cfelseif listfind('31',attributes.report_type)>
                    <cfif len(country_id_list)>
                        <cfset country_id_list=listsort(country_id_list,"numeric","ASC",",")>
                        <cfquery name="get_country" datasource="#DSN#">
                            SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id_list#) ORDER BY COUNTRY_ID
                        </cfquery>
                        <cfset country_id_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
                    </cfif>	
                <cfelseif attributes.report_type eq 4>
                    <cfif ListLen(musteri_city_list)>
                        <cfset musteri_city_list=listsort(musteri_city_list,"numeric","ASC",",")>
                        <cfquery name="get_musteri_city" datasource="#DSN#">
                            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#musteri_city_list#) ORDER BY CITY_ID
                        </cfquery>
                        <cfset musteri_city_list = listsort(listdeleteduplicates(valuelist(get_musteri_city.city_id,',')),'numeric','ASC',',')>
                    </cfif>
                </cfif>
                <cfif attributes.page neq 1 and not isdefined('attributes.ajax')><!--- Alt toplama kümülatif raporlarda ihtiyacımız yok. --->
                    <cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
                        <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>   
                        <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                        <cfif isdefined("GROSSTOTAL_DOVIZ") and len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                        <cfif isdefined("PRICE_DOVIZ") and len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 				
                        <cfif isdefined("PRICE_DOVIZ") and  isdefined("GROSSTOTAL_DOVIZ") and len(GROSSTOTAL_DOVIZ) and len(PRICE_DOVIZ)><cfset toplam_isk_doviz = GROSSTOTAL_DOVIZ-PRICE_DOVIZ+toplam_isk_doviz></cfif> 						
                        <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                        <cfif isdefined("NET_KAR_DOVIZ") and len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                        <cfif len(GROSSTOTAL) and len(PRICE)><cfset toplam_isk_tutar = GROSSTOTAL-PRICE+toplam_isk_tutar></cfif> 	
                        <cfif listfind('2,3,19',attributes.report_type)>
                            <cfif len(PRODUCT_STOCK)>
								<cfset unit_ = filterSpecialChars(birim)>
                                <cfif birim is 'Kilogram'>
                                    <cfset toplam_Kilogram=toplam_Kilogram+PRODUCT_STOCK>
                                <cfelse>
                                    <cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') +PRODUCT_STOCK>	
                                </cfif>
                            </cfif>
                        <cfelse>
                            <cfif isdefined('PRODUCT_STOCK') and len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif> 
                        </cfif>
                        <cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
                            <cfif len(priceless_amount)>
                                <cfset toplam_bedelsiz = toplam_bedelsiz + priceless_amount>
                            </cfif>
                        </cfif>
                        <cfif attributes.report_type eq 19 and attributes.is_cost_price eq 1>
                            <cfif not len(cost_price)><cfset row_cost_price= 0><cfelse><cfset row_cost_price= cost_price></cfif>
                            <cfif not len(cost_price_2)><cfset row_cost_price_2= 0><cfelse><cfset row_cost_price_2= cost_price_2></cfif>
                            <cfif not len(margin)><cfset row_margin= 0><cfelse><cfset row_margin= margin></cfif>
                            <cfset toplam_cost_price=toplam_cost_price+row_cost_price>
                            <cfset toplam_cost_price_all=toplam_cost_price_all+(row_cost_price*PRODUCT_STOCK)>
                            <cfset toplam_cost_price_2=toplam_cost_price_2+row_cost_price_2>
                            <cfset toplam_cost_price_all_2=toplam_cost_price_all_2+(row_cost_price_2*PRODUCT_STOCK)>
                            <cfset toplam_marj_all=toplam_marj_all+(row_margin*row_cost_price*PRODUCT_STOCK/100)>
                        </cfif>
                        <cfif attributes.report_type eq 19>
                            <cfif product_stock neq 0>
                                <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row/product_stock)>
                            <cfelse>
                                <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row)>
                            </cfif>
                        </cfif>
                    </cfoutput>				  
                </cfif>
                <cfif (attributes.report_type eq 1 or attributes.report_type eq 32)>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang no='657.Kategori Kod'></th>
                            <th class="txtbold" height="22"><cf_get_lang_main no='74.Kategori'></th>
                            <th class="txtbold" height="22"><cf_get_lang_main no='223.Miktar'></th>
                            <th class="txtbold" height="22"><cf_get_lang_main no='224.Birim'></th>
                            <cfif x_show_second_unit>
                            	<th class="txtbold" height="22">2.<cf_get_lang_main no='223.Miktar'></th>
                                <th class="txtbold" height="22"><cf_get_lang_main no='2318.Birim'></th>
                            </cfif>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                                <th class="txtbold"><cf_get_lang no ='1333.Sapma'></th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                    <th class="txtbold"><cf_get_lang no ='1333.Sapma'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                        <tbody>
                            <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                    <td style="mso-number-format:\@;">#HIERARCHY#</td>
                                    <td>#PRODUCT_CAT#</td>
                                    <td style="text-align:right;">
                                        <cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif>
                                        <cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
                                        <cfif len(PRODUCT_STOCK)>
                                            <cfset unit_ = filterSpecialChars(birim)>
                                            <cfset 'toplam_#unit_#' = evaluate('toplam_miktar_#unit_#') + PRODUCT_STOCK>
                                    </cfif>
                                    </td>                            
                                    <td style="text-align:right;">#BIRIM#</td>
                                    <cfif x_show_second_unit>
                                        <td style="text-align:right;">
                                            <cfif isdefined("AMOUNT2") and len(AMOUNT2)>
                                                <cfset toplam_multiplier = toplam_multiplier + (AMOUNT2)>
                                                #TLFormat(AMOUNT2,4)#
                                            </cfif>
                                        </td>
                                        <cfif len(BIRIM2)><cfset unit2_list = listappend(unit2_list,BIRIM2)></cfif>
                                        <td style="text-align:right;">#BIRIM2#</td>                            
                                    </cfif>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                                        </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif><cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;">
                                            <cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                            <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 	
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;">
                                            <cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                            <cfif len(NET_KAR)> <cfset toplam_karlilik=NET_KAR+toplam_karlilik></cfif> 
                                        </td> 
                                        <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                        <td style="text-align:right;"><cfif PRICE neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR*100)/PRICE,2)#<cfelse>#TLFormat((NET_KAR*100)/PRICE,5)#</cfif></cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                        <td style="text-align:right;">
                                            <cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>						
                                            <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz=GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                        </td>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                            <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                            <cfif attributes.is_other_money eq 1>
                                                <cfif ArrayLen(StructFindValue(rapor.money_array["money_type"],other_money,'all')) eq 0>
                                                    <cfset money_type_counter++>
                                                    <cfset rapor.money_array["money_type"][money_type_counter] = other_money>
                                                    <cfset money_total = 0.0>
                                                    <cfset mny_type = StructFindValue(rapor.money_array["money_type"],other_money)>
                                                    <cfset rapor.money_array["money_total"][mny_type[1].key] = 0>   
                                                </cfif>
                                                    <cfset mny_type = StructFindValue(rapor.money_array["money_type"],other_money)>
                                                    <cfset money_total = rapor.money_array["money_total"][mny_type[1].key]>
                                                    <cfset money_total += PRICE_DOVIZ>
                                                    <cfset rapor.money_array["money_total"][mny_type[1].key] = money_total>
                                            </cfif>
                                        </td>
                                        <cfif attributes.is_discount eq 1>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                                <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                            </td>
                                        </cfif>
                                        <cfif attributes.is_profit eq 1>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                                <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                            </td>
                                            <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                            <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#<cfelse>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,5)#</cfif></cfif></td>
                                        </cfif>
                                        <td style="text-align:center;width:60px;">
                                        <cfif attributes.is_other_money eq 1>#other_money#
                                        <cfelse>#session.ep.money2#</cfif>
                                        </td>
                                    </cfif>
                                    <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif listfind('2,3',attributes.report_type,',')>
                    <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                         <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfinclude template="../../settings/cumulative/cumulative_sales_analyse_inc.cfm">
                        </cfoutput>
                        <cfif get_total_purchase.recordcount gte (attributes.startrow+attributes.maxrows)>
                            <script type="text/javascript">
                                user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/get_total_purchase.recordcount)#</cfoutput>);
                            </script>
                        <cfelse>
                            <script type="text/javascript">
                                user_info_show_div(1,1,1);
                            </script>
                            <cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
                                UPDATE 
                                    REPORT_SYSTEM 
                                SET 
                                    PROCESS_FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                    PROCESS_ROW_COUNT = (SELECT COUNT(SALES_PRODUCT_MONTH_ID) FROM SALES_PRODUCT_MONTH WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#">)
                                WHERE 
                                    REPORT_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="SALES_PRODUCT_MONTH"> AND
                                    PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND 
                                    PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#"> AND 
                                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#">
                            </cfquery>
                        </cfif>
                        <cfabort>
                    <cfelse>
                        <thead>
                            <tr>
                                <th class="txtbold"><cf_get_lang no='657.Kategori Kod'></th>
                                <th class="txtbold"><cf_get_lang_main no='74.Kategori'></th>
                                <cfif attributes.report_type eq 3 and isdefined("x_show_special_code") and x_show_special_code eq 1><th class="txtbold"><cf_get_lang_main no='377.Özel Kod'></th></cfif>
                                <th class="txtbold"><cf_get_lang_main no='1388.Ürün Kod'></th>
                                <th class="txtbold"><cf_get_lang_main no='221.Barkod'></th>
                                <th class="txtbold"><cf_get_lang_main no='245.Ürün'> </th>
								<cfif is_brand_show eq 1><th><cf_get_lang_main no='1435.Marka'></th></cfif>
								<cfif is_short_code_show eq 1><th><cf_get_lang_main no='813.Model'></th></cfif>
                                <th class="txtbold"><cf_get_lang no ='1562.Marj'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                                <th width="100" class="txtbold" style="text-align:right;">2.<cf_get_lang_main no='223.Miktar'></th>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='224.Birim'></th>
                                <cfif x_unit_weight eq 1>
	                                <th width="100" class="txtbold" style="text-align:right;">Ağırlık</th>
                                </cfif>
                                <cfif x_show_second_unit>
                                    <th width="100" class="txtbold" style="text-align:right;">2. Birim <cf_get_lang_main no='223.Miktar'></th>
                                    <th style="text-align:center;width:60px;" class="txtbold">2. <cf_get_lang_main no='224.Birim'></th>
                                </cfif>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                    <th style="text-align:right;">%</th>
                                    <th class="txtbold"><cf_get_lang no ='1333.Sapma'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                    <cfif attributes.is_discount eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                        <th style="text-align:right;">%</th>
                                        <th class="txtbold"><cf_get_lang no ='1333.Sapma'></th>
                                    </cfif>
                                    <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                </cfif>
                                <th width="35" class="txtbold" style="text-align:right;">%</th>
                            </tr>
                        </thead>
                        <cfif get_total_purchase.recordcount>
                            <tbody>
                                <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                                        <td style="mso-number-format:\@;">#HIERARCHY#</td>
                                        <td>#PRODUCT_CAT#</td>
                                        <cfif attributes.report_type eq 3 and isdefined("x_show_special_code") and x_show_special_code eq 1><td>#STOCK_CODE_2#</td></cfif>
                                        <td style="mso-number-format:\@;"><cfif attributes.report_type eq 2>#PRODUCT_CODE#<cfelse>#STOCK_CODE#</cfif></td>
                                        <td>#BARCOD#</td>
                                        <td><cfif attributes.report_type eq 2>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">#PRODUCT_NAME#</a>
                                            <cfelse>
                                                #PRODUCT_NAME#
                                            </cfif>
                                            <cfif attributes.report_type eq 3> #PROPERTY#</cfif>
                                        </td>
                                        <cfif is_brand_show eq 1><td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list_new,brand_id,',')]#</cfif></td></cfif>
                                        <cfif is_short_code_show eq 1><td><cfif len(short_code_id)and len(short_code_id_list)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(MIN_MARGIN,2)#<cfelse>#TLFormat(MIN_MARGIN,5)#</cfif></td>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)# <cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif>
                                            <cfif len(PRODUCT_STOCK)>
                                                <cfset unit_ = filterSpecialChars(birim)>
                                                <cfif birim is 'Kilogram'>
                                                    <cfset toplam_Kilogram=toplam_Kilogram+PRODUCT_STOCK>
                                                <cfelse>
                                                    <cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') +PRODUCT_STOCK>	
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <td style="text-align:right;">
                                            <cfif len(PRODUCT_STOCK) and IsDefined("MULTIPLIER_AMOUNT_1") and len(MULTIPLIER_AMOUNT_1)>
                                                <cfset toplam_multiplier_amount_1 = toplam_multiplier_amount_1 + PRODUCT_STOCK/MULTIPLIER_AMOUNT_1>
                                                #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT_1,4)#
                                            </cfif>
                                        </td>
                                        <td style="text-align:center;width:60px;"><cfif len(PRODUCT_STOCK)>#BIRIM#</cfif></td>
                                        <cfif x_unit_weight eq 1>
                                            <td>
                                                <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT)>
                                                    <cfset toplam_unit_weıght = toplam_unit_weıght + PRODUCT_STOCK*UNIT_WEIGHT>
                                                    #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT,4)#
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif x_show_second_unit>
                                            <td style="text-align:right;">
                                                <cfif len(PRODUCT_STOCK) and len(multiplier)>
                                                    <cfset unit_ = filterSpecialChars(unit2)>
                                                    <cfif isdefined("toplam_miktar_#unit_#")>
                                                        <cfset 'toplam_miktar_#unit_#' = evaluate('toplam_miktar_#unit_#') + PRODUCT_STOCK/wrk_round(multiplier,8,1)>
                                                    </cfif>
                                                    <cfset toplam_ikinci_miktar = toplam_ikinci_miktar + PRODUCT_STOCK/wrk_round(multiplier,8,1)>
                                                    <cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK/wrk_round(multiplier,8,1),2)# <cfelse>#TLFormat(PRODUCT_STOCK/wrk_round(multiplier,8,1),5)#</cfif>
                                                </cfif>
                                            </td>
                                            <td style="text-align:center;width:60px;">
                                                #unit2#
                                                <cfif len(unit2)><cfset unit2_list = listappend(unit2_list,unit2)></cfif>
                                            </td>
                                        </cfif>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,2)#</cfif>
                                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                                        </td>
                                        <td style="text-align:right;">
                                            <cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                        </td>
                                        <cfif attributes.is_discount eq 1>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                            </td> 
                                        </cfif>
                                        <cfif attributes.is_profit eq 1>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                            </td>
                                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                            <td style="text-align:right;"><cfif PRICE neq 0>#TLFormat((NET_KAR*100)/PRICE,2)#</cfif></td>
                                        </cfif>
                                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)# </cfif>
                                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                            </td>
                                            <td style="text-align:right;">
                                                <cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                            </td>
                                            <cfif attributes.is_discount eq 1>
                                                <td style="text-align:right;">
                                                    <cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                                </td>	                   
                                            </cfif>
                                            <cfif attributes.is_profit eq 1>
                                                <td style="text-align:right;">
                                                    <cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                                </td>
                                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                                <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#<cfelse>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,5)#</cfif></cfif></td>
                                            </cfif>
                                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                        </cfif>
                                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        <cfelse>
                            <tr>
                                <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                            </tr>
                        </cfif>
                    </cfif>    
                <cfelseif listfind('4,6',attributes.report_type)>
                    <cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
                         <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif type eq 1>
                                <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                    SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T1 WHERE MUSTERI_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MUSTERI_ID#">
                                </cfquery>
                            <cfelseif type eq 0>
                                <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                    SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T2 WHERE MUSTERI_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MUSTERI_ID#">
                                </cfquery>
                            <cfelse>
                                <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                    SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T3 WHERE MUSTERI_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MUSTERI_ID#">
                                </cfquery>
                            </cfif>
                            <cfif len(MUSTERI_CITY)>
                                <cfquery name="GET_MUSTERI_CITY" datasource="#DSN#">
                                    SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MUSTERI_CITY#">
                                </cfquery> 
                            </cfif>
                            <cfinclude template="../../settings/cumulative/cumulative_sales_analyse_inc.cfm">
                        </cfoutput>
                        <cfif get_total_purchase.recordcount gte (attributes.startrow+attributes.maxrows)>
                            <script type="text/javascript">
                                user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/get_total_purchase.recordcount)#</cfoutput>);
                            </script>
                        <cfelse>
                            <script type="text/javascript">
                                user_info_show_div(1,1,1);
                            </script>
                            <cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
                                UPDATE 
                                    REPORT_SYSTEM 
                                SET 
                                    PROCESS_FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                                    PROCESS_ROW_COUNT = (SELECT COUNT(SALES_CUSTOMER_MONTH_ID) FROM SALES_CUSTOMER_MONTH WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#"> AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#">)
                                WHERE 
                                    REPORT_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="SALES_CUSTOMER_MONTH"> AND 
                                    PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#"> AND 
                                    PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_month#"> AND 
                                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_our_company_id#">
                            </cfquery>
                        </cfif>
                        <cfabort>
                    <cfelse> 
                        <thead>   
                            <tr>
                                <th class="txtbold"><cf_get_lang_main no='146.Üye no'></th>
                                <th class="txtbold"><cf_get_lang_main no='1195.Firma'></th>
                                <cfif attributes.report_type eq 4>
                                    <cfif isdefined("x_show_sales_zone") and x_show_sales_zone eq 1>
                                        <th class="txtbold"><cf_get_lang_main no='247.Satış Bölgesi'></th>
                                    </cfif>
                                    <th class="txtbold"><cf_get_lang_main no='1350.Vergi Dairesi'></th>
                                    <th class="txtbold"><cf_get_lang_main no='340.Vergi No'></th>
                                    <th class="txtbold"><cf_get_lang no='963.Belge Adedi'></th>
                                    <th class="txtbold"><cf_get_lang_main no='559.Şehir'></th>
                                </cfif>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                    <cfif attributes.is_discount eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                        <th style="text-align:right;">%</th>
                                    </cfif>
                                    <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                </cfif>
                                <th width="35" class="txtbold" style="text-align:right;">%</th>
                            </tr>
                        </thead>
                        <cfif get_total_purchase.recordcount>
                        <tbody>
                            <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                            <td nowrap>#member_code#</td>
                            <td>
                                <cfif attributes.report_type eq 4>					
                                    <cfif type eq 1>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','medium');" class="tableyazi">#MUSTERI#</a>
                                    <cfelseif type eq 0>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','medium');" class="tableyazi">#MUSTERI#</a>
                                    <cfelse>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#musteri_id#','medium');" class="tableyazi">#MUSTERI#</a>
                                    </cfif>
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','medium');" class="tableyazi ">
                                        #MUSTERI#
                                    </a>
                                </cfif>
                                </td>
                                <cfif attributes.report_type eq 4>
                                    <cfif isdefined("x_show_sales_zone") and x_show_sales_zone eq 1>
                                    <td>#SZ_2.SZ_NAME[listfind(list_zone_ids,zone_id,',')]#</td>
                                    </cfif>
                                    <td>#TAXOFFICE#</td>
                                    <td style="mso-number-format:\@">#TAXNO#</td>
                                    <td>
                                    <cfif type eq 1>
                                        <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                            SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T1 WHERE MUSTERI_ID=#MUSTERI_ID#
                                        </cfquery>
                                    <cfelseif type eq 0>
                                        <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                            SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T2 WHERE MUSTERI_ID=#MUSTERI_ID#
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                            SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT FROM T3 WHERE MUSTERI_ID=#MUSTERI_ID#
                                        </cfquery>
                                    </cfif>
                                    #GET_INVOICE_COUNT.INVOICE_COUNT#
                                    </td>
                                    <td><cfif Len(musteri_city)>#get_musteri_city.city_name[ListFind(musteri_city_list,musteri_city,',')]#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;">
                                    <cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></td> 
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td> 
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(get_total_purchase.GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(get_total_purchase.GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = get_total_purchase.GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                            </cfoutput>
                            </tbody>
                        <cfelse>
                            <tr>
                                <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                            </tr>
                        </cfif>
		            </cfif>
                <cfelseif attributes.report_type eq 5>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang no='683.Müşteri Tipi'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                        <tbody>
                            <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#MUSTERI_TYPE#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)# <cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif><cfif len(PRICE)>
                                    <cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;">
                                        <cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif len(NET_KAR)>#session.ep.money#</cfif></td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)# </cfif>
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td> 
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                            </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 7>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang_main no='41.Şube'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                        <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#BRANCH_NAME#</td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;">#TLFormat(DISCOUNT)# 
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                        </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 8>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no='164.Çalışan'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                        <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>

                        </tr>
                        </cfoutput>
                        </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 9>
                	<thead>
						<tr>
							<th class="txtbold"><cf_get_lang_main no='1435.Marka'></th>
							<th class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
							<th class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
							<th class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
						    <cfif attributes.is_discount eq 1>
								<th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
							</cfif>
							<cfif attributes.is_profit eq 1>
								<th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
								<th style="text-align:right;">%</th>
								<th class="txtbold">Sapma</th>
							</cfif>
							<th class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
							<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
								<th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
								<cfif attributes.is_discount eq 1>
									<th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
								</cfif>
								<cfif attributes.is_profit eq 1>
									<th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
									<th style="text-align:right;">%</th>
									<th class="txtbold">Sapma</th>
								</cfif>
								<th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
							</cfif>
							<th class="txtbold" style="text-align:right;">%</th>
						</tr> 
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#BRAND_NAME#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                    <td style="text-align:right;"><cfif PRICE neq 0>#TLFormat((NET_KAR*100)/PRICE,2)#</cfif></td>
                                </cfif>
                                <td>#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                        <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 10>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang_main no='1140.Müşteri Değeri'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>  
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#GET_CUSTOMER_VALUE_2.CUSTOMER_VALUE[listfind(list_customer_val_ids,CUSTOMER_VALUE_ID,',')]#</td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                            </td> 
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)# <cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 11>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang no='503.İlişki Tipi'></th>
    
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100"  class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr> 
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody> 
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#GET_RESOURCE_2.RESOURCE[listfind(list_resource_ids,RESOURCE_ID,',')]#</td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)# <cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 12>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no='722.Mikro Bölge Kodu'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>  
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#IMS_CODE_NAME#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)# <cfelse>#TLFormat(PRICE,5)#</cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 13>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang_main no='247.Satış Bölgesi'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#SZ_2.SZ_NAME[listfind(list_zone_ids,ZONE_ID,',')]#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)# </cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)# <cfelse>#TLFormat(DISCOUNT,5)# </cfif>
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR)#</cfif>
                                        <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#SESSION.EP.MONEY#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>				
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 33>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang_main no='167.Sektör'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#GET_SECTOR.SECTOR_CAT[listfind(list_sector_ids,SECTOR_CAT_ID,',')]#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)# <cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#SESSION.EP.MONEY#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)# <cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>				
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 14>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang_main no='1104.Ödeme Yöntemi'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr> 
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>
                            <cfif len(PAY_METHOD) and listfind(list_pay_ids,PAY_METHOD,',')>
                                #GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAY_METHOD,',')]#
                            <cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
                                #GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#
                            </cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 15>
                    <thead>
                        <tr>
                            <th class="txtbold"><cf_get_lang no='649.Hedef Pazar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr> 
                    </thead>
                    <cfif  get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>
                            <cfif len(get_total_purchase.SEGMENT_ID) and listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')>
                                #GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')]#
                            </cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>  
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)# <cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)# <cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 16>
                    <thead>
                    <tr>
                        <th class="txtbold">İl</th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>
                            <cfif len(get_total_purchase.city) and listfind(city_id_list,get_total_purchase.city,',')>
                                #get_city.city_name[listfind(city_id_list,get_total_purchase.city,',')]#
                            </cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)# <cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)# <cfelse>#TLFormat(PRICE,5)#</cfif>
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;">#TLFormat(DISCOUNT_DOVIZ)# 
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 17>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no ='4.Proje'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>
                        <cfif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
                            #get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#
                        </cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT)#</cfif> 
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#SESSION.EP.MONEY#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 18>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no='1036.Ürün Sorumlusu'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                     <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>				
                            <cfif len(get_total_purchase.position_code) and listfind(position_code_list,get_total_purchase.position_code,',')>
                                <cfif type_ eq 1>
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.position_code#','medium');" class="tableyazi">
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
                                    </a>
                                </cfif>
                            </cfif>
                        </td>
                        <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,2)#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;"> #session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;">#TLFormat(DISCOUNT_DOVIZ)# 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;">#TLFormat(NET_KAR_DOVIZ)# 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 19>
                		
                        <thead>
                            <tr>
                                <th class="txtbold"><cf_get_lang_main no='225.Seri No'></th>
                                <th class="txtbold"><cf_get_lang_main no='721.Fatura No'></th>
                                <th class="txtbold"><cf_get_lang_main no='1347.Fatura Tarihi'></th>
                                <cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
                                    <th class="txtbold"><cf_get_lang_main no='217.açıklama'></th>
                                </cfif>
                                <cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1>
                                    <th class="txtbold"><cf_get_lang_main no='41.Şube'></th>
                                </cfif>
                                <cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
                                    <th class="txtbold">Sipariş Şubesi</th>
                                </cfif>
                                <th><cf_get_lang_main no="760.Gelir Merkezi"></th>
                                <th><cf_get_lang no="1564.Satış Yapan"></th>
                                <th class="txtbold"><cf_get_lang_main no='45.Müşteri'><cf_get_lang_main no='146.Üye No'></th>
                                <cfif isdefined("x_show_account_code") and x_show_account_code eq 1><th class="txtbold"><cf_get_lang_main no='45.Müşteri'><cf_get_lang_main no='1399.Muhasebe Koduz'></th></cfif>
                                <th class="txtbold"><cf_get_lang_main no='45.Müşteri'></th>
                                <cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
                                    <th class="txtbold"><cf_get_lang dictionary_id="30343.Özel Kod 3"></th>    
                                </cfif>
                                <cfif attributes.is_project eq 1>
                                    <th class="txtbold"><cf_get_lang_main no ='4.Proje'></th>
                                </cfif>
                                <th class="txtbold"><cf_get_lang no='683.Müşteri Tipi'></th>
                                <cfif isdefined("x_show_subs") and x_show_subs eq 1>
                                	<th class="txtbold"><cf_get_lang_main no='1705.Abone No'> </th>
                                    <th class="txtbold"><cf_get_lang no='513.Abone ismi'> </th>
                                </cfif>
                                <th class="txtbold"><cf_get_lang_main no='1383.Müşteri Temsilcisi'> </th>
                                <th class="txtbold"><cf_get_lang_main no='1552.Fiyat Listesi'></th>
                                <th class="txtbold"><cf_get_lang_main no='1388.Ürün Kod'></th>
                                <th class="txtbold"><cf_get_lang_main no='222.Üretici Kodu'></th>
                                <th class="txtbold"><cf_get_lang_main no='245.Ürün'> </th>
                                <cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
                                    <th class="txtbold"><cf_get_lang dictionary_id='32916.Lot no'></th>
                                </cfif>
                                <cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
                                    <th class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></th>
                                </cfif>
                                <cfif is_brand_show eq 1><th><cf_get_lang_main no='1435.Marka'></th></cfif>
                                <cfif is_short_code_show eq 1><th><cf_get_lang_main no='813.Model'></th></cfif>
                                <cfif attributes.is_spect_info eq 1>
                                    <th class="txtbold"><cf_get_lang_main no='235.Spec'></th>
                                    <th class="txtbold">Spec Id</th>
                                </cfif>
                                <cfif x_show_product_code_2>
                                    <th class="txtbold"><cf_get_lang_main no="377.Özel Kod"></th>
                                </cfif>
                                <th class="txtbold">Ürün <cf_get_lang no ='1562.Marj'></th>
                                <th class="txtbold"><cf_get_lang_main no ='228.Vade'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                                <cfif x_show_second_unit>
                                	<th width="100" class="txtbold" style="text-align:right;">2.<cf_get_lang_main no='223.Miktar'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='224.Birim'></th>
                                <cfif x_show_second_unit>
                                	<th style="text-align:center;width:60px;" class="txtbold">2.<cf_get_lang_main no='224.Birim'></th>
                                </cfif>
                                <cfif x_unit_weight eq 1>
	                                <th width="100" class="txtbold" style="text-align:right;">Ağırlık</th>
                                </cfif>
                                <cfif attributes.is_priceless eq 1>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no ='1563.Mal Fazlası'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='226.Birim Fiyat'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no ='122.Net Fiyat'></th>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                                <cfif attributes.is_discount eq 1>
                                    <cfif isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
                                        <cfloop from="1" to="#listlen(attributes.exp_discounts)#" index="disc_indx">
                                            <th nowrap class="txtbold" style="text-align:right;">ISK <cfoutput>#listgetat(attributes.exp_discounts,disc_indx)#</cfoutput></th>
                                        </cfloop>
                                    </cfif>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İskonto Tutar'></th>
                                </cfif>
                                <cfif attributes.is_cost_price eq 1>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='671.Net'><cf_get_lang_main no='846.Maliyet'></th>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no ='1482.Toplam Maliyet'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                    <th style="text-align:right;">%</th>
                                    <th class="txtbold" style="text-align:right;"><cf_get_lang no ='1333.Sapma'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'><cf_get_lang_main no='226.Birim Fiyat'></th>
                                    <cfif attributes.is_discount eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                    </cfif>
                                    <cfif attributes.is_cost_price eq 1>
                                        <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1 and attributes.is_money2 eq 1>
                                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='671.Net'><cf_get_lang_main no='846.Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no ='1482.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
                                        </cfif>
                                    </cfif>
                                    <cfif attributes.is_cost_price eq 1 and x_show_other_money_cost eq 1 and isdefined('attributes.cost_type') and attributes.cost_type eq 1>
                                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='846.Maliyet'></th>
                                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'><cf_get_lang_main no='265.Döviz'><cf_get_lang_main no='846.Maliyet'></th>
                                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                        <th style="text-align:right;">%</th>
                                        <th class="txtbold" style="text-align:right;"><cf_get_lang no ='1333.Sapma'></th>
                                    </cfif>
                                    <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                                </cfif>
                                <cfif attributes.is_cost_price eq 1>
                                    <th class="txtbold"><cf_get_lang no ='1562.Marj'></th>
                                    <th class="txtbold"><cf_get_lang no ='1562.Marj'><cf_get_lang_main no='80.Toplam'></th>
                                </cfif>
                                <th width="35" class="txtbold" style="text-align:right;">%</th>
                            </tr>
                        </thead>
                        <cfif get_total_purchase.recordcount>
                   		<tbody>
							<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                <tr>
                                <td style="mso-number-format:\@;">
                                    <cfset fuse_type = 'invoice'>
                                    <cfif type_ eq 1>
                                            #serial_number#
                                    <cfelse>
                                        <cfif purchase_sales eq 1>
                                            <cfif invoice_cat eq 52>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.add_bill_retail&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_number#</a>
                                            <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.form_add_bill&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_number#</a>
                                            </cfif>
                                        <cfelseif purchase_sales eq 0>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.form_add_bill_purchase&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_number#</a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td style="mso-number-format:\@;">
                                    <cfif len(serial_no)><cfset serial_no_ = serial_no><cfelse><cfset serial_no_ = invoice_number></cfif> 
                                        <cfif IsDefined("attributes.process_type_select") and attributes.process_type_select eq 690>
                                            <cfif type_ eq 1>
                                                #serial_no_#
                                            <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=finance.upd_daily_zreport&iid=#invoice_id#','wide');" class="tableyazi">#serial_no_#</a>
                                            </cfif>
                                        <cfelse>
                                            <cfif type_ eq 1>
                                                #serial_no_#
                                            <cfelse>
                                                <cfif purchase_sales eq 1>
                                                    <cfif invoice_cat eq 52>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.add_bill_retail&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_no_#</a>
                                                    <cfelse>
                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.form_add_bill&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_no_#</a>
                                                    </cfif>
                                                <cfelseif purchase_sales eq 0>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.form_add_bill_purchase&event=upd&iid=#invoice_id#','wide');" class="tableyazi">#serial_no_#</a>
                                                </cfif>
                                            </cfif>
                                        </cfif>                                    
                                </td>
                                <td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
                                <cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
                                    <td width="150">#NOTE#</td>
                                </cfif>
                                <cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1>
                                    <td><cfif Len(department_id)>#get_invoice_branch.branch_name[listfind(branch_id_list,department_id,',')]#</cfif></td>
                                </cfif>
                                <cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
                                    <td><cfif Len(order_branch_id)>#get_invoice_branch2.branch_name[listfind(branch_id_list2,order_branch_id,',')]#</cfif></td>
                                </cfif>
                                <td>#EXPENSE_CENTER#</td>
                                <cfquery name="get_sale_emp" datasource="#dsn2#">
                                    SELECT SALE_EMP,SALE_PARTNER FROM INVOICE WHERE INVOICE_ID = #INVOICE_ID#
                                </cfquery>
                                <td><cfif len(get_sale_emp.sale_emp)>#get_emp_info(get_sale_emp.sale_emp,0,1)#<cfelseif len(get_sale_emp.sale_partner)>#get_par_info(get_sale_emp.sale_partner,1,-1,1)#</cfif></td>
                                <td style="mso-number-format:\@;">#UYE_NO#</td>
                                <cfif isdefined("x_show_account_code") and x_show_account_code eq 1>
                                    <td style="mso-number-format:\@;">#account_code#</td>
                                </cfif>
                                <td>#MUSTERI#</td>
                                <cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
                                    <td style="mso-number-format:\@;">#OZEL_KOD_2#</td>
                                </cfif>
                                <cfif attributes.is_project eq 1>
                                    <td><cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
                                            <cfif type_ eq 1>
                                                #get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#
                                            <cfelse>
                                                <a href="#request.self#?fuseaction=project.projects&event=det&id=#row_project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#</a>
                                            </cfif>
                                        <cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
                                             <cfif type_ eq 1>
                                                #get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#
                                            <cfelse>
                                               <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
                                            </cfif>
                                        </cfif>  
                                    </td>
                                </cfif>
                                <td>#KATEGORI#</td>
                                <cfif isdefined('x_show_subs') and x_show_subs eq 1>
                                	<cfquery name="get_subs_info" datasource="#DSN2#">
                                    	SELECT 
                                        	SC.SUBSCRIPTION_NO AS SUBS_NO,
                                            SC.SUBSCRIPTION_HEAD AS SUBS_HEAD
                                        FROM 
                                        	INVOICE I 
                                            LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = I.SUBSCRIPTION_ID
                                        WHERE 
                                        	I.INVOICE_ID = #INVOICE_ID#    
                                    </cfquery>
                                	<td>#get_subs_info.subs_no#</td>
                                	<td>#get_subs_info.subs_head#</td>
                                </cfif>
                                <td><cfif len(company_id) and company_id gt 0 and len(company_list)>
                                        <cfif type_ eq 1>
                                            #get_pos_name.employee_name[listfind(company_list,company_id,',')]# #get_pos_name.employee_surname[listfind(company_list,company_id,',')]#
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_pos_name.position_code[listfind(company_list,company_id,',')]#','medium');" class="tableyazi">#get_pos_name.employee_name[listfind(company_list,company_id,',')]# #get_pos_name.employee_surname[listfind(company_list,company_id,',')]#</a>
                                        </cfif>
                                    <cfelseif len(consumer_id) and consumer_id gt 0 and len(consumer_list)>
                                        <cfif type_ eq 1>
                                            #get_pos_name_2.employee_name[listfind(consumer_list,consumer_id,',')]# #get_pos_name_2.employee_surname[listfind(consumer_list,consumer_id,',')]#
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_pos_name_2.position_code[listfind(consumer_list,consumer_id,',')]#','medium');" class="tableyazi">#get_pos_name_2.employee_name[listfind(consumer_list,consumer_id,',')]# #get_pos_name_2.employee_surname[listfind(consumer_list,consumer_id,',')]#</a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td>
                                <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                    #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
                                <cfelseif price_cat eq -2>
                                    Standart Satış
                                <cfelseif price_cat eq -1>
                                    Standart Alış
                                </cfif>
                                </td>
                                <td style="mso-number-format:\@;">#STOCK_CODE#</td>
                                <td style="mso-number-format:\@;">#MANUFACT_CODE#</td>
                                <td><cfif session.ep.isBranchAuthorization>
                                        <cfif type_ eq 1>
                                            #PRODUCT_NAME# #PROPERTY#
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&is_store_module=1','medium');" class="tableyazi">#PRODUCT_NAME# #PROPERTY#</a>
                                        </cfif>
                                    <cfelse>
                                        <cfif type_ eq 1>
                                            #PRODUCT_NAME# #PROPERTY#
                                        <cfelse>
                                            <a href="javascript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=product.list_product&event=det&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME# #PROPERTY#</a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
                                    <td style="mso-number-format:\@;">#LOT_NO#</td>
                                </cfif>
                                <cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
                                    <td style="mso-number-format:\@;">#BARCOD#</td>
                                </cfif>
                                <cfif is_brand_show eq 1><td><cfif len(brand_id) and  len(brand_id_list_new)>#get_brand.BRAND_NAME[listfind(brand_id_list_new,brand_id,',')]#</cfif></td></cfif>
                                <cfif is_short_code_show eq 1><td><cfif len(short_code_id) and len(short_code_id_list)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
                                <cfif attributes.is_spect_info eq 1>
                                    <td>#spect_var_name#</td>
                                    <td>#spect_main_id#</td>
                                </cfif>
                                <cfif x_show_product_code_2>
                                    <td style="mso-number-format:\@;">#product_code_2#</td>
                                </cfif>
                                <td>#MIN_MARGIN#</td>
                                <td style="text-align:right;">#due_date#</td>
                                <td style="text-align:right;mso-number-format:0\.00;">
                                    #TLFormat(PRODUCT_STOCK,4)#
                                    <cfif len(PRODUCT_STOCK)>
                                        <cfset unit_ = filterSpecialChars(birim)>
                                        <cfif birim is 'Kilogram'>
                                            <cfset toplam_Kilogram=toplam_Kilogram+PRODUCT_STOCK>
                                        <cfelse>
                                            <cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') +PRODUCT_STOCK>	
                                        </cfif>
                                     </cfif>
                                </td>
                                <cfif x_show_second_unit>
                                    <td style="text-align:right;mso-number-format:0\.00;">
                                        <cfif len(PRODUCT_STOCK) and len(MULTIPLIER_AMOUNT_2)>
                                            <cfset toplam_multiplier_amount_2 = toplam_multiplier_amount_2 + PRODUCT_STOCK/MULTIPLIER_AMOUNT_2>
                                            #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT_2,4)#
                                        </cfif>
                                    </td> 
                                </cfif>                               
                                <td>#BIRIM#</td>
                                <cfif x_show_second_unit>
                                    <td>
                                        #UNIT2#
                                        <cfif len(unit2)><cfset unit2_list = listappend(unit2_list,unit2)></cfif>
                                    </td>
                                </cfif>
                                <cfif x_unit_weight eq 1>
                                    <td>
                                        <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT_1)>
                                            <cfset toplam_unit_weıght_1 = toplam_unit_weıght_1 + PRODUCT_STOCK*UNIT_WEIGHT_1>
                                            #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT_1,4)#
                                        </cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_priceless eq 1>
                                    <td style="text-align:right;">#TLFormat(priceless_amount,2)#</td>
                                </cfif>
                                <cfif len(priceless_amount)>
                                    <cfset toplam_bedelsiz = toplam_bedelsiz + priceless_amount>
                                </cfif>
                                <cfif product_stock neq 0>
                                    <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row/product_stock)>
                                <cfelse>
                                    <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row)>
                                </cfif>
                                <td style="text-align:right;">#tlformat(PRICE_ROW)#</td>
                                <td style="text-align:right;">#TLFormat(GROSSTOTAL)# 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif product_stock neq 0>#TLFormat(nettotal_row/product_stock)#<cfelse>#tlformat(nettotal_row)#</cfif></td>
                                <td style="text-align:right;">#TLFormat(PRICE)# 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <cfif isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
                                        <cfset total_disc = 0>
                                        <cfloop from="1" to="10" index="disc_indx">
                                            <cfif disc_indx eq 1>
                                                <cfset "disc_amount_#disc_indx#" = GROSSTOTAL_NEW*evaluate("DISCOUNT#disc_indx#")/100>
                                                <cfset total_disc = GROSSTOTAL_NEW*evaluate("DISCOUNT#disc_indx#")/100>
                                            <cfelse>
                                                <cfset "disc_amount_#disc_indx#" = (GROSSTOTAL_NEW - total_disc)*evaluate("DISCOUNT#disc_indx#")/100>
                                                <cfset total_disc = total_disc + (GROSSTOTAL_NEW - total_disc)*evaluate("DISCOUNT#disc_indx#")/100>
                                            </cfif>									
                                        </cfloop>
                                        <cfloop from="1" to="#listlen(attributes.exp_discounts)#" index="disc_indx">
                                            <td style="text-align:right;">#TLFormat(evaluate("disc_amount_#listgetat(attributes.exp_discounts,disc_indx)#"))#</td>
                                            <cfset "total_discount_#listgetat(attributes.exp_discounts,disc_indx)#" = evaluate("total_discount_#listgetat(attributes.exp_discounts,disc_indx)#") + evaluate("disc_amount_#listgetat(attributes.exp_discounts,disc_indx)#")>
                                        </cfloop>
                                    </cfif>
                                    <td style="text-align:right;">#TLFormat(DISCOUNT)# 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_cost_price eq 1>
                                    <cfif not len(cost_price)><cfset row_cost_price= 0><cfelse><cfset row_cost_price= cost_price></cfif>
                                    <cfif not len(cost_price_2)><cfset row_cost_price_2= 0><cfelse><cfset row_cost_price_2= cost_price_2></cfif>
                                    <cfif not len(margin)><cfset row_margin= 0><cfelse><cfset row_margin= margin></cfif>
                                    <td style="text-align:right;">#TLFormat(row_cost_price,2)#</td>
                                    <td style="text-align:right;">#TLFormat(row_cost_price*PRODUCT_STOCK,2)#</td>
                                    <cfset toplam_cost_price=toplam_cost_price+row_cost_price>
                                    <cfset toplam_cost_price_2=toplam_cost_price_2+row_cost_price_2>
                                    <cfset toplam_marj_all=toplam_marj_all+(row_margin*row_cost_price*PRODUCT_STOCK/100)>
                                    <cfset toplam_cost_price_all=toplam_cost_price_all+(row_cost_price*PRODUCT_STOCK)>
                                    <cfset toplam_cost_price_all_2=toplam_cost_price_all_2+(row_cost_price_2*PRODUCT_STOCK)>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;">#TLFormat(NET_KAR)#
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0 and len(NET_KAR)>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                    <td style="text-align:right;"><cfif PRICE neq 0 and len(NET_KAR)>#TLFormat((NET_KAR*100)/PRICE,2)#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;">#TLFormat(PRICE_ROW_OTHER)#</td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;">#TLFormat(DISCOUNT_DOVIZ)# 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                     <cfif attributes.is_cost_price eq 1>
                                        <cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1 and attributes.is_money2 eq 1>
                                            <td style="text-align:right;">#TLFormat(row_cost_price_2,2)#</td>
                                            <td style="text-align:right;">#TLFormat(row_cost_price_2*PRODUCT_STOCK,2)#</td>
                                        </cfif>
                                     </cfif>
                                    <cfif attributes.is_cost_price eq 1 and x_show_other_money_cost eq 1 and isdefined('attributes.cost_type') and attributes.cost_type eq 1>
                                        <td style="text-align:right;">#TLFormat(cost_price_other,2)#</td>
                                        <td style="text-align:right;">#TLFormat(cost_price_other*PRODUCT_STOCK,2)#</td>
                                        <td style="text-align:center;width:60px;">#cost_price_money#</td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;" nowrap="nowrap">#TLFormat(NET_KAR_DOVIZ)# 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                        <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <cfif attributes.is_cost_price eq 1>
                                    <td style="text-align:right;">#TLFormat(row_margin,2)#</td>
                                    <td style="text-align:right;">#TLFormat(row_margin*row_cost_price*PRODUCT_STOCK/100,2)#</td>
                                </cfif>
                                <td style="text-align:right;mso-number-format:0\.00;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                            </cfoutput>
                    	</tbody>
                        <cfelse>
                            <tr>
                                <td colspan="60"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                            </tr>
                        </cfif>
                
				<cfelseif attributes.report_type eq 20>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang no='966.Promosyon No'></th>
                        <th class="txtbold"><cf_get_lang no='956.Promosyon'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif  get_total_purchase.recordcount>
                    <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#get_total_purchase.prom_no#</td>
                        <td>#get_total_purchase.prom_head#</td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 21>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                     <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>
                            <cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                <cfif type_ eq 1>
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    </a>
                                </cfif>
                            </cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)# <cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)# <cfelse>#TLFormat(PRICE,5)#</cfif>
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td> 
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)# <cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)# </cfif>
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 22>
                    <thead>
                    <tr>
                        <th class="txtbold" width="100"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                        <th class="txtbold"><cf_get_lang_main no='245.Ürün'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>
                                    <cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                        <cfif type_ eq 1>
                                            #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                            #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            </a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td><cfif type_ eq 1>#product_name#<cfelse><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');">#product_name#</a></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)# <cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif (attributes.report_type eq 34 or attributes.report_type eq 35 or attributes.report_type eq 39)>
                    <thead>
                    <tr>
                        <th class="txtbold" width="100"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                        <th class="txtbold"><cf_get_lang no='657.Kategori Kod'></th>
                        <th class="txtbold" height="22"><cf_get_lang_main no='74.Kategori'></th>
                        <cfif attributes.report_type eq 39>
                        <th class="txtbold" height="22"><cf_get_lang_main no='807.Ülke'></th>
                        </cfif>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>
                                   <cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                        <cfif type_ eq 1>
                                            #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                            #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            </a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td style="mso-number-format:\@;">#HIERARCHY#</td>
                                <td>#PRODUCT_CAT#</td>
                                <cfif attributes.report_type eq 39>
                                <td>#COUNTRY_NAME#</td>
                                </cfif>
                                <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,2)#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)# <cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)# <cfelse>#TLFormat(PRICE,5)#</cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;">#TLFormat(DISCOUNT_DOVIZ)# 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;">#TLFormat(NET_KAR_DOVIZ)# 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 36>
                    <thead>
                    <tr>
                        <th class="txtbold" width="100"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                        <th class="txtbold"><cf_get_lang no='683.Müşteri Tipi'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif  get_total_purchase.recordcount>
                    <tbody>
                     <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>
                            <cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                <cfif type_ eq 1>
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                    #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    </a>
                                </cfif> 
                            </cfif>
                        </td>
                        <td>#MUSTERI_TYPE#</td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;">#TLFormat(GROSSTOTAL)# 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;">#TLFormat(NET_KAR)#
                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)# <cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;">#TLFormat(NET_KAR_DOVIZ)# 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif (attributes.report_type eq 23 or attributes.report_type eq 40 or attributes.report_type eq 41)>
                    <thead>
                        <tr>
                        <cfif attributes.report_type neq 41>
                            <th class="txtbold" width="100"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                         </cfif>
                            <th class="txtbold" width="100"><cf_get_lang_main no='45.Müşteri'></th>
                            <cfif attributes.report_type eq 23>
                                <th class="txtbold" width="100"><cf_get_lang_main no='106.Stok Kodu'></th>
                                <th class="txtbold"><cf_get_lang_main no='245.Ürün'></th>
                            <cfelseif attributes.report_type eq 40 or attributes.report_type eq 41>
                            	<th class="txtbold"><cf_get_lang no='657.Kategori Kod'></th>
                                <th class="txtbold"><cf_get_lang_main no='74.Kategori'></th>
                            </cfif>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <cfif attributes.report_type eq 40 or attributes.report_type eq 41>
                                <th width="100" class="txtbold" style="text-align:right;">2. Birim <cf_get_lang_main no='223.Miktar'></th>
                                <cfif x_show_second_unit>
	                                <th style="text-align:center;width:60px;" class="txtbold">2. <cf_get_lang_main no='224.Birim'></th>
                                </cfif>
                            </cfif>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                            <cfif  attributes.report_type neq 41>
                                <td>
                                    <cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                        <cfif type_ eq 1>
                                            #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                        <cfelse>
                                             <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                                #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                                #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                            </a>
                                        </cfif>
                                    </cfif>
                                </td>
                                </cfif>
                                <td>
                                    <cfif type_ eq 1>
                                        #MUSTERI#
                                    <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','medium');" class="tableyazi ">
                                        #MUSTERI#
                                    </a>
                                    </cfif>
                                </td>
                                <cfif attributes.report_type eq 23>
                                    <td><cfif isdefined('stock_code')>#STOCK_CODE#</cfif></td>
                                    <td><cfif type_ eq 1>#product_name#<cfelse><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');">#product_name#</a></cfif></td>
                                <cfelseif attributes.report_type eq 40 or attributes.report_type eq 41>
                                    <td style="mso-number-format:\@;">#HIERARCHY#</td>
                                    <td>#PRODUCT_CAT#</td>
                                </cfif>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <cfif attributes.report_type eq 40 or  attributes.report_type eq 41>
                                	<td style="text-align:right;">
                                    	<cfif len(PRODUCT_STOCK) and len(multiplier)>
                                        	<cfset unit_ = filterSpecialChars(unit2)>
                                            <cfif isdefined("toplam_ikinci_#unit_#")>
											    <cfset 'toplam_ikinci_#unit_#' = evaluate('toplam_ikinci_#unit_#') + PRODUCT_STOCK/wrk_round(multiplier,8,1)>
                                            </cfif>
                                            <cfset toplam_ikinci_miktar = toplam_ikinci_miktar + PRODUCT_STOCK/wrk_round(multiplier,8,1)>
                                            <cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK/wrk_round(multiplier,8,1),2)# <cfelse>#TLFormat(PRODUCT_STOCK/wrk_round(multiplier,8,1),5)#</cfif>
                                        </cfif>
                                    </td>
                                    <cfif x_show_second_unit>
                                        <td style="text-align:center;width:60px;">
                                            #unit2#
                                            <cfif len(unit2)><cfset unit2_list = listappend(unit2_list,unit2)></cfif>
                                        </td>
                                    </cfif>
                                </cfif>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)# <cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)# <cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 24>
                    <thead>
                    <tr>
                        <th class="txtbold"><cf_get_lang_main no='1350.Vergi Dairesi'></th>
                        <th class="txtbold"><cf_get_lang_main no='340.Vergi No'></th>
                        <th class="txtbold"><cf_get_lang no='963.Belge Adedi'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#TAXOFFICE#</td>
                               <td style="mso-number-format:\@">#TAXNO#</td>
                                <td><cfquery name="GET_INVOICE_COUNT" dbtype="query">
                                        SELECT COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT 
                                        FROM 
                                        <cfif type eq 1>
                                            T1 
                
                                        <cfelseif type eq 0>
                                            T2
                                        <cfelse>
                                            T3
                                        </cfif>
                                        WHERE TAXOFFICE='#TAXOFFICE#' AND TAXNO='#TAXNO#'
                                    </cfquery>
                                    #GET_INVOICE_COUNT.INVOICE_COUNT#
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif><cfif len(PRICE)>
                                    <cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif>
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 25>
                    <thead>
                    <tr>
                        <th class="txtbold" width="100"><cf_get_lang no ='1564.Satış Yapan'></th>
                        <th class="txtbold" width="100"><cf_get_lang_main no='45.Müşteri'></th>
                        <th class="txtbold"><cf_get_lang_main no='245.Ürün'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td><cfif len(get_total_purchase.sale_emp) and listfind(employee_id_list,get_total_purchase.sale_emp,',')>
                                        <cfif type_ eq 1>
                                            #get_employee.employee_name[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;
                                            #get_employee.employee_surname[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_total_purchase.sale_emp#','medium');" class="tableyazi">
                                                #get_employee.employee_name[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;
                                                #get_employee.employee_surname[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;
                                            </a>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td><cfif type_ eq 1>
                                        #MUSTERI#
                                    <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','medium');" class="tableyazi ">
                                        #MUSTERI#
                                    </a>
                                    </cfif>
                                </td>
                                <td><cfif type_ eq 1>#product_name#<cfelse><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');">#product_name#</a></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)# <cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                            </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 26>
                    <thead>
                        <tr>
                            <th class="txtbold" width="100">Satış Ortağı</th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>

                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><cfif len(sales_member_id) and sales_member_type eq 1 and len(partner_list)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#sales_member_id#','medium');" class="tableyazi"> 
                                    #get_partner_name.company_partner_name[listfind(partner_list,sales_member_id,',')]# #get_partner_name.company_partner_surname[listfind(partner_list,sales_member_id,',')]#
                                </a> - 
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_name.company_id[listfind(partner_list,sales_member_id,',')]#','medium');" class="tableyazi"> 
                                    #get_partner_name.nickname[listfind(partner_list,sales_member_id,',')]#
                                </a>
                            <cfelseif len(sales_member_id) and sales_member_type eq 2 and len(consumer_list)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#sales_member_id#','medium','popup_con_det');">
                                    #get_consumer_name.consumer_name[listfind(consumer_list,sales_member_id,',')]# #get_consumer_name.consumer_surname[listfind(consumer_list,sales_member_id,',')]#
                                </a>
                            </cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;">#session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 27>
                    <thead>
                    <tr>
                        <th class="txtbold" width="100"><cf_get_lang_main no='45.Müşteri'></th>
                        <th class="txtbold" width="100"><cf_get_lang no ='1181.Referans Kodu'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" class="txtbold" style="text-align:right;">%</th>
                    </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td><cfif type eq 1>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','medium');" class="tableyazi">#MUSTERI#</a>
                                    <cfelse>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','medium');" class="tableyazi">#MUSTERI#</a>
                                    </cfif>
                                </td>
                                <td>#member_reference_code#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)# <cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                            </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
                <cfelseif attributes.report_type eq 28>
                <thead>
                    <tr>
                        <th width="100"><cf_get_lang_main no='1552.Fiyat Listesi'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" style="text-align:right;"> <cf_get_lang no='686.Doviz Kar'> </th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                    #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
                                <cfelseif price_cat eq -2>
                                    Standart Satış
                                <cfelseif price_cat eq -1>
                                    Standart Alış
                                </cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif>
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                </td>
                                <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# 
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)# <cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif>
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                    </td>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <cfelse>
                    <tr>
                        <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                    </tr>
                </cfif>
                <cfelseif attributes.report_type eq 29>
                <thead>
                    <tr>
                        <th width="100"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></th>
                        <th width="100"><cf_get_lang_main no='1552.Fiyat Listesi'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                        </cfif>
                        <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>
					<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><cfif len(get_total_purchase.wp_position_code) and listfind(position_code_list,get_total_purchase.wp_position_code,',')>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.wp_position_code#','medium');" class="tableyazi">
                                        #get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                        #get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;
                                    </a>
                                </cfif>
                            </td>
                            <td><cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                    #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
                                <cfelseif price_cat eq -2>
                                    Standart Satış
                                <cfelseif price_cat eq -1>
                                    Standart Alış
                                </cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                    </td>
        
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif>
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <cfelse>
                    <tr>
                        <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                    </tr>
                </cfif>
                <cfelseif attributes.report_type eq 30>
                <thead>	
                    <tr>
                        <th width="100"><cf_get_lang_main no='1552.Fiyat Listesi'></th>
                        <th><cf_get_lang_main no='1388.Ürün Kod'></th>
                        <th><cf_get_lang_main no='221.Barkod'></th>
                        <th><cf_get_lang_main no='245.Ürün'> </th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <cfif attributes.is_discount eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <th width="100" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                            <th style="text-align:right;">%</th>
                            <th><cf_get_lang no ='1333.Sapma'></th>
                        </cfif>
                        <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <th width="75" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                <th style="text-align:right;">%</th>
                                <th><cf_get_lang no ='1333.Sapma'></th>
                            </cfif>
                            <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>
					<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                    #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
                                <cfelseif price_cat eq -2>
                                    Standart Satış
                                <cfelseif price_cat eq -1>
                                    Standart Alış
                                </cfif>
                            </td>
                            <td>#PRODUCT_CODE#</td>
                            <td>#BARCOD#</td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','large');" class="tableyazi">#PRODUCT_NAME#</a></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif>
                                <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                            </td>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                    <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                </td> 
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                    <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                <td style="text-align:right;"><cfif PRICE neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR*100)/PRICE,2)#<cfelse>#TLFormat((NET_KAR*100)/PRICE,5)#</cfif></cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;">#session.ep.money#</td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif>
                                    <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                    <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                        <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>	                   
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)#</cfif> 
                                        <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                    </td>
                                    <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                    <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#<cfelse>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,5)#</cfif></cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                            </cfif>
                            <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <cfelse>
                    <tr>
                        <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                    </tr>
                </cfif>
                <cfelseif attributes.report_type eq 31>
                    <thead>	
                        <tr>
                            <th width="100"><cf_get_lang_main no ='807.Ülke'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                                <th><cf_get_lang no ='1333.Sapma'></th>
                            </cfif>
                            <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                    <th><cf_get_lang no ='1333.Sapma'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>	
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td><cfif len(country_id_list) and len(country_id)>
                                        #get_country.country_name[listfind(country_id_list,country_id,',')]#
                                    </cfif>
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td> 
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                    <td style="text-align:right;"><cfif PRICE neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR*100)/PRICE,2)#<cfelse>#TLFormat((NET_KAR*100)/PRICE,5)#</cfif></cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>	                   
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)# </cfif>
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                        <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#<cfelse>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,4)#</cfif></cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>				
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
				<cfelseif attributes.report_type eq 37>     
                    <thead>
                        <tr>
                            <th class="txtbold">Ürün Grubu</th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" class="txtbold" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                            </cfif>
                            <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" class="txtbold" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                </cfif>
                                <th style="text-align:center;width:60px;" class="txtbold"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" class="txtbold" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount gt 0>
                    <tbody> 
                    	<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>
                        	<cfset deger_ = listGetAt(product_cat_list,PRODUCT_TYPE,',')>
							<cfif deger_ eq 667>İnternet
                            <cfelseif deger_ eq 607>Extranet
							<cfelseif deger_ eq 164>Kalite 
                            <cfelse>
                                #getLang('product',deger_)#
                                <cf_get_lang_set module_name="report">
                            </cfif>
						</td>
                        <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,2)#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                            <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>

                        </td>
                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                            <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                        </td>
                        <cfif attributes.is_discount eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif>
                                <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
                            </td>
                        </cfif>
                        <cfif attributes.is_profit eq 1>
                            <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                <cfif len(NET_KAR)><cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
                            </td>
                            <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                        </cfif>
                        <td style="text-align:center;width:60px;"> #session.ep.money#</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                            <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# 
                                <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
                            </td>
                            <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# 
                                <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
                            </td>
                            <cfif attributes.is_discount eq 1>
                                <td style="text-align:right;">#TLFormat(DISCOUNT_DOVIZ)# 
                                    <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <td style="text-align:right;">#TLFormat(NET_KAR_DOVIZ)# 
                                    <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
                                </td>
                                <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                            </cfif>
                            <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                        </cfif>
                        <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                    </tr>
                    </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr> 
                    </cfif>
				<cfelseif attributes.report_type eq 42>
					<thead>	
                        <tr>
                            <th width="100"><cf_get_lang_main no='377.Özel Kod'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang no='660.Brüt Tutar'></th>
                            <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                            <cfif attributes.is_discount eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='661.İsk Tutar'></th>
                            </cfif>
                            <cfif attributes.is_profit eq 1>
                                <th width="100" style="text-align:right;"><cf_get_lang no='687.Karlılık'></th>
                                <th style="text-align:right;">%</th>
                                <th><cf_get_lang no ='1333.Sapma'></th>
                            </cfif>
                            <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                <th width="75" style="text-align:right;"><cf_get_lang no='658.Brüt Doviz'></th>
                                <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                                <cfif attributes.is_discount eq 1>
                                    <th width="75" style="text-align:right;"><cf_get_lang no='659.İsk Doviz'></th>
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <th width="75" style="text-align:right;"><cf_get_lang no='686.Doviz Kar'></th>
                                    <th style="text-align:right;">%</th>
                                    <th><cf_get_lang no ='1333.Sapma'></th>
                                </cfif>
                                <th style="text-align:center;width:60px;"><cf_get_lang_main no='1062.Birim'></th>
                            </cfif>
                            <th width="35" style="text-align:right;">%</th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>	
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td style="mso-number-format:\@;">#PRODUCT_CODE_2#</td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRODUCT_STOCK,2)#<cfelse>#TLFormat(PRODUCT_STOCK,5)#</cfif><cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif></td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL)#<cfelse>#TLFormat(GROSSTOTAL,5)#</cfif> 
                                    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
                                </td>
                                <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif> 
                                    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
                                </td>
                                <cfif attributes.is_discount eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT)#<cfelse>#TLFormat(DISCOUNT,5)#</cfif> 
                                        <cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif> 
                                    </td> 
                                </cfif>
                                <cfif attributes.is_profit eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR)#<cfelse>#TLFormat(NET_KAR,5)#</cfif>
                                        <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif butun_kar neq 0>#Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",",")#</cfif></td>
                                    <td style="text-align:right;"><cfif PRICE neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR*100)/PRICE,2)#<cfelse>#TLFormat((NET_KAR*100)/PRICE,5)#</cfif></cfif></td>
                                </cfif>
                                <td style="text-align:center;width:60px;">#session.ep.money#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(GROSSTOTAL_DOVIZ)#<cfelse>#TLFormat(GROSSTOTAL_DOVIZ,5)#</cfif> 
                                        <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
                                    </td>
                                    <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif> 
                                        <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif> 	
                                    </td>
                                    <cfif attributes.is_discount eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(DISCOUNT_DOVIZ)#<cfelse>#TLFormat(DISCOUNT_DOVIZ,5)#</cfif> 
                                            <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif> 
                                    </td>	                   
                                    </cfif>
                                    <cfif attributes.is_profit eq 1>
                                        <td style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(NET_KAR_DOVIZ)#<cfelse>#TLFormat(NET_KAR_DOVIZ,5)# </cfif>
                                            <cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif> 	
                                        </td>
                                        <td style="text-align:right;"><cfif diger_butun_kar neq 0>#Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",",")#</cfif></td>
                                        <td style="text-align:right;"><cfif PRICE_DOVIZ neq 0><cfif x_five_digit eq 0>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,2)#<cfelse>#TLFormat((NET_KAR_DOVIZ*100)/PRICE_DOVIZ,4)#</cfif></cfif></td>
                                    </cfif>
                                    <td style="text-align:center;width:60px;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
                                </cfif>
                                <td style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
                            </tr>
                        </cfoutput>				
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr>
                    </cfif>
				<cfelseif attributes.report_type eq 38>
                <cfif isdefined("attributes.model_month") and len(attributes.model_month)>
                	<thead>
                    	<tr>
                        	<th>Ay</th>
                            <th>Model</th>
                            <th>Miktar</th>
                            <th>Birim</th>
                            <th><cf_get_lang_main no='261.Tutar'></th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                    	<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="MODEL_CODE">
                        	<tr>
                            	<td>#INVOICE_DATE#</td>
                                <td>#MODEL_NAME#</td>
                                <td>#PRODUCT_STOCK#</td>
                                <td>#UNIT#</td>
                                <td>#TlFormat(PRICE,2)#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr> 
                    </cfif>
                <cfelse>
                    <cfset first_month = month(dateformat(attributes.date1,dateformat_style))>
                    <cfset last_month = month(dateformat(attributes.date2,dateformat_style))>
                    <thead>
                        <tr>
                            <cfoutput>
                                <cfloop index="aaa" from="#first_month#" to="#last_month#">
                                    <th colspan="4" class="txtbold" style="text-align:center; width:400px;">#aaa#/#session.ep.period_year#</th>
                                </cfloop>
                            </cfoutput>
                        </tr> 
                    </thead>
                    <cfif get_total_purchase.recordcount>
                        <cfset fatura_aylar = ListDeleteDuplicates(valuelist(get_total_purchase.INVOICE_DATE))>
                    <tbody>
                    	<cfif (last_month-first_month) gt listlen(fatura_aylar)>
							<cfset empty_months = ''>
                            <cfloop index="aaa" from="#first_month#" to="#last_month#">
                                <cfif not listfindnocase(fatura_aylar,aaa,',')>
                                    <cfset empty_months = listappend(empty_months,aaa)>
                                </cfif>
                            </cfloop>
                            <cfset kontrol_degiskeni=0>
                            <cfquery name="get_" datasource="#dsn#">
                            <CFLOOP list="#empty_months#" index="bbb">
                                <cfset ++kontrol_degiskeni>
                                 SELECT
                                    #bbb# AS INVOICE_DATE,
                                    '<cfif len(attributes.MODEL_NAME)>#attributes.MODEL_NAME#<cfelse></cfif>' AS MODEL_NAME,
                                    NULL AS PRODUCT_STOCK,
                                    '' AS UNIT,
                                    NULL AS PRICE
                                    <cfif kontrol_degiskeni neq listlen(empty_months)>UNION</cfif>
                                    
                            </CFLOOP>
                           </cfquery>
                            <cfquery name="get_purch" dbtype="query">
                                SELECT
                                    MODEL_NAME,
                                    PRODUCT_STOCK,
                                    UNIT,
                                    INVOICE_DATE,
                                    PRICE
                                FROM
                                    get_total_purchase
                                 UNION
                                 SELECT
                                    MODEL_NAME,
                                    PRODUCT_STOCK,
                                    UNIT,
                                    INVOICE_DATE,
                                    PRICE
                                 FROM
                                    get_
                                 ORDER BY INVOICE_DATE
                            </cfquery>
                        <cfelse>
                            <cfquery name="get_purch" dbtype="query">
                                SELECT
                                    MODEL_NAME,
                                    PRODUCT_STOCK,
                                    UNIT,
                                    INVOICE_DATE,
                                    PRICE
                                FROM
                                    get_total_purchase
                            </cfquery>
                        </cfif>
						<cfoutput query="get_purch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="INVOICE_DATE">
                            <td colspan="4" valign="top">
                                <table cellpadding="0" cellspacing="0">
                                    <thead>
                                    <tr>
                                        <th style="width:100px;" class="txtbold">MODEL</th>
                                        <th class="txtbold" style="text-align:right;width:100px;">MİKTAR</th>
                                        <th class="txtbold" style="text-align:right;width:100px;">BİRİM</th>
                                        <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang_main no='261.Tutar'></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <cfoutput>
                                    <tr>
                                        <td>#MODEL_NAME#</td>
                                        <td>#PRODUCT_STOCK#</td>
                                        <td>#UNIT#</td>
                                        <td>#TlFormat(PRICE,2)#</td>
                                    </tr>
                                    </cfoutput>
                                    </tbody>
                                </table>
                            </td>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr>
                            <td colspan="30"> <cf_get_lang_main no="72.Kayıt yok">!</td>
                        </tr> 
                    </cfif>
                </cfif>
				<cfelseif get_total_purchase.recordcount eq 0>
                    <cfif isdefined('attributes.ajax')>
                        <script type="text/javascript">
                            user_info_show_div(1,1,1);
                        </script>
                    </cfif> 		
                </cfif>
                <tfoot>
					<cfoutput>
					<cfif attributes.report_type neq 38 and get_total_purchase.recordcount neq 0>
							<tr>
								<td colspan="
								<cfif attributes.report_type eq 2>
									<cfset colspan_ = 7>
									<cfif is_brand_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									<cfif is_short_code_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									#colspan_#
								<cfelseif attributes.report_type eq 3>
									<cfset colspan_ = 6>
									<cfif is_brand_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									<cfif is_short_code_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									<cfif isdefined("x_show_special_code") and x_show_special_code eq 1><cfset colspan_ = colspan_ + 1></cfif>
									#colspan_#
								<cfelseif listfind('1,20,22,27,29,32,36',attributes.report_type)>
									2
								<cfelseif listfind('24,25,34,35',attributes.report_type)>
									3
                                <cfelseif   attributes.report_type eq 23>
                                	4
								<cfelseif attributes.report_type eq 4>
									<cfif isdefined("x_show_sales_zone") and x_show_sales_zone eq 1>7<cfelse>6</cfif>
								<cfelseif attributes.report_type eq 19>
									<cfset colspan_ = 15>
									<cfif (isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1)><cfset colspan_ = colspan_ + 1></cfif>
									<cfif attributes.is_project eq 1><cfset colspan_ = colspan_ + 1></cfif>
									<cfif attributes.is_spect_info eq 1><cfset colspan_ = colspan_ + 2></cfif>
                                    <cfif isdefined('x_show_subs') and x_show_subs eq 1><cfset colspan_ = colspan_ + 2></cfif> 	
									<cfif x_show_product_code_2><cfset colspan_ = colspan_ + 1></cfif>  
                                    <cfif IsDefined("attributes.process_type_select") and attributes.process_type_select eq 690><cfset colspan_ = colspan_ + 1></cfif>                                    						
									<cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1><cfset colspan_ = colspan_ + 1></cfif>
									<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1><cfset colspan_ = colspan_ + 1></cfif>
									<cfif isdefined("x_show_account_code") and x_show_account_code eq 1><cfset colspan_ = colspan_ + 1></cfif>
									<cfif is_brand_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									<cfif is_short_code_show eq 1>
										<cfset colspan_ = colspan_ + 1>
									</cfif>
									#colspan_#
								<cfelseif attributes.report_type eq 6>
									2
								<cfelseif listfind('30,39,40,41',attributes.report_type)>
									<cfif x_show_second_unit>
                                    	<cfif listfind('30,40',attributes.report_type)>4<cfelse>3</cfif>
                                    <cfelse>
                                    	<cfif listfind('40',attributes.report_type)>5<cfelse>4</cfif>
                                    </cfif>
								</cfif>" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'>&nbsp;</td>
                                <td class="txtbold" style="text-align:right;">
                                    <cfif listfind('2,3,19',attributes.report_type)>	
                                        <cfset kontrol_=0>	
                                        <cfloop query="get_product_units">							
                                            <cfif get_product_units.unit is 'Kg'>
                                                <cfset kontrol_=1>
                                                <cfset toplam_Kg = toplam_Kg + toplam_Kilogram>
                                            </cfif>
                                            <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                            <cfif evaluate('toplam_#unit_#') gt 0>
                                                #Tlformat(evaluate('toplam_#unit_#'),4)# <br>
                                            </cfif>
                                        </cfloop>
                                    <cfelse>
                                        <cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif>	
                                    </cfif>
                                    <cfif ListFindNoCase("1,32",attributes.report_type)><td></td></cfif>
                                </td>
                                <cfif listfind('2,3,19',attributes.report_type)>
                                <cfif attributes.report_type eq 3>
                                	<td></td>
                                </cfif>
                                	<td class="txtbold" style="text-align:center">                                        
                                            <cfset kontrol_=0>	
                                            <cfloop query="get_product_units">
                                                <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                                <cfif evaluate('toplam_#unit_#') gt 0>
                                                    #unit_# <br>
                                                </cfif>
                                            </cfloop>
                                    </td>
                                </cfif>  
                                <cfif x_show_second_unit>  
                                    <cfif attributes.report_type eq 19>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier_amount_2,4)#</td>
                                    <cfelseif  listfind('1,32',attributes.report_type)>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier,4)#</td>
                                        <td></td>  
                                    <cfelseif attributes.report_type eq 2>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier_amount_1,4)#</td>                                                                  
                                    </cfif>   
                                </cfif>                               	
                                <cfif x_unit_weight eq 1>
									<cfif attributes.report_type eq 19>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght_1,4)#</td>
                                    <cfelseif listfind('2,3',attributes.report_type)>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght,4)#</td>
                                    </cfif>
                                </cfif>
                                <!---<cfif x_unit_weight eq 1>
									<cfif attributes.report_type eq 19>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght_1,4)#</td>
                                    <cfelseif listfind('2,3',attributes.report_type)>>
                                        <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght,4)#</td>
                                    </cfif>
                                </cfif>--->
                                <cfif listfind('2,3,40,41',attributes.report_type)>
									<cfif x_show_second_unit>
                                	<td class="txtbold" style="text-align:right;">
                                    <cfset unit2_list = listdeleteduplicates(unit2_list)>
                                    	<cfloop list="#unit2_list#" index="cc">
											<cfset unit2_ = filterSpecialChars(cc)>
                                            <cfif x_five_digit eq 0>#TLFormat(evaluate('toplam_miktar_#unit2_#'))#<cfelse>#TLFormat(evaluate('toplam_miktar_#unit2_#'),5)#</cfif> <br>
										</cfloop>
									</td>
									<td class="txtbold" style="text-align:center">
                                    	<cfset unit2_list = listdeleteduplicates(unit2_list)>
										<cfloop list="#unit2_list#" index="cc">
											<cfset unit2_ = filterSpecialChars(cc)>
												#unit2_# <br>
										</cfloop>
									</td>
                                    </cfif>
								</cfif>
								<cfif attributes.report_type eq 19 and attributes.is_priceless eq 1>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_bedelsiz)#<cfelse>#TLFormat(toplam_bedelsiz,5)#</cfif></td>
								</cfif>
								<cfif attributes.report_type eq 19><td></td></cfif>
								<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_brut)#<cfelse>#TLFormat(toplam_brut,5)#</cfif></td>
								<cfif attributes.report_type eq 19>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_net_fiyat)#<cfelse>#TLFormat(toplam_net_fiyat,5)#</cfif></td>
								</cfif>
								<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></td>
								<cfif attributes.is_discount eq 1>
									<cfif attributes.report_type eq 19 and isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
										<cfloop from="1" to="#listlen(attributes.exp_discounts)#" index="disc_indx">
											<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(evaluate("total_discount_#listgetat(attributes.exp_discounts,disc_indx)#"))#<cfelse>#TLFormat(evaluate("total_discount_#listgetat(attributes.exp_discounts,disc_indx)#"),5)#</cfif></td>
										</cfloop>
									</cfif>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_isk_tutar)#<cfelse>#TLFormat(toplam_isk_tutar,5)#</cfif></td>
								</cfif>
								<cfif attributes.report_type eq 19 and attributes.is_cost_price eq 1>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_cost_price)#<cfelse>#TLFormat(toplam_cost_price,5)#</cfif></td>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_cost_price_all)#<cfelse>#TLFormat(toplam_cost_price_all,5)#</cfif></td>
								</cfif>
								<cfif attributes.is_profit eq 1>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_karlilik)#<cfelse>#TLFormat(toplam_karlilik,5)#</cfif></td>
									<td class="txtbold" style="text-align:right;"><cfif butun_kar neq 0><cfif x_five_digit eq 0>#TLFormat(toplam_karlilik*100/butun_kar)#<cfelse>#TLFormat(toplam_karlilik*100/butun_kar,5)#</cfif></cfif></td>
									<cfif listfind('1,2,3,9,19,30,31,32,42',attributes.report_type)><td>&nbsp;</td></cfif>
								</cfif>
								<td class="txtbold" style="text-align:center;width:60px;">#session.ep.money#</td>
								<cfif attributes.is_other_money eq 0 and attributes.is_money2 eq 1 >
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_brut_doviz)#<cfelse>#TLFormat(toplam_brut_doviz,5)#</cfif></td>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_doviz)#<cfelse>#TLFormat(toplam_doviz,5)#</cfif></td>
									<cfif attributes.report_type eq 19><td></td></cfif>
								<cfelseif attributes.is_other_money eq 1>
									<td></td>
                                    <td class="txtbold" style="text-align:right;">
                                        <cfloop from="1" to="#money_type_counter#" index="m">
                                            <cfset rapor.money_array["money_total"][m] = wrk_round(rapor.money_array["money_total"][m],2)>
                                            <b>#TLFormat(rapor.money_array["money_total"][m],2)#</b> <br>
                                        </cfloop> 
                                    </td>    
                                    <cfif attributes.report_type eq 19><td></td></cfif>
								</cfif>
								<cfif attributes.is_discount eq 1>
									<cfif attributes.is_other_money eq 1>
										<td></td>
									<cfelseif attributes.is_money2 eq 1>
										<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_isk_doviz)#<cfelse>#TLFormat(toplam_isk_doviz,5)#</cfif></td>
									</cfif>
								</cfif>
								<cfif attributes.report_type eq 19 and attributes.is_cost_price eq 1>
									<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1 and attributes.is_money2 eq 1>
										<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_cost_price_2)#<cfelse>#TLFormat(toplam_cost_price_2,5)#</cfif></td>
										<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_cost_price_all_2)#<cfelse>#TLFormat(toplam_cost_price_all_2,5)#</cfif></td>
									</cfif>
								</cfif>
								<cfif attributes.is_cost_price eq 1 and x_show_other_money_cost eq 1 and isdefined('attributes.cost_type') and attributes.cost_type eq 1>
									<td></td>
									<td></td>
									<td></td>
								</cfif>
								<cfif attributes.is_profit eq 1>
									<cfif attributes.is_other_money eq 1>
										<td></td><td></td><td></td>
										<cfif listfind('1,2,3,9,19,30,31,32',attributes.report_type)><td></td></cfif>
									<cfelseif attributes.is_money2 eq 1>
										<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_doviz_kar)#<cfelse>#TLFormat(toplam_doviz_kar,5)#</cfif></td>
										<td>&nbsp;</td>
										<cfif listfind('1,2,3,9,19,30,31,32,42',attributes.report_type)><td></td></cfif>
										<!--- <cfif listfind('19,30',attributes.report_type)><td></td></cfif> --->
									</cfif>
								<cfelse>
									<cfif attributes.is_other_money eq 1 and attributes.is_money2 neq 1>
                                    <td class="txtbold" style="text-align:center;">
                                        <cfloop from="1" to="#money_type_counter#" index="m">
                                            <b>#rapor.money_array["money_type"][m]#</b> <br>
                                        </cfloop> 
                                    </td></cfif>
								</cfif>
								<cfif attributes.is_money2 eq 1>
									<td class="txtbold" style="text-align:center;width:60px;">#session.ep.money2#</td>
								</cfif>
								<cfif attributes.report_type eq 19 and attributes.is_cost_price eq 1>
									<td></td>
									<td class="txtbold" style="text-align:right;"><cfif x_five_digit eq 0>#TLFormat(toplam_marj_all)#<cfelse>#TLFormat(toplam_marj_all,5)#</cfif></td>
								</cfif>
								<td class="txtbold" style="text-align:right;"><cfif butun_toplam neq 0><cfif x_five_digit eq 0>#TLFormat(toplam_satis*100/butun_toplam)#<cfelse>#TLFormat((toplam_satis*100/butun_toplam),5)#</cfif></cfif></td>
							</tr>
						</cfif>
					</cfoutput>
                </tfoot>
            </cf_report_list>
    </cfif>
    <cfset adres = "">
    <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
        <cfset adres = "#fusebox.circuit#.sale_analyse_report&form_submitted=1">
        <cfif len(attributes.process_type_)>
            <cfset adres = "#adres#&process_type_=#attributes.process_type_#">
        </cfif>
        <cfif len(attributes.process_type_select)>
            <cfset adres = "#adres#&process_type_select=#attributes.process_type_select#">
        </cfif>
        <cfif len(attributes.graph_type)>
            <cfset adres = "#adres#&graph_type=#attributes.graph_type#">
        </cfif>
        <cfif len(attributes.report_sort)>
            <cfset adres = "#adres#&report_sort=#attributes.report_sort#">
        </cfif>
        <cfif len(attributes.product_id)>
            <cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
        </cfif>
        <cfif len(attributes.employee_id)>
            <cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee_name=#attributes.employee_name#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset adres = "#adres#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.department_id)>
            <cfset adres = "#adres#&department_id=#attributes.department_id#">
        </cfif>
        <cfif len(attributes.brand_name) and len(attributes.brand_id)>
            <cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
        </cfif>
        <cfif len(attributes.model_name) and len(attributes.model_id)>
            <cfset adres = "#adres#&model_id=#attributes.model_id#&model_name=#attributes.model_name#">
        </cfif>
        <cfif len(attributes.sup_company_id)>
            <cfset adres = "#adres#&sup_company_id=#attributes.sup_company_id#&sup_company=#attributes.sup_company#">
        </cfif>
        <cfif len(attributes.company_id)>
            <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
        </cfif>
        <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
        </cfif>
        <cfif isdefined('attributes.employee_id2') and len(attributes.employee_id2)>
            <cfset adres = "#adres#&employee_id2=#attributes.employee_id2#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
            <cfset adres = "#adres#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
        </cfif>
        <cfif len(attributes.search_product_catid)>
            <cfset adres = "#adres#&search_product_catid=#attributes.search_product_catid#&product_cat=#attributes.product_cat#">
        </cfif>
        <cfif isdate(attributes.date1) and isdefined("attributes.date1") and len(attributes.date1)>
			<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.date2) and isdefined("attributes.date2") and len(attributes.date2)>
			<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
		</cfif>
        <cfif len(attributes.report_type)>
            <cfset adres = "#adres#&report_type=#attributes.report_type#">
        </cfif>
        <cfif len(attributes.product_employee_id)>
            <cfset adres = "#adres#&product_employee_id=#attributes.product_employee_id#">
        </cfif>
        <cfif len(attributes.employee_name)>
            <cfset adres = "#adres#&employee_name=#attributes.employee_name#">
        </cfif>
        <cfif len(attributes.zone_id) and IsDefined("attributes.zone_id")>     
            <cfset adres = "#adres#&zone_id=#attributes.zone_id#">
        </cfif>
		<cfif len(attributes.main_properties)>
            <cfset adres = "#adres#&main_properties=#attributes.main_properties#">
        </cfif>
        <cfif len(attributes.main_dt_properties)>
            <cfset adres = "#adres#&main_dt_properties=#attributes.main_dt_properties#">
        </cfif>
        <cfif len(attributes.resource_id)>
            <cfset adres = "#adres#&resource_id=#attributes.resource_id#">
        </cfif>
        <cfif len(attributes.ims_code_id)>
            <cfset adres = "#adres#&ims_code_id=#attributes.ims_code_id#">
        </cfif>
        <cfif len(attributes.customer_value_id)>
            <cfset adres = "#adres#&customer_value_id=#attributes.customer_value_id#">
        </cfif>
        <cfif isdefined("attributes.is_sale_product")>
            <cfset adres = "#adres#&is_sale_product=#attributes.is_sale_product#">
        </cfif>
        <cfif len(attributes.segment_id)>
            <cfset adres = "#adres#&segment_id=#attributes.segment_id#">
        </cfif>
        <cfif len(attributes.price_catid)>
            <cfset adres = "#adres#&price_catid=#attributes.price_catid#">
        </cfif>
        <cfif isDefined("attributes.is_kdv") and len(attributes.is_kdv)>
            <cfset adres = "#adres#&is_kdv=#attributes.is_kdv#">
        </cfif>
        <cfif isDefined("attributes.is_prom") and len(attributes.is_prom)>
            <cfset adres = "#adres#&is_prom=#attributes.is_prom#">
        </cfif>
        <cfif isDefined("attributes.is_other_money") and len(attributes.is_other_money)>
            <cfset adres = "#adres#&is_other_money=#attributes.is_other_money#">
        </cfif>
        <cfif isDefined("attributes.is_money2") and len(attributes.is_money2)>
            <cfset adres = "#adres#&is_money2=#attributes.is_money2#">
        </cfif>
        <cfif isDefined("attributes.is_discount") and len(attributes.is_discount)>
            <cfset adres = "#adres#&is_discount=#attributes.is_discount#">
        </cfif>
        <cfif len(attributes.city_id)>
            <cfset adres = "#adres#&city_id=#attributes.city_id#">
        </cfif>
        <cfif isDefined("attributes.is_profit") and len(attributes.is_profit)>
            <cfset adres = "#adres#&is_profit=#attributes.is_profit#">
        </cfif>
        <cfif len(attributes.member_cat_type)>
            <cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
        </cfif>
        <cfif isDefined("attributes.project_id") and len(attributes.project_id)>
            <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
        </cfif>
        <cfif isDefined("attributes.is_priceless") and attributes.is_priceless eq 1>
            <cfset adres = "#adres#&is_priceless=1">
        </cfif>
        <cfif isDefined("attributes.is_price_change") and attributes.is_price_change eq 1>
            <cfset adres = "#adres#&is_price_change=1">
        </cfif>
        <cfif isDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
            <cfset adres = "#adres#&sector_cat_id=#attributes.sector_cat_id#">
        </cfif>
        <cfif isDefined("attributes.ref_member_id") and len(attributes.ref_member_id)>
            <cfset adres = "#adres#&ref_member_id=#attributes.ref_member_id#">
        </cfif>
        <cfif isDefined("attributes.ref_member_type") and len(attributes.ref_member_type)>
            <cfset adres = "#adres#&ref_member_type=#attributes.ref_member_type#">
        </cfif>
        <cfif isDefined("attributes.ref_member") and len(attributes.ref_member)>
            <cfset adres = "#adres#&ref_member=#attributes.ref_member#">
        </cfif>
        <cfif isDefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
            <cfset adres = "#adres#&exp_discounts=#attributes.exp_discounts#">
        </cfif>
        <cfif isDefined("attributes.prom_head") and len(attributes.prom_head)>
            <cfset adres = "#adres#&prom_head=#attributes.prom_head#">
        </cfif>
        <cfif isDefined("attributes.cost_type")>
            <cfset adres = "#adres#&cost_type=1">
        </cfif>
        <cfif isDefined("attributes.is_location_cost")>
            <cfset adres = "#adres#&is_location_cost=1">
        </cfif>	
        <cfif isDefined("attributes.is_zero_value")>
            <cfset adres = "#adres#&is_zero_value=1">
        </cfif>
        <cfif isDefined("attributes.is_cost_price")>
            <cfset adres = "#adres#&is_cost_price=#attributes.is_cost_price#">
        </cfif> 
        <cfif isDefined("attributes.is_project")>
            <cfset adres = "#adres#&is_project=#attributes.is_project#">
        </cfif>
        <cfif isDefined("attributes.is_spect_info")>
            <cfset adres = "#adres#&is_spect_info=#attributes.is_spect_info#">
        </cfif>
        <cfif isDefined("attributes.ship_method_id")>
            <cfset adres = "#adres#&ship_method_id=#attributes.ship_method_id#">
        </cfif>
        <cfif isDefined("attributes.ship_method_name")>
            <cfset adres = "#adres#&ship_method_name=#attributes.ship_method_name#">
        </cfif>
        <cfif isDefined("attributes.product_types")>
            <cfset adres = "#adres#&product_types=#attributes.product_types#">
        </cfif>
		<cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
			<cfset adres = adres&"&use_efatura="&attributes.use_efatura>
        </cfif>
        <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"></td>
           
    </cfif>
    <!--- Grafik Başlangıç --->
    <cfif isdefined("attributes.form_submitted") and len(attributes.graph_type) and isdefined('get_total_purchase_3.recordcount') and get_total_purchase_3.recordcount>
    <br>
                <cfif isDefined("form.graph_type") and len(form.graph_type)>
                    <cfset graph_type = form.graph_type>
                <cfelse>
                    <cfset graph_type = "bar">
                </cfif>
                <script src="JS/Chart.min.js"></script> 
                    <cfoutput query="get_total_purchase">
                        <cfset 'sum_of_total#currentrow#' =  NumberFormat(PRICE*100/butun_toplam,'00.00')>
                        <!--- Kategori Bazında ise --->
                        <cfif attributes.report_type eq 1 or attributes.report_type eq 32>
                            <cfset item_value = PRODUCT_CAT >
                        <!--- Ürün Bazında ise --->
                        <cfelseif attributes.report_type eq 2>
                            <cfset item_value = left(PRODUCT_NAME,30)>
                        <!--- Stok Bazında --->
                        <cfelseif attributes.report_type eq 3>
                            <cfset item_value = left('#PRODUCT_NAME#&nbsp;#PROPERTY#',30)>
                        <!--- Müşteri Bazında --->
                        <cfelseif attributes.report_type eq 4>
                            <cfset item_value = left(MUSTERI,30)>
                        <!--- Müşteri Tipi Bazında --->
                        <cfelseif attributes.report_type eq 5>
                            <cfset item_value = left(MUSTERI_TYPE,30)>
                        <!--- Tedarikçi Bazında --->
                        <cfelseif attributes.report_type eq 6>
                            <cfset item_value = left(MUSTERI,30)>
                        <!--- Şube Bazında --->
                        <cfelseif attributes.report_type eq 7>
                            <cfset item_value = left(BRANCH_NAME,30)>
                        <!--- Satış Yapan Bazında --->
                        <cfelseif attributes.report_type eq 8>
                            <cfset item_value = left('#EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME#',30)>
                        <!--- Marka Bazında --->
                        <cfelseif attributes.report_type eq 9>
                            <cfset item_value = left(BRAND_NAME,30)>
                        <!--- Müşteri Değeri Bazında --->
                        <cfelseif attributes.report_type eq 10>
                            <cfset item_value = left(GET_CUSTOMER_VALUE_2.CUSTOMER_VALUE[listfind(list_customer_val_ids,CUSTOMER_VALUE_ID,',')],30)>
                        <!--- İlişki Tipi Bazında --->
                        <cfelseif attributes.report_type eq 11>
                            <cfset item_value = left(GET_RESOURCE_2.RESOURCE[listfind(list_resource_ids,RESOURCE_ID,',')],30)>
                        <!--- Mikro Bölge Bazında --->
                        <cfelseif attributes.report_type eq 12>
                            <cfset item_value = left(IMS_CODE_NAME,30)>
                        <!--- Satış Bölgesi Bazında --->
                        <cfelseif attributes.report_type eq 13>
                            <cfset item_value = left(SZ_2.SZ_NAME[listfind(list_zone_ids,ZONE_ID,',')],30)>
                        <!--- Ödeme Yöntemi Bazında --->
                        <cfelseif attributes.report_type eq 14>
                            <cfif len(PAY_METHOD) and listfind(list_pay_ids,PAY_METHOD,',')>
                                <cfset item_value = left('#GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAY_METHOD,',')]#',30)>
                            <cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
                                <cfset item_value =left('#GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#',30)>
                            <cfelse>
                                <cfset item_value =	''>
                            </cfif>
                        <!---Hedef Pazar Bazında --->
                        <cfelseif attributes.report_type eq 15>
                            <cfset item_value = left(GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')],30)>
                        <!---İl Bazında --->
                        <cfelseif attributes.report_type eq 16>
                            <cfset item_value = left(get_city.city_name[listfind(city_id_list,get_total_purchase.city,',')],30)>
                        <!---Proje Bazında --->
                        <cfelseif attributes.report_type eq 17>
                            <cfset item_value = left(get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')],30)>
                        <!---Ürün Sorumlusu Bazında --->
                        <cfelseif attributes.report_type eq 18>
                            <cfset item_value = left('#get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;#get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#',30)>
                        <!---Belge ve Stok Bazında --->
                        <cfelseif attributes.report_type eq 19>
                            <cfset item_value = left(INVOICE_NUMBER,30)>
                        <!---Promosyon Bazında --->
						<cfelseif attributes.report_type eq 42>
							<cfset item_value = left(PRODUCT_CODE_2,30)>
                        <cfelseif attributes.report_type eq 20>
                            <cfset item_value = left(PROM_NO,30)>
                        <!--- Müşteri Temsilcisi Bazında --->
                        <cfelseif attributes.report_type eq 21>
                            <cfset item_value = left('#get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;#get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#',30)>
                        <!--- Müşteri Temsilcisi ve Ürün Bazında --->
                        <cfelseif attributes.report_type eq 22>
                            <cfset item_value = left('#get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;#get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;#PRODUCT_NAME#',40)>
                        <!--- Müşteri Temsilcisi,Müşteri ve Ürün Bazında --->
                        <cfelseif attributes.report_type eq 23>
                            <cfset item_value = left('#get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;#get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')]#&nbsp;#PRODUCT_NAME#',40)>
                        <!--- Vergi No Bazında --->
                        <cfelseif attributes.report_type eq 24>
                            <cfset item_value = left('#taxoffice#',40)>
                        <!--- Satış Yapan,Müşteri ve Ürün Bazında --->
                        <cfelseif attributes.report_type eq 25>
                            <cfset item_value = left('#get_employee.employee_name[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;#get_employee.employee_surname[listfind(employee_id_list,get_total_purchase.sale_emp,',')]#&nbsp;#PRODUCT_NAME#',40)>
                        <!--- Satış Ortağı Bazında --->
                        <cfelseif attributes.report_type eq 26>	
                            <cfif len(sales_member_id) and sales_member_type eq 1 and len(partner_list)>
                                <cfset item_value = left('#get_partner_name.company_partner_name[listfind(partner_list,sales_member_id,',')]#&nbsp;#get_partner_name.company_partner_surname[listfind(partner_list,sales_member_id,',')]#',40)>
                            <cfelseif len(sales_member_id) and sales_member_type eq 2 and len(consumer_list)>
                                <cfset item_value = left('#get_consumer_name.consumer_name[listfind(consumer_list,sales_member_id,',')]# #get_consumer_name.consumer_surname[listfind(consumer_list,sales_member_id,',')]#',40)>
                            <cfelse>
                                <cfset item_value = ''>
                            </cfif>
                        <!--- Referans Kod Bazında --->
                        <cfelseif attributes.report_type eq 27>
                            <cfset item_value = left('#MUSTERI#&nbsp;#member_reference_code#',40)>
                        <!--- Fiyat Listesi Bazında --->
                        <cfelseif attributes.report_type eq 28>
                            <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                <cfset item_value = left('#get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#',40)>
                            <cfelseif price_cat eq -2>
                                <cfset item_value = 'Standart Satış'>
                            <cfelseif price_cat eq -1>
                                <cfset item_value = 'Standart Alış'>
                            <cfelse>
                                <cfset item_value = ''>
                            </cfif>
                        <!--- Müşteri Temsilcisi ve Fiyat Listesi Bazında --->
                        <cfelseif attributes.report_type eq 29>
                            <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                <cfset item_value = left('#get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#',40)>
                            <cfelseif price_cat eq -2>
                                <cfset item_value = 'Standart Satış'>
                            <cfelseif price_cat eq -1>
                                <cfset item_value = 'Standart Alış'>
                            <cfelse>
                                <cfset item_value = ''>
                            </cfif>
                        <!--- Fiyat Listesi ve Ürün Bazında --->
                        <cfelseif attributes.report_type eq 30>
                            <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                <cfset item_value = left('#get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#',40)>
                            <cfelseif price_cat eq -2>
                                <cfset item_value = 'Standart Satış'>
                            <cfelseif price_cat eq -1>
                                <cfset item_value = 'Standart Alış'>
                            <cfelse>
                                <cfset item_value = ''>
                            </cfif>
                            <cfset item_value = '#item_value#-#left(PRODUCT_NAME,30)#'>
                        <cfelseif attributes.report_type eq 31>
                            <cfset item_value = left(get_country.country_name[listfind(country_id_list,get_total_purchase.country_id,',')],30)>
                        <cfelseif attributes.report_type eq 33>
                            <cfset item_value = left(GET_SECTOR.SECTOR_CAT[listfind(list_sector_ids,SECTOR_CAT_ID,',')],30)>
                        <cfelseif attributes.report_type eq 34>
                            <cfset item_value = Left(get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&Left(get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&"-"&PRODUCT_CAT>
                        <cfelseif attributes.report_type eq 35>
                            <cfset item_value = Left(get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&Left(get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&"-"&PRODUCT_CAT>
						<cfelseif attributes.report_type eq 36>
                            <cfset item_value = Left(get_position.employee_name[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&Left(get_position.employee_surname[listfind(position_code_list,get_total_purchase.wp_position_code,',')],30)&"-"&left(MUSTERI_TYPE,30)>
                        </cfif>
                        <cfset 'item_#currentrow#' = "#item_value#">
					    <cfset 'value_#currentrow#' = "#wrk_round(Evaluate("sum_of_total#currentrow#"))#">
                     </cfoutput>
                  <script src="JS/Chart.min.js"></script> 
                <canvas id="myChart" style="float:left;max-width:500px;max-height:500px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Satış Analiz Fatura",
									backgroundColor: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj"><cfoutput>#NumberFormat(evaluate("value_#jj#"),'00')#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>
    <br />
    </cfif>
</div>
<script type="text/javascript">
    <cfif attributes.is_excel eq 1>
        $(function(){
            TableToExcel.convert(document.getElementById('sales_list'));
           $('#sales_list').remove();
        });
        
    </cfif>
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
	function degistir_report()
	{
		if(document.getElementById('report_type').value == 19)
		{
			//money_info_2.style.display = '';
			is_priceless_page.style.display = '';
			if(is_cost_page != undefined)
			is_cost_page.style.display = '';
			is_project.style.display = '';
			spect_info_2.style.display = '';
		}
		else if(document.getElementById('report_type').value == 38)
		{
			document.getElementById('model_month_td').style.display = '';
		}
		else
		{
			//money_info_2.style.display = 'none';
			//document.rapor.is_money_info.checked = false;
			is_priceless_page.style.display = 'none';
			document.getElementById(rapor.is_priceless).checked = false;
			is_cost_page.style.display = 'none';
			document.getElementById(rapor.is_cost_price).checked = false;
			document.getElementById(is_project).style.display = 'none';
			document.getElementById(rapor.is_project).checked = false;
			spect_info_2.style.display = 'none';
			document.getElementById(rapor.is_spect_info).checked = false;
			document.getElementById('model_month_td').style.display = 'none';
			document.getElementById(rapor.model_month).checked = false
		}
		if(document.getElementById(rapor.report_type).value == 29)
			is_price_change_page.style.display = '';
		else
		{
			<cfif isDefined('x_prod_prop_filter') and len(x_prod_prop_filter)>
				var report_list = '<cfoutput>#x_prod_prop_filter#</cfoutput>'
				if(list_find(report_list,document.getElementById('report_type').value,','))
				{
					goster(main_prop1);	
					goster(main_prop2);	
					goster(main_prop3);	
					goster(main_prop4);	
				}
				else
				{
					gizle(main_prop1);	
					gizle(main_prop2);	
					gizle(main_prop3);	
					gizle(main_prop4);	
				}
			</cfif>
			is_price_change_page.style.display = 'none';
			document.rapor.is_price_change.checked = false;
		}
		show_discount();
	}
	
	<cfif isDefined('x_prod_prop_filter') and len(x_prod_prop_filter)>
		function get_sub_properties(mdtp)
		{
			gizle(main_prop4);
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_get_prod_dt_ajax&main_prop='+mdtp+'','main_prop4',1);
			goster(main_prop4);
		}
	</cfif>
		
	function satir_kontrol()
	{
		document.getElementById('process_type_select').value = document.getElementById('process_type_').value;
		var process_selected=0;
		for(kk=0;kk<document.rapor.process_type_.length; kk++)
		{
			if(document.rapor.process_type_[kk].selected)
			{
				process_selected = 1;
			}
		}
		if(process_selected != 1)
		{
			alert("<cfoutput>#getLang('main',1358)#</cfoutput>");
			return false;
		}
		var process_type_list='';
		if(list_find('1,2,3',document.getElementById('report_type').value)) //stok,urun veya kategori bazında ise çalışıyor
		{
			for(kk=0;kk<document.rapor.process_type_.length; kk++)
			{
				if(document.rapor.process_type_[kk].selected && document.rapor.process_type_.options[kk].value.length!='' && list_find('670,690',document.rapor.process_type_.options[kk].value))
				{
					process_type_list= process_type_list + ',' + document.rapor.process_type_.options[kk].value;
				}
				/*if(process_type_list.length!='' && document.rapor.process_type_[kk].selected && document.rapor.process_type_.options[kk].value!=670 && document.rapor.process_type_.options[kk].value!=690)
				{
					alert("<cf_get_lang no ='1821.Yazar Kasa ve Z Raporu İşlem Tiplerini Ayrı Seçiniz!'>");
					return false;
				}*/
			}
            if(process_type_list.length!='' && list_find(process_type_list,'670') && list_find(process_type_list,'690'))
            { 
                alert("<cf_get_lang no ='1821.Yazar Kasa ve Z Raporu İşlem Tiplerini Ayrı Seçiniz!'>");
                return false;
            }
		}
		var process_type_list_='';
		if(list_find('19',document.getElementById('report_type').value)) //belge ve stok bazında ise çalışıyor
		{
			for(kk=0;kk<document.rapor.process_type_.length; kk++)
			{
				if(document.rapor.process_type_[kk].selected)
				{
					process_type_list_= process_type_list_ + ',' + document.rapor.process_type_.options[kk].value;
				}
			}
			if(process_type_list_.length=='')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='388.İşlem Tipi'>");
				return false;
			}
		}
		if(document.rapor.is_excel.checked == false)
			if(document.rapor.maxrows.value > 1000)
			{
				alert ("<cf_get_lang no ='1565.Görüntüleme Sayısı 1000 den fazla olamaz'>!");
				return false;
			}
        if ((document.rapor.date1.value != '') && (document.rapor.date2.value != '') &&
	    !date_check(rapor.date1,rapor.date2,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	        return false;
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.sale_analyse_report</cfoutput>";
			return true;
		}
		else $('#rapor').submit();
       
	}
	function show_discount()
	{
		if(document.rapor.exp_discounts != undefined)
			if(document.rapor.is_discount.checked == true && document.rapor.report_type.value == 19)
			{
				discount1.style.display = '';
				discount2.style.display = '';
			}
			else
			{
				discount1.style.display = 'none';
				discount2.style.display = 'none';
			}
	}
	function change_cost()
	{
		if(location_cost != undefined)
			if(document.rapor.cost_type.checked == true)
			{
				location_cost.style.display = '';
			}
			else
			{
				location_cost.style.display = 'none';
			}
	}
	function dissable_check(type)
	{
		if (type == 1)
			document.getElementById("is_money2").checked = false;
		else if(type == 2)
			document.getElementById("is_other_money").checked = false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
