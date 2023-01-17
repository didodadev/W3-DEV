<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="add_product_property" datasource="#dsn1#" result="MAX_ID">
		INSERT INTO 
			PRODUCT_PROPERTY 
		(
			IS_VARIATION_CONTROL,
			IS_ACTIVE,
			IS_INTERNET,
			PROPERTY_CODE,
			PROPERTY,
			PROPERTY_SIZE,
			PROPERTY_COLOR,
			DETAIL,
			PROPERTY_LEN,
            RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES	
		(	
			<cfif isdefined("attributes.is_variation_control")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_web_control")>1<cfelse>0</cfif>,
			<cfif len(attributes.property_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_code#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property#">,
			<cfif isdefined("attributes.size_color") and (attributes.size_color eq 1)>1,0,<cfelseif isdefined("attributes.size_color") and (attributes.size_color eq 0)>0,1,<cfelseif not isdefined("attributes.size_color")>0,0,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
			<cfif isdefined("attributes.PROPERTY_LEN")>1<cfelse>0</cfif>,
            #now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	</cfquery>
	<cfif isdefined("attributes.our_company_ids") and listlen(attributes.our_company_ids)>
		<cfloop from="1" to="#listlen(attributes.our_company_ids)#" index="i">
				<cfquery name="add_property_our_company" datasource="#dsn1#">
					INSERT INTO
						PRODUCT_PROPERTY_OUR_COMPANY
					(
						PROPERTY_ID,
						OUR_COMPANY_ID
					)				
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.our_company_ids,i)#
					)
				</cfquery>
		</cfloop>
	</cfif>
  </cftransaction>
</cflock>
<script>
	
	<cfif not isdefined("attributes.draggable")>
		location.href = document.referrer;
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</script>
