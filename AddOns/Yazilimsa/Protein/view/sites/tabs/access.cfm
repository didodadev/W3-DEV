<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\access.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site Erişim ayarları formu. bu dosya include olarak çalısıyor
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<cfquery name="company_cat" datasource="#dsn#">
    SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="consumer_cat" datasource="#dsn#">
    SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT 
</cfquery>
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<div id="access">
    <cfform name="form_sites_step_two" enctype="multipart/form-data">
        <div class="row" type="row">
            <div class="col col-6 col-md-8 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="form-group col col-3 col-xs-12" id="item-status">   
                        <label><cf_get_lang dictionary_id='30964.Public'><input type="checkbox" v-model="models[0].ACCESS_DATA[0].PUBLIC.STATUS" true-value="1" false-value="0"></label>
                    </div>
                    <div class="form-group col col-3 col-xs-12" id="item-casir_status">   
                        <label><cf_get_lang dictionary_id='50526.Kariyer Portal'><input type="checkbox"  v-model="models[0].ACCESS_DATA[0].CARIER.STATUS" true-value="1" false-value="0"></label>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" type="row">
            <div class="col col-4 col-md-6 col-sm-9 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-company">
                    <label class="col col-12"><cf_get_lang dictionary_id='62304.Kurumsal Üyelere Özel'> <input type="checkbox" v-model="models[0].ACCESS_DATA[0].COMPANY.STATUS" true-value="1" false-value="0"></label>
                    <div class="col col-12">
                        <select v-model="models[0].ACCESS_DATA[0].COMPANY.SELECT" multiple>
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="company_cat">
                                <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </div>
                <div class="form-group" id="item-company_login">
                    <label class="col col-12"><cf_get_lang dictionary_id='62305.Kurumsal Üye Login Path'></label>
                    <div class="col col-12">
                        <input type="text"  v-model="models[0].ACCESS_DATA[0].COMPANY.LOGIN_PATH"> 
                    </div>
                </div>
                <div class="form-group" id="item-consumer">
                    <label class="col col-12"><cf_get_lang dictionary_id='62306.Bireysel Üyelere Özel'> <input type="checkbox" v-model="models[0].ACCESS_DATA[0].CONSUMER.STATUS" true-value="1" false-value="0"></label>
                    <div class="col col-12">
                        <select v-model="models[0].ACCESS_DATA[0].CONSUMER.SELECT" multiple>
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="consumer_cat">
                                <option value="#CONSCAT_ID#">#CONSCAT#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </div>
                <div class="form-group" id="item-consumer_login">
                    <label class="col col-12"><cf_get_lang dictionary_id='62307.Bireysel Üye Login Path'></label>
                    <div class="col col-12">
                        <input type="text"  v-model="models[0].ACCESS_DATA[0].CONSUMER.LOGIN_PATH"> 
                    </div>
                </div>
            </div>
        </div>
    </cfform>
</div>
<script>
    var proteinAppAccess = new Vue({
          el: '#access',
          data: {
            vue_test : '',
            method : 'access_upd',
            models : [{
                ID : <cfoutput>#attributes.site#</cfoutput>,         
                ACCESS_DATA : [{
                    COMPANY:{STATUS:0,SELECT:[],LOGIN_PATH:''},
                    CONSUMER:{STATUS:0,SELECT:[],LOGIN_PATH:''},
                    PUBLIC:{STATUS:0},
                    CARIER:{STATUS:0}
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){               
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppAccess.method, proteinAppAccess.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Erişim Tanmıları Kaydedildi",type:"success"});
                            }else{
                              alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinAppAccess.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_access", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].ACCESS_DATA.length){
                        Vue.set(proteinAppAccess.$data, 'models', response.data.DATA);
                        var ACCESS_DATA = [];
                        ACCESS_DATA[0] = JSON.parse(proteinAppAccess.models[0].ACCESS_DATA);
                        Vue.set(proteinAppAccess.$data.models[0], 'ACCESS_DATA', ACCESS_DATA);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppAccess.error.push({ecode: 1001, message:"method:"+proteinAppAccess.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
        })
</script>