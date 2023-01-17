<cftransaction>
<cfif attributes.purchase_sales eq 1>
		  <cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
				SELECT 
					PRODUCT_CATID, 
					HIERARCHY
				FROM 
					PRODUCT_CAT 
				WHERE 
					PRODUCT_CATID IS NOT NULL AND
					PRODUCT_CATID = #attributes.product_catid#
				ORDER BY HIERARCHY
			</cfquery>		  
			<cfquery name="GET_PRODUCT" datasource="#DSN3#">
			  SELECT 
				  PRODUCT.PRODUCT_NAME, 
				  PRODUCT.RECORD_DATE, 
				  PRODUCT.PRODUCT_CODE,
				  PRODUCT.PRODUCT_ID,
				  PRODUCT.TAX,
				  PRODUCT.TAX_PURCHASE
			  FROM 
				  PRODUCT 
			  WHERE 
				  PRODUCT.PRODUCT_STATUS = 1
	   			  <cfif len(attributes.product_cat)>
 				  AND PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
				  </cfif>
				  <cfif len(attributes.employee) and len(attributes.employee_id)>
				  AND PRODUCT_MANAGER=#attributes.employee_id#
				  </cfif>
				  <cfif len(attributes.get_company) and len(attributes.get_company_id)>
				  AND COMPANY_ID = #attributes.get_company_id#
				  </cfif>
          </cfquery>
		  <cfloop query="GET_PRODUCT">
			<cfset attributes.form_discount1 = evaluate('attributes.discount1#currentrow#')>
			<cfset attributes.form_discount2 = evaluate('attributes.discount2#currentrow#')>
			<cfset attributes.form_discount3 = evaluate('attributes.discount3#currentrow#')>
			<cfset attributes.form_discount4 = evaluate('attributes.discount4#currentrow#')>
			<cfset attributes.form_discount5 = evaluate('attributes.discount5#currentrow#')>
			<cfset attributes.form_discount5 = evaluate('attributes.discount5#currentrow#')>
			<cfset attributes.form_paymethod_id = evaluate('attributes.paymethod_type#currentrow#')>
			<cfif isdefined("attributes.form_is_record_active#currentrow#")>
			<cfif len(attributes.form_discount1) and len(attributes.form_discount2) and len(attributes.form_discount3) and len(attributes.form_discount4) and len(attributes.form_discount5)>
				<cfquery name="GET_P_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#" maxrows="1">
					SELECT
						PRODUCT_ID
					FROM
						CONTRACT_PURCHASE_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID#
					ORDER BY
						START_DATE DESC
				</cfquery>
				<cfif get_p_purchase_prod_discount.recordcount>
					<cfquery name="UPD_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#">
						UPDATE
							CONTRACT_PURCHASE_PROD_DISCOUNT
						SET
							PRODUCT_ID = #get_product.product_id#,
							DISCOUNT1 = #attributes.form_discount1#,
							DISCOUNT2 = #attributes.form_discount2#,
							DISCOUNT3 = #attributes.form_discount3#,
							DISCOUNT4 = #attributes.form_discount4#,
							DISCOUNT5 = #attributes.form_discount5#,
							PAYMETHOD_ID = #attributes.form_paymethod_id#,
							START_DATE = #attributes.start_date#,
							RECORD_EMP = #session.ep.userid#,
							RECORD_DATE = #now()#,
							RECORD_IP = '#cgi.REMOTE_ADDR#'
						WHERE
							PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND
							C_P_PROD_DISCOUNT_ID = #GET_P_PURCHASE_PROD_DISCOUNT.C_P_PROD_DISCOUNT_ID#
					</cfquery>
				<cfelse>
					<cfquery name="ADD_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#">
					INSERT 
					INTO
						CONTRACT_PURCHASE_PROD_DISCOUNT
					(
						PRODUCT_ID,
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						PAYMETHOD_ID,
						START_DATE,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
					VALUES
					(
						#get_product.product_id#,
						#attributes.form_discount1#,
						#attributes.form_discount2#,
						#attributes.form_discount3#,
						#attributes.form_discount4#,
						#attributes.form_discount5#,
						#attributes.form_paymethod_id#,
						#attributes.start_date#,
						#session.ep.userid#,
						#now()#,
						'#cgi.REMOTE_ADDR#'
					)
				</cfquery>
			</cfif>
		</cfif>
		</cfif>
	</cfloop>
<cfelseif attributes.purchase_sales eq 2>
          <cfquery name="GET_PRODUCT" datasource="#DSN3#">
			  SELECT 
				  PRODUCT.PRODUCT_NAME, 
				  PRODUCT.RECORD_DATE, 
				  PRODUCT.PRODUCT_CODE,
				  PRODUCT.PRODUCT_ID 
			  FROM 
				  PRODUCT 
			  WHERE 
				  PRODUCT.PRODUCT_STATUS = 1
	   			  <cfif len(attributes.product_cat)>
 				  AND PRODUCT_CODE LIKE '#attributes.product_cat#.%'
				  </cfif>
				  <cfif len(attributes.employee) and len(attributes.employee_id)>
				  AND PRODUCT_MANAGER=#attributes.employee_id#
				  </cfif>
				  <cfif len(attributes.get_date)>
				  AND PRODUCT.RECORD_DATE >= #attributes.get_date#
				  </cfif>
          </cfquery>
		  <cfloop query="GET_PRODUCT">
			<cfset attributes.form_discount1 = evaluate('attributes.discount1#currentrow#')>
			<cfset attributes.form_discount2 = evaluate('attributes.discount2#currentrow#')>
			<cfset attributes.form_discount3 = evaluate('attributes.discount3#currentrow#')>
			<cfset attributes.form_discount4 = evaluate('attributes.discount4#currentrow#')>
			<cfset attributes.form_discount5 = evaluate('attributes.discount5#currentrow#')>
			<cfset attributes.form_discount5 = evaluate('attributes.discount5#currentrow#')>
			<cfset attributes.form_paymethod_id = evaluate('attributes.paymethod_type#currentrow#')>
			<cfif isdefined("attributes.form_is_record_active#currentrow#")>
			<cfif len(form_discount1) and len(form_discount2) and len(form_discount3) and len(form_discount4) and len(form_discount5)>
				<cfquery name="GET_P_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#" maxrows="1">
					SELECT
						PRODUCT_ID
					FROM
						CONTRACT_SALES_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID#
					ORDER BY RECORD_DATE DESC
				</cfquery>
				<cfif get_p_purchase_prod_discount.recordcount>
					<cfquery name="UPD_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#">
						UPDATE
							CONTRACT_SALES_PROD_DISCOUNT
						SET
							PRODUCT_ID = #get_product.product_id#,
							DISCOUNT1 = #attributes.form_discount1#,
							DISCOUNT2 = #attributes.form_discount2#,
							DISCOUNT3 = #attributes.form_discount3#,
							DISCOUNT4 = #attributes.form_discount4#,
							DISCOUNT5 = #attributes.form_discount5#,
							PAYMETHOD_ID = #attributes.form_paymethod_id#,
							START_DATE = #attributes.start_date#,
							RECORD_EMP = #session.ep.userid#,
							RECORD_DATE = #now()#,
							RECORD_IP = '#cgi.REMOTE_ADDR#'
						WHERE
							PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND
							C_S_PROD_DISCOUNT_ID = #GET_P_PURCHASE_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID#
					</cfquery>
				<cfelse>
					<cfquery name="ADD_PURCHASE_PROD_DISCOUNT" datasource="#DSN3#">
						INSERT 
						INTO
							CONTRACT_SALES_PROD_DISCOUNT
						(
							PRODUCT_ID,
							DISCOUNT1,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							PAYMETHOD_ID,
							START_DATE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
							VALUES
						(
							#get_product.product_id#,
							#attributes.form_discount1#,
							#attributes.form_discount2#,
							#attributes.form_discount3#,
							#attributes.form_discount4#,
							#attributes.form_discount5#,
							#attributes.form_paymethod_id#,
							#attributes.start_date#,
							#session.ep.userid#,
							#now()#,
							'#cgi.REMOTE_ADDR#'
						)
				</cfquery>
			</cfif>
		</cfif>
		</cfif>
	</cfloop>	
</cfif>
</cftransaction>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

