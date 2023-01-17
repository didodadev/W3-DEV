<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.menu_id" default="">
<cfparam name="attributes.partner_position_id" default="">
<cfparam name="attributes.company_catid" default="">
<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT 
    	PARTNER_POSITION_ID, 
        PARTNER_POSITION, 
        DETAIL,
        IS_UNIVERSITY, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_PARTNER_POSITION 
    ORDER BY 
    	PARTNER_POSITION
</cfquery>
<cfquery name="GET_MAIN_MENU" datasource="#DSN#">
	SELECT MENU_NAME, MENU_ID FROM MAIN_MENU_SETTINGS 
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
    SELECT DISTINCT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>

<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_main_menu_layouts" datasource="#dsn#">
        SELECT 
        	LAYOUT_ID, 
            FACTION, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            MENU_ID 
        FROM 
    	    MAIN_SITE_LAYOUTS 
        WHERE 
	        MENU_ID = #attributes.menu_id# 
        ORDER BY 
        	LAYOUT_ID
    </cfquery>
<cfelse>
	<cfset get_main_menu_layouts.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="filter" action="#request.self#?fuseaction=settings.partner_user_denied" method="post">
            <cf_box_search more="0">
                <input type="hidden" name="is_submit" id="is_submit" value="1">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
                        <input type="text" name="partner_name" id="partner_name" placeholder="<cfoutput>#getLang('main',246)#</cfoutput>" value="<cfoutput>#attributes.partner_name#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis btnPointer"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_id=filter.partner_id&field_name=filter.partner_name&select_list=2</cfoutput>','list')"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="company_catid" id="company_catid">
                        <option value=""><cf_get_lang_main no='1197.Üye Kategorisi'></option>
                        <cfoutput query="GET_COMPANYCAT">
                        <option value="#companycat_id#" <cfif companycat_id eq attributes.company_catid>selected</cfif>>#companycat#</option>
                        </cfoutput>
                    </select>
                </div>   
                <div class="form-group">
                    <select name="partner_position_id" id="partner_position_id">
                        <option value=""><cf_get_lang_main no='161.Görev/Pozisyon'></option>
                        <cfoutput query="get_partner_positions">
                        <option value="#partner_position_id#" <cfif partner_position_id eq attributes.partner_position_id>selected</cfif>>#partner_position#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="menu_id" id="menu_id">
                        <option value=""><cf_get_lang_main no='1874.Siteler'>*</option>
                        <cfoutput query="get_main_menu">
                        <option value="#menu_id#" <cfif attributes.menu_id eq menu_id>selected</cfif>>#menu_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='kontrol()' button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('settings',202)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_partner">
                <input type="hidden" name="position_id_" id="position_id_" value="<cfoutput>#attributes.partner_position_id#</cfoutput>">
                <input type="hidden" name="companycat_id_" id="companycat_id_" value="<cfoutput>#attributes.company_catid#</cfoutput>">
                <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.partner_id#</cfoutput>">
                <input type="hidden" name="menu_id_" id="menu_id_" value="<cfoutput>#attributes.menu_id#</cfoutput>">
                <thead>
                    <tr>
						<th><cf_get_lang_main no ='169.Sayfa'></th>
						<th><cf_get_lang_main no ='279.Dosya'></th>
                    	<th width="200"><cf_get_lang no ='2768.Görmesin'></th>
                    </tr>
                </thead>
                <cfif get_main_menu_layouts.recordcount>
                    <tbody>
                        <cfoutput query="get_main_menu_layouts">
                            <cfquery name="get_layout_name" datasource="#dsn#">
                            SELECT OBJECT_NAME FROM MAIN_SITE_LAYOUTS_SELECTS WHERE FACTION = '#faction#' AND MENU_ID = #attributes.menu_id#
                            </cfquery>
                            <cfquery name="get_denied_position" datasource="#dsn#">
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
                                DENIED_PAGE = 'objects2.#faction#' AND
                                <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                                    PARTNER_ID = #attributes.partner_id# 
                                <cfelseif isdefined('attributes.partner_position_id') and len(attributes.partner_position_id)> 
                                    PARTNER_POSITION_ID = #attributes.partner_position_id#
                                <cfelse>
                                    COMPANY_CAT_ID = #attributes.company_catid#
                                </cfif>
                            </cfquery>
                            <tr>
                                <td>#get_layout_name.object_name#</td>
                                <td>#faction#</td>
                                <td><input type="checkbox" name="is_view" id="is_view" value="#faction#" <cfif len(get_denied_position.is_view) and get_denied_position.is_view eq 1>checked</cfif>></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                    <tr>
                        <td colspan="3"><cf_workcube_buttons is_upd='0' type_format="1"></td>
                    </tr>
                    </tfoot>
                <cfelse>
                    <tbody>
                        <tr>
                        <td colspan="3"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
                        </tr>
                    </tbody>
                </cfif>
            </cfform>
        </cf_grid_list>
    </cf_box>
</div>
<script type="text/javascript">
document.getElementById('partner_name').focus();
function kontrol()
{
	x = document.filter.partner_position_id.selectedIndex;
	y = document.filter.menu_id.selectedIndex;
	z = document.filter.company_catid.selectedIndex;
	if(document.filter.partner_id.value == '' && document.filter.partner_position_id[x].value == '' && document.filter.company_catid[z].value == '')
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='246.Üye'>, <cf_get_lang_main no='1197.Üye Kategorisi'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='161.Görev/Pozisyon'>");
		return false;	
	}
	if(document.filter.partner_position_id[x].value != '' && (document.filter.partner_id.value != '' || document.filter.company_catid[z].value != ''))
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='246.Üye'>, <cf_get_lang_main no='1197.Üye Kategorisi'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='161.Görev/Pozisyon'>");
		return false;	
	}
	if(document.filter.partner_id.value != '' && (document.filter.partner_position_id[x].value != '' || document.filter.company_catid[z].value != ''))
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='246.Üye'>, <cf_get_lang_main no='1197.Üye Kategorisi'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='161.Görev/Pozisyon'>");
		return false;	
	}
	if(document.filter.company_catid[z].value != '' && (document.filter.partner_position_id[x].value != '' || document.filter.partner_id.value != ''))
	{
		alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang_main no='246.Üye'>, <cf_get_lang_main no='1197.Üye Kategorisi'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='161.Görev/Pozisyon'>");
		return false;	
	}
	if (document.filter.menu_id[y].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang no='2687.Site Seçmelisiniz'>");
		return false;
	}
	return true;
}
</script>

<!---<cfquery name="get_partners" datasource="#dsn#">
  SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER
</cfquery>
<cfquery name="get_company_cat" datasource="#dsn#">
  SELECT COMPANYCAT,COMPANYCAT_ID FROM COMPANY_CAT
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td height="35">
<table width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='202.Partner Kullanıcı Kısıtları'></td>
    <td>&nbsp;</td>
  </tr>
</table>
	</td>
  </tr>
  <tr>
    <td>
        <table width="98%"  border="0" cellpadding="2" cellspacing="1" height="100%" class="color-border" align="center" >
		 <cfset list=''>   
 		 <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_partner">
          <tr class="color-row">            
            <td valign="top" width="50%">
			  <table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <tr class="color-list">
				    <td height="20" colspan="4">
					<table>
                <tr>
                  <td><cf_get_lang_main no='169.Sayfa'>
				  </td>
               
				  <td>
                    <input type="text" name="modul_name" value="" style="width:100px;">
                  </td>
                  <td>
                    <input type="text" name="faction" value="" style="width:160px;">
                    <input type="hidden" name="faction_id" value="">
                  </td>
                  <td><a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=add_faction.faction_id&field_faction=add_faction.faction&field_modul=add_faction.modul_name</cfoutput>','medium');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='193.Fuseaction Ekle'>" border="0"></a></td>
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
			  <cfoutput query="get_company_cat">
				<tr class="color-list">
				    <td>
					  <a href="javascript://" onClick="gonder_popup('#COMPANYCAT_ID#');return false">#COMPANYCAT#</a>
					</td>
				  <td align="center"><input type="checkbox" name="is_view_" value="#COMPANYCAT_ID#"></td>
					 <td align="center"><input type="checkbox" name="is_insert_" value="#COMPANYCAT_ID#"></td>
					  <td align="center"><input type="checkbox" name="is_delete_" value="#COMPANYCAT_ID#"> </td>     
				</tr>
			 </cfoutput>	
			  <input type="hidden" name="LIST" value="<cfoutput>#valuelist(get_company_cat.COMPANYCAT_ID)#</cfoutput>">
			  <input type="hidden" name="id" value="">
				<tr align="right" class="color-list">
			      <td height="35" colspan="4">
				  <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	</cfform>
  </table>

<script type="text/javascript">
  function kontrol()
   {
     if (add_faction.faction.value.length == 0)
	  {
	  alert("<cf_get_lang no='1455.Sayfa Seçiniz'> !");
		return false;
	  }
	  return true;
   }
  function gonder_popup(company_cat_id)
  {
  	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_partner_user_denied&id=' + company_cat_id + '&modul_name=' + add_faction.modul_name.value + '&faction=' + add_faction.faction.value,'list');
  }
</script>--->
