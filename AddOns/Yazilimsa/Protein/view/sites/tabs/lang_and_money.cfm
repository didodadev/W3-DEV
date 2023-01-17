<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\lang_and_money.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site para birimi ve dil tanımlar formu. bu dosya include olarak çalısıyor
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<cfquery name="our_company" datasource="#dsn#">
    SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
</cfquery>
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>
<div id="lang_and_money">
    <cfform name="form_sites_step_two" enctype="multipart/form-data">            
        <div class="row" type="row">
            <div class="col col-5 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-company">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-8 col-sm-12">
                        <select v-model="models[0].COMPANY ">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="our_company">
                                <option value="#COMP_ID#">#COMPANY_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </div>
                <div class="form-group" id="item-language">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58996.Dil'> / <cf_get_lang dictionary_id='62300.Yol'> / <cf_get_lang dictionary_id='50532.Anasayfa'></label>
                    <div class="col col-8 col-sm-12 padding-0">
                        <cfoutput query="get_language">
                            <div class="form-group">
                                <label class="col col-4 col-sm-12">#LANGUAGE_SET# <input type="checkbox" v-model="models[0].ZONE_DATA[0].LANGUAGE[0].#LANGUAGE_SHORT#.STATUS" true-value="1" false-value="0"></label>
                                <div class="col col-3 col-sm-12">
                                    <input type="text" v-model="models[0].ZONE_DATA[0].LANGUAGE[0].#LANGUAGE_SHORT#.PATH" maxlength="250"> 
                                </div>
                                <div class="col col-5 col-sm-12">
                                    <input type="text" v-model="models[0].ZONE_DATA[0].LANGUAGE[0].#LANGUAGE_SHORT#.HOMEPAGE" maxlength="250"> 
                                </div>
                            </div>
                        </cfoutput>                        
                    </div>             
                </div>
            </div>
            <div class="col col-2 col-md-3 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-language">
                    <label class="col col-12"><cf_get_lang dictionary_id='38765.Para'></label>
                    <div class="col col-12 col-xs-12">
                        <div class="form-group" >   
                            <label><cf_get_lang dictionary_id='37345.TL'><input type="checkbox" v-model="models[0].ZONE_DATA[0].MONEY[0].TL" true-value="1" false-value="0"></label>
                        </div>
                        <div class="form-group" >   
                            <label><cf_get_lang dictionary_id='37344.USD'><input type="checkbox" v-model="models[0].ZONE_DATA[0].MONEY[0].USD" true-value="1" false-value="0"></label>
                        </div>
                        <div class="form-group" >   
                            <label>EUR<input type="checkbox" v-model="models[0].ZONE_DATA[0].MONEY[0].EUR" true-value="1" false-value="0"></label>
                        </div>
                    </div>              
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                <div class="form-group"  id="item-stock_type" >
                    <label class="col col-12"><cf_get_lang dictionary_id ='58166.Stoklar'></label>
                    <div class="col col-12">
                        <select v-model="models[0].ZONE_DATA[0].STOCK_TYPE">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="2"><cf_get_lang dictionary_id='29766.XML'><cf_get_lang dictionary_id ='44471.Stoklarım'></option>
                            <option value="3"><cf_get_lang dictionary_id ='58081.Hepsi'></option>
                        </select>
                    </div>
                </div> 
                <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
                    SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE IS_STORE <> 2 AND DEPARTMENT_STATUS = 1  ORDER BY DEPARTMENT_HEAD
                </cfquery>                    
                <div class="form-group" id="item-depertment" >
                    <label class="col col-12"><cf_get_lang dictionary_id ='44472.Depolar'></label>
                    <div class="col col-12">
                        <select v-model="models[0].ZONE_DATA[0].DEPERTMENT" multiple>
                            <cfoutput query="GET_DEPARTMENT">
                                <option value="#department_id#">#department_head#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </div>
            </div>
        </div>
    </cfform>
</div>
<script>
    var proteinAppLangAndMoney = new Vue({
          el: '#lang_and_money',
          data: {
            vue_test : '',
            method : 'lang_and_money_upd',
            models : [{
                ID : <cfoutput>#attributes.site#</cfoutput>,     
                COMPANY  : 0,           
                ZONE_DATA : [{
                    LANGUAGE : [{
                        <cfoutput query="get_language">
                            #LANGUAGE_SHORT#:{
                                STATUS:0,
                                PATH:'/#LANGUAGE_SHORT#',
                                LANGUAGE_SHORT:'#LANGUAGE_SHORT#',
                                LANGUAGE_SET:'#LANGUAGE_SET#',
                                HOMEPAGE:'welcome_#LANGUAGE_SHORT#'
                            },
                        </cfoutput>orther:{}
                    }],
                    MONEY : [{
                        TL:1,
                        USD:0,
                        EUR:0
                    }],
                    STOCK_TYPE : 0,
                    DEPERTMENT : []
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){ 
                if(proteinAppLangAndMoney.models[0].COMPANY == 0){alertObject({message:"Şirket seçiniz.",type:"warning"}); return false;}
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppLangAndMoney.method, proteinAppLangAndMoney.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Dil ve Para Birimleri Kaydedildi",type:"success"});
                                
                            }else{
                              alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }
                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinAppLangAndMoney.error.push({ecode: 1000, message:"method:"+proteinAppLangAndMoney.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_lang_and_money", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].ZONE_DATA.length){
                        Vue.set(proteinAppLangAndMoney.$data, 'models', response.data.DATA);
                        var ZONE_DATA = [];
                        ZONE_DATA[0] = JSON.parse(proteinAppLangAndMoney.models[0].ZONE_DATA);
                        Vue.set(proteinAppLangAndMoney.$data.models[0], 'ZONE_DATA', ZONE_DATA);
                        <cfoutput query="get_language">
                            if(!ZONE_DATA[0].LANGUAGE[0].#LANGUAGE_SHORT#.HOMEPAGE) Vue.set(proteinAppLangAndMoney.$data.models[0].ZONE_DATA[0].LANGUAGE[0].#LANGUAGE_SHORT#, 'HOMEPAGE', 'welcome_#LANGUAGE_SHORT#');
                        </cfoutput>
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppLangAndMoney.error.push({ecode: 1001, message:"method:"+proteinAppLangAndMoney.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
        })
</script>