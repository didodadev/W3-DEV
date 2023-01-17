<cfset mail_companies = createObject("component", "V16.settings.cfc.mail_company_settings")>
<cfset GET_MAIL_TEMPLATES= mail_companies.SelectTemplates()/> 


<cfif isDefined('attributes.maid')>
    <cfset mail_content = createObject("component", "V16.settings.cfc.mail_company_settings")>
    <cfset get_mail_content = mail_content.SelectMailContent(#attributes.maid#)/>
</cfif>

<!--- <cfset GET_COMPANY_NAMES= mail_companies.SelectCompany()/> ---> 
<cfparam name="attributes.coid" default="">
<cfparam name="attributes.startdate" default="#day(now())#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#day(now())#/#month(now())#/#session.ep.period_year#">
<cfif len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>

<div class="row">
    <div class="col col-12">
        <a href='?fuseaction=settings.list_mail_companies'>
            <h4 class="wrkPageHeader"><cf_get_lang dictionary_id='57428.E-Posta'><cf_get_lang dictionary_id='48277.Gönderi'></h4>
        </a>
    </div>
</div>

<div class="row">
    <div class="col col-12">
       <cfform name="formMailCompanySettings">
            <cfinput type="hidden" name="today" id="today" value="#dateformat(now(),dateformat_style)#">
            <cfif isDefined('attributes.maid')>  <cfinput type="hidden" name="maid" id="maid" value="#attributes.maid#"></cfif>
            <div class="row">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44440.Gönderi Adı' module_name='settings'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="DELIVERY_NAME" id="DELIVERY_NAME" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.DELIVERY_NAME#</cfoutput></cfif>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="SUBJECT" id="SUBJECT" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.SUBJECT#</cfoutput></cfif>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51070.Gönderen'><cf_get_lang dictionary_id='57428.E-Posta'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="SENDER_EMAIL" id="SENDER_EMAIL" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.SENDER_EMAIL#</cfoutput></cfif>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44482.Görüntülenecek Ad'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="SEEN_NAME" id="SEEN_NAME" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.SEEN_NAME#</cfoutput></cfif>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58654.Cevap'><cf_get_lang dictionary_id='49318.Adresi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="RETURN_ADDRESS" id="RETURN_ADDRESS" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.RETURN_ADDRESS#</cfoutput></cfif>">
                        </div>
                    </div>

                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49330.Şablonlar'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="TEMPLATE_NAME" id="TEMPLATE_NAME">
                                <option value="0"><cf_get_lang_main dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_MAIL_TEMPLATES">
                                    <option value="#TEMPLATE_NAME#" <cfif isDefined('attributes.maid') and TEMPLATE_NAME eq get_mail_content.TEMPLATE_NAME> selected </cfif>>#TEMPLATE_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38340.Mail Gönderim Listesi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="MAIL_LIST" id="MAIL_LIST">
                                <option value="Seçiniz"><cf_get_lang_main dictionary_id='57734.Seçiniz'></option>
                                <option value="Seçmeyiniz">Seçmeyiniz</option>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <div class="col col-12">
                            Gönderimleri tarih parametrelerini girerek zamanlayabilirsiniz. Eğer herhangi bir şey belirtilmemişse gönderim hemen başlatılır.    
                        </div>
                    </div>
                
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">		
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='47474.Tarih Hatalı'></cfsavecontent>
                                <cfif len(attributes.startdate) gt 5>
                                    <cfif isDefined('attributes.maid')>
                                        <cfinput type="text" name="startdate" style="width:65px;" maxlength="10" value="#dateformat(get_mail_content.startdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
                                    <cfelse>
                                        <cfinput type="text" name="startdate" style="width:65px;" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
                                    </cfif>
                                <cfelse>
                                    <cfinput type="text" name="startdate" maxlength="10" value="" validate="#validate_style#" message="#alert#">
                                </cfif>
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="startdate">
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31066.Saat Aralığı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-2 paddingNone">
                                <input type="text" name="STR_FIRST_HOUR" id="STR_FIRST_HOUR" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.STR_FIRST_HOUR#</cfoutput></cfif>">
                            </div>
                            <div class="col col-1">&nbsp;:</div>
                            <div class="col col-2 paddingNone">
                                <input type="text" name="STR_FIRST_MINUTE" id="STR_FIRST_MINUTE" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.STR_FIRST_MINUTE#</cfoutput></cfif>">
                            </div>
                            <div class="col col-1">&nbsp;-</div>
                            <div class="col col-2 paddingNone">
                                <input type="text" name="STR_SECOND_HOUR" id="STR_SECOND_HOUR" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.STR_SECOND_HOUR#</cfoutput></cfif>">
                            </div>
                            <div class="col col-1">&nbsp;:</div>
                            <div class="col col-2 paddingNone">
                                <input type="text" name="STR_SECOND_MINUTE" id="STR_SECOND_MINUTE" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.STR_SECOND_MINUTE#</cfoutput></cfif>">
                            </div>
                        </div>
                    </div>

                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44584.Seçtiğiniz'><cf_get_lang dictionary_id='44585.Günler'></label>
                        <div class="col col-8 col-xs-12 paddingNone">
                            <label><cf_get_lang dictionary_id='57604.Pazartesi'><input type="checkbox" name="is_monday" id="is_monday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_monday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57605.Salı'><input type="checkbox" name="is_tuesday" id="is_tuesday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_tuesday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57606.Çarşamba'><input type="checkbox" name="is_wednesday" id="is_wednesday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_wednesday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57607.Perşembe'><input type="checkbox" name="is_thursday" id="is_thursday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_thursday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57608.Cuma'><input type="checkbox" name="is_friday" id="is_friday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_friday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57609.Cumartesi'><input type="checkbox" name="is_saturday" id="is_saturday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_saturday eq 1>checked</cfif>></label>
                            <label><cf_get_lang dictionary_id='57610.Pazar'><input type="checkbox" name="is_sunday" id="is_sunday" value="1" <cfif isDefined('attributes.maid') and get_mail_content.is_sunday eq 1>checked</cfif>></label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">		
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id='47474.Tarih Hatalı'></cfsavecontent>
                                <cfif len(attributes.finishdate) gt 5>
                                    <cfif isDefined('attributes.maid')>
                                        <cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" value="#dateformat(get_mail_content.finishdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
                                    <cfelse>
                                        <cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
                                    </cfif>
                                <cfelse>
                                    <cfinput type="text" name="finishdate" style="width:65px;" maxlength="10" value="" validate="#validate_style#" message="#alert#">
                                </cfif>
                                <span class="input-group-addon">	
                                    <cf_wrk_date_image date_field="finishdate">
                                </span>	
                            </div>
                        </div>
                        
                    </div>

                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51547.Bitiş Saati'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-2 paddingNone">
                                <input type="text" name="FNS_HOUR" id="FNS_HOUR" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.FNS_HOUR#</cfoutput></cfif>">
                            </div>
                            <div class="col col-1">&nbsp;:</div>
                            <div class="col col-2 paddingNone">
                                <input type="text" name="FNS_MINUTE" id="FNS_MINUTE" value="<cfif isDefined('attributes.maid')><cfoutput>#get_mail_content.FNS_MINUTE#</cfoutput></cfif>">
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="row formContentFooter">
                <div class="pull-right">
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </div>
            </div>
        </cfform>
    </div>
</div>
<script>
    function kontrol()
    {
        var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
        if(document.getElementById('SENDER_EMAIL').value.match(mailformat))
        {
            document.formMailCompanySettings.SENDER_EMAIL.focus();
        }
        else
        {
            alert("<cf_get_lang dictionary_id='51931.Mail Adresini Kontrol Ediniz'> : <cf_get_lang dictionary_id='51070.Gönderen'><cf_get_lang dictionary_id='57428.E-Posta'>");
            return false;
        }
        if(document.getElementById('RETURN_ADDRESS').value.match(mailformat))
        {
            document.formMailCompanySettings.RETURN_ADDRESS.focus();
        }
        else
        {
            alert("<cf_get_lang dictionary_id='51931.Mail Adresini Kontrol Ediniz'> : <cf_get_lang dictionary_id='58654.Cevap'><cf_get_lang dictionary_id='49318.Adresi'>");
            return false;
        }

        if(document.getElementById('STR_FIRST_HOUR').value > 23 || document.getElementById('STR_SECOND_HOUR').value > 23 || document.getElementById('FNS_HOUR').value > 23 || document.getElementById('STR_FIRST_HOUR').value < 0 || document.getElementById('STR_SECOND_HOUR').value < 0 || document.getElementById('FNS_HOUR').value < 0)
        {
            alert("<cf_get_lang dictionary_id='44604.Saat Bilgisi Geçersiz.'>");
            return false;
        }

        if(document.getElementById('STR_FIRST_MINUTE').value > 59 || document.getElementById('STR_SECOND_MINUTE').value > 59 || document.getElementById('FNS_MINUTE').value > 59 || document.getElementById('STR_FIRST_MINUTE').value < 0 || document.getElementById('STR_SECOND_MINUTE').value < 0 || document.getElementById('FNS_MINUTE').value < 0)
        {
            alert("<cf_get_lang dictionary_id='44604.Saat Bilgisi Geçersiz.'>");
            return false;
        }
 
        if(!date_check(formMailCompanySettings.startdate,formMailCompanySettings.finishdate,"<cf_get_lang dictionary_id ='48942.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
        {
            return false;
        }
        if(!date_check(formMailCompanySettings.today,formMailCompanySettings.finishdate,"<cf_get_lang dictionary_id='44591.Lütfen İleri Bir Tarih Giriniz'>"))
        {
            return false;
        }
        if(!date_check(formMailCompanySettings.today,formMailCompanySettings.startdate,"<cf_get_lang dictionary_id='44591.Lütfen İleri Bir Tarih Giriniz'>"))
        {
            return false;
        }
       
        if(document.getElementById('DELIVERY_NAME').value == '')
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='44440.Gönderi Adı' module_name='settings'>");
            return false;
        }
        
        if(document.getElementById('SENDER_EMAIL').value == '')
        {
            alert("<cf_get_lang dictionary_id='51070.Gönderen'><cf_get_lang dictionary_id='57428.E-Posta'>");
            return false;
        }

        
        if(document.getElementById('SEEN_NAME').value == '')
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='44482.Görüntülenecek Ad'>");
            return false;
        }

        if(document.getElementById('RETURN_ADDRESS').value == '')
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58654.Cevap'><cf_get_lang dictionary_id='49318.Adresi'>");
            return false;
        }
        return true;
    }
</script>
