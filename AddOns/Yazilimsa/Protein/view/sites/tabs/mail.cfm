<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\mail.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          21.06.2021
    Description :   Site mail ayarları
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<div id="protein_mail">    
    <cfform name="form_sites_step_six" enctype="multipart/form-data">
        <div class="row" type="row">
            <div class="col col-4 col-md-6 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-server">
                    <label class="col col-4 col-sm-12">Mail Server</label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" v-model="models[0].MAIL_SETTINGS_DATA[0].SERVER" maxlength="250"> 
                    </div>
                </div>
                <div class="form-group" id="item-user">
                    <label class="col col-4 col-sm-12">Kullanıcı</label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" v-model="models[0].MAIL_SETTINGS_DATA[0].USER" maxlength="250"> 
                    </div>
                </div>
                <div class="form-group" id="item-password">
                    <label class="col col-4 col-sm-12">Parola</label>
                    <div class="col col-8 col-sm-12">
                        <input type="password" v-model="models[0].MAIL_SETTINGS_DATA[0].PASSWORD" maxlength="250"> 
                    </div>
                </div>
                <!--- TODO: Mail server test butonu eklenecek --->
            </div>
        </div>
    </cfform>
</div>
<script>
    var proteinAppMail = new Vue({
          el: '#protein_mail',
          data: {
            vue_test : '',
            method : 'mail_settins_upd',
            models : [{
                ID : <cfoutput>#attributes.site#</cfoutput>,         
                MAIL_SETTINGS_DATA : [{ 
                    SERVER : "",
                    USER : "",
                    PASSWORD : ""               
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){               
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppMail.method, proteinAppMail.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Mail Tanımları Kaydedildi",type:"success"});
                                
                            }else{
                              alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinAppMail.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_mail_settings", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].MAIL_SETTINGS_DATA.length){
                        Vue.set(proteinAppMail.$data, 'models', response.data.DATA);
                        var MAIL_SETTINGS_DATA = [];
                        MAIL_SETTINGS_DATA[0] = JSON.parse(proteinAppMail.models[0].MAIL_SETTINGS_DATA);

                        Vue.set(proteinAppMail.$data.models[0], 'MAIL_SETTINGS_DATA', MAIL_SETTINGS_DATA);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppMail.error.push({ecode: 1001, message:"method:"+proteinAppMail.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
        })
</script>
