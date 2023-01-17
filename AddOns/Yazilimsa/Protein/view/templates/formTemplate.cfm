<!---
    File :          AddOns\Yazilimsa\Protein\view\templates\formTemplate.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Protein kabuk oluşturur view-add-upd-del içerir
    Notes :         /AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc ile çalışır
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

<cfquery name="thısDomaın" datasource="#dsn#">
    SELECT DOMAIN FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.site#">
</cfquery>
<cfset pageHead = "Template : #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div class="row" id="addTemplate"> 
    <div class="col col-3 uniqueRow" id="content">
        <cfsavecontent variable="message">Defintitions</cfsavecontent>
        <cf_box title="#message#" closable="0">
            <cfform name="form_sites_step_four" enctype="multipart/form-data">
                <cf_box_elements vertical="1">                         
                    <div class="form-group col col-2">
                        <label>Layout</label>
                        <input type="radio" v-model="models[0].TYPE" value="1">
                    </div>
                    <div class="form-group col col-2">
                        <label>Template</label>
                        <input type="radio" v-model="models[0].TYPE" value="2">
                    </div>
                    <div class="form-group col col-2">
                        <label>Active</label>
                        <input type="checkbox" v-model="models[0].STATUS" true-value="1" false-value="0">
                    </div>
                    <div class="form-group col col-12">
                        <label>Title</label>
                        <input type="text" v-model="models[0].TITLE">
                    </div>
                </cf_box_elements>
            </cfform>           
        </cf_box>
        <cfsavecontent variable="message">Widgets</cfsavecontent>
        <cf_box title="#message#" closable="0">
            <ul class="ui-list widget-list-main" >                
                <li data-widget_title="Dynamic Content İç Kabuk" data-widget_id="0" v-show="models[0].TYPE == 1">
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-029-crane"></span>
                            Dynamic Content Template
                        </div>
                        <div class="ui-list-right">
                            <i class="icon-question"></i>
                        </div>
                    </a>
                </li>
                <li data-widget_title="Dynamic Content Page" data-widget_id="-1" v-show="models[0].TYPE == 2">
                    <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-029-crane"></span>
                            Dynamic Content Page
                        </div>
                        <div class="ui-list-right">
                            <i class="icon-question"></i>
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
                        <li data-widget_title="#WIDGET_TITLE#" data-wrk_widget_id="#WIDGETID#" data-widget_id="" data-wrk_widget_default_title="#WIDGET_TITLE#">
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
    <div class="col col-9 uniqueRow" id="content" style="position: sticky; top: 50px; ">
        <cf_box closable="0">
            <a href="javascript://" @click="createGrid('row')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-bars"></i>Add Row</a>
            <a href="javascript://" @click="createGrid('col')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-ellipsis-h"></i>Add Col</a>
            <cfif attributes.event eq 'upd'>                
                <div class="col pull-right">                
                    <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinApp.deleteTemplateConfirm()" add_function="proteinApp.save()">
                </div>
                <div class="col pull-right">
                    <cfset GET_TEMPLATE_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_TEMPLATE_RECORD_INFO(template:attributes.template)>
                    <cf_record_info query_name="GET_TEMPLATE_RECORD_INFO">
                </div>
           <cfelse>
                <cf_workcube_buttons add_function="proteinApp.save()">
            </cfif>
        </cf_box>
        <cfsavecontent variable="message">Template</cfsavecontent>
        <cf_box title="#message#" closable="0">
            <div id="artboard">
                <div class="row" data-content_type="row" :data-row-index="index_grid" v-for="(item, index_grid) in models[0].DESIGN_DATA[0].GRID">
                    <label class="check-container">&nbsp;
                        <input type="radio" name="select_row" class="select_row" v-model="select_row" :value="index_grid">
                        <span class="chech-item"></span>
                    </label>
                    <i class="fa fa-trash row-trash" @click="$delete(models[0].DESIGN_DATA[0].GRID, index_grid)"></i>                 
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
                            <cfif isdefined('attributes.template') and len(attributes.template)>
                                <li v-once v-for="(item_widget,index_widget) in temporary_model[0].DESIGN_DATA_HISTORY[0].GRID[index_grid].COLS[index_col].WIDGET" :data-widget_title="item_widget.TITLE" :data-widget_id="item_widget.ID" :data-grid="index_grid" :data-col="index_col" :data-widget_index="index_widget" >
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
        <cf_box  resize="0" collapsable="0" draggable="1" id="protein_widget_params_box" title="Widget Params" closable="1" call_function="cfmodalx({e:'close',id:'protein_widget_params'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <cf_tab defaultOpen="widget_info_tab" divId="widget_info_tab,box_settings,extend_css_tab,extend_file_tab" divLang="Params;Box Settings;Extend Css;Extend File">
                    <div id="unique_widget_info_tab" class="ui-info-text uniqueBox">
                        <div class="row">
                            <div class="col col-4 col-md-6 col-sm-12 col-xs-12">
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
            <div class="ui-form-list-btn padding-top-10">
                <button type="button" class="btn btn-info pull-right margin-right-5" data-dismiss="modal" @click="cfmodalx({e:'close',id:'protein_widget_information'});">Vazgeç</button>
            </div>
        </cf_box>
    </div>
    <div class="ui-cfmodal" id="del_template_confirm_modal" style="display:none;">
        <cf_box  resize="0" collapsable="0" draggable="1" id="del_template_confirm_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'del_template_confirm_modal'});" close_href="javascript://">
            <div class="ui-form-list ui-form-block">
                <div class="row">
                    <div class="col col-12" style=" padding: 20px; text-align: center; ">
                        <cfif isdefined('attributes.site') and len(attributes.site)> <cfoutput>#thısDomaın.DOMAIN#</cfoutput></cfif> sitesinde {{models[0].TITLE}} başlıklı kayıt silinecek onaylıyor musun?
                    </div>
                </div>
            </div>
            <div class="ui-form-list-btn padding-top-10">
                <cf_workcube_buttons extraButton="1"  extraFunction="proteinApp.deleteTemplate()" extraButtonText = "#getLang('main',51)#">
            </div>
        </cf_box>
    </div>
</div>
<script>
    var proteinApp = new Vue({
        el: '#addTemplate',
        data: {
        row_count: 0,
        col_count: 0,
        select_row : 0,
        method : '<cfoutput>#attributes.event#</cfoutput>_template',
        wdigetListJson : <cfoutput>#wdigetListJson#</cfoutput>,
        widget_filter_keyword : '',
        models : [{
            SITE : <cfoutput>#attributes.site#</cfoutput>,
            ID : <cfif isdefined('attributes.template') and len(attributes.template)><cfoutput>#attributes.template#</cfoutput><cfelse>null</cfif>,
            TITLE : '',
            TYPE :1,   
            STATUS : 1,    
            DESIGN_DATA : [{
                GRID:[]
            }]
        }],     
        temporary_model: [{
            DESIGN_DATA_HISTORY:[{
               GRID:[] 
            }]
        }],  
        OBJECT_PROPERTIES : [], 
        BOX_PROPERTIES : [], 
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
            WIDGET_BOX_DATA : [{}],
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
        error: []
        },
        methods: {
            createGrid : function(type){               
                if(type == 'row'){
                    proteinApp.row_count++;
                    proteinApp.models[0].DESIGN_DATA[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                    proteinApp.temporary_model[0].DESIGN_DATA_HISTORY[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                }else if(type == 'col'){
                    proteinApp.col_count++;
                    proteinApp.models[0].DESIGN_DATA[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
                    proteinApp.temporary_model[0].DESIGN_DATA_HISTORY[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
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
                                
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
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
                                            wmd.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                                    })

                                }
                            
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " X---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });
                                $(evt.item).find('i.delete_item, i.icon-question').remove();
                                //$(evt.item).find('.ui-list-right').append('<i class="fa fa-trash delete_item" onClick="$(this).closest(\'li\').remove();"></i>');
                                /* dynamic content sadece 1 defa eklenebilir. */
                                
                                if($(evt.item).data('widget_id')==0){
                                    $('.widget-list-main [data-widget_id="0"]').hide();
                                }
                            }catch(err) {
                                console.log('bi hata var ');
                            }
                        },
                        onEnd: function (evt) {
                            try {
                                var row_index = $(evt.from).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.from).closest('[data-col-index]').data('col-index');
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.from.childNodes, function( index, value ) {
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });

                                var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.to.childNodes, function( index, value ) {
                                proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
                for (g in proteinApp.models[0].DESIGN_DATA[0].GRID) {
                    for (c in proteinApp.models[0].DESIGN_DATA[0].GRID[g].COLS) {
                        for (w in proteinApp.models[0].DESIGN_DATA[0].GRID[g].COLS[c].WIDGET) {
                            if(proteinApp.models[0].DESIGN_DATA[0].GRID[g].COLS[c].WIDGET[w].ID == id){
                                proteinApp.models[0].DESIGN_DATA[0].GRID[g].COLS[c].WIDGET[w].TITLE = proteinApp.widget_models[0].TITLE;
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
                                alertObject({message:"Şablon : " + response.data.IDENTITYCOL+ " kaydedildi 😉",type:"success"});
                                setTimeout(function(){window.location="/index.cfm?fuseaction=protein.templates&event=upd&template=" + response.data.IDENTITYCOL + "&site=<cfoutput>#attributes.site#</cfoutput>";} , 2000);
                                
                            }else{
                              alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
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
                                    $.each(BOX_PROPERTIES.OBJECT_PROPERTY, function( index, item ) {
                                        WIDGET_BOX_DATA[0][item.PROPERTY]=item.PROPERTY_DEFAULT;                            
                                    });
                                    Vue.set(proteinApp.$data.widget_models[0], 'WIDGET_BOX_DATA', WIDGET_BOX_DATA[0]);
                                    Vue.set(proteinApp.$data, 'BOX_PROPERTIES', BOX_PROPERTIES);
                                }                       
                            })
                            .catch(e => {
                                alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1002",type:"danger"});
                                proteinApp.error.push({ecode: 1008, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                            });

                    })
                    .catch(e => {
                        alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1003",type:"danger"});
                        proteinApp.error.push({ecode: 1003, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
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
                                cfmodalx({e:'close',id:'protein_widget_params'});                               
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
                                cfmodalx({e:'open',id:'protein_widget_information'});
                            }else{
                              alertObject({message:"Hata : 2003 - " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 2004 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        wmd.error.push({ecode: 1000, message:"Hata : 2004 bir problem meydana geldi..."})
                    })
                
            },
            deleteTemplateConfirm : function(){                
                cfmodalx({e:'open',id:'del_template_confirm_modal'});
            },
            deleteTemplate : function(){
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_template",{params:{template:proteinApp.models[0].ID}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Sayfa Silindi.",type:"success"}); 
                            cfmodalx({e:'close',id:'del_template_confirm_modal'});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site&event=upd&site=<cfoutput>#attributes.site#</cfoutput>"} , 2000);                               
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_template_confirm_modal'});
                    proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
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
                    wmd.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                })
               console.log(type," --- ",action,"---",widget); 
            } 
        },
        mounted () {  
            <cfif isdefined('attributes.template') and len(attributes.template)>
                axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_template", {params: {id :<cfoutput>#attributes.template#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].DESIGN_DATA.length){
                        Vue.set(proteinApp.$data, 'models', response.data.DATA);
                        Vue.set(proteinApp.$data, 'temporary_model', response.data.DATA);

                        let DESIGN_DATA = [];
                        DESIGN_DATA[0] = JSON.parse(proteinApp.models[0].DESIGN_DATA);

                        let DESIGN_DATA_HISTORY = [];
                        DESIGN_DATA_HISTORY[0] = JSON.parse(proteinApp.temporary_model[0].DESIGN_DATA);

                        Vue.set(proteinApp.$data.models[0], 'DESIGN_DATA', DESIGN_DATA);
                        Vue.set(proteinApp.$data.temporary_model[0], 'DESIGN_DATA_HISTORY', DESIGN_DATA_HISTORY);
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
                                        proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
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
                                                            proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                                        }else{
                                                        alertObject({message:"Hata : 1998 - " + response.data.ERROR ,type:"danger"});  
                                                        }                            
                                                })
                                                .catch(e => {
                                                    alertObject({message:"Hata : 1999 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                                                    wmd.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                                                })

                                            }else{
                                                 proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                            }
                                           
                                            console.log( index + " Y---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        
                                        });
                                        $(evt.item).find('i.delete_item, i.icon-question').remove();
                                        //$(evt.item).find('.ui-list-right').append('<i class="fa fa-trash delete_item" onClick="$(this).closest(\'li\').remove();"></i>');
                                        /* dynamic content sadece 1 defa eklenebilir. */
                                        
                                        if($(evt.item).data('widget_id')==0){
                                            $('.widget-list-main [data-widget_id="0"]').hide();
                                        }
                                    }catch(err) {
                                        console.log('bi hata var ');
                                    }
                                },
                                onEnd: function (evt) {
                                    try {
                                        var row_index = $(evt.from).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.from).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.from.childNodes, function( index, value ) {
                                        proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                        console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        });

                                        var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.to.childNodes, function( index, value ) {
                                        proteinApp.models[0].DESIGN_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
                    proteinApp.error.push({ecode: 1001, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                });
                 
            </cfif> 
             __x = 0; 
             $('#del_template_confirm_modal #wrk_submit_button').remove();   
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
            
            if($(evt.item).data('widget_id')==0){
                $('.widget-list-main [data-widget_id="0"]').show();
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
                wmd.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
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