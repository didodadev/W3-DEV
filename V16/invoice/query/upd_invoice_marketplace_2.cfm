<cfquery name="UPD_INVOICE" datasource="#dsn2#">
	UPDATE 
		INVOICE 
	SET 
		IS_CASH=<cfif isDefined("FORM.CASH")>1<cfelse>0</cfif>,
		IS_IPTAL=0,
		INVOICE_NUMBER = '#FORM.INVOICE_NUMBER#',
		INVOICE_DATE = #attributes.INVOICE_DATE#,	
		INVOICE_CAT = #INVOICE_CAT#,
		PROCESS_CAT = #FORM.PROCESS_CAT#,
		NETTOTAL=#attributes.BASKET_NET_TOTAL#,
		GROSSTOTAL=#attributes.BASKET_GROSS_TOTAL#,
		GROSSTOTAL_WITHOUT_ROUND=<cfif len(attributes.yuvarlama)>#Evaluate(form.basket_net_total-attributes.yuvarlama)#,<cfelse>#form.basket_net_total#,</cfif>
		TAXTOTAL=#attributes.BASKET_TAX_TOTAL#,
		OTV_TOTAL =	<cfif len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
		SA_DISCOUNT=#form.genel_indirim#,
		OTHER_MONEY='#form.BASKET_MONEY#',
		OTHER_MONEY_VALUE=#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
		DELIVER_EMP = '#LEFT(TRIM(DELIVER_GET_ID),50)#',
		DEPARTMENT_ID = #attributes.department_id#,
		DEPARTMENT_LOCATION = #attributes.location_id#,
		PAY_METHOD = <cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
		SHIP_METHOD = <cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		ROUND_MONEY =<cfif len(attributes.yuvarlama)>#attributes.yuvarlama#<cfelse>NULL</cfif>,
	<cfif isdefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
		SALE_EMP=#EMPO_ID#,
		SALE_PARTNER=NULL,
	<cfelseif isdefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.PARTO_ID)>
		SALE_EMP=NULL,
		SALE_PARTNER=#PARTO_ID#,
	<cfelse>
		SALE_EMP=NULL,
		SALE_PARTNER=NULL,
	</cfif>	
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID=#attributes.company_id#,
		PARTNER_ID=<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
		CONSUMER_ID=NULL,
	<cfelse>
		COMPANY_ID=NULL,
		PARTNER_ID=NULL,
		CONSUMER_ID=#attributes.consumer_id#,
	</cfif>
		NOTE=<cfif isDefined("NOTE") and len(NOTE)>'#NOTE#'<CFELSE>NULL</cfif>,
		UPDATE_DATE = #NOW()#,	
		UPDATE_EMP=#SESSION.EP.USERID#
	WHERE 
		INVOICE_ID = #form.invoice_id#
</cfquery>
<!--- kapatıldı,hal faturasndan bütçe dağılm vs yapılmıyor.. Ayşenur20080331
<cfquery name="DEL_EXPENSE_ROW" datasource="#dsn2#">
	DELETE FROM EXPENSE_ITEMS_ROWS WHERE INVOICE_ID = #form.invoice_id#
</cfquery> --->
<cfquery name="DEL_ROW" datasource="#dsn2#">
	DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih="attributes.deliver_date#i#">
	<cfinclude template="get_dis_amount.cfm">
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
			DARA,
			DARALI,
			SHIP_ID,
			SHIP_PERIOD_ID,
			DISCOUNT_COST,
			IS_PROMOTION,
			UNIQUE_RELATION_ID,
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
			NUMBER_OF_INSTALLMENT,
			PRICE_CAT,
			CATALOG_ID,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID,
			RELATED_ACTION_ID,
			RELATED_ACTION_TABLE,
			OTV_ORAN,
			OTVTOTAL,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID
			)
		VALUES
			(
			0,
			#evaluate('attributes.product_id#i#')#,
			'#left(wrk_eval('attributes.product_name#i#'),75)#',				
			#form.invoice_id#,
			#evaluate('attributes.stock_id#i#')#,
			#evaluate('attributes.amount#i#')#,
			'#wrk_eval('attributes.unit#i#')#',
			#evaluate('attributes.unit_id#i#')#,
			#evaluate('attributes.price#i#')#,
			#DISCOUNT_AMOUNT#,
			#evaluate('attributes.row_lasttotal#i#')#,
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
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
			#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
			#evaluate('attributes.spect_id#i#')#,
			'#wrk_eval('attributes.spect_name#i#')#',
		</cfif>
		<cfif isdefined('attributes.lot_no#i#')>'#wrk_eval('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
		<cfif len(evaluate("attributes.dara#i#"))>#evaluate("attributes.dara#i#")#,<cfelse>0,</cfif>
		<cfif len(evaluate("attributes.darali#i#"))>#evaluate("attributes.darali#i#")#,<cfelse>0,</cfif>		
			#listfirst(ship_id,';')#,
		<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session.ep.period_id#</cfif>,
		<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
			0,
		<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))>'#wrk_eval('attributes.related_action_table#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfloop>
<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
	DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfif (included_irs eq 1) and len(attributes.ship_ids)>
	<cfloop list="#attributes.ship_ids#" index="k">
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
				'#form.INVOICE_NUMBER#',
				#k#,
				'#get_irs.SHIP_NUMBER[listfind(attributes.ship_ids,k,",")]#',
				0,
				#session.ep.period_id#
				)
		</cfquery>
	</cfloop>
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
</cfif>

