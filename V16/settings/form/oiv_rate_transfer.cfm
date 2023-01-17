
<!--- File:V16\settings\form\oiv_rate_transfer.cfm
Author: Fatma zehra Dere
Date:30/12/2020
Description:
öiv oranlarının aktarıldığı sayfadır
History:
To Do: ---> 
<cfparam  name="attributes.form_submitted" default="">
<cfset comp  = createObject("component","V16.settings.cfc.oiv_rate_transver") />
<cfset get_companies = comp.get_companies()/>
<cf_box title="#getLang(dictionary_id:61525)#"  >    
    <div class="col col-12 col-xs-12">
        <cfform name="form_" id= "form_" action="" method="post">
            <cf_box_elements>    
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-comp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang  dictionary_id="43260.Hedef Dönem"></label>
                        <div class="col col-8 col-xs-12">  
                            <select name="item_company_id" id="item_company_id" tabindex="60" onchange="show_periods_departments(1)">
                                <cfoutput query="get_companies">
                                    <option value="#comp_id#" <cfif isdefined("attributes.item_company_id") and attributes.item_company_id eq comp_id>selected <cfelseif comp_id eq session.ep.company_id>selected</cfif>>#company_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-hedef_period_1">
                    <label class="col col-4 col-xs-12"><cf_get_lang   dictionary_id="39035.Dönem Seçiniz">
                    </label>
                        <div class="col col-8 col-xs-12"> 
                            <select name="hedef_period_1" id="hedef_period_1" tabindex="60">
                            <cfif isdefined("attributes.item_company_id") and len(attributes.item_company_id)>
                                    <cfset get_periods = comp.get_periods( item_company_id: attributes.item_company_id  
                                    )/>
                                    <cfoutput query="get_periods">	 	
                                        <option value="#period_id#" <cfif isdefined("attributes.hedef_period_1") and attributes.hedef_period_1 eq period_id>selected</cfif>>#period#</option>		
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group"><div class="col col-8 col-xs-12"> 
                        <label class="col col-12 bold"><td class="headbold" valign="top"><cf_get_lang dictionary_id="57433.Yardım"></label>
                            <cftry>
                                <cfinclude template="#file_web_path#templates/period_help/öivRateTransfer_#session.ep.language#.html">
                                <cfcatch>
                                    <script type="text/javascript">
                                        alert("<cf_get_lang dictionary_id  ="29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz">");
                                    </script>
                                </cfcatch>
                            </cftry>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer> 
                <div class="col col-12 text-right ">
                    <cfsavecontent variable="OivOranıAktar"><cf_get_lang dictionary_id="45607.Oiv Oranı Aktar"></cfsavecontent>
                        <cf_workcube_buttons extraButton="1"  extraButtonText="#OivOranıAktar#"  extraFunction=" basamak_1()" update_status="0">
                    </div> 
            </cf_box_footer> 
            <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
                <cf_box>
                    <div class="ui-cfmodal-close">×</div>
                    <ul class="required_list"></ul>
                    <div class="ui-form-list-btn">
                        <div>
                            <a href="javascript:void(0);"  onClick="cancel();" class="ui-btn ui-btn-delete"><cf_get_lang dictionary_id="58461.Redeet"></a>
                        </div>
                        <div>
                            <input type="button" value="<cf_get_lang dictionary_id="44010.Aktarımı Başlat">" onClick="basamak_2();">		
                        </div>
                    </div>
                </cf_box>
            </div>            
        </cfform>
    </div>
</cf_box>       
<script type="text/javascript">
    function basamak_1()
        {
            if($('#hedef_period_1').val() == ""){
                alert("<cf_get_lang dictionary_id ="44014.Hedef Period Seçmelisiniz">!");
                return false;
            }
            if($('#form_submitted').val())	{
                $('.ui-cfmodal__alert .required_list li').remove();
                $('.ui-cfmodal__alert .required_list').append('ÖİV Oranı Aktarım İşlemi Gerçekleştir');	
                $('.ui-cfmodal__alert').fadeIn();
                return false;
            } 
            return true;
        }
    function basamak_2() {
            hedef_period_1 =$('#hedef_period_1').val();
            $.ajax({ 
                type:'POST',  
                url:'V16/settings/cfc/oiv_rate_transver.cfc?method=oiv_aktarim', 
                data: { 
                    hedef_period_1 : hedef_period_1
                },
                async:false, 
                dataType: 'json',
                success : function(res){
                
                    if (res.STATUS == true) {
                        alert("<cf_get_lang dictionary_id ='61210.işlem başarılı'>!");
                        $('.ui-cfmodal__alert').fadeOut();
                    }
                    else{
                        if(res.DATA.PERIOD_ID == 0){
                            alert("<cf_get_lang dictionary_id ="44013.Kaynak Period Bulunamadı!Önceki Dönemi Olmayan Bir Döneme Aktarım Yapılamaz">");    
                            $('.ui-cfmodal__alert').fadeOut();      
                        }
                        else{
                            console.log(res);
                            alert("<cf_get_lang dictionary_id="44032.Bu aktarim daha önce yapılmıştır">!");
                                $('.ui-cfmodal__alert').fadeOut();
                        }
                    }
                },
                error: function () 
                {
                    console.log('CODE:8 please, try again..');
                }
            });
            return true;
    }
    function cancel() {
            $('.ui-cfmodal__alert').fadeOut();
            return false;		
    }
    $(document).ready(function(){
        <cfif NOT (isdefined("attributes.item_company_id") and len(attributes.item_company_id))>
            var company_id = document.getElementById('item_company_id').value;
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
            AjaxPageLoad(send_address,'hedef_period_1',1,' alert("<cf_get_lang dictionary_id="32476.Dönemler">!");');
        </cfif>
        }
    )
    function show_periods_departments(number){
        if(number == 1)
        {
            if(document.getElementById('item_company_id').value != '')
            {
                var company_id = document.getElementById('item_company_id').value;
                var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
                AjaxPageLoad(send_address,'hedef_period_1',1,'alert("<cf_get_lang dictionary_id="32476.Dönemler">!");');
            }
        }
    }
</script>