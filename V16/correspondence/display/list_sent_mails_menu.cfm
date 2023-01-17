<table width="98%" align="center">
	<tr>
        <td height="35" class="headbold"><cf_get_lang_main no='1884.CubeMail'></td>
        <td style="text-align:right;">

        </td>
    </tr>	
</table>	
<table width="98%" align="center">
	<tr>
		<td valign="top" width="200" >
        	<cf_box title="Folder" style="height:300px;" body_style="height:300px;" closable='0' ><cfinclude template="../display/mails_menu_tr.cfm"></cf_box>
            <cf_box>
                <form name="form_kategori_sec" method="post" action="">
                <cfquery name="get_cat" datasource="#DSN#">
                    SELECT TEMPLATE_ID, TEMPLATE_HEAD, TEMPLATE_CONTENT FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE=39 ORDER BY TEMPLATE_HEAD
                </cfquery>
                    <select name="TEMPLATE_ID" id="TEMPLATE_ID" style="width:185px;" onChange="document.send_mail.message.value='';form_kategori_sec.submit();">
                        <option value="" selected ><cf_get_lang_main no='1228.Şablon'>
                        <cfoutput query="get_cat">
                            <option value="#TEMPLATE_ID#"<cfif isDefined("attributes.TEMPLATE_ID") and (attributes.TEMPLATE_ID eq TEMPLATE_ID)> selected</cfif>>#TEMPLATE_HEAD# 
                        </cfoutput>
                    </select>
                </form>
        	</cf_box>
        </td>
        <td valign="top">
        	<cfinclude template="mail_compose.cfm">
		</td>
	</tr>
</table>
