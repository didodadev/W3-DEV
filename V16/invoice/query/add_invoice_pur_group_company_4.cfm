<cfif listfind('54,55,59',invoice_cat,',')><!--- stok işlemi yapılabilir bir fatura ise --->
	<cfif (not included_irs) and (inventory_product_exists eq 1)><!---fatura kendi irsaliyesini oluşturuyor --->
		<cfquery name="ADD_PURCHASE" datasource="#new_dsn2#" result="MAX_ID">
			INSERT INTO
				SHIP
				(
				PAYMETHOD_ID,
				PURCHASE_SALES,
				SHIP_NUMBER,
				SHIP_TYPE,
			<cfif not included_irs>
				SHIP_METHOD,
			</cfif>
				SHIP_DATE,
				DELIVER_DATE,
				COMPANY_ID,
				DELIVER_EMP,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				DEPARTMENT_IN,
				LOCATION_IN,
				RECORD_DATE,
				RECORD_EMP,
				IS_WITH_SHIP
				)
			VALUES
				(
				#get_invoice.PAYMETHOD_ID#,
				0,
				'#get_invoice.INVOICE_NUMBER#',
				76,
			<cfif not included_irs>
				<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
			</cfif>
				#attributes.invoice_date#,
				#attributes.invoice_date#,
				#attributes.company_id#,
				'#LEFT(TRIM(DELIVER_GET_ID),50)#',
				0,<!--- get_invoice.basket_discount_total --->
				#get_invoice.NETTOTAL#,
				#get_invoice.GROSSTOTAL#,
				#get_invoice.TAXTOTAL#,
				#attributes.department_id#,
				#attributes.location_id#,
				#now()#,
				#SESSION.EP.USERID#,
				1
				)
		</cfquery>
		<cfoutput query="get_invoice_row">
			<cfquery name="get_inve" dbtype="query">
				SELECT * FROM get_prod_in WHERE PRODUCT_ID=#PRODUCT_ID#
			</cfquery>
			<cfif get_inve.IS_INVENTORY eq 1><!--- envantere dahil ürün satırı ise --->
				<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#">
					INSERT INTO SHIP_ROW
						(
							NAME_PRODUCT,
							SHIP_ID,
							STOCK_ID,
							PRODUCT_ID,
							AMOUNT,
							UNIT,
							UNIT_ID,					
							TAX,
							PRICE,
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
							SPECT_VAR_ID,
							SPECT_VAR_NAME,
							LOT_NO,
							PRICE_OTHER,
							IS_PROMOTION,
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
							WIDTH_VALUE,
							DEPTH_VALUE,
							HEIGHT_VALUE,
							ROW_PROJECT_ID
						)
					VALUES
						(
							'#NAME_PRODUCT#',
							#MAX_ID.IDENTITYCOL#,
							#STOCK_ID#,
							#PRODUCT_ID#,
							#AMOUNT#,
							'#UNIT#',
							#UNIT_ID#,
							#TAX#,
							#PRICE#,
							0,
							<cfif len(DISCOUNT1)>#DISCOUNT1#<cfelse>0</cfif>,
							<cfif len(DISCOUNT2)>#DISCOUNT2#<cfelse>0</cfif>,
							<cfif len(DISCOUNT3)>#DISCOUNT3#<cfelse>0</cfif>,
							<cfif len(DISCOUNT4)>#DISCOUNT4#<cfelse>0</cfif>,
							<cfif len(DISCOUNT5)>#DISCOUNT5#<cfelse>0</cfif>,
							<cfif len(DISCOUNT6)>#DISCOUNT6#<cfelse>0</cfif>,
							<cfif len(DISCOUNT7)>#DISCOUNT7#<cfelse>0</cfif>,
							<cfif len(DISCOUNT8)>#DISCOUNT8#<cfelse>0</cfif>,
							<cfif len(DISCOUNT9)>#DISCOUNT9#<cfelse>0</cfif>,
							<cfif len(DISCOUNT10)>#DISCOUNT10#<cfelse>0</cfif>,
							<cfif len(DISCOUNTTOTAL)>#DISCOUNTTOTAL#<cfelse>0</cfif>,
							<cfif len(GROSSTOTAL)>#GROSSTOTAL#<cfelse>0</cfif>,
							<cfif len(NETTOTAL)>#NETTOTAL#<cfelse>0</cfif>,
							<cfif len(TAXTOTAL)>#TAXTOTAL#<cfelse>0</cfif>,
							#attributes.invoice_date#,
							#attributes.department_id#,
							#attributes.location_id#,
							<cfif len(SPEC_VAR_ID)>#SPEC_VAR_ID#,<cfelse>0,</cfif>
							'#SPEC_VAR_NAME#',
							'#LOT_NO#',
							#PRICE_OTHER#,
							0,
							<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
						)
				</cfquery>
				<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
					<cfquery name="GET_UNIT" datasource="#new_dsn2#">
						SELECT 
							ADD_UNIT,
							MULTIPLIER,
							MAIN_UNIT,
							PRODUCT_UNIT_ID
						FROM
							#new_dsn3_alias#.PRODUCT_UNIT 
						WHERE
							PRODUCT_ID = #PRODUCT_ID# AND
							ADD_UNIT = '#UNIT#'
					</cfquery>
					<cfif (get_unit.recordcount) and len(get_unit.multiplier)>
						<cfset multi = get_unit.multiplier * AMOUNT>
					<cfelse>
						<cfset multi = AMOUNT>
					</cfif>
					<cfquery name="ADD_STOCK_ROW" datasource="#new_dsn2#">
						INSERT INTO STOCKS_ROW
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
								LOT_NO,
								SHELF_NUMBER,
								PRODUCT_MANUFACT_CODE
							)
						VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								#PRODUCT_ID#,
								#STOCK_ID#,
								76,
								#multi#,
								#attributes.department_id#,
								#attributes.location_id#,
								#attributes.invoice_date#,
							<cfif len(SPEC_VAR_ID)>#SPEC_VAR_ID#<cfelse>NULL</cfif>,
								'#LOT_NO#',
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
