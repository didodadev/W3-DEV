<style type="text/css">
	.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
	.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
	.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
</style>

<cfoutput>
<cfif isdefined("arguments.mail_logo") and len(arguments.mail_logo)>#arguments.mail_logo#</cfif>
<table width="600" class="css1">
	<tr>
    	<cfquery name="GET_LAST_ASSET_ID" datasource="#DSN#">
			SELECT MAX(ASSET_ID) AS ASSET_ID FROM ASSET
		</cfquery>
        <cfquery name="GET_ASSET" datasource="#DSN#">
        	SELECT
            	ASSET.ASSET_NAME,
            	ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_FILE_PATH_NAME,
                ASSET_CAT.ASSETCAT_ID,
                ASSET_CAT.ASSETCAT_PATH
			FROM
            	ASSET,
                ASSET_CAT
			WHERE
            	ASSET.ASSET_ID = <cfif isdefined('arguments.asset_id')>#arguments.asset_id#<cfelse>#get_last_asset_id.ASSET_ID#</cfif> AND 
				ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID
        </cfquery>
		<cfsavecontent variable="message"><cfoutput>#application.functions.getlang('asset',192,'Bu e-maili, Dijital Varlıklara eklenen bir dosyaya Alıcı olarak belirtildiğiniz için aldınız Dosyaya aşağıdaki linkten ulaşabilirsiniz')#</cfoutput></cfsavecontent>
		<td align="left">#message#</td>
    </tr>
    <br />
    <tr>
		<td align="left">
        	<cfif get_asset.assetcat_id gte 0>
				<cfset folder="asset/">
            <cfelse>
                <cfset folder="">
            </cfif>
			<cfif not isdefined("arguments.user_domain") and len(arguments.user_domain) eq 0>
				<cfset user_domain = caller.user_domain>
			</cfif>
        	<cfif not len(get_asset.asset_file_path_name)>
				<a href ="#arguments.user_domain#/documents/#folder##get_asset.assetcat_path#/#get_asset.asset_file_name#"><cfoutput>#get_asset.asset_name#</cfoutput></a>
            <cfelse>
            	<cfscript>
	            	get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, "/", "\");
					get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, ":", "$");
				</cfscript>
	            <a href ="#arguments.user_domain#/documents/#folder##get_asset.asset_file_path_name#"><cfoutput>#get_asset.asset_name#</cfoutput></a>
            </cfif>
		</td>
	</tr>
</table>
<br/>
<table width="100%">
	<tr align="left">
		<td><cfinclude template="../../objects/display/view_company_info.cfm">&nbsp;</td>
	</tr>
	<tr height="50" valign="bottom">
		<td><font class="css2">
				#application.functions.getlang('main',663,'Bu mesaj')#
				<cfoutput>#session.ep.company#</cfoutput>
				#application.functions.getlang('main',664,'sistemi tarafından otomatik olarak gönderilmiştir')#<br/>
				#application.functions.getlang('main',665,'Eger bir sorun oldugunu dusunuyorsaniz lutfen maili siliniz')#<br/>
			</font>		
		</td>
	</tr>
</table>
</cfoutput>
