<cfquery name="GET_COMPANY_RIVAL_DETAIL" datasource="#DSN#">
	SELECT 
        RIVAL_ID, 
        COMPANY_ID, 
        SERVICE_NUMBER, 
        RELATION_LEVEL, 
        SPECIAL_INFO
    FROM 
    	COMPANY_RIVAL_DETAIL 
    WHERE 
	    COMPANY_ID = #attributes.cpid# AND RIVAL_ID = #attributes.r_id#
</cfquery>
<cfquery name="GET_ACTS" datasource="#dsn#">
	SELECT 
		COMPANY_RIVAL_ACTIVITY.ACTIVITY_ID, 
		SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE
	FROM 
		COMPANY_RIVAL_ACTIVITY,
		SETUP_ACTIVITY_TYPES
	WHERE 
		COMPANY_RIVAL_ACTIVITY.ACTIVITY_ID = SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE_ID AND
		COMPANY_RIVAL_ACTIVITY.RIVAL_ID = #attributes.r_id# AND 
		COMPANY_RIVAL_ACTIVITY.COMPANY_ID = #attributes.cpid#
	ORDER BY 
		SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE
	DESC
</cfquery>
<cfquery name="GET_OPTIONS" datasource="#dsn#">
	SELECT 
		COMPANY_RIVAL_OPTION_APPLY.OPTION_ID,
		SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON
	FROM 
		COMPANY_RIVAL_OPTION_APPLY,
		SETUP_RIVAL_PREFERENCE_REASONS
	WHERE  
		COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID = #attributes.cpid#  AND 
		COMPANY_RIVAL_OPTION_APPLY.RIVAL_ID = #attributes.r_id# AND 
		COMPANY_RIVAL_OPTION_APPLY.OPTION_ID = SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON_ID
</cfquery>
<cfquery name="GET_REL" datasource="#dsn#">
	SELECT PARTNER_RELATION_ID, PARTNER_RELATION FROM SETUP_PARTNER_RELATION ORDER BY PARTNER_RELATION_ID 
</cfquery>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" class="color-border">
        <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
            <tr class="color-list">
                <td class="headbold" height="35"><cf_get_lang dictionary_id="51623.Rakip Bilgileri"> : <cfif isdefined("attributes.rival_name")><cfoutput>#attributes.rival_name#</cfoutput></cfif></td>
            </tr>
            <tr class="color-row">
                <td valign="top">
                    <table>
                        <cfform name="upd_company_rival_detail" action="#request.self#?fuseaction=crm.emptypopup_upd_company_rival_detail" method="post">
                        <input name="cpid" id="cpid" type="hidden" value="<cfoutput>#attributes.cpid#</cfoutput>">
                        <input name="r_id" id="r_id" type="hidden" value="<cfoutput>#attributes.r_id#</cfoutput>">
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id="43113.Tercih Nedeni"></td>
                            <td rowspan="4" valign="top" width="180">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <select name="option_applied" id="option_applied" style="width:150px;height:100;" multiple>
                                                <cfoutput query="get_options">
                                                    <option value="#option_id#">#preference_reason#</option>
                                                </cfoutput>
                                            </select>
                                        </td>
                                        <td valign="top">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_option_applied_detail&field_name=upd_company_rival_detail.option_applied','small');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a><br/>
                                            <a href="javascript://" onClick="kaldir1();"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand"></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td><cf_get_lang dictionary_id="51722.Servis Sayısı"></td>
                            <td width="160">
                                <select name="service_number" id="service_number" style="width:170;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <option value="1" <cfif get_company_rival_detail.service_number eq 1>selected</cfif>>1</option>
                                    <option value="2" <cfif get_company_rival_detail.service_number eq 2>selected</cfif>>2</option>
                                    <option value="3" <cfif get_company_rival_detail.service_number eq 3>selected</cfif>>3</option>
                                    <option value="4" <cfif get_company_rival_detail.service_number eq 4>selected</cfif>>4</option>
                                    <option value="5" <cfif get_company_rival_detail.service_number eq 5>selected</cfif>>5</option>
                                    <option value="6" <cfif get_company_rival_detail.service_number eq 6>selected</cfif>>6</option>
                                    <option value="7" <cfif get_company_rival_detail.service_number eq 7>selected</cfif>>7</option>
                                    <option value="8" <cfif get_company_rival_detail.service_number eq 8>selected</cfif>>8</option>
                                    <option value="9" <cfif get_company_rival_detail.service_number eq 9>selected</cfif>>9</option>
                                    <option value="10" <cfif get_company_rival_detail.service_number eq 10>selected</cfif>>10</option>
                                    <option value="11" <cfif get_company_rival_detail.service_number eq 11>selected</cfif>>11</option>
                                    <option value="12" <cfif get_company_rival_detail.service_number eq 12>selected</cfif>>12</option>
                                    <option value="13" <cfif get_company_rival_detail.service_number eq 13>selected</cfif>>13</option>
                                    <option value="14" <cfif get_company_rival_detail.service_number eq 14>selected</cfif>>14</option>
                                    <option value="15" <cfif get_company_rival_detail.service_number eq 15>selected</cfif>>15</option>
                                </select>
                            </td>
                         </tr>
                         <tr>
                            <td>&nbsp;</td>
                            <td><cf_get_lang dictionary_id="51738.İlişki Düzeyi"></td>
                            <td>
                                <select name="relation_level" id="relation_level" style="width:170;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_rel">
                                        <option value="#PARTNER_RELATION_ID#" <cfif get_company_rival_detail.RELATION_LEVEL eq PARTNER_RELATION_ID>selected</cfif>>#partner_relation#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td><cf_get_lang dictionary_id="51737.Özel Bilgiler"></td>
                            <td rowspan="6" valign="top"><textarea name="special_info" id="special_info" style="width:170;height:140px;"><cfoutput>#get_company_rival_detail.special_info#</cfoutput></textarea></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id="51723.Yapılan Etkinlikler"></td>
                            <td rowspan="4" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td rowspan="2">
                                            <select name="activity" id="activity" style="width:150px;height=100;" multiple>
                                                <cfoutput query="get_acts">
                                                    <option value="#activity_id#">#activity_type#</option>
                                                </cfoutput>
                                            </select>
                                        </td>
                                        <td valign="top">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_rivals_activity&field_name=upd_company_rival_detail.activity','small');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a><br/>
                                            <a href="javascript://" onClick="kaldir2();"><img src="/images/delete_list.gif" border="0" title="Sil" style="cursor=hand"></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="3">&nbsp;</td>
                            <td><cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='hepsini_sec()'></td>
                        </tr>
                        </cfform>
                    </table>
                </td>
            </tr>
        </table>
    </td>
  </tr>
</table>
<script language="JavaScript" type="text/javascript">
	function hepsini_sec()
	{
	select_all('activity');
	select_all('option_applied');
	}
function select_all(selected_field){
	var m = eval("document.upd_company_rival_detail."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.upd_company_rival_detail."+selected_field+"["+i+"].selected=true")
	}
	x = (500 - document.upd_company_rival_detail.special_info.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='1311.Adres'> "+ ((-1) * x) +" <cf_get_lang no='173.Karakter Uzun !'>");
		return false;
	}
}
function kaldir1()
{
	for (i=document.upd_company_rival_detail.option_applied.options.length-1;i>-1;i--)
	{
		if (document.upd_company_rival_detail.option_applied.options[i].selected==true)
		{
			document.upd_company_rival_detail.option_applied.options.remove(i)
		}	
	}
}
	function kaldir2()
{
	for (i=document.upd_company_rival_detail.activity.options.length-1;i>-1;i--)
	{
		if (document.upd_company_rival_detail.activity.options[i].selected==true)
		{
			document.upd_company_rival_detail.activity.options.remove(i)
			
		}	
	}
}
</script>
