<!--- Sosyal Medya Kategorisi Guncelleme Query --->
<cfif isDefined("file_name_") and len(attributes.file_name_)>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cffile action="UPLOAD" 
			filefield="file_name_" 
			destination="#upload_folder#" 
			mode="777" 
			nameconflict="MAKEUNIQUE" accept="image/png,image/jpeg,application/msword,application/pdf,text/plain">
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
	<cfif FileExists("#upload_folder##attributes.smicon_old#")>
		<cffile action="delete" file="#upload_folder##attributes.smicon_old#">
	</cfif>
	<cfset attributes.file_name_ = '#file_name#.#cffile.serverfileext#'>
</cfif>

<cfif isDefined("is_del") and is_del eq 1>
<cfquery name="DELIMCAT" datasource="#dsn#">
	DELETE FROM SETUP_SOCIAL_MEDIA_CAT WHERE SMCAT_ID=#attributes.smcat_id#
	DELETE FROM SOCIAL_MEDIA WHERE SMCAT_ID=#attributes.smcat_id#
</cfquery>
<cfelse>
<cfquery name="UPDIMCAT" datasource="#dsn#">
	UPDATE 
		SETUP_SOCIAL_MEDIA_CAT 
	SET 
		SMCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialCat#">,
		<cfif isDefined("attributes.file_name_") and len(attributes.file_name_)>
			SMCAT_ICON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_name_#">,
		</cfif>
		SMCAT_LINK_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialLinkType#">,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE 
		SMCAT_ID = #attributes.smcat_id#
</cfquery>
</cfif>
<script>
location.href = document.referrer;
</script>
