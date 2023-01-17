<link rel="stylesheet" href="/css/assets/template/w3-designer/style.css">
<cf_catalystheader>

<cfset event_query = get_event_detail(attributes.id)>

<cfset events = {
    add: {status: (event_query.ADD_ID gt 0 ? true : false), id: event_query.ADD_ID, icon: 'fa-plus'},
    upd: {status: (event_query.UPDATE_ID gt 0 ? true : false), id: event_query.UPDATE_ID, icon: 'fa-edit'},
    list: {status: (event_query.LIST_ID gt 0 ? true : false), id: event_query.LIST_ID, icon: 'fa-align-justify'},
    dashboard: {status: (event_query.DASHBOARD_ID gt 0 ? true : false), id: event_query.DASHBOARD_ID, icon: 'fa-image'},
    info: {status: (event_query.INFO_ID gt 0 ? true : false), id: event_query.INFO_ID, icon: 'fa-cube'}
}/>

<div class="row" id="appLayout">
    <div class="col col-3 col-md-3 col-xs-12 uniqueRow toolbar" id="content">
        <cf_box title = "Widgets" scroll = "0" resize = "0">
            <div data-bind="visible: self.viewMode() == 'editor'">
                <div class="widget-search-input">
                    <i class="fa fa-search"></i>
                    <input type="text" data-bind="value: keyword, valueUpdate: 'input', evSearchWidget: searchWidget" placeholder="arama yap...">
                </div>
                <ul class="scroll-md ui-list list-main" data-bind="dragula: { data: lofWidgets, group: 'widget' }" data-copy="source" data-accept="false" data-dropgroup="widget">
                    <li class="widget">
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-packing-3"></span>
                                <span id="widget-title" data-bind="text: $data.title.charAt(0).toUpperCase() + $data.title.slice(1)"></span>
                            </div>
                            <div class="ui-list-right">
                                <i data-bind = "attr: { class: 'fa ' + ($data.tool == 'nocode' ? 'fa-codepen' : 'fa-file'), title: ($data.tool == 'nocode' ? 'NoCode' : 'Hard Code') }, click: function() { if( $data.tool == 'nocode' ){ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=upd&fuseact=' + $data.fuseaction + '&event_type=' + $data.event + '&version=' + $data.version + '&id=' + $data.id + '&woid=' + $data.woid + '#widget','Widget'); }else{ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=add&id=' + $data.id + '&woid=#widget','Widget') } }"></i>
                            </div>
                        </a>
                    </li>
                </ul>
                <ul class="scroll-md ui-list module-widget mt-3" data-bind="foreach: lofModuleWidgets">
                    <li>
                        <a href="javascript:void(0)" onClick="$(this).next('ul').slideToggle(200)" style=" position: sticky; top: -1px; background: white; ">
                            <div class="ui-list-left">
                                <span data-bind="attr: { class: 'ui-list-icon ' + module.icon }"></span>
                                <span data-bind="text: module.title.charAt(0).toUpperCase() + module.title.slice(1)">
                            </div>
                        </a>
                        <ul class="list-main" data-bind="dragula: { data: widget, group: 'widget' }" data-copy="source" data-accept="false" data-dropgroup="widget" style="display:none;">
                            <li class="widget">
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-packing-3"></span>
                                        <span id="widget-title" data-bind="text: $data.title.charAt(0).toUpperCase() + $data.title.slice(1) + (!$data.version.includes('v') ? ' v' : ' ') + $data.version + ' / ' + $data.event "></span>
                                    </div>
                                    <div class="ui-list-right">
                                        <i data-bind = "attr: { class: 'fa ' + ($data.tool == 'nocode' ? 'fa-codepen' : 'fa-file'), title: ($data.tool == 'nocode' ? 'NoCode' : 'Hard Code') }, click: function() { if( $data.tool == 'nocode' ){ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=upd&fuseact=' + $data.fuseaction + '&event_type=' + $data.event + '&version=' + $data.version + '&id=' + $data.id + '&woid=' + $data.woid + '#widget','Widget'); }else{ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=add&id=' + $data.id + '&woid=#widget','Widget') } }"></i>
                                    </div>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </cf_box>
        <cf_box title = "#getLang('Hazır Objeler','',63118)#" scroll = "0" resize = "0">
            <div data-bind="visible: self.viewMode() == 'editor'">
                <ul class="scroll-md ui-list list-main" data-bind="dragula: { data: lofReadyObjects, group: 'widget' }" data-copy="source" data-accept="false" data-dropgroup="widget">
                    <li class="widget">
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-packing-3"></span>
                                <span id="widget-title" data-bind="text: $data.title.charAt(0).toUpperCase() + $data.title.slice(1)"></span>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
        </cf_box>
    </div>
    <div class="col col-6 col-md-6 col-xs-12 uniqueRow">
        <cf_box closable="0">
            <cfform name = "events_form">
                <div class="ui-form-list flex-list">
                    <div data-bind="visible: self.viewMode() == 'editor'">
                        <button type="button" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" data-bind="click: function() { newRow(); }"><i class="fa fa-plus"></i>Add Row</button>
                        <button type="button" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" data-bind="click: function() { newCol(); }, enable: hasRow"><i class="fa fa-plus"></i>Add Col</button> 
                    </div>
                    <div data-bind="visible: self.viewMode() == 'menu'">
                        <button type="button" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" data-bind="click: function() { newMenuElm(); }"><i class="fa fa-plus"></i>Add Menu Element</button>
                    </div>
                    <cfloop collection = "#events#" item = "item">
                        <cfif events[item].status >
                            <cfset newQueryString = LCase(replace(replace(cgi.query_string, "event_type=#attributes.event_type#", "event_type=#item#"),"id=#attributes.id#", "id=#events[item].id#")) />
                            <cfoutput><a class="ui-wrk-btn btn-info" href="#request.self#?#newQueryString#"><!--- <i class="fa #events[item].icon#"></i> --->#UCase(item)#</a></cfoutput>
                        </cfif>
                    </cfloop>
                    <cf_workcube_buttons is_upd='1' is_delete="0" is_insert="1" add_function="kontrol()">
                </div>
            </cfform>
        </cf_box>
        <cf_box title="Event Designer - #UCase(attributes.event_type)#" closable="0">
            <cf_box_elements>
                <cf_tab defaultOpen="editor" divId="editor,json,menu" divLang="Design;Json Editor;Menu Design" beforeFunction="eventApp.showEditor()|eventApp.showJSON()|eventApp.showMenu()">
                    <div id="editor" class="designer col col-12 mt-3" data-bind="visible: viewMode() == 'editor'">
                        <div class="col col-12 mb-3 pdn-r-0">
                            <div class="form-group">
                                <label class="col col-3 pdn-l-0">Master Widget:</label>
                                <div class="col col-9 pdn-r-0">
                                    <select data-bind="value: self.template.masterWidget, options: masterWidgetListSource, optionsText: 'title', optionsValue: 'uniqid', optionsCaption: 'No Master'" style="padding: 4px; min-width: 100px;"></select>
                                </div>
                            </div>
                        </div>
                        <!-- ko with: template -->
                        <div data-bind="foreach: lofRows">
                            <div class="row row-container col col-12" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                <a href="javascript:void(0);" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length === 0) { removeRow( $data ); } }"><i class="fa fa-trash fa-1-5x text-danger"></i></a>
                                <div class="row row-body col col-12" data-bind="dragula: { data: listOfCols, group: 'col', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="col">
                                    <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                        <div class="block-header text-right">
                                            <select data-bind="value: colsize">
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                                <option>4</option>
                                                <option>5</option>
                                                <option>6</option>
                                                <option>7</option>
                                                <option>8</option>
                                                <option>9</option>
                                                <option>10</option>
                                                <option>11</option>
                                                <option>12</option>
                                            </select>
                                            <a href="javascript:void(0);" class="ml-2" data-bind="click: function() { if ($data.listOfWidgets().length > 0 && confirm('This column contains several widgets. You cannot retrieve this if remove. Are you sure?') || $data.listOfWidgets().length == 0) { removeColumn($data, $parent); } }"><i class="fa fa-trash fa-1-5x text-danger"></i></a>
                                        </div>
                                        <ul class="widget ui-list widget-list-col" data-bind="dragula: { data: $data.listOfWidgets, group: 'widget', afterDrop: self.widgetDropped }" data-dropgroup="widget">
                                            <li>
                                                <a href="javascript://">
                                                    <div class="ui-list-left">
                                                        <span class="ui-list-icon ctl-packing-3"></span>
                                                        <span id="widget-title" data-bind="text: title"></span>
                                                    </div>
                                                    <div class="ui-list-right">
                                                        <span class="fa fa-codepen" data-bind = "visible: ($data.tool != 'readyobject'), attr: { class: 'fa ' + ($data.tool == 'nocode' ? 'fa-codepen' : 'fa-file'), title: ($data.tool == 'nocode' ? 'NoCode' : 'Hard Code') }, click: function() { if( $data.tool == 'nocode' ){ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=upd&fuseact=' + $data.fuseaction + '&event_type=' + $data.event + '&version=' + $data.version + '&id=' + $data.id + '&woid=' + $data.woid + '#widget','Widget'); }else{ window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.widget&event=add&id=' + $data.id + '&woid=#widget','Widget') } }"></span>
                                                        <span class="icon-cog ml-2" data-bind = "click: function(){ $root.setActiveWidget( $data, $parent ); }"></span>
                                                        <span class="fa fa-trash ml-2" data-bind = "click: function(){ if( confirm('Are you sure want to remove widget?') ) $root.removeWidget( $data, $parent ); }"></span>
                                                    </div>
                                                </a>
                                            </li>                    
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                    <div id="json" data-bind="visible: viewMode() == 'json'">
                        <div id="jsoneditor" style="width: 100%; height: 600px;"></div>
                    </div>
                    <div id="menu" data-bind="visible: viewMode() == 'menu'">
                        <div class="menubar" data-bind="dragula: { data: self.template.lofTabs, group: 'tab' }" data-dropgroup="tab">
                            <div class="menu-element">
                                <!--- <a href="javascript:void(0)" data-bind="click: function() { self.moveupMenu( $index() ); }"><i class="fa fa-angle-left"></i></a> --->
                                <a href="javascript:void(0)" data-bind="text: label, click: function() { self.editMenuElm($data); }"></a>
                            </div>
                        </div>
                    </div>
                </cf_tab>
            </cf_box_elements>
        </cf_box>
    </div>
    <div class="col col-3 col-md-3 col-xs-12 uniqueRow propertiesbar">
        <div class="row" data-bind = "visible: viewMode() != 'menu'">
            <cf_box id = "box_widget_info" title = "Widget Properties" closable = "0" resize = "0">
                <div id = "widget_info" data-bind = "with: $root.activeWidget">
                    <cf_grid_list id = "box_widget_info">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Version</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td data-bind = "text: title"></td>
                                <td data-bind = "text: version"></td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                    <cf_grid_list id = "box_widget_trigger_params">
                        <thead>
                            <tr><th colspan="2">Trigger and Params</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Trigger</td>
                                <td>
                                    <div class="form-group">
                                        <select data-bind="value: trigger(), options: resTrigger, optionsText: 'title', optionsValue: 'id'"></select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Params</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: params()">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = params; getFieldValue('map&towidget=' + id()); }"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <!-- ko if: tool() == 'readyobject' -->
                            <tr>
                                <td>Customtag</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: customtag().value">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = customtag; getFieldValue('tag&towidget=' + id(), $data.title().replace('cf_','') + '.cfm'); }"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <!-- /ko -->
                        </tbody>
                    </cf_grid_list>
                    <!-- ko if: props().length > 0 -->
                    <cf_grid_list id = "box_widget_props">
                        <thead>
                            <tr><th colspan = "2">Dynamic Properties</th></tr>
                        </thead>
                        <tbody data-bind = "foreach: props">
                            <tr>
                                <td data-bind = "text: label"></td>
                                <td>
                                    <div class="form-group">
                                        <!-- ko if: type == 'value' -->
                                            <input type="text" data-bind="value: valuedata">
                                        <!-- /ko -->
                                        <!-- ko if: type == 'options' -->
                                            <select data-bind="value: valuedata, options: value, optionsText: 'valuename', optionsValue: 'value', optionsCaption: 'Choose'"></select>
                                        <!-- /ko -->
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                    <!-- /ko -->
                    <div class="row formContentFooter">
                        <button class="ui-wrk-btn ui-wrk-btn-success ui-btn-block mt-1 ml-0" data-bind="click: function() { $root.commitActiveWidget(); }">Save</button>
                    </div>
                </div>
            </cf_box>
        </div>
        <div class="row" data-bind = "visible: viewMode() == 'menu'">
            <cf_box id = "box_menu_info" title = "Menu Properties" closable = "0" resize = "0">
                <div id = "widget_info" data-bind = "with: $root.activeMenu">
                    <cf_grid_list id = "box_widget_props">
                        <tbody>
                            <tr>
                                <td>Label</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: label">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = label; openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1')}"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Icon CSS</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: iconCss">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = iconCss; openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.icons&popup_page=1&is_popup=1&point=0&call_function=iconcss')}"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Icon Place</td>
                                <td>
                                    <div class="form-group">
                                        <select data-bind="value: place">
                                            <option value="top">Top</option>
                                            <option value="left">Left</option>
                                            <option value="all">Top + Left</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Type</td>
                                <td>
                                    <div class="form-group">
                                        <select data-bind="value: type">
                                            <option value="popup">Popup</option>
                                            <option value="blank">Blank</option>
                                            <option value="self">Self</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr data-bind="visible: type() == 'popup'">
                                <td>Popup Size</td>
                                <td>
                                    <div class="form-group">
                                        <select data-bind="value: popup">
                                            <option value="page">Page (900 X 600)</option>
                                            <option value="print_page">Print Page (750 X 500)</option>
                                            <option value="list">List (800 X 600)</option>
                                            <option value="medium">Medium (800 X 600)</option>
                                            <option value="small">Small (570 X 350)</option>
                                            <option value="large">Large (615 X 550)</option>
                                            <option value="longpage">Long Page (1200 X 500)</option>
                                            <option value="horizantal">Horizontal (1600 X 550)</option>
                                            <option value="list_horizantal">List Horizontal (1100 X 550)</option>
                                            <option value="page_horizantal">Page Horizontal (800 X 500)</option>
                                            <option value="norm_horizontal">Normal Horizontal (800 X 600)</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>WO</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: fuseaction">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { self.activeItem = $data; getFact(); }"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Event</td>
                                <td>
                                    <div class="form-group">
                                        <!-- ko if: self.activeEventType() == 'list' -->
                                        <select data-bind="value: event, options: self.activeEventList"></select>
                                        <!-- /ko -->
                                        <!-- ko if: self.activeEventType() == 'value' -->
                                        <input type="text" data-bind="value: event">
                                        <!-- /ko -->
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Parameters</td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" data-bind="value: parameter">
                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { self.activeItem = $data.parameter; getFieldValue('map&tofuse=' + $data.fuseaction()); }"></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                    <div class="row formContentFooter">
                        <button class="ui-wrk-btn ui-wrk-btn-success ui-btn-block mt-1 ml-0" data-bind="click: function() { $root.commitMenu(); }">Save</button>
                        <button class="ui-wrk-btn ui-wrk-btn-red ui-btn-block mt-1 ml-0" data-bind="click: function() { $root.deleteMenu(); }">Remove</button>
                    </div>
                </div>
            </cf_box>
        </div>
    </div>
</div>