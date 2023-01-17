<cflock name="#CreateUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="upd_prod_pause_type" datasource="#dsn3#">
			UPDATE
				SETUP_PROD_PAUSE_TYPE
			SET
				PROD_PAUSE_CAT_ID = <cfif isdefined("attributes.pauseCat") and len(attributes.pauseCat)>#attributes.pauseCat#<cfelse>NULL</cfif>,
				PROD_PAUSE_TYPE_CODE = '#attributes.pauseType_code#',
				PROD_PAUSE_TYPE = '#attributes.pauseType#',
				PAUSE_DETAIL = <cfif isdefined("attributes.detail") and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				IS_ACTIVE = <cfif isdefined("attributes.is_active") and len(attributes.is_active)>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'	
			WHERE
				PROD_PAUSE_TYPE_ID = #attributes.prod_pause_type_id#
		</cfquery>
		<cfquery name="del_pause_type" datasource="#dsn3#">
			DELETE FROM SETUP_PROD_PAUSE_TYPE_ROW WHERE PROD_PAUSE_TYPE_ID = #attributes.prod_pause_type_id#
		</cfquery>
		<cfif isDefined("attributes.productCat") and len(attributes.productCat)>
			<!--- Iliskili Urun Kategorileri --->
			<cfloop list="#attributes.productCat#" index="CAT">
				<cfquery name="Add_Product_catid" datasource="#dsn3#">
					INSERT INTO
						SETUP_PROD_PAUSE_TYPE_ROW
					(
						PROD_PAUSE_PRODUCTCAT_ID,
						PROD_PAUSE_TYPE_ID
					)
					VALUES
					(
						#cat#,
						#attributes.prod_pause_type_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<!---<script type="text/javascript">
	wrk_opener_reload();
	window.close();	
</script>--->
<script type="text/javascript">	
	window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_prod_pause_type</cfoutput>';
</script>
