<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35"> 
    <tr>
        <td class="headbold"><cf_get_lang no='860.Background'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_background"><img src="/images/plus1.gif" alt="<cf_get_lang no='320.Background Ekle'>" border="0"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td width="200" valign="top" class="color-row">
            <cfinclude template="../display/list_backgrounds.cfm">
        </td>
        <td valign="top" class="color-row">
        <cfquery name="BACKGROUND" datasource="#dsn#">
            SELECT 
        	    BACKGROUND_ID, 
                BACKGROUND_NAME, 
                BACKGROUND_FILE, 
                BACKGROUND_FILE_SERVER_ID, 
                PORTAL, 
                PAGE 
            FROM 
    	        SETUP_BACKGROUND 
            WHERE 
	            BACKGROUND_ID = #attributes.BACKGROUND_ID#
        </cfquery>
			<cfoutput>
                <table>
                    <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_background" method="post" name="background" enctype="multipart/form-data">
                    <input type="hidden" value="#attributes.background_id#" name="background_id" id="background_id">
                        <tr>
                            <td width="75"><cf_get_lang no='321.İmaj Adı'>*</td>
                            <td>
                            <cfsavecontent variable="message"><cf_get_lang no='725.İmaj Adı girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="background_name" maxlength="50" required="Yes" message="#message#" style="width:200;" value="#BACKGROUND.background_name#"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='1965.İmaj'></td>
                            <td><input type="file" name="background_file" id="background_file" style="width:200;"></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='323.Portal'></td>
                            <td><input type="radio" name="portal" id="portal" value="1" <cfif background.portal eq 1>checked</cfif>>
                                EP 
                                <input type="radio" name="portal" id="portal" value="2" <cfif background.portal eq 2>checked</cfif>>
                                PP 
                                <input type="radio" name="portal" id="portal" value="3" <cfif background.portal eq 3>checked</cfif>>
                                WW
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='324.Konum'></td>
                            <td>
                                <select name="page" id="page" style="width:200;">
                                    <cfloop from="1" to="25" index="i">
                                        <option value="#i#" <cfif background.page eq i>selected</cfif>>#i#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                        <cfif len(background.background_file)>
                            <input type="hidden" value="#background.background_file#" name="old_background" id="old_background">
                            <input type="hidden" value="#background.background_file_server_id#" name="old_background_server_id" id="old_background_server_id">
                            <tr>
                                <td>&nbsp;</td>
                                <td>	
                                    <a href="javascript://" onClick="windowopen('#file_web_path#settings/#background.background_file#','medium')" class="tableyazi"><cf_get_lang no='601.Aktif Background'></a>
                                </td>
                            </tr>
                        </cfif>
                        <tr>
                            <td height="35" colspan="2" align="right" style="text-align:right;">
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_background&background_id=#attributes.background_id#'>
                            </td>
                        </tr>
                    </cfform>
                </table>
            </cfoutput>
        </td>
    </tr>
</table>
