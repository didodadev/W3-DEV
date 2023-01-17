<!---
    File :          AddOns\Yazilimsa\Protein\view\sites\tabs\general_definations.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Site genel tanımlar formu. bu dosya include olarak çalısıyor
    Notes :         AddOns\Yazilimsa\Protein\view\sites\definitions.cfm ta include edilir
--->
<div id="general_definitions">
    <cfsavecontent variable="message"><small class="font-grey-cascade"><strong>1. Adım :</strong> Tanımlar</small></cfsavecontent>
    <cfform name="form_sites_step_one" method="post" action="" enctype="multipart/form-data">
        <div class="row" type="row" v-show="method == 'general_definitions_upd'">
            <div class="col col-6 col-md-8 col-sm-9 col-xs-12 padding-left-10 " type="column" index="1" sort="true">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="form-group col col-2 col-xs-12" id="item-status">   
                        <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="status" id="status" v-model="models[0].STATUS" true-value="1" false-value="0"></label>
                    </div>
                    <div class="form-group col col-9 col-xs-12" id="item-maintenance_mode">   
                        <label class="col col-3 col-sm-12"><cf_get_lang dictionary_id='62290.Bakım Modu'><input type="checkbox" name="maintenance_mode" id="maintenance_mode" v-model="models[0].MAINTENANCE_MODE" true-value="1" false-value="0"></label>
                        <div class="col col-4 col-sm-12" v-show="models[0].MAINTENANCE_MODE == 1">
                            <div class="input-group" style="margin: -9px;">
                                <input type="password" v-model="models[0].PRIMARY_DATA[0].MAINTENANCE_PASSWORD">
                                <div class="input-group_tooltip">Bakım Modunda Siteye Gözatmak İçin Parola Belirleyiniz
                                    <span  v-show="models[0].PRIMARY_DATA[0].MAINTENANCE_PASSWORD"><strong>Parolanız : {{models[0].PRIMARY_DATA[0].MAINTENANCE_PASSWORD}}</strong><span>
                                </div>
                                <span class="input-group-addon icon-lock text-success  input-group-tooltip"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" type="row">
            <div class="col col-6 col-md-7 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-domain">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57892.Domain'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="domain" id="domain" v-model="models[0].DOMAIN" maxlength="500"> 
                    </div>
                </div>
                <div class="form-group" id="item-domain">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='44794.Title'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="pd_title" id="pd_title" v-model="models[0].PRIMARY_DATA[0].TITLE" maxlength="250"> 
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='52750.Detail'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_detail" id="pd_detail" v-model="models[0].PRIMARY_DATA[0].DETAIL"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-meta_description" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58993.Meta Tanımı'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_meta_description" id="pd_meta_description" v-model="models[0].PRIMARY_DATA[0].META_DESCRIPTION"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-meta_keyword" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58994.Meta Anahtar Kelimeleri'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_meta_keyword" id="pd_meta_keyword" v-model="models[0].PRIMARY_DATA[0].META_KEYWORD"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-google_analytics_code" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62291.Google Analytic Code'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="pd_google_analytics_code" id="pd_google_analytics_code" v-model="models[0].PRIMARY_DATA[0].GOOGLE_ANALYTICS_CODE" maxlength="250"> 
                    </div>
                </div>
                <div class="form-group" id="item-facebook_relation" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62292.Facebook Relation'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="pd_facebook_relation" id="pd_facebook_relation" v-model="models[0].PRIMARY_DATA[0].FACEBOOK_RELATION" maxlength="250"> 
                    </div>
                </div>
                <div class="form-group" id="item-twitter_relation" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62293.Twitter Relation'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="pd_twitter_relation" id="pd_twitter_relation" v-model="models[0].PRIMARY_DATA[0].TWITTER_RELATION" maxlength="250"> 
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-5 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-og_image" v-show="method == 'general_definitions_upd'">                  
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62294.Og-İmage'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="file" accept=".ico,.png"  id="og_image_file">						 
                            <span class="input-group-addon icon-minus text-danger btnPointer" @click="update_file('og_image','delete')"></span>
                            <span class="input-group-addon icon-check text-success btnPointer" @click="update_file('og_image','update')"></span>
                            <span class="input-group-addon preview-icon" v-if="models[0].PRIMARY_DATA[0].OG_IMAGE"><img :src="'http://'+ domainSplit(models[0].DOMAIN) +'/src/includes/manifest/'+models[0].PRIMARY_DATA[0].OG_IMAGE"/></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-favicon" v-show="method == 'general_definitions_upd'">                  
                    <label class="col col-4 col-sm-12">Favicon</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="file" accept=".ico,.png"  id="favicon_file">						 
                            <span class="input-group-addon icon-minus text-danger btnPointer" @click="update_file('favicon','delete')"></span>
                            <span class="input-group-addon icon-check text-success btnPointer" @click="update_file('favicon','update')"></span>
                            <span class="input-group-addon preview-icon" v-if="models[0].PRIMARY_DATA[0].FAVICON"><img :src="'http://'+ domainSplit(models[0].DOMAIN) +'/src/includes/manifest/'+models[0].PRIMARY_DATA[0].FAVICON"/></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-og_descrition" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62295.Og-Description'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_og_description" id="pd_og_description" v-model="models[0].PRIMARY_DATA[0].OG_DESCRIPTION"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-appendix_meta" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62296.Appendix Meta'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_appendix_meta" id="pd_appendix_meta" v-model="models[0].PRIMARY_DATA[0].APPENDIX_META"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-appendix_top" v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62297.Appendix Top'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_appendix_top" id="pd_appendix_top" v-model="models[0].PRIMARY_DATA[0].APPENDIX_TOP"></textarea>
                    </div>              
                </div>
                <div class="form-group" id="item-appendix_foot"  v-show="method == 'general_definitions_upd'">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62298.Appendix Foot'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="pd_appendix_foot" id="pd_appendix_foot" v-model="models[0].PRIMARY_DATA[0].APPENDIX_FOOT"></textarea>
                    </div>              
                </div>
            </div>
        </div>        
    </cfform>
    <div class="ui-cfmodal" id="del_site_confirm_modal" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="del_site_confirm_box" title="#getLang('','Delete',44845)#" closable="1" call_function="cfmodalx({e:'close',id:'del_site_confirm_modal'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                        <cfif isdefined('attributes.site') and len(attributes.site)> <cfoutput>#thısDomaın.DOMAIN#</cfoutput></cfif> <cf_get_lang dictionary_id='62299.adresli bu site silinecek onaylıyor musun?'>
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <button type="button" class="btn btn-info pull-right margin-right-5" data-dismiss="modal" @click="cfmodalx({e:'close',id:'del_site_confirm_modal'});"><cf_get_lang dictionary_id='57462.Vazgeç'></button>
                <button type="button" class="btn btn-danger pull-right margin-right-5" @click="deleteSite()"><cf_get_lang dictionary_id='57463.Sil'></button>
            </div>
        </cf_box>
    </div>
    
</div>

<script>
    var proteinAppGeneralDefinitions = new Vue({
          el: '#general_definitions',
          data: {
            vue_test : '',
            method : 'general_definitions_<cfoutput>#attributes.event#</cfoutput>',
            models : [{
                ID : <cfif isdefined('attributes.site') and len(attributes.site)><cfoutput>#attributes.site#</cfoutput><cfelse>null</cfif>,
                DOMAIN : '',
                STATUS : 0,
                MAINTENANCE_MODE : 1,                
                PRIMARY_DATA : [{
                    TITLE : '',
                    DETAIL :'',
                    META_DESCRIPTION : '',
                    META_KEYWORD : '',
                    GOOGLE_ANALYTICS_CODE : '',
                    FACEBOOK_RELATION : '',
                    TWITTER_RELATION : '',
                    OG_IMAGE : '',
                    FAVICON : '',
                    OG_DESCRIPTION : '',
                    APPENDIX_META : '',
                    APPENDIX_TOP : '',
                    APPENDIX_FOOT : '',
                    MAINTENANCE_PASSWORD : '',
                }]
            }],            
            error: []
          },
          methods: {
            save : function(type,url){  
                if(proteinAppGeneralDefinitions.models[0].DOMAIN.length == 0){alertObject({message:"Domain bilgisi giriniz.",type:"warning"}); return false;}
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinAppGeneralDefinitions.method, proteinAppGeneralDefinitions.models[0])
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Genel Tanımlar Kaydedildi",type:"success"}); 
                            if(proteinAppGeneralDefinitions.method == 'general_definitions_add'){
                                setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site&event=upd&site=" + response.data.IDENTITYCOL;} , 2000);                               
                            }
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }
                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppGeneralDefinitions.error.push({ecode: 1000, message:"method:"+proteinAppGeneralDefinitions.method+" bir porblem meydana geldi..."})
                })                   
                
                return false;
            },
            deleteSiteConfirm : function(){                
                cfmodalx({e:'open',id:'del_site_confirm_modal'});
            },
            deleteSite : function(){
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_site",{params:{site:proteinAppGeneralDefinitions.models[0].ID}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Site Silindi.",type:"success"}); 
                            cfmodalx({e:'close',id:'del_site_confirm_modal'});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site"} , 2000);                               
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_site_confirm_modal'});
                    proteinAppGeneralDefinitions.error.push({ecode: 1000, message:"method:"+proteinAppGeneralDefinitions.method+" bir porblem meydana geldi..."})
                })   
                
            },
            update_file : function(type,action){
                
                var formData = new FormData();
                if(type == 'og_image'){
                    var sfile = document.querySelector('#og_image_file');
                    var delete_file = proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].OG_IMAGE;
                }else if(type == 'favicon'){
                    var sfile = document.querySelector('#favicon_file');
                    var delete_file = proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].FAVICON;
                }                
                formData.append("file", sfile.files[0]);
                formData.append("type", type);
                formData.append("site", proteinAppGeneralDefinitions.models[0].ID);

                if(action == "delete"){
                    formData.append("delete_file", delete_file); 
                }

                axios.post('/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method='+action+'_site_manifest_file', formData, {
                    headers: {
                    'Content-Type': 'multipart/form-data'
                    }
                })
                .then(response => {                        
                    if(response.data.STATUS == true){
                        if(action == "update"){    
                            alertObject({message:"Dosya Kaydedildi 😉",type:"success"});
                            if(type == 'og_image'){
                                proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].OG_IMAGE =  response.data.FILE;
                            }else if(type == 'favicon'){
                                proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].FAVICON =  response.data.FILE;
                            }
                        }else{
                            alertObject({message:"Dosya Silindi 😉",type:"success"});
                            if(type == 'og_image'){
                                proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].OG_IMAGE = "";
                            }else if(type == 'favicon'){
                                proteinAppGeneralDefinitions.models[0].PRIMARY_DATA[0].FAVICON = "";
                            }
                        }                                                                   
                    }else{
                    alertObject({message:"Hata : 2005 - " + response.data.ERROR ,type:"danger"});  
                    }                            
                })
                .catch(e => {
                    alertObject({message:"Hata : 2006 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppGeneralDefinitions.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                })
            },
            domainSplit: function (value) {
              if (!value) return ''
                let str = value;
                const domainList= str.split(",");
                console.log(domainList[0]);
              return domainList[0];
            }
          },
          mounted () {
            <cfif isdefined('attributes.site') and len(attributes.site)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_general_definitions", {params: {id :<cfoutput>#attributes.site#</cfoutput>}})
                .then(response => {
                    Vue.set(proteinAppGeneralDefinitions.$data, 'models', response.data.DATA);
                    var PRIMARY_DATA = [];
                    PRIMARY_DATA[0] = JSON.parse(proteinAppGeneralDefinitions.models[0].PRIMARY_DATA);
                    Vue.set(proteinAppGeneralDefinitions.$data.models[0], 'PRIMARY_DATA', PRIMARY_DATA);
                    if(!PRIMARY_DATA[0].MAINTENANCE_PASSWORD) Vue.set(proteinAppGeneralDefinitions.$data.models[0].PRIMARY_DATA[0], 'MAINTENANCE_PASSWORD', '');
                    if(!PRIMARY_DATA[0].FAVICON) Vue.set(proteinAppGeneralDefinitions.$data.models[0].PRIMARY_DATA[0], 'FAVICON', '');
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinAppGeneralDefinitions.error.push({ecode: 1001, message:"method:"+proteinAppGeneralDefinitions.method+" bir porblem meydana geldi..."})
                });
            </cfif>     
        }
    })
</script>