<cfloop index="i" from="1" to="10">  
	<cfif LEN(EVALUATE("attributes.get_rol#i#"))>
		<cfset ROLE=EVALUATE("attributes.get_rol#i#")>
	</cfif>
	<cfif len(evaluate("attributes.POSITION_CODE#i#")) and (evaluate("attributes.POSITION_CODE#i#") neq 0)>
		<cfset position_code=evaluate("attributes.POSITION_CODE#i#")>
		<cfif LEN(EVALUATE("attributes.get_rol#i#")) eq 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49329.Rol !'>");
				history.back();
			</script>
			<cfexit>
		</cfif>
		<cfquery name="add_worker_emp" datasource="#DSN3#">
			INSERT INTO 
				CAMPAIGN_TEAM
				(
					CAMPAIGN_ID,
					POSITION_CODE
					<cfif len(evaluate("attributes.get_rol#i#"))>
					,ROLE_ID 
					</cfif> 
				)
				VALUES
				(
					#attributes.CAMPAIGN_ID#,
					#position_code#
					<cfif len(evaluate("attributes.get_rol#i#"))>
					,#ROLE# 
					</cfif> 
				)
		</cfquery>
		<cfelseif len(evaluate("attributes.PARTNER_ID#i#")) and (evaluate("attributes.PARTNER_ID#i#") neq 0)>
			<cfif LEN(EVALUATE("attributes.get_rol#i#")) eq 0>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49329.Rol !'>");
					history.back();
				</script>
				<cfexit>
			</cfif>
			<cfset partner_id=evaluate("attributes.PARTNER_ID#i#")>
			<cfquery name="add_worker_par" datasource="#DSN3#">
				INSERT INTO 
					CAMPAIGN_TEAM
					(
						CAMPAIGN_ID,
						PARTNER_ID
						<cfif len(evaluate("attributes.get_rol#i#"))>
						,ROLE_ID 
						</cfif> 
					)
					VALUES
					(
						#attributes.CAMPAIGN_ID#,
						#partner_id#
						<cfif len(evaluate("attributes.get_rol#i#"))>
						,#ROLE# 
						</cfif>  
					)
			</cfquery>
	</cfif> 
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique_list_correspondence1_menu' );
	</cfif>
	
</script>
