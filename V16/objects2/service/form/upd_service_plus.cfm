<cfset attributes.id = attributes.service_id>
<cfinclude template="../query/get_service_plus.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfform name="upd_service_plus" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_service_plus">
    <table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
        <input type="Hidden" name="service_plus_id" id="service_plus_id" value="<cfoutput>#get_service_plus.service_plus_id#</cfoutput>">
        <input type="Hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
        <input type="Hidden" name="clicked" id="clicked" value="">
        <tr class="color-border">
            <td>
                <table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
                	<tr class="color-list" style="height:35px;">
                		<td class="headbold">&nbsp;&nbsp;<cf_get_lang no='244.Takip'></td>
                	</tr>
                    <tr class="color-row"> 
                        <td style="vertical-align:top;">
                        	<table>
                                <tr>
                                    <td>
                                        &nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>&nbsp;&nbsp;&nbsp;&nbsp;
                                        <input type="text" name="header" id="header" style="width:250px;"  value="<cfoutput><cfif isDefined("get_service_plus.subject")>#get_service_plus.subject#</cfif></cfoutput>">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='68.Konu'></cfsavecontent>
                                        <cfinput type="text" name="plus_date" id="plus_date" style="width:65px;" value="#dateformat(get_service_plus.plus_date,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message#" readonly>
                                        <select name="commethod_id" id="commethod_id" style="width:140px;">
                                            <option value="0"><cf_get_lang_main no='678.İletişim Yöntemi'></option>
                                            <cfoutput query="get_com_method">
                                            	<option value="#commethod_id#" <cfif commethod_id is get_service_plus.commethod_id> selected</cfif>>#commethod#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align:top;">
                                      	<cfmodule template="../../../fckeditor/fckeditor.cfm"
                                            toolbarset="Basic"
                                            basepath="/fckeditor/"
                                            instancename="plus_content"
                                            valign="top"
                                            value="#get_service_plus.plus_content#"
                                            width="550"
                                            height="300">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="right" style="text-align:right;">
                                        <cf_workcube_buttons 
                                        	is_upd='1' 
                                            delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_service_plus&service_plus_id=#get_service_plus.service_plus_id#'>
                                            &nbsp;&nbsp;&nbsp; 
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>  
	</table>
</cfform>
