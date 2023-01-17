<cftry>
	<cfif isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
		<cfquery name = "GET_ASSET_CAT" datasource = "#dsn#">
			SELECT 
				ASSETCAT_PATH 
			FROM 
				ASSET_CAT
			WHERE
				ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetcat_id#">
		</cfquery>
		<cfif GET_ASSET_CAT.recordcount eq 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='48534'>");
				history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfset dir_tr = "#GET_ASSET_CAT.ASSETCAT_PATH#/#attributes.ASSETCAT_PATH#">	
		</cfif>
	<cfelse>
		<cfset dir_tr = attributes.ASSETCAT_PATH>
	</cfif>
    <cf_tr2eng var_name="dir_tr">
	<cfif not DirectoryExists("#upload_folder#asset#dir_seperator##dir_tr#")>
		<CFDIRECTORY ACTION="CREATE" DIRECTORY="#upload_folder#asset#dir_seperator##dir_tr#" MODE="777">
	<cfelse>
		<script type="text/javascript">
		 	alert("<cf_get_lang dictionary_id='48542'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfcatch type="ANY">
		<script type="text/javascript">
		 	alert("<cf_get_lang no='94.Seçtiğiniz Klasör İsmi ile İlgili Bir Sorun Oluştu !'>");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfquery name="GET_ASSETCAT_MAX" datasource="#DSN#">
    SELECT 
          MAX(ASSETCAT_ID) AS max_id
    FROM
         ASSET_CAT 	  
</cfquery>
<cfscript>
    if (GET_ASSETCAT_MAX.max_id eq '')
    	max_id = 1;
	else max_id = GET_ASSETCAT_MAX.max_id + 1;	
	//if(isdefined("attributes.to_pos_codes")) s_PCODES =ListSort(ListDeleteDuplicates(attributes.to_pos_codes),"Numeric", "Desc") ; else s_PCODES ='';
	if(isdefined("attributes.digital_asset_group_id")) dgag_id = ListSort(ListDeleteDuplicates(attributes.digital_asset_group_id),"Numeric", "Desc") ; else dgag_id ='';
</cfscript>	

<cftransaction>
	<cfquery name="INSASSETCAT" datasource="#DSN#" result="MAX">
		INSERT INTO 
			ASSET_CAT
		( 
			ASSETCAT_ID,
			<cfif isdefined("attributes.assetcat_name") and len(attributes.assetcat_name) and isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
				ASSETCAT_MAIN_ID,
			</cfif> 
			ASSETCAT,
			ASSETCAT_PATH,
			ASSETCAT_DETAIL,
			CONTENT_PROPERTY_ID,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP,
			IS_INTERNET,
			IS_EXTRANET
		) 
		VALUES 
		(    #max_id#,
			<cfif isdefined("attributes.assetcat_name") and len(attributes.assetcat_name) and isdefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assetcat_id#">,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ASSETCAT#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#dir_tr#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ASSETCAT_DETAIL#">,
			<cfif isdefined("attributes.content_property_id") and len(attributes.content_property_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#content_property_id#"><cfelse>NULL</cfif>,
			'#cgi.remote_addr#',
			#now()#,
			#session.ep.userid#,
			<cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_extranet")>1<cfelse>0</cfif>
		)
	</cfquery>
	<cfif ListLen(dgag_id)>
		<cfloop list="#dgag_id#" index="I" delimiters=",">
			<cfquery name="ADD_GROUP_PERM" datasource="#DSN#">
				INSERT INTO 
					DIGITAL_ASSET_GROUP_PERM
				(
					ASSETCAT_ID,
					GROUP_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id#">,
					#I#
				)
			</cfquery>	
		</cfloop>
	</cfif>
</cftransaction>

<cfif isdefined("attributes.popup")>
	<script>
		location.href = document.referrer;
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.form_add_asset_cat" addtoken="no">
</cfif>