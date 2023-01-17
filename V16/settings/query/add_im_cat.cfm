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
	<cfset form.imicon = '#file_name#.#cffile.serverfileext#'>
</cfif>

<cfquery name="INSIMCAT" datasource="#DSN#">
	INSERT INTO 
		SETUP_IM
        (
            IMCAT,
            IMCAT_ICON,
            IMCAT_LINK_TYPE,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        ) 
        VALUES 
        (
            '#IMCAT#',
            '#imicon#',
            '#imLinkType#',
            #now()#,
            #session.ep.userid#,
            '#CGI.REMOTE_ADDR#'
        )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_im_cat" addtoken="no"> 
