<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\privacy.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          24.12.2021
    Description :   Site Cookie ve Privacy Politikaları Ayarı
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>
<div id="privacy">  
    <cfoutput query="get_language">  
        <cf_seperator title="#LANGUAGE_SET#" id="privacy_#LANGUAGE_SHORT#" is_closed="1" important_closed="1" >
        <div id="privacy_#LANGUAGE_SHORT#" style="display:none;">
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-site_privacy_text_#LANGUAGE_SHORT#">
                        <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='61743.Aydınlatma Metni'> <small class="text-danger">*<cf_get_lang dictionary_id='64619.İçerik Id'></small></label>
                        <div class="col col-12 col-sm-12">
                            <input type="number" name="site_privacy_text_#LANGUAGE_SHORT#" v-model="models[0].PRIVACY_DATA[0].#LANGUAGE_SHORT#.privacy_text" maxlength="500"> 
                        </div>              
                    </div>
                    <div class="form-group" id="item-site_privacy_text_standart_#LANGUAGE_SHORT#">
                        <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='64626.Standard Cookie'></label>
                        <div class="col col-12 col-sm-12">
                            <textarea rows="3" name="site_privacy_text_standart_#LANGUAGE_SHORT#" id="site_privacy_text_standart_#LANGUAGE_SHORT#" v-model="models[0].PRIVACY_DATA[0].#LANGUAGE_SHORT#.standart_text"></textarea> 
                        </div>
                    </div>
                    <div class="form-group" id="item-site_privacy_text_analytic_#LANGUAGE_SHORT#">
                        <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='64627.Analytic Cookie'></label>
                        <div class="col col-12 col-sm-12">
                            <textarea rows="3" name="site_privacy_text_analytic_#LANGUAGE_SHORT#" id="site_privacy_text_analytic_#LANGUAGE_SHORT#" v-model="models[0].PRIVACY_DATA[0].#LANGUAGE_SHORT#.analytic_text"></textarea> 
                        </div>
                    </div>
                    <div class="form-group" id="item-site_privacy_text_marketing_#LANGUAGE_SHORT#">
                        <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='64628.Marketing Cookie'></label>
                        <div class="col col-12 col-sm-12">
                            <textarea rows="3" name="site_privacy_text_marketing_#LANGUAGE_SHORT#" id="site_privacy_text_marketing_#LANGUAGE_SHORT#" v-model="models[0].PRIVACY_DATA[0].#LANGUAGE_SHORT#.marketing_text"></textarea> 
                        </div>
                    </div>
                    <div class="form-group" id="item-site_privacy_text_personisation_#LANGUAGE_SHORT#">
                        <label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='64630.Personalisation Cookie'></label>
                        <div class="col col-12 col-sm-12">
                            <textarea rows="3" name="site_privacy_text_personisation_#LANGUAGE_SHORT#" id="site_privacy_text_personisation_#LANGUAGE_SHORT#" v-model="models[0].PRIVACY_DATA[0].#LANGUAGE_SHORT#.personisation_text"></textarea> 
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </cfoutput>
</div>

<script>
    var proteinAppPrivacy = new Vue({
        el: '#privacy',
        data: {
        method : 'privacy_upd',
        models : [{
            ID : <cfoutput>#attributes.site#</cfoutput>,
            PRIVACY_DATA : [{
                <cfoutput query="get_language">
                    #LANGUAGE_SHORT#:{
                        privacy_text:"",
                        standart_text:"",
                        analytic_text:"",
                        marketing_text:"",
                        personisation_text:""
                    },
                </cfoutput>
                ABC:0
            }]                         
        }],            
        error: []
        },
        methods: {
            save : function(type,url){ 
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppPrivacy.method, proteinAppPrivacy.models[0])
                    .then(response => {
                            if(response.data.STATUS == true){
                                alertObject({message:"Gizlilik Ayarları Kaydedildi",type:"success"});                                
                            }else{
                                alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }
                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinAppPrivacy.error.push({ecode: 1000, message:"method:"+proteinAppPrivacy.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
        },
        mounted () { 
        <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_privacy", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].PRIVACY_DATA.length){
                        Vue.set(proteinAppPrivacy.$data, 'models', response.data.DATA);
                        var PRIVACY_DATA = [];
                        PRIVACY_DATA[0] = JSON.parse(proteinAppPrivacy.models[0].PRIVACY_DATA);
                        Vue.set(proteinAppPrivacy.$data.models[0], 'PRIVACY_DATA', PRIVACY_DATA);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppPrivacy.error.push({ecode: 1001, message:"method:"+proteinAppPrivacy.method+" bir porblem meydana geldi..."})
                });
        </cfif>      
        }
    })
</script>