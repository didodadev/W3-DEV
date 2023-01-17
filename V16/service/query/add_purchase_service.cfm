<cfinclude template="check_our_period.cfm">
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>

<cfquery name="GET_PURCHASE" datasource="#DSN2#">
	SELECT
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM 
		SHIP
	WHERE 
		PURCHASE_SALES = 0 AND 
		SHIP_NUMBER='#SHIP_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='123.Girdiğiniz İrsaliye Numarası Kullanılıyor ! Lütfen Tekrar Giriniz !'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="ADD_PURCHASE" datasource="#DSN2#" result="MAX_ID">
		INSERT INTO
			SHIP
			(
				WRK_ID,
				PURCHASE_SALES,
				SHIP_NUMBER,
				SHIP_TYPE,
				PROCESS_CAT,
				<cfif isDefined("attributes.SHIP_METHOD") and len(attributes.SHIP_METHOD)>SHIP_METHOD,</cfif>
				SHIP_DATE,
				<cfif len(attributes.company_id)>
					COMPANY_ID,
					PARTNER_ID,
				<cfelse>
					CONSUMER_ID,
				</cfif>
				DELIVER_DATE,
				DELIVER_EMP,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				DEPARTMENT_IN,
				LOCATION_IN,
				RECORD_DATE,
				IS_WITH_SHIP,
				RECORD_EMP
			)
		VALUES
			(
				'#wrk_id#',
				0,
				'#SHIP_NUMBER#',
				#get_process_type.PROCESS_TYPE#,
				#form.process_cat#,
				<cfif isDefined("attributes.SHIP_METHOD") and len(attributes.SHIP_METHOD)>
					#attributes.SHIP_METHOD#,
				</cfif>
				#attributes.ship_date#,
				<cfif len(attributes.company_id) >
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				<cfelse>
					#attributes.consumer_id#,
				</cfif>
				<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,<cfelse>NULL,</cfif>
				'#LEFT(TRIM(DELIVER_GET_ID),50)#',
				<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
				'#form.basket_money#',
				#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
				#attributes.department_id#,
				#attributes.location_id#,
				#now()#,
				0,
				#session.ep.userid#
			)
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfinclude template="get_dis_amount.cfm">
		<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
			INSERT INTO
				SHIP_ROW
				(
				NAME_PRODUCT,
				PAYMETHOD_ID, 
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
				PURCHASE_SALES,
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
				DELIVER_DEPT,
				DELIVER_LOC,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
			</cfif>
				LOT_NO,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,				
				PRICE_OTHER,
				OTHER_MONEY_GROSS_TOTAL,
				EXTRA_COST,
				ROW_ORDER_ID,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
                DETAIL_INFO_EXTRA,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				IS_PROMOTION,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID
				)
			VALUES
				(
				'#left(evaluate("attributes.product_name#i#"),250)#',
				<cfif  isdefined("attributes.paymethod_id#i#") and  len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.product_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				'#wrk_eval("attributes.unit#i#")#',
				<cfif isdefined("attributes.unit_id#i#") and len(evaluate("attributes.unit_id#i#"))  >#evaluate("attributes.unit_id#i#")#,<cfelse>NULL,</cfif>
				#evaluate("attributes.tax#i#")#,
				<cfif len(evaluate("attributes.price#i#"))>
				#evaluate("attributes.price#i#")#,
				</cfif>
				0,
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
				#attributes.department_id#,
				#attributes.location_id#,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				'#wrk_eval('attributes.spect_name#i#')#',
			</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
				<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
				0,
				<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
				0,
				<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
				)
		</cfquery>
	<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
		<cfinclude template="get_unit_add_fis.cfm">
		<cfif get_unit.recordcount  and len(get_unit.multiplier) >
			<cfset multi = get_unit.multiplier*evaluate("attributes.amount#i#")>
		<cfelse>
			<cfset multi = evaluate("attributes.amount#i#")>
		</cfif>
		<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
			INSERT INTO 
				STOCKS_ROW
				(
					UPD_ID,
					PRODUCT_ID,
					STOCK_ID,
					PROCESS_TYPE,
					STOCK_IN,
					STORE,
					STORE_LOCATION,
					PROCESS_DATE,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>SPECT_VAR_ID,</cfif>
					LOT_NO
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
					#attributes.deliver_date_frm#,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#,</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cfif>
	</cfloop>
	<cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
		<cfloop list="#attributes.order_id_listesi#" index="k">
			<cfquery name="add_orders_ship" datasource="#dsn2#">
				INSERT INTO
					#dsn3_alias#.ORDERS_SHIP
					(
						ORDER_ID,
						SHIP_ID,
						PERIOD_ID
					)
				VALUES
					(
						#k#,
						#MAX_ID.IDENTITYCOL#,
						#session.ep.period_id#
					)
			</cfquery>
			 <cfset attributes.order_id=k>
			 <cfinclude template="../query/get_order_rate_purchase.cfm">
			 <cfquery name="UPD_ORD" datasource="#dsn2#">
				UPDATE 
					#dsn3_alias#.ORDERS 
				SET 
					IS_PROCESSED = 1,
					ORDER_CURRENCY = #ORDER_CUR#,
					RESERVED = 0
				WHERE 
					ORDER_ID =#attributes.order_id#
			</cfquery>
		</cfloop>
	</cfif>  
	<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);</cfscript>				
	</cftransaction>
</cflock>


<!--- seri islemleri --->
<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
		<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>  
			<cfscript>
				add_serial_no(
					session_row : i,
					process_id :MAX_ID.IDENTITYCOL,
					process_type : get_process_type.PROCESS_TYPE,
					process_number :'#LEFT(SHIP_NUMBER,50)#',
					dpt_id : attributes.department_id,
					loc_id : attributes.location_id,
					par_id : attributes.partner_id,
					con_id : attributes.consumer_id,
					comp_id : attributes.company_id
				);
			</cfscript>
		</cfif>
	</cfif>
</cfloop>
<!--- seri islemleri --->
<cfif session.ep.our_company_info.workcube_sector is "per">
	<cflocation url="#request.self#?fuseaction=stock.form_add_purchase" addtoken="No">
<cfelse>
	<cflocation url="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#MAX_ID.IDENTITYCOL#" addtoken="No">
</cfif>
