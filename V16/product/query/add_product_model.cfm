<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.model_id eq 0>
			<cfquery name="add_product_model" datasource="#dsn1#">
				INSERT INTO
					PRODUCT_BRANDS_MODEL
				(
					MODEL_CODE,
					MODEL_NAME,
                    BRAND_ID,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_code#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery>
		<cfelse>
			<cfquery name="ADD_PRODUCT_BRANDS" datasource="#dsn1#">
				UPDATE
					PRODUCT_BRANDS_MODEL
				SET
					MODEL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_code#">,
					MODEL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">,
                    BRAND_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				WHERE
					MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
			</cfquery>
		</cfif>
	</cftransaction>
</cflock>	
<script type="text/javascript">
	location.href = document.referrer;
</script>
