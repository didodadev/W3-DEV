<cfquery name="GET_BANK_TYPE" datasource="#DSN#">
	SELECT 
    	BANK_ID, 
        BANK_NAME, 
        DETAIL, 
        COMPANY_ID, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        EXPORT_TYPE, 
        BANK_CODE, 
        FTP_SERVER_NAME, 
        FTP_FILE_PATH, 
        FTP_USERNAME, 
        FTP_PASSWORD,
        BANK_TYPE_GROUP_ID,
        SWIFT_CODE
    FROM 
    	SETUP_BANK_TYPES
    WHERE 
    	BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#</cfoutput>.popup_add_bank_type"><img src="/images/plus1.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12">
<cf_box>
    <cfform name="upd_bank" method="post" action="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.emptypopup_upd_bank_type">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-bank_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="bank_type" style="width:150px;" maxlength="150" value="#get_bank_type.bank_name#">
                    </div>
                </div>
                <div class="form-group" id="item-export_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
                    <div class="col col-8 col-xs-12">
                        <select name="export_type" id="export_type">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="5" <cfif get_bank_type.export_type eq 5>selected</cfif>><cf_get_lang dictionary_id="39541.Akbank"></option>
                            <option value="4" <cfif get_bank_type.export_type eq 4>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
                            <option value="7" <cfif get_bank_type.export_type eq 7>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
                            <option value="6" <cfif get_bank_type.export_type eq 6>selected</cfif>><cf_get_lang dictionary_id="39564.HSBC"></option>
                            <option value="9" <cfif get_bank_type.export_type eq 9>selected</cfif>><cf_get_lang dictionary_id="39564.HSBC">2</option>
                            <option value="10" <cfif get_bank_type.export_type eq 10>selected</cfif>><cf_get_lang dictionary_id="39564.HSBC"><cf_get_lang dictionary_id="57677.Döviz"></option>
                            <option value="11" <cfif get_bank_type.export_type eq 11>selected</cfif>><cf_get_lang dictionary_id="48747.ING"></option>
                            <option value="3" <cfif get_bank_type.export_type eq 3>selected</cfif>><cf_get_lang dictionary_id="60894.İşbank"></option>
                            <option value="2" <cfif get_bank_type.export_type eq 2>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
                            <option value="8" <cfif get_bank_type.export_type eq 8>selected</cfif>><cf_get_lang dictionary_id="42718.Vakıfbank"></option>
                            <option value="1" <cfif get_bank_type.export_type eq 1>selected</cfif>><cf_get_lang dictionary_id="39567.Yapı Kredi"></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-bank_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59006.Banka Kodu'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="bank_code" value="#get_bank_type.bank_code#" onKeyUp="isNumber(this);" maxlength="4" style="width:150px;">
                    </div>
                </div>
                <div class="form-group" id="item-swift_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinput type="text" name="swift_code" id="swift_code" value ="#get_bank_type.swift_code#" maxlength="50">
                    </div>
                </div>
                <div class="form-group" id="item-company_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49909.Kurumsal Üye'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif len(get_bank_type.company_id)><cfoutput>#get_bank_type.company_id#</cfoutput></cfif>">
                            <input type="text" name="company" id="company" value="<cfif len(get_bank_type.company_id)><cfoutput>#get_par_info(get_bank_type.company_id,1,1,0)#</cfoutput></cfif>" style="width:150px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','upd_bank','3','200');">	  
                            <span class="input-group-addon icon-ellipsis btnPointer "onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_bank.company_id&field_comp_name=upd_bank.company&select_list=2','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-bank_TYPE">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34102.Banka Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="get_bank_type_groups" datasource="#dsn#">
                            SELECT * FROM SETUP_BANK_TYPE_GROUPS ORDER BY BANK_TYPE_ID
                        </cfquery>
                        <select name="bank_type_group" id="bank_type_group" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_bank_type_groups">
                                <option value="#BANK_TYPE_ID#" <cfif get_bank_type.BANK_TYPE_GROUP_ID eq BANK_TYPE_ID>selected</cfif>>#BANK_TYPE#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-company_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea style="width:150px;height:30px;" name="detail" id="detail"><cfif len(get_bank_type.detail)><cfoutput>#get_bank_type.detail#</cfoutput></cfif></textarea>
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <cfif len(get_bank_type.company_id)>
                <cfset attributes.cpid = get_bank_type.company_id>
                <cfset is_from_finance = 1>
                    <cf_flat_list id="genel">
                    <tr class="color-row">
                        <td width="3" valign="top"><a href="javascript://" onclick="gizle_goster(member1);"><cf_get_lang dictionary_id="57771.Detay"></a></td>
                        <td valign="top">
                            <div id="member1" style="display:none;"><cfinclude template="../../myhome/display/my_company_detail.cfm"></div>
                        </td>
                    </tr>
                    <tr class="color-row">
                        <td valign="top"><a href="javascript://" onclick="gizle_goster(member2);"><cf_get_lang dictionary_id="58885.Partner"></a></td>
                        <td valign="top">
                            <div id="member2" style="display:none;"><cfinclude template="../../myhome/display/my_company_partner_detail.cfm"></div>
                        </td>
                    </tr>
                    <tr class="color-row">
                        <td valign="top"><a href="javascript://" onclick="gizle_goster(member3);"><cf_get_lang dictionary_id="58723.Adres"></a></td>
                        <td valign="top">
                            <div id="member3" style="display:none;"><cfinclude template="../../myhome/display/my_company_address_detail.cfm"></div>
                        </td>
                    </tr>
                    </cf_flat_list>
                </cfif>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name = "get_bank_type">
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function="controlAddBank()">
        </cf_box_footer>
    </cfform>
</cf_box>
</div>
	
<script type="text/javascript">
function controlAddBank()
{
	if(!$("#bank_type").val().length)
	{
		alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">:<cf_get_lang dictionary_id="57521.Banka">');
		return false;	
	}
	return true;
}
</script>