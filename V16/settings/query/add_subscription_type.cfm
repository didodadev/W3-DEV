<cfif len(subs_icon_file)>
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
	<cfquery name="ADD_SUBSCRIPTION_TYPE" datasource="#DSN3#" result="MAX_ID">
		INSERT INTO 
			SETUP_SUBSCRIPTION_TYPE
		(
			SUBSCRIPTION_TYPE,
			PRODUCT_ID,
			STOCK_ID,
			ICON_COLOR,
			ICON_FILE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		) 
		VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscripton_type#">,
			<cfif len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.stock_id) and len(attributes.stock_id)>#attributes.stock_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.system_icon_color)>'#attributes.system_icon_color#'<cfelse>NULL</cfif>,
			<cfif len(subs_icon_file)>'#cffile.serverfile#'<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
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
					#MAX_ID.IDENTITYCOL#,
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
					#MAX_ID.IDENTITYCOL#,
					#I#
				)
			</cfquery>	
		</cfloop>
	</cfif>
	<cfif ListLen(pos_cats)>
		<cfloop list="#pos_cats#" index="I" delimiters=",">
			<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN3#">
				INSERT INTO 
					SUBSCRIPTION_GROUP_PERM
				(
					SUBSCRIPTION_TYPE_ID,
					POSITION_CAT
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#I#
				)
			</cfquery>	
		</cfloop>
	</cfif>
</cftransaction>
<cflocation url="#request.self#?fuseaction=settings.add_subscription_type" addtoken="no">
