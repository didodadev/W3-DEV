<!---
    File :          AddOns\Yazilimsa\Protein\view\menus\formMegaMenu.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          30.12.2020
    Description :   Alt menülerü widgetlarla design etmeyi sağlar. form sayfası
    Notes :         /AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc ile çalışır formMenü.cfm den gidilir gidilir
--->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery-sortablejs@latest/jquery-sortable.js"></script> 
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
<script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js"></script>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css" />
<cfquery name="company_cat" datasource="#dsn#">
    SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="consumer_cat" datasource="#dsn#">
    SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT 
</cfquery>
<cfquery name="PROTEIN_WIDGET" datasource="#dsn#">
    SELECT 
        W.WIDGETID,
        W.WIDGET_TITLE,
        W.WIDGETMODULENO MODULE_NO,
        M.MODULE_DICTIONARY_ID,
        DC.ITEM_#session.ep.LANGUAGE# MODULE_TITLE,
        ISNULL(M.ICON,'ctl-045-warehouse') ICON
    FROM 
        WRK_WIDGET W
        LEFT JOIN WRK_MODULE M ON M.MODULE_ID = W.WIDGETMODULENO
        LEFT JOIN SETUP_LANGUAGE_TR DC ON DC.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
    WHERE
        W.WIDGET_TOOL = 'code' 
        AND W.WIDGET_STATUS = 'Deployment'
        AND W. WIDGETMODULENO IS NOT NULL
    ORDER BY W.WIDGETMODULENO ASC
</cfquery>
<cfset wdigetListJson = Replace(SerializeJSON(PROTEIN_WIDGET,'STRUCT'),"//","")>
<cfquery name="get_body_template" datasource="#dsn#">
    SELECT TITLE,TEMPLATE_ID AS ID FROM PROTEIN_TEMPLATES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#"> AND TYPE=1 AND STATUS = 1
</cfquery>
<cfquery name="get_body_inside" datasource="#dsn#">
    SELECT TITLE,TEMPLATE_ID AS ID FROM PROTEIN_TEMPLATES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#"> AND TYPE=2 AND STATUS = 1
</cfquery>
<cfquery name="get_body_inside" datasource="#dsn#">
    SELECT TITLE,TEMPLATE_ID AS ID FROM PROTEIN_TEMPLATES WHERE SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#"> AND TYPE=2 AND STATUS = 1
</cfquery>
<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfset pageHead = "Mega Menu : #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row" id="addMegaMenu"> 
    <div class="col col-3 uniqueRow" id="content">
        <cfsavecontent variable="message">Definitions</cfsavecontent>
        <cf_box title="#message#" closable="0">
             <cfform name="form_megamenu" enctype="multipart/form-data">
                <cf_box_elements vertical="1">                         
                    <div class="form-group col col-12">   
                        <label>Aktif</label>
                        <input type="checkbox" v-model="models[0].STATUS" true-value="1" false-value="0">
                    </div>
                    <div class="form-group col col-12">
                        <label>Başlık</label>
                        <input type="text" v-model="models[0].TITLE" maxlength="140">
                    </div>                    
                </cf_box_elements>
            </cfform>
        </cf_box>
        <cfsavecontent variable="message">Widgets</cfsavecontent>
        <cf_box title="#message#" closable="0">
            <ul class="ui-list widget-list-main" >                
                <li data-widget_title="Sub Menu" data-widget_id="-2">
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-029-crane"></span>
                            Sub Menu
                        </div>
                        <div class="ui-list-right">
                            <i class="icon-question" title="alt menülerin yükleneceği alan"></i>
                        </div>
                    </a>
                </li>
            </ul>
            <div class="widget-search-input">
                <i class="fa fa-search"></i>
                <input type="text" v-model="widget_filter_keyword" placeholder="arama yap...">
            </div>
            <div class="widget-search-count" v-show="widget_filter_keyword.length > 2">{{widget_filtered.length}} Sonuç Bulundu</div>            
            <ul class="scroll-md ui-list filter-widget-list" v-for="(item,name) in widget_filtered">
                <li :data-widget_title="item.WIDGET_TITLE" data-widget_id="" :data-wrk_widget_id="item.WIDGETID" :data-wrk_widget_default_title="item.WIDGET_TITLE">
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-packing-3"></span>
                            <span id="widget_title">{{item.WIDGET_TITLE}}</span>
                        </div>
                        <div class="ui-list-right">
                            <i class="icon-question" @click="widgetInfo(item.WIDGETID)"></i>
                        </div>
                    </a>
                </li>
            </ul>
            <ul class="scroll-md ui-list" v-show="widget_filter_keyword.length < 2"> 
                <li>
                    <a href="javascript:void(0)" onClick="$(this).next('ul').slideToggle(200)" style=" position: sticky; top: -1px; background: white; ">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-light-bulb"></span>
                            Main Widgets
                        </div>
                    </a>
                    <ul class="widget-list-main" style="display:none;">
                        <li data-widget_title="<cf_get_lang dictionary_id='65346.Design Block'>" data-wrk_widget_id="-2" data-widget_id data-wrk_widget_default_title="<cf_get_lang dictionary_id='65346.Design Block'>">
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-web-page"></span>
                                    <span id="widget_title"><cf_get_lang dictionary_id='65346.Design Block'></span>
                                </div>
                                <div class="ui-list-right">
                                    <i class="icon-question" @click="widgetInfo(-2)"></i>
                                </div>
                            </a>
                        </li>
                    </ul>
                </li>
                <cfquery name="PROTEIN_WIDGET" datasource="#dsn#">
                    SELECT 
                        W.WIDGETID,
                        W.WIDGET_TITLE,
                        M.MODULE_NO ,
                        M.MODULE_DICTIONARY_ID,
                        ISNULL(DC.ITEM_#session.ep.LANGUAGE#,'PROTEIN') MODULE_TITLE,
                        ISNULL(M.ICON,'ctl-045-warehouse') ICON
                    FROM 
                        WRK_WIDGET W
                        LEFT JOIN WRK_MODULE M ON M.MODULE_NO = W.WIDGETMODULEID
                        LEFT JOIN SETUP_LANGUAGE_TR DC ON DC.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
                    WHERE
                        W.WIDGET_TOOL = 'code' 
                        AND W.WIDGET_STATUS = 'Deployment'
                        AND W. WIDGETMODULEID IS NOT NULL
                    ORDER BY W.WIDGETMODULEID ASC
                </cfquery>
                <cfset GROUP_CONTROL = 0>
                <cfoutput query="PROTEIN_WIDGET">
                    <cfif GROUP_CONTROL neq MODULE_NO>
                        <cfif currentRow neq 1>
                            </ul>
                        </li>
                        </cfif>
                        <li>
                            <a href="javascript:void(0)" onClick="$(this).next('ul').slideToggle(200)" style=" position: sticky; top: -1px; background: white; ">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon #ICON#"></span>
                                    #MODULE_TITLE#
                                </div>
                            </a>
                        <ul class="widget-list-main" style="display:none;">
                    </cfif>
                        <li data-widget_title="#WIDGET_TITLE#" data-wrk_widget_id="#WIDGETID#" data-widget_id data-wrk_widget_default_title="#WIDGET_TITLE#">
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    <span class="ui-list-icon ctl-packing-3"></span>
                                    <span id="widget_title">#WIDGET_TITLE#</span>
                                </div>
                                <div class="ui-list-right">
                                    <i class="icon-question" @click="widgetInfo(#WIDGETID#)"></i>
                                </div>
                            </a>
                        </li>
                    <cfset GROUP_CONTROL = #MODULE_NO#>
                    <cfif currentRow eq PROTEIN_WIDGET.recordcount>
                            </ul>
                        </li>
                    </cfif>
                </cfoutput>
            </ul>
            <div class="widget-trash-container">
                <i class="fa fa-trash"></i>
                <ul class="ui-list widget-trash" >
                </ul>   
            </div>
        </cf_box>        
    </div>
    <div class="col col-9 uniqueRow" id="content" style=" position: sticky; top: 50px; ">
        <cf_box closable="0">
            <a href="javascript://" @click="createGrid('row')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-bars"></i>Add Row</a>
            <a href="javascript://" @click="createGrid('col')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-ellipsis-h"></i>Add Col</a>
            <cfif attributes.event eq 'upd_megamenu'>
                <div class="col pull-right">                
                    <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinApp.deleteMegaMenuConfirm()" add_function="proteinApp.save()">
                </div>
                <div class="col pull-right">
                    <cfset GET_MEGAMENU_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_MEGAMENU_RECORD_INFO(megamenu:attributes.megamenu)>
                    <cf_record_info query_name="GET_MEGAMENU_RECORD_INFO">
                </div>
            <cfelse>
                <cf_workcube_buttons add_function="proteinApp.save()">
            </cfif>
        </cf_box>
        <cfsavecontent variable="message">Mega Menu</cfsavecontent>
        <cf_box title="#message#" closable="0">
            <div id="artboard">
                <div class="row" data-content_type="row" :data-row-index="index_grid" v-for="(item, index_grid) in models[0].MEGAMENU_DATA[0].GRID">
                    <label class="check-container">&nbsp;
                        <input type="radio" name="select_row" class="select_row" v-model="select_row" :value="index_grid">
                        <span class="chech-item"></span>
                    </label>
                    <i class="fa fa-trash row-trash" @click="$delete(models[0].MEGAMENU_DATA[0].GRID, index_grid)"></i>                 
                    <div :class="'col '+'col-'+item_col.SIZE" data-content_type="col" :data-col-index="index_col" v-for="(item_col, index_col) in item.COLS">
                        <div class="col-toolbox">
                            <div @click="$delete(item.COLS, index_col)" class="toolbox-item"><i class="fa fa-trash"></i></div>
                            <div class="toolbox-item">                        
                                <select v-model="item_col.SIZE">
                                    <option v-for="n in 12" :value="n">{{n}}</option>
                                </select>                        
                            </div> 
                        </div> 
                        <ul class="ui-list widget-list-col" >
                            <cfif isdefined('attributes.megamenu') and len(attributes.megamenu)>
                                <li v-once v-for="(item_widget,index_widget) in temporary_model[0].MEGAMENU_DATA_HISTORY[0].GRID[index_grid].COLS[index_col].WIDGET" :data-widget_title="item_widget.TITLE" :data-widget_id="item_widget.ID" :data-grid="index_grid" :data-col="index_col" :data-widget_index="index_widget" >
                                    <a>
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-packing-3"></span>
                                            <span id="widget_title">{{item_widget.TITLE}}</span>
                                        </div>
                                        <div class="ui-list-right">
                                            <span class="ui-list-icon ctl-044-gear" v-if="item_widget.ID != 0" @click="widget_params_modal(item_widget.ID);"></span>
                                        </div>
                                    </a>
                                </li>
                            </cfif>                            
                        </ul>            
                    </div>
                </div>
            </div>
        </cf_box>
    </div>

    <div class="ui-cfmodal ui-cfmodal-xl" id="protein_widget_params" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="protein_widget_params_box" title="Widget Settings" closable="1" call_function="cfmodalx({e:'close',id:'protein_widget_params'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <cf_tab defaultOpen="widget_info_tab" divId="widget_info_tab,extend_css_tab,extend_file_tab" divLang="Params;Box Settings;Extend Css;Extend File;Search Engine Optimization">
                    <div id="unique_widget_info_tab" class="ui-info-text uniqueBox">
                        <div class="row" v-if="widget_models[0].WIDGET_NAME != '-2'">
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
                        <div class="row" v-else>
                            <div class="col col-12 scrollContent">
                                <div class="row margin-top-20">
                                    <p v-if="designBlocks_type == 'draft'"><span class="icon-info-circle"></span> design block oluştur yada taslak tasarımları kullan.<p>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12 margin-bottom-30" v-if="designBlocks_type == 'draft'">
                                        <div class="desing_block_list_item desing_block_list_item_add">
                                            <div class="bg-grey desing_block_list_item_image ">
                                                <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&widget_id='+widget_models[0].ID" target="edit_desgin_block">                     
                                                    <i class="fa fa-paint-brush desing-block-add-icon"></i><i class="fa fa-plus desing-block-add-icon"></i>
                                                </a>
                                            </div>
                                            <div class="desing_block_list_item_text">
                                                <div class="desing_block_list_item_text_top">
                                                    <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&widget_id='+widget_models[0].ID" target="edit_desgin_block">
                                                        <cf_get_lang dictionary_id='42377.Design Block Oluştur'>
                                                    </a>
                                                </div>
                                                <div class="desing_block_list_item_text_bottom">
                                                    <ul>                                
                                                        <li class="user">                                    
                                                            <i class="wrk-uF0092"></i>Design Block<br>                                    
                                                        </li>
                                                        <li>                                        
                                                            <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&widget_id='+widget_models[0].ID" target="edit_desgin_block">
                                                                <i class="catalyst-plus"></i>
                                                            </a>                                        
                                                        </li>                                
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12 margin-bottom-30" v-for="(item, index) in designBlocks">
                                        <div class="desing_block_list_item">
                                            <div class="desing_block_list_item_image">                        
                                                <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id='+item.ID+'&widget_id='+widget_models[0].ID" target="edit_desgin_block">
                                                    <img :src="'/documents/design_blocks_thumbnail/'+item.THUMBNAIL">
                                                </a>
                                            </div>
                                            <div class="desing_block_list_item_text">
                                                <div class="desing_block_list_item_text_top">
                                                    <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id='+item.ID+'&widget_id='+widget_models[0].ID" target="edit_desgin_block">
                                                        {{item.BLOCK_CONTENT_TITLE}}
                                                    </a>
                                                </div>
                                                <div class="desing_block_list_item_text_bottom">
                                                    <ul>                                
                                                        <li class="user">                                    
                                                            <i class="wrk-uF0092"></i>{{item.Author}}<br>                                    
                                                        </li>
                                                        <li>                                        
                                                            <a :href="'index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id='+item.ID+'&widget_id='+widget_models[0].ID" target="edit_desgin_block">
                                                                <i class="catalyst-eye"></i>
                                                            </a>                                        
                                                        </li>                                
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>                                            
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
                </cf_tab>                                          
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <cf_workcube_buttons add_function="proteinApp.save_widget_params()">
            </div>
        </cf_box>
    </div>
    <div class="ui-cfmodal" id="protein_widget_information" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="protein_widget_information_box" title="Widget" closable="1" call_function="cfmodalx({e:'close',id:'protein_widget_information'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" v-html="wıdgetInformation.WIDGET_DESCRIPTION">
                    </div>
                </div>     
            </div>
        </cf_box>
    </div>
    <div class="ui-cfmodal" id="del_megamenu_confirm_modal" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="del_megamenuconfirm_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'del_megamenu_confirm_modal'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                        Mega menü silinecek onaylıyor musun?
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <cf_workcube_buttons del_function="proteinApp.deleteMegaMenu()">
            </div>
        </cf_box>
    </div>
</div>
<script>
    var proteinApp = new Vue({
        el: '#addMegaMenu',
        data: {
        row_count: 0,
        col_count: 0,
        select_row : 0,
        method : 'upd_megamenu',
        wdigetListJson : <cfoutput>#wdigetListJson#</cfoutput>,
        widget_filter_keyword : '',
        models : [{
           STATUS : 1,
            ID : <cfif isdefined('attributes.megamenu') and len(attributes.megamenu)><cfoutput>'#attributes.megamenu#'</cfoutput><cfelse>null</cfif>,
            MENU : <cfif isdefined('attributes.menu') and len(attributes.menu)><cfoutput>#attributes.menu#</cfoutput><cfelse>null</cfif>,
            TITLE : '',
            SITE : <cfoutput>#attributes.site#</cfoutput>,
            MEGAMENU_DATA : [{
                GRID:[]
            }]
        }],     
        temporary_model: [{
            MEGAMENU_DATA_HISTORY:[{
               GRID:[] 
            }]
        }],  
        OBJECT_PROPERTIES : [],  
        widget_models : [{
            ID : 0,
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
            WIDGET_EXTEND : [{
                CSS : "",
                BEFORE : "",
                AFTER : ""
            }]
        }],
        key : '',
        wıdgetInformation: {
            WIDGET_TITLE:'',
            WIDGET_DESCRIPTION:'',
        },
        designBlocks:[],
        designBlocks_type:'draft',
        error: []
        },
        methods: {
            createGrid : function(type){               
                if(type == 'row'){
                    proteinApp.row_count++;
                    proteinApp.models[0].MEGAMENU_DATA[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                    proteinApp.temporary_model[0].MEGAMENU_DATA_HISTORY[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                }else if(type == 'col'){
                    proteinApp.col_count++;
                    proteinApp.models[0].MEGAMENU_DATA[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
                    proteinApp.temporary_model[0].MEGAMENU_DATA_HISTORY[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
                }
                setTimeout(function() {
                    $('.widget-list-col').sortable({
                            group: {
                            name: 'shared'
                        },
                        animation: 150,
                        draggable: "li",
                        emptyInsertThreshold: 150,
                        onAdd: function (evt) {
                            try {
                                var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.to.childNodes, function( index, value ) {
                                if(value.dataset.widget_id.length == 0){
                                    console.log('protein widget ekle');
                                    console.log(value.dataset.wrk_widget_id);
                                    
                                     axios
                                        .post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=add_widget", 
                                        {
                                            SITE :proteinApp.models[0].SITE,
                                            TITLE : value.dataset.wrk_widget_default_title,
                                            WIDGET_NAME : value.dataset.wrk_widget_id,
                                            STATUS : 1
                                        }
                                        )
                                        .then(response => {
                                                console.log(response.data.STATUS);
                                                if(response.data.STATUS == true){
                                                    alertObject({message:"Widget Eklendi 😉",type:"success"});
                                                    value.dataset.widget_id = response.data.IDENTITYCOL;
                                                    $(evt.item).find('.ui-list-right').append(
                                                        $('<span>').addClass('ui-list-icon ctl-044-gear').attr('data-widget-detail','location')
                                                    );                                                    
                                                }else{
                                                alertObject({message:"Hata : 1994 - " + response.data.ERROR ,type:"danger"});  
                                                }                            
                                        })
                                        .catch(e => {
                                            alertObject({message:"Hata : 1995 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                                            wmd.error.push({ecode: 1121, message:"method: bir porblem meydana geldi..."})
                                    })

                                }
                            
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " X---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });
                                $(evt.item).find('i.delete_item, i.icon-question').remove();
                                //$(evt.item).find('.ui-list-right').append('<i class="fa fa-trash delete_item" onClick="$(this).closest(\'li\').remove();"></i>');
                                
                                /* sub menu sadece 1 defa eklenebilir. */                                
                                if($(evt.item).data('widget_id')==-2){
                                    $('.widget-list-main [data-widget_id="-2"]').hide();
                                }
                            }catch(err) {
                                console.log('bi hata var ');
                            }
                        },
                        onEnd: function (evt) {
                            try {
                                var row_index = $(evt.from).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.from).closest('[data-col-index]').data('col-index');
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.from.childNodes, function( index, value ) {
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });

                                var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.to.childNodes, function( index, value ) {
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " B---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });
                            }catch(err) {
                                console.log('bi hata var ');
                            }
                        }
                    });
                }, 800);                 
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
            change_widget_name : function(id) {
                widget = $('[data-widget_id="'+id +'"]');
                new_name = proteinApp.widget_models[0].TITLE;
                for (g in proteinApp.models[0].MEGAMENU_DATA[0].GRID) {
                    for (c in proteinApp.models[0].MEGAMENU_DATA[0].GRID[g].COLS) {
                        for (w in proteinApp.models[0].MEGAMENU_DATA[0].GRID[g].COLS[c].WIDGET) {
                            if(proteinApp.models[0].MEGAMENU_DATA[0].GRID[g].COLS[c].WIDGET[w].ID == id){
                                proteinApp.models[0].MEGAMENU_DATA[0].GRID[g].COLS[c].WIDGET[w].TITLE = proteinApp.widget_models[0].TITLE;
                            }
                        }
                    }                    
                }
                $('[data-widget_id="'+id +'"] #widget_title').empty().html(proteinApp.widget_models[0].TITLE);
            },
            save : function(type,url){
                if(proteinApp.models[0].TITLE.length == 0){alertObject({message:"Başlık giriniz.",type:"warning"}); return false;}

                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method="+proteinApp.method, proteinApp.models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Mega Menü : " + response.data.IDENTITYCOL+ " kaydedildi 😉",type:"success"});
                                setTimeout(function(){window.location="/index.cfm?fuseaction=protein.menus&event=upd_megamenu&site=<cfoutput>#attributes.site#</cfoutput>&menu=<cfoutput>#attributes.menu#</cfoutput>&megamenu=<cfoutput>#attributes.megamenu#</cfoutput>";} , 2000);
                                
                            }else{
                              alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    })
                return false;
            },
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
                                alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1002",type:"danger"});
                                proteinApp.error.push({ecode: 1002, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                            });

                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1003",type:"danger"});
                        proteinApp.error.push({ecode: 1003, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    });
                cfmodalx({e:'open',id:'protein_widget_params'});                
                setTimeout(function(){
                    if(__x == 0 )$('[data-id="widget_info_tab"]').trigger("click"); __x++;/* Cf Tab Bug ilk seçilen sekme default açılmıyor */                    
                 }, 100);
                
            },
            save_widget_params : function(){  
                if(proteinApp.widget_models[0].TITLE.length == 0){alertObject({message:"Widget başlığı giriniz.",type:"warning"}); return false;}
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=upd_widget", proteinApp.widget_models[0])
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Site : " + response.data.IDENTITYCOL+ "Widget kaydedildi 😉",type:"success"});
                                cfmodalx({e:'close',id:'protein_widget_params'});;                                
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
            widgetInfo : function(widget) {
                console.log(widget);
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_widget_info", {id:widget})
                    .then(response => {
                            if(response.data.STATUS == true){
                                Vue.set(proteinApp.$data, 'wıdgetInformation', response.data.DATA[0]);
                                cfmodalx({e:'open',id:'protein_widget_information'});
                            }else{
                              alertObject({message:"Hata : 2003 - " + response.data.ERROR ,type:"danger"});  
                            }
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 2004 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"Hata : 2004 bir porblem meydana geldi..."})
                    })
            },
            deleteMegaMenuConfirm : function(){                
                cfmodalx({e:'open',id:'del_megamenu_confirm_modal'});
            },
            deleteMegaMenu : function(){
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_megamenu",{params:{MegaMenu:proteinApp.models[0].ID}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Sayfa Silindi.",type:"success"}); 
                            cfmodalx({e:'close',id:'del_megamenu_confirm_modal'});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site&event=upd&site=<cfoutput>#attributes.site#</cfoutput>"} , 2000);                               
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_megamenu_confirm_modal'});
                    proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                }) 
                
            },
            filter_sort_fn : function(){
                setTimeout(function() { 
                    $('.widget-list-main, .filter-widget-list').sortable({
                        group: {
                            name: 'shared',
                            pull: 'clone', 
                            put : false
                        },
                        animation: 150,
                        draggable: "li",
                        fallbackClass: "newDesignItem",
                        sort: false
                    });
                }, 800);   
            },
            update_extend_file : function(type,action,widget){
                /* 
                    type: after | befote 
                    action: update | delete
                    
                 */
                var formData = new FormData();
                if(type == 'before'){
                    var extend_file = document.querySelector('#extend_before_file');
                }else{
                    var extend_file = document.querySelector('#extend_after_file');
                }                
                formData.append("extend_file", extend_file.files[0]);
                formData.append("type", type);
                formData.append("widget", widget);


                axios.post('/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method='+action+'_extend_file', formData, {
                    headers: {
                    'Content-Type': 'multipart/form-data'
                    }
                })
                .then(response => {                        
                    if(response.data.STATUS == true){
                        if(action == "update"){    
                            alertObject({message:"Widget Extend File Kaydedildi 😉",type:"success"});
                            if(type == 'before'){
                                proteinApp.widget_models[0].WIDGET_EXTEND.BEFORE =  response.data.FILE;
                            }else{
                                proteinApp.widget_models[0].WIDGET_EXTEND.AFTER  =  response.data.FILE;
                            }
                        }else{
                            alertObject({message:"Widget Extend File Silindi 😉",type:"success"});
                            if(type == 'before'){
                                proteinApp.widget_models[0].WIDGET_EXTEND.BEFORE =  "";
                            }else{
                                proteinApp.widget_models[0].WIDGET_EXTEND.AFTER  =  "";
                            }
                        }                                                                   
                    }else{
                    alertObject({message:"Hata : 2005 - " + response.data.ERROR ,type:"danger"});  
                    }                            
                })
                .catch(e => {
                    alertObject({message:"Hata : 2006 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    wmd.error.push({ecode: 1121, message:"method: bir porblem meydana geldi..."})
                })
               console.log(type," --- ",action,"---",widget); 
            },
            getDesignBlocks : function(widget_id) {
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_widget_desing_blocks",{widget_id:widget_id})
                    .then(response => {
                        console.log(response.data)
                            if(response.data.STATUS == true){
                                console.log(response.data.DATA)
                                 Vue.set(proteinApp.$data, 'designBlocks', response.data.DATA);
                                 Vue.set(proteinApp.$data, 'designBlocks_type', response.data.TYPE); 
                            }else{
                              alertObject({message:"Hata : 2003 - " + response.data.ERROR ,type:"danger"});  
                            }
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 2004 - sistem yanıt veremedi, daha sonra tekrar dene. get_desing_blocks",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"Hata : 2004 bir problem meydana geldi..."})
                    })
            }
        },
        mounted () {
            <cfif isdefined('attributes.megamenu') and len(attributes.megamenu)>
                axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_megamenu", {params: {id :<cfoutput>'#attributes.megamenu#'</cfoutput>}})
                .then(response => {
                    
                    if(response.data.DATA[0] && response.data.DATA[0].MEGAMENU_DATA.length){
                        Vue.set(proteinApp.$data, 'models', response.data.DATA);
                        Vue.set(proteinApp.$data, 'temporary_model', response.data.DATA);

                        let MEGAMENU_DATA = [];
                        MEGAMENU_DATA[0] = JSON.parse(proteinApp.models[0].MEGAMENU_DATA);

                        let MEGAMENU_DATA_HISTORY = [];
                        MEGAMENU_DATA_HISTORY[0] = JSON.parse(proteinApp.temporary_model[0].MEGAMENU_DATA);
                        
                        
                        Vue.set(proteinApp.$data.models[0], 'MEGAMENU_DATA', MEGAMENU_DATA);
                        Vue.set(proteinApp.$data.temporary_model[0], 'MEGAMENU_DATA_HISTORY', MEGAMENU_DATA_HISTORY);

                        /* dynamic content sadece 1 defa eklenebilir. */
                        if(proteinApp.models[0].TYPE == 1){
                            $('.widget-list-main [data-widget_id="0"]').hide();
                        }
                        setTimeout(function() {
                            $('.widget-list-col').sortable({
                                    group: {
                                    name: 'shared'
                                },
                                animation: 150,
                                draggable: "li",
                                emptyInsertThreshold: 150,
                                onAdd: function (evt) {
                                   try{
                                        var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.to.childNodes, function( index, value ) {
                                            if(value.dataset.widget_id.length == 0){
                                                console.log('protein widget ekle');
                                                console.log(value.dataset.wrk_widget_id);
                                                
                                                axios
                                                .post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=add_widget", 
                                                {
                                                    SITE :proteinApp.models[0].SITE,
                                                    TITLE : value.dataset.wrk_widget_default_title,
                                                    WIDGET_NAME : value.dataset.wrk_widget_id,
                                                    STATUS : 1
                                                }
                                                )
                                                .then(response => {
                                                        console.log(response.data.STATUS);
                                                        if(response.data.STATUS == true){
                                                            alertObject({message:"Widget Eklendi 😉",type:"success"});
                                                            value.dataset.widget_id = response.data.IDENTITYCOL;
                                                            if($(evt.item).attr('data-widget_id')!=0){
                                                                $(evt.item).find('.ui-list-right').append(
                                                                    $('<span>').addClass('ui-list-icon ctl-044-gear').attr('data-widget-detail','location')
                                                                );
                                                            }
                                                            proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                                        }else{
                                                        alertObject({message:"Hata : 1998 - " + response.data.ERROR ,type:"danger"});  
                                                        }                            
                                                })
                                                .catch(e => {
                                                    alertObject({message:"Hata : 1999 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                                                    wmd.error.push({ecode: 1121, message:"method: bir porblem meydana geldi..."})
                                                })

                                            }else{
                                                 proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                            }
                                           
                                            console.log( index + " Y---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        
                                        });
                                        $(evt.item).find('i.delete_item, i.icon-question').remove();
                                        //$(evt.item).find('.ui-list-right').append('<i class="fa fa-trash delete_item" onClick="$(this).closest(\'li\').remove();"></i>');
                                        
                                        /* sub menu sadece 1 defa eklenebilir. */                                        
                                        if($(evt.item).data('widget_id')==-2){
                                            $('.widget-list-main [data-widget_id="-2"]').hide();
                                        }
                                    }catch(err) {
                                        console.log('bi hata var ');
                                    }
                                },
                                onEnd: function (evt) {
                                    try {
                                        var row_index = $(evt.from).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.from).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.from.childNodes, function( index, value ) {
                                        proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                        console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        });

                                        var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.to.childNodes, function( index, value ) {
                                        proteinApp.models[0].MEGAMENU_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                        console.log( index + " B---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        });
                                    }catch(err) {
                                        console.log('bi hata var ');
                                    }
                                }
                            });
                        }, 2000);
                    }
                })
                .catch(e => {
                    alertObject({message:"Hata : 2000 -  sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 1001, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                });
                 
            </cfif>
            __x = 0; 
        },
        watch:{
            widget_models : function(newValue){
                if(newValue[0].WIDGET_NAME == '-2'){proteinApp.getDesignBlocks(newValue[0].ID)}
            }
        },
        computed: {
            widget_filtered: function () {
                var source = this.wdigetListJson;
                var keyword = this.widget_filter_keyword;
                searchString = keyword.replace(/[Iıİ]/gi,"i").replace(/[öÖ]/gi,"o").replace(/[şŞ]/gi,"s").replace(/[çÇ]/gi,"c").replace(/[ğĞ]/gi,"g").toLowerCase().trim();
                if(searchString.length >= 3){
                    if(!searchString){
                        return source;
                    }   
                    source = source.filter(function(item){
                    if(item.WIDGET_TITLE.replace(/[Iıİ]/gi,"i").replace(/[öÖ]/gi,"o").replace(/[şŞ]/gi,"s").replace(/[çÇ]/gi,"c").replace(/[ğĞ]/gi,"g").toLowerCase().trim().indexOf(searchString) !== -1){
                        return item;
                    }
                }) 
                    proteinApp.filter_sort_fn();
                    return source;                   
                }else{
                  return [];
                }
            }       
        }
    });
</script>
<script>
    proteinApp.filter_sort_fn();
     $('.widget-trash').sortable({
        group: {
            name: 'shared',
        },
        animation: 150,
        draggable: "li",
        emptyInsertThreshold: 15,
        sort: true,
        onAdd: function (evt) {
            console.log($(evt.item).data('widget_id'));
            console.log($(evt.item).attr('data-widget_id'));
            
            if($(evt.item).data('widget_id')==-2){
                $('.widget-list-main [data-widget_id="-2"]').show();
            }
            axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_widget", 
            {
                SITE :proteinApp.models[0].SITE,
                WIDGET_ID : $(evt.item).attr('data-widget_id')
            })
            .then(response => {
                    console.log(response.data.STATUS);
                    if(response.data.STATUS == true){
                        alertObject({message:"Widget : " + response.data.IDENTITYCOL+ " Silindi 😉",type:"success"});
                        $(evt.item).remove();
                    }else{
                    alertObject({message:"Hata : 2001 - " + response.data.ERROR ,type:"danger"});  
                    }                            
            })
            .catch(e => {
                alertObject({message:"Hata : 2002 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                wmd.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
            })
                console.log('Silindi... TODO: protein widget ten sil')
                console.log($(evt.item).data('widget_id'));
            }
    });
    $( document ).on( "click", "[data-widget-detail]", function() {
        var widget_id = $(this).closest('li').attr('data-widget_id');
        proteinApp.widget_params_modal(widget_id);
    });
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