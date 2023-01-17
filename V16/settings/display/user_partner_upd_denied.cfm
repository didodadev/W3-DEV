<cfquery name="GET_DENIED_PAGE" datasource="#DSN#">
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
        DENIED_PAGE  = '#url.faction#' 
</cfquery>
<cfquery name="GET_CAT_NAME" datasource="#DSN#">
	SELECT COMPANYCAT,COMPANYCAT_ID FROM COMPANY_CAT 
</cfquery>
<cfset LIST = valuelist(get_denied_page.company_cat_id)>
<script type="text/javascript">
function send_to_frame(cat_id)
{
	add_faction.id.value = cat_id;
	add_faction.target='partner_ids';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.popup_partner_user_denied1&iframe=1</cfoutput>';
	add_faction.submit();
	add_faction.target='_self';
	add_faction.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_partner_perm_faction1</cfoutput>';
}
</script>
<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
	<tr>
		<td class="headbold"><cf_get_lang no='202.Partner Kullanıcı Kısıtları'></td>
	</tr>
</table>
<cfset list=''>   
<table width="98%" align="center" border="0" cellpadding="2" cellspacing="1" class="color-border">
    <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_partner_upd_denied&&faction=#get_denied_page.denied_page#">
        <tr class="color-list">
            <td height="20" colspan="4">
            <table>
                <tr>
                    <td><cf_get_lang_main no='169.Sayfa'></td>
                    <td><input type="text" name="modul_name" id="modul_name" value="<cfoutput>#listfirst(get_denied_page.denied_page,".")#</cfoutput>" style="width:100px;"></td>
                    <td>
                        <input type="text" name="faction" id="faction" value="<cfoutput>#listlast(get_denied_page.denied_page,".")#</cfoutput>" style="width:160px;">
                        <input type="hidden" name="faction_id" id="faction_id" value="">
                    </td>
                    <td>
                        <cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>
                            <a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=add_faction.faction_id&field_faction=add_faction.faction&field_modul=add_faction.modul_name</cfoutput>','medium');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='193.Fuseaction Ekle'>" border="0"></a>
                        </cfif>
                    </td>
                </tr>
            </table>
            </td>
        </tr>
        <tr class="color-header">
            <td class="form-title" width="100%" height="20"><cf_get_lang no='42.Partnerlar'></td>
            <td class="form-title" width="50"> View&nbsp;&nbsp;</td>                    
            <td class="form-title" width="50"> Insert</td> 
            <td class="form-title" width="50"> Delete</td> 
        </tr>
    <cfoutput query="get_cat_name">
        <tr class="color-list">
            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_partner_user_denied1&id=#companycat_id#&faction=#listLAST(get_denied_page.denied_page,".")#&modul_name=#listfirst(get_denied_page.denied_page,".")#','list');return false">#companycat#</a></td>
            <td align="center">
                <cfquery name="GET_COM_CAT_CONTROL" datasource="#DSN#">
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
	                    DENIED_PAGE = '#URL.FACTION#' AND COMPANY_CAT_ID = #companycat_id#
                </cfquery>
                <input type="checkbox" name="is_view_" id="is_view_" value="#companycat_id#"  <cfif get_com_cat_control.recordcount and get_com_cat_control.is_view eq 1> checked</cfif>>
            </td>
            <td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#companycat_id#" <cfif get_com_cat_control.recordcount and get_com_cat_control.is_insert eq 1> checked</cfif>></td>
            <td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#companycat_id#" <cfif get_com_cat_control.recordcount and get_com_cat_control.is_delete eq 1> checked</cfif>></td>
        </tr>
    </cfoutput>	
    <input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_cat_name.companycat_id)#</cfoutput>">
    <input type="hidden" name="id" id="id" value="">
        <tr class="color-list">
            <td height="20" colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
        </tr>
    </cfform>
</table>
