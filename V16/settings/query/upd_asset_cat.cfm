<cfquery name="KLASOR" datasource="#DSN#">
	SELECT ASSETCAT_ID,ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.assetcat_id#">
</cfquery>

<cfif isdefined("attributes.assettopcat_id") and len(attributes.assettopcat_id)>
	<cfquery name = "GET_ASSET_CAT" datasource = "#dsn#">
		SELECT 
			ASSETCAT_PATH 
		FROM 
			ASSET_CAT
		WHERE
			ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assettopcat_id#">
	</cfquery>
	<cfif GET_ASSET_CAT.recordcount eq 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='48534'>");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfset assetCatPath = Replace(GET_ASSET_CAT.ASSETCAT_PATH,'\', '/', 'all')>
		<cfset pathLastFolder = ListLast(assetCatPath, '/')>
		<cfset newPathFolder = Replace(assetCatPath,pathLastFolder,attributes.ASSETCAT_PATH,'all')>
		<cfset dir_tr = newPathFolder>	
	</cfif>
<cfelse>
	<cfset dir_tr = attributes.ASSETCAT_PATH>
</cfif>

<cfset hata = 0>
<!---<cfset dir_tr = form.assetcat_path>--->
<cf_tr2eng var_name="dir_tr">
<cfset dir_tr_yaz = replace(dir_tr,'/','#dir_seperator#','all')>
<cfif klasor.assetcat_path neq dir_tr>
	<cftry>
		<cfdirectory
            action="RENAME" 
            directory="#upload_folder#asset#dir_seperator##klasor.assetcat_path#"
            newdirectory="#upload_folder#ASSET#dir_seperator##dir_tr_yaz#" 
            mode="777">
		<cfcatch>
			<script type="text/javascript">
			 alert("<cf_get_lang no='94.Seçtiğiniz Klasör İsmi ile İlgili Bir Sorun Oluştu !'>");
			 history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>

<cfif not hata>
	<cfscript>
		if(isdefined("attributes.digital_asset_group_id")) dgag_id = ListSort(ListDeleteDuplicates(attributes.digital_asset_group_id),"Numeric", "Desc") ; else dgag_id ='';
	</cfscript>
	<cfquery name="UPDASSETCAT" datasource="#DSN#">
		UPDATE 
			ASSET_CAT 
		SET
			ASSETCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetcat#">,
			<cfif isdefined("attributes.assetcat_name") and len(attributes.assetcat_name) and isdefined("attributes.assettopcat_id") and len(attributes.assettopcat_id)>
				ASSETCAT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.assettopcat_id#">,
			</cfif> 
			ASSETCAT_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#dir_tr#">,
			ASSETCAT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetcat_detail#">,
			CONTENT_PROPERTY_ID = <cfif isdefined("attributes.content_property_id") and len(attributes.content_property_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.content_property_id#"><cfelse>NULL</cfif>,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
			IS_EXTRANET = <cfif isdefined("attributes.is_extranet")>1<cfelse>0</cfif>
		WHERE 
			ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
	</cfquery>
	<cfquery name="DEL_PERM" datasource="#DSN#">
		DELETE FROM DIGITAL_ASSET_GROUP_PERM WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">,
					#I#
				)
			</cfquery>	
		</cfloop>
	</cfif>
	
</cfif>
<cfif isdefined("attributes.popup")>
	<script>
		location.href = document.referrer;
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.form_add_asset_cat" addtoken="no">
</cfif>