<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"> 
<cfif isdefined('attributes.ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset attributes.ship_number = Replace(attributes.ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='4.Ürün Seçmelisiniz!'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not len(attributes.company_id) and not len(attributes.consumer_id)>
	<script type="text/javascript">
		alert("<cf_get_lang no='131.Cari Hesap Seçiniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL" >
</cfif>
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
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
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
				DELIVER_EMP_ID,
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
				RECORD_EMP,
				ORDER_ID
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
				<cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)>'#LEFT(TRIM(attributes.deliver_get),50)#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id)>#attributes.deliver_get_id#<cfelse>NULL</cfif>,
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
				#session.ep.userid#,
				<cfif isdefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
            <cf_date tarih = 'attributes.deliver_date#i#'><!--- satırdaki teslim tarihi burada formatlanıyor, fakat stocks_row'a kayıt atılırken de aynı degerler kullanılıyor --->
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
					DELIVER_DATE,				
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
					OTHER_MONEY,
					OTHER_MONEY_VALUE,				
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					DARA,
					DARALI,
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
					<cfif isdefined('attributes.indirim1#i#') and len(evaluate('attributes.indirim1#i#'))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim2#i#') and len(evaluate('attributes.indirim2#i#'))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim3#i#') and len(evaluate('attributes.indirim3#i#'))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim4#i#') and len(evaluate('attributes.indirim4#i#'))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim5#i#') and len(evaluate('attributes.indirim5#i#'))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim6#i#') and len(evaluate('attributes.indirim6#i#'))>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim7#i#') and len(evaluate('attributes.indirim7#i#'))>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim8#i#') and len(evaluate('attributes.indirim8#i#'))>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim9#i#') and len(evaluate('attributes.indirim9#i#'))>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim10#i#') and len(evaluate('attributes.indirim10#i#'))>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
					#DISCOUNT_AMOUNT#,
					#evaluate("attributes.row_lasttotal#i#")#,
					#evaluate("attributes.row_nettotal#i#")#,
					#evaluate("attributes.row_taxtotal#i#")#,
					<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
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
					<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
					#evaluate("attributes.dara#i#")#,
					#evaluate("attributes.darali#i#")#,
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
                        to_action_id : MAX_ID.IDENTITYCOL,
                        from_action_id :Evaluate("attributes.related_action_id#i#")
                        );
                </cfscript>
            </cfif>
			<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
				<cfinclude template="get_unit_add_fis.cfm">
				<cfif get_unit.recordcount  and len(get_unit.multiplier) >
					<cfset multi = get_unit.multiplier*(evaluate("attributes.darali#i#")-evaluate("attributes.dara#i#"))>
				<cfelse>
					<cfset multi = evaluate("attributes.darali#i#")-evaluate("attributes.dara#i#")>
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
                                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                                                            SPECT_VAR_ID,
                                                        </cfif>                                            
                                                            SHELF_NUMBER
                                                            
                                                        )
                                                        VALUES
                                                        (
                                                            #MAX_ID.IDENTITYCOL#,
                                                            #GET_SPEC_PRODUCT.product_id#,
                                                            #GET_SPEC_PRODUCT.stock_id#,
                                                            #get_process_type.PROCESS_TYPE#,
                                                            #multi*GET_SPEC_PRODUCT.product_amount#,
                                                            #attributes.department_id#,
                                                            #attributes.location_id#,
                                                            #attributes.deliver_date_frm#,
                                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                                           <cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID)>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
                                                        </cfif>
                                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>
                                                      
                                                        )
                               				 </cfquery>
									</cfloop>
								</cfif>
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
                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
                                            SPECT_VAR_ID,
                                        </cfif>                                            
                                            SHELF_NUMBER
                                            
                                        )
                                        VALUES
                                        (
                                            #MAX_ID.IDENTITYCOL#,
                                            #GET_KARMA_PRODUCT.product_id#,
                                    		#GET_KARMA_PRODUCT.stock_id#,
                                            #get_process_type.PROCESS_TYPE#,
                                            #multi*GET_KARMA_PRODUCT.product_amount#,
                                            #attributes.department_id#,
                                            #attributes.location_id#,
                                            #attributes.deliver_date_frm#,
                                        <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
                                           <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
                                        </cfif>
                                        <cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>
                                      
                                        )
                                </cfquery>
                            </cfloop>
                        </cfif>
               		<cfelse>
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
							#attributes.deliver_date_frm#,
						<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
							#evaluate('attributes.spect_id#i#')#,
						</cfif>
						<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
						)
				</cfquery>
                	</cfif>
			</cfif>
		</cfloop>
		<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);</cfscript>
	</cftransaction>
</cflock>
<cfif isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:2,action_id:MAX_ID.IDENTITYCOL,query_type:1);</cfscript>
</cfif>
<script type="text/javascript">
window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_marketplace_ship&event=upd&ship_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
