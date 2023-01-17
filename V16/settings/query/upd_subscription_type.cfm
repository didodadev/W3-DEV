	<cfif len(attributes.subs_icon_file)>
		<cfif not DirectoryExists("#upload_folder#settings#dir_seperator#")>
			<cfdirectory action="create" directory="#upload_folder#settings#dir_seperator#">
		</cfif>
		<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
		<cffile action = "upload" 
			fileField = "subs_icon_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777">
		
		<cfif len(cffile.serverfile) gt 50>
		<cffile action="delete" file="#upload_folder#settings#dir_seperator##cffile.serverfile#">
		<script type="text/javascript">
			alert('Dosya Adı Çok Uzun Lütfen Değiştiriniz !');
			history.back();
		</script>
		<cfabort>
		</cfif>
	</cfif>
<cftransaction>
	<cfquery name="UPD_SUBSCRIPTION_TYPE" datasource="#DSN3#">
		UPDATE 
			SETUP_SUBSCRIPTION_TYPE
		SET 
			SUBSCRIPTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_type#">,
			PRODUCT_ID = <cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#,<cfelse>NULL,</cfif>
			STOCK_ID = <cfif len(attributes.stock_id) and len(attributes.product_name)>#attributes.stock_id#,<cfelse>NULL,</cfif>
			ICON_COLOR = <cfif len(attributes.system_icon_color)>'#attributes.system_icon_color#'<cfelse>NULL</cfif>,
			ICON_FILE = <cfif isdefined("cffile.serverfile")>'#cffile.serverfile#'<cfelseif isdefined("attributes.del_icon") and attributes.del_icon eq 1>NULL<cfelse>ICON_FILE</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE 
			SUBSCRIPTION_TYPE_ID = #attributes.subscription_type_id#
	</cfquery>
	<cfquery name="DEL_PERM" datasource="#DSN3#">
		DELETE FROM SUBSCRIPTION_GROUP_PERM WHERE SUBSCRIPTION_TYPE_ID = #attributes.subscription_type_id#
	</cfquery>

	<cfscript>
		if(isdefined("attributes.to_par_ids")) s_PARS = ListSort(ListDeleteDuplicates(attributes.to_par_ids),"Numeric", "Desc"); else s_PARS ='';
		if(isdefined("attributes.to_pos_codes")) s_PCODES =ListSort(ListDeleteDuplicates(attributes.to_pos_codes),"Numeric", "Desc") ; else s_PCODES ='';
		if(isdefined("attributes.position_cats")) pos_cats =ListSort(ListDeleteDuplicates(attributes.position_cats),"Numeric", "Desc") ; else pos_cats ='';
	</cfscript>
	<cfif ListLen(s_PARS)>
		<cfloop list="#s_PARS#" index="I" delimiters=",">
			<cfquery name="ADD_PRO_COMP_PERM" datasource="#DSN3#">
				INSERT INTO 
					SUBSCRIPTION_GROUP_PERM
					(
						SUBSCRIPTION_TYPE_ID,
						PARTNER_ID
					)
				VALUES
					(
						#attributes.subscription_type_id#,
						#I#
					)
			</cfquery>
		</cfloop>
	</cfif>
	<cfif ListLen(s_PCODES)>
		<cfloop list="#s_PCODES#" index="I" delimiters=",">
			<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN3#">
				INSERT INTO 
					SUBSCRIPTION_GROUP_PERM
					(
						SUBSCRIPTION_TYPE_ID,
						POSITION_CODE
					)
				VALUES
					(
						#attributes.subscription_type_id#,
						#I#
					)
			</cfquery>	
		</cfloop>
	</cfif>
	<cfif ListLen(pos_cats)>
		<cfloop list="#pos_cats#" index="I" delimiters=",">
			<cfif (isdefined("attributes.status_#i#") and evaluate("attributes.status_#i#") eq 1) or not isdefined("attributes.status_#i#")>
				<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN3#">
					INSERT INTO 
						SUBSCRIPTION_GROUP_PERM
						(
							SUBSCRIPTION_TYPE_ID,
							POSITION_CAT
						)
					VALUES
						(
							#attributes.subscription_type_id#,
							#I#
						)
				</cfquery>	
			</cfif>
		</cfloop>
	</cfif>
</cftransaction>
<script>
	location.href = document.referrer;
</script>
