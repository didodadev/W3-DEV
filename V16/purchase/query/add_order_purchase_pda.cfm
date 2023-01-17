<cf_get_lang_set module_name="sales">
<!--- 
	TEKLİF,SİPARİŞ,İRSALİYE VE FATURA BELGELERİNİN ARALARINDAKİ DÖNÜŞÜMLERDE KULLANILMAK ÜZERE YAZILDI,KOD KİRLİĞİĞİ ÖNLEMEK AÇISINDAN FONKSİYON İLE YAPILDI...
	HANGİ BELGENİN "SATIRI" HANGİ BELGENİN SATIRI İLE İLİŞKİLİ OLDUĞUNU TUTAR...
	M.ER 23 02 2009
 --->
<cffunction name="add_relation_rows" returntype="numeric" output="false">
	<cfargument name="action_type" type="string" required="yes" default="add"><!--- add or del --->
	<cfargument name="to_table" type="string" required="no">
    <cfargument name="from_table" type="string" required="no">
    <cfargument name="to_wrk_row_id" type="string" required="no">
    <cfargument name="from_wrk_row_id" type="string" required="no">
    <cfargument name="amount" type="numeric" required="no">
    <cfargument name="to_action_id" type="numeric" required="no">
    <cfargument name="from_action_id" type="numeric" required="no">
    <cfargument name="action_dsn" type="string" required="no" default="#dsn3#">
    	<cfif arguments.action_type is 'add'>
            <cfquery name="ADD_PAPER_ROW_TO_PAPER_ROW" datasource="#action_dsn#">
                INSERT INTO 
                   #dsn3_alias#.RELATION_ROW
                    (
                        PERIOD_ID,
                        TO_TABLE,
                        FROM_TABLE,
                        TO_WRK_ROW_ID,
                        FROM_WRK_ROW_ID,
                        TO_AMOUNT,
                        TO_ACTION_ID,
                        FROM_ACTION_ID
                    )
                    VALUES
                    (
                        #session.pda.period_id#,
                        '#arguments.to_table#',
                        '#arguments.from_table#',
                        '#arguments.to_wrk_row_id#',
                        '#arguments.from_wrk_row_id#',
                        #arguments.amount#,
                        #arguments.to_action_id#,
                        #arguments.from_action_id#
                    )
            </cfquery>
        <cfelseif arguments.action_type is 'del'>
            <cfquery name="DEL_RELATION_PAPERS_ROW" datasource="#action_dsn#">
                DELETE FROM  #dsn3_alias#.RELATION_ROW WHERE TO_ACTION_ID = #arguments.to_action_id# AND TO_TABLE = '#arguments.to_table#' AND PERIOD_ID = #session.pda.period_id#
            </cfquery>
		</cfif>
	<cfreturn true>
</cffunction>
<cfif not isdefined("attributes.rows_") or attributes.rows_ lte 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmediniz Lütfen Ürün Seçiniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cf_date tarih = "attributes.basket_due_value_date_">
<cf_date tarih = "attributes.order_date">
<!--- irsaliye tarihine gore ortalama vade tarihi --->
<cfif isdefined('attributes.basket_due_value_date_')>
	<cfset order_due_date = attributes.basket_due_value_date_>
<cfelse>
	<cfset order_due_date = ''>
</cfif>
<!--- <cfinclude template="../../objects/functions/add_relation_rows.cfm"> ---><!--- sip,irs,fat satırlarının birbiri ile ilişkileri.. --->
<cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)>
	<cf_date tarih = "attributes.deliverdate">
</cfif>
<cfif isdefined("attributes.publishdate") and isdate(attributes.publishdate)>
	<cf_date tarih = "attributes.publishdate">
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100)>
<cflock name="#CreateUUID()#" timeout="20">
<cftransaction>
	<cfquery name="GET_ORDER_CODE" datasource="#DSN3#">
		SELECT 
			ORDER_NO,
			ORDER_NUMBER 
		FROM 
			GENERAL_PAPERS
		WHERE 
			PAPER_TYPE = 1 AND ZONE_TYPE = 0
	</cfquery>
	<cfquery name="UPD_OFFER_CODE" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS 
		SET 
			ORDER_NUMBER = ORDER_NUMBER+1
		WHERE 
			PAPER_TYPE = 1 
			AND ZONE_TYPE = 0
	</cfquery>
	<!--- ORDER_CURRENCY 1 DURUMUNDA BASLIYOR --->
	<cfquery name="INS_ORDER" datasource="#DSN3#">
		INSERT INTO 
		ORDERS 
			(
			WRK_ID,
			ORDER_STATUS,
			ORDER_STAGE,
			ORDER_DATE,
			ORDER_NUMBER,
			PURCHASE_SALES,
			COMPANY_ID,
			PARTNER_ID,
			STARTDATE,
			DELIVERDATE,
			PRIORITY_ID,								   
			OFFER_ID,
			PAYMETHOD,
			ORDER_HEAD,
			ORDER_DETAIL,
			NETTOTAL,
			DELIVER_DEPT_ID,
			LOCATION_ID,
			SHIP_ADDRESS,
			INVISIBLE,
			PUBLISHDATE,
		<cfif isdefined('form.basket_money')>
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
		</cfif>
		<cfif isdefined('attributes.tax')>			
			TAX,
		</cfif>
			INCLUDED_KDV,
			RESERVED,
			SHIP_METHOD,
			PROJECT_ID,
			CATALOG_ID,
			TAXTOTAL,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			ORDER_EMPLOYEE_ID,
			DUE_DATE,
			REF_NO,
			CARD_PAYMETHOD_ID,
			CARD_PAYMETHOD_RATE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
			)
		VALUES  
			(
			'#wrk_id#',
			1,
			#attributes.process_stage#,
			#attributes.order_date#,
			'#GET_ORDER_CODE.ORDER_NO#-#GET_ORDER_CODE.ORDER_NUMBER#',
			0,
			#FORM.COMPANY_ID#,
		<cfif len(FORM.PARTNER_ID)>#FORM.PARTNER_ID#<cfelse>NULL</cfif>,
			#now()#,
		<cfif len(attributes.deliverdate)>
			#attributes.deliverdate#,
		<cfelse>
			NULL,
		</cfif>
			<cfif isdefined("FORM.PRIORITY_ID") and len(FORM.PRIORITY_ID)>#FORM.PRIORITY_ID#,<cfelse>1,</cfif>
			0,
		<cfif isdefined("form.paymethod_id") and len(form.paymethod_id) and len(form.pay_method)>
			#form.paymethod_id#,
		<cfelse>
			NULL,
		</cfif>
			'#FORM.ORDER_HEAD#',
			'#FORM.ORDER_DETAIL#',									 
		<cfif isdefined("form.basket_net_total")>
			#FORM.basket_net_total#,
		<cfelse>
			0,
		</cfif>
		<cfif isdefined("form.deliver_dept_id") and len(form.deliver_dept_id) and len(form.deliver_dept_name)>
			#form.deliver_dept_id#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("form.deliver_loc_id") and len(form.deliver_loc_id) and len(form.deliver_dept_name)>
			#form.deliver_loc_id#,
		<cfelse>
			NULL,
		</cfif>
			'#form.deliver_dept_name#',
		<cfif isDefined("FORM.INVISIBLE")>
			1,
		<cfelse>
			0,
		</cfif>
		<cfif len(attributes.publishdate)>
			#attributes.publishdate#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined('form.basket_money')>
			'#form.basket_money#',
			#((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
		</cfif>
		<cfif isdefined('attributes.tax')>
			#attributes.tax#,
		</cfif>
		<cfif isDefined("INCLUDED_KDV")>
			1,
		<cfelse>
			0,
		</cfif>
		<cfif isDefined('attributes.RESERVED')>1<cfelse>0</cfif>,
		<cfif len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,			
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
			#attributes.project_id#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id) and len(attributes.catalog_name)>
			#attributes.catalog_id#,
		<cfelse>
			NULL,
		</cfif>
			#form.basket_tax_total#,
			#form.basket_discount_total#,
			#form.basket_gross_total#,
		<cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)>#attributes.order_employee_id#<cfelse>NULL</cfif>, 
		<cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
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
			#now()#,
			#session.pda.USERID#,
			'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
		<cfquery name="GET_ORDER" datasource="#DSN3#">
			SELECT MAX(ORDER_ID) AS ORDER_ID FROM ORDERS WHERE WRK_ID = '#wrk_id#'
		</cfquery>
		<cfif attributes.rows_ neq 0>
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfif evaluate('attributes.row_kontrol#i#')>
				<cf_date tarih="attributes.deliver_date#i#">
				<cf_date tarih="attributes.reserve_date#i#">
				<!--- <cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
					<cfinclude template="../../objects/query/add_basket_spec.cfm">
				</cfif> --->
				<cfquery name="ADD_ORDER_ROW_" datasource="#DSN3#">
					INSERT INTO 
						ORDER_ROW 	 
						(
						ORDER_ID,
						ROW_INTERNALDEMAND_ID,
						RELATED_INTERNALDEMAND_ROW_ID,
						ROW_PRO_MATERIAL_ID,
						STOCK_ID,
						PRODUCT_ID,
						PRODUCT_NAME,
						QUANTITY,
					<cfif isdefined('attributes.price#i#') and  len(evaluate('attributes.price#i#'))>
						PRICE,
					</cfif>
						TAX,
						UNIT,
						UNIT_ID,
						DELIVER_DATE,
						DELIVER_DEPT,
						DELIVER_LOCATION,
						DISCOUNT_1,
						DISCOUNT_2,
						DISCOUNT_3,
						DISCOUNT_4,
						DISCOUNT_5,						
						DISCOUNT_6,
						DISCOUNT_7,
						DISCOUNT_8,
						DISCOUNT_9,
						DISCOUNT_10,						
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						SPECT_VAR_ID,
						SPECT_VAR_NAME,
					</cfif>
						LOT_NO,
						PRICE_OTHER,
						NETTOTAL,
						IS_PROMOTION,
						DISCOUNT_COST,
						ORDER_ROW_CURRENCY,
						RESERVE_TYPE,
						RESERVE_DATE,
						EXTRA_COST,
						UNIQUE_RELATION_ID,
						PROM_RELATION_ID,
						PRODUCT_NAME2,
						AMOUNT2,
						UNIT2,
						EXTRA_PRICE,
						EK_TUTAR_PRICE,<!--- iscilik birim ücreti --->
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
						DUEDATE,
						KARMA_PRODUCT_ID,
						OTV_ORAN,
						OTVTOTAL,
                        WRK_ROW_ID,
                        WRK_ROW_RELATION_ID,
                        RELATED_ACTION_ID,
                        RELATED_ACTION_TABLE
						)
					VALUES 
						(
						#GET_ORDER.ORDER_ID#,
					<cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
						#evaluate("attributes.stock_id#i#")#,
						#evaluate("attributes.product_id#i#")#,
						'#wrk_eval("attributes.product_name#i#")#',
						#evaluate("attributes.amount#i#")#,
					<cfif isdefined('attributes.price#i#') and len(evaluate('attributes.price#i#'))>
						#evaluate('attributes.price#i#')#,
					</cfif>
						#evaluate("attributes.tax#i#")#,
						'#wrk_eval("attributes.unit#i#")#',
						#evaluate("attributes.unit_id#i#")#,
					<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif len(attributes.deliver_dept_id)>
						#attributes.deliver_dept_id#,						
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif len(attributes.deliver_loc_id)>
						#attributes.deliver_loc_id#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
					'#wrk_eval("attributes.other_money_#i#")#',
					<cfif isdefined("attributes.other_money_value_#i#") and  len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>1</cfif>,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						#evaluate('attributes.spect_id#i#')#,
						'#wrk_eval('attributes.spect_name#i#')#',
					</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
						0,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reserve_date#i#") and len(evaluate("attributes.reserve_date#i#"))>#evaluate("attributes.reserve_date#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))>'#wrk_eval('attributes.prom_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))>'#wrk_eval('attributes.related_action_table#i#')#'<cfelse>NULL</cfif>
						)
				</cfquery>

			<cfquery name="get_max_order_row" datasource="#DSN3#">
				SELECT MAX(ORDER_ROW_ID) AS ORDER_ROW_ID FROM ORDER_ROW
			</cfquery>
			<cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
                <cfscript>
					add_relation_rows(
						action_type:'add',
						action_dsn : '#dsn3#',
						to_table:'ORDERS',
						from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
						to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
						from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
						amount : Evaluate("attributes.amount#i#"),
						to_action_id : GET_ORDER.ORDER_ID,
						from_action_id :Evaluate("attributes.related_action_id#i#")
						);
				</cfscript>
            </cfif>
			<cfset attributes.ROW_MAIN_ID = get_max_order_row.ORDER_ROW_ID>
			<cfset row_id = i>
			<cfset ACTION_TYPE_ID = 2>
			<cfset attributes.product_id = evaluate("attributes.product_id#i#")>
			<cfinclude template="add_assortment_textile_js.cfm">
			<cfinclude template="add_department_information.cfm">
			<!--- //  urun asortileri --->	
			</cfif>		
			</cfloop>	
		</cfif>
		<!--- referans satıs siparisiyle kaydedilen siparis arasındaki baglantı  PAPER_RELATION'da tutuluyor--->
		<cfif isdefined('attributes.ref_paper_id') and len(attributes.ref_paper_id)>
			<cfquery name="ADD_PAPER_RELATION" datasource="#DSN3#">
				INSERT INTO
				#dsn_alias#.PAPER_RELATION
					(
					PAPER_ID,
					PAPER_TABLE,
					PAPER_TYPE_ID,
					RELATED_PAPER_ID,
					RELATED_PAPER_TABLE,
					RELATED_PAPER_TYPE_ID,
					COMP_ID,
					PERIOD_ID
					)
				VALUES
					(
					#GET_ORDER.ORDER_ID#,
					'ORDERS',
					1,
					<cfif isdefined('attributes.pro_material_id') and len(attributes.pro_material_id)>
					#attributes.pro_material_id#,
					'PRO_MATERIAL',
					2,
					<cfelse>
					#attributes.ref_paper_id#,
					'ORDERS',
					1,
					</cfif>
					#session.pda.our_company_id#,
					#session.pda.period_id#
					)
			</cfquery>
		</cfif>
	<cfscript>
		basket_kur_ekle(action_id:GET_ORDER.ORDER_ID,table_type_id:3,process_type:0);
		include('add_order_row_reserved_stock_pda.cfm','\objects\functions'); //rezerve edilen satırlar icin ORDER_ROW_RESERVED'a kayıt atıyor.
		add_reserve_row(
			reserve_order_id:GET_ORDER.ORDER_ID,
			reserve_action_type:0,
			is_order_process:0,
			is_purchase_sales:0
			);
		if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //siparis ic talepten olusturulacaksa
		{
			include('add_internaldemand_relation.cfm','\objects\functions'); 
			add_internaldemand_row_relation(
				to_related_action_id:GET_ORDER.ORDER_ID,
				to_related_action_type:0,
				action_status:0
				);
		}
		if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
		{
			include('add_paper_relation.cfm','\objects\functions'); 
			add_paper_relation(
				to_paper_id :GET_ORDER.ORDER_ID,
				to_paper_table : 'ORDERS',
				to_paper_type :1,
				from_paper_table : 'PRO_MATERIAL',
				from_paper_type :2,
				relation_type : 1,
				action_status:0
				);
		}
	</cfscript>
	</cftransaction>
</cflock>
<cf_get_lang_set module_name="sales"><!--- sayfanin en ustunde acilisi var --->
