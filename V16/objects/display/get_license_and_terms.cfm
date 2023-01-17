<cfset workcube_license = createObject("V16.settings.cfc.workcube_license") />
<cfset get_license_information = workcube_license.get_license_information() />

<cfif isDefined("attributes.acceptLicense") and attributes.acceptLicense eq 1>
    <cftransaction>
        <cfset save_approve_info = workcube_license.save_approve_info() />

        <cfif save_approve_info.status>

            <cfhttp url="https://networg.workcube.com/wex.cfm/subscription_approve/add_subscription_approve" result="resp" charset="utf-8">
                <cfhttpparam name="company_id" type="formfield" value="5">
                <cfhttpparam name="subscription_no" type="formfield" value="#get_license_information.WORKCUBE_ID#">
                <cfhttpparam name="app_domain" type="formfield" value="#cgi.server_name#">
                <cfhttpparam name="app_name_surname" type="formfield" value="#session.ep.name# #session.ep.surname#">
                <cfhttpparam name="release_no" type="formfield" value="#get_license_information.RELEASE_NO#">
                <cfhttpparam name="patch_no" type="formfield" value="#get_license_information.PATCH_NO#">
            </cfhttp>

            <cfset response = structNew() />

            <cfif resp.Statuscode eq '200 OK'>
                <cfset responseWexJson = resp.FileContent />
                <cfset responseWex = deserializeJson(responseWexJson) />
                <cfif responseWex.status>
                    <cfset response = { status: true, message: "#getLang('','Onayınız için teşekkürler',64762)#" } />
                <cfelse>
                    <cftransaction action="rollback"/>
                    <cfset response = responseWex />
                </cfif>
            <cfelse>
                <cftransaction action="rollback"/>
                <cfset response = { status: false, message: "#getLang('','Bir hata oluştu: ER1002',52126)#" } />
            </cfif>
            
        <cfelse>
            <cftransaction action="rollback"/>
            <cfset response = { status: false, message: "#getLang('','Bir hata oluştu: ER1001',52126)#" } />
        </cfif>

    </cftransaction>
    <cfoutput>#replace(serializeJSON(response),'//','')#</cfoutput>
    <cfabort>
</cfif>

<cf_box title = "#getLang('','Lisans ve kullanım koşulları',64745)#" closable = "1" collapsable = "0" resize = "0" settings = "0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfscript>
        content = fileRead("#download_folder#/licence.txt",'UTF-8');
    </cfscript>
    <div class="ui-info-text scrollContent padding-5" style="height:500px;">
        <p><cfoutput>#replace(content,Chr(13)&Chr(10),"<br>","all")#</cfoutput></p>
    </div>
    <form id="formLicenseAndTerms" name="formLicenseAndTerms" action="">
        <cf_box_footer>
            <cfif get_license_information.IS_APPROVE eq 1>
                <div class="col col-12 mt-3">
                    <cf_get_lang dictionary_id='64851.Lisans ve Kullanım Sözleşmesi kabul edilmiş'>.
                    <cf_get_lang dictionary_id='64852.Sözleşme Kabul Tarihi'>: <cfoutput>#dateformat(get_license_information.APPROVED_DATE,dateformat_style)# #timeformat(get_license_information.APPROVED_DATE,timeformat_style)#</cfoutput>,
                    <cf_get_lang dictionary_id='64853.Sözleşmeyi Onaylayan'>: <cfoutput>#get_license_information.APPROVED_NAME_SURNAME#</cfoutput>
                </div>
            <cfelse>
                <div class="col col-4 col-md-12 col-xs-12">
                    <label class="mt-3"><input type="checkbox" name="acceptLicense" id="acceptLicense" value="1"><cf_get_lang dictionary_id='64751.Lisans ve Kullanım Koşullarını kabul ediyorum'></label>
                    <cf_workcube_buttons add_function="kontrol()">
                </div>
            </cfif>
        </cf_box_footer>
    </form>
</cf_box>

<script>
    function kontrol(){
        if($("input[name = acceptLicense]").is(":checked")){
            var data = new FormData();
            data.append("acceptLicense", 1);
            AjaxControlPostDataJson('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=getLicenseAndTerms', data, function(response){
                alert(response.MESSAGE);
                if(response.STATUS) location.reload();
            });
        }else{
            alert("<cf_get_lang dictionary_id='64766.Lütfen Lisans ve Kullanım Koşulları sözleşmesini onaylayınız'>!");
        }
        return false;
    }

    <cfif get_license_information.IS_APPROVE eq 1>
        $("form[name = formLicenseAndTerms] input[name = wrk_submit_button]").prop("disabled", true);
    </cfif>
</script>