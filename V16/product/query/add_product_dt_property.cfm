<cf_xml_page_edit fuseact="product.popup_form_add_product_dt_property">
<cflock name="#createuuid()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_PRODUCT_CAT_RELATED_PROPERTY" datasource="#DSN1#">
			DELETE FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID= #attributes.product_id#
		</cfquery>
		<cfquery name="GET_STOCK" datasource="#DSN1#">
			SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id# ORDER BY RECORD_DATE DESC
		</cfquery>
		<cfif len(get_stock.stock_id)>
			<cfquery name="DEL_STOCK_PROPERTY" datasource="#DSN1#">
				DELETE FROM STOCKS_PROPERTY WHERE STOCK_ID = #get_stock.stock_id#
			</cfquery>
		</cfif>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") neq 0 and len(evaluate("attributes.property_id#i#")) and len(evaluate("attributes.property#i#"))>
				<cfscript>
					form_property_id = evaluate("attributes.property_id#i#");
					form_variation_id = evaluate("attributes.variation_id#i#");
					if(xml_product_connect != 'undefined' && xml_product_connect == 1){
						form_product_id = evaluate("attributes.product_property_id#i#");
						form_product = evaluate("attributes.product_property#i#");
					}
					form_detail = evaluate("attributes.detail#i#");
					form_line_row = evaluate ("attributes.line_row#i#");
					form_amount = evaluate("attributes.amount#i#");
					form_total_max = evaluate("attributes.total_max#i#");
					form_total_min = evaluate("attributes.total_min#i#");
				</cfscript>
				<cfquery name="ADD_PROPERTY" datasource="#DSN1#">
					INSERT INTO
						PRODUCT_DT_PROPERTIES
					(
						PRODUCT_ID,
						PROPERTY_ID,
						VARIATION_ID,
						DETAIL,
						LINE_VALUE,
						AMOUNT,
						TOTAL_MIN,
						TOTAL_MAX,
						IS_OPTIONAL,
						IS_EXIT,
						IS_INTERNET,
						<cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
							PRODUCT_PROPERTY_ID,
						</cfif>
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#attributes.product_id#,
						<cfif len(form_property_id)>#form_property_id#<cfelse>NULL</cfif>,
						<cfif len(form_variation_id)>#form_variation_id#<cfelse>NULL</cfif>,
						<cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
						<cfif len(form_line_row)>#form_line_row#<cfelse>NULL</cfif>,
						<cfif len(form_amount)>#form_amount#<cfelse>0</cfif>,
						<cfif len(form_total_min)>#form_total_min#<cfelse>NULL</cfif>,
						<cfif len(form_total_max)>#form_total_max#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.is_optional#i#")>1<cfelse>0</cfif>,
						<cfif isDefined("attributes.is_exit#i#")>1<cfelse>0</cfif>,
						<cfif isDefined("attributes.is_internet#i#")>1<cfelse>0</cfif>,
						<cfif isdefined("xml_product_connect") and xml_product_connect eq 1>
							<cfif len(form_product_id) and len(form_product)>#form_product_id#<cfelse>NULL</cfif>,
						</cfif>
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#'
					)
				</cfquery>
				<cfif len(get_stock.stock_id)>
					<cfoutput query="get_stock">
						<cfquery name="ADD_PROPERTY" datasource="#DSN1#">
							INSERT INTO
								STOCKS_PROPERTY
							(
								STOCK_ID,
								PROPERTY_ID,
								PROPERTY_DETAIL_ID,
								PROPERTY_DETAIL,
								TOTAL_MIN,
								TOTAL_MAX
							)
							VALUES
							(
								#get_stock.stock_id#,
								<cfif len(form_property_id)>#form_property_id#<cfelse>NULL</cfif>,
								<cfif len(form_variation_id)>#form_variation_id#<cfelse>NULL</cfif>,
								<cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
								<cfif len(form_total_min)>#form_total_min#<cfelse>NULL</cfif>,
								<cfif len(form_total_max)>#form_total_max#<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
		<cfif isdefined("attributes.auto_product_code_2") and attributes.auto_product_code_2 eq 1>
			<cfquery name="GET_PROPERTY_CODE" datasource="#DSN1#">
				SELECT
					PROPERTY_DETAIL_CODE
				FROM
					PRODUCT_DT_PROPERTIES,
					PRODUCT_PROPERTY_DETAIL
				WHERE
					PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.product_id# AND
					PRODUCT_PROPERTY_DETAIL.PRPT_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
					PRODUCT_DT_PROPERTIES.VARIATION_ID = PROPERTY_DETAIL_ID
			</cfquery>

			<cfset product_code = "">
			<cfoutput query="GET_PROPERTY_CODE">
			<cfif currentrow eq 1>
				<cfset product_code = "#GET_PROPERTY_CODE.PROPERTY_DETAIL_CODE#">
			<cfelse>
				<cfset product_code = "#product_code#.#GET_PROPERTY_CODE.PROPERTY_DETAIL_CODE#">
			</cfif>
			</cfoutput>
			<cfquery name="UPD_PRODUCT_CODE" datasource="#DSN1#">
				UPDATE PRODUCT SET PRODUCT_CODE_2 = '#product_code#' WHERE PRODUCT_ID = #attributes.product_id#
			</cfquery>

		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
