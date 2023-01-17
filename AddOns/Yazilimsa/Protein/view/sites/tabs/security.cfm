<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\security.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          23.05.2021
    Description :   Site güvenlik ayarları, plevne settings
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<div id="security">    
    <cfform name="form_sites_step_five" enctype="multipart/form-data">
        <div class="row" type="row">
            <div class="col col-4 col-md-6 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-WAS">
                    <label class="col col-10">
                        Plevne WAS uygulaması eklensin 
                        <input type="checkbox" name="status" id="status" v-model="models[0].SECURITY_DATA[0].plevne_was_status" true-value="1" false-value="0">
                    </label>
                    <div class="col col-2 text-right">
                        <img src="css/assets/icons/catalyst-icon-svg/plevne_was_logo.svg" style="width: 30px !important;height: 60px !important;margin: -20px 0;">
                    </div>
                </div>
                <div class="form-group" id="item-WAS-PARAMS" v-if="models[0].SECURITY_DATA[0].plevne_was_status == 1">
                    <div class="col col-12">
                        <ul class="ui-list">
                            <li>
                                <a href="javascript:void(0)" style="background: none;">
                                    <div class="ui-list-left font-red-flamingo">
                                        <span class="ui-list-icon ctl-american-football"></span>
                                        Tedbirler
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <label>
                                            Siyah <input type="checkbox" v-model="models[0].SECURITY_DATA[0].param_1" true-value="1" false-value="0">
                                        </label>
                                    </div>
                                </a>
                           </li>
                           <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <label>
                                            Kırmızı <input type="checkbox" v-model="models[0].SECURITY_DATA[0].param_2" true-value="1" false-value="0">
                                        </label>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <label>
                                            Mavi <input type="checkbox" v-model="models[0].SECURITY_DATA[0].param_3" true-value="1" false-value="0">
                                        </label>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <label>
                                            Yeşil <input type="checkbox"v-model="models[0].SECURITY_DATA[0].param_4" true-value="1" false-value="0">
                                        </label>
                                    </div>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
        
            </div>
        </div>
    </cfform>
</div>
<script>
    var proteinAppSecurity = new Vue({
          el: '#security',
          data: {
            vue_test : '',
            method : 'security_upd',
            models : [{
                ID : <cfoutput>#attributes.site#</cfoutput>,         
                SECURITY_DATA : [{
                    plevne_was_status:0,
                    param_1:0,
                    param_2:0,
                    param_3:0,
                    param_4:0,
                    param_5:0
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){               
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppSecurity.method, proteinAppSecurity.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Güvenlik Tanmları Kaydedildi",type:"success"});
                                
                            }else{
                              alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinAppSecurity.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_security", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].SECURITY_DATA.length){
                        Vue.set(proteinAppSecurity.$data, 'models', response.data.DATA);
                        var SECURITY_DATA = [];
                        SECURITY_DATA[0] = JSON.parse(proteinAppSecurity.models[0].SECURITY_DATA);
                        Vue.set(proteinAppSecurity.$data.models[0], 'SECURITY_DATA', SECURITY_DATA);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppSecurity.error.push({ecode: 1001, message:"method:"+proteinAppSecurity.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
        })
</script>
