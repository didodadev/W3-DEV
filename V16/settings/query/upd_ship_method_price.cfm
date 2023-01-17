<cfif isdefined("attributes.picture") and len(attributes.picture)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" destination="#upload_folder#settings#dir_seperator#" filefield="picture" nameconflict="MAKEUNIQUE" accept="image/*"> 
		<cffile action="rename" 
			    source="#upload_folder#settings#dir_seperator##cffile.serverfile#" 
		   destination="#upload_folder#settings#dir_seperator##file_name#.#cffile.serverfileext#">
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>	
	<cfscript>
		attributes.picture = file_name &"." & cffile.serverfileext;
	</cfscript>	
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
 	<cftransaction>
		<cfquery name="UPD_SHIP_METHOD_PRICE" datasource="#DSN#">
			UPDATE
				SHIP_METHOD_PRICE
			SET
				COMPANY_ID = #attributes.company_id#,
				PRICE = #attributes.price#,
				MAX_LIMIT = #attributes.max_limit#,
				CALCULATE_TYPE = #attributes.calculate_type#,
				PICTURE = <cfif isDefined("attributes.picture") and len(attributes.picture)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.picture#"><cfelse>NULL</cfif>,
				PICTURE_SERVER_ID = <cfif isDefined("attributes.picture") and len(attributes.picture)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				MULTI_CITY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.multi_city_id#">,
				PRODUCT_ID = <cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE 
				SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
		</cfquery>
	
		<cfquery name="DEL_SHIP_METHOD_PRICE_ROW" datasource="#DSN#">
			DELETE FROM SHIP_METHOD_PRICE_ROW WHERE SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num#" index="i">
	 		<cfif evaluate("attributes.row_kontrol#i#")>
				<cfset form_ship_method = evaluate("attributes.ship_method#i#")>
				<cfset form_package_type = evaluate("attributes.package_type#i#")>		
				<cfset form_start_value = evaluate("attributes.start_value#i#")>
				<cfset form_finish_value = evaluate("attributes.finish_value#i#")>
				<cfset form_price = evaluate("attributes.price#i#")>
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
						#attributes.ship_method_price_id#,
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
<!--- <cflocation url="#request.self#?fuseaction=settings.form_upd_ship_method_price&ship_method_price_id=#attributes.ship_method_price_id#" addtoken="no"> --->
<cflocation url="#request.self#?fuseaction=settings.list_ship_method_price" addtoken="no">