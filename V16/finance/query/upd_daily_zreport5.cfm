<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
	DELETE FROM STOCKS_ROW WHERE UPD_ID = #form.invoice_id# AND PROCESS_TYPE = 69
</cfquery>
<cfif (inventory_product_exists eq 1)>
	<!--- karma koli icin eklendi --->
	<cfif isdefined("karma_product_list") and len(karma_product_list)>
		<cfquery name="CHECK_KARMA_PRODUCTS" datasource="#dsn2#">
			SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID IN (#karma_product_list#) AND IS_KARMA=1
		</cfquery>
		<cfif CHECK_KARMA_PRODUCTS.recordcount>
			<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#">
				SELECT 
					S.STOCK_ID,
					KP.PRODUCT_ID,
					KP.PRODUCT_AMOUNT,
					KP.KARMA_PRODUCT_ID
				FROM 
					#dsn1_alias#.KARMA_PRODUCTS KP,
					#dsn1_alias#.PRODUCT P,
					#dsn1_alias#.STOCKS S
				WHERE  
					P.PRODUCT_ID = KP.PRODUCT_ID AND 
					S.PRODUCT_ID = KP.PRODUCT_ID AND
					S.STOCK_ID = KP.STOCK_ID AND
					KP.KARMA_PRODUCT_ID IN (#valuelist(CHECK_KARMA_PRODUCTS.PRODUCT_ID,",")#)
			</cfquery>
		</cfif>
	</cfif>
	<!--- //karma koli icin eklendi--->
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfif evaluate('attributes.is_inventory#i#') eq 1><!--- envantere dahil ürün satırı ise --->
			<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
				<cfquery name="GET_UNIT" datasource="#dsn2#">
					SELECT 
						ADD_UNIT,
						MULTIPLIER,
						MAIN_UNIT,
						PRODUCT_UNIT_ID
					FROM
						#dsn3_alias#.PRODUCT_UNIT 
					WHERE
						PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND
						ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval("attributes.unit#i#")#">
				</cfquery>
				<cfif get_unit.recordcount and len(get_unit.multiplier)>
					<cfset multi = get_unit.multiplier*evaluate("attributes.amount#i#")>
				<cfelse>
					<cfset multi = evaluate("attributes.amount#i#")>
				</cfif>
				<!---  specli bir satirsa main_spec id yazilacak stok row a --->
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
				<!--- karma koli icin eklendi --->
				<cfif isdefined("karma_product_list") and len(karma_product_list) and (CHECK_KARMA_PRODUCTS.recordcount)>
					<cfquery name="GET_KARMA_PRODUCT" dbtype="query">
						SELECT 
							STOCK_ID,
							PRODUCT_ID,
							PRODUCT_AMOUNT
						FROM
							GET_KARMA_PRODUCTS
						WHERE  
							KARMA_PRODUCT_ID = #evaluate("attributes.product_id#i#")#
					</cfquery>
				<cfelse>
					<cfset GET_KARMA_PRODUCT.recordcount=0>
				</cfif>
				<cfif GET_KARMA_PRODUCT.recordcount>
					<cfloop query="GET_KARMA_PRODUCT">
						<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
							INSERT INTO STOCKS_ROW
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
								LOT_NO,
								DELIVER_DATE,
								SHELF_NUMBER,
								PRODUCT_MANUFACT_CODE
								)
							VALUES
								(
								#form.invoice_id#,
								#GET_KARMA_PRODUCT.product_id#,
								#GET_KARMA_PRODUCT.stock_id#,
								69,
								#multi*GET_KARMA_PRODUCT.product_amount#,
								#attributes.department_id#,
								#attributes.location_id#,
								#attributes.invoice_date#,
								<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>#evaluate("attributes.spect_id#i#")#<cfelse>NULL</cfif>, --->
								<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.lot_no#i#")#'><cfelse>NULL</cfif>,
								<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
								<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
								)
						</cfquery>					
					</cfloop>
				<cfelse>
					<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
						INSERT INTO STOCKS_ROW
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
							LOT_NO,
							DELIVER_DATE,
							SHELF_NUMBER,
							PRODUCT_MANUFACT_CODE
							)
						VALUES
							(
							#form.invoice_id#,
							#evaluate("attributes.product_id#i#")#,
							#evaluate("attributes.stock_id#i#")#,
							69,
							#multi#,
							#attributes.department_id#,
							#attributes.location_id#,
							#attributes.invoice_date#,
							<cfif isdefined('form_spect_main_id') and len(form_spect_main_id)>#form_spect_main_id#<cfelse>NULL</cfif>,<!--- <cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>#evaluate("attributes.spect_id#i#")#<cfelse>NULL</cfif>, --->
							<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.lot_no#i#")#'><cfelse>NULL</cfif>,
							<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
