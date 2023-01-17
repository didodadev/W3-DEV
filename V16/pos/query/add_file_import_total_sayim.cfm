<cfquery name="GET_MONEY_FIS" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
</cfquery>
<cfset sayim_fisi=false>
<cfset fire_fisi=false>
<cfif isdefined("attributes.file_import_total") and len(attributes.file_import_total)>
	<cfquery name="get_fileimports_total" datasource="#DSN2#">
		SELECT 
			PROCESS_DATE,
			STOCK_AMOUNT,
			FILE_AMOUNT,
			DEPARTMENT_ID,
			DEPARTMENT_LOCATION,
			STOCK_ID,
			PRODUCT_ID,
			SPECT_MAIN_ID,
			SHELF_NUMBER,
			DELIVER_DATE,
            LOT_NO,
			(FILE_AMOUNT-STOCK_AMOUNT) AS FARK
		FROM
			FILE_IMPORTS_TOTAL
		WHERE 
			FIS_ID IS NULL AND
			FILE_IMPORTS_TOTAL_ID IN (#attributes.file_import_total#)
	</cfquery>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY,	
			STOCKS.TAX_PURCHASE,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.PRODUCT_UNIT_ID
		FROM
			STOCKS,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE
			PRODUCT_UNIT.IS_MAIN = 1 AND
			STOCKS.STOCK_ID IN (#valuelist(get_fileimports_total.STOCK_ID)#) AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
			PRICE_STANDART.PURCHASESALES = 0
		ORDER BY
			STOCKS.STOCK_ID
	</cfquery>
	<cfif get_fileimports_total.recordcount>
		<cfloop query="get_fileimports_total">
			<cfif FARK gt 0>
				<cfset sayim_fisi=true>
			<cfelseif FARK lt 0>
				<cfset fire_fisi=true>
			</cfif>
		</cfloop>
		<cfset fis_tarihi=CreateODBCDateTime(get_fileimports_total.PROCESS_DATE)>
	</cfif>
	 
<cfif sayim_fisi or fire_fisi>
	<cf_papers paper_type="STOCK_FIS">
	<cfset system_paper_no=paper_code & '-' & paper_number>
	<cfset system_paper_no_add = paper_number>
	<cflock timeout="60">
		<cftransaction>
		<!--- sayim fisi ekleniyor --->
			<cfif sayim_fisi>
				<cfif isdefined("is_total_fis")>
					<cfset all_loop_count = all_loop_count + 1>
				</cfif>
				<cfquery name="ADD_STOCK_FIS" datasource="#dsn2#">
					INSERT INTO
					STOCK_FIS
					(
						FIS_TYPE,
						PROCESS_CAT,
						FIS_NUMBER,
						FIS_DATE,
						EMPLOYEE_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP,
						DEPARTMENT_IN,
						LOCATION_IN
					)
					VALUES
					(
						115,
						#attributes.process_cat1#,
						'#system_paper_no#',
						#fis_tarihi#,				
						#session.ep.userid#,
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#',
						#get_fileimports_total.DEPARTMENT_ID#,
						#get_fileimports_total.DEPARTMENT_LOCATION#
					)
				</cfquery>
				<cfquery name="GET_ID" datasource="#dsn2#">
					SELECT MAX(FIS_ID) AS MAX_ID FROM STOCK_FIS
				</cfquery>
				<cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
					<cfquery name="ADD_FIS_MONEY" datasource="#dsn2#">
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
								#GET_ID.MAX_ID#,
								'#GET_MONEY_FIS.MONEY#',
								#GET_MONEY_FIS.RATE2#,
								#GET_MONEY_FIS.RATE1#,
								<cfif GET_MONEY_FIS.MONEY eq session.ep.money2>1<cfelse>0</cfif>
							)
					</cfquery>
				</cfoutput>
				<cfquery name="get_sayim_stok_info" dbtype="query">
					SELECT 
						get_fileimports_total.*,
						get_product.*
					FROM
						get_fileimports_total,
						get_product
					WHERE
						get_fileimports_total.PRODUCT_ID=get_product.PRODUCT_ID AND
						get_fileimports_total.STOCK_ID=get_product.STOCK_ID AND
						get_fileimports_total.FARK > 0
				</cfquery>
				<cfoutput query="get_sayim_stok_info">
					<cfscript>
						fis_miktarı=abs(get_sayim_stok_info.FARK);
						satir_toplam = fis_miktarı * get_sayim_stok_info.price;
						satir_toplam_net = fis_miktarı * get_sayim_stok_info.price;
						kdv_toplam = (satir_toplam_net *get_sayim_stok_info.tax_purchase)/100;
						
						spec='';
						if(len(get_sayim_stok_info.SPECT_MAIN_ID))
						{
							spec=specer(
								dsn_type:dsn2,
								spec_type:session.ep.our_company_info.spect_type,
								main_spec_id:get_sayim_stok_info.SPECT_MAIN_ID,
								add_to_main_spec:1
							);
						}
					</cfscript>
					<cfquery name="add_stock_row" datasource="#DSN2#">
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
                            LOT_NO
						)
						VALUES
						(
							#get_id.max_id#,
							'#system_paper_no#',							
							#get_sayim_stok_info.stock_id#,
							#fis_miktarı#,
							'#get_sayim_stok_info.add_unit#',
							#get_sayim_stok_info.product_unit_id#,							
							#get_sayim_stok_info.price#,
							'#get_sayim_stok_info.money#',
							#get_sayim_stok_info.tax_purchase#,
							0,
							0,
							0,
							0,
							0,
							#satir_toplam#,
							#kdv_toplam#,
							#satir_toplam_net#,
							<cfif listlen(spec,',')>
								#listgetat(spec,2,',')#,
								'#listgetat(spec,3,',')#'
							<cfelse>
								NULL,
								NULL
							</cfif>,
							<cfif len(get_sayim_stok_info.SHELF_NUMBER)>#get_sayim_stok_info.SHELF_NUMBER#<cfelse>NULL</cfif>,
							<cfif len(get_sayim_stok_info.DELIVER_DATE)>#createodbcdatetime(get_sayim_stok_info.DELIVER_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(get_sayim_stok_info.LOT_NO)>'#get_sayim_stok_info.LOT_NO#'<cfelse>NULL</cfif>
						)
					</cfquery>		
					<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
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
                            LOT_NO
						)
						VALUES
						(
							#get_id.max_id#,
							#get_sayim_stok_info.product_id#,
							#get_sayim_stok_info.stock_id#,
							115,
							#fis_miktarı#,
							#get_fileimports_total.DEPARTMENT_ID#,
							#get_fileimports_total.DEPARTMENT_LOCATION#,
							#fis_tarihi#,
							<cfif listlen(spec,',')>#listgetat(spec,1,',')#<cfelse>NULL</cfif>,
							<cfif len(get_sayim_stok_info.SHELF_NUMBER)>#get_sayim_stok_info.SHELF_NUMBER#<cfelse>NULL</cfif>,
							<cfif len(get_sayim_stok_info.DELIVER_DATE)>#createodbcdatetime(get_sayim_stok_info.DELIVER_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(get_sayim_stok_info.LOT_NO)>'#get_sayim_stok_info.LOT_NO#'<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfoutput>
				<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
					UPDATE 
						#dsn3_alias#.GENERAL_PAPERS
					SET
						STOCK_FIS_NUMBER=#system_paper_no_add#
					WHERE
						STOCK_FIS_NUMBER IS NOT NULL
				</cfquery>		
				<cfquery name="UPD_FILE_IMPORTS_TOTAL" datasource="#dsn2#">
					UPDATE
						FILE_IMPORTS_TOTAL
					SET
						FIS_ID=#GET_ID.MAX_ID#,
						FIS_PROCESS_TYPE=115
					WHERE
						<!--- STOCK_ID IN (#sayim_stok_id#)--->
						(FILE_AMOUNT-STOCK_AMOUNT) > 0 AND
						FILE_IMPORTS_TOTAL_ID IN (#attributes.file_import_total#) AND
						DEPARTMENT_ID=#get_fileimports_total.DEPARTMENT_ID# AND
						DEPARTMENT_LOCATION=#get_fileimports_total.DEPARTMENT_LOCATION# AND
						PROCESS_DATE=#fis_tarihi#
				</cfquery>
			</cfif>
			<!--- fire fisi ekleniyor --->
			<cfif fire_fisi>
				<cfif sayim_fisi>
					<cfset system_paper_number = paper_number + 1>
				<cfelse>
					<cfset system_paper_number = paper_number>
				</cfif>
				<cfset system_paper_no=paper_code & '-' & system_paper_number>
				<cfif isdefined("is_total_fis")>
					<cfset all_loop_count = all_loop_count + 1>
				</cfif>
				<cfquery name="ADD_STOCK_FIRE_FIS" datasource="#dsn2#">
					INSERT INTO
					STOCK_FIS
					(
						FIS_TYPE,
						PROCESS_CAT,
						FIS_NUMBER,
						FIS_DATE,
						EMPLOYEE_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP,
						DEPARTMENT_OUT,
						LOCATION_OUT
					)
					VALUES
					(
						112,
						#attributes.process_cat2#,
						'#system_paper_no#',
						#fis_tarihi#,
						#session.ep.userid#,
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#',
						#get_fileimports_total.DEPARTMENT_ID#,
						#get_fileimports_total.DEPARTMENT_LOCATION#
					)
				</cfquery>
				<cfquery name="GET_ID" datasource="#dsn2#">
					SELECT MAX(FIS_ID) AS MAX_ID FROM STOCK_FIS
				</cfquery> 
				<cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
					<cfquery name="ADD_FIS_MONEY" datasource="#dsn2#">
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
								#GET_ID.MAX_ID#,
								'#GET_MONEY_FIS.MONEY#',
								#GET_MONEY_FIS.RATE2#,
								#GET_MONEY_FIS.RATE1#,
								<cfif GET_MONEY_FIS.MONEY eq session.ep.money2>1<cfelse>0</cfif>
							)
					</cfquery>
				</cfoutput>
				<cfquery name="get_fire_stok_info" dbtype="query">
					SELECT 
						get_fileimports_total.*,
						get_product.*
					FROM
						get_fileimports_total,
						get_product
					WHERE
						get_fileimports_total.PRODUCT_ID=get_product.PRODUCT_ID AND
						get_fileimports_total.STOCK_ID=get_product.STOCK_ID AND
						get_fileimports_total.FARK < 0
				</cfquery>
				<cfoutput query="get_fire_stok_info">
					<cfscript>
						fire_fis_miktarı=abs(get_fire_stok_info.FARK);
						satir_toplam = fire_fis_miktarı * get_fire_stok_info.price;
						satir_toplam_net = fire_fis_miktarı * get_fire_stok_info.price;
						kdv_toplam = (satir_toplam_net *get_fire_stok_info.tax_purchase)/100;
						
						spec_sarf='';
						if(len(get_fire_stok_info.SPECT_MAIN_ID))
						{
							spec_sarf=specer(
									dsn_type:dsn2,
									spec_type:session.ep.our_company_info.spect_type,
									main_spec_id:get_fire_stok_info.SPECT_MAIN_ID,
									add_to_main_spec:1
								);
						}
					</cfscript>
					<cfquery name="add_stock_row" datasource="#DSN2#">
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
                            LOT_NO
						)
						VALUES
						(
							#get_id.max_id#,
							'#system_paper_no#',							
							#get_fire_stok_info.stock_id#,
							#fire_fis_miktarı#,
							'#get_fire_stok_info.add_unit#',
							#get_fire_stok_info.product_unit_id#,							
							#get_fire_stok_info.price#,
							'#get_fire_stok_info.money#',
							#get_fire_stok_info.tax_purchase#,
							0,
							0,
							0,
							0,
							0,
							#satir_toplam#,
							#kdv_toplam#,
							#satir_toplam_net#,
							<cfif listlen(spec_sarf,',')>
								#listgetat(spec_sarf,2,',')#,
								'#listgetat(spec_sarf,3,',')#'
							<cfelse>
								NULL,
								NULL
							</cfif>,
							<cfif len(get_fire_stok_info.SHELF_NUMBER)>#get_fire_stok_info.SHELF_NUMBER#<cfelse>NULL</cfif>,
							<cfif len(get_fire_stok_info.DELIVER_DATE)>#createodbcdatetime(get_fire_stok_info.DELIVER_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(get_fire_stok_info.LOT_NO)>'#get_fire_stok_info.LOT_NO#'<cfelse>NULL</cfif>
						)
					</cfquery>		
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
							SPECT_VAR_ID,
							SHELF_NUMBER,
							DELIVER_DATE,
                            LOT_NO
						)
						VALUES
						(
							#get_id.max_id#,
							#get_fire_stok_info.product_id#,
							#get_fire_stok_info.stock_id#,
							112,
							#fire_fis_miktarı#,
							#get_fileimports_total.DEPARTMENT_ID#,
							#get_fileimports_total.DEPARTMENT_LOCATION#,		
							#fis_tarihi#,
							<cfif listlen(spec_sarf,',')>#listgetat(spec_sarf,1,',')#<cfelse>NULL</cfif>,
							<cfif len(get_fire_stok_info.SHELF_NUMBER)>#get_fire_stok_info.SHELF_NUMBER#<cfelse>NULL</cfif>,
							<cfif len(get_fire_stok_info.DELIVER_DATE)>#createodbcdatetime(get_fire_stok_info.DELIVER_DATE)#<cfelse>NULL</cfif>,
                            <cfif len(get_fire_stok_info.LOT_NO)>'#get_fire_stok_info.LOT_NO#'<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfoutput>
				<cfquery name="UPD_GEN_PAP" datasource="#DSN2#">
					UPDATE 
						#dsn3_alias#.GENERAL_PAPERS
					SET
						STOCK_FIS_NUMBER=#system_paper_no_add+1#
					WHERE
						STOCK_FIS_NUMBER IS NOT NULL
				</cfquery>		
				<cfquery name="UPD_FILE_IMPORTS_TOTAL" datasource="#dsn2#">
					UPDATE
						FILE_IMPORTS_TOTAL
					SET
						FIS_ID=#GET_ID.MAX_ID#,
						FIS_PROCESS_TYPE=112
					WHERE
						(FILE_AMOUNT-STOCK_AMOUNT) < 0 AND
						FILE_IMPORTS_TOTAL_ID IN (#attributes.file_import_total#) AND
						DEPARTMENT_ID=#get_fileimports_total.DEPARTMENT_ID# AND
						DEPARTMENT_LOCATION=#get_fileimports_total.DEPARTMENT_LOCATION# AND
						PROCESS_DATE=#fis_tarihi#
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
 </cfif> 
 <cfif not isdefined("is_total_fis")>
 	<cf_date tarih="attributes.islem_tarihi">
 	<cfquery name="get_fileimports_total_last" datasource="#DSN2#">
		SELECT 
			FIT.FILE_IMPORTS_TOTAL_ID,
			FIT.PROCESS_DATE,
			FIT.STOCK_AMOUNT,
			FIT.FILE_AMOUNT,
			FIT.SPECT_MAIN_ID,
			FIT.SHELF_NUMBER,
			FIT.DELIVER_DATE,
            FIT.LOT_NO,
			S.PRODUCT_NAME,
			S.PROPERTY
		FROM
			FILE_IMPORTS_TOTAL FIT,
			#dsn3_alias#.STOCKS S
		WHERE 
			FIT.FIS_ID IS NULL AND
			S.STOCK_ID = FIT.STOCK_ID AND
			FIT.DEPARTMENT_ID =  <cfqueryparam value="#get_fileimports_total.department_id#" cfsqltype="cf_sql_integer"> AND
			FIT.DEPARTMENT_LOCATION = <cfqueryparam value="#get_fileimports_total.DEPARTMENT_LOCATION#" cfsqltype="cf_sql_integer"> AND
			FIT.PROCESS_DATE =  <cfqueryparam value="#attributes.islem_tarihi#" cfsqltype="cf_sql_timestamp"> AND
			(FIT.FILE_AMOUNT-FIT.STOCK_AMOUNT) <> 0
		ORDER BY
			(FIT.FILE_AMOUNT-FIT.STOCK_AMOUNT)  DESC
	</cfquery>
	<script type="text/javascript">
		alert("<cf_get_lang no ='141.Fiş Ekleme Başarıyla Tamamlandı'>!");
		<cfif get_fileimports_total_last.recordcount>
			alert('Diğer Kayıtlar İçin Lütfen Devam Ediniz!');
		</cfif>
		window.location.href = "<cfoutput>#request.self#?fuseaction=pos.list_fileimports_total&is_submitted=1&department_id=#get_fileimports_total.DEPARTMENT_ID#&location_id=#get_fileimports_total.DEPARTMENT_LOCATION#&start_date=#dateformat(attributes.islem_tarihi,dateformat_style)#</cfoutput>";
	</script>
 </cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='142.Seçim Yapmadınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
