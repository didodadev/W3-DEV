<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%s">
  	<tr class="color-row">
    	<td valign="top">
			<cfif not isdefined("attributes.id")>
                <cfexit method="exittemplate">
            </cfif>
            <cfquery name="get_PAR_ID" datasource="#DSN#">
                SELECT 
        	        PARTNER_ID, 
                    COMPANY_PARTNER_NAME, 
                    COMPANY_PARTNER_SURNAME
                FROM 
    	            COMPANY_PARTNER 
                WHERE 
	                COMPANYCAT_ID =  #attributes.id#
            </cfquery>
            <cfquery name="get_cat_name" datasource="#dsn#">
                SELECT COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID = #attributes.id#
            </cfquery>
            <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_par_id_denied&faction=#faction#&com_cat_id=#attributes.id#">
                <table cellspacing="1" cellpadding="2" width="100%" border="0">
                    <tr class="color-list">
                        <td height="20" colspan="5" >
                        <table>
                            <tr>
                                <td><cf_get_lang_main no='169.Sayfa'></td>
                                <td><input type="text" name="modul_name" id="modul_name" value="<cfoutput>#attributes.modul_name#</cfoutput>" style="width:100px;" readonly="yes"></td>
                                <td>
                                    <input type="text" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>" style="width:160px;" readonly="yes">
                                    <input type="hidden" name="faction_id" id="faction_id" value="">
                                </td>
                                <td><cf_get_lang_main no='1085.Pozisyon'> :<cfoutput>#get_cat_name.companycat#</cfoutput></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                    <tr class="color-header">
                        <td class="form-title" width="50%"><cf_get_lang no='42.Partnerlar'> </td>
                        <td class="form-title" width="50"> <cf_get_lang no='2860.View'>&nbsp;&nbsp;</td>
                        <td class="form-title" width="50"> <cf_get_lang no='2861.Insert'></td>
                        <td class="form-title" width="50"> <cf_get_lang no='2862.Delete'></td>
                    </tr>
                    <cfif get_PAR_ID.RECORDCOUNT>
                    <cfoutput query="get_PAR_ID">
                    <cfquery name="GET_NAME" datasource="#DSN#">
                        SELECT PARTNER_ID,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #PARTNER_ID#
                    </cfquery>
                    <cfset faction1 = '#attributes.modul_name#.#attributes.faction#'>
                    <cfquery name="CONTROL" datasource="#DSN#">
                        SELECT 
        	                DENIED_PAGE_ID, 
                            PARTNER_ID, 
                            DENIED_PAGE, 
                            IS_VIEW, 
                            IS_INSERT, 
                            IS_DELETE 
                        FROM 
    	                    COMPANY_PARTNER_DENIED 
                        WHERE 
	                        PARTNER_ID = #PARTNER_ID# AND  DENIED_PAGE ='#faction1#' AND COMPANY_CAT_ID IS NULL
                    </cfquery>
                    <tr class="color-list">
                        <td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#GET_NAME.PARTNER_ID#','medium')" class="tableyazi">#GET_NAME.COMPANY_PARTNER_NAME# #GET_NAME.COMPANY_PARTNER_SURNAME#</a></td>
                        <td><input type="checkbox" name="is_view_" id="is_view_" value="#PARTNER_ID#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked </cfif>></td>
                        <td><input type="checkbox" name="is_insert_" id="is_insert_" value="#PARTNER_ID#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked</cfif>></td>
                        <td><input type="checkbox" name="is_delete_" id="is_delete_" value="#PARTNER_ID#"  <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked </cfif>></td>
                    </tr>
                    </cfoutput>
                    <input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_PAR_ID.PARTNER_ID)#</cfoutput>">
                    
                </cfif>
                    <tr class="color-list">
                        <td height="20" colspan="5" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </table>
            </cfform>
		</td>
	</tr>
</table>
