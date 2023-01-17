<!--- 
stok hareketlerini yapan function, spec-karmakoli-ürün ağacı çözümüne göre
M.ER 20080718
Özden 20091006
--->
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
    <cffunction name="add_stock_rows" returntype="string" output="false">
        <cfargument name="sr_dsn_type" type="string" default="#dsn2#">
        <cfargument name="sr_process_type" type="boolean" default="">
		<cfargument name="sr_main_process_type" default=""><!--- faturanın kendi irsaliyesi stok hareketi olustururken bu argumana fatura process_type gonderılır, sr_process_type a ise faturanın olusturdgu irsaliyenin process_type ı gonderilir --->
		<cfargument name="sr_control_process_type" type="string" default=""><!---belgenin iade işlem tiplerini tutar. Alım iadelerde spec-ağaç çözümü YAPILMAZ, satıs iadelerde ise spec-ağaç çözümü YAPILIR --->
        <cfargument name="sr_stock_row_count" type="numeric"><!---toplu stok hareketi yapabilmk için kulanılabilir,irsaliye ekleme sayfalarndaki stok hareketi kısmında kullanılmaz--->
        <cfargument name="sr_max_id" type="numeric" default=""><!--- stocks_row daki UPD_ID yani stok hareketinin ilgili oldugu action_id--->
        <cfargument name="sr_department_id" type="numeric" default="">
        <cfargument name="sr_location_id" type="string" default="">
        <cfargument name="sr_process_date" type="string" default="">
        <cfargument name="sr_is_purchase_sales" type="boolean" default="1"><!--- 0 Alış 1 Satış --->
        <cfargument name="sr_product_id_list" type="string" default="">
        <cfargument name="sr_stock_id_list" type="string" default="">
        <cfargument name="sr_unit_list" type="string" default="">
        <cfargument name="sr_amount_list" type="string" default="">
        <cfargument name="sr_spec_id_list" type="string" default="">
        <cfargument name="sr_spec_main_id_list" type="string" default="">
        <cfargument name="sr_lot_no_list" type="string" default="">
        <cfargument name="sr_shelf_number_list" type="string" default="">
        <cfargument name="sr_manufact_code_list" type="string" default="">
        <cfargument name="sr_amount_other_list" type="string" default="">
        <cfargument name="sr_unit_other_list" type="string" default="">
        <cfargument name="sr_deliver_date_list" type="string" default="">
        <cfargument name="sr_paper_row_id_list" type="string" default="">
        <cfargument name="sr_width_list" type="string" default="">
        <cfargument name="sr_depth_list" type="string" default="">
        <cfargument name="sr_height_list" type="string" default="">
        <cfargument name="sr_wrk_row_id_list" type="string" default="">
        <cfargument name="sr_row_department_id" type="string" default=""><!--- satırdaki teslim depo bilgisi --->
        <cfargument name="sr_row_location_id" type="string" default=""><!--- satırdaki teslim deponun lokasyon bilgisi --->
		 <!--- grup içi işlemden yeni spect oluşturmak için eklendi PY 102015 --->
		<cfargument name="is_company_related_action" default="0">
		<cfargument name="company_related_dsn" default="#new_dsn3#">
		
		<cfset arguments.sr_process_date_time = arguments.sr_process_date>
        <cfset arguments.sr_process_date = createdate(year(arguments.sr_process_date),month(arguments.sr_process_date),day(arguments.sr_process_date))>
	
        
        <cfif arguments.is_company_related_action>
            <cfset new_dsn3 = arguments.company_related_dsn>
        <cfelse>
        	<cfset new_dsn3 = dsn3>
        </cfif>

		<cfif not len(arguments.sr_main_process_type)>
			<cfset arguments.sr_main_process_type = arguments.sr_process_type>
		</cfif>
		<cfif arguments.sr_is_purchase_sales eq 1><!--- Satış ise  STOCK_ROW'DA STOCK_OUT tablosuna yazılacak alış ise STOCK_IN alanına yazılır!--->
			<cfset stock_in_out = 'STOCK_OUT'>
		<cfelseif arguments.sr_is_purchase_sales eq 0 >
			<cfset stock_in_out = 'STOCK_IN'>
		</cfif>
        <cfquery name="GET_KARMA_PRODUCTS" datasource="#arguments.sr_dsn_type#"><!--- karma koli olan ürünler --->
            SELECT PRODUCT_ID FROM #new_dsn3#.PRODUCT WHERE PRODUCT_ID IN (#arguments.sr_product_id_list#) AND IS_KARMA = 1
        </cfquery>
        <cfset karma_product_list = valuelist(GET_KARMA_PRODUCTS.PRODUCT_ID)>
        <cfquery name="GET_PROD_PRODUCTS" datasource="#arguments.sr_dsn_type#"><!--- üretilen ürünler --->
            SELECT STOCK_ID FROM #new_dsn3#.STOCKS WHERE STOCK_ID IN (#arguments.sr_stock_id_list#) AND IS_PRODUCTION=1
        </cfquery>
        <cfset prod_product_list = valuelist(GET_PROD_PRODUCTS.STOCK_ID)>
		<cfloop from="1" to="#arguments.sr_stock_row_count#" index="src_ind">
			<cfif isdefined('arguments.sr_deliver_date_list') and ListGetAt(arguments.sr_deliver_date_list,src_ind,',') gt 0>
				<cfset row_deliver_date=ListGetAt(arguments.sr_deliver_date_list,src_ind,',')>
			<cfelse>
				<cfset row_deliver_date='NULL'>
			</cfif>
			<!--- varsa satırdaki teslim depo bilgisi yoksa belgenin depo bilgisi stok hareketine yazılıyor--->
			<cfset row_dept_id=arguments.sr_department_id>
			<cfset row_loc_id=arguments.sr_location_id>
			<!--- TESLIM DEPOYA GORE STOCK KONTROLU YAPILDIGINDA ACILACAK, SIMDILIK KAPATILDI OZDEN20091116
			<cfif isdefined('arguments.sr_row_department_id') and listlen(arguments.sr_row_department_id) gte  src_ind and ListGetAt(arguments.sr_row_department_id,src_ind,',') gt 0>
				<cfset row_dept_id=ListGetAt(arguments.sr_row_department_id,src_ind,',')>
			<cfelse>
				<cfset row_dept_id=arguments.sr_department_id>
			</cfif>
			<cfif isdefined('arguments.sr_row_location_id') and listlen(arguments.sr_row_location_id) gte  src_ind and ListGetAt(arguments.sr_row_location_id,src_ind,',') gt 0>
				<cfset row_loc_id=ListGetAt(arguments.sr_row_location_id,src_ind,',')>
			<cfelse>
				<cfset row_loc_id=arguments.sr_location_id>
			</cfif> --->
			<cfquery name="GET_UNIT" datasource="#arguments.sr_dsn_type#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					#new_dsn3#.PRODUCT_UNIT 
				WHERE 
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.sr_product_id_list,src_ind,',')#"> AND
					ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(arguments.sr_unit_list,src_ind,',')#"> AND
					PRODUCT_UNIT_STATUS = 1
			</cfquery>
			<cfif get_unit.recordcount and len(get_unit.multiplier) >
				<cfset multi=get_unit.multiplier*ListGetAt(arguments.sr_amount_list,src_ind,',')>
			<cfelse>
				<cfset multi=ListGetAt(arguments.sr_amount_list,src_ind,',')>
			</cfif>
			<cfif not (isdefined("karma_product_list") and ListFind(karma_product_list,ListGetAt(arguments.sr_product_id_list,src_ind,',')))>
				<!--- satırdaki ürün karma koli olmadığı sürece kendisine hareket yapar,
				bir ürün hem karma koli olup hem spect seçilme gibi durumlarda yanlış çalıştıgı düşünülmesin,business gereği olamaz,
				ürüne bağlı spec,karma koli,ürün ağacı tanımlamalarından sadece biri yapılmalıdır...AE20060621--->
				
				<!--- shelf number ve  PRODUCT_MANUFACT_CODE spect ve urun agacı için sadece ana ürüne eklenir,
				karmakoli ise karmakoliyi olusturan tum urunlere eklenir. OZDEN20060818--->
				<cfif isdefined('arguments.sr_spec_id_list') and ListGetAt(arguments.sr_spec_id_list,src_ind,',') gt 0>
					<cfquery name="GET_SPEC_MAIN" datasource="#arguments.sr_dsn_type#">
						SELECT SPECT_MAIN_ID FROM #new_dsn3#.SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.sr_spec_id_list,src_ind,',')#">
					</cfquery>
				</cfif>
				<cfquery name="ADD_STOCK_ROW" datasource="#arguments.sr_dsn_type#"><!--- satırlardaki ana ürünler için stok hareketleri--->
					INSERT INTO 
						STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
                            ROW_ID,
                            WRK_ROW_ID,
							PROCESS_TYPE,
							#stock_in_out#,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE,
							PROCESS_TIME,
							SPECT_VAR_ID,
							LOT_NO,
							DELIVER_DATE,
							SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE,
							AMOUNT2,
							UNIT2,
							DEPTH_VALUE,
							WIDTH_VALUE,
							HEIGHT_VALUE
						)
						VALUES
						(
							#arguments.sr_max_id#,
							#ListGetAt(arguments.sr_product_id_list,src_ind,',')#,
							#ListGetAt(arguments.sr_stock_id_list,src_ind,',')#,
							<cfif isdefined('arguments.sr_paper_row_id_list') and len(arguments.sr_paper_row_id_list)>#ListGetAt(arguments.sr_paper_row_id_list,src_ind,',')#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_wrk_row_id_list') and len(arguments.sr_wrk_row_id_list)>'#ListGetAt(arguments.sr_wrk_row_id_list,src_ind,',')#'<cfelse>NULL</cfif>,
							#arguments.sr_process_type#,
							#multi#,
							#row_dept_id#,
							#row_loc_id#,
							#arguments.sr_process_date#,
							#arguments.sr_process_date_time#,
							<cfif isdefined('arguments.sr_spec_id_list') and len(ListGetAt(arguments.sr_spec_id_list,src_ind,',')) and  ListGetAt(arguments.sr_spec_id_list,src_ind,',') gt 0 and len(GET_SPEC_MAIN.SPECT_MAIN_ID)>#GET_SPEC_MAIN.SPECT_MAIN_ID#,<cfelse>NULL,</cfif>
							<cfif isdefined('arguments.sr_lot_no_list') and len(ListGetAt(arguments.sr_lot_no_list,src_ind,',')) and ListGetAt(arguments.sr_lot_no_list,src_ind,',') neq 0>'#ListGetAt(arguments.sr_lot_no_list,src_ind,',')#'<cfelse>NULL</cfif>,
							#row_deliver_date#,
							<cfif isdefined('arguments.sr_shelf_number_list') and len(ListGetAt(arguments.sr_shelf_number_list,src_ind,',')) and ListGetAt(arguments.sr_shelf_number_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_shelf_number_list,src_ind,',')#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_manufact_code_list') and len(ListGetAt(arguments.sr_manufact_code_list,src_ind,',')) and ListGetAt(arguments.sr_manufact_code_list,src_ind,',') neq 0>'#ListGetAt(arguments.sr_manufact_code_list,src_ind,',')#'<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_amount_other_list') and len(ListGetAt(arguments.sr_amount_other_list,src_ind,',')) and ListGetAt(arguments.sr_amount_other_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_amount_other_list,src_ind,',')#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_unit_other_list') and ListGetAt(arguments.sr_unit_other_list,src_ind,',') gt 0>'#ListGetAt(arguments.sr_unit_other_list,src_ind,',')#'<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_width_list') and (listlen(arguments.sr_width_list) gte src_ind) and len(ListGetAt(arguments.sr_width_list,src_ind,',')) and ListGetAt(arguments.sr_width_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_width_list,src_ind,',')#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_depth_list') and (listlen(arguments.sr_width_list) gte src_ind) and len(ListGetAt(arguments.sr_depth_list,src_ind,',')) and ListGetAt(arguments.sr_depth_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_depth_list,src_ind,',')#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.sr_height_list') and (listlen(arguments.sr_width_list) gte src_ind) and len(ListGetAt(arguments.sr_height_list,src_ind,',')) and ListGetAt(arguments.sr_height_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_height_list,src_ind,',')#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>
			<!--- satırdaki ürünlerin spec-ürünağacı-karmakoli çözümleri --->
				<cfif len(karma_product_list) and ListFind(karma_product_list,ListGetAt(arguments.sr_product_id_list,src_ind,','))><!--- karma koliyse --->
					<cfquery name="GET_KARMA_PRODUCT" datasource="#arguments.sr_dsn_type#">
						SELECT PRODUCT_ID,STOCK_ID,SPEC_MAIN_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.sr_product_id_list,src_ind,',')#">
					</cfquery>
					<cfif GET_KARMA_PRODUCT.recordcount>
						<cfloop query="GET_KARMA_PRODUCT">
							<cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)><!--- karma koli satırındaki urun için spec seçilmisse, hem o ürün hem de sevkte birleştirilen urunleri için stok hareketi yazılır --->
								<cfquery name="GET_SPEC_PRODUCT" datasource="#arguments.sr_dsn_type#">
									SELECT 
										PRODUCT_ID,
										STOCK_ID,
										AMOUNT,
										RELATED_MAIN_SPECT_ID
									FROM
										#new_dsn3#.SPECT_MAIN_ROW
									WHERE
										IS_SEVK = 1 AND
										STOCK_ID IS NOT NULL AND
										PRODUCT_ID IS NOT NULL AND
										SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCT.SPEC_MAIN_ID#">
								</cfquery>
								<cfif GET_SPEC_PRODUCT.recordcount>
									<cfloop query="GET_SPEC_PRODUCT">
										<cfquery name="ADD_STOCK_ROW" datasource="#arguments.sr_dsn_type#">
											INSERT INTO
												STOCKS_ROW
											(
												UPD_ID,
												PRODUCT_ID,
												STOCK_ID,
												ROW_ID,
												WRK_ROW_ID,
												SPECT_VAR_ID,
												PROCESS_TYPE,
												#stock_in_out#,
												STORE,
												STORE_LOCATION,
												DELIVER_DATE,
												SHELF_NUMBER,
												PROCESS_DATE,
												PROCESS_TIME
											)
											VALUES
											(
												#arguments.sr_max_id#,
												#GET_SPEC_PRODUCT.product_id#,
												#GET_SPEC_PRODUCT.stock_id#,
												<cfif isdefined('arguments.sr_paper_row_id_list') and len(arguments.sr_paper_row_id_list)>#ListGetAt(arguments.sr_paper_row_id_list,src_ind,',')#<cfelse>NULL</cfif>,
												<cfif isdefined('arguments.sr_wrk_row_id_list') and len(arguments.sr_wrk_row_id_list)>'#ListGetAt(arguments.sr_wrk_row_id_list,src_ind,',')#'<cfelse>NULL</cfif>,
												<cfif len(GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID) and GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID gt 0>#GET_SPEC_PRODUCT.RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
												#arguments.sr_process_type#,
												#multi*GET_SPEC_PRODUCT.AMOUNT#,
												#row_dept_id#,
												#row_loc_id#,                                
												#row_deliver_date#,
												<cfif isdefined('arguments.sr_shelf_number_list') and len(ListGetAt(arguments.sr_shelf_number_list,src_ind,','))and ListGetAt(arguments.sr_shelf_number_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_shelf_number_list,src_ind,',')#<cfelse>NULL</cfif>,
												#arguments.sr_process_date#,
												#arguments.sr_process_date_time#
											)
										</cfquery>
									</cfloop>
								</cfif>
							</cfif>
							<cfquery name="ADD_STOCK_ROW" datasource="#arguments.sr_dsn_type#">
								INSERT INTO
									STOCKS_ROW
								(
									UPD_ID,
									PRODUCT_ID,
									STOCK_ID,
									SPECT_VAR_ID,
                                    ROW_ID,
                                    WRK_ROW_ID,
									PROCESS_TYPE,
									#stock_in_out#,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE,
									PROCESS_TIME,
									DELIVER_DATE,
									SHELF_NUMBER,
									PRODUCT_MANUFACT_CODE
								)
								VALUES
								(
									#arguments.sr_max_id#,
									#GET_KARMA_PRODUCT.product_id#,
									#GET_KARMA_PRODUCT.stock_id#,
									<cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>NULL</cfif>,
									<cfif isdefined('arguments.sr_paper_row_id_list') and len(arguments.sr_paper_row_id_list)>#ListGetAt(arguments.sr_paper_row_id_list,src_ind,',')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.sr_wrk_row_id_list') and len(arguments.sr_wrk_row_id_list)>'#ListGetAt(arguments.sr_wrk_row_id_list,src_ind,',')#'<cfelse>NULL</cfif>,
									#arguments.sr_process_type#,
									#multi*GET_KARMA_PRODUCT.product_amount#,
									#row_dept_id#,
									#row_loc_id#,
									#arguments.sr_process_date#,
									#arguments.sr_process_date_time#,
									#row_deliver_date#,
									<cfif isdefined('arguments.sr_shelf_number_list') and len(ListGetAt(arguments.sr_shelf_number_list,src_ind,',')) and ListGetAt(arguments.sr_shelf_number_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_shelf_number_list,src_ind,',')#<cfelse>NULL</cfif>,						
									<cfif isdefined('arguments.sr_manufact_code_list') and len(ListGetAt(arguments.sr_manufact_code_list,src_ind,',')) and ListGetAt(arguments.sr_manufact_code_list,src_ind,',') neq 0>'#ListGetAt(arguments.sr_manufact_code_list,src_ind,',')#'<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfloop>
					</cfif>
				<cfelseif isdefined('arguments.sr_spec_id_list') and ListGetAt(arguments.sr_spec_id_list,src_ind,',') gt 0><!--- spectse --->
					<cfquery name="GET_SPEC_PRODUCT" datasource="#arguments.sr_dsn_type#">
						SELECT 
							PRODUCT_ID,
							STOCK_ID,
							AMOUNT_VALUE,
							RELATED_SPECT_ID
						FROM
							#new_dsn3#.SPECTS_ROW
						WHERE
							IS_SEVK = 1 AND<!--- sevkte birleştir--->
							STOCK_ID IS NOT NULL AND
							PRODUCT_ID IS NOT NULL AND
							SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.sr_spec_id_list,src_ind,',')#">
					</cfquery>
					<cfif GET_SPEC_PRODUCT.recordcount>
						<cfloop query="GET_SPEC_PRODUCT">
							<cfquery name="ADD_STOCK_ROW" datasource="#arguments.sr_dsn_type#">
								INSERT INTO
									STOCKS_ROW
								(
									UPD_ID,
									PRODUCT_ID,
									STOCK_ID,
                                    ROW_ID,
                                    WRK_ROW_ID,
									SPECT_VAR_ID,
									PROCESS_TYPE,
									#stock_in_out#,
									STORE,
									STORE_LOCATION,
									DELIVER_DATE,
									SHELF_NUMBER,
									PROCESS_DATE,
									PROCESS_TIME
								)
								VALUES
								(
									#arguments.sr_max_id#,
									#GET_SPEC_PRODUCT.product_id#,
									#GET_SPEC_PRODUCT.stock_id#,
									<cfif isdefined('arguments.sr_paper_row_id_list') and len(arguments.sr_paper_row_id_list)>#ListGetAt(arguments.sr_paper_row_id_list,src_ind,',')#<cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.sr_wrk_row_id_list') and len(arguments.sr_wrk_row_id_list)>'#ListGetAt(arguments.sr_wrk_row_id_list,src_ind,',')#'<cfelse>NULL</cfif>,
									<cfif len(GET_SPEC_PRODUCT.RELATED_SPECT_ID) and GET_SPEC_PRODUCT.RELATED_SPECT_ID gt 0>#GET_SPEC_PRODUCT.RELATED_SPECT_ID#<cfelse>NULL</cfif>,
									#arguments.sr_process_type#,
									#multi*GET_SPEC_PRODUCT.AMOUNT_VALUE#,
									#row_dept_id#,
									#row_loc_id#,                                
									#row_deliver_date#,
									<cfif isdefined('arguments.sr_shelf_number_list') and len(ListGetAt(arguments.sr_shelf_number_list,src_ind,','))and ListGetAt(arguments.sr_shelf_number_list,src_ind,',') neq 0>#ListGetAt(arguments.sr_shelf_number_list,src_ind,',')#<cfelse>NULL</cfif>,
									#arguments.sr_process_date#,
									#arguments.sr_process_date_time#
								)
							</cfquery>
						</cfloop>
					</cfif>
				<cfelseif len(prod_product_list) and ListFind(prod_product_list,ListGetAt(arguments.sr_stock_id_list,src_ind,','))><!--- üretilen ürünse --->
					<cfquery name="GET_PROD_PRODUCT" datasource="#arguments.sr_dsn_type#">
						SELECT
							S.STOCK_ID,
							S.PRODUCT_ID,
							PT.AMOUNT
						FROM
							#new_dsn3#.PRODUCT_TREE PT,
							#new_dsn3#.STOCKS S
						WHERE
							PT.RELATED_ID = S.STOCK_ID AND
							PT.IS_SEVK = 1 AND<!--- sevkte birleştir--->
							PT.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(arguments.sr_stock_id_list,src_ind,',')#">
					</cfquery>
					<cfif GET_PROD_PRODUCT.recordcount>
						<cfloop query="GET_PROD_PRODUCT">
							<cfquery name="ADD_STOCK_ROW" datasource="#arguments.sr_dsn_type#">
								INSERT INTO
									STOCKS_ROW
								(
									UPD_ID,
									PRODUCT_ID,
									STOCK_ID,
                                    ROW_ID,
                                    WRK_ROW_ID,
									SPECT_VAR_ID,
									PROCESS_TYPE,
									#stock_in_out#,
									STORE,
									STORE_LOCATION,
									DELIVER_DATE,
									SHELF_NUMBER,
									PROCESS_DATE,
									PROCESS_TIME
								)
								VALUES
								(
									#arguments.sr_max_id#,
									#GET_PROD_PRODUCT.PRODUCT_ID#,
									#GET_PROD_PRODUCT.STOCK_ID#,
									<cfif len(GET_PROD_PRODUCT.SPECT_MAIN_ID) and GET_PROD_PRODUCT.SPECT_MAIN_ID gt 0>#GET_PROD_PRODUCT.SPECT_MAIN_ID#<cfelse>NULL</cfif>,
									#arguments.sr_process_type#,
									#multi*GET_PROD_PRODUCT.AMOUNT#,
									#row_dept_id#,
									#row_loc_id#,
									#row_deliver_date#,
									<cfif isdefined('arguments.sr_shelf_number_list') and len(ListGetAt(arguments.sr_shelf_number_list,src_ind,',')) and ListGetAt(arguments.sr_shelf_number_list,src_ind,',') neq 0 >#ListGetAt(arguments.sr_shelf_number_list,src_ind,',')#<cfelse>NULL</cfif>,
									#arguments.sr_process_date#,
									#arguments.sr_process_date_time#
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
		</cfloop>
    </cffunction>
</cfprocessingdirective>
