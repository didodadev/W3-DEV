<cfset mail_companies = createObject("component", "V16.settings.cfc.mail_company_settings")>
<cfset get_mail_templates= mail_companies.SelectTemplates(TEMPLATE_ID:attributes.tid)/>
<!--- <cfdump var="#get_mail_templates#" abort> --->
<div class="row">
    <div class="col col-12">
        <h4 class="wrkPageHeader"><cf_get_lang dictionary_id='58640.Şablon'><cf_get_lang dictionary_id='37022.Bilgileri'></h4>
    </div>
</div>
<div class="row">
    <div class="col col-12">
       <cfform name="formAddMailAccount">
            <cfinput type="hidden" name="tid" value="#attributes.tid#">
            <div class="row">
                <div class="col col-12">

                    <div class="form-group">
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='58509.Şablon Adı' module_name='settings'></label>
                        <div class="col col-10 col-xs-12">
                            <input type="text" name="TEMPLATE_NAME" id="TEMPLATE_NAME" value="<cfoutput>#get_mail_templates.TEMPLATE_NAME#</cfoutput>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57480.Konu' module_name='settings'></label>
                        <div class="col col-10 col-xs-12">
                            <input type="text" name="TEMPLATE_SUBJECT" id="TEMPLATE_SUBJECT" value="<cfoutput>#get_mail_templates.TEMPLATE_SUBJECT#</cfoutput>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57653.İçerik'></label>
                        <div class="col col-10 col-xs-12 paddingNone">
                            <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarSet="WRKContent"
                                basePath="/fckeditor/"
                                instanceName="template_content"
                                value="#get_mail_templates.TEMPLATE_CONTENT#"
                                width="99%"
                                height="350">
                        </div>
                    </div>

                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">                
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="pull-right">
                    <cf_workcube_buttons is_upd='1' add_function="kontrol()">
                </div>
            </div>
        </cfform>
    </div>
</div>
<script>
    function kontrol()
        {
            return true;
        }
</script>