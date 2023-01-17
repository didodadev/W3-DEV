<!--- Sosyal Medya Kategorisi Ekleme Query --->
<cfif isDefined("attributes.file_name_") and len(attributes.file_name_)>
		<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
		<cffile action="UPLOAD" 
				filefield="file_name_" 
				destination="#upload_folder#" 
				mode="777" 
				nameconflict="MAKEUNIQUE"  accept="image/png,image/jpeg,application/msword,application/pdf,text/plain">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset attributes.file_name_ = '#file_name#.#cffile.serverfileext#'>
</cfif>

<cfquery name="INSSMCAT" datasource="#DSN#">
	INSERT INTO 
		SETUP_SOCIAL_MEDIA_CAT
	(
		SMCAT,
		SMCAT_ICON,
		SMCAT_LINK_TYPE,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialCat#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_name_#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialLinkType#">,
		#NOW()#,
		#SESSION.EP.USERID#
	)
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_social_media_cat" addtoken="no"> 
