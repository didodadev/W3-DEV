<cfquery name="UPD_INVOICE" datasource="#dsn2#">
	UPDATE 
		INVOICE 
	SET 
		IS_CASH = <cfif isDefined("FORM.CASH")>1<cfelse>0</cfif>,
		IS_BANK = <cfif isdefined("attributes.bank")>1<cfelse>0</cfif>,
		IS_CREDITCARD = <cfif isdefined("attributes.credit")>1<cfelse>0</cfif>,
		KASA_ID = <cfif isDefined("FORM.CASH") and len(KASA)>#KASA#<cfelseif isdefined("attributes.bank")>#attributes.account_id#<cfelse>NULL</cfif>,
		IS_IPTAL = 0,
		CANCEL_TYPE_ID = NULL,
		SERIAL_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SERIAL_NUMBER#">,
		INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.INVOICE_NUMBER#">,
		SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SERIAL_NO#">,
		INVOICE_DATE = #attributes.INVOICE_DATE#,
        PROCESS_DATE = <cfif isdefined("attributes.process_date") and len(attributes.process_date)><cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#attributes.process_date#"><cfelse>NULL</cfif>,
		DUE_DATE = <cfif len(invoice_due_date) and isdate(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
		INVOICE_CAT = #INVOICE_CAT#,
		PROCESS_CAT = #form.PROCESS_CAT#,
		NETTOTAL=#attributes.BASKET_NET_TOTAL#,
		GROSSTOTAL = #attributes.BASKET_GROSS_TOTAL#,
		GROSSTOTAL_WITHOUT_ROUND=<cfif len(attributes.yuvarlama)>#Evaluate(form.basket_net_total-attributes.yuvarlama)#,<cfelse>#form.basket_net_total#,</cfif>
		TAXTOTAL=#attributes.BASKET_TAX_TOTAL#,
		OTV_TOTAL =	<cfif len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
		SA_DISCOUNT=#form.genel_indirim#,
		OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BASKET_MONEY#">,
		OTHER_MONEY_VALUE=#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
		DELIVER_EMP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET_ID),50)#">,
		DEPARTMENT_ID = #attributes.department_id#,
		DEPARTMENT_LOCATION = #attributes.location_id#,
		PAY_METHOD = <cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id) and isdefined('attributes.paymethod') and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
		SHIP_METHOD = <cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		ROUND_MONEY =<cfif len(attributes.yuvarlama)>#attributes.yuvarlama#<cfelse>NULL</cfif>,
	<cfif isdefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
		SALE_EMP = #EMPO_ID#,
		SALE_PARTNER = NULL,
	<cfelseif isdefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.PARTO_ID)>
		SALE_EMP = NULL,
		SALE_PARTNER = #PARTO_ID#,
	<cfelse>
		SALE_EMP = NULL,
		SALE_PARTNER = NULL,
	</cfif>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
		COMPANY_ID = #attributes.company_id#,
		PARTNER_ID = <cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
		CONSUMER_ID = NULL,
		EMPLOYEE_ID = NULL,
	<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		COMPANY_ID = NULL,
		PARTNER_ID = NULL,
		CONSUMER_ID = #attributes.consumer_id#,
		EMPLOYEE_ID = NULL,
	<cfelse>
		COMPANY_ID = NULL,
		PARTNER_ID = NULL,
		CONSUMER_ID = NULL,
		EMPLOYEE_ID = #attributes.employee_id#,
	</cfif>
		NOTE=<cfif isDefined("NOTE") and len(NOTE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#NOTE#"><cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,	
		UPDATE_EMP = #SESSION.EP.USERID#,
		<cfif session.ep.our_company_info.project_followup eq 1>
			PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
		</cfif>
		IS_COST = 0,
		REF_NO = <cfif isdefined('attributes.ref_no') and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
	<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
		CARD_PAYMETHOD_ID= #attributes.card_paymethod_id#,
		CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
	<cfelse>
		CARD_PAYMETHOD_ID= NULL,
		CARD_PAYMETHOD_RATE = NULL,
	</cfif>
		CONSUMER_REFERENCE_CODE = <cfif isdefined('attributes.consumer_reference_code') and len(attributes.consumer_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_reference_code#"><cfelse>NULL</cfif>,
		IS_TAX_OF_OTV = <cfif isdefined('attributes.basket_otv_from_tax_price') and len(attributes.basket_otv_from_tax_price)>#attributes.basket_otv_from_tax_price#<cfelse>NULL</cfif>,
		CARI_ACTION_TYPE = <!--- parçalı cari işlemi tutuyor --->
			<cfif isDefined("attributes.invoice_payment_plan") and attributes.invoice_payment_plan eq 0>
				<!--- FBS 20120711 Odeme Planini Yeniden Olusturmamasi Icin Type Degerinin Tasinmasi Gerekiyor --->
				<cfif isDefined("attributes.invoice_cari_action_type") and Len(attributes.invoice_cari_action_type)>#attributes.invoice_cari_action_type#<cfelse>4</cfif>
			<cfelse>
				0
			</cfif>, 
		TEVKIFAT = <cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
		TEVKIFAT_ORAN = <cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
		TEVKIFAT_ID = <cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
		ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		ACC_DEPARTMENT_ID = <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
		SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_no) and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		STOPAJ = <cfif isdefined("form.stopaj") and len(form.stopaj)>#form.stopaj#<cfelse>NULL</cfif>,
		STOPAJ_ORAN = <cfif isdefined("form.stopaj_yuzde") and len(form.stopaj_yuzde)>#form.stopaj_yuzde#<cfelse>NULL</cfif>,
		STOPAJ_RATE_ID = <cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>NULL</cfif>,
        CITY_ID = <cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
        COUNTY_ID = <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
        DELIVER_COMP_ID = <cfif isdefined("attributes.deliver_comp_id") and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#<cfelse>NULL</cfif>,
        DELIVER_CONS_ID = <cfif isdefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#<cfelse>NULL</cfif>,
        SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
        SHIP_ADDRESS = <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
		CONTRACT_ID = <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
		ACC_TYPE_ID = <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		REALIZATION_DATE = <cfif isdefined("attributes.realization_date") and len(attributes.realization_date) and isdate(attributes.realization_date)>#attributes.realization_date#<cfelse>NULL</cfif>,
        BSMV_TOTAL = <cfif isdefined("attributes.total_bsmv") and len(attributes.total_bsmv)>#attributes.total_bsmv#<cfelse>0</cfif>,
		OIV_TOTAL = <cfif isdefined("attributes.total_oiv") and len(attributes.total_oiv)>#attributes.total_oiv#<cfelse>0</cfif>,
		VAT_EXCEPTION_ID = <cfif isdefined("form.exc_id") and len(form.exc_id)>#form.exc_id#<cfelse>NULL</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>, PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"></cfif>,
		IS_EARCHIVE = <cfif isDefined("attributes.is_earchive")>1<cfelse>0</cfif>
    WHERE 
		INVOICE_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_ROW" datasource="#dsn2#">
	DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfscript>
	//döngü içinde çalışmaması için döngü dışında yazıldı her güncelleme işleminde öncelikle tüm dağıtım silinmeli 
	butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
	dagilim=false;//dagilim yapılıp yapılmadığını tutacak değer ona göre is_cost set edilecek

	if( listfind('59,60,65,68,64',invoice_cat,',') ){
		butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2,reserv_type:1); // butce rez. siliyor
	}
	//invoice update edilirken zaten is_cost=0 yapıldığı için tekrar yapmamak için kapatıldı
	//upd_invoice_cost = cfquery(datasource : "#dsn2#",is_select: false, sqlstring : "UPDATE INVOICE SET IS_COST=0 WHERE INVOICE_ID=#form.invoice_id#");
	product_id_list=''; // satıs iade fat. karmakoli-üretim-spect stok hareketi cözumleri icin kullanılıyor
	stock_id_list='';
	if(isdefined("attributes.process_date") and len(attributes.process_date))
		attributes.invoice_date = attributes.process_date; // işlem tarihi üzerinden hareketler yaptırılıyor PY
</cfscript>

<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih="attributes.deliver_date#i#">
	<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1>
		<cfset specer_spec_id=''>
		<cfset dsn_type=dsn2>
		<cfif not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
			<cfinclude template="../../objects/query/add_basket_spec.cfm">
		<cfelseif attributes.basket_spect_type eq 7 ><!--- satırdada guncellenebilmeli bu spec tipinde--->
			<cfset specer_spec_id=evaluate('attributes.spect_id#i#')>
			<cfinclude template="../../objects/query/add_basket_spec.cfm">
		</cfif>
	</cfif>
	<cfinclude template="get_dis_amount.cfm">

	<cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
    	<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
    <cfelse>
    	<cfset reasonCode = ''>
    </cfif>
	
	<cfif IsDefined("attributes.order_id") and len( attributes.order_id ) and isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>
        <cfquery name = "get_order" datasource = "#dsn2#">
            SELECT ORDER_ID FROM #dsn3#.ORDER_ROW WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#">
        </cfquery>
        <cfif get_order.recordcount>
            <cfset attributes.order_id = get_order.ORDER_ID />
        </cfif>
    </cfif>
	
	<cfquery name="ADD_INVOICE_ROW" datasource="#dsn2#">
		INSERT INTO INVOICE_ROW
			(
			PURCHASE_SALES,
			PRODUCT_ID,
			NAME_PRODUCT,
			INVOICE_ID,
			STOCK_ID,
			AMOUNT,
			UNIT,
			UNIT_ID,
			PRICE,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			TAXTOTAL,
			TAX,
			DUE_DATE,
			DISCOUNT1,
			DISCOUNT2,
			DISCOUNT3,
			DISCOUNT4,
			DISCOUNT5,
			DISCOUNT6,
			DISCOUNT7,
			DISCOUNT8,
			DISCOUNT9,
			DISCOUNT10,			
			DELIVER_DATE,
			DELIVER_DEPT,
			DELIVER_LOC,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			SPECT_VAR_ID,
			SPECT_VAR_NAME,
		</cfif>
			LOT_NO,
			PRICE_OTHER,
			OTHER_MONEY_GROSS_TOTAL,
			COST_PRICE,
			EXTRA_COST,
			SHIP_ID,
			SHIP_PERIOD_ID,
			DISCOUNT_COST,
			IS_PROMOTION,
			ORDER_ID,
			UNIQUE_RELATION_ID,
			PROM_RELATION_ID,
			PRODUCT_NAME2,
			AMOUNT2,
			UNIT2,
			EXTRA_PRICE,
			EK_TUTAR_PRICE,<!--- iscilik_birim_ucreti --->
			EXTRA_PRICE_TOTAL,
			EXTRA_PRICE_OTHER_TOTAL,
			SHELF_NUMBER,
			PRODUCT_MANUFACT_CODE,
			BASKET_EXTRA_INFO_ID,
			SELECT_INFO_EXTRA,
			DETAIL_INFO_EXTRA,
			BASKET_EMPLOYEE_ID,
			LIST_PRICE,
			PRICE_CAT,
			CATALOG_ID,
			NUMBER_OF_INSTALLMENT,
			KARMA_PRODUCT_ID,
			OTV_ORAN,
			OTVTOTAL,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID,
			RELATED_ACTION_ID,
			RELATED_ACTION_TABLE,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID,
            ROW_WORK_ID,
            ROW_EXP_CENTER_ID,
            ROW_EXP_ITEM_ID,
            ROW_ACC_CODE,
			REASON_CODE,
			REASON_NAME,
			DELIVERY_CONDITION,
			CONTAINER_TYPE,
			CONTAINER_NUMBER,
			CONTAINER_QUANTITY,
			DELIVERY_COUNTRY,
			DELIVERY_CITY,
			DELIVERY_COUNTY,
			DELIVERY_TYPE,
			GTIP_NUMBER
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
			<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,OTV_TYPE</cfif>
			<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,OTV_DISCOUNT</cfif>
			<cfif isDefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,WEIGHT</cfif>
			<cfif isDefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,SPECIFIC_WEIGHT</cfif>
			<cfif isDefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,VOLUME</cfif>
			)
		VALUES
			(
			0,
			#evaluate('attributes.product_id#i#')#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),75)#">,
			#form.invoice_id#,
			#evaluate('attributes.stock_id#i#')#,
			#evaluate('attributes.amount#i#')#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
			#evaluate('attributes.unit_id#i#')#,
			#evaluate('attributes.price#i#')#,
			#DISCOUNT_AMOUNT#,
			<cfif isdefined("attributes.row_lasttotal#i#")>#evaluate("attributes.row_lasttotal#i#")#,<cfelse>0,</cfif>
			#evaluate('attributes.row_nettotal#i#')#,
			#evaluate('attributes.row_taxtotal#i#')#,
			#evaluate('attributes.tax#i#')#,
			<cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#Evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
			#indirim1#,
			#indirim2#,
			#indirim3#,
			#indirim4#,
			#indirim5#,
			#indirim6#,
			#indirim7#,
			#indirim8#,
			#indirim9#,
			#indirim10#,
			<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.department_id') and len(attributes.department_id)>
				#attributes.department_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.location_id') and len(attributes.location_id)>
				#attributes.location_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
			</cfif>
			<cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
				#listfirst(ship_id,';')#,
			<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session.ep.period_id#</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
				0,
			<cfif isDefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
			<cfif StructKeyExists(attributes,"row_exp_center_id#i#") and len(attributes["row_exp_center_id#i#"]) and StructKeyExists(attributes,"row_exp_center_name#i#") and len(attributes["row_exp_center_name#i#"])><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes['row_exp_center_id#i#']#"><cfelse>NULL</cfif>,
			<cfif StructKeyExists(attributes,"row_exp_item_id#i#") and len(attributes["row_exp_item_id#i#"]) and StructKeyExists(attributes,"row_exp_item_name#i#") and len(attributes["row_exp_item_name#i#"])><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes['row_exp_item_id#i#']#"><cfelse>NULL</cfif>,
			<cfif StructKeyExists(attributes,"row_acc_code#i#") and len(attributes["row_acc_code#i#"])><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes['row_acc_code#i#']#"><cfelse>NULL</cfif>,
				<cfif len(reasonCode) and reasonCode contains '*'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
			<cfelse>
				NULL,
				NULL
			</cfif>
        	,<cfif isdefined("attributes.delivery_condition#i#") and len(evaluate("attributes.delivery_condition#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_condition#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.container_type#i#") and len(evaluate("attributes.container_type#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_type#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.container_number#i#") and len(evaluate("attributes.container_number#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_number#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.container_quantity#i#") and len(evaluate("attributes.container_quantity#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_quantity#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.delivery_country#i#") and len(evaluate("attributes.delivery_country#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_country#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.delivery_city#i#") and len(evaluate("attributes.delivery_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_city#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.delivery_county#i#") and len(evaluate("attributes.delivery_county#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_county#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.delivery_type#i#") and len(evaluate("attributes.delivery_type#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_type#i#')#"><cfelse>NULL</cfif>
        	,<cfif isdefined("attributes.gtip_number#i#") and len(evaluate("attributes.gtip_number#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.gtip_number#i#')#"><cfelse>NULL</cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>    
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_type#i#')#"></cfif>
			<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_discount#i#')#"></cfif>
			<cfif isDefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_weight#i#')#"></cfif>
			<cfif isDefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_specific_weight#i#')#"></cfif>
			<cfif isDefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_volume#i#')#"></cfif>
			)
	</cfquery>
	<cfset product_id_list=listappend(product_id_list,evaluate("attributes.product_id#i#"))>
	<cfset stock_id_list=listappend(stock_id_list,evaluate("attributes.stock_id#i#"))>
    <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
		<cfscript>
            add_relation_rows(
                action_type:'add',
                action_dsn : '#dsn2#',
                to_table:'INVOICE',
                from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                amount : Evaluate("attributes.amount#i#"),
                to_action_id : form.invoice_id,
                from_action_id :Evaluate("attributes.related_action_id#i#")
                );
        </cfscript>
    </cfif>
	<cfscript>
	if(isdefined("session.ep") and is_project_based_budget and session.ep.our_company_info.project_followup eq 1)
	{
		if(isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#')))
			inv_project_id=evaluate('attributes.row_project_id#i#'); 
		else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
			inv_project_id=attributes.project_id; 
		else 
			inv_project_id='';
	}
	else 
		inv_project_id='';
	
	if(is_budget){ //butce
			if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
				budget_branch_id = attributes.branch_id;
			else
				budget_branch_id = ListGetAt(session.ep.user_location,2,"-");
			GET_MAX_INV_ROW = cfquery(datasource : "#dsn2#", sqlstring : "SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#");
			if (isdefined('attributes.other_money_#i#'))
				other_money=evaluate('attributes.other_money_#i#');
			else
				other_money='';
			if (isdefined('attributes.other_money_value_#i#') and len(evaluate('attributes.other_money_value_#i#')))
				other_money_value=evaluate('attributes.other_money_value_#i#');
			else
				other_money_value=0;
			if(isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no))
				attributes.subscription_id_ = attributes.subscription_id;
			else
				attributes.subscription_id_ = '';
			butce=butceci(
				action_id:form.invoice_id,
				muhasebe_db:dsn2,
				stock_id: evaluate("attributes.stock_id#i#"),
				product_id: evaluate("attributes.product_id#i#"),
				product_tax: evaluate("attributes.tax#i#"),
				product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
				product_bsmv: iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0),
				product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
				tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
				activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
				expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
				subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
				invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
				paper_no:form.INVOICE_NUMBER,
				detail:'#form.INVOICE_NUMBER# Nolu Fatura',
				is_income_expense: 'false',
				process_type:INVOICE_CAT,
				process_cat:attributes.PROCESS_CAT,
				nettotal:evaluate("attributes.row_nettotal#i#"),
				other_money_value:other_money_value,
				action_currency:other_money,
				expense_date:attributes.INVOICE_DATE,
				department_id:attributes.department_id,
				project_id=inv_project_id,
				branch_id : budget_branch_id,
				currency_multiplier : attributes.currency_multiplier
			);
			if(butce)dagilim=true; //bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
	}

	if(is_budget_reserved eq 1 and listfind('59,60,65,68,64',invoice_cat,',') and isDefined("attributes.order_id") and len(attributes.order_id)){ //butce rez.

			CreateCompenent = CreateObject("component","V16.budget.cfc.GetBudgetComplianceCheck");
			queryComponent = CreateCompenent.GetBudgetControl(
				new_datasource: dsn2, 
				order_id : attributes.order_id, 
				expense_center_id : iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id : iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0));
	
		if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
			budget_branch_id = attributes.branch_id;
		else
			budget_branch_id = ListGetAt(session.ep.user_location,2,"-");
		GET_MAX_INV_ROW = cfquery(datasource : "#dsn2#", sqlstring : "SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#");
		if (isdefined('attributes.other_money_#i#'))
			other_money=evaluate('attributes.other_money_#i#');
		else
			other_money='';
		if (isdefined('attributes.other_money_value_#i#') and len(evaluate('attributes.other_money_value_#i#')))
			other_money_value=evaluate('attributes.other_money_value_#i#');
		else
			other_money_value=0;
		if(isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no))
			attributes.subscription_id_ = attributes.subscription_id;
		else
			attributes.subscription_id_ = '';
		if(queryComponent.REZ_TOTAL_AMOUNT_ALACAK neq 0){
			butceci(
				action_id:form.invoice_id,
				muhasebe_db:dsn2,
				stock_id: evaluate("attributes.stock_id#i#"),
				product_id: evaluate("attributes.product_id#i#"),
				product_tax: evaluate("attributes.tax#i#"),
				product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
				product_bsmv: iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0),
				product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
				tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
				activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
				expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
				subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
				invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
				paper_no:form.INVOICE_NUMBER,
				detail:'#form.INVOICE_NUMBER# Nolu Fatura',
				is_income_expense: false,
				process_type:INVOICE_CAT,
				process_cat:attributes.PROCESS_CAT,
				nettotal:evaluate("attributes.row_nettotal#i#"),
				other_money_value:other_money_value,
				action_currency:other_money,
				expense_date:attributes.INVOICE_DATE,
				department_id:attributes.department_id,
				project_id :inv_project_id,
				branch_id : budget_branch_id,
				reserv_type : 1,
				currency_multiplier : attributes.currency_multiplier
			);
		}
}
	</cfscript>
</cfloop>
<cfscript>
//döngü dışına alındı her satırda is_cost update etmemesi için
	if(dagilim) upd_invoice_cost = cfquery(datasource : "#dsn2#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#form.invoice_id#");
</cfscript>
<cfif (included_irs eq 1 and isdefined("form.fatura_iptal") and form.fatura_iptal eq 1) or not (isdefined("form.fatura_iptal") and form.fatura_iptal eq 1)>
	<!--- kendi irsaliyesini olusturmus fatura iptal edilirse fatura-irsaliye ilişkisi silinmez --->
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
		DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
	<cfif (included_irs eq 1) and len(attributes.ship_ids)>
    <cfset attributes.ship_ids = listsort(attributes.ship_ids,'numeric','asc')>   
	<!--- faturaya aktif donemden çekilen irsaliye kayıtları yazılıyor --->	
		<cfloop list="#attributes.ship_ids#" index="per_k">
			<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
				INSERT INTO
					INVOICE_SHIPS
				(
					INVOICE_ID,
					INVOICE_NUMBER,
					SHIP_ID,
					SHIP_NUMBER,
					IS_WITH_SHIP,
					SHIP_PERIOD_ID
				)
				VALUES
				(
					#form.invoice_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.INVOICE_NUMBER#">,
					#per_k#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_irs.SHIP_NUMBER[listfind(attributes.ship_ids,per_k,',')]#">,
					0 ,<!--- irsaliyeli fatura --->
					#session.ep.period_id#
				)
			</cfquery>
		</cfloop>
	</cfif>
	<cfif (included_irs eq 1) and isdefined('pre_period_ships') and len(pre_period_ships)>
		<!--- faturaya önceki donemden irsaliye kayıtları yazılıyor --->
		<cfloop list="#pre_period_ships#" index="index_t">
			<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
				INSERT INTO
					INVOICE_SHIPS
				(
					INVOICE_ID,
					INVOICE_NUMBER,
					SHIP_ID,
					SHIP_NUMBER,
					IS_WITH_SHIP,
					SHIP_PERIOD_ID
				)
				VALUES
				(
					#form.invoice_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.INVOICE_NUMBER#">,
					#index_t#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_irs2.SHIP_NUMBER[listfind(pre_period_ships,index_t,',')]#">,
					0, <!--- irsaliyeli fatura --->
					#pre_period_id#
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<cfif included_irs eq 1><!--- faturaya cekilen irsaliyeler icin (dikkat faturanın kendi irsaliyesi icin degil) SHIP_ROW_RELATION tablosuna kayıt atılıyor--->
	<cfscript>
		add_ship_row_relation(
			to_related_process_id : form.invoice_id,
			to_related_process_type : INVOICE_CAT,
			old_related_process_type : form.old_process_type,
			is_related_action_iptal : iif((isdefined("form.fatura_iptal") and (form.fatura_iptal eq 1)),1,0),
			is_invoice_ship : 0,
			ship_related_action_type:1,
			process_db :dsn2
			);
	</cfscript>
<cfelse>
	<cfquery name="DEL_SHIP_ROW_RELATION" datasource="#dsn2#">
		DELETE 
			FROM SHIP_ROW_RELATION
		WHERE
			TO_INVOICE_ID=#form.invoice_id# AND TO_INVOICE_CAT=#form.old_process_type#
	</cfquery>
</cfif>
<!--- tevkifatlı fatura ise --->
<cfquery name="DEL_INVOICE_TAXES" datasource="#dsn2#">
	DELETE FROM INVOICE_TAXES WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
	<cfloop from="1" to="#form.basket_tax_count#" index="tax_i">
		<cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
			INSERT INTO
				INVOICE_TAXES
			(
				INVOICE_ID,
				TAX,
				TEVKIFAT_TUTAR,
				BEYAN_TUTAR					
			)
			VALUES
			(
				#form.invoice_id#,
				#evaluate("attributes.basket_tax_#tax_i#")#,
				#evaluate("attributes.tevkifat_tutar_#tax_i#")#,
				#evaluate("attributes.basket_tax_value_#tax_i#")*100#   
			)
		</cfquery>
	</cfloop>
</cfif>
