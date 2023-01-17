<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfinclude template="get_process_cat.cfm">
<cf_papers paper_type="STOCK_FIS">
<cfset system_paper_no_fis = paper_code & '-' & paper_number>
<cfset system_paper_no_fis_add = paper_number>
<cfset attributes.exchange_no= system_paper_no_fis>

<cf_date tarih = 'attributes.process_date'>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfloop from="1" to="#attributes.stock_record_num#" index="rw_ind">
			<cfif isdefined('attributes.row_kontrol#rw_ind#') and evaluate('attributes.row_kontrol#rw_ind#') eq 1>
				<cfif isDefined("session.ep")>
					<cfquery name="get_production" datasource="#dsn2#">
						SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate('attributes.stock_id#rw_ind#')#
					</cfquery>
					<cfquery name="get_production2" datasource="#dsn2#">
						SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate('attributes.exit_stock_id#rw_ind#')#
					</cfquery>
					<cfif get_production.IS_PRODUCTION eq 1 and not (isdefined('attributes.spec_main_name#rw_ind#') and len(evaluate('attributes.spec_main_id#rw_ind#')))>
						<cfquery name="GET_TREE#rw_ind#" datasource="#dsn2#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor.aşağıdada bu main spec kullanılarak bir spec oluşturuluyor..ve baskete yansıtılıyor.. --->
							SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#rw_ind#")# ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
						</cfquery>
						<cfif evaluate('GET_TREE#rw_ind#.RECORDCOUNT')>
							<cfset 'attributes.spec_main_id#rw_ind#'=evaluate('GET_TREE#rw_ind#.SPECT_MAIN_ID')>
							<cfset 'attributes.spec_main_name#rw_ind#'=evaluate('GET_TREE#rw_ind#.SPECT_MAIN_NAME')>
						</cfif>
					</cfif>
					<cfif get_production2.IS_PRODUCTION eq 1 and not (isdefined('attributes.exit_spec_main_name#rw_ind#') and len(evaluate('attributes.exit_spec_main_id#rw_ind#')))>
						<cfquery name="GET_TREE2_#rw_ind#" datasource="#dsn2#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor.aşağıdada bu main spec kullanılarak bir spec oluşturuluyor..ve baskete yansıtılıyor.. --->
							SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.exit_stock_id#rw_ind#")# ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
						</cfquery>
						<cfif evaluate('GET_TREE2_#rw_ind#.RECORDCOUNT')>
							<cfset 'attributes.exit_spec_main_id#rw_ind#'=evaluate('GET_TREE2_#rw_ind#.SPECT_MAIN_ID')>
							<cfset 'attributes.exit_spec_main_name#rw_ind#'=evaluate('GET_TREE2_#rw_ind#.SPECT_MAIN_NAME')>
						</cfif>
					</cfif>
				</cfif>	
                <cfif isdefined('attributes.spec_main_name#rw_ind#') and len(evaluate('attributes.spec_main_id#rw_ind#'))>
					<cfscript>
                        new_cre_spect_id = specer(
                            dsn_type:dsn2,
                            add_to_main_spec:1,
                            main_spec_id:evaluate('attributes.spec_main_id#rw_ind#')
                        );
                    </cfscript>
                    <cfif isdefined("new_cre_spect_id") and len(new_cre_spect_id)>
                        <cfset 'spect_id#rw_ind#' = listgetat(new_cre_spect_id,2,',')>
                    </cfif>
                </cfif>
                <cfif isdefined('attributes.exit_spec_main_name#rw_ind#') and len(evaluate('attributes.exit_spec_main_id#rw_ind#'))>
					<cfscript>
                        new_cre_spect_id = specer(
                            dsn_type:dsn2,
                            add_to_main_spec:1,
                            main_spec_id:evaluate('attributes.exit_spec_main_id#rw_ind#')
                        );
                    </cfscript>
                    <cfif isdefined("new_cre_spect_id") and len(new_cre_spect_id)>
                        <cfset 'exit_spect_id#rw_ind#' = listgetat(new_cre_spect_id,2,',')>
                    </cfif>
                </cfif>
				<cfquery name="add_exchange" datasource="#dsn2#" result="MAX_ID">
					INSERT INTO
					STOCK_EXCHANGE
						(
							EXCHANGE_NUMBER,
							STOCK_EXCHANGE_TYPE,
							PROCESS_TYPE,
							PROCESS_CAT,
							PROCESS_DATE,
							STOCK_ID,
							PRODUCT_ID,
							UNIT_ID,
							UNIT,
							EXIT_STOCK_ID,
							EXIT_PRODUCT_ID,
							EXIT_UNIT_ID,
							EXIT_UNIT,
							EXIT_SPECT_ID,
							EXIT_SPECT_MAIN_ID,
							SPECT_ID,
							SPECT_MAIN_ID,
							AMOUNT,
							AMOUNT2,
							EXIT_AMOUNT,
							EXIT_AMOUNT2,
							UNIT2,
							EXIT_UNIT2,
							DEPARTMENT_ID,
							LOCATION_ID,
							SHELF_NUMBER,
							EXIT_DEPARTMENT_ID,
							EXIT_LOCATION_ID,
							EXIT_SHELF_NUMBER,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							DETAIL,
                            WRK_ROW_ID,
                            EXIT_LOT_NO,
                            LOT_NO
						)
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.exchange_no#">,
							0,
							#GET_PROCESS_TYPE.PROCESS_TYPE#,
							#attributes.process_cat#,
							#attributes.process_date#,
							#evaluate('attributes.stock_id#rw_ind#')#,
							#evaluate('attributes.product_id#rw_ind#')#,
							<cfif isdefined("attributes.unit_id#rw_ind#") and len(evaluate("attributes.unit_id#rw_ind#"))>#evaluate('attributes.unit_id#rw_ind#')#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#rw_ind#')#">,
							#evaluate('attributes.exit_stock_id#rw_ind#')#,
							#evaluate('attributes.exit_product_id#rw_ind#')#,
							<cfif isdefined("attributes.exit_unit_id#rw_ind#") and len(evaluate("attributes.exit_unit_id#rw_ind#"))>#evaluate('attributes.exit_unit_id#rw_ind#')#<cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.exit_unit#rw_ind#')#">,
							<cfif isdefined("exit_spect_id#rw_ind#") and len(evaluate("exit_spect_id#rw_ind#"))>#evaluate('exit_spect_id#rw_ind#')#,<cfelse>NULL,</cfif>
							<cfif len(evaluate('attributes.exit_spec_main_name#rw_ind#')) and len(evaluate('attributes.exit_spec_main_id#rw_ind#'))>#evaluate('attributes.exit_spec_main_id#rw_ind#')#<cfelse>NULL</cfif>,
							<cfif isdefined("spect_id#rw_ind#") and len(evaluate("spect_id#rw_ind#"))>#evaluate('spect_id#rw_ind#')#,<cfelse>NULL,</cfif>
							<cfif len(evaluate('attributes.spec_main_name#rw_ind#')) and len(evaluate('attributes.spec_main_id#rw_ind#'))>#evaluate('attributes.spec_main_id#rw_ind#')#<cfelse>NULL</cfif>,
							#evaluate('attributes.amount#rw_ind#')#,
							<cfif isdefined('attributes.amount2_#rw_ind#') and len(evaluate('attributes.amount2_#rw_ind#'))>#evaluate('attributes.amount2_#rw_ind#')#<cfelse>NULL</cfif>,
							#evaluate('attributes.exit_amount#rw_ind#')#,
							<cfif isdefined('attributes.exit_amount2_#rw_ind#') and len(evaluate('attributes.exit_amount2_#rw_ind#'))>#evaluate('attributes.exit_amount2_#rw_ind#')#<cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.unit2_#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit2_#rw_ind#')#"><cfelse>NULL</cfif>,
							<cfif len(evaluate('attributes.exit_unit2_#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.exit_unit2_#rw_ind#')#"><cfelse>NULL</cfif>,
							#attributes.department_id#,
							#attributes.location_id#,
							<cfif isdefined('attributes.shelf_id#rw_ind#') and len(evaluate('attributes.shelf_id#rw_ind#')) and isdefined('attributes.shelf_code#rw_ind#') and len(evaluate('attributes.shelf_code#rw_ind#'))>#evaluate('attributes.shelf_id#rw_ind#')#<cfelse>NULL</cfif>,
							#attributes.exit_department_id#,
							#attributes.exit_location_id#,
							<cfif isdefined('attributes.exit_shelf_id#rw_ind#') and len(evaluate('attributes.exit_shelf_id#rw_ind#')) and isdefined('attributes.exit_shelf_code#rw_ind#') and len(evaluate('attributes.exit_shelf_code#rw_ind#'))>#evaluate('attributes.exit_shelf_id#rw_ind#')#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
							#now()#,
							<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.wrk_row_id#rw_ind#') and len(evaluate('attributes.wrk_row_id#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#rw_ind#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.exit_lot_no#rw_ind#') and len(evaluate('attributes.exit_lot_no#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.exit_lot_no#rw_ind#')#"><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.lot_no#rw_ind#') and len(evaluate('attributes.lot_no#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#rw_ind#')#"><cfelse>NULL</cfif>
						)
				</cfquery>
				<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
					<cfquery name="add_exchange_stock" datasource="#dsn2#">
						INSERT INTO
						STOCKS_ROW
							(
								PROCESS_TYPE,
								STOCK_ID,
								PRODUCT_ID,
								UPD_ID,
								STOCK_IN,
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								SHELF_NUMBER,
								PROCESS_DATE,
								SPECT_VAR_ID,
								UNIT2,
								LOT_NO
							)
						VALUES
							(
								#GET_PROCESS_TYPE.PROCESS_TYPE#,
								#evaluate('attributes.stock_id#rw_ind#')#,
								#evaluate('attributes.product_id#rw_ind#')#,
								#MAX_ID.IDENTITYCOL#,
								#evaluate('attributes.amount#rw_ind#')#,
								0,
								#attributes.department_id#,
								#attributes.location_id#,
								<cfif isdefined('attributes.shelf_id#rw_ind#') and len(evaluate('attributes.shelf_id#rw_ind#')) and isdefined('attributes.shelf_code#rw_ind#') and len(evaluate('attributes.shelf_code#rw_ind#'))>#evaluate('attributes.shelf_id#rw_ind#')#<cfelse>NULL</cfif>,
								#attributes.process_date#,
								<cfif len(evaluate('attributes.spec_main_name#rw_ind#')) and len(evaluate('attributes.spec_main_id#rw_ind#'))>#evaluate('attributes.spec_main_id#rw_ind#')#<cfelse>NULL</cfif>,
								<cfif len(evaluate('attributes.unit2_#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit2_#rw_ind#')#"><cfelse>NULL</cfif>,
								<cfif isdefined('attributes.lot_no#rw_ind#') and len(evaluate('attributes.lot_no#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#rw_ind#')#"><cfelse>NULL</cfif>
							)
					</cfquery>
					<cfquery name="add_exchange_stock" datasource="#dsn2#">
						INSERT INTO
						STOCKS_ROW
						
							(
								PROCESS_TYPE,
								STOCK_ID,
								PRODUCT_ID,
								UPD_ID,
								STOCK_IN,
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								SHELF_NUMBER,
								PROCESS_DATE,
								SPECT_VAR_ID,
								UNIT2,
								LOT_NO
							)
						VALUES
							(
								#GET_PROCESS_TYPE.PROCESS_TYPE#,
								#evaluate('attributes.exit_stock_id#rw_ind#')#,
								#evaluate('attributes.exit_product_id#rw_ind#')#,
								#MAX_ID.IDENTITYCOL#,
								0,
								#evaluate('attributes.exit_amount#rw_ind#')#,
								#attributes.exit_department_id#,
								#attributes.exit_location_id#,
								<cfif isdefined('attributes.exit_shelf_id#rw_ind#') and len(evaluate('attributes.exit_shelf_id#rw_ind#')) and isdefined('attributes.exit_shelf_code#rw_ind#') and len(evaluate('attributes.exit_shelf_code#rw_ind#'))>#evaluate('attributes.exit_shelf_id#rw_ind#')#<cfelse>NULL</cfif>,
								#attributes.process_date#,
								<cfif len(evaluate('attributes.exit_spec_main_name#rw_ind#')) and len(evaluate('attributes.exit_spec_main_id#rw_ind#'))>#evaluate('attributes.exit_spec_main_id#rw_ind#')#<cfelse>NULL</cfif>,
								<cfif len(evaluate('attributes.exit_unit2_#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.exit_unit2_#rw_ind#')#"><cfelse>NULL</cfif>,
								<cfif isdefined('attributes.exit_lot_no#rw_ind#') and len(evaluate('attributes.exit_lot_no#rw_ind#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.exit_lot_no#rw_ind#')#"><cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
                <!--- Burasi eklemede satir bazinda girilen serilerin belge numaralarini guncellemeyi sagliyor --->
                    <!--- GİRİŞ --->
                    <cfquery name="upd_serial" datasource="#dsn2#">
                        UPDATE
                            #dsn3_alias#.SERVICE_GUARANTY_NEW
                        SET
                            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            SPECT_ID =<cfif isdefined("spect_id#rw_ind#") and len(evaluate("spect_id#rw_ind#"))>#evaluate('spect_id#rw_ind#')#,<cfelse>NULL,</cfif>
                            PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.exchange_no#">,
                            PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">,
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                            DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">,
                            LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#">,
                            SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>
                        WHERE
                            WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#rw_ind#')#">
                            AND PROCESS_ID = 0
                    </cfquery>
                    <!--- ÇIKIŞ --->
                    <cfquery name="upd_serial2" datasource="#dsn2#">
                        UPDATE
                            #dsn3_alias#.SERVICE_GUARANTY_NEW
                        SET
                            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            SPECT_ID = <cfif isdefined("exit_spect_id#rw_ind#") and len(evaluate("exit_spect_id#rw_ind#"))>#evaluate('exit_spect_id#rw_ind#')#,<cfelse>NULL,</cfif>
                            PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.exchange_no#">,
                            PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">,
                            PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                            DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exit_department_id#">,
                            LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exit_location_id#">,
                            SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>
                        WHERE
                            WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.exit_wrk_row_id#rw_ind#')#">
                    </cfquery>
			</cfif>
		</cfloop>
		<cfscript>
			if (get_process_type.is_account eq 1) 
			{
				/* giris depo */
				if(len(attributes.location_id) and len(attributes.department_id)) 
				{	
					LOCATION_IN=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_id# AND SL.LOCATION_ID=#attributes.location_id#");
					location_type_in = LOCATION_IN.LOCATION_TYPE;
					branch_id_in = LOCATION_IN.BRANCH_ID;
					is_scrap_in = LOCATION_IN.IS_SCRAP;
				}
				else
				{
					location_type_in ='';	
					is_scrap_in='';
				}
				/* cikis depo */
				if( len(attributes.exit_location_id) and len(attributes.exit_department_id)) 
				{
					LOCATION_OUT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.exit_department_id# AND SL.LOCATION_ID=#attributes.exit_location_id#");
					location_type_out = LOCATION_OUT.LOCATION_TYPE;
					branch_id_out = LOCATION_OUT.BRANCH_ID;
					is_scrap_out = LOCATION_OUT.IS_SCRAP;
				}
				else
				{
					location_type_out ='';	
					is_scrap_out='';
				}	
				detail = 'Stok Virman Fişi';	
				if(isdefined("is_account_group") and is_account_group eq 1)
					detail = "#detail#" & iif(isDefined("attributes.detail") and Len(attributes.detail),de("-#attributes.detail#"),de(""));
			}
		</cfscript>
		<cfif get_process_type.is_account eq 1>
			<cfinclude template="stock_exchange_account_process.cfm">
		</cfif>
		<cfscript>
			if (get_process_type.is_account eq 1) 
			{
				muhasebeci(
					action_id : MAX_ID.IDENTITYCOL,
					workcube_process_type : get_process_type.process_type,
					workcube_process_cat : attributes.process_cat,
					account_card_type : 13,
					islem_tarihi : attributes.process_date,
					borc_hesaplar : str_borclu_hesaplar,
					borc_tutarlar : borc_alacak_tutarlar,
					other_amount_borc : borc_alacak_dovizli_tutarlar,
					other_currency_borc : borc_alacak_doviz_currency,
					alacak_hesaplar : str_alacakli_hesaplar,
					alacak_tutarlar : borc_alacak_tutarlar,
					other_amount_alacak : borc_alacak_dovizli_tutarlar,
					other_currency_alacak : borc_alacak_doviz_currency,
					from_branch_id : branch_id_out,
					to_branch_id : branch_id_in,
					fis_detay : detail,
					fis_satir_detay : detail,
					belge_no : attributes.exchange_no,
					is_account_group : get_process_type.is_account_group,
					currency_multiplier : currency_multiplier
				);		
			}
		</cfscript>
	</cftransaction>
</cflock>
<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
	UPDATE 
		GENERAL_PAPERS
	SET
		STOCK_FIS_NUMBER = #system_paper_no_fis_add#
	WHERE
		STOCK_FIS_NUMBER IS NOT NULL
</cfquery>
<!--- maliyet --->
<cfset attributes.actionId = MAX_ID.IDENTITYCOL >
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1>
	<cfscript>cost_action(action_type:7,action_id:MAX_ID.IDENTITYCOL,query_type:2);</cfscript>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.form_add_stock_exchange&event=upd&exchange_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.form_add_stock_exchange&event=upd&exchange_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
	</script>
</cfif>

