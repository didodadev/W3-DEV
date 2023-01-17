<cfif isDefined("imicon") and len(form.imicon)>
	<cfif not DirectoryExists("#upload_folder##dir_seperator#settings#dir_seperator#")>
        <cfdirectory action="create" directory="#upload_folder##dir_seperator#settings#dir_seperator#">
    </cfif>
	<cfset upload_folder = "#upload_folder##dir_seperator#settings#dir_seperator#">
	<cffile action="upload" 
        filefield="imicon" 
        destination="#upload_folder#" 
        mode="777" 
        nameconflict="MAKEUNIQUE"> <!---  accept="image/*" --->

	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<!---Script dosyalarını engelle  02092010 FA,ND --->
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
	<cfif FileExists("#upload_folder##attributes.imicon_eski#")>
		<cffile action="delete" file="#upload_folder##attributes.imicon_eski#">
	</cfif>
	<cfset form.imicon = '#file_name#.#cffile.serverfileext#'>
</cfif>

<cfquery name="UPDIMCAT" datasource="#DSN#">
	UPDATE 
		SETUP_IM 
	SET 
		IMCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.imcat#">,
		<cfif isDefined("attributes.imicon") and len(attributes.imicon)>
			IMCAT_ICON = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.imicon#">,
		</cfif>
		IMCAT_LINK_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.imLinkType#">,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		IMCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.imcat_id#">
</cfquery> 

<cflocation url="#request.self#?fuseaction=settings.form_add_im_cat" addtoken="no">

