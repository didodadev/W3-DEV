<!---
    File :          AddOns\Yazilimsa\Protein\view\po\publishing_settings.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          20.04.2021
    Description :   Protein Object | PO - yayın ayarları widgetı
    Notes :         frienly url alan module objelerinin protein pageleri ile ilişkisini organize eder
--->
<cfset PROTEIN_MAIN_SERVICES = createObject('component','AddOns/Yazilimsa/Protein/cfc/siteMethods')>
<cfset GET_SITES = PROTEIN_MAIN_SERVICES.GET_SITES()>

<style>
    .protein-publish-buttons i{
        font-size: 18px;
        line-height: 16px !important;
    }
    i.protein-publish-on{color: #4caf50 !important;}
    i.protein-publish-off{color: #f44336 !important; transform: rotate(180deg);}
    .protein-publish-buttons i::before{
        opacity: 0.5;
        animation: 1s fadeIn;
        animation-fill-mode: forwards;
        transition: opacity 1.5s;
    }
    @keyframes fadeIn {
        from {
            opacity: 0.5;
        }
        to {
            opacity: 1;
        }
    }
    .publish-model-table input{
        border: 0;
        border-bottom: 1px;
        border-style: dashed;
        background: none;
        color: #2196f3;
        width: calc(100% - 40px);
        height: 12px;
    }

    #alertObjectContent {
        display: block;
        position: fixed;
        z-index: 999999;
        width: 400PX;
        right: 10px !important;
        left: unset;
        top: 50px;
        opacity: 0.94;
    }

    .protein-publish-icon-badge i {
        color: #fff !important;
        margin: 0px -5px;
        font-size: 11px !important;
        background: #2196f3;
        border-radius: 50%;
        width: 12px;
        height: 12px;
        text-align: center;
        padding: 3px;
        float: right;
    }
    .protein-publish-icon-badge a { color: #fff !important;}
    .protein-reafonly-input{
        color: #666 !important;
        border: 1px solid #cacaca !important;
        background-color: #eee !important;
        box-shadow: none !important;
    }

    span.protein-event-list{
        background: #ffb74d; color: white;
    }

    span.protein-event-add{
        background: #aed581; color: white;
    }

    span.protein-event-upd{
        background: #64b5f6; color: white;
    }

    span.protein-event-det{
        background: #e57373; color: white;
    }
    span.input-group-addon.protein-publish-icon-badge.bg-none {
        background: none !important;
    }
    .publish-model-table input[type="checkbox"] {
        width: auto;
    }
    .publish-model-table .check-label-group .check-label {
        display: inline-block !important;
        float: left;
        margin: 0px 5px !important;
    }

</style>
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
    <cf_box title="Protein Publishing Settings" popup_box="1" id="po_publishing_settings">
        <div data-vue-app="app_publishing_settings" class="publish-model-table">
            <div class="ui-card scrollContent" style=" overflow: auto !important; max-height: 550px;">
                <div class="ui-card-item" style=" border: 1px solid #00897b; border-left: 4px solid #00897b; ">
                    <cf_box_elements vertical="1">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label>Yayınlanacak Sayfa</label>
                                <select v-model="publish_add_model[0].PAGE_ID" 
                                @change="
                                    publish_add_model[0].SITE_ID= get_publish_page_available_data.filter((item) => item.PAGE_ID == publish_add_model[0].PAGE_ID)[0].SITE;
                                ">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>   
                                    <cfoutput query="GET_SITES">
                                        <optgroup label="#DOMAIN#">
                                            <option v-for="item in get_publish_page_available_data.filter((item) => item.SITE == #SITE_ID#)" :value="item.PAGE_ID">
                                                {{item.TITLE}}
                                            </option>
                                        </optgroup>
                                    </cfoutput>
                                </select>
                            </div> 
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label>Friendly Url</label>
                                <div class="input-group">
                                    <input type="text" v-model="publish_add_model[0].FRIENDLY_URL"/>
                                    <span class="input-group-addon protein-publish-icon-badge">
                                        <i class="fa fa-magic" @click="generate_friendly('-1')" title="generate friendly url"></i>                                        
                                    </span>
                                </div>
                            </div>                            
                        </div>
                        <div class="col col-1 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label>Language</label>
                                <select v-model="publish_add_model[0].OPTIONS_DATA.LANGUAGE">
                                    <cfoutput query="get_language">
                                        <option value="#LANGUAGE_SHORT#">#LANGUAGE_SET#</option>
                                    </cfoutput>
                                </select>
                            </div> 
                        </div> 
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label>Settings</label>
                                <div class="check-label-group">
                                    <label class="check-label">index<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.index" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Follow<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.no_follow" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Archive<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.no_archive" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No İmage Index<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.no_image_index" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Snippet<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.no_snipped" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Follow External Links<input type="checkbox" v-model="publish_add_model[0].OPTIONS_DATA.no_follow_external_links" true-value="1" false-value="0"/></label>
                                </div>
                            </div>
                        </div>                 
                        <div class="row">
                            <div class="col col-12"> 
                                <a href="javascript://" class="ui-ripple-btn pull-right" @click="app_publishing_settings.add_publish_set()">Ekle</a>
                            </div>
                        </div>
                    </cf_box_elements>                    
                </div>
            </div>
            <div class="ui-card scrollContent" style=" overflow: auto !important; max-height: 550px;">
                <div class="ui-card-item" v-for="(item,index) in publish_model" :data-publish-page="index">
                    <cf_box_elements vertical="1">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label>{{item.DOMAIN}}</label>
                                <div class="input-group">
                                    <input type="text" readonly class="protein-reafonly-input" v-model="item.TITLE">
                                    <span :class="'input-group-addon protein-event-'+item.EVENT">
                                        {{item.EVENT}}
                                    </span>
                                    <span class="input-group-addon protein-publish-icon-badge">
                                        <a :href="'/index.cfm?fuseaction=protein.pages&event=upd&page='+item.PAGE_ID+'&site='+item.SITE" target="_blank">
                                            <i class="icon-cog color-S " style="color: #fff !important; font-size: 11px;" title="page settings"></i>
                                        </a>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Friendly Url</label>
                                <div class="input-group">
                                    <input type="text" v-model="item.FRIENDLY_URL" :title="item.FRIENDLY_URL"/>
                                    <span class="input-group-addon protein-publish-icon-badge">
                                        <i class="fa fa-magic" @click="generate_friendly(index,0)" title="generate friendly url" v-show="!item.FRIENDLY_URL"></i>
                                        <a :href="'http://'+item.DOMAIN+'/'+item.FRIENDLY_URL" target="_blank">
                                            <i class="icon-link bg-yellow-gold" style="color: #fff !important; font-size: 11px;" title="go to link" v-show="item.FRIENDLY_URL"></i>
                                        </a>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Language</label>
                                <select v-model="item.OPTIONS_DATA.LANGUAGE">
                                    <cfoutput query="get_language">
                                        <option value="#LANGUAGE_SHORT#">#LANGUAGE_SET#</option>
                                    </cfoutput>
                                </select>
                            </div>                          
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">                             
                            <div class="form-group">
                                <label>Status</label>
                                <select v-model="item.STATUS">
                                    <option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>                              
                                    <option v-for="item in status_options" :value="item.KEY">
                                            {{item.TITLE}}
                                    </option>
                                </select>
                            </div>                           
                            <div class="form-group">
                                <label>Settings</label>
                                <div class="check-label-group">
                                    <label class="check-label">index<input type="checkbox" v-model="item.OPTIONS_DATA.index" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Follow<input type="checkbox" v-model="item.OPTIONS_DATA.no_follow" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Archive<input type="checkbox" v-model="item.OPTIONS_DATA.no_archive" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No İmage Index<input type="checkbox" v-model="item.OPTIONS_DATA.no_image_index" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Snippet<input type="checkbox" v-model="item.OPTIONS_DATA.no_snipped" true-value="1" false-value="0"/></label>
                                    <label class="check-label">No Follow External Links<input type="checkbox" v-model="item.OPTIONS_DATA.no_follow_external_links" true-value="1" false-value="0"/></label>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12"> 
                            <div class="form-group" v-show="item.STATUS == 4">
                                <label>Redirect Type</label>
                                <select v-model="item.OPTIONS_DATA.redirect_type">
                                    <option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option v-for="item in redirect_options" :value="item.KEY">
                                        {{item.TITLE}}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group" v-show="item.STATUS == 4">
                                <label>Redirect Url</label>
                                <input type="text" v-model="item.OPTIONS_DATA.redirect_url">
                            </div>
                            <div class="form-group" v-show="item.STATUS == 0">
                                <label>Cancel Type</label>
                                <select v-model="item.OPTIONS_DATA.cancel_type">
                                    <option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option v-for="item in cancel_options" :value="item.KEY">
                                        {{item.TITLE}}
                                    </option>
                                </select>
                            </div>                             
                        </div>
                        <div class="row">
                            <div class="col col-12"> 
                                <a href="javascript://" class="ui-ripple-btn pull-right" @click="app_publishing_settings.save_publish_set(index,'upd')"><cf_get_lang dictionary_id='57464.Güncelle'></a>
                            </div>
                        </div>
                    </cf_box_elements>                    
                </div>
            </div>
        </div>        
    </cf_box>
</div>
<!--- TODO: POST GET organizasyonunnun kontrol et--->
<script type="text/javascript">
    var app_publishing_settings = new Vue({
			el : '[data-vue-app="app_publishing_settings"]',
			data : {
				protein : '2020',
                frienly_model :{
                    faction     : '<cfoutput>#attributes.faction#</cfoutput>',
                    event       : '<cfoutput>#attributes.event#</cfoutput>',
                    action_type : '<cfoutput>#attributes.action_type#</cfoutput>',
                    action_id   : '<cfoutput>#attributes.action_id#</cfoutput>'
                },
                publish_model : [],
                publish_add_model : [{
                    SITE_ID     : '',
                    PAGE_ID     : '',
                    FRIENDLY_URL: '',
                    OPTIONS_DATA: {LANGUAGE:'tr',index:'1',no_follow:'0',no_archive:'0',no_image_index:'0',no_snipped:'0',no_follow_external_links:'0'},
                    STATUS      : 1,
                    faction     : '<cfoutput>#attributes.faction#</cfoutput>',
                    event       : '<cfoutput>#attributes.event#</cfoutput>',
                    action_type : '<cfoutput>#attributes.action_type#</cfoutput>',
                    action_id   : '<cfoutput>#attributes.action_id#</cfoutput>'
                }],
                get_publish_page_available_data : [],
                status_options : [
                    {
                        KEY: -2,
                        TITLE : 'Sil'
                    },
                    {
                        KEY: 1,
                        TITLE : 'Yayın'
                    },
                    {
                        KEY: 0,
                        TITLE : 'İptal'
                    },
                    {
                        KEY: 3,
                        TITLE : 'Geçici Durdurma'
                    },
                    {
                        KEY: 4,
                        TITLE : 'Yönlendirme'
                    }
                ],
                redirect_options : [
                    {
                        KEY: 301,
                        TITLE : '301'
                    },
                    {
                        KEY: 302,
                        TITLE : '302'
                    },
                    {
                        KEY: 307,
                        TITLE : '307'
                    }
                ],
                cancel_options : [
                    {
                        KEY: 410,
                        TITLE : '410'
                    },
                    {
                        KEY: 451,
                        TITLE : '451'
                    }
                ],
				error: [],
			},
			methods : {
				get_publish_page : function(){
                    /* faction|event a uygun aktif protein pagelerini getirir */
                    var this_ = this;
					axios.post( '/AddOns/Yazilimsa/Protein/cfc/publishing.cfc?method=get_publish_page', this_.frienly_model)
					.then(response => {
                        response_ = response.data.DATA;
                        response_.forEach( function (element, index) { /* OPTIONS_DATA boş ise burda model ile doldurulur */
                            if(!response_[index].OPTIONS_DATA) {
                                response_[index].OPTIONS_DATA = {
                                    index : 1,
                                    no_follow : 0,
                                    no_archive : 0,
                                    no_image_index : 0,
                                    no_snipped : 0,
                                    no_follow_external_links : 0,
                                    redirect_type : '',
                                    redirect_url : '',
                                    cancel_type : '',
                                    LANGUAGE : 'tr'
                                }
                            }else{
                                response_[index].OPTIONS_DATA = JSON.parse(response_[index].OPTIONS_DATA);
                            }
                        });

                        Vue.set(app_publishing_settings.$data, 'publish_model', response_);

                        console.log(response_);
					})
					.catch(e => {
						alertObject({message:"Şuanda İşlem Yapılamıyor. ERROR:E01",type:"danger"});
						this_.error.push({ecode: 01, message:"Şuanda İşlem Yapılamıyor...."})						
					})  
				},
                get_publish_page_available : function(){
                    /* faction|event a uygun aktif protein pagelerini getirir */
                    var this_ = this;
					axios.post( '/AddOns/Yazilimsa/Protein/cfc/publishing.cfc?method=get_publish_page_available', this_.frienly_model)
					.then(response => {
                        response_ = response.data.DATA;                      
                        Vue.set(app_publishing_settings.$data, 'get_publish_page_available_data', response_);
					})
					.catch(e => {
						alertObject({message:"Şuanda İşlem Yapılamıyor. ERROR:E01",type:"danger"});
						this_.error.push({ecode: 01, message:"Şuanda İşlem Yapılamıyor...."})						
					})  
				},
                add_publish_set : function (index,action) {
                    var this_ = this;
					axios.post( '/AddOns/Yazilimsa/Protein/cfc/publishing.cfc?method=add_publish_page', this_.publish_add_model[0])
					.then(response => {
                        var res =  response.data;
                        if(res.STATUS == true){
                            alertObject({message:"Frindly Url Kaydedildi",type:"success"});
                            Vue.set(app_publishing_settings.$data, 'publish_model', []);
                            this.get_publish_page();                   
                        }else{
                            alertObject({message:res.ERROR,type:"danger"});
                        }
					})
					.catch(e => {
                        alertObject({message:"Şuanda İşlem Yapılamıyor. ERROR:E02",type:"danger"});
						this_.error.push({ecode: 02, message:"Şuanda İşlem Yapılamıyor...."})						
					}) 
                },               
                save_publish_set : function (index,action) {
                    var this_ = this;
					axios.post( '/AddOns/Yazilimsa/Protein/cfc/publishing.cfc?method=upd_publish_page', this_.publish_model[index])
					.then(response => {
                        var res =  response.data;
                        console.log(res.TYPE);
                        if (res.TYPE == 'insert') { 
                            if(res.STATUS == true){
                                alertObject({message:res.RESPONSE_MESSAGE,type:"success"});  
                                                  
                            }else{
                                alertObject({message:res.ERROR,type:"danger"});
                            }
                        } else {
                            alertObject({message:res.RESPONSE_MESSAGE,type:"warning"});
                        }
                        Vue.set(app_publishing_settings.$data, 'publish_model', []);
                        this.get_publish_page();   
					})
					.catch(e => {
                        alertObject({message:"Şuanda İşlem Yapılamıyor. ERROR:E02",type:"danger"});
						this_.error.push({ecode: 02, message:"Şuanda İşlem Yapılamıyor...."})						
					}) 
                },generate_friendly: function (index) {
                    var this_ = this;                    
                    var data_ = (index == -1)?this_.publish_add_model[0]:this_.publish_model[index];
                    console.log(data_);
					axios.post( '/AddOns/Yazilimsa/Protein/cfc/publishing.cfc?method=generate_friendly', data_)
					.then(response => {
                        var res =  response.data;
                        console.log(res.TYPE);                        
                        if(res.STATUS == true){
                            alertObject({message:"FRIENDLY URL Oluşturuldu",type:"success"});
                            if(index=="-1"){                                
                                this_.publish_add_model[0].FRIENDLY_URL = res.DATA.FRIENDLY_URL;
                            }else{
                                this_.publish_model[index].FRIENDLY_URL = res.DATA.FRIENDLY_URL; 
                            }                       
                        }else{
                            alertObject({message:res.ERROR,type:"danger"});
                        }                        
					})
					.catch(e => {
                        alertObject({message:"Şuanda İşlem Yapılamıyor. ERROR:E02",type:"danger"});
						this_.error.push({ecode: 02, message:"Şuanda İşlem Yapılamıyor...."})						
					});
                }
			},
			mounted () {
                this.get_publish_page();
                this.get_publish_page_available();
            }
		});
</script>