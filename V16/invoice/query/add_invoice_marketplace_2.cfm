<cfquery name="ADD_INVOICE_SALE" datasource="#dsn2#" result="MAX_ID">
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
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		NETTOTAL,
		GROSSTOTAL,
		GROSSTOTAL_WITHOUT_ROUND,
		TAXTOTAL,
		OTV_TOTAL,
		SA_DISCOUNT,
		NOTE,
		DELIVER_EMP,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		SHIP_METHOD,
		PAY_METHOD,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		PROCESS_CAT,
		IS_WITH_SHIP,
		ROUND_MONEY,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(	
		'#wrk_id#',
		<cfif isDefined("FORM.CASH")>1,#KASA#,<cfelse>0,NULL,</cfif>
		<cfif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
			#EMPO_ID#,
		<cfelseif isDefined("attributes.PARTNER_NAMEO") and len(attributes.PARTNER_NAMEO) and len(attributes.EMPO_ID)>
			#PARTO_ID#,
		</cfif>
		0,
		'#FORM.INVOICE_NUMBER#',
		#INVOICE_CAT#,
		#attributes.invoice_date#,
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			#attributes.company_id#,
			<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			NULL,
		<cfelse>
			NULL,
			NULL,
			#attributes.consumer_id#,
		</cfif>
		#form.basket_net_total#,
		#form.basket_gross_total#,
		<cfif len(attributes.yuvarlama)>#evaluate(form.basket_net_total-attributes.yuvarlama)#,<cfelse>#form.basket_net_total#,</cfif>		
		#form.basket_tax_total#,
		<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		#form.genel_indirim#,
		'#NOTE#',
		'#LEFT(TRIM(DELIVER_GET_ID),50)#',
		#attributes.department_id#,
		#attributes.location_id#,
		<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
		1,
		'#form.basket_money#',
		#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
		#FORM.PROCESS_CAT#,
	<cfif (not included_irs) and (inventory_product_exists eq 1)>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif len(attributes.yuvarlama)>#attributes.yuvarlama#<cfelse>NULL</cfif>,
		#now()#,
		#SESSION.EP.USERID#
	)
</cfquery>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih = "attributes.deliver_date#i#">
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
				#evaluate("attributes.product_id#i#")#,
				'#left(wrk_eval("attributes.product_name#i#"),250)#',
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				'#wrk_eval("attributes.unit#i#")#',
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
			<cfelseif not ( isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) )>
				#attributes.department_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.other_money_#i#") and len(evaluate("attributes.other_money_#i#"))>'#wrk_eval("attributes.other_money_#i#")#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				#evaluate("attributes.spect_id#i#")#,
				'#wrk_eval("attributes.spect_name#i#")#',
			<cfelse>
				NULL,
				NULL,
			</cfif>
			<cfif isdefined("attributes.lot_no#i#")>'#wrk_eval("attributes.lot_no#i#")#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.other_money_gross_total#i#') and len(evaluate('attributes.other_money_gross_total#i#'))>#evaluate('attributes.other_money_gross_total#i#')#<cfelse>NULL</cfif>,
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
                to_action_id : MAX_ID.IDENTITYCOL,
                from_action_id :Evaluate("attributes.related_action_id#i#")
                );
        </cfscript>
	</cfif>
</cfloop>
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
				#MAX_ID.IDENTITYCOL#,
				'#form.invoice_number#',
				#k#,
				'#get_irs.SHIP_NUMBER[listfind(attributes.ship_ids,k,",")]#',
				0, <!--- irsaliyeli fatura --->
				#session.ep.period_id#
				)
		</cfquery>
	</cfloop>
</cfif>
<cfif included_irs eq 1><!--- faturaya cekilen irsaliyeler icin (dikkat faturanın kendi irsaliyesi icin degil) SHIP_ROW_RELATION tablosuna kayıt atılıyor--->
	<cfscript>
		add_ship_row_relation(
			to_related_process_id : MAX_ID.IDENTITYCOL,
			to_related_process_type :INVOICE_CAT,
			is_invoice_ship : 0,
			ship_related_action_type:0,
			process_db :dsn2
			);
	</cfscript>
</cfif>

