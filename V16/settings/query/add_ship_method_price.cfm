<cflock name="#CREATEUUID()#" timeout="60">
  	<cftransaction>
		<cfquery name="ADD_SHIP_METHOD_PRICE" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				SHIP_METHOD_PRICE
			(
				COMPANY_ID,
				PRICE,
				MAX_LIMIT,
				CALCULATE_TYPE,
				OTHER_MONEY,
				MULTI_CITY_ID,
				PRODUCT_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#attributes.company_id#,
				#attributes.price#,
				#attributes.max_limit#,
				#attributes.calculate_type#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.multi_city_id#">,
				<cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#			
			)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
		  <cfif evaluate("attributes.row_kontrol#i#")>
			<cfset form_ship_method = evaluate("attributes.ship_method#i#")>
			<cfset form_package_type = evaluate("attributes.package_type#i#")>
			<cfset form_start_value = evaluate("attributes.start_value#i#")>
			<cfset form_finish_value = evaluate("attributes.finish_value#i#")>
			<cfset form_price = evaluate("attributes.price#i#")>
			<cfset form_customer_price = evaluate("attributes.customer_price#i#")>
			<cfquery name="ADD_SHIP_METHOD_PRICE" datasource="#DSN#">
				INSERT INTO 
					SHIP_METHOD_PRICE_ROW
				(
					SHIP_METHOD_PRICE_ID,
					SHIP_METHOD_ID,
					PACKAGE_TYPE_ID,
					START_VALUE,
					FINISH_VALUE,
					PRICE,
					CUSTOMER_PRICE,
					OTHER_MONEY
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					<cfif len(form_ship_method)>#form_ship_method#<cfelse>NULL</cfif>,
					#form_package_type#,
					<cfif len(form_start_value)>#form_start_value#<cfelse>NULL</cfif>,
					<cfif len(form_finish_value)>#form_finish_value#<cfelse>NULL</cfif>,
					<cfif len(form_price)>#form_price#<cfelse>NULL</cfif>,
					<cfif len(form_customer_price)>#form_customer_price#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				)
			</cfquery>
		  </cfif>
		</cfloop>
  	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_ship_method_price" addtoken="no">
