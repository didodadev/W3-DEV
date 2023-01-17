<cfquery name="get_imp_products" datasource="#dsn3#">
	SELECT QUALITY_CONTROL_ID FROM IMPROPER_PRODUCTS WHERE QUALITY_CONTROL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quality_control_id#">
</cfquery>
<cfif len(attributes.imp_date)>
	<cf_date tarih="attributes.imp_date">
</cfif>

<cfif get_imp_products.recordcount>
	<cfquery name="UPD_IDENTY" datasource="#dsn3#">
		UPDATE
			IMPROPER_PRODUCTS
		SET
			PRODUCT_ID = <cfif len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
			CREATE_UNIT = <cfif len(attributes.create_unit)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.create_unit#"><cfelse>NULL</cfif>, 
			IMP_DEFINITION = <cfif len(attributes.imp_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.imp_definition#"><cfelse>NULL</cfif>,
			IMP_QUANTITY = <cfif len(attributes.imp_quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.imp_quantity#"><cfelse>NULL</cfif>,
			IMP_DATE = <cfif len(attributes.imp_date)>#attributes.imp_date#<cfelse>NULL</cfif>,
			IMP_SOURCE_ID = <cfif len(attributes.imp_source_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.imp_source_id#"><cfelse>NULL</cfif>,
			PROCESS = <cfif len(attributes.process)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process#"><cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			QUALITY_CONTROL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quality_control_id#">
	</cfquery>
<cfelse>
	<cfquery name="add_imp_product" datasource="#dsn3#">
		INSERT INTO 
			IMPROPER_PRODUCTS
			(
				QUALITY_CONTROL_ID,
				PRODUCT_ID,
				CREATE_UNIT, 
				IMP_DEFINITION,
				IMP_QUANTITY,
				IMP_DATE,
				IMP_SOURCE_ID,
				PROCESS,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quality_control_id#">,
				<cfif len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
				<cfif len(attributes.create_unit)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.create_unit#"><cfelse>NULL</cfif>,
				<cfif len(attributes.imp_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.imp_definition#"><cfelse>NULL</cfif>,
				<cfif len(attributes.imp_quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.imp_quantity#"><cfelse>NULL</cfif>,
				<cfif len(attributes.imp_date)>#attributes.imp_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.imp_source_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.imp_source_id#"><cfelse>NULL</cfif>,
				<cfif len(attributes.process)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfif>
<script type="text/javascript">
location.href = document.referrer;
</script>
