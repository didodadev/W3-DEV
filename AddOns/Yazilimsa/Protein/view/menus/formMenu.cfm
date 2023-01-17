<!---
    File :          AddOns\Yazilimsa\Protein\view\pages\formPage.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Protein sayfalarında kullanılacak menüleri oluşturur. form sayfası
    Notes :         /AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc ile çalışır 
    listesi \AddOns\Yazilimsa\Protein\view\sites\menus.cfm
--->
<script src="/JS/assets/plugins/menuDesigner/jquery.nestable.min.js"></script>
<link rel="stylesheet" href="/css/assets/template/w3-menuDesigner/css/jquery.nestable.min.css" />
<script src="/JS/assets/plugins/vue.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js"></script>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css" />

<cfquery name="get_pages" datasource="#dsn#">
    SELECT
        PAGE_ID,
        TITLE,
        FRIENDLY_URL
    FROM
        PROTEIN_PAGES
    WHERE
        SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
        AND STATUS = 1
</cfquery>
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>
<cfset pageHead = "Menu : #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row" id="formMenu"> 
    <div class="col col-3 uniqueRow" >
        <cfsavecontent variable="message"><small class="font-grey-cascade"><strong>Tool</small></cfsavecontent>
        <cf_box title="#message#" closable="0">
            <cfform name="form_menu" enctype="multipart/form-data">
                <cf_box_elements vertical="1">                         
                <div class="form-group col col-12">
                    <label>Title</label>
                    <input type="text" v-model="models[0].MENU_NAME"> 
                </div>
                <div class="form-group col col-6">
                    <label>LANGUAGE</label>
                    <select v-model="models[0].MENU_LANGUAGE">
                        <cfoutput query="get_language">
                            <option value="#LANGUAGE_SHORT#">#LANGUAGE_SET#</option>
                        </cfoutput>
                    </select> 
                </div>
                <div class="form-group col col-3">
                    <label style=" margin-top: 25px !important; ">Active
                        <input type="checkbox" v-model="models[0].MENU_STATUS" true-value="1" false-value="0">
                    </label>
                </div>               
                <div class="form-group col col-3">
                    <label style=" margin-top: 25px !important; ">Default
                        <input type="checkbox" v-model="models[0].IS_DEFAULT" true-value="1" false-value="0">
                    </label>
                </div>
                </cf_box_elements>
                <cf_box_elements vertical="1"> 
                <div class="form-group col-4">
                    <label class="margin-right-10 btnPointer" @click="addMenuItem(keyGenerate(5),'Group','','','group','','')"><i class="fa fa-folder"></i> Grup Oluştur</label>
                </div>
                <div class="form-group col-4">
                    <label class="margin-right-10 btnPointer" @click="addMenuItem(keyGenerate(5),'Link','','','link','','')"><i class="fa fa-link"></i> Link Oluştur</label>
                </div>
                </cf_box_elements>
                <div class="row" type="row">
                    <div class="dd scroll-md" id="menu-basket-all">
                        <cfoutput> 
                        <ol class="dd-list">                       
                            <cfloop query="get_pages">
                                <li class="dd-item dd-nochildren"  data-id="#PAGE_ID#" data-url="#FRIENDLY_URL#" data-name="#TITLE#" data-type="child" data-dictionary="" data-css="" data-icn="" data-login_status="0">
                                    <div class="dd-handle">
                                        <div class="item_title">#TITLE#</div>
                                    </div> 
                                    <div class="item_tools">
                                        <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm('#PAGE_ID#')"></i>
                                        <i title="options" class="fa fa-paint-brush edit_item" @click="editItem('#PAGE_ID#')"></i>   
                                    </div>
                                </li>
                            </cfloop>
                        </ol>                         
                        </cfoutput>
                    </div>
                </div>
                <div class="row formContentFooter">                    
                    <cfif attributes.event eq 'upd'>
                        <div class="col col-12">
                            <cfset GET_MENU_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_MENU_RECORD_INFO(menu:attributes.menu)>
                            <cf_record_info query_name="GET_MENU_RECORD_INFO">
                        </div>
                        <div class="col col-12 mt-3">
                            <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinApp.deleteMenuConfirm()" add_function="proteinApp.save()">
                        </div>
                    <cfelse>
                        <div class="col col-12">
                        <cf_workcube_buttons add_function="proteinApp.save()">
                        </div>
                    </cfif>                    
                </div>
            </cfform>
        </cf_box>
    </div>
    <div class="col col-4 col-xs-12 uniqueRow">
        <cfsavecontent variable="message"><small class="font-grey-cascade"><strong>Menu</small></cfsavecontent>
        <cf_box title="#message#" closable="0">
                <div class="row" type="row">
                    <div class="col col-12">
                        <div class="dd" id="menu-basket">
                            <ol class="dd-list" v-if="models[0].MENU_DATA.length">
                                <li v-for="item in models[0].MENU_DATA[0]"
                                    class="dd-item" 
                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                    v-bind:data-id="item.id" 
                                    v-bind:data-type="item.type" 
                                    v-bind:data-name="item.name" 
                                    v-bind:data-dictionary="item.dictionary"
                                    v-bind:data-url="item.url"
                                    v-bind:data-css="item.css"
                                    v-bind:data-icn="item.icn"
                                    v-bind:data-login_status="item.login_status"
                                    v-once="models[0]"
                                    >
                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                    <div class="dd-handle">
                                        <div class="item_title">{{item.name}}</div>
                                    </div> 
                                    <div class="item_tools">
                                        <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>                                 
                                        <i title="options" class="fa fa-paint-brush edit_item"  @click="editItem(item.id)" ></i>
                                        <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i> 
                                    </div>
                                    <ol class="dd-list" v-if="item.children"><!--- Depth 1 --->
                                        <li v-for="item in item.children"
                                            class="dd-item" 
                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                            v-bind:data-id="item.id" 
                                            v-bind:data-type="item.type" 
                                            v-bind:data-name="item.name" 
                                            v-bind:data-dictionary="item.dictionary"
                                            v-bind:data-url="item.url"
                                            v-bind:data-css="item.css"
                                            v-bind:data-icn="item.icn"
                                            v-bind:data-login_status="item.login_status"
                                            >
                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                            <div class="dd-handle">
                                                <div class="item_title">{{item.name}}</div>
                                            </div> 
                                            <div class="item_tools">
                                                <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>
                                                <i title="options" class="fa fa-paint-brush editItem"  @click="editItem(item.id)" ></i>  
                                                <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i>    
                                            </div>
                                            <ol class="dd-list" v-if="item.children"><!--- Depth 2 --->
                                                <li v-for="item in item.children"
                                                    class="dd-item" 
                                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                    v-bind:data-id="item.id" 
                                                    v-bind:data-type="item.type" 
                                                    v-bind:data-name="item.name" 
                                                    v-bind:data-dictionary="item.dictionary"
                                                    v-bind:data-url="item.url"
                                                    v-bind:data-css="item.css"
                                                    v-bind:data-icn="item.icn" 
                                                    v-bind:data-login_status="item.login_status"
                                                    >
                                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                    <div class="dd-handle">
                                                        <div class="item_title">{{item.name}}</div>
                                                    </div> 
                                                    <div class="item_tools">
                                                        <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>
                                                        <i title="options" class="fa fa-paint-brush editItem"  @click="editItem(item.id)" ></i>
                                                        <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i> 
                                                    </div>
                                                    <ol class="dd-list" v-if="item.children"><!--- Depth 3 --->
                                                        <li v-for="item in item.children"
                                                            class="dd-item" 
                                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                            v-bind:data-id="item.id" 
                                                            v-bind:data-type="item.type" 
                                                            v-bind:data-name="item.name" 
                                                            v-bind:data-dictionary="item.dictionary"
                                                            v-bind:data-url="item.url"
                                                            v-bind:data-css="item.css"
                                                            v-bind:data-icn="item.icn"
                                                            v-bind:data-login_status="item.login_status"
                                                            >
                                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                            <div class="dd-handle">
                                                                <div class="item_title">{{item.name}}</div>
                                                            </div> 
                                                            <div class="item_tools">
                                                                <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>
                                                                <i title="options" class="fa fa-paint-brush editItem"  @click="editItem(item.id)" ></i>
                                                                <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i>    
                                                            </div>
                                                            <ol class="dd-list" v-if="item.children"><!--- Depth 4 --->
                                                                <li v-for="item in item.children"
                                                                    class="dd-item" 
                                                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                                    v-bind:data-id="item.id" 
                                                                    v-bind:data-type="item.type" 
                                                                    v-bind:data-name="item.name" 
                                                                    v-bind:data-dictionary="item.dictionary"
                                                                    v-bind:data-url="item.url"
                                                                    v-bind:data-css="item.css"
                                                                    v-bind:data-icn="item.icn"
                                                                    v-bind:data-login_status="item.login_status"
                                                                    >
                                                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                                    <div class="dd-handle">
                                                                        <div class="item_title">{{item.name}}</div>
                                                                    </div> 
                                                                    <div class="item_tools">
                                                                        <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>
                                                                        <i title="options" class="fa fa-paint-brush editItem"  @click="editItem(item.id)" ></i>
                                                                        <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i>    
                                                                    </div>
                                                                    <ol class="dd-list" v-if="item.children"><!--- Depth 5 --->
                                                                        <li v-for="item in item.children"
                                                                            class="dd-item" 
                                                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                                            v-bind:data-id="item.id" 
                                                                            v-bind:data-type="item.type" 
                                                                            v-bind:data-name="item.name" 
                                                                            v-bind:data-dictionary="item.dictionary"
                                                                            v-bind:data-url="item.url"
                                                                            v-bind:data-css="item.css"
                                                                            v-bind:data-icn="item.icn"
                                                                            v-bind:data-login_status="item.login_status"
                                                                            >
                                                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                                            <div class="dd-handle">
                                                                                <div class="item_title">{{item.name}}</div>
                                                                            </div> 
                                                                            <div class="item_tools">
                                                                                <i title="delete" class="fa fa-trash delete_item" @click="deleteItemConfirm(item.id)"></i>
                                                                                <i title="options" class="fa fa-paint-brush editItem"  @click="editItem(item.id)" ></i>
                                                                                <i title="mega menu" class="fa fa fa-cubes" v-if="item.type == 'group' && models[0].ID" @click="megamenu(item.id)" ></i>   
                                                                            </div>
                                                                        </li>                            
                                                                    </ol>
                                                                </li>                            
                                                            </ol>
                                                        </li>                            
                                                    </ol>
                                                </li>                            
                                            </ol>
                                        </li>                            
                                    </ol>
                                </li>                            
                            </ol>
                        </div>
                    </div>
                </div>
        </cf_box>
    </div>

    <div class="ui-cfmodal" id="protein_menu_option" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="protein_menu_option_box" title="Item Parameters" closable="1" call_function="cfmodalx({e:'close',id:'protein_menu_option'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <form name="edit_item">
                    <div class="row">
                        <div class="col col-12" >
                            <div class="form-group">
                                <label class="col col-12">Title</label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" class="form-control" id="idictionary_id"  name="idictionary_id" >
                                        <input type="text" class="form-control"  id="iName">
                                        <span class="input-group-addon" id=""><i class="fa fa-book" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=edit_item.idictionary_id&amp;lang_item_name=edit_item.iName','list');return false"></i></span>
                                    </div>
                                </div>           
                            </div>
                            <div class="form-group">
                                <label class="col col-12">Icon</label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="iicn">
                                        <span class="input-group-addon" id=""><i title="options" class="fa fa-paint-brush" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=iicn','medium');"></i></span>
                                    </div>
                                </div>                
                            </div>
                            <div class="form-group" v-if="selected_item_type != 'group'">
                                <label class="col col-12">Url</label>
                                <div class="col col-12">
                                    <input type="text" class="form-control" id="iUrl"> 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12">Css</label>
                                <div class="col col-12">
                                    <input type="text" class="form-control" id="iCss"> 
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-12">Login Gerekli</label>
                                <div class="col col-12">
                                    <input type="checkbox" class="form-control" id="ilogin_status">
                                </div>
                            </div>   
                        </div>
                    </div>
                </form>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <button type="button" class="btn btn-info pull-right margin-right-5" data-dismiss="modal" @click="cfmodalx({e:'close',id:'protein_menu_option'});">Vazgeç</button>
                <button type="button" class="btn btn-success pull-right margin-right-5" @click="saveEditItem(selected_item)">Kaydet</button>
            </div>
        </cf_box>
    </div>

    <div class="ui-cfmodal" id="protein_menu_delete" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="protein_menu_delete_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'protein_menu_delete'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                            {{selected_item}} Id'li Menü Elamanı Silinecek Onaylıyor Musun?
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <button type="button" class="btn btn-info pull-right margin-right-5" data-dismiss="modal" @click="cfmodalx({e:'close',id:'protein_menu_delete'});">Vazgeç</button>
                <button type="button" class="btn btn-danger pull-right margin-right-5" @click="deleteItem(selected_item)">Sil</button>
            </div>
        </cf_box>
    </div>
    
    <div class="ui-cfmodal" id="del_menu_confirm_modal" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="del_menu_confirm_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'del_menu_confirm_modal'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                        <cfif isdefined('attributes.site') and len(attributes.site)> <cfoutput>#thısDomaın.DOMAIN#</cfoutput></cfif> sitesinde {{models[0].TITLE}} başlıklı menu silinecek onaylıyor musun?
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <button type="button" class="btn btn-info pull-right margin-right-5" data-dismiss="modal" @click="cfmodalx({e:'close',id:'del_menu_confirm_modal'});">Vazgeç</button>
                <button type="button" class="btn btn-danger pull-right margin-right-5" @click="deleteMenu()">Sil</button>
            </div>
        </cf_box>
    </div>

<script>
    var proteinApp = new Vue({
        el: '#formMenu',
        data: {
        vue_test : '⚡Protein 2020',
        key : '',
        selected_item : 0,
        selected_item_type : '',    
        method : '<cfoutput>#attributes.event#</cfoutput>_menu', 
        models : [{
            ID : <cfif isdefined('attributes.menu') and len(attributes.menu)><cfoutput>#attributes.menu#</cfoutput><cfelse>null</cfif>,
            SITE : <cfoutput>#attributes.site#</cfoutput>,
            MENU_NAME : '',
            MENU_STATUS : 1,
            IS_DEFAULT : 1,
            MENU_LANGUAGE : "tr",
            MENU_DATA : []
        }],            
        error: []
        },
        methods: {
            randomNumber : function(){
              return (Math.floor(Math.random() * 10000) + 10000).toString().substring(1);
            },
            save : function(){  
                if($('#menu-basket').nestable('serialize').length == 0){
                    alertObject({message:'Menu Boş Soldaki Nesneler İle Menü Oluşturunuz...'}); return false;
                }else{
                    proteinApp.models[0].MENU_DATA = JSON.stringify($('#menu-basket').nestable('serialize'));
                }
                if(proteinApp.models[0].MENU_NAME.length == 0){alertObject({message:"Menü başlığı giriniz.",type:"warning"}); return false;}

                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinApp.method, proteinApp.models[0])
                    .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Site : " + response.data.IDENTITYCOL+ "menu kaydedildi 😉",type:"success"});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.menus&event=upd&menu=" + response.data.IDENTITYCOL + "&site=<cfoutput>#attributes.site#</cfoutput>";} , 2000);
                            
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1000",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    })                   
                
                return false;
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
            },
            deleteItemConfirm : function(e) {
                proteinApp.selected_item = e;
                cfmodalx({e:'open',id:'protein_menu_delete'});
                console.log('deleteItemConfirm fn' + e);
            },
            deleteItem : function(e) {
                proteinApp.selected_item = e;
                var item =  e;
                $('#menu-basket').nestable('remove', item, function(){
                    if($('#menu-basket').nestable('serialize').length == 0 && !$('#menu-basket').find('.dd-empty').length){
                        $('#menu-basket').find('.dd-list').remove();
                    }
                });
                $('#menu-basket').nestable('remove', item);
                cfmodalx({e:'close',id:'protein_menu_delete'});
                console.log('deleteItemfn' + e);
            },            
            editItem : function(e) {
                proteinApp.selected_item = e;
                data = $('#menu-basket [data-id="'+e+'"]').data();
                console.log(data);
                $('#iName').val(data.name);
                $('#iUrl').val(data.url);
                $('#idictionary_id').val(data.dic);
                $('#iCss').val(data.css);
                $('#iicn').val(data.icn);

                if(data.login_status == 1){
                    $('#ilogin_status').prop('checked', true);
                }else{
                    $('#ilogin_status').prop('checked', false);
                }
                

                proteinApp.selected_item_type = data.type;
                cfmodalx({e:'open',id:'protein_menu_option'});
                console.log('editItem fn' + e);
            },
            saveEditItem : function(e) {
                var item = $('#menu-basket [data-id="'+e+'"]');
                data = item.data();
                
                data.name = $('#iName').val();
                data.url =  $('#iUrl').val()
                data.dictionary = $('#idictionary_id').val();
                data.css = $('#iCss').val()
                data.icn = $('#iicn').val();
                if($('#ilogin_status').is(':checked')){
                     data.login_status = 1;
                     login_status_ = 1;
                }else{
                     data.login_status = 0;
                     login_status_ = 0;
                }
               console.log(data);

                item.attr({
                    'data-name':$('#iName').val(),
                    'data-url':$('#iUrl').val(),
                    'data-dictionary':$('#idictionary_id').val(),
                    'data-css':$('#iCss').val(),
                    'data-icn':$('#iicn').val(),
                    'data-login_status':login_status_
                });

                
                $('[data-id="'+e+'"] .item_title:first').empty().append($('#iName').val());
                cfmodalx({e:'close',id:'protein_menu_option'});
                console.log('saveEditItem fn' + e);
            },
            addMenuItem: function(id,name,url,dic,type,css,icn,login_status){
                var item = $('<li>')
                if(type == 'link'){
                    item.addClass('dd-item dd-nochildren');
                }else{
                    item.addClass('dd-item type-group');
                }
                item.attr({
                    'data-id':id,
                    'data-name':name,
                    'data-url':url,
                    'data-type':type,
                    'data-dictionary':dic,
                    'data-css':css,
                    'data-icn':icn,
                    'data-login_status':login_status
                });

                item.append('<div class="dd-handle"><div class="item_title">'+name+'</div></div>');
                var item_tools = $("<div>").addClass("item_tools");
                item_tools.append('<i title="delete" class="fa fa-trash delete_item" onClick="proteinApp.deleteItemConfirm(\''+id+'\')"></i>');
                
                item_tools.append('<i title="options" class="fa fa-paint-brush edit_item" onClick="proteinApp.editItem(\''+id+'\')"></i>');
                if(type == 'group')item_tools.append('<i title="mega menu" class="fa fa-cubes edit_item" onClick="proteinApp.megaMenu(\''+id+'\')"></i>');
                item.append(item_tools);
                

                if($('#menu-basket').find('.dd-empty').length){
                    $('#menu-basket .dd-empty').remove();
                    $('#menu-basket').append('<ol class="dd-list"></ol>');
                }
                
                $('#menu-basket > ol.dd-list').append(item);    
                
            },
            deleteMenuConfirm : function(){                
                cfmodalx({e:'open',id:'del_menu_confirm_modal'});
            },
            deleteMenu : function(){
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_menu",{params:{menu:proteinApp.models[0].ID}})
                .then(response => {
                    if(response.data.STATUS == true){
                        alertObject({message:"Sayfa Silindi.",type:"success"}); 
                        cfmodalx({e:'close',id:'del_menu_confirm_modal'});
                        setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site&event=upd&site=<cfoutput>#attributes.site#</cfoutput>"} , 2000);                               
                    }else{
                        alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                    }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_menu_confirm_modal'});
                    proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                })
            },
            megamenu : function(m){
                window.open('/index.cfm?fuseaction=protein.menus&event=upd_megamenu&site='+proteinApp.models[0].SITE+'&menu='+proteinApp.models[0].ID+'&megamenu='+m, 'megamenu');
            },
            
        },
        mounted () {
            <cfif isdefined('attributes.menu') and len(attributes.menu)>
            axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_menu", {params: {id :<cfoutput>#attributes.menu#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].MENU_DATA.length){
                        Vue.set(proteinApp.$data, 'models', response.data.DATA);
                        var MENU_DATA = [];
                        MENU_DATA[0] = JSON.parse(response.data.DATA[0].MENU_DATA);
                        console.log(JSON.parse(response.data.DATA[0].MENU_DATA));
                        Vue.set(proteinApp.$data.models[0], 'MENU_DATA', MENU_DATA);

                        setTimeout(function(){
                            $('#menu-basket').nestable({
                                maxDepth : 5
                            });
                            $('#menu-basket-all').nestable({
                                maxDepth : 5,
                                clone : false,
                                insertable : false
                            });  
                        }, 2000);  
                                                 
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 1001, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                });
            <cfelse>
                $('#menu-basket').nestable({
                    maxDepth : 5
                });
                $('#menu-basket-all').nestable({
                    maxDepth : 5,
                    clone : false,
                    insertable : false
                });
            </cfif>  
           
           
        }
    });  
</script>