<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<!--- <cfinclude template="check_our_period.cfm"> --->
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='4.Ürün Seçmediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date' >
<cfif not len(attributes.location_id)>
	<cfset attributes.location_id = "NULL">
</cfif>
<cfif not len(attributes.location_in_id)>
	<cfset attributes.location_in_id = "NULL">
</cfif>

<cfif isDefined("session.ep")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cfif isDefined("session.pda")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
	<cfquery name="ADD_SALE" datasource="#DSN2#" result="MAX_ID">
		INSERT INTO
			SHIP
		(
			WRK_ID,
			PURCHASE_SALES,
			SHIP_NUMBER,
			DISPATCH_SHIP_ID,
			SHIP_TYPE,
			PROCESS_CAT,
			<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>SHIP_METHOD,</cfif>
			SHIP_DATE,
			<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
			DISCOUNTTOTAL,
			NETTOTAL,
			GROSSTOTAL,
			TAXTOTAL,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			DELIVER_STORE_ID,
			LOCATION,
			DEPARTMENT_IN,
			LOCATION_IN,
			REF_NO,
			PROJECT_ID,
			RECORD_DATE,
			RECORD_EMP,
			SHIP_DETAIL
		)
		VALUES
		(
			'#wrk_id#',
			1,
			'#SHIP_NUMBER#',
			<cfif isdefined("attributes.dispatch_ship_id")>#attributes.dispatch_ship_id#<cfelse>NULL</cfif>,
			#get_process_type.process_type#,
			#form.process_cat#,
			<cfif isDefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#,</cfif>
			#attributes.ship_date#,
			<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,</cfif>
			<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>0#attributes.BASKET_DISCOUNT_TOTAL#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#<cfelse>0</cfif>,
			<cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#<cfelse>0</cfif>,
			'#form.basket_money#',
			#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
			#attributes.department_id#,
			#attributes.location_id#,
			#attributes.department_in_id#,
			#attributes.location_in_id#,
			<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.pda.userid#,
			<cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<!--- <cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
			<cfset dsn_type=dsn2>
			<cfinclude template="../../objects/query/add_basket_spec.cfm">
		</cfif> --->
		<cfif evaluate('attributes.row_kontrol#i#')>
		<cf_date tarih = 'attributes.deliver_date#i#'>
		<cfinclude template="get_dis_amount.cfm">
		<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>
			<cfset product_name_other_ = evaluate('attributes.product_name_other#i#')>
		</cfif>
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
				DISCOUNT,
				PURCHASE_SALES,
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
				LOT_NO,
				PRICE_OTHER,
				OTHER_MONEY_GROSS_TOTAL,
				IS_PROMOTION,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
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
				ROW_INTERNALDEMAND_ID,
				CATALOG_ID,
				OTV_ORAN,
				OTVTOTAL,
				DARA,
				DARALI,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID
			)
			VALUES
			(
				'#left(evaluate("attributes.product_name#i#"),250)#',
				<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#<cfelse>NULL</cfif>,
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
				1,
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
			<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				#attributes.department_id#,
				#attributes.location_id#,
			  <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				'#wrk_eval('attributes.spect_name#i#')#',
			  </cfif>
			<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#evaluate('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
				0,
			<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#product_name_other_#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and evaluate('attributes.row_ship_id#i#') neq 0>#evaluate('attributes.row_ship_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfif get_process_type.is_stock_action eq 1><!--- Stok hareketi yapılsın --->
			<cfinclude template="get_unit_add_fis.cfm">
			<cfif get_unit.recordcount and len(get_unit.multiplier)>
				<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
			<cfelse>
				<cfset multi=evaluate("attributes.amount#i#")>
			</cfif>
			<cfset form_spect_main_id="">
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				<cfset form_spect_id="#evaluate('attributes.spect_id#i#')#">
				<cfif len(form_spect_id) and len(form_spect_id)>
					<cfquery name="GET_MAIN_SPECT" datasource="#DSN2#">
						SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID=#form_spect_id#
					</cfquery>
					<cfif GET_MAIN_SPECT.RECORDCOUNT>
						<cfset form_spect_main_id=GET_MAIN_SPECT.SPECT_MAIN_ID>
					</cfif>
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
					STOCK_OUT,
					STORE,
					STORE_LOCATION,
					PROCESS_DATE,
				  <cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
					SPECT_VAR_ID,
				  </cfif>
					LOT_NO,
					<!--- DELIVER_DATE,
					SHELF_NUMBER,  raf ve son kullanma tarihi bilgileri sadece giris depodan yapılan stok hareketlerinde tutuluyor OZDEN20071008 --->
					PRODUCT_MANUFACT_CODE,				
					AMOUNT2,
					UNIT2
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.stock_id#i#")#,
					#get_process_type.process_type#,
					#multi#,
					#attributes.department_id#,
					#attributes.location_id#,
					#attributes.ship_date#,
				<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>
					#form_spect_main_id#,
				</cfif>
				<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#evaluate('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
	<!--- 		<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,--->
				<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>
		</cfif>
	</cfloop>
	<cfscript>
		if( len(attributes.location_in_id) and len(attributes.department_in_id)) //giris deposu kontrol ediliyor
		{
			LOCATION_IN=cfquery(datasource:"#dsn2#",sqlstring:"SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_in_id# AND LOCATION_ID=#attributes.location_in_id#");
			location_type_in = LOCATION_IN.LOCATION_TYPE;
			is_scrap_in = LOCATION_IN.IS_SCRAP;
		}
		else
			location_type_in =''; is_scrap_in='';
		if( len(attributes.location_id) and len(attributes.department_id)) //cikis deposu kontrol ediliyor
		{	
			LOCATION_OUT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#");
			location_type_out = LOCATION_OUT.LOCATION_TYPE;
			is_scrap_out = LOCATION_OUT.IS_SCRAP;
		}
		else
			location_type_out = ''; is_scrap_out='';
			
		/*1-Hammadde,2-Mal,3-Mamul,4-Konsinye*/
		if(get_process_type.is_account eq 1 and location_type_in neq location_type_out and location_type_in neq 1 and location_type_out eq 2)
		{
			include('ship_account_process.cfm');
			muhasebeci(
				action_id : MAX_ID.IDENTITYCOL,
				workcube_process_type : get_process_type.process_type,
				workcube_process_cat:form.process_cat,
				account_card_type : 13,
				islem_tarihi : attributes.ship_date,
				borc_hesaplar : str_borclu_hesaplar,
				borc_tutarlar : borc_alacak_tutar,
				other_amount_borc : str_dovizli_tutarlar,
				other_currency_borc : str_doviz_currency,
				borc_miktarlar : str_miktar,
				borc_birim_tutar : str_tutar,
				alacak_hesaplar : str_alacakli_hesaplar,
				alacak_tutarlar : borc_alacak_tutar,
				other_amount_alacak : str_dovizli_tutarlar,
				other_currency_alacak :str_doviz_currency,
				alacak_miktarlar : str_miktar,
				alacak_birim_tutar : str_tutar,
				fis_detay : "DEPO SEVK İRSALİYESİ",
				fis_satir_detay : satir_detay_list,
				belge_no : SHIP_NUMBER,
				is_account_group : get_process_type.is_account_group,
				currency_multiplier : currency_multiplier,
				acc_project_list_alacak : acc_project_list_alacak,
				acc_project_list_borc : acc_project_list_borc
			);			
		}
		basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);
		
		if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //depo sevk ic talepten olusturulmussa
		{
			include('add_internaldemand_relation_pda.cfm','\objects\functions'); 
			add_internaldemand_row_relation(
				to_related_action_id:MAX_ID.IDENTITYCOL,
				to_related_action_type:1,
				action_status:0,
				process_db:dsn2
				);
		}
	</cfscript>	
	<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = "#MAX_ID.IDENTITYCOL#"
			action_table="SHIP"
			action_column="SHIP_ID"
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cfif>
	</cftransaction>
</cflock>

<!--- seri no--->
<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
		<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1) >
			 <cfscript>
				add_serial_no(
					session_row : i,
					is_insert : true,
					action_id : MAX_ID.IDENTITYCOL,
					action_type : 2,
					action_number  : '#SHIP_NUMBER#',
					is_sale : true,
					dpt_id : attributes.department_in_id,
					loc_id : attributes.location_in_id
				);
			 </cfscript>
			 <cfscript>
				add_serial_no(
					session_row : i,
					is_insert : false,
					dpt_id : attributes.department_id,
					loc_id : attributes.location_id
				);
			 </cfscript>
			 
		</cfif>
	</cfif>
</cfloop>		
<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)>
	<cfquery name="UPD_PAPERS" datasource="#DSN3#">
		UPDATE
			PAPERS_NO
		SET
			SHIP_NUMBER = #attributes.paper_number#
		WHERE
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #SESSION.pda.USERID#
		</cfif>
	</cfquery>
</cfif>
<!--- <cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_ship_dispatch&ship_id=#get_id.max_id#" addtoken="no"> --->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
