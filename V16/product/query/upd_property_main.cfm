<cflock name="#createUUID()#" timeout="20">
  <cftransaction>
	  <cfquery name="UPD_PRODUCT_PROPERTY" datasource="#DSN1#">
			UPDATE  
				PRODUCT_PROPERTY
			SET		
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				IS_INTERNET = <cfif isdefined("attributes.is_web_control")>1<cfelse>0</cfif>,
				IS_VARIATION_CONTROL = <cfif isdefined("attributes.is_variation_control")>1<cfelse>0</cfif>,
				PROPERTY_CODE = <cfif len(attributes.property_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property_code#"><cfelse>NULL</cfif>,
				PROPERTY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property#">,
			<cfif isDefined("attributes.size_color") and (attributes.size_color eq 1)>
				PROPERTY_SIZE = 1,
				PROPERTY_COLOR = 0,
			<cfelseif isDefined("attributes.size_color") and (attributes.size_color eq 0)>
				PROPERTY_SIZE = 0,
				PROPERTY_COLOR = 1,
			<cfelseif not isDefined("attributes.size_color")>
				PROPERTY_SIZE = 0,
				PROPERTY_COLOR = 0,
			</cfif>
				PROPERTY_LEN = <cfif isdefined("attributes.PROPERTY_LEN")>1<cfelse>0</cfif>,
				DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
                UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE 
				PROPERTY_ID = #attributes.property_id#
	   </cfquery>
	   	<cfquery name="del_property_company" datasource="#dsn1#">
			DELETE FROM 
				PRODUCT_PROPERTY_OUR_COMPANY
			WHERE
				PROPERTY_ID = #attributes.property_id#
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
							#attributes.property_id#,
							#listgetat(attributes.our_company_ids,i)#
						)
					</cfquery>
			</cfloop>
	   </cfif>
	</cftransaction>
</cflock>
<script>
	location.href = document.referrer;
	
</script>

