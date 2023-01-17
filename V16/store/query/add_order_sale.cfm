<cf_date tarih ='attributes.deliver_date_frm'>
<cf_date tarih ='attributes.ship_date'>

<cfinclude template="get_process_cat.cfm">
<cfif attributes.rows_ eq 0 >
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmediniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cfset paymethod_id = "" >
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfscript>
		if(isdefined("attributes.paymethod_id#i#"))paymethod_id=listappend(paymethod_id,evaluate("attributes.paymethod_id#i#"));
	</cfscript>
</cfloop>

<cfquery name="GET_PURCHASE" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM
		SHIP
	WHERE
		PURCHASE_SALES = 1 AND
		SHIP_NUMBER='#SHIP_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no ='152.Girdiginiz İrsaliye Numarası Kullanılıyor ! Lütfen Tekrar Giriniz '>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>		
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_SALE" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				SHIP
				(
					PAYMETHOD_ID,
					PURCHASE_SALES,
					SHIP_NUMBER,
					SHIP_TYPE,
					PROCESS_CAT,
				<cfif isDefined('attributes.SHIP_METHOD')>
					<cfif len(attributes.SHIP_METHOD)>
					SHIP_METHOD,
					</cfif>
				</cfif>
					SHIP_DATE,
					<cfif len(attributes.company_id) and attributes.company_id neq 0>
						COMPANY_ID,
						PARTNER_ID,
					<cfelse>
						CONSUMER_ID,
					</cfif>
				<cfif isdate(attributes.deliver_date_frm)>
					DELIVER_DATE,
				</cfif>
					DELIVER_EMP,
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					<!--- MONEY,
					RATE1,
					RATE2, --->
					DELIVER_STORE_ID,
					LOCATION,
					RECORD_DATE,
					ADDRESS,
					RECORD_EMP,
					ORDER_ID,
					IS_WITH_SHIP
					)
			VALUES
					(
					#attributes.paymethod_id#,
					1,
					'#SHIP_NUMBER#',
					#get_process_type.PROCESS_TYPE#,
					#form.process_cat#,
				<cfif isDefined('attributes.SHIP_METHOD')>
					<cfif len(attributes.SHIP_METHOD)>
					#SHIP_METHOD#,
					</cfif>
				</cfif>
					#attributes.ship_date#,
				<cfif len(attributes.company_id) and attributes.company_id neq 0>
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				<cfelse>
					#attributes.consumer_id#,
				</cfif>
				<cfif isdate(attributes.deliver_date_frm)>
					#attributes.deliver_date_frm#,
				</cfif>
					'#LEFT(TRIM(DELIVER_GET),50)#',
					<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
					<!--- '#session.ep.money#',
					#attributes.basket_rate1#,
					#attributes.basket_rate2#, --->
					#attributes.department_id#,
					#attributes.location_id#,
					 #now()#,
					'#ADRES#',
					#session.ep.userid#,
					#attributes.order_id#,
					0
					)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfinclude template="get_unit_add_fis.cfm">
			<cfif get_unit.recordcount  and len(get_unit.multiplier) >
				<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
			<cfelse>
				<cfset multi=evaluate("attributes.amount#i#")>
			</cfif>
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
				INSERT INTO
					SHIP_ROW
					(
					NAME_PRODUCT,
					SHIP_ID,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,				
					TAX,
				<cfif len(evaluate("attributes.price#i#"))>
					PRICE,
				</cfif>
					DISCOUNT,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,
					DISCOUNTTOTAL,
					GROSSTOTAL,
					NETTOTAL,
					TAXTOTAL,
					PURCHASE_SALES,
					DELIVER_DEPT,
					DELIVER_LOC,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
				</cfif>
					LOT_NO,
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					IS_PROMOTION,
					DISCOUNT_COST,
					UNIQUE_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EXTRA_PRICE_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					OTV_ORAN,
					OTVTOTAL,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
					)
				VALUES
					(
					'#left(evaluate("attributes.product_name#i#"),250)#',
					#MAX_ID.IDENTITYCOL#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					'#wrk_eval("attributes.unit#i#")#',
					#evaluate("attributes.unit_id#i#")#,				
					#evaluate("attributes.tax#i#")#,
				<cfif len(evaluate("attributes.price#i#"))>
					#evaluate("attributes.price#i#")#,
				</cfif>
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
					#DISCOUNT_AMOUNT#,
					#evaluate("attributes.row_lasttotal#i#")#,
					#evaluate("attributes.row_nettotal#i#")#,
					#evaluate("attributes.row_taxtotal#i#")#,
	
					1,
					#attributes.department_id#,
					#attributes.location_id#,				
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
					'#wrk_eval('attributes.spect_name#i#')#',
				</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
					0,
				<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>'#wrk_eval('attributes.shelf_number#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
				<cfinclude template="get_unit_add_fis.cfm">
				<cfif get_unit.recordcount  and len(get_unit.multiplier) >
					<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
				<cfelse>
					<cfset multi=evaluate("attributes.amount#i#")>
				</cfif>
				<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
					INSERT INTO 
						STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_OUT,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
							SPECT_VAR_ID,
						</cfif>
							LOT_NO,
							SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.stock_id#i#")#,
							#get_process_type.PROCESS_TYPE#,
							#multi#,
							#attributes.department_id#,
							#attributes.location_id#,											
							#attributes.ship_date#,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
							#evaluate('attributes.spect_id#i#')#,
						</cfif>
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>'#wrk_eval('attributes.shelf_number#i#')#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
		</cfloop>
		<cfinclude template="get_order_rate.cfm">
		<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);</cfscript>

	</cftransaction>
</cflock>

<!--- seri no varsa --->
<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
		<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>  
			<cfscript>
				add_serial_no(
				session_row : i,
				is_insert : true,
				action_id : MAX_ID.IDENTITYCOL,
				action_type : 2,
				action_number : '#SHIP_NUMBER#',
				dpt_id : attributes.department_id,
				loc_id : attributes.location_id,
				is_sale : false,
				par_id :attributes.partner_id,
				con_id : attributes.consumer_id );
			</cfscript>
		</cfif>
	</cfif>
</cfloop>

<cfif len(attributes.paper_number)>	
	<cfquery name="UPD_PAPERS" datasource="#DSN3#">
		UPDATE 
			PAPERS_NO 
		SET 
			SHIP_NUMBER = #attributes.paper_number# 
		WHERE 
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #SESSION.EP.USERID#
		</cfif>
	</cfquery>
</cfif>

<cflocation url="#request.self#?fuseaction=store.form_add_sale&event=upd&ship_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
