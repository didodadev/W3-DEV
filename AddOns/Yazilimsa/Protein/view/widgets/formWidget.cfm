<!---
    File :          AddOns\Yazilimsa\Protein\view\widgets\widgets.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Protein widgetların parametre ayarları buradan yapılır --end off life
--->
<script src="/JS/assets/plugins/vue.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/JS/codemirror/codemirror.js"></script>
<script src="/JS/codemirror/addon/css.js"></script>
<script src="/JS/codemirror/addon/show-hint.js"></script>
<script src="/JS/codemirror/addon/css-hint.js"></script>
<script src="/JS/codemirror/addon/lint.js"></script>
<script src="/JS/codemirror/addon/css-lint.js"></script>
<link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css" />
<link rel="stylesheet" href="/JS/codemirror/addon/show-hint.css" />
<link rel="stylesheet" href="/JS/codemirror/addon/lint.css" />
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css?v=210520211339" />
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.widget#">
</cfquery>
<cfset pageHead = "#pageHead# - #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row" id="protein_widget_params"> 
    <div class="col col-12">
        <cf_box id="protein_widget_params_box" title="Widget Settings" >
            <div class="ui-form-list ui-form-block">
                <cf_tab defaultOpen="widget_info_tab" divId="widget_info_tab,box_settings,extend_css_tab,extend_file_tab,widget_seo" divLang="Params;Box Settings;Extend Css;Extend File;Search Engine Optimization">
                    <div id="unique_widget_info_tab" class="ui-info-text uniqueBox">
                        <div class="row">
                            <div class="col col-4 col-md-6 col-sm-12 col-xs-12 scroll-md">
                                    <div class="form-group" id="item-status">   
                                    <div class="col col-12">
                                        <label class="margin-right-10">Active<input type="checkbox" v-model="widget_models[0].STATUS" true-value="1" false-value="0"></label>
                                    </div>
                                </div>            
                                <div class="form-group" id="item-title">
                                    <label class="col col-12">Title</label>
                                    <div class="col col-12">
                                        <input type="text" v-model="widget_models[0].TITLE" maxlength="140" @change="change_widget_name(widget_models[0].ID)"> 
                                    </div>
                                </div>
                                <div class="form-group" v-for="(item, index) in OBJECT_PROPERTIES.OBJECT_PROPERTY">                           
                                    <label class="col col-12">{{item.PROPERTY_DETAIL}}</label>
                                    <div class="col col-12">
                                        <input type="text" v-if="item.PROPERTY_TYPE == 'input'" :id="item.PROPERTY" v-model="widget_models[0].WIDGET_DATA[item.PROPERTY]"> 
                                        <select v-else-if="item.PROPERTY_TYPE == 'select'" :id="item.PROPERTY" v-model="widget_models[0].WIDGET_DATA[item.PROPERTY]">
                                            <option>Seçiniz</option>
                                            <option v-for="val,index in splitedList(item.PROPERTY_VALUES)" :value="val">
                                            {{splitedList(item.PROPERTY_NAMES)[index]}}
                                            </option>
                                        </select>
                                    </div>
                                </div>                            
                            </div>
                            <div class="col col-8 col-md-6 col-sm-12 col-xs-12" v-if="widget_models[0].TITLE.length > 0">
                                <div class="form-group">
                                    <div class="col col-12 mb-2">
                                        <h2>{{widget_models[0].TITLE}}</h2>
                                        <small class="mr-3"><a title="author"><i class="fa fa-user-circle-o"></i> {{widget_models[0].WIDGET_AUTHOR}}</a></small>
                                        <small class="mr-3"><a title="version"><i class="fa fa-tag"></i> {{widget_models[0].WIDGET_VERSION}}</a></small>
                                        <small class="mr-3"><a :href="'/index.cfm?fuseaction=dev.widget&event=add&id='+widget_models[0].WIDGET_NAME+'&woid'" target="_blank"><i class="fa fa-code"></i> WorkDev</a></small>
                                    </div>
                                    <div class="col col-12" v-html="widget_models[0].WIDGET_DESCRIPTION">
                                    </div>              
                                </div>
                            </div>
                        </div>   
                    </div>
                    <div id="unique_box_settings" class="ui-info-text uniqueBox">
                        <div class="row">
                            <div class="col col-4 col-md-6 col-sm-12 col-xs-12">                   
                                <div class="form-group" v-for="(item, index) in BOX_PROPERTIES.OBJECT_PROPERTY">                           
                                    <label class="col col-12">{{item.PROPERTY_DETAIL}}</label>
                                    <div class="col col-12">
                                        <input type="text" v-if="item.PROPERTY_TYPE == 'input'" :id="item.PROPERTY" v-model="widget_models[0].WIDGET_BOX_DATA[item.PROPERTY]"> 
                                        <select v-else-if="item.PROPERTY_TYPE == 'select'" :id="item.PROPERTY" v-model="widget_models[0].WIDGET_BOX_DATA[item.PROPERTY]">
                                            <option>Seçiniz</option>
                                            <option v-for="val,index in splitedList(item.PROPERTY_VALUES)" :value="val">
                                            {{splitedList(item.PROPERTY_NAMES)[index]}}
                                            </option>
                                        </select>
                                    </div>
                                </div> 
                            </div>
                        </div>
                    </div>
                    <div id="unique_extend_css_tab" class="ui-info-text uniqueBox">
                        <div class="form-group">
                            <label class="col col-12">Widget Unique Selector : <kbd>{{"#protein_widget_"+widget_models[0].ID}}</kbd></label>
                        </div>
                        <div class="form-group">
                            <textarea id="css_editor_code_mirror" v-model="widget_models[0].WIDGET_EXTEND.CSS"></textarea>
                        </div>
                    </div>
                    <div id="unique_extend_file_tab" class="ui-info-text uniqueBox">
                        <div class="row">
                            <div class="col col-3 col-md-6 col-sm-12 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12">Append Before : <small>{{widget_models[0].WIDGET_EXTEND.BEFORE}}</small></label>
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <input type="file" accept=".cfm" id="extend_before_file">						 
                                            <span class="input-group-addon icon-minus text-danger btnPointer" @click="update_extend_file('before','delete',widget_models[0].ID)"></span>
                                            <span class="input-group-addon icon-check text-success btnPointer" @click="update_extend_file('before','update',widget_models[0].ID)"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12">Append After : <small>{{widget_models[0].WIDGET_EXTEND.AFTER}}</small></label>
                                    <div class="col col-12">
                                        <div class="input-group">
                                            <input type="file" accept=".cfm"  id="extend_after_file">						 
                                            <span class="input-group-addon icon-minus text-danger btnPointer" @click="update_extend_file('after','delete',widget_models[0].ID)"></span>
                                            <span class="input-group-addon icon-check text-success btnPointer" @click="update_extend_file('after','update',widget_models[0].ID)"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="unique_widget_seo" class="ui-info-text uniqueBox">
                        <div class="row">
                            <div class="col col- col-md-6 col-sm-12 col-xs-12 scroll-md">
                                <div class="form-group">
                                    <label>Schema Markup</label>
                                    <select v-model="widget_models[0].WIDGET_SEO_DATA.SCHEMA_ORG">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option v-for="item in SCHEMA_ORG" :value="item.KEY">
                                            {{item.TITLE}}
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>                            
                </cf_tab>                                          
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <cf_workcube_buttons add_function="proteinApp.save_widget_params()">
            </div>
        </cf_box>
    </div>
</div>
<script>
    var proteinApp = new Vue({
        el: '#protein_widget_params',
        data: {
        key : '',
        OBJECT_PROPERTIES : [],
        BOX_PROPERTIES : [],
        widget_models : [{
            ID : <cfoutput>#attributes.widget#</cfoutput>,
            SITE : <cfoutput>#attributes.site#</cfoutput>,
            STATUS : 1,
            TITLE : '',
            WIDGET_NAME : 0,
            WIDGET_FILE_PATH : "",
            WIDGET_TITLE :"",
            WIDGET_DESCRIPTION : "",
            WIDGET_AUTHOR : "", 
            WIDGET_VERSION : "",  
            WIDGET_DATA : [{}],
            WIDGET_BOX_DATA : [{}],
            WIDGET_EXTEND : [{
                CSS : "",
                BEFORE : "",
                AFTER : ""                
            }],
            WIDGET_SEO_DATA : [{
                SCHEMA_ORG : ''              
            }]
        }],
        key : '',
        wıdgetInformation: {
            WIDGET_TITLE:'',
            WIDGET_DESCRIPTION:'',
        },
        SCHEMA_ORG : [
            {
                KEY: 'Article',
                TITLE : 'Article'
            },
            {
                KEY: 'Breadcrumb',
                TITLE : 'Breadcrumb'
            },
            {
                KEY: 'Event',
                TITLE : 'Event'
            },
            {
                KEY: 'faq',
                TITLE : 'FAQ Page'
            },
            {
                KEY: 'how-to',
                TITLE : 'How-to'
            },
            {
                KEY: 'Job Posting',
                TITLE : 'Job Posting'
            },
            {
                KEY: 'Local Business',
                TITLE : 'Local Business'
            },
            {
                KEY: 'Organization',
                TITLE : 'Organization'
            },
            {
                KEY: 'Person',
                TITLE : 'Person'
            },
            {
                KEY: 'Product',
                TITLE : 'Product'
            },
            {
                KEY: 'Recipe',
                TITLE : 'Recipe'
            },
            {
                KEY: 'Video',
                TITLE : 'Video'
            },
            {
                KEY: 'Website',
                TITLE : 'Website'
            }
        ],            
        error: []
        },
        methods: {
            widget_params_modal : function(widget_id){
                proteinApp.widget_models[0].ID = widget_id;
                axios
                    .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_widget", {params: {id : widget_id}})
                    .then(response => {
                        Vue.set(proteinApp.$data, 'widget_models', response.data.DATA);
                        if(proteinApp.widget_models[0].WIDGET_DATA){
                            var WIDGET_DATA = [];
                            WIDGET_DATA = JSON.parse(proteinApp.widget_models[0].WIDGET_DATA);
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_DATA', WIDGET_DATA);
                        }else{
                            var WIDGET_DATA = [{}];
                        }

                        if(proteinApp.widget_models[0].WIDGET_BOX_DATA){
                            var WIDGET_BOX_DATA = [];
                            WIDGET_BOX_DATA = JSON.parse(proteinApp.widget_models[0].WIDGET_BOX_DATA);
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_BOX_DATA', WIDGET_BOX_DATA);
                        }else{
                            var WIDGET_BOX_DATA = [{}];
                        }


                        if(!proteinApp.widget_models[0].WIDGET_EXTEND){
                            var WIDGET_EXTEND = [{
                                CSS : "",
                                BEFORE : "",
                                AFTER : ""
                            }];                           
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_EXTEND', WIDGET_EXTEND[0]);
                        }else{
                            var WIDGET_EXTEND = [];
                            WIDGET_EXTEND = JSON.parse(proteinApp.widget_models[0].WIDGET_EXTEND);
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_EXTEND', WIDGET_EXTEND);
                        }

                        if(!proteinApp.widget_models[0].WIDGET_SEO_DATA){
                            var WIDGET_SEO_DATA = [{
                                SCHEMA_ORG : '' 
                            }];                           
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_SEO_DATA', WIDGET_SEO_DATA[0]);
                        }else{
                            var WIDGET_EXTEND = [];
                            WIDGET_SEO_DATA = JSON.parse(proteinApp.widget_models[0].WIDGET_SEO_DATA);
                            Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_SEO_DATA', WIDGET_SEO_DATA);
                        }

                        try {
                            css_code_mirror.setValue(proteinApp.widget_models[0].WIDGET_EXTEND.CSS);
                        }
                        catch(err) {/* ilk call da çalışmaz */}                                                

                        var full_path = proteinApp.widget_models[0].WIDGET_FILE_PATH;
                        var file_name = full_path.split('/')[full_path.split('/').length - 1];
                        var folder_path = full_path.replace(file_name,'');
                        xml = file_name.replace('.cfm','.xml');
                        axios
                            .post("/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_xml_settings",
                            {
                                XML : xml
                            })
                            .then(response => {
                                OBJECT_PROPERTIES = JSON.parse(response.data.DATA);

                                if(!OBJECT_PROPERTIES.OBJECT_PROPERTY.length){ //tek param varsa dizi olarak gelmiyor, burası düzeltme olarak eklendi.
                                    e = []
                                    e[0] = OBJECT_PROPERTIES.OBJECT_PROPERTY; 
                                    OBJECT_PROPERTIES.OBJECT_PROPERTY = e;
                                }

                                if(proteinApp.widget_models[0].WIDGET_DATA){
                                    Vue.set(proteinApp.$data, 'OBJECT_PROPERTIES', OBJECT_PROPERTIES);
                                }else{
                                    $.each(OBJECT_PROPERTIES.OBJECT_PROPERTY, function( index, item ) {
                                        WIDGET_DATA[0][item.PROPERTY]=item.PROPERTY_DEFAULT;                            
                                    });
                                    Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_DATA', WIDGET_DATA[0]);
                                    Vue.set(proteinApp.$data, 'OBJECT_PROPERTIES', OBJECT_PROPERTIES);
                                }                         
                            })
                            .catch(e => {
                                alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1002 A",type:"danger"});
                                proteinApp.error.push({ecode: 1002, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                            });

                        axios
                            .post("/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_xml_settings",
                            {
                                XML : 'protein_box_params.xml'
                            })
                            .then(response => {
                                BOX_PROPERTIES = JSON.parse(response.data.DATA);

                                if(!BOX_PROPERTIES.OBJECT_PROPERTY.length){ //tek param varsa dizi olarak gelmiyor, burası düzeltme olarak eklendi.
                                    e = []
                                    e[0] = BOX_PROPERTIES.OBJECT_PROPERTY; 
                                    BOX_PROPERTIES.OBJECT_PROPERTY = e;
                                }
                                Vue.set(proteinApp.$data, 'BOX_PROPERTIES', BOX_PROPERTIES);
                                if(proteinApp.widget_models[0].WIDGET_BOX_DATA){
                                    Vue.set(proteinApp.$data, 'BOX_PROPERTIES', BOX_PROPERTIES);
                                }else{
                                    var WIDGET_BOX_DATA=[{}];
                                    $.each(BOX_PROPERTIES.OBJECT_PROPERTY, function( index, item ) {
                                        WIDGET_BOX_DATA[0][item.PROPERTY]=item.PROPERTY_DEFAULT;                            
                                    });
                                    Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_BOX_DATA', WIDGET_BOX_DATA[0]);
                                    Vue.set(proteinApp.$data, 'BOX_PROPERTIES', BOX_PROPERTIES);
                                }                       
                            })
                            .catch(e => {
                                alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1008",type:"danger"});
                                proteinApp.error.push({ecode: 1008, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                            });                            

                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1003",type:"danger"});
                        proteinApp.error.push({ecode: 1003, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                    });
                
            },
            save_widget_params : function(){  
                if(proteinApp.widget_models[0].TITLE.length == 0){alertObject({message:"Widget başlığı giriniz.",type:"warning"}); return false;}
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=upd_widget", proteinApp.widget_models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Site : " + response.data.IDENTITYCOL+ "Widget kaydedildi 😉",type:"success"});
                            }else{
                                alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                            }
                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1000",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                    })                   
                
                return false;
            },
            widgetInfo : function(widget) {
                console.log(widget);
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_widget_info", {id:widget})
                    .then(response => {
                            if(response.data.STATUS == true){
                                Vue.set(proteinApp.$data, 'wıdgetInformation', response.data.DATA[0]);
                            }else{
                              alertObject({message:"Hata : 2003 - " + response.data.ERROR ,type:"danger"});  
                            }
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 2004 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"Hata : 2004 bir problem meydana geldi..."})
                    })
            },
            keyGenerate : function(len) {
                let text = ""
                let chars = "1234567890abcdefghijklmnopqrstuvwxyz"
            
                for( let i=0; i < len; i++ ) {
                text += chars.charAt(Math.floor(Math.random() * chars.length))
                }

                return text
            },
            splitedList : function(i) {
                let list = i.split(',') 
                return list
            }
        },
        mounted () {
        <cfif isdefined('attributes.widget') and len(attributes.widget)>
            setTimeout(function(){
                proteinApp.widget_params_modal(<cfoutput>#attributes.widget#</cfoutput>)
            }, 300);
        </cfif>     
        }
    })
    $( document ).on( "click", '[data-id="extend_css_tab"]', function() {
        css_code_mirror = CodeMirror.fromTextArea(document.getElementById('css_editor_code_mirror'), {
            mode: "css",
            lineNumbers: true,
        });
        css_code_mirror.save();
        css_code_mirror.on("change",function(){
            Vue.set(proteinApp.$data.widget_models[0].WIDGET_EXTEND, 'CSS', css_code_mirror.getValue());
        });
        $( document ).off('click', '[data-id="extend_css_tab"]'); //bir defa çalışıması için
    });
</script>