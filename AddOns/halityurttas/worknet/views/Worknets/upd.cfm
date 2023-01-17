<cfquery name="get_worknet" datasource="#dsn#">
	SELECT 
    	WORKNET_ID, 
        WORKNET, 
        IS_INTERNET, 
        WORKNET_STATUS, 
        WEBSITE, 
        MANAGER, 
        MANAGER_EMAIL, 
        DETAIL, 
        WORKNET_SABLON_FILE, 
        WORKNET_CSS_FILE, 
        WORKNET_SITE_NAME, 
        WORKNET_HEADER_HEIGHT, 
        WORKNET_PAGE_WIDTH 
    FROM 
    	WORKNET 
    WHERE 
    	WORKNET_ID = #attributes.worknet_id#
</cfquery>
<cf_catalystHeader>
<cfform name="upd_worknet" method="post">
    <input type="hidden" name="worknet_id" id="worknet_id" value="<cfoutput>#get_worknet.worknet_id#</cfoutput>">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-worknet">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='17.Worknet Adı'> *</label>
                    <div class="col col-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang no ='18.Worknet Adı Girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" name="worknet" required="yes" message="#message#" style="width:150px;" value="#get_worknet.worknet#">
                    </div>
                </div>
                
                <div class="form-group" id="item-website">
                    <label class="col col-4 col-xs-12"><cf_get_lang no="302.Web Site"></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="website" maxlength="30" style="width:150px;" value="#get_worknet.website#">
                    </div>
                </div>
                
                <div class="form-group" id="item-manager">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="manager" value="#get_worknet.manager#" style="width:150px;">
                    </div>
                </div>
                <div class="form-group" id="item-manager_email">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='22.Yönetici E-mail'></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="manager_email" value="#get_worknet.manager_email#" style="width:150px;">
                    </div>
                </div>
                
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
                    <div class="col col-8 col-xs-12">
                    <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                    </div>
                </div>
                <div class="form-group" id="item-worknet_status">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='81.Aktif'></label>
                    <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="worknet_status" id="worknet_status" value="1" <cfif len(get_worknet.worknet_status) and get_worknet.worknet_status>checked</cfif>>
                    
                    </div>
                </div>
                <div class="form-group" id="item-is_internet">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='25.İnternet Yayın'></label>
                    <div class="col col-8 col-xs-12">
                    <input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif len(get_worknet.is_internet) and get_worknet.is_internet>checked</cfif>>
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                    <textarea name="detail" id="detail" style="width:150px;height:75px;"><cfoutput>#get_worknet.detail#</cfoutput></textarea>
                    </div>
                </div>
                </div>
            </div>
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-domain">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="480.Domain"> *</label>
                    <div class="col col-8 col-xs-12">
                    <select name="domain" id="domain" style="width:150px;">
                    <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                        <!---
                        <cfloop list="#worknet_url#" index="x" delimiters=";">
                            <cfoutput><option value="#x#" <cfif x is '#get_worknet.WORKNET_SITE_NAME#'>selected</cfif>>#x#</option></cfoutput>
                        </cfloop>
                    --->
                    </select>
                    </div>
                </div>
                <div class="form-group" id="item-sablon_file">
                    <label class="col col-4 col-xs-12"><cf_get_lang no="304.Genel Şablon Dosyası"></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="sablon_file" id="sablon_file" style="width:150px;" value="#get_worknet.WORKNET_SABLON_FILE#">
                    </div>
                </div>
                <div class="form-group" id="item-header_height">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="573.Üst"> <cf_get_lang_main no="284.Yükseklik"></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="header_height" value="#get_worknet.WORKNET_HEADER_HEIGHT#" onKeyUp="isNumber(this);" validate="integer" style="width:30px;" maxlength="4">
                    </div>
                </div>
                </div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                <div class="form-group" id="item-css_file">
                    <label class="col col-4 col-xs-12"><cf_get_lang no="306.CSS Dosyası"></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="css_file" id="css_file" style="width:150px;" value="#get_worknet.WORKNET_CSS_FILE#">
                    </div>
                </div>
                <div class="form-group" id="item-general_width">
                    <label class="col col-4 col-xs-12"><cf_get_lang no="305.Sayfa Genişliği"></label>
                    <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="general_width" value="#get_worknet.WORKNET_PAGE_WIDTH#" onKeyUp="isNumber(this);" validate="integer" style="width:30px;" maxlength="4">
                    </div>
                </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </div>
            </div>
            </div>
        </div>
        
        </div>
    
</cfform>

<script type="text/javascript">
function kontrol()
{
		return process_cat_control();
}
</script>
