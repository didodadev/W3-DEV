<cfsetting requesttimeout="3000"><!--- time out ayarlı ise coldfusionda time outa düşmemesi için sayfanın bu kontrol koyuldu TolgaS--->
<cfsetting showdebugoutput="no">
<!--- 
Yazan: Aysenur20070207
...
düzenleme: TolgaS 20071224 düzenlendi fişler 100 erli satırlar halinde kesildi spec düzenlemeleri eklendi 
maliyet için düzenlemeye gerek yok çünkü daha öne maliyet kullanıyorsa tekrar devir fişlerine yazarak kaydetmenin bir anlamı yok 
zaten maliyetini önceki dönemdende bularak mevcut stokla maliyet işlemleri yapılıyor.
devir sırasında spec raf ve soın kullanma tarihini alarak yapıyor
discountlarda hesaba katılmadı zaten devir fişlerinde bir anlamı yok
 --->
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfif not isdefined("attributes.hedef_period")>
<cfsavecontent variable = "title">
	<cf_get_lang dictionary_id='44065.Stok Aktarımı'>
</cfsavecontent>
<div class="col col-12 col-xs-12">
<cf_box title="#title#">
		<form name="form_" method="post"action="">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			    <div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='44064.Stokları Devret'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
					<input type="checkbox" name="is_transfer" id="is_transfer" value="1" <cfif isdefined("attributes.is_transfer") and attributes.is_transfer> checked</cfif>>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='43767.Kaynak Dönem'></label>
				<div class="col col-3 col-md-3 col-xs-12">	
					<select name="from_cmp" id="from_cmp" onchange="show_periods_departments(1)">
						<cfoutput query="get_companies">
						<option value="#comp_id#" <cfif isdefined("attributes.from_cmp") and attributes.from_cmp eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
					</cfoutput>
				</select>
		    </div>
			<div id="source_div" class="col col-5 col-md-5 col-xs-12">	
				<select name="kaynak_period_1" id="kaynak_period_1" style="width:220px;" >
					<cfif isdefined("attributes.from_cmp") and len(attributes.from_cmp)>
						<cfquery name="get_periods" datasource="#dsn#">
							SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #attributes.from_cmp# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
						</cfquery>
						<cfoutput query="get_periods">				
							<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period#</option>						
						</cfoutput>
					</cfif>
				</select>
			</div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='43260.Hedef Dönem'></label>
				<div class="col col-3 col-md-3 col-xs-12">	
					<select name="to_cmp" id="to_cmp" onchange="show_periods_departments(2)">
						<cfoutput query="get_companies">
							<option value="#comp_id#" <cfif isdefined("attributes.to_cmp") and attributes.to_cmp eq comp_id>selected<cfelseif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
						</cfoutput>
					</select>
		    </div>
			<div id="target_div" class="col col-5 col-md-5 col-xs-12">	
				<select name="hedef_period_1" id="hedef_period_1" style="width:220px;">
					<cfif isdefined("attributes.to_cmp") and len(attributes.to_cmp)>
						<cfoutput query="get_periods">				
							<option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>						
						</cfoutput>
					</cfif>
				</select>
		    </div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='44063.Spec Aktar'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
					<input type="checkbox" name="is_spec" id="is_spec" value="1" <cfif isdefined("attributes.is_spec") and attributes.is_spec>checked</cfif>>
		    </div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='44062.Raf Aktar'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
				<input type="checkbox" name="is_shelf" id="is_shelf" value="1" <cfif isdefined("attributes.is_shelf") and attributes.is_shelf>checked</cfif>>
		    </div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='43137.Lot No Aktar'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
					<input type="checkbox" name="is_lot_no" id="is_lot_no" value="1" <cfif isdefined("attributes.is_lot_no") and attributes.is_lot_no>checked</cfif>>
		    </div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='44061.Son Kullanma Tarihi Aktar'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
				<input type="checkbox" name="is_deliver_date" id="is_deliver_date" value="1" <cfif isdefined("attributes.is_deliver_date") and attributes.is_deliver_date>checked</cfif>>
		    </div>
	        </div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='44060.Yapılmış Aktarımları Sil'></label>
				<div class="col col-8 col-md-8 col-xs-12">	
				<input type="checkbox" name="is_transfer_delete" id="is_transfer_delete" value="1" <cfif isdefined("attributes.is_transfer_delete") and attributes.is_transfer_delete>checked</cfif>>
		    </div>
	        </div>
		</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<h3><cf_get_lang dictionary_id='57433.Yardım'></h3>
			<cfset getImportExpFormat("stocktransfer") />
		</div>
	</cf_box_elements>
<cf_box_footer>	
	<br/><br/><br/>
	<input type="button" value="<cf_get_lang dictionary_id ='58676.Aktar'>" onClick="basamak_1();">
</cf_box_footer>
</form>
</cf_box>
</div>
</cfif>
<cfif isdefined("attributes.hedef_period_1") and isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='44058.Hedef Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif not len(attributes.kaynak_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='44047.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="GET_HEDEF_PERIOD" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hedef_period_1#">
	</cfquery>
	
	<cfquery name="GET_KAYNAK_PERIOD" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period_1#">
	</cfquery>
	<form action="" name="form1_" method="post">
		<input type="hidden" name="aktarim_hedef_period" id="aktarim_hedef_period" value="<cfoutput>#attributes.hedef_period_1#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_year" id="aktarim_hedef_year" value="<cfoutput>#get_hedef_period.period_year#</cfoutput>">
		<input type="hidden" name="aktarim_hedef_company" id="aktarim_hedef_company" value="<cfoutput>#get_hedef_period.our_company_id#</cfoutput>">
        <input type="hidden" name="aktarim_hedef_start_date" id="aktarim_hedef_start_date" value="<cfoutput>#get_hedef_period.start_date#</cfoutput>">
		<cfif isdefined("attributes.is_transfer")>
			<input type="hidden" name="aktarim_is_transfer" id="aktarim_is_transfer" value="1">
		</cfif>
		<cfif isdefined("attributes.is_spec")>
			<input type="hidden" name="aktarim_spec" id="aktarim_spec" value="1">
		</cfif>
		<cfif isdefined("attributes.is_shelf")>
			<input type="hidden" name="aktarim_shelf_number" id="aktarim_shelf_number" value="1">
		</cfif>
		<cfif isdefined("attributes.is_deliver_date")>
			<input type="hidden" name="aktarim_deliver_date" id="aktarim_deliver_date" value="1">
		</cfif>
		<cfif isdefined("attributes.is_lot_no")>
			<input type="hidden" name="is_lot_no" id="is_lot_no" value="1">
		</cfif>
		<cfif isdefined("attributes.is_transfer_delete")>
			<input type="hidden" name="aktarim_is_transfer_delete" id="aktarim_is_transfer_delete" value="1">
		</cfif>
		<cf_get_lang dictionary_id ='44011.Kaynak Veri Tabanı'>: <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput><br/>
		<cf_get_lang dictionary_id ='44012.Hedef Veri Tabanı'> : <cfoutput>#get_hedef_period.period# (#get_hedef_period.period_year#)</cfoutput><br/>
		<input type="button" value="<cf_get_lang dictionary_id ='44010.Aktarımı Başlat'>" onClick="basamak_2();">
	</form>
</cfif>	
<cfif isdefined("attributes.aktarim_hedef_period")>
	<cfset hedef_dsn2 = '#dsn#_#attributes.aktarim_hedef_year#_#attributes.aktarim_hedef_company#'>
	<cfset hedef_dsn3 = '#dsn#_#attributes.aktarim_hedef_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset stock_fis_id_list=''>
	<cfset attributes.process_date = createodbcdatetime(attributes.aktarim_hedef_start_date)>
    
<!--- DEVİRLER SİLİNECEK İSE --->
	<cfif isdefined('attributes.aktarim_is_transfer_delete') and len(attributes.aktarim_is_transfer_delete)>
		<cfquery name="DEL_TRANSFER_1" datasource="#hedef_dsn2#">
			DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID IN (SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE = 114 AND FIS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#" list="yes"> AND IS_STOCK_TRANSFER = 1)
		</cfquery>
		<cfquery name="DEL_TRANSFER_2" datasource="#hedef_dsn2#">
			DELETE FROM STOCK_FIS_ROW WHERE FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE = 114 AND FIS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#" list="yes"> AND IS_STOCK_TRANSFER = 1)
		</cfquery>
		<cfquery name="DEL_TRANSFER_3" datasource="#hedef_dsn2#">
			DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE = 114 AND UPD_ID IN (SELECT FIS_ID FROM STOCK_FIS WHERE FIS_TYPE = 114 AND FIS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#"> AND IS_STOCK_TRANSFER = 1)
		</cfquery>
		<cfquery name="DEL_TRANSFER_4" datasource="#hedef_dsn2#">
			DELETE FROM STOCK_FIS WHERE FIS_TYPE = 114 AND FIS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date#"> AND IS_STOCK_TRANSFER = 1
		</cfquery>
	</cfif>
<!--- DEVİRLER SİLİNECEK İSE --->
<!--- devir yapılacak ise baslıyor--->
	<cfif isdefined('attributes.aktarim_is_transfer') and len(attributes.aktarim_is_transfer)>
		<cfquery name="GET_PROCESS_TYPE" datasource="#hedef_dsn3#"><!--- devir fişi --->
			SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 114 AND PROCESS_MODULE = 50
		</cfquery>
		<cfif get_process_type.recordcount eq 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='44057.Pos modülüne ait devir fişi işlem kategorisi kaydedilmemiş'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
		<cfquery name="GET_MONEY_FIS" datasource="#hedef_dsn2#">
			SELECT * FROM SETUP_MONEY
		</cfquery>
	
		<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
			SELECT 
				SL.DEPARTMENT_LOCATION,
				D.DEPARTMENT_ID,
				SL.LOCATION_ID
			FROM 
				DEPARTMENT D,
				BRANCH B,
				STOCKS_LOCATION SL
			WHERE 
				D.IS_STORE <> 2 AND
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_hedef_company#"> AND
				B.BRANCH_ID = D.BRANCH_ID AND
				D.DEPARTMENT_ID = SL.DEPARTMENT_ID
			ORDER BY
				D.DEPARTMENT_HEAD,
				SL.COMMENT
		</cfquery>
		<cfif len(session.ep.money2)>
			<cfset is_selected_money = session.ep.money2>
		<cfelse>
			<cfset is_selected_money = session.ep.money>
		</cfif>
		<cfoutput query="get_departments">
			<cfset dep_id = get_departments.department_id>
			<cfset loc_id = get_departments.location_id>
			<cfquery name="AKTARIM_KONTROL" datasource="#hedef_dsn2#">
				SELECT * FROM STOCK_FIS WHERE IS_STOCK_TRANSFER = 1 AND DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#dep_id#"> AND LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_id#"> AND FIS_TYPE = 114
			</cfquery>
			<cfif not AKTARIM_KONTROL.recordcount>
				<cfquery name="ROW_CONTROL" datasource="#kaynak_dsn2#">
					SELECT
						S.PRODUCT_ID,
						S.STOCK_ID,
						SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_STOCK,
					<cfif isdefined('attributes.aktarim_spec')>
                        SR.SPECT_VAR_ID,
                    <cfelse>
                        NULL SPECT_VAR_ID,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_shelf_number')>
                        SR.SHELF_NUMBER,
                    <cfelse>
                        NULL SHELF_NUMBER,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_deliver_date')>
                        SR.DELIVER_DATE,
                    <cfelse>
                        NULL DELIVER_DATE,
                    </cfif>
                    <cfif isdefined('attributes.is_lot_no')>
                        SR.LOT_NO,
                    <cfelse>
                        NULL LOT_NO,
                    </cfif>
						PU.ADD_UNIT,
						PU.MAIN_UNIT,
						PU.PRODUCT_UNIT_ID,
						PS.PRICE,
						PS.MONEY,
						P.TAX_PURCHASE,
						ISNULL(SUM(SR.AMOUNT2),0) AMOUNT2
					FROM
						#dsn3_alias#.STOCKS S,
						#dsn3_alias#.PRODUCT P,
						#dsn3_alias#.PRODUCT_UNIT PU,
						#kaynak_dsn2#.STOCKS_ROW SR,
						#dsn3_alias#.PRICE_STANDART AS PS
					WHERE
						PS.PURCHASESALES = 0 AND
						PS.PRICESTANDART_STATUS = 1 AND
						PS.PRODUCT_ID = P.PRODUCT_ID AND
						PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
						P.PRODUCT_ID = S.PRODUCT_ID AND
						PU.IS_MAIN = 1 AND
						SR.STOCK_ID = S.STOCK_ID AND
						S.PRODUCT_ID = PU.PRODUCT_ID AND
						SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#dep_id#"> AND
						SR.STORE_lOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_id#">
					GROUP BY
						S.PRODUCT_ID,
						S.STOCK_ID,
					<cfif isdefined('attributes.aktarim_spec')>
                   		SR.SPECT_VAR_ID,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_shelf_number')>
                    	SR.SHELF_NUMBER,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_deliver_date')>
                        SR.DELIVER_DATE,
                    </cfif>
					<cfif isdefined('attributes.is_lot_no')>
                        SR.LOT_NO,
                    </cfif>
						PU.ADD_UNIT,
						PU.MAIN_UNIT,
						PU.PRODUCT_UNIT_ID,
						PS.PRICE,
						PS.MONEY,
						P.TAX_PURCHASE
					HAVING
						ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) > 0
					UNION
                    
					SELECT
						S.PRODUCT_ID,
						S.STOCK_ID,
						SUM(SR.STOCK_IN - SR.STOCK_OUT) PRODUCT_STOCK,
					<cfif isdefined('attributes.aktarim_spec')>
                        SR.SPECT_VAR_ID,
                    <cfelse>
                        NULL SPECT_VAR_ID,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_shelf_number')>
                        SR.SHELF_NUMBER,
                    <cfelse>
                        NULL SHELF_NUMBER,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_deliver_date')>
                        SR.DELIVER_DATE,
                    <cfelse>
                        NULL DELIVER_DATE,
                    </cfif>
                    <cfif isdefined('attributes.is_lot_no')>
                        SR.LOT_NO,
                    <cfelse>
                        '' LOT_NO,
                    </cfif>
						PU.ADD_UNIT,
						PU.MAIN_UNIT,
						PU.PRODUCT_UNIT_ID,
						0 PRICE,
						'TL' AS MONEY,
						P.TAX_PURCHASE,
						ISNULL(SUM(SR.AMOUNT2),0) AMOUNT2
					FROM
						#dsn3_alias#.STOCKS S,
						#dsn3_alias#.PRODUCT P,
						#dsn3_alias#.PRODUCT_UNIT PU,
						#kaynak_dsn2#.STOCKS_ROW SR
					WHERE
						P.PRODUCT_ID NOT IN(SELECT PS.PRODUCT_ID FROM #dsn3_alias#.PRICE_STANDART AS PS WHERE PS.PURCHASESALES = 0 AND PS.PRICESTANDART_STATUS = 1 AND PS.PRODUCT_ID = P.PRODUCT_ID AND PS.UNIT_ID = PU.PRODUCT_UNIT_ID) AND
						P.PRODUCT_ID = S.PRODUCT_ID AND
						PU.IS_MAIN = 1 AND
						SR.STOCK_ID = S.STOCK_ID AND
						S.PRODUCT_ID = PU.PRODUCT_ID AND
						SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#dep_id#"> AND
						SR.STORE_lOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_id#">
					GROUP BY
						S.PRODUCT_ID,
						S.STOCK_ID,
					<cfif isdefined('attributes.aktarim_spec')>
                        SR.SPECT_VAR_ID,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_shelf_number')>
                        SR.SHELF_NUMBER,
                    </cfif>
                    <cfif isdefined('attributes.aktarim_deliver_date')>
                        SR.DELIVER_DATE,
                    </cfif>
					<cfif isdefined('attributes.is_lot_no')>
                        SR.LOT_NO,
                    </cfif>
						PU.ADD_UNIT,
						PU.MAIN_UNIT,
						PU.PRODUCT_UNIT_ID,
						P.TAX_PURCHASE	
					HAVING
						ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),2) > 0
				</cfquery>
				<cfif row_control.recordcount>
					<cflock name="#CREATEUUID()#" timeout="70">
						<cftransaction>
						<cfset query_currentrow = 1>
						<cfloop query="row_control">
							<cfset temp_prod_id=row_control.product_id[query_currentrow]>
							<cfset temp_stock_id=row_control.stock_id[query_currentrow]>
							<cfset temp_prod_stock=row_control.product_stock[query_currentrow]>
							<cfif query_currentrow mod 100 eq 0 or query_currentrow eq 1>
								<!---<cf_papers paper_type="STOCK_FIS"> transaction içinde olduğundan calismıyordu--->
								<cfquery name="get_gen_paper" datasource="#hedef_dsn2#">
									SELECT
										*
									FROM
										#dsn#_#attributes.aktarim_kaynak_company#.GENERAL_PAPERS GENERAL_PAPERS
									WHERE 
										GENERAL_PAPERS.PAPER_TYPE IS NULL 
								</cfquery>
								<cfset paper_code = evaluate('get_gen_paper.stock_fis_no')>
								<cfset paper_number = evaluate('get_gen_paper.stock_fis_number') +1>
								<cfset system_paper_no = paper_code & '-' & paper_number>
								<cfset system_paper_no_add = paper_number>
								<cfset attributes.fis_no = system_paper_no>
								<cfquery name="ADD_STOCK_FIS" datasource="#hedef_dsn2#" result="MAX_ID">
									INSERT INTO
										STOCK_FIS
                                    (
                                        IS_STOCK_TRANSFER,
                                        FIS_TYPE,
                                        PROCESS_CAT,
                                        FIS_NUMBER,
                                        DEPARTMENT_IN,
                                        LOCATION_IN,
                                        EMPLOYEE_ID,
                                        FIS_DATE,
                                        RECORD_EMP,
                                        RECORD_DATE,
                                        RECORD_IP
                                    )
                                    VALUES
                                    (
                                        1,
                                        114,<!--- Devir Fisi --->
                                        #get_process_type.process_cat_id#,
                                        '#attributes.fis_no#',
                                        #dep_id#,
                                        #loc_id#,
                                        #session.ep.userid#,
                                        #attributes.process_date#,
                                        #session.ep.userid#,
                                        #now()#,
                                        '#cgi.remote_addr#'
                                    )
								</cfquery>
								<cfset stock_fis_id_list=listappend(stock_fis_id_list,MAX_ID.IDENTITYCOL,',')>
								<cfloop query="get_money_fis"><!--- fis_money_kayitlari --->
									<cfquery name="ADD_FIS_MONEY" datasource="#hedef_dsn2#">
										INSERT INTO
											STOCK_FIS_MONEY
                                        (
                                            ACTION_ID,
                                            MONEY_TYPE,
                                            RATE2,
                                            RATE1,
                                            IS_SELECTED
                                        )
                                        VALUES
                                        (
                                            #MAX_ID.IDENTITYCOL#,
                                            '#get_money_fis.money#',
                                            #get_money_fis.rate2#,
                                            #get_money_fis.rate1#,
                                            <cfif get_money_fis.money eq is_selected_money>1<cfelse>0</cfif>
                                        )
									</cfquery>
								</cfloop>
							</cfif>
							<cfscript>
								spec='';
								if(len(ROW_CONTROL.SPECT_VAR_ID[query_currentrow]))
								{
									spec=specer(
										dsn_type:hedef_dsn2,
										spec_type:session.ep.our_company_info.spect_type,
										main_spec_id:ROW_CONTROL.SPECT_VAR_ID[query_currentrow],
										add_to_main_spec:1
									);
								}
								cost_price=#ROW_CONTROL.PRICE[query_currentrow]#;
								extra_cost_price=0;
							</cfscript>
							<cfquery name="INSERT_STOCK_FIS_ROW" datasource="#hedef_dsn2#">
								INSERT INTO 
                                	STOCK_FIS_ROW
								(
									FIS_ID,
									FIS_NUMBER,
									STOCK_ID,
									AMOUNT,
									UNIT,
									UNIT_ID,							
									PRICE,
									OTHER_MONEY,
									TAX,
									DISCOUNT1,
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,				
									TOTAL,
									TOTAL_TAX,
									NET_TOTAL,
									SPECT_VAR_ID,
									SPECT_VAR_NAME,
									SHELF_NUMBER,
									DELIVER_DATE,
									COST_PRICE,
									EXTRA_COST,
                                    LOT_NO
								)
								VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									'#attributes.fis_no#',
									#temp_stock_id#,
									#temp_prod_stock#,
									'#ROW_CONTROL.ADD_UNIT[query_currentrow]#',
									#ROW_CONTROL.PRODUCT_UNIT_ID[query_currentrow]#,
									#ROW_CONTROL.PRICE[query_currentrow]#,
									'#ROW_CONTROL.MONEY[query_currentrow]#',
									#ROW_CONTROL.TAX_PURCHASE[query_currentrow]#,
									0,
									0,
									0,
									0,
									0,
									#(ROW_CONTROL.PRICE[query_currentrow]*temp_prod_stock)#,
									#(((ROW_CONTROL.PRICE[query_currentrow]*temp_prod_stock) * ROW_CONTROL.TAX_PURCHASE[query_currentrow])/100)#,
									#(ROW_CONTROL.PRICE[query_currentrow]*temp_prod_stock)#,
								<cfif isdefined('spec') and listlen(spec,',')>
                                    #listgetat(spec,2,',')#,
                                    '#listgetat(spec,3,',')#',
                                <cfelse>
                                    NULL,
                                    NULL,
                                </cfif>
									<cfif len(ROW_CONTROL.SHELF_NUMBER[query_currentrow])>#ROW_CONTROL.SHELF_NUMBER[query_currentrow]#<cfelse>NULL</cfif>,
									<cfif len(ROW_CONTROL.DELIVER_DATE[query_currentrow])>#createodbcdatetime(ROW_CONTROL.DELIVER_DATE[query_currentrow])#<cfelse>NULL</cfif>,
									#cost_price#,
									#extra_cost_price#,
                                    <cfif len(ROW_CONTROL.LOT_NO[query_currentrow])>'#ROW_CONTROL.LOT_NO[query_currentrow]#'<cfelse>NULL</cfif>
								)
							</cfquery>
							<cfquery name="INSERT_STOCK_ROW" datasource="#hedef_dsn2#">
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
									SPECT_VAR_ID,
									SHELF_NUMBER,
									DELIVER_DATE,
                                    LOT_NO,
									AMOUNT2
								)
								VALUES
								(
									#MAX_ID.IDENTITYCOL#,
									#temp_prod_id#,
									#temp_stock_id#,
									114,
									#temp_prod_stock#,
									#dep_id#,
									#loc_id#,
									#attributes.process_date#,
									<cfif isdefined('spec') and listlen(spec,',')>#listgetat(spec,1,',')#<cfelse>NULL</cfif>,
									<cfif len(ROW_CONTROL.SHELF_NUMBER[query_currentrow])>#ROW_CONTROL.SHELF_NUMBER[query_currentrow]#<cfelse>NULL</cfif>,
									<cfif len(ROW_CONTROL.DELIVER_DATE[query_currentrow])>#createodbcdatetime(ROW_CONTROL.DELIVER_DATE[query_currentrow])#<cfelse>NULL</cfif>,
                                    <cfif len(ROW_CONTROL.LOT_NO[query_currentrow])>'#ROW_CONTROL.LOT_NO[query_currentrow]#'<cfelse>NULL</cfif>,
									<cfif len(ROW_CONTROL.AMOUNT2[query_currentrow])>'#ROW_CONTROL.AMOUNT2[query_currentrow]#'<cfelse>NULL</cfif>
								)
							</cfquery>
							<cfset query_currentrow = query_currentrow+1>
							<cfif query_currentrow mod 100 eq 0 or query_currentrow eq row_control.recordcount+1>
								<cfquery name="UPD_GEN_PAP" datasource="#hedef_dsn2#">
									UPDATE 
										#dsn3_alias#.GENERAL_PAPERS
									SET
										STOCK_FIS_NUMBER = #system_paper_no_add#
									WHERE
										STOCK_FIS_NUMBER IS NOT NULL
								</cfquery>
							</cfif>
						</cfloop>
						</cftransaction>
					</cflock>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='44003.İşlem Başarıyla Tamamlanmıştır'>!");
	</script>
</cfif>
<script type="text/javascript">
	function basamak_1()
	{
		if(confirm("<cf_get_lang dictionary_id ='44066.Stok Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form_.submit();
		else 
			return false;
	}
	function basamak_2()
	{
		if(confirm("<cf_get_lang dictionary_id ='44066.Stok Aktarım İşlemi Yapacaksınız !!!Bu İşlem Geri Alınamaz!!! Emin misiniz'>?"))
			document.form1_.submit();
		else 
			return false;
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.from_cmp") and len(attributes.from_cmp))>
			var company_id = document.getElementById('from_cmp').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
		</cfif>
		}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('from_cmp').value != '')
			{
				var company_id = document.getElementById('from_cmp').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'kaynak_period_1',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('to_cmp').value != '')
			{
				var company_id = document.getElementById('to_cmp').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
		<cfif NOT (isdefined("attributes.to_cmp") and len(attributes.to_cmp))>
			var company_id = document.getElementById('to_cmp').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'hedef_period_1',1,'Dönemler');
		</cfif>
		}
	)
</script>