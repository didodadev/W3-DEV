<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\theme.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site tema tanımları formu. bu dosya include olarak çalısıyor
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<div id="theme">
    <cfform name="form_sites_step_four" enctype="multipart/form-data">
        <div class="row" type="row">
            <div class="col col-4 col-md-6 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-REACTOR">
                    <label class="col col-12"><cf_get_lang dictionary_id='35634.Tema'></label>
                    <div class="col col-12">
                        <select v-model="models[0].THEME_DATA[0].REACTOR">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <option value="bootstrap"><cf_get_lang dictionary_id='62308.Bootstrap'></option>
                            <option value="holistic_digital_academy"><cf_get_lang dictionary_id='62309.Holistic Digital Academy'></option>
                            <option value="protein_soft"><cf_get_lang dictionary_id='62310.Protein Soft'></option>
                            <option value="protein_project"><cf_get_lang dictionary_id='62311.Protein Project'></option>
                            <option value="protein_business"><cf_get_lang dictionary_id='62312.Protein Business'></option>
                            <option value="protein_landing">Protein Landing</option>
                       </select>
                    </div>              
                </div>
                <div class="form-group" id="item-ex_js">
                    <label class="col col-12"><cf_get_lang dictionary_id='62313.Siteye Özel JS Path'></label>
                    <div class="col col-12">
                        <input type="text" v-model="models[0].THEME_DATA[0].EXTERNAL_JS_PATH"> 
                    </div>
                </div>
                <div class="form-group" id="item-ex_css">
                    <label class="col col-12"><cf_get_lang dictionary_id='62314.Siteye Özel CSS Path'></label>
                    <div class="col col-12">
                        <input type="text" v-model="models[0].THEME_DATA[0].EXTERNAL_CSS_PATH"> 
                    </div>
                </div>
                <div class="form-group" id="item-template">
                    <label class="col col-12"><cf_get_lang dictionary_id='62315.Ana Şablon'></label>
                    <div class="col col-12">
                        <select v-model="models[0].THEME_DATA[0].MAIN_TEMPLATE">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfquery name="get_body_template" datasource="#dsn#">
                                SELECT TITLE,TEMPLATE_ID AS ID FROM PROTEIN_TEMPLATES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#"> AND TYPE=1 AND STATUS = 1
                            </cfquery>
                            <cfoutput query="get_body_template">
                                <option value="#ID#">#TITLE#</option>
                            </cfoutput>
                        </select>
                    </div>              
                </div>
            </div>
        </div>
    </cfform>
</div>
<script>
    var proteinAppTheme = new Vue({
          el: '#theme',
          data: {
            vue_test : '',
            method : 'theme_upd',
            models : [{
                ID : <cfoutput>#attributes.site#</cfoutput>,         
                THEME_DATA : [{
                    REACTOR:0,
                    EXTERNAL_JS_PATH : '',
                    EXTERNAL_CSS_PATH : '',
                    MAIN_TEMPLATE : 0
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){               
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppTheme.method, proteinAppTheme.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Tema Tanmları Kaydedildi",type:"success"});
                                
                            }else{
                              alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinAppTheme.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_theme", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].THEME_DATA.length){
                        Vue.set(proteinAppTheme.$data, 'models', response.data.DATA);
                        var THEME_DATA = [];
                        THEME_DATA[0] = JSON.parse(proteinAppTheme.models[0].THEME_DATA);
                        Vue.set(proteinAppTheme.$data.models[0], 'THEME_DATA', THEME_DATA);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppTheme.error.push({ecode: 1001, message:"method:"+proteinAppTheme.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
        })
</script>