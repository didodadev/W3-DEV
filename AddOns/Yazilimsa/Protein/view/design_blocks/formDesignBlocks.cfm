<!---
    File :          AddOns\Yazilimsa\Protein\view\design_blocks\formDesignBlocks.cfm
    AUTHOR :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          09.04.2020
    Description :   Protein sitelerinde kullanılacak bağımsız html design block'ları oluşturur günceller
--->
<cfparam name="attributes.design_block_id" default="">
<cfparam name="attributes.widget_id" default="">


<script src="/JS/assets/plugins/vue.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
<script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js"></script>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css" />
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,'design_block_'+LANGUAGE_SHORT LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>

<cf_catalystHeader>
  
<div id="formDesignBlock"> 
    <cfsavecontent variable="message">Design Block Editor</cfsavecontent> 
    <cf_box title="#message#" uidrop="1" hide_table_column="1"> 
        <div class="row">
            <div class="col col-12 uniqueRow">
                <cfform name="desgin_block_#session.ep.language#" enctype="multipart/form-data">
                    <cf_box_elements vertical="1">   
                        <div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-domain">
                                <label class="col col-4 col-sm-12">Başlık</label>
                                <div class="col col-8 col-sm-12">
                                    <input type="text"  v-model="models[0].BLOCK_CONTENT_TITLE" maxlength="500"> 
                                </div>
                            </div>
                            <div class="form-group" id="item-domain">
                                <label class="col col-4 col-sm-12">AUTHOR</label>
                                <div class="col col-8 col-sm-12">
                                    <input type="text" v-model="models[0].AUTHOR" maxlength="500"> 
                                </div>
                            </div>
                            <div class="form-group" id="item-thumbnail_file" v-if="method == 'upd_design_blocks'">                  
                                <label class="col col-4 col-sm-12">Thumbnail</label>
                                <div class="col col-8 col-sm-12">
                                    <div class="input-group">
                                        <input type="file" accept=".jpg,.jpeg,.png"  id="thumbnail_file">						 
                                        <span class="input-group-addon icon-minus text-danger btnPointer" @click="update_file('THUMBNAIL','delete')"></span>
                                        <span class="input-group-addon icon-check text-success btnPointer" @click="update_file('THUMBNAIL','update')"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-5 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" v-if="models[0].THUMBNAIL">
                                <img :src="'/documents/design_blocks_thumbnail/'+models[0].THUMBNAIL"/ style="height: 150px !important;">
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_elements vertical="1">
                        <div class="col col-12" type="column" index="3" sort="true"> 
                            <cf_tab defaultOpen="design_block_#session.ep.language#" divId="#ValueList(get_language.LANGUAGE_SHORT,",")#" divLang="#ValueList(get_language.LANGUAGE_SET,";")#">
                                <cfloop query="get_language">
                                    <div id="unique_<cfoutput>#LANGUAGE_SHORT#</cfoutput>" class="ui-info-text uniqueBox">                 
                                        <div class="form-group" id="item-BLOCK_CONTENT_<cfoutput>#LANGUAGE_SHORT#</cfoutput>">
                                            <textarea id="block_content_editor_<cfoutput>#LANGUAGE_SHORT#</cfoutput>" v-model="models[0].BLOCK_CONTENT.<cfoutput>#LANGUAGE_SHORT#</cfoutput>">                
                                            </textarea>   
                                        </div>
                                    </div>
                                </cfloop> 
                            </cf_tab>

                        </div>
                    </cf_box_elements> 
                </cfform>                    
            </div>
        </div>
        <div class="row">
            <cf_box_footer>  
                <cfif attributes.event eq 'upd'>                            
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfset GET_PAGE_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_DESIGN_BLOCK_RECORD_INFO(design_block_id:attributes.design_block_id)>
                        <cf_record_info query_name="GET_PAGE_RECORD_INFO">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">               
                        <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinApp.deleteConfirm()" add_function="proteinApp.save()">
                    </div>
                <cfelse>
                    <cf_workcube_buttons add_function="proteinApp.save()">
                </cfif>
            </cf_box_footer>   
        </div>
    </cf_box>

    <div class="ui-cfmodal" id="del_designblock_confirm_modal" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="del_pageconfirm_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'del_designblock_confirm_modal'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                        kayıt silinecek onaylıyor musun?
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <cf_workcube_buttons extraButton="1"  extraFunction="proteinApp.delete()" extraButtonText = "#getLang('main',51)#">
            </div>
        </cf_box>
    </div>
</div>
<script>

var proteinApp = new Vue({
        el: '#formDesignBlock',
        data: {
        method : '<cfoutput>#attributes.event#</cfoutput>_design_blocks',
        models : [{
            ID : <cfif isdefined('attributes.design_block_id') and len(attributes.design_block_id)><cfoutput>#attributes.design_block_id#</cfoutput><cfelse>null</cfif>,
            DESIGN_BLOCK_ID : 0,
            BLOCK_CONTENT_TITLE : '',
            AUTHOR : '',
            THUMBNAIL: '',
            BLOCK_CONTENT : {
                <cfloop query="get_language">
                    <cfoutput>#LANGUAGE_SHORT#</cfoutput>:"",
                </cfloop>
                LOREM:""
            },
            widget_id : '<cfoutput>#attributes.widget_id#</cfoutput>'
        }],             
        error: []
        },
        methods: {
           runEditor : function(){
               /* var useDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches; */
                var useDarkMode = false;
                <cfloop query="get_language">                  
                    tinymce.init({
                        selector: 'textarea#block_content_editor_<cfoutput>#LANGUAGE_SHORT#</cfoutput>',
                        plugins: 'print preview paste importcss searchreplace autolink autosave save directionality code visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap quickbars emoticons',
                        imagetools_cors_hosts: ['picsum.photos'],
                        menubar: 'file edit view insert format tools table help',
                        toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist | forecolor backcolor removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media template link anchor codesample | ltr rtl',
                        toolbar_sticky: true,
                        paste_data_images: true,
                        autosave_ask_before_unload: true,
                        autosave_interval: '2s',
                        autosave_prefix: '{path}{query}-{id}-',
                        autosave_restore_when_empty: false,
                        autosave_retention: '2m',
                        image_advtab: true,
                        link_list: [
                            { title: 'My page 1', value: 'https://www.tiny.cloud' },
                            { title: 'My page 2', value: 'http://www.moxiecode.com' }
                        ],
                        image_list: [
                            { title: 'My page 1', value: 'https://www.tiny.cloud' },
                            { title: 'My page 2', value: 'http://www.moxiecode.com' }
                        ],
                        image_class_list: [
                            { title: 'None', value: '' },
                            { title: 'Some class', value: 'class-name' }
                        ],
                        importcss_append: true,
                        file_picker_callback: function (callback, value, meta) {
                            /* Provide file and text for the link dialog */
                            if (meta.filetype === 'file') {
                            callback('https://www.google.com/logos/google.jpg', { text: 'My text' });
                            }

                            /* Provide image and alt text for the image dialog */
                            if (meta.filetype === 'image') {
                            callback('https://www.google.com/logos/google.jpg', { alt: 'My alt text' });
                            }

                            /* Provide alternative source and posted for the media dialog */
                            if (meta.filetype === 'media') {
                            callback('movie.mp4', { source2: 'alt.ogg', poster: 'https://www.google.com/logos/google.jpg' });
                            }
                        },
                        templates: [
                                { title: 'New Table', description: 'creates a new table', content: '<div class="mceTmpl"><table width="98%%"  border="0" cellspacing="0" cellpadding="0"><tr><th scope="col"> </th><th scope="col"> </th></tr><tr><td> </td><td> </td></tr></table></div>' },
                            { title: 'Starting my story', description: 'A cure for writers block', content: 'Once upon a time...' },
                            { title: 'New list with dates', description: 'New List with dates', content: '<div class="mceTmpl"><span class="cdate">cdate</span><br /><span class="mdate">mdate</span><h2>My List</h2><ul><li></li><li></li></ul></div>' }
                        ],
                        template_cdate_format: '[Date Created (CDATE): %m/%d/%Y : %H:%M:%S]',
                        template_mdate_format: '[Date Modified (MDATE): %m/%d/%Y : %H:%M:%S]',
                        height: 600,
                        image_caption: true,
                        quickbars_selection_toolbar: 'bold italic | quicklink h2 h3 blockquote quickimage quicktable',
                        noneditable_noneditable_class: 'mceNonEditable',
                        toolbar_mode: 'sliding',
                        contextmenu: 'link image imagetools table',
                        skin: useDarkMode ? 'oxide-dark' : 'oxide',
                        content_css: useDarkMode ? 'dark' : 'default',
                        content_style: 'body { font-family:Helvetica,Arial,sans-serif; font-size:14px }',
                        element_format : 'html',
                        valid_elements : '*[*]',
                        valid_children : '+body[style]',
                        extended_valid_elements:"style,link[href|rel]",
                        custom_elements:"style,link,~link"
                    });
                </cfloop>  

                
            },
            save : function(){
                const _this = this;
                <cfloop query="get_language">
                    _this.models[0].BLOCK_CONTENT.<cfoutput>#LANGUAGE_SHORT#</cfoutput> = tinyMCE.get('block_content_editor_<cfoutput>#LANGUAGE_SHORT#</cfoutput>').getContent();
                </cfloop>  

                if(_this.models[0].BLOCK_CONTENT_TITLE.length == 0){alertObject({message:"Başlık giriniz.",type:"warning"}); return false;}
                if(_this.models[0].AUTHOR.length == 0){alertObject({message:"AUTHOR giriniz.",type:"warning"}); return false;}
                if(_this.models[0].BLOCK_CONTENT.length == 0){alertObject({message:"Content giriniz.",type:"warning"}); return false;}
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+_this.method, _this.models[0])
                    .then(response => {
                        if(response.data.STATUS == true){
                            if(_this.method == 'add_design_blocks'){
                                alertObject({message:"Design block created.🧩",type:"success"}); 
                                setTimeout(function(){
                                    window.location="/index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id=" + response.data.IDENTITYCOL;
                                } , 2000);   
                            }else{
                                alertObject({message:"Design block updated.🧩",type:"success"});
                            } 
                        }else{
                            alertObject({message:"ERROR : 01 - " + response.data.ERROR ,type:"danger"});  
                        }                            
                    })
                    .catch(e => {
                        alertObject({message:"ERROR : 02 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                })                
                return false;              
            },
            update_file : function(type,action){
                
                var formData = new FormData();
                
                var sfile = document.querySelector('#thumbnail_file');
                var delete_file = proteinApp.models[0].THUMBNAIL;
                              
                formData.append("file", sfile.files[0]);
                formData.append("type", type);
                formData.append("id", proteinApp.models[0].ID);

                if(action == "delete"){
                    formData.append("delete_file", delete_file); 
                }

                axios.post('/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method='+action+'_design_block_thumbnail_file', formData, {
                    headers: {
                    'Content-Type': 'multipart/form-data'
                    }
                })
                .then(response => {                        
                    if(response.data.STATUS == true){
                        if(action == "update"){    
                            alertObject({message:"Dosya Kaydedildi 😉",type:"success"});                            
                            proteinApp.models[0].THUMBNAIL =  response.data.FILE;
                        }else{
                            alertObject({message:"Dosya Silindi 😉",type:"success"});
                            proteinApp.models[0].THUMBNAIL = "";                            
                        }                                                                   
                    }else{
                    alertObject({message:"Hata : 2005 - " + response.data.ERROR ,type:"danger"});  
                    }                            
                })
                .catch(e => {
                    alertObject({message:"Hata : 2006 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                })
            },
            deleteConfirm : function(){                
                cfmodalx({e:'open',id:'del_designblock_confirm_modal'});
            },
            delete : function(){
                const _this = this;
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_design_blocks",{params: {id :_this.models[0].ID,widget_id :_this.models[0].widget_id}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Kayıt Silindi.",type:"success"}); 
                            cfmodalx({e:'close',id:'del_designblock_confirm_modal'});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.design_blocks"} , 2000);                               
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_designblock_confirm_modal'});
                    proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                }) 
                
            }            
        },
        mounted () {
            const _this = this;
            if(_this.models[0].ID){
                alertObject({message:"design block record called",type:"warning"});
                axios
                    .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_desing_blocks", {params: {id :_this.models[0].ID,widget_id :_this.models[0].widget_id}})
                    .then(response => {
                        if(response.data.DATA){
                            getData = response.data.DATA;
                            getData[0].widget_id = '<cfoutput>#attributes.widget_id#</cfoutput>';
                            /* dil kullanılmadan önce oluşturulanlar için hotfix */
                            Vue.set(_this.$data, 'models', getData);
                            console.log(JSON.parse(getData[0].BLOCK_CONTENT))
                            if(!JSON.parse(getData[0].BLOCK_CONTENT)){
                                legacy_content = getData[0].BLOCK_CONTENT;
                                getData[0].BLOCK_CONTENT = {};                                
                                <cfloop query="get_language">
                                    getData[0].BLOCK_CONTENT.<cfoutput>#LANGUAGE_SHORT#</cfoutput> = legacy_content;                                    
                                </cfloop>  
                            }else{
                                Vue.set(_this.$data.models[0], 'BLOCK_CONTENT', JSON.parse(getData[0].BLOCK_CONTENT));
                            }
                            /* END */

                            
                            
                        }
                        _this.runEditor();
                    })
                    .catch(e => {
                        console.log(e)
                        alertObject({message:"Error: system failed to respond, try again later.",type:"danger"});
                    });             
            }else{
                _this.runEditor(); 
            } 
        },
    });

    
    
</script>