<!---
    File :          AddOns\Yazilimsa\Protein\view\pages\formPage.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          31.08.2020
    Description :   Protein sayfalarını oluşturur view-add-upd-del içerir
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
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css?v=22042022" />
<cfquery name="company_cat" datasource="#dsn#">
    SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="consumer_cat" datasource="#dsn#">
    SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT 
</cfquery>
<cfquery name="get_language" datasource="#dsn#">
    SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
</cfquery>
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
<cfset pageHead = "Page : #thısDomaın.DOMAIN#">
<cf_catalystHeader>
<div id="addTemplate"> 
    <cf_box>   
        <div class="row">
            <cf_tab defaultOpen="page_definitions" divId="page_definitions,page_designer" divLang="Defitinitons;Designer">
                <div class="row ui-info-text uniqueBox" id="unique_page_definitions">
                    <div class="col col-12 uniqueRow">
                        <cfform name="form_page" enctype="multipart/form-data">
                            <cf_box_elements vertical="1">   
                                <div class="col col-3 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">                         
                                    <div class="form-group col col-12">   
                                        <label>Aktif</label>
                                        <input type="checkbox" v-model="models[0].STATUS" true-value="1" false-value="0">
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Başlık</label>
                                        <input type="text" v-model="models[0].TITLE" maxlength="140">
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Related WO</label>
                                        <div class="col col-12">
                                            <div class="input-group">                                
                                                <input type="text" name="related_wo" id="related_wo" readonly v-model="models[0].PAGE_DATA[0].RELATED_WO" message="İlişkili WO' yu seçiniz">
                                                <span class="input-group-addon icon-ellipsis btnPointer" @click="selectWoBox()"></span>                                
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group col col-12" v-if="models[0].PAGE_DATA[0].RELATED_WO">
                                        <label>Friendly Url</label>
                                        <div class="input-group">  
                                            <input type="text" v-model="models[0].FRIENDLY_URL">
                                            <span class="input-group-addon ppe-list" v-if="models[0].PAGE_DATA[0].EVENT == 'list'">/LİST</span>
                                            <span class="input-group-addon ppe-add" v-else-if="models[0].PAGE_DATA[0].EVENT == 'add'">/ADD</span>
                                            <span class="input-group-addon ppe-upd" v-else-if="models[0].PAGE_DATA[0].EVENT == 'upd'">/UPD</span>
                                            <span class="input-group-addon ppe-detail" v-else-if="models[0].PAGE_DATA[0].EVENT == 'det'">/DETAIL</span>
                                            <span class="input-group-addon ppe-dashboard" v-else-if="models[0].PAGE_DATA[0].EVENT == 'dashboard'">/DASHBOARD</span>
                                        </div>
                                    </div>
                                    <div class="form-group col col-12" v-else>
                                        <label>Friendly Url</label>
                                        <input type="text" v-model="models[0].FRIENDLY_URL" maxlength="140">
                                    </div>                    
                                    <div class="form-group col col-12 mb-2">
                                        <label>Events</label>
                                        <div class="col col-12" v-if="models[0].PAGE_DATA[0].RELATED_WO">
                                            <ul class="protein-page-event-list">
                                                <li v-for="(item,name) in EVENT_STATUS">                   
                                                    <span class="protein-page-event ppe-list" v-if="EVENT_LIST && name == 'list'">
                                                        <a :href="'/index.cfm?fuseaction=protein.pages&event='+ ((item.page != 0 || item.child_page == 0) ? 'upd&page='+ item.page : 'add') +'&site='+models[0].SITE+ ((EVENT_DEFAULT == 'list')?'':'&related_page='+ ((models[0].PAGE_DATA[0].RELATED_PAGE) ? models[0].PAGE_DATA[0].RELATED_PAGE : models[0].ID) +'&page_event=list')" target="_blank">LİST<i v-if="EVENT_DEFAULT == 'list'" class="fa fa-star ml-1" title="default"></i></a>
                                                    </span>
                                                    <span class="protein-page-event ppe-add" v-if="EVENT_ADD && name == 'add'">
                                                        <a :href="'/index.cfm?fuseaction=protein.pages&event='+((item.page != 0 || item.child_page == 0) ? 'upd&page='+ item.page  : 'add') +'&site='+models[0].SITE+ ((EVENT_DEFAULT == 'add')?'':'&related_page='+ ((models[0].PAGE_DATA[0].RELATED_PAGE) ? models[0].PAGE_DATA[0].RELATED_PAGE : models[0].ID) +'&page_event=add')" target="_blank">ADD<i v-if="EVENT_DEFAULT == 'add'" class="fa fa-star ml-1" title="default"></i></a>
                                                    </span>
                                                    <span class="protein-page-event ppe-upd" v-if="EVENT_UPD && name == 'upd'">
                                                        <a :href="'/index.cfm?fuseaction=protein.pages&event='+ ((item.page != 0 || item.child_page == 0) ? 'upd&page='+ item.page : 'add') +'&site='+models[0].SITE+ ((EVENT_DEFAULT == 'upd')?'':'&related_page='+ ((models[0].PAGE_DATA[0].RELATED_PAGE) ? models[0].PAGE_DATA[0].RELATED_PAGE : models[0].ID) +'&page_event=upd')" target="_blank">UPD<i v-if="EVENT_DEFAULT == 'upd'" class="fa fa-star ml-1" title="default"></i></a>
                                                    </span>
                                                    <span class="protein-page-event ppe-detail" v-if="EVENT_DETAIL && name == 'det'">
                                                        <a :href="'/index.cfm?fuseaction=protein.pages&event='+ ((item.page != 0 || item.child_page == 0) ? 'upd&page='+ item.page : 'add') +'&site='+models[0].SITE+ ((EVENT_DEFAULT == 'det')?'':'&related_page='+ ((models[0].PAGE_DATA[0].RELATED_PAGE) ? models[0].PAGE_DATA[0].RELATED_PAGE : models[0].ID) +'&page_event=det')" target="_blank">DETAIL<i v-if="EVENT_DEFAULT == 'det'" class="fa fa-star ml-1" title="default"></i></a>
                                                    </span>
                                                    <span class="protein-page-event ppe-dashboard" v-if="EVENT_DASHBOARD && name == 'dashboard'">
                                                        <a :href="'/index.cfm?fuseaction=protein.pages&event='+ ((item.page != 0 || item.child_page == 0) ? 'upd&page='+ item.page : 'add') +'&site='+models[0].SITE+ ((EVENT_DEFAULT == 'dashboard')?'':'&related_page='+ ((models[0].PAGE_DATA[0].RELATED_PAGE) ? models[0].PAGE_DATA[0].RELATED_PAGE : models[0].ID) +'&page_event=dashboard')" target="_blank">DASHBOARD<i v-if="EVENT_DEFAULT == 'dashboard'" class="fa fa-star ml-1" title="default"></i></a>
                                                    </span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-language">
                                        <label class="col col-12">
                                            <cf_get_lang dictionary_id='58996.Dil'>
                                        </label>
                                        <div class="col col-12">
                                            <select v-model="models[0].PAGE_DATA[0].LANGUAGE" multiple>
                                                <cfoutput query="get_language">
                                                    <option value="#LANGUAGE_SHORT#">#LANGUAGE_SET#</option>
                                                </cfoutput>
                                            </select>
                                        </div>              
                                    </div>
                                    <div class="form-group" id="item-company" v-show="models[0].ID">                        
                                        <label class="col col-12 font-red text-bold">
                                            <a :href="'/index.cfm?fuseaction=protein.pages&event=denied&page='+models[0].ID+'&site='+models[0].SITE"><i class="fa fa-eye-slash"></i> Sayfa Kısıtı Ayarla</a>
                                        </label>
                                    </div>
                                    <div class="form-group col col-12">   
                                        <label>Public<input type="checkbox" v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].PUBLIC.STATUS" true-value="1" false-value="0"></label>
                                        <label v-if="models[0].PAGE_DATA[0].ACCESS_DATA[0].PUBLIC.STATUS == 0">Kariyer Portal<input type="checkbox"  v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].CARIER.STATUS" true-value="1" false-value="0"></label>
                                        <label v-if="models[0].PAGE_DATA[0].ACCESS_DATA[0].PUBLIC.STATUS == 0">Kurumsal Üyelere Özel <input type="checkbox" v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].COMPANY.STATUS" true-value="1" false-value="0"></label>
                                        <label v-if="models[0].PAGE_DATA[0].ACCESS_DATA[0].PUBLIC.STATUS == 0">Bireysel Üyelere Özel <input type="checkbox" v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].CONSUMER.STATUS" true-value="1" false-value="0"></label>
                                    </div>
                                    <div class="form-group" id="item-company" v-show="models[0].PAGE_DATA[0].ACCESS_DATA[0].COMPANY.STATUS == 1">
                                        <label class="col col-12">Kurumsal Üye Kategorileri</label>
                                        <div class="col col-12">
                                            <select v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].COMPANY.SELECT" multiple>
                                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="company_cat">
                                                    <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                                                </cfoutput>
                                            </select>
                                        </div>              
                                    </div>
                                    <div class="form-group" id="item-consumer" v-show="models[0].PAGE_DATA[0].ACCESS_DATA[0].CONSUMER.STATUS == 1">
                                        <label class="col col-12">Bireysel Üye Kategorileri</label>
                                        <div class="col col-12">
                                            <select v-model="models[0].PAGE_DATA[0].ACCESS_DATA[0].CONSUMER.SELECT" multiple>
                                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="consumer_cat">
                                                    <option value="#CONSCAT_ID#">#CONSCAT#</option>
                                                </cfoutput>
                                            </select>
                                        </div>              
                                    </div>                            
                                </div>
                                <div class="col col-3 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                    <div class="form-group col col-12">
                                        <label>Meta Description</label>
                                        <textarea v-model="models[0].PAGE_DATA[0].META_DESCRIPTION"></textarea>
                                        <code class="makro-box">Meta Makro <kbd @click="models[0].PAGE_DATA[0].META_DESCRIPTION+='[product_desc]'">Ürün</kbd> <kbd @click="models[0].PAGE_DATA[0].META_DESCRIPTION+='[content_desc]'">İçerik</kbd></code>
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Meta Keyword</label>
                                        <textarea v-model="models[0].PAGE_DATA[0].META_KEYWORD"></textarea>
                                        <code class="makro-box">Meta Makro <kbd @click="models[0].PAGE_DATA[0].META_KEYWORD+='[product_keyword]'">Ürün</kbd> <kbd @click="models[0].PAGE_DATA[0].META_KEYWORD+='[content_keyword]'">İçerik</kbd></code>
                                    </div> 
                                    <div class="form-group col col-12">
                                        <label>Header Script</label>
                                        <textarea v-model="models[0].PAGE_DATA[0].HEADER_SCRIPT" rows="3"></textarea>
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Footer Script</label>
                                        <textarea v-model="models[0].PAGE_DATA[0].FOOTER_SCRIPT" rows="3"></textarea>
                                    </div> 
                                    <div class="form-group col col-12">
                                        <label>Schema Markup</label>
                                        <select v-model="models[0].PAGE_DATA[0].SCHEMA_MARKUP">
                                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option v-for="item in SCHEMA_ORG" :value="item.KEY">
                                                {{item.TITLE}}
                                            </option>
                                        </select>
                                    </div>
                                    
                                </div>  
                                <div class="col col-3 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                    <div class="form-group col col-12">
                                        <label>Layout</label>
                                        <select v-model="models[0].TEMPLATE_BODY">
                                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_body_template">
                                                <option value="#ID#">#TITLE#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Template</label>
                                        <select v-model="models[0].TEMPLATE_INSIDE">
                                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_body_inside">
                                                <option value="#ID#">#TITLE#</option>
                                            </cfoutput>                                    
                                        </select>
                                    </div>
                                    <div class="form-group col col-12">
                                        <label>Security</label>
                                        <select v-model="models[0].PAGE_DATA[0].SECURITY">
                                            <option v-for="item in SECURITY" :value="item.KEY">
                                                {{item.TITLE}}
                                            </option>
                                        </select>
                                    </div>
                                </div>
                            </cf_box_elements>
                        </cfform>                    
                    </div>
                </div>
                <div class="row ui-info-text uniqueBox" id="unique_page_designer">
                    <div class="col col-3 uniqueRow ">
                        <cfsavecontent variable="message">Widgets</cfsavecontent>
                        <cf_box title="#message#" closable="0">
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
                                <!--- TODO 1 : query cfc ye alınacak --->
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
                    <div class="col col-9 uniqueRow" style=" position: sticky; top: 50px; ">
                        <cf_box title="Page" closable="0"> 
                            <div class="artboard-top-tools">
                                <a href="javascript://" @click="createGrid('row')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-bars"></i>Add Row</a>
                                <a href="javascript://" @click="createGrid('col')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-ellipsis-h"></i>Add Col</a>           
                            </div>
                            <div id="artboard">
                                <div class="row" data-content_type="row" :data-row-index="index_grid" v-for="(item, index_grid) in models[0].PAGE_DATA[0].GRID">
                                    <label class="check-container">&nbsp;
                                        <input type="radio" name="select_row" class="select_row" v-model="select_row" :value="index_grid">
                                        <span class="chech-item"></span>
                                    </label>
                                    <i class="fa fa-trash row-trash" @click="$delete(models[0].PAGE_DATA[0].GRID, index_grid)"></i>
                                    <i class="fa fa-cog row-setting" @click="openRowParams(index_grid)"></i>          
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
                                            <cfif isdefined('attributes.page') and len(attributes.page)>
                                                <li v-once v-for="(item_widget,index_widget) in temporary_model[0].PAGE_DATA_HISTORY[0].GRID[index_grid].COLS[index_col].WIDGET" :data-widget_title="item_widget.TITLE" :data-widget_id="item_widget.ID" :data-grid="index_grid" :data-col="index_col" :data-widget_index="index_widget" >
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
                </div>
            </cf_tab>
            <div class="ui-cfmodal ui-cfmodal-xl" id="protein_widget_params" style="display:none;">
                <cf_box  resize="0" collapsable="0" draggable="1" id="protein_widget_params_box" title="Widget Settings" closable="1" call_function="cfmodalx({e:'close',id:'protein_widget_params'});" close_href="javascript://">
                    <div class="ui-form-list ui-form-block">
                        <cf_tab defaultOpen="widget_info_tab" divId="widget_info_tab,box_settings,extend_css_tab,extend_file_tab,widget_seo" divLang="Params;Box Settings;Extend Css;Extend File;Search Engine Optimization">
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
                                                <select v-else-if="item.QUERY_SELECT" :id="item.PROPERTY" v-model="widget_models[0].WIDGET_DATA[item.PROPERTY]">
                                                    <cfset getCmp = createObject('component','AddOns.Yazilimsa.Protein.cfc.generalFunctions').our_company()>
                                                    <option>Seçiniz</option>
                                                    <cfoutput query="getCmp">
                                                        <option value="#COMP_ID#">
                                                            #COMPANY_NAME#
                                                        </option>
                                                    </cfoutput>                                                   
                                                </select>
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
            <div class="ui-cfmodal ui-cfmodal-md" id="protein_row_params" style="display:none;">
                <cf_box  resize="0" collapsable="0" draggable="1" id="protein_row_params_params_box" title="Row Settings" closable="1" call_function="cfmodalx({e:'close',id:'protein_row_params'});" close_href="javascript://">
                    <div class="ui-form-list ui-form-block">
                        <cf_tab defaultOpen="row_settings" divId="row_settings" divLang="Row Settings">
                            <div id="unique_row_settings" class="ui-info-text uniqueBox">
                                <div class="row">
                                    <div class="col col-4 col-md-6 col-sm-12 col-xs-12">                      
                                        <div class="form-group" v-for="(item, index) in ROW_PROPERTIES.OBJECT_PROPERTY">                           
                                            <label class="col col-12">{{item.PROPERTY_DETAIL}}</label>
                                            <div class="col col-12">
                                                <input type="text" v-if="item.PROPERTY_TYPE == 'input'" :id="item.PROPERTY" v-model="ROW_PROPERTIES_DATA[item.PROPERTY]"> 
                                                <select v-else-if="item.PROPERTY_TYPE == 'select'" :id="item.PROPERTY" v-model="ROW_PROPERTIES_DATA[item.PROPERTY]">
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
                        </cf_tab>                                          
                    </div>
                    <div class="ui-form-list-btn padding-top-10">
                        <cf_workcube_buttons add_function="proteinApp.saveRowParams()">
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
            <div class="ui-cfmodal" id="del_page_confirm_modal" style="display:none;">
                <cf_box  resize="0" collapsable="0" draggable="1" id="del_pageconfirm_box" title="Delete" closable="1" call_function="cfmodalx({e:'close',id:'del_page_confirm_modal'});" close_href="javascript://">
                    <div class="ui-form-list ui-form-block">
                        <div class="row">
                            <div class="col col-12" style=" padding: 20px; text-align: center; ">
                                <cfif isdefined('attributes.site') and len(attributes.site)> <cfoutput>#thısDomaın.DOMAIN#</cfoutput></cfif> sitesinde {{models[0].TITLE}} başlıklı {{models[0].FRIENDLY_URL}} adresli bu sayfa silinecek onaylıyor musun?
                            </div>
                        </div>
                    </div>
                    <div class="ui-form-list-btn padding-top-10">
                        <cf_workcube_buttons extraButton="1"  extraFunction="proteinApp.deletePage()" extraButtonText = "#getLang('main',51)#">
                    </div>
                </cf_box>
            </div>
        </div>
        <div class="row">
            <cf_box_footer>  
                <cfif attributes.event eq 'upd'>                            
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfset GET_PAGE_RECORD_INFO = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_PAGE_RECORD_INFO(page:attributes.page)>
                        <cf_record_info query_name="GET_PAGE_RECORD_INFO">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">               
                        <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="proteinApp.deletePageConfirm()" add_function="proteinApp.save()">
                    </div>
                <cfelse>
                    <cf_workcube_buttons add_function="proteinApp.save()">
                </cfif>
            </cf_box_footer>   
        </div>
    </cf_box>
</div>
<script>
    var proteinApp = new Vue({
        el: '#addTemplate',
        data: {
        row_count: 0,
        col_count: 0,
        select_row : 0,
        method : '<cfoutput>#attributes.event#</cfoutput>_page',
        wdigetListJson : <cfoutput>#wdigetListJson#</cfoutput>,
        widget_filter_keyword : '',
        models : [{
           STATUS : 1,
            ID : <cfif isdefined('attributes.page') and len(attributes.page)><cfoutput>#attributes.page#</cfoutput><cfelse>null</cfif>,
            TITLE : '',
            FRIENDLY_URL : '',          
            SITE : <cfoutput>#attributes.site#</cfoutput>,
            TEMPLATE_BODY : 0,
            TEMPLATE_INSIDE : 0,   
            PAGE_DATA : [{
                DETAIL: '',
                LANGUAGE : '',
                META_DESCRIPTION : '',
                META_KEYWORD : '',
                GRID:[],
                ACCESS_DATA : [{
                    COMPANY:{STATUS:0,SELECT:[]},
                    CONSUMER:{STATUS:0,SELECT:[]},
                    PUBLIC:{STATUS:0},
                    CARIER:{STATUS:0}
                }],
                RELATED_WO : '',
                RELATED_PAGE : '',
                EVENT : '',
                EVENT_DEFAULT : '',
                HEADER_SCRIPT : '',
                FOOTER_SCRIPT : ''             
            }]
        }],
        EVENT_LIST : false,
        EVENT_ADD : false,
        EVENT_UPD : false,
        EVENT_DETAIL : false,
        EVENT_DASHBOARD : false,
        EVENT_DEFAULT : '',
        EVENT_STATUS : {},
        temporary_model: [{
            PAGE_DATA_HISTORY:[{
               GRID:[] 
            }]
        }],  
        OBJECT_PROPERTIES : [],  
        BOX_PROPERTIES : [],
        ROW_PROPERTIES : [],
        ROW_PROPERTIES_DATA : [{}],
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
        SECURITY : [
            {
                KEY: 'Standart',
                TITLE : 'Standart'
            },
            {
                KEY: 'Light',
                TITLE : 'Light'
            },
            {
                KEY: 'Dark',
                TITLE : 'Dark'
            }
        ],
        designBlocks:[],
        designBlocks_type:'draft',
        error: []
        },
        methods: {
            createGrid : function(type){               
                if(type == 'row'){
                    proteinApp.row_count++;
                    proteinApp.models[0].PAGE_DATA[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                    proteinApp.temporary_model[0].PAGE_DATA_HISTORY[0].GRID.push({NO:proteinApp.row_count,COLS:[]});
                }else if(type == 'col'){
                    proteinApp.col_count++;
                    proteinApp.models[0].PAGE_DATA[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
                    proteinApp.temporary_model[0].PAGE_DATA_HISTORY[0].GRID[proteinApp.select_row].COLS.push({NO:proteinApp.col_count,SIZE:2,WIDGET:[]});
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
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
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
                            
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.from.childNodes, function( index, value ) {
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                });

                                var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                $.each(evt.to.childNodes, function( index, value ) {
                                proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
                for (g in proteinApp.models[0].PAGE_DATA[0].GRID) {
                    for (c in proteinApp.models[0].PAGE_DATA[0].GRID[g].COLS) {
                        for (w in proteinApp.models[0].PAGE_DATA[0].GRID[g].COLS[c].WIDGET) {
                            if(proteinApp.models[0].PAGE_DATA[0].GRID[g].COLS[c].WIDGET[w].ID == id){
                                proteinApp.models[0].PAGE_DATA[0].GRID[g].COLS[c].WIDGET[w].TITLE = proteinApp.widget_models[0].TITLE;
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
                                if(response.data.ACTION == proteinApp.method){
                                    alertObject({message:"Sayfa : " + response.data.IDENTITYCOL+ " kaydedildi 😉",type:"success"});
                                    setTimeout(function(){window.location="/index.cfm?fuseaction=protein.pages&event=upd&page=" + response.data.IDENTITYCOL + "&site=<cfoutput>#attributes.site#</cfoutput>";} , 2000);
                                }else if (response.data.ACTION =='friendly_url_control') {
                                    alertObject({message: response.data.ERROR ,type:"warning"}); 
                                    proteinApp.error.push({ecode: 'friendly_url_control', message:response.data.ERROR })
                                } 
                            }else{
                              alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
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
                                    var WIDGET_BOX_DATA=[{}];
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
                                cfmodalx({e:'close',id:'protein_widget_params'});;                                
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
            deletePageConfirm : function(){                
                cfmodalx({e:'open',id:'del_page_confirm_modal'});
            },
            deletePage : function(){
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_page",{params:{page:proteinApp.models[0].ID}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Sayfa Silindi.",type:"success"}); 
                            cfmodalx({e:'close',id:'del_page_confirm_modal'});
                            setTimeout(function(){window.location="/index.cfm?fuseaction=protein.site&event=upd&site=<cfoutput>#attributes.site#</cfoutput>"} , 2000);                               
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    cfmodalx({e:'close',id:'del_page_confirm_modal'});
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
            },
            selectWoBox : function(){
                <cfoutput>
                    openBoxDraggable('#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=form_page.related_wo&function=proteinApp.woSelected&is_upd=1&only_choice=1&draggable=1&choice=1');
                </cfoutput>
                return false;
            },
            woSelected : function(selectet_wo,action){
                Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'RELATED_WO', selectet_wo);
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_wo",{params:{wo:selectet_wo}})
                .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                             wo = response.data.DATA[0];
                             if(!action) Vue.set(proteinApp.$data.models[0], 'FRIENDLY_URL', wo.FRIENDLY_URL);
                             if(!action) Vue.set(proteinApp.$data.models[0], 'TITLE', wo.HEAD);
                             Vue.set(proteinApp.$data, 'EVENT_LIST', wo.EVENT_LIST);
                             Vue.set(proteinApp.$data, 'EVENT_ADD', wo.EVENT_ADD);
                             Vue.set(proteinApp.$data, 'EVENT_UPD', wo.EVENT_UPD);
                             Vue.set(proteinApp.$data, 'EVENT_DETAIL', wo.EVENT_DETAIL);
                             Vue.set(proteinApp.$data, 'EVENT_DASHBOARD', wo.EVENT_DASHBOARD); 
                             Vue.set(proteinApp.$data, 'EVENT_DEFAULT', wo.EVENT_DEFAULT);
                             Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'EVENT_DEFAULT', wo.EVENT_DEFAULT);                             
                             if(!action)Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'EVENT', wo.EVENT_DEFAULT);  
                                                  
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }   
                        <cfif isdefined('attributes.related_page') and len(attributes.related_page)>
                            this.get_related_page_event(<cfoutput>#attributes.related_page#</cfoutput>);
                        <cfelseif isdefined('attributes.page') and len(attributes.page)>
                            this.get_related_page_event(<cfoutput>#attributes.page#</cfoutput>); 
                        </cfif>                      
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 2121, message:"method:get_wo bir problem meydana geldi..."})
                }) 

            },
            getRelated : function(related_page){                                 
                axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_relatedInfo",{params:{id:related_page}})
                .then(response => {
                        
                        if(response.data.STATUS == true){
                            related_page = JSON.parse(response.data.DATA[0].PAGE_DATA);
                            proteinApp.woSelected(related_page.RELATED_WO,'get')                          
                            console.log(related_page);                                                
                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }                        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 2121, message:"method:getRelated bir problem meydana geldi..."})
                })                 
            },
            get_related_page_event : function(related_page){                                 
                var x = axios.get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_related_page_event",{params:{related_page:related_page}})
                .then(response => {                        
                        if(response.data.STATUS == true){
                            console.log(proteinApp.EVENT_DEFAULT);
                            events__ = {
                                add:{page:(proteinApp.EVENT_DEFAULT != 'add')?0:related_page,child_page:(proteinApp.EVENT_DEFAULT == 'add')?0:1},
                                upd:{page:(proteinApp.EVENT_DEFAULT != 'upd')?0:related_page,child_page:(proteinApp.EVENT_DEFAULT == 'upd')?0:1},
                                list:{page:(proteinApp.EVENT_DEFAULT != 'list')?0:related_page,child_page:(proteinApp.EVENT_DEFAULT == 'list')?0:1},
                                det:{page:(proteinApp.EVENT_DEFAULT != 'det')?0:related_page,child_page:(proteinApp.EVENT_DEFAULT == 'det')?0:1},
                                dashboard:{page:(proteinApp.EVENT_DEFAULT != 'dashboard')?0:related_page,child_page:(proteinApp.EVENT_DEFAULT == 'dashboard')?0:1}
                            };
                            response.data.DATA.forEach(element => {
                                /*
                                CHILD_PAGE: 1
                                EVENT: "add"
                                PAGE_ID: 21 
                                */
                               if(element.EVENT == 'add') events__.add = {page:element.PAGE_ID,child_page:element.CHILD_PAGE};
                               if(element.EVENT == 'upd') events__.upd = {page:element.PAGE_ID,child_page:element.CHILD_PAGE};
                               if(element.EVENT == 'list') events__.list = {page:element.PAGE_ID,child_page:element.CHILD_PAGE};
                               if(element.EVENT == 'det') events__.det = {page:element.PAGE_ID,child_page:element.CHILD_PAGE};
                               if(element.EVENT == 'dashboard') events__.dashboard = {page:element.PAGE_ID,child_page:element.CHILD_PAGE};
                            });
                            console.log(events__);
                            Vue.set(proteinApp.$data, 'EVENT_STATUS', events__);

                        }else{
                            alertObject({message:"Hata : " + response.data.ERROR ,type:"danger"});  
                        }              
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                    proteinApp.error.push({ecode: 2121, message:"method:getRelated bir problem meydana geldi..."})
                })
            },            
            getRowParams : function(){   
                var ROW_PROPERTIES_DATA = [{}];
               /* 
                var SELECTED_ROW_DATA = proteinApp.models[0].PAGE_DATA[0].GRID[proteinApp.select_row].ROW_PARAMS  */
                try {
                    proteinApp.ROW_PROPERTIES_DATA = proteinApp.models[0].PAGE_DATA[0].GRID[proteinApp.select_row].ROW_PARAMS;
                } catch (error) {
                    console.log('1042');
                }              
                
                axios
                .post("/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_xml_settings",
                {
                    XML : 'protein_row_params.xml'
                })
                .then(response => {
                    ROW_PROPERTIES = JSON.parse(response.data.DATA);

                    if(!ROW_PROPERTIES.OBJECT_PROPERTY.length){ //tek param varsa dizi olarak gelmiyor, burası düzeltme olarak eklendi.
                        e = []
                        e[0] = ROW_PROPERTIES.OBJECT_PROPERTY; 
                        ROW_PROPERTIES.OBJECT_PROPERTY = e;
                    }
                    
                    Vue.set(proteinApp.$data, 'ROW_PROPERTIES', ROW_PROPERTIES);
                    if(!proteinApp.ROW_PROPERTIES_DATA){
                        console.log(1111111);
                        $.each(ROW_PROPERTIES.OBJECT_PROPERTY, function( index, item ) {
                            ROW_PROPERTIES_DATA[0][item.PROPERTY] = item.PROPERTY_DEFAULT;                            
                            console.log(item.PROPERTY);
                        });
                        Vue.set(proteinApp.$data, 'ROW_PROPERTIES_DATA', ROW_PROPERTIES_DATA[0]);
                    }        
                })
                .catch(e => {
                    alertObject({message:"Hata : sistem yanıt veremedi, daha sonra tekrar dene. HATA:1002",type:"danger"});
                    proteinApp.error.push({ecode: 1008, message:"method:"+proteinApp.method+" bir problem meydana geldi..."})
                });                
            },
            openRowParams : function(index_grid){
                this.select_row = index_grid; 
                cfmodalx({e:'open',id:'protein_row_params'}); 
                this.getRowParams();
            },
            saveRowParams : function(){
                this.models[0].PAGE_DATA[0].GRID[this.select_row].ROW_PARAMS = this.ROW_PROPERTIES_DATA
                cfmodalx({e:'close',id:'protein_row_params'}); 
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
            <cfif isdefined('attributes.page') and len(attributes.page)>
                axios
                .get( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=get_page", {params: {id :<cfoutput>#attributes.page#</cfoutput>}})
                .then(response => {
                    if(response.data.DATA[0].PAGE_DATA.length){
                        Vue.set(proteinApp.$data, 'models', response.data.DATA);
                        Vue.set(proteinApp.$data, 'temporary_model', response.data.DATA);

                        let PAGE_DATA = [];
                        PAGE_DATA[0] = JSON.parse(proteinApp.models[0].PAGE_DATA);

                        let PAGE_DATA_HISTORY = [];
                        PAGE_DATA_HISTORY[0] = JSON.parse(proteinApp.temporary_model[0].PAGE_DATA);

                        if(!PAGE_DATA[0].ACCESS_DATA){//access data daha önce olusturulmadi ise
                             PAGE_DATA[0].ACCESS_DATA = [{
                                COMPANY:{STATUS:0,SELECT:[]},
                                CONSUMER:{STATUS:0,SELECT:[]},
                                PUBLIC:{STATUS:0},
                                CARIER:{STATUS:0}
                            }]
                        }                        
                        Vue.set(proteinApp.$data.models[0], 'PAGE_DATA', PAGE_DATA);
                        /* Sonradan Eklenen json Veriler Eski Datalarda Hata Vermemesi İçin Gelen Dataya Ekleniyor */
                        if(!PAGE_DATA[0].RELATED_WO) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'RELATED_WO', '');
                        if(!PAGE_DATA[0].RELATED_PAGE) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'RELATED_PAGE', '');
                        if(!PAGE_DATA[0].EVENT) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'EVENT', '');
                        if(!PAGE_DATA[0].EVENT_DEFAULT) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'EVENT_DEFAULT', '');
                        if(!PAGE_DATA[0].HEADER_SCRIPT) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'HEADER_SCRIPT', '');
                        if(!PAGE_DATA[0].FOOTER_SCRIPT) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'FOOTER_SCRIPT', '');
                        if(!PAGE_DATA[0].SCHEMA_MARKUP) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'SCHEMA_MARKUP', 0);
                        if(!PAGE_DATA[0].SECURITY) Vue.set(proteinApp.$data.models[0].PAGE_DATA[0], 'SECURITY', 'Standart');
                        
                        Vue.set(proteinApp.$data.temporary_model[0], 'PAGE_DATA_HISTORY', PAGE_DATA_HISTORY);
                        
                        if(proteinApp.$data.models[0].PAGE_DATA[0].RELATED_WO)proteinApp.woSelected(proteinApp.$data.models[0].PAGE_DATA[0].RELATED_WO,'upd');

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
                                        proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
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
                                                            proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                                        }else{
                                                        alertObject({message:"Hata : 1998 - " + response.data.ERROR ,type:"danger"});  
                                                        }                            
                                                })
                                                .catch(e => {
                                                    alertObject({message:"Hata : 1999 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                                                    wmd.error.push({ecode: 1121, message:"method: bir problem meydana geldi..."})
                                                })

                                            }else{
                                                 proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
                                        proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.from.childNodes, function( index, value ) {
                                        proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
                                        console.log( index + " A---> title :" + value.dataset.widget_title + " id :" + value.dataset.widget_id );
                                        });

                                        var row_index = $(evt.to).closest('[data-row-index]').data('row-index');
                                        var col_index = $(evt.to).closest('[data-col-index]').data('col-index');
                                        proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET = [];
                                        console.log('ROW : ' + row_index + 'COL : ' + col_index);
                                        $.each(evt.to.childNodes, function( index, value ) {
                                        proteinApp.models[0].PAGE_DATA[0].GRID[row_index].COLS[col_index].WIDGET.push({ID:value.dataset.widget_id,TITLE:value.dataset.widget_title});
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
            <cfif isdefined('attributes.related_page') and len(attributes.related_page)>
                this.getRelated(<cfoutput>#attributes.related_page#</cfoutput>);
                this.models[0].PAGE_DATA[0].RELATED_PAGE = '<cfoutput>#attributes.related_page#</cfoutput>';
                this.models[0].PAGE_DATA[0].EVENT = '<cfoutput>#attributes.page_event#</cfoutput>';
            </cfif>            
            __x = 0;  
            $('#del_page_confirm_modal #wrk_submit_button').remove();          
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
        },
        watch:{
            widget_models : function(newValue){
                if(newValue[0].WIDGET_NAME == '-2'){proteinApp.getDesignBlocks(newValue[0].ID)}
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