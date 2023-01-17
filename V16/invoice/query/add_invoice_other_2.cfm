<!--- invoice + row --->
<cfquery name="ADD_INVOICE_SALE" datasource="#dsn2#">
	INSERT INTO INVOICE
		(
		WRK_ID,
		IS_CASH,
		KASA_ID,
	<cfif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
		SALE_EMP,
	<cfelseif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.PARTO_ID)>
		SALE_PARTNER,
	</cfif>
		PURCHASE_SALES,
		INVOICE_NUMBER,
		INVOICE_CAT,
		INVOICE_DATE,
        PROCESS_DATE,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		NETTOTAL,
		GROSSTOTAL,
		TAXTOTAL,
		OTV_TOTAL,
		SA_DISCOUNT,
		NOTE,
		DELIVER_EMP,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		ACC_DEPARTMENT_ID,
		SHIP_METHOD,
		PAY_METHOD,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		STOPAJ,
		STOPAJ_ORAN,
		STOPAJ_RATE_ID,
		PROCESS_CAT,
		IS_WITH_SHIP,
		DUE_DATE,
		REF_NO,
		IS_RETURN, <!--- diger alıs fat. iade olup olmadıgını gosteriyor --->
		PROJECT_ID,
		TEVKIFAT,
		TEVKIFAT_ORAN,
		TEVKIFAT_ID,
		CARD_PAYMETHOD_ID,
		CARD_PAYMETHOD_RATE,
		ASSETP_ID,
		RECORD_DATE,
		RECORD_EMP,
		SUBSCRIPTION_ID,
		TAX_CODE
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,PROCESS_STAGE</cfif>
	)
	VALUES
	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
		<cfif isDefined("FORM.CASH")>1,#KASA#,<cfelse>0,NULL,</cfif>
		<cfif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
			#EMPO_ID#,
		<cfelseif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.PARTO_ID)>
			#PARTO_ID#,
		</cfif>
		0,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
		#INVOICE_CAT#,
		#attributes.invoice_date#,
        <cfif isdefined("attributes.process_date") and len(attributes.process_date)><cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#attributes.process_date#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			#attributes.company_id#,
			<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			NULL,
		<cfelseif isDefined("attributes.consumer_id")>
			NULL,
			NULL,
			#attributes.consumer_id#,
		</cfif>
		#form.basket_net_total#,
		#form.basket_gross_total#,
		#form.basket_tax_total#,
		<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		#form.genel_indirim#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#NOTE#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET_ID),50)#">,
		#attributes.department_id#,
		#attributes.location_id#,
		<cfif isdefined('attributes.acc_department_id') and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
		#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
		#form.stopaj#,
		#form.stopaj_yuzde#,
		<cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>NULL</cfif>,
		#form.PROCESS_CAT#,
		<cfif (INVOICE_CAT eq 64) or (INVOICE_CAT eq 690)><!--- sadece bu işlem tipinde kendi irsaliyesi var --->
			1,
		<cfelse>
			0,
		</cfif>
		<cfif isdefined("invoice_due_date") and len(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_return") and len(attributes.is_return)>#attributes.is_return#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#,<cfelse>NULL,</cfif>	
		<cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
			#attributes.card_paymethod_id#,
			<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
				#attributes.commission_rate#,
			<cfelse>
				NULL,
			</cfif>
		<cfelse>
			NULL,
			NULL,
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,	
		#now()#,
		#SESSION.EP.USERID#,
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#attributes.tax_code#'<cfelse>NULL</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"></cfif>	
	)
</cfquery>

<cfquery name="GET_INVOICE_ID" datasource="#dsn2#">
	SELECT MAX(INVOICE_ID) AS MAX_ID FROM INVOICE WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
</cfquery>
<cfscript>
	dagilim=false;
	//proje bazli dagilim yapilacaksa her satirda almasina gerek yok bir kere alip butceci ye proje_id verilmesi yeterli
	if(is_project_based_budget and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
		inv_project_id=attributes.project_id; 
	else 
		inv_project_id='';
	if(isdefined("attributes.process_date") and len(attributes.process_date))
		attributes.invoice_date = attributes.process_date;// işlem tarihi üzerinden hareketler yaptırılıyor
</cfscript>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih = "attributes.deliver_date#i#">
	<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
		<cfset dsn_type=dsn2>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cfinclude template="get_dis_amount.cfm">
	<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
		INSERT INTO
			INVOICE_ROW
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
				GROSSTOTAL,
				NETTOTAL,
				TAXTOTAL,
				DISCOUNTTOTAL,
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
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
				LOT_NO,
				PRICE_OTHER,
				OTHER_MONEY_GROSS_TOTAL,
				SHIP_ID,
				SHIP_PERIOD_ID,
				EXTRA_COST,
				DISCOUNT_COST,
				IS_PROMOTION,
				UNIQUE_RELATION_ID,
				PROM_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EXTRA_PRICE_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
				DETAIL_INFO_EXTRA,
				LIST_PRICE,
				PRICE_CAT,
				CATALOG_ID,
				NUMBER_OF_INSTALLMENT,
				OTV_ORAN,
				OTVTOTAL,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,ROW_EXP_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,ROW_EXP_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ROW_ACC_CODE</cfif>
				<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
				<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
			)
		VALUES
			(
				0,
				#evaluate("attributes.product_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('attributes.product_name#i#'),250)#">,
				#get_invoice_id.max_id#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
				#evaluate("attributes.price#i#")#,
				#evaluate("attributes.row_lasttotal#i#")#,
				#evaluate("attributes.row_nettotal#i#")#,
				#evaluate("attributes.row_taxtotal#i#")#,
				#DISCOUNT_AMOUNT#,
				#evaluate("attributes.tax#i#")#,
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
			<cfif isdefined("attributes.other_money_#i#") and len(evaluate("attributes.other_money_#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				#evaluate("attributes.spect_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
			<cfelse>
				NULL,
				NULL,
			</cfif>
			<cfif isdefined("attributes.lot_no#i#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
				#listfirst(ship_id,';')#,
			<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session.ep.period_id#</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
				0,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
			<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>	
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			)
	</cfquery>
	<cfscript>
	if(is_budget){ //butce
		if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
			budget_branch_id = attributes.branch_id;
		else
			budget_branch_id = ListGetAt(session.ep.user_location,2,"-");
			
		GET_MAX_INV_ROW = cfquery(datasource : "#dsn2#", sqlstring : "SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID=#get_invoice_id.max_id#");
		if (isdefined('attributes.other_money_#i#'))
			other_money=evaluate('attributes.other_money_#i#');
		else
			other_money='';
		if (isdefined('attributes.other_money_value_#i#') and len(evaluate('attributes.other_money_value_#i#')))
			other_money_value=evaluate('attributes.other_money_value_#i#');
		else
			other_money_value=0;

		if(isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#')))
			attributes.row_activity_id = evaluate('attributes.row_activity_id#i#');
		else
			attributes.row_activity_id = '';

		butce=butceci(
			action_id:get_invoice_id.max_id,
			muhasebe_db:dsn2,
			stock_id: evaluate("attributes.stock_id#i#"),
			product_id: evaluate("attributes.product_id#i#"),
			product_tax: evaluate("attributes.tax#i#"),
			product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
			product_bsmv: iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0),
			product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
			tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
			activity_type: attributes.row_activity_id,
			expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
			expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),		
			invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
			paper_no:form.INVOICE_NUMBER,
			is_income_expense: 'false',
			process_type:INVOICE_CAT,
			nettotal:evaluate("attributes.row_nettotal#i#"),
			other_money_value:other_money_value,
			action_currency:other_money,
			expense_date:attributes.INVOICE_DATE,
			department_id:attributes.department_id,
			project_id:inv_project_id,
			branch_id : budget_branch_id,
			currency_multiplier : attributes.currency_multiplier,
			subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id)),'attributes.subscription_id',de(''))
		);
		if(butce)dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
	}
	</cfscript>
</cfloop>
<cfscript>
	if(dagilim) upd_invoice_cost = cfquery(datasource : "#dsn2#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#get_invoice_id.max_id#");
</cfscript>
<!--- tevkifatlı fatura ise --->
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
				#get_invoice_id.max_id#,
				#evaluate("attributes.basket_tax_#tax_i#")#,
				#evaluate("attributes.tevkifat_tutar_#tax_i#")#,
				#evaluate("attributes.basket_tax_value_#tax_i#")*100#   
				)
		</cfquery>
	</cfloop>
</cfif>
<cfif isDefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
	<cfloop list="#attributes.order_id_listesi#" index="order_id">
		<cfquery name="add_orders_invoice" datasource="#dsn2#">
			INSERT INTO
				#dsn3_alias#.ORDERS_INVOICE
				(
					ORDER_ID,
					INVOICE_ID,
					PERIOD_ID
				)
				VALUES
				(
					#order_id#,
					#get_invoice_id.max_id#,
					#session_base.period_id#
				)
		</cfquery>
	</cfloop>
</cfif>
<!--- // invoice + row --->
