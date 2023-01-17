<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"> 
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT SHIP_ID FROM SHIP WHERE SHIP_ID = #attributes.upd_id#
</cfquery>
<cfif not get_number.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='537.Böyle Bir İrsaliye Kaydı Bulunamadı'>!");
		window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>";	
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_process_cat.cfm">
<cfif isDefined("form.del") and (form.del eq 1)>
	<cfinclude template="upd_del_purchase.cfm">
	<cfabort>
</cfif>
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='4.Ürün Seçmediniz !'>!!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>	
</cfif>
<cfquery name="GET_UNIQUE" datasource="#dsn2#">
	SELECT 
		SHIP_NUMBER,
		PURCHASE_SALES,
		SHIP_ID
	FROM 
		SHIP
	WHERE 
		SHIP_NUMBER = '#SHIP_NUMBER#' AND 
		PURCHASE_SALES = 0 AND
		SHIP_ID <> #attributes.upd_id#
</cfquery>
<cfif GET_UNIQUE.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='123.Girdiginiz İrsaliye Numarası Kullanılıyor ! Lütfen Tekrar Giriniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL" >
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_PURCHASE" datasource="#dsn2#">
			UPDATE
				SHIP
			SET
				SHIP_NUMBER = '#SHIP_NUMBER#',
				SHIP_TYPE = #get_process_type.PROCESS_TYPE#,
				PROCESS_CAT=#form.process_cat#,
			<cfif isDefined('attributes.SHIP_METHOD') and len(SHIP_METHOD) >
				SHIP_METHOD = #SHIP_METHOD#,
			</cfif>
				SHIP_DATE = #attributes.ship_date#,
			<cfif len(attributes.company_id) and attributes.company_id neq 0>
				COMPANY_ID = #attributes.company_id#,
				PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				CONSUMER_ID= NULL,
			<cfelse>
				COMPANY_ID = NULL,
				PARTNER_ID = NULL,
				CONSUMER_ID=#attributes.consumer_id#,
			</cfif>
			<cfif isdate(attributes.deliver_date_frm)>
				DELIVER_DATE = #attributes.deliver_date_frm#,
			</cfif>
				DELIVER_EMP = <cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)>'#LEFT(TRIM(attributes.deliver_get),50)#'<cfelse>NULL</cfif>,
				DELIVER_EMP_ID = <cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id)>#attributes.deliver_get_id#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.paymethod_id")>
				PAYMETHOD_ID = #attributes.paymethod_id#,
			</cfif>
				DISCOUNTTOTAL =<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				NETTOTAL = <cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#,<cfelse>0,</cfif>
				GROSSTOTAL =<cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#,<cfelse>0,</cfif>
				TAXTOTAL =<cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#,<cfelse>0,</cfif>
				OTHER_MONEY='#form.basket_money#',			
				OTHER_MONEY_VALUE=#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
				DEPARTMENT_IN = #attributes.department_id#,
				LOCATION_IN=#attributes.location_id#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP =#session.ep.userid#,
				IS_SHIP_IPTAL = <cfif isdefined("form.irsaliye_iptal") and form.irsaliye_iptal eq 1>1<cfelse>0</cfif>
			WHERE
				SHIP_ID = #attributes.UPD_ID#
		</cfquery>	
		<cfquery name="DEL_SHIP_ROWS" datasource="#dsn2#">
			DELETE FROM SHIP_ROW WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID=#attributes.UPD_ID# AND PROCESS_TYPE=#attributes.TYPE_ID#
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfif not len(evaluate("attributes.darali#i#"))><cfset "attributes.darali#i#"=0></cfif>
			<cfif not len(evaluate("attributes.dara#i#"))><cfset "attributes.dara#i#"=0></cfif>
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
				<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
					COST_PRICE,
				</cfif>
					EXTRA_COST,
					LOT_NO,
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					DARA,
					DARALI,
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
					BASKET_EXTRA_INFO_ID,
					SELECT_INFO_EXTRA,
                	DETAIL_INFO_EXTRA,
					LIST_PRICE,
					NUMBER_OF_INSTALLMENT,
					PRICE_CAT,
					CATALOG_ID,
					OTV_ORAN,
					OTVTOTAL,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID,
                    RELATED_ACTION_ID,
                    RELATED_ACTION_TABLE,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
					)
				VALUES
					(
					'#left(wrk_eval("attributes.product_name#i#"),250)#',
					#attributes.UPD_ID#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					'#wrk_eval("attributes.unit#i#")#',
					#evaluate("attributes.unit_id#i#")#,
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
					<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
						<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
                    </cfif>
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
					#evaluate("attributes.dara#i#")#,
					#evaluate("attributes.darali#i#")#,
					0,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
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
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))>'#wrk_eval('attributes.related_action_table#i#')#'<cfelse>NULL</cfif>,
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
                        to_table:'SHIP',
                        from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                        to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                        from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                        amount : Evaluate("attributes.amount#i#"),
                        to_action_id : attributes.UPD_ID,
                        from_action_id :Evaluate("attributes.related_action_id#i#")
                        );
                </cfscript>
            </cfif>
		</cfloop>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID=#attributes.UPD_ID# AND PROCESS_TYPE=#attributes.TYPE_ID#
		</cfquery>
		<cfif not (isdefined("form.irsaliye_iptal") and (form.irsaliye_iptal eq 1))> <!--- irsaliye iptal secili degilse stok hareketi yapılır --->
			<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfinclude template="get_unit_add_fis.cfm">
				<cfif get_unit.recordcount and len(get_unit.multiplier)>
					<cfset multi=get_unit.multiplier*(evaluate("attributes.darali#i#")-evaluate("attributes.dara#i#"))>
				<cfelse>
					<cfset multi=evaluate("attributes.darali#i#")-evaluate("attributes.dara#i#")>
				</cfif>
                <cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
					SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#evaluate("attributes.product_id#i#")#) AND IS_KARMA = 1
				</cfquery>
					<cfif GET_KARMA_PRODUCTS.recordcount>
                        <cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
                            SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID =#evaluate("attributes.product_id#i#")#
                        </cfquery>
						<cfif GET_KARMA_PRODUCT.recordcount>
                            <cfloop query="GET_KARMA_PRODUCT">
                            <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)><!--- karma koli satırındaki urun için spec seçilmisse, hem o ürün hem de sevkte birleştirilen urunleri için stok hareketi yazılır --->
								<cfquery name="GET_SPEC_PRODUCT" datasource="#dsn2#">
									SELECT 
										PRODUCT_ID,
										STOCK_ID,
										AMOUNT,
										RELATED_MAIN_SPECT_ID
									FROM
										#dsn3_alias#.SPECT_MAIN_ROW
									WHERE
										IS_SEVK = 1 AND
										STOCK_ID IS NOT NULL AND
										PRODUCT_ID IS NOT NULL AND
										SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCT.SPEC_MAIN_ID#">
								</cfquery>
								<cfif GET_SPEC_PRODUCT.recordcount>
									<cfloop query="GET_SPEC_PRODUCT">
                                             <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                                INSERT INTO 
                                                    STOCKS_ROW
                                                    (
                                                        PROCESS_DATE,
                                                        UPD_ID,
                                                        PRODUCT_ID,
                                                        STOCK_ID,
                                                        PROCESS_TYPE,
                                                        STOCK_IN,
                                                        STORE,
                                                        STORE_LOCATION,
                                                    <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                                                        SPECT_VAR_ID,
                                                    </cfif>                                          
                                                        SHELF_NUMBER
                                                    )
                                                    VALUES
                                                    (
                                                    <cfif len(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>,
                                                        #attributes.UPD_ID#,
                                                        #GET_SPEC_PRODUCT.product_id#,
                                                        #GET_SPEC_PRODUCT.stock_id#,
                                                        #get_process_type.PROCESS_TYPE#,
                                                        #multi*GET_SPEC_PRODUCT.product_amount#,
                                                        #attributes.department_id#,
                                                        #attributes.location_id#,
                                                    <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                                        <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                    </cfif>				
                                                    <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>
                                                    )
                                            </cfquery>
									</cfloop>
								</cfif>
							</cfif>
                              <cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
                                    INSERT INTO 
                                        STOCKS_ROW
                                        (
                                            PROCESS_DATE,
                                            UPD_ID,
                                            PRODUCT_ID,
                                            STOCK_ID,
                                            PROCESS_TYPE,
                                            STOCK_IN,
                                            STORE,
                                            STORE_LOCATION,
                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                                            SPECT_VAR_ID,
                                        </cfif>                                          
                                            SHELF_NUMBER
                                        )
                                        VALUES
                                        (
                                        <cfif len(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>,
                                            #attributes.UPD_ID#,
                                            #GET_KARMA_PRODUCT.product_id#,
                                    		#GET_KARMA_PRODUCT.stock_id#,
                                            #get_process_type.PROCESS_TYPE#,
                                            #multi*GET_KARMA_PRODUCT.product_amount#,
                                            #attributes.department_id#,
                                            #attributes.location_id#,
                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                            <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                        </cfif>				
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>
                                        )
                                </cfquery>
                            </cfloop>
                        </cfif>
               		<cfelse>
						<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
					INSERT INTO 
						STOCKS_ROW
						(
							PROCESS_DATE,
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_IN,
							STORE,
							STORE_LOCATION,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
							SPECT_VAR_ID,
						</cfif>
							LOT_NO,
							SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE
						)
						VALUES
						(
						<cfif len(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>,
							#attributes.UPD_ID#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.stock_id#i#")#,
							#get_process_type.PROCESS_TYPE#,
							#multi#,
							#attributes.department_id#,
							#attributes.location_id#,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
							#evaluate('attributes.spect_id#i#')#,
						</cfif>				
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
						)
				</cfquery>
               	 	</cfif>
			</cfloop>
		</cfif>
		</cfif>
		<cfscript>basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:2,process_type:1);</cfscript>	
        <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#attributes.UPD_ID#" action_name="#SHIP_NUMBER# Güncellendi" paper_no="#SHIP_NUMBER#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:2);</cfscript>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_marketplace_ship&event=upd&ship_id=#attributes.UPD_ID#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
