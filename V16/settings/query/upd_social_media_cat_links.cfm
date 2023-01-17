<!---Social Media Link Ekleme EmptyPopup--->
<cfloop from=1 to="#attributes.rowcount#" index="i">	
		<cfquery name="check_link" datasource="#dsn#">
			SELECT LINK FROM SETUP_SOCIAL_MEDIA_CAT_LINK WHERE SMCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.smcat_id#"> AND OUR_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.comp_id_#i#')#">
		</cfquery>
		<cfset temp_link_ = evaluate('attributes.link_#i#')>
		<cfif check_link.recordcount>
			<cfquery name="comp_link_upd" datasource="#dsn#">
				UPDATE 
					SETUP_SOCIAL_MEDIA_CAT_LINK SET LINK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_link_#">,
					IS_INTERNET = <cfif isdefined("attributes.is_internet_#i#")>1<cfelse>0</cfif>
				WHERE 
					SMCAT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.smcat_id#"> AND
					OUR_COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.comp_id_#i#')#">
			</cfquery>
		<cfelse>
			<cfquery name="comp_link_ins" datasource="#dsn#"> 
				INSERT INTO 
					SETUP_SOCIAL_MEDIA_CAT_LINK
				(
					SMCAT_ID,
					OUR_COMPANY_ID,
					LINK,
					IS_INTERNET
				) 
				VALUES 
				(
					#attributes.smcat_id#,
					#evaluate('attributes.comp_id_#i#')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_link_#">,
					<cfif isdefined("attributes.is_internet_#i#")>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfif>
</cfloop>

<script type="text/javascript">
	window.close();	
</script>
