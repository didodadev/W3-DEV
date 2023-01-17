<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\definitions.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site tanımları taşıyıcı file, tab sekmeleri ayrı dosyadadır
    Notes :         AddOns\Yazilimsa\Protein\view\sites\tabs içerisindekiler tablara include edilir
--->
<script src="/JS/assets/plugins/vue.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js"></script>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css?v=06082021" />
<cf_box title="#getLang('','Tanımlar',57529)#">
    <div class="ui-form-list  ui-form-block row">
        <cf_tab defaultOpen="definitions" divId="definitions,lang_and_money,access,theme,security,privacy,mail_settings,params_settings" divLang="#getLang('','Genel Tanımlar',59018)#;#getLang('','',62319)#;#getLang('','Erişim',43251)#;#getLang('','Tema',35634)#;#getLang('','Güvenlik',58151)#;#getLang('','Gizlilik',64611)#;Mail;#getLang('','Parametreler',64052)#">       
            <div id="unique_definitions" class="ui-info-text uniqueBox">
                <cfinclude  template="tabs/general_definations.cfm">
            </div>
            <div id="unique_lang_and_money" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/lang_and_money.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_access" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/access.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_theme" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/theme.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_security" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/security.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_privacy" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/privacy.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_mail_settings" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/mail.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div>
            <div id="unique_params_settings" class="ui-info-text uniqueBox">
                <cfif isdefined('attributes.site') and len(attributes.site)>
                    <cfinclude  template="tabs/protein_params.cfm">
                <cfelse>
                    <cf_get_lang dictionary_id='62289.Önce Site Oluşturunuz'>
                </cfif>
            </div> 
                 
        </cf_tab>
        <div class="row formContentFooter">           
            <cfif attributes.event eq 'upd'>
                <div class="col col-6">
                    <cfset GET_SITE_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_SITE_RECORD_INFO(SITE:attributes.site)>
                    <cf_record_info query_name="GET_SITE_RECORD_INFO">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinAppGeneralDefinitions.deleteSiteConfirm()" add_function="save_tabs()">
                </div>
                <cfelse>
                <div class="col col-12">   
                    <cf_workcube_buttons add_function="save_tabs()">
                </div>
            </cfif>
        </div>
    </div>
</cf_box>

<script>
    function save_tabs() {
        <cfif attributes.event eq "upd">
            proteinAppGeneralDefinitions.save();
            proteinAppAccess.save();
            proteinAppLangAndMoney.save();
            proteinAppTheme.save();
            proteinAppSecurity.save();
            proteinAppMail.save();
            proteinAppPrivacy.save();
            proteinAppParams.save();
        <cfelse>
            proteinAppGeneralDefinitions.save();
            return true;
        </cfif>
    }
</script>