<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr class="color-row">
		<td valign="top">
			<cfif not isdefined("attributes.id")>
                <cfexit method="exittemplate">
            </cfif>
            <cfquery name="GET_CAT_IDS" datasource="#DSN#">
                SELECT 
                    COMPANY_PARTNER.PARTNER_ID,
                    COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                    COMPANY_CAT.COMPANYCAT
                FROM 
                    COMPANY_PARTNER,
                    COMPANY_CAT,
                    COMPANY
                WHERE 
                    COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                    COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
                    COMPANY_CAT.COMPANYCAT_ID = #attributes.id#
                ORDER BY 
                    COMPANY_PARTNER_NAME
            </cfquery>
    
            <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_par_id">
                <table cellspacing="1" cellpadding="2" width="100%" border="0">
                    <tr class="color-list">
                        <td height="20" colspan="4" >
                        <table>
                            <tr>
                                <td><cf_get_lang_main no='169.Sayfa'></td>
                                <td><input type="text" name="modul_name" id="modul_name" value="<cfoutput>#attributes.modul_name#</cfoutput>" style="width:100px;" readonly="yes"></td>
                                <td>
                                    <input type="text" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>" style="width:160px;" readonly="yes">
                                    <input type="hidden" name="faction_id" id="faction_id" value="">
                                </td>
                                <td><cf_get_lang_main no='1085.Pozisyon'> :<cfoutput>#get_cat_ids.COMPANYCAT#</cfoutput></td>
                                <td></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                    <tr class="color-header">
                        <td height="20" class="form-title" width="100%"><cf_get_lang no='42.Partnerler'></td>
                        <td class="form-title" width="50"> <cf_get_lang no='2860.View'>&nbsp;&nbsp;</td>
                        <td class="form-title" width="50"> <cf_get_lang no='2861.Insert'></td>
                        <td class="form-title" width="50"> <cf_get_lang no='2862.Delete'></td>
                    </tr>
                    <tr class="color-row">
                        <td class="txtboldblue" height="20" ><cf_get_lang_main no ='669.Hepsi'></td>
                        <td align="center"><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></td>
                        <td align="center"><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert();"></td>
                        <td align="center"><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete();"></td>
                    </tr>
                    <cfset faction1 = '#attributes.modul_name#.#attributes.faction#'>
                    <cfif  get_cat_ids.recordcount>
                        <cfoutput query="get_cat_ids">
                            <cfquery name="CONTROL" datasource="#DSN#">
                                SELECT 
                                    DENIED_PAGE_ID, 
                                    PARTNER_ID, 
                                    PARTNER_POSITION_ID,
                                    COMPANY_CAT_ID, 
                                    MENU_ID, 
                                    DENIED_PAGE, 
                                    IS_VIEW, 
                                    IS_INSERT, 
                                    IS_DELETE
                                FROM 
        	                        COMPANY_PARTNER_DENIED 
                                WHERE 
	                                PARTNER_ID = #get_cat_ids.PARTNER_ID# AND  DENIED_PAGE ='#faction1#' AND  COMPANY_CAT_ID IS NULL
                            </cfquery>
                                <tr class="color-list">
                                    <td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium')" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
                                    <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="#partner_id#" <cfif (control.recordcount) and (control.is_view eq 1)> checked</cfif>></td>
                                    <td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#partner_id#" <cfif (control.recordcount) and (control.is_insert eq 1)> checked</cfif>></td>
                                    <td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#partner_id#" <cfif (control.recordcount) and (control.is_delete eq 1)> checked</cfif>></td>
                                </tr>
                        </cfoutput>
                        <input type="hidden" name="list" id="list" value="<cfoutput>#valuelist(get_cat_ids.partner_id)#</cfoutput>">
                        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                    </cfif>
                    <tr class="color-list">
                        <td align="right" height="35" colspan="4"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </table>
            </cfform>
		</td>
	</tr>
</table>
<script type="text/javascript">
function hepsi_view()
{
	if(document.add_faction.all_view.checked)
	{
		for(i=0;i<document.add_faction.is_view_.length;i++)
			document.add_faction.is_view_[i].checked = true;
	}
	else
	{
		for(i=0;i<document.add_faction.is_view_.length;i++)
			document.add_faction.is_view_[i].checked = false;
	}
}
function hepsi_insert()
{
	if (document.add_faction.all_insert.checked) 
	{
		for(i=0;i<document.add_faction.is_insert_.length;i++)
			document.add_faction.is_insert_[i].checked = true;
	}
	else
	{
		for(i=0;i<document.add_faction.is_insert_.length;i++)
			document.add_faction.is_insert_[i].checked = false;
	}
}
function hepsi_delete()
{
	if (document.add_faction.all_delete.checked)
	{	
		for(i=0;i<document.add_faction.is_delete_.length;i++)
		document.add_faction.is_delete_[i].checked = true;
	}
	else
	{
		for(i=0;i<document.add_faction.is_delete_.length;i++)
		document.add_faction.is_delete_[i].checked = false;
	}
}
</script>
