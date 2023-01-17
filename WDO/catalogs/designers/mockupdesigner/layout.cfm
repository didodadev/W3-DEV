<link rel="stylesheet" href="/css/assets/template/w3-designer/style.css">
<cf_catalystheader>

<script type="text/html" id="cfbox_template">
    <div class="row">
        <div class="col col-3" style="padding-left:0;">
            <div class="col col-12" style="margin-top: -4px;">
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" data-bind="value: title" placeholder="Box Title">
                        <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = title; openBoxDraggable('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1')}"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-9" style="padding-left:0;">
            <div class="form-inline" style="line-height:29px!important">
                <input type="checkbox" data-bind="checked: dragdrop" style="display: inline-block; float: none; vertical-align: middle;">
                <i class="fa fa-arrows"></i>
                &nbsp;
                <input type="checkbox" data-bind="checked: refresh" style="display: inline-block; float: none; vertical-align: middle;">
                <i class="fa fa-refresh"></i>
                &nbsp;
                <input type="checkbox" data-bind="checked: collapsable" style="display: inline-block; float: none; vertical-align: middle;">
                <i class="fa fa-compress"></i>
                &nbsp;
                <input type="checkbox" data-bind="checked: closable" style="display: inline-block; float: none; vertical-align: middle;">
                <i class="fa fa-close"></i>
                &nbsp;
                <a href="javascript:void(0)" onclick="$(this).parent().parent().parent().next().toggle();$(this).find('.text_more, .text_less').toggle()"><span class="text_more">More...</span><span class="text_less" style="display: none;">Less...</span></a>
            </div>
        </div>
    </div>
    <div class="" style="display: none; margin: 6px 0; padding: 6px; border: 1px solid #ccc;">
        <div class="row">
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Is Widget</label>
                    <div class="col col-9">
                        <input type="checkbox" data-bind="checked: iswidget">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Design Type</label>
                    <div class="col col-9">
                        <input type="checkbox" data-bind="checked: design_type">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Left Side</label>
                    <div class="col col-9">
                        <input type="checkbox" data-bind="checked: left_side">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Unload Body</label>
                    <div class="col col-9">
                        <input type="checkbox" data-bind="checked: unload_body">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Scroll</label>
                    <div class="col col-9">
                        <input type="checkbox" data-bind="checked: scroll">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Box Type</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: box_type">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Body Height</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: body_height">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Style</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: style">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Header Style</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: header_style">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Body Style</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: body_style">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Title Style</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: title_style">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-sm-6">
                <div class="form-group">
                    <label class="col col-3">Unique Box Height</label>
                    <div class="col col-9">
                        <input type="textbox" style="width: 100%;" class="form-control" data-bind="value: uniquebox_height">
                    </div>
                </div>
            </div>
        </div>
    </div>
</script>

<div class="row" id = "app-mockup_designer">
    <div class="col col-2 col-md-2 col-sm-12 col-xs-12 uniqueRow toolbar" id="content">
        <cf_box title = "Elements" scroll = "0" resize = "0">
            <!-- ko foreach: appModels() -->
            <!-- ko if: $data.type() == 'Toolbox' -->
            <div class="toolbox-block">
                <div class="toolbox-body">
                    <div data-bind="dragula: { data: listOfElements(), group: 'fields' }" data-copy="source" data-accept="false" data-dropgroup="fields grids">
                        <div class="tool" data-bind="attr: { title: label, alt: label }">
                            <span data-bind="css: fieldType"></span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /ko -->
            <!-- /ko -->
        </cf_box>
        <div data-bind="visible: self.layoutType() == 'devDash'">
            <cf_box title = "Graphbox" resize = "0">
                <div class="struct-block">
                    <div class="toolbox-body">
                        <div data-bind="dragula: { data: graphBox(), group: 'blocks', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-copy="source" data-accept="false" data-dropgroup="cols">
                            <div class="tool" data-bind="attr: { title: name, alt: name }" style="text-align:center">
                                <img class="graphs" data-bind="attr: { src: '<cfoutput>#fusebox.server_machine_list#</cfoutput>/images/graphics/'+ name.toLowerCase() +'.png', title: name }" width="25" height="25">
                                <!--- <span class="graphs" data-bind="text: name"></span> --->
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box>
        </div>
        <div <!--- data-bind="visible: self.layoutType() != 'devSearch'" --->>
            <cf_box title = "Main Struct" scroll = "0" resize = "0">
                <!-- ko foreach: appModels() -->
                <!-- ko if: $data.type() == 'Main' -->
                <div class="struct-block">
                    <div class="struct-head" onclick="$(this).next().toggle('fast');$(this).children('i').toggleClass('fa-caret-right');$(this).children('i').toggleClass('fa-caret-down');">
                        <div class="title"><span data-bind="text: label"></span><i class="fa fa-caret-right"></i></div>
                    </div>
                    <div class="struct-body animated fadeIn" style="display: none;">
                        <div data-bind="dragula: { data: listOfElements(), group: 'fields' }" data-copy="source" data-accept="false" data-dropgroup="fields">
                            <div class="field" data-bind="visible: true || typeof $data[self.layoutType()] === 'function' && $data[self.layoutType()]() == true">
                                <label data-bind="text: label"></label>
                                <span class="struct-input" data-bind="css: fieldType"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /ko -->
                <!-- /ko -->
            </cf_box>
        </div>
        <div data-bind="visible: self.layoutType() != 'devSearch'"> 
            <cf_box title = "Sub Struct" resize = "0">
                <!-- ko foreach: appModels() -->
                <!-- ko if: $data.type() == 'Sub' -->
                <div class="struct-block">
                    <div class="struct-head" onclick="$(this).next().toggle('fast');$(this).children('i').toggleClass('fa-caret-right');$(this).children('i').toggleClass('fa-caret-down');">
                        <div class="title" data-bind="text: label"></div>
                        <i class="fa fa-caret-right"></i>
                    </div>
                    <div class="struct-body animated fadeIn" style="display: none;">
                        <!-- ko if : $data.template() == 'Default' -->
                        <div data-bind="dragula: { data: listOfElements(), group: 'fields' }" data-copy="source" data-accept="false" data-dropgroup="grids">
                            <div class="field" data-bind="visible: typeof $data[self.layoutType()] === 'function' && $data[self.layoutType()]() == true">
                                <label data-bind="text: label"></label>
                                <span class="struct-input" data-bind="css: fieldType">&nbsp;</span>
                            </div>
                        </div>
                        <!-- /ko -->
                        <!-- ko if : $data.template() != 'Default' -->
                        <div data-bind="dragula: { data: listOfElements(), group: 'fields' }" data-copy="source" data-accept="false" data-dropgroup="grids">
                            <div class="field" data-bind="visible: typeof $data[self.layoutType()] === 'function' && $data[self.layoutType()]() == true">
                                <label data-bind="text: label"></label>
                                <span data-bind="css: fieldType">&nbsp;</span>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                </div>
                <!-- /ko -->
                <!-- /ko -->
            </cf_box>
        </div>
    </div>
    <div class="col col-7 col-md-7 col-sm-12 col-xs-12 uniqueRow">
        <cf_box closable="0">
            <cfform name = "mockup_form">
                <div class="ui-form-list flex-list">
                    <div class="form-group">
                        <input name="mockup_name" id="mockup_name" type="text" data-bind="value: mockup_name" placeholder="Mockup Name">
                    </div>
                    <div class="form-group large">
                        <div class="input-group">
                            <input type="hidden" name="position_code" id="position_code">
                            <input type="hidden" name="employee_id" id="employee_id" data-bind = "value: mockup_author_id">
                            <input type="text" name="employee_name" id="employee_name" data-bind = "value: mockup_author_name" placeholder="Author">
                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind = "click: function(){ windowopen('index.cfm?fuseaction=objects.popup_list_positions&amp;field_name=mockup_form.employee_name&amp;field_emp_id=mockup_form.employee_id&amp;field_code=mockup_form.position_code&amp;select_list=1','list'); }"></span>
                        </div>
                    </div>
                    <cfif attributes.event eq 'upd'>
                        <cf_workcube_buttons is_upd='1' is_delete="1" is_insert="1" del_function="appDesign.delete()" add_function="kontrol()">
                    <cfelse>
                        <cf_workcube_buttons add_function="kontrol()">
                    </cfif>
                </div>
            </cfform>
        </cf_box>
        <cf_box title="Mockup Designer" closable="0">
            <cf_box_elements>
                <cf_tab defaultOpen="devAdd" divId="devAdd,devUpdate,devList,devInfo,devDash" divLang="Add;Upd;List;Info;Dashboard" beforeFunction="appDesign.setLayoutType('devAdd')|appDesign.setLayoutType('devUpdate')|return true|appDesign.setLayoutType('devInfo')|appDesign.setLayoutType('devDash')">
                    <div id = "unique_devAdd" class="ui-info-text uniqueBox">
                        <!-- ko with: appLayout.addLayout -->
                        <div class="row mt-3">
                            <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                        </div>
                        <div class="row mt-3">
                            <button data-bind="click: function() { createRow(); }, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left ml-0"><i class="fa fa-plus"></i>Add Row</button>
                            <button data-bind="click: function() { createCol('col'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Col</button>
                            <button data-bind="click: function() { createCol('grid'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Grid</button>
                        </div>
                        <div class="designer mt-3">
                            <div id="addform" data-bind="foreach: layout, visible: self.layoutType() == 'devAdd'">
                                <div class="row row-container col col-12" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                    <div class="row-header col col-12 mb-3">
                                        <div class="col col-10 col-xs-9 pdn-l-0">
                                            <label class="col col-2 col-xs-4">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <span><input type="checkbox" data-bind="checked: showtitle"></span>
                                                        Title
                                                    </div>
                                                </div>
                                            </label>
                                            <div class="col col-4 col-xs-6">
                                                <div class="form-group">
                                                    <div class="input-group" data-bind="visible: showtitle">
                                                        <input type="text" data-bind="value: rowtitle">
                                                        <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = rowtitle; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-3 pdn-r-0 text-right">
                                            <a href="javascript:void(0);" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length == 0) { removeBlock($data, appLayout.addLayout); } }"><i class="fa fa-trash row-trash"></i></a>
                                        </div>
                                    </div>
                                    <div class="row row-body col col-12" data-bind="dragula: { data: listOfCols, group: 'blocks', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="cols">
                                        <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                            <div class="block-header">
                                                <span class="columnName" data-bind="text: coltype.toUpperCase()"></span>
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
                                                <a href="javascript:void(0);" class="ml-2" data-bind="click: function() { if (($data.listOfElements().length > 0 && confirm('This column contains several fields. You cannot retrieve this if remove. Are you sure?')) || $data.listOfElements().length == 0) { removeBlock($data, $parent.listOfCols); } }"><i class="fa fa-trash col-trash"></i></a>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'col'" data-dropgroup="fields">
                                                <div class="field field-marker">
                                                    <!--- <p><i data-bind="visible: isDB" class="fa fa-database"></i><i data-bind="visible: isMethod" class="fa fa-code"></i></p> --->
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <span class="field-marker" data-bind="css: fieldType"></span>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'grid'" data-dropgroup="grids">
                                                <div class="list-field field field-marker">
                                                    <!--- <p><i data-bind="visible: isDB" class="fa fa-database"></i><i data-bind="visible: isMethod" class="fa fa-code"></i></p> --->
                                                    <label class="field-marker field-full" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                    <div id = "unique_devUpdate" class="ui-info-text uniqueBox">
                        <!-- ko with: appLayout.updLayout -->
                        <div class="row mt-3">
                            <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                        </div>
                        <div class="row mt-3">
                            <button data-bind="click: function() { createRow(); }, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left ml-0"><i class="fa fa-plus"></i>Add Row</button>
                            <button data-bind="click: function() { createCol('col'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Col</button>
                            <button data-bind="click: function() { createCol('grid'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Grid</button>
                        </div>
                        <div class="designer mt-3">
                            <div id="updateform" data-bind="foreach: layout, visible: self.layoutType() == 'devUpdate'">
                                <div class="row row-container col col-12" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                    <div class="row-header col col-12 mb-3">
                                        <div class="col col-10 col-xs-9 pdn-l-0">
                                            <label class="col col-2 col-xs-4">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <span><input type="checkbox" data-bind="checked: showtitle"></span>
                                                        Title
                                                    </div>
                                                </div>
                                            </label>
                                            <div class="col col-4 col-xs-6">
                                                <div class="form-group">
                                                    <div class="input-group" data-bind="visible: showtitle">
                                                        <input type="text" data-bind="value: rowtitle">
                                                        <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = rowtitle; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-3 pdn-r-0 text-right">
                                            <a href="javascript:void(0);" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length == 0) { removeBlock($data, appLayout.updLayout); } }"><i class="fa fa-trash row-trash"></i></a>
                                        </div>
                                    </div>
                                    <div class="row row-body col col-12" data-bind="dragula: { data: listOfCols, group: 'blocks', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="cols">
                                        <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                            <div class="block-header">
                                                <span class="columnName" data-bind="text: coltype.toUpperCase()"></span>
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
                                                <a href="javascript:void(0)" class="ml-2" data-bind="click: function() { if (($data.listOfElements().length > 0 && confirm('This column contains several fields. You cannot retrieve this if remove. Are you sure?')) || $data.listOfElements().length == 0) { removeBlock($data, $parent.listOfCols); } }"><i class="fa fa-trash col-trash"></i></a>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'col'" data-dropgroup="fields">
                                                <div class="field field-marker">
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <span class="field-marker" data-bind="css: fieldType"></span>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'grid'" data-dropgroup="grids">
                                                <div class="list-field field field-marker">
                                                    <label class="field-marker field-full" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                    <div id = "unique_devInfo" class="ui-info-text uniqueBox">
                        <!-- ko with: appLayout.infoLayout -->
                        <div class="row mt-3">
                            <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                        </div>
                        <div class="row mt-3">
                            <button data-bind="click: function() { createRow(); }, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left ml-0"><i class="fa fa-plus"></i>Add Row</button>
                            <button data-bind="click: function() { createCol('col'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Col</button>
                        </div>
                        <div class="designer mt-3">
                            <div id="infoform" data-bind="foreach: layout, visible: self.layoutType() == 'devInfo'">
                                <div class="row row-container col col-12" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                    <div class="row-header col col-12 mb-3">
                                        <div class="col col-10 col-xs-9 pdn-l-0">
                                            <label class="col col-2 col-xs-4">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <span><input type="checkbox" data-bind="checked: showtitle"></span>
                                                        Title
                                                    </div>
                                                </div>
                                            </label>
                                            <div class="col col-4 col-xs-6">
                                                <div class="form-group">
                                                    <div class="input-group" data-bind="visible: showtitle">
                                                        <input type="text" data-bind="value: rowtitle">
                                                        <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = rowtitle; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-3 pdn-r-0 text-right">
                                            <a href="javascript:void(0);" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length == 0) { removeBlock($data, appLayout.infoLayout); } }"><i class="fa fa-trash row-trash"></i></a>
                                        </div>
                                    </div>
                                    <div class="row row-body col col-12" data-bind="dragula: { data: listOfCols, group: 'blocks', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="cols">
                                        <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                            <div class="block-header">
                                                <span class="columnName" data-bind="text: coltype.toUpperCase()"></span>
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
                                                <a href="javascript:void(0);" class="ml-2" data-bind="click: function() { if (($data.listOfElements().length > 0 && confirm('This column contains several fields. You cannot retrieve this if remove. Are you sure?')) || $data.listOfElements().length == 0) { removeBlock($data, $parent.listOfCols); } }"><i class="fa fa-trash col-trash"></i></a>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'col'" data-dropgroup="fields">
                                                <div class="field field-marker">
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <span class="field-marker" data-bind="css: fieldType"></span>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                            <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }, visible: coltype == 'grid'" data-dropgroup="grids">
                                                <div class="list-field field field-marker">
                                                    <label class="field-marker field-full" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                    <!-- ko with: appLayout.listLayout -->
                    <div id = "unique_devList" class="ui-info-text uniqueBox">
                        <cf_seperator id = "list_search" title = "Search" onClick_function = "appDesign.setLayoutType('devSearch');" closeForGrid="1">
                        <div id = "list_search" data-bind="visible: self.layoutType() == 'devSearch'">
                            <!-- ko with: search -->
                            <div class="row mt-3">
                                <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                            </div>
                            <div class="row mt-3">
                                <button data-bind="click: function() { createRow(); }, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left ml-0"><i class="fa fa-plus"></i>Add Row</button>
                                <button data-bind="click: function() { createCol('col'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Col</button>
                                <button data-bind="click: function() { createCol('grid'); }, enable: hasRow, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-plus"></i>Add Grid</button>
                            </div>
                            <div class="designer mt-3">
                                <div id="searchform" data-bind="foreach: layout">
                                    <div class="row row-container" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                        <div class="row-header col col-12 mb-3">
                                            <div class="col col-10 col-xs-9 pdn-l-0">
                                                <label class="col col-2 col-xs-4">
                                                    <div class="form-group">
                                                        <div class="input-group">
                                                            <span><input type="checkbox" data-bind="checked: showtitle"></span>
                                                            Title
                                                        </div>
                                                    </div>
                                                </label>
                                                <div class="col col-4 col-xs-6">
                                                    <div class="form-group">
                                                        <div class="input-group" data-bind="visible: showtitle">
                                                            <input type="text" data-bind="value: rowtitle">
                                                            <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = rowtitle; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col col-2 col-xs-3 pdn-r-0 text-right">
                                                <a href="javascript:void(0)" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length == 0) { removeBlock($data, self.appLayout.listLayout, true); } }"><i class="fa fa-trash row-trash"></i></a>
                                            </div>
                                        </div>
                                        <div class="row row-body" data-bind="dragula: { data: listOfCols, group: 'blocks', moves: function(el, source, handle, sibling) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="cols">
                                            <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                                <div class="block-header">
                                                    <span class="columnName" data-bind="text: coltype.toUpperCase()"></span>
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
                                                    <a href="javascript:void(0);" class="ml-2" data-bind="click: function() { if (($data.listOfElements().length > 0 && confirm('This column contains several fields. You cannot retrieve this if remove. Are you sure?')) || $data.listOfElements().length == 0) { removeBlock($data, $parent.listOfCols); } }"><i class="fa fa-trash col-trash"></i></a>
                                                </div>
                                                <div class="field-container" data-bind="dragula: { data: listOfElements, group: 'fields' }" data-dropgroup="fields">
                                                    <div class="field field-marker">
                                                        <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                        <span class="field-marker" data-bind="css: fieldType"></span>
                                                        <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind = "click: function(){ $root.setActiveElement( $data, $parent, 'Main', 'Default' ); }"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /ko -->
                        </div>
                        <cf_seperator id = "list_table" title = "Table" onClick_function = "appDesign.setLayoutType('devList');" closeForGrid="1">
                        <div id = "list_table" data-bind="visible: self.layoutType() == 'devList'">
                            <div class="row mt-3">
                                <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                            </div>
                            <div class="designer mt-3">
                                <div id="listform" >
                                    <div class="row">
                                        <div class="col col-12 pdn-l-0 pdn-r-0">
                                            <div class="field-container" data-bind="dragula: { data: layout, group: 'fields' }" data-dropgroup="fields">
                                                <div class="list-field field field-marker">
                                                    <span class="table-field" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></span>
                                                    <i class="fa fa-cog fa-1-3x mt-2 ml-2" data-bind="click: function() { $root.setActiveElement($data, $parent, 'Main', 'Default'); }"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id = "unique_devDash" class="ui-info-text uniqueBox">
                        <!-- ko with: appLayout.dashLayout -->
                        <div class="row mt-3">
                            <span data-bind="template: { name: 'cfbox_template', data: box }"></span>
                        </div>
                        <div class="row mt-3">
                            <button data-bind="click: function() { createRow(); }, visible: hasTree" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left ml-0"><i class="fa fa-plus"></i>Add Row</button>
                        </div>
                        <div class="designer mt-3">
                            <div id="dashform" data-bind="foreach: layout, visible: self.layoutType() == 'devDash'">
                                <div class="row row-container" data-bind="css: { 'active' : self.activeRow() == $data }, click: function() { self.activeRow($data); return true; }">
                                    <div class="row-header col col-12 mb-3">
                                        <div class="col col-10 col-xs-9 pdn-l-0">
                                            <label class="col col-2 col-xs-4">
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <span><input type="checkbox" data-bind="checked: showtitle"></span>
                                                        Title
                                                    </div>
                                                </div>
                                            </label>
                                            <div class="col col-4 col-xs-6">
                                                <div class="form-group">
                                                    <div class="input-group" data-bind="visible: showtitle">
                                                        <input type="text" data-bind="value: rowtitle">
                                                        <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = rowtitle; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-3 pdn-r-0 text-right">
                                            <a href="javascript:void(0);" data-bind="click: function() { if (($data.listOfCols().length > 0 && confirm('This row contains several columns. You cannot retrieve this if remove. Are you sure?')) || $data.listOfCols().length == 0) { removeBlock($data, appLayout.dashLayout); } }"><i class="fa fa-trash row-trash"></i></a>
                                        </div>
                                    </div>
                                    <div class="row row-body graph_body" data-bind="dragula: { data: listOfCols, group: 'blocks', moves: function( el, source, handle, sibling ) { return !handle.classList.contains('field-marker'); } }" data-dropgroup="cols">
                                        <div data-bind="attr: { class: 'col col-' + $data.colsize() }">
                                            <div class="block-header">
                                                <span class="columnName" data-bind="text:  ( name.toUpperCase() != '' ) ? coltype.toUpperCase() + ' - ' + name.toUpperCase() : coltype.toUpperCase()"></span>
                                                <select data-bind="value: cachetime">
                                                    <option value="0">Nocache</option>
                                                    <option value="15">15 Min</option>
                                                    <option value="30">30 Min</option>
                                                    <option value="60">1 Hr</option>
                                                    <option value="120">2 Hr</option>
                                                    <option value="240">4 Hr</option>
                                                    <option value="360">6 Hr</option>
                                                    <option value="720">12 Hr</option>
                                                    <option value="1440">24 Hr</option>
                                                </select>
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
                                                <a href="javascript:void(0)" class="ml-2" data-bind="click: function() { if (($data.listOfAxis().length > 0 && confirm('This column contains several fields. You cannot retrieve this if remove. Are you sure?')) || $data.listOfElements().length == 0) { removeBlock($data, $parent.listOfCols); } }"><i class="fa fa-trash col-trash"></i></a>
                                            </div>
                                            <div class="container-title">Axis</div>
                                            <div class="field-container" data-bind="dragula: { data: listOfAxis, group: 'fields', afterDrop: self.graphDroped }, visible: coltype == 'graph'" data-dropgroup="fields" data-accept="false">
                                                <div class="field field-marker">
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <select data-bind="value: graphMethod">
                                                        <option value="group">Group</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="container-title">Summary</div>
                                            <div class="field-container" data-bind="dragula: { data: listOfSummaries, group: 'fields', afterDrop: self.graphDroped }, visible: coltype == 'graph'" data-dropgroup="fields" data-accept="false">
                                                <div class="field field-marker">
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <select class="field-marker" data-bind="value: graphMethod">
                                                        <option value="sum">Sum</option>
                                                        <option value="count">Count</option>
                                                        <option value="avg">Average</option>
                                                        <option value="min">Minimum</option>
                                                        <option value="max">Maximum</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="container-title">Arguments</div>
                                            <div class="field-container" data-bind="dragula: { data: listOfArguments, group: 'fields', afterDrop: self.graphArgDropped }, visible: coltype == 'graph'" data-dropgroup="fields" data-accept="false">
                                                <div class="field field-marker">
                                                    <label class="field-marker" data-bind="text: (langNo() != '') ? label() + ' - ' + langNo() : label()"></label>
                                                    <select class="field-marker" data-bind="value: graphMethod">
                                                        <option value="equal">=</option>
                                                        <option value="less">&lt;</option>
                                                        <option value="greater">&gt;</option>
                                                        <option value="lessequal">&lt;=</option>
                                                        <option value="greaterequal">&gt;=</option>
                                                        <option value="like">LIKE</option>
                                                    </select>
                                                    <input type="text" data-bind="value: graphMethodArg">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                    <!-- /ko -->
                </cf_tab>
            </cf_box_elements>
        </cf_box>
    </div>
    <div class="col col-3 col-md-3 col-sm-12 col-xs-12 propertiesbar">
        <cf_box id="box_element_info" title = "Element Properties" closable = "0" resize = "0">
            <div id = "element_info" data-bind = "with: $root.activeElementDomain">
                <cf_grid_list id = "table_element_info">
                    <tbody>
                        <tr>
                            <td>Struct Name</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" list="dlstruct" data-bind="value: struct">
                                    <datalist id="dlstruct">
                                        <!-- ko foreach: self.structs -->
                                        <option data-bind="value: $data, text: $data"></option>
                                        <!-- /ko -->
                                    </datalist>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Input Name</td>
                            <td>
                                <div class="form-group">
                                    <input type = "text" data-bind = "value:label">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Lang No</td>
                            <td>
                                <div class="form-group">
                                    <div class="input-group">
                                        <input type="text" data-bind="value: langNo">
                                        <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = langNo; openBoxDraggable('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1')}"></a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <!-- ko if: self.layoutType() != 'devList' -->
                        <tr>
                            <td>Data Type</td>
                            <td>
                                <div class="form-group">
                                    <select data-bind="value: dataType">
                                        <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                        <option>Numeric</option>
                                        <option>Alphanumeric</option>
                                        <option>Date</option>
                                        <option>Money</option>
                                        <option>E-Mail</option>
                                        <option>Phone</option>
                                        <option>Zip Code</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr data-bind="attr: { style: dataType() == 'Numeric' ? 'display: none' : '' }">
                            <td>Min Size</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" data-bind="value: minSize">
                                </div>
                            </td>
                        </tr>
                        <tr data-bind="attr: { style: dataType() == 'Numeric' ? 'display: none' : '' }">
                            <td>Max Size</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" data-bind="value: maxSize">
                                </div>
                            </td>
                        </tr>
                        <tr data-bind="attr: { style: dataType() == 'Numeric' ? 'display: none' : '' }">
                            <td>Float Size</td>
                            <td>
                                <div class="form-group">
                                    <input type="text" data-bind="value: floatSize">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Required</td>
                            <td>
                                <div class="form-group">
                                    <input type="checkbox" data-bind="checked: isRequired">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan = "2">
                                <cf_grid_list id = "table_element_event_info">
                                    <thead>
                                        <tr>
                                            <th>Add</th>
                                            <th>Upd</th>
                                            <th>List</th>
                                            <th>Search</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="form-group">
                                                    <input type="checkbox" data-bind="checked: devAdd">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="checkbox" data-bind="checked: devUpdate">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="checkbox" data-bind="checked: devList">
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <input type="checkbox" data-bind="checked: devSearch">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </cf_grid_list>
                            </td>
                        </tr>
                        <tr>
                            <td colspan = "2">
                                <cf_grid_list id = "table_element_dev_settings">
                                    <thead>
                                        <tr>
                                            <th colspan="2">Value Settings</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr data-bind="visible: fieldType() != 'Custom Tag'">
                                            <td>Method</td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="text" data-bind="value: devMethod().value">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.devMethod; window.setFieldValue({value: ''}); window.getFieldValue('mtd.cmp'); }"></span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </cf_grid_list>
                            </td>
                        </tr>
                        <!-- /ko -->
                    </tbody>
                </cf_grid_list>
                <div class="row formContentFooter">
                    <button class="ui-wrk-btn ui-wrk-btn-success ui-btn-block mt-1 ml-0" data-bind="click: function() { $root.commitActiveElementDomain(); }">Save</button>
                    <!-- ko if: self.activeElementisToolbox == false -->
                    <button class="ui-wrk-btn ui-wrk-btn-red ui-btn-block mt-1 ml-0" data-bind="click: function() { $root.removeActiveElementDomain(); }">Remove</button>
                    <!-- /ko -->
                </div>
            </div>
        </cf_box>
    </div>
</div>

<script>
    function kontrol() {
        
        if( document.getElementById('mockup_name').value == '' ){
            alert("Please enter the mockup name!");
            return false;
        }
        
        if( document.getElementById('employee_id').value == '' || document.getElementById('employee_name').value == '' ){
            alert("Please enter the author name!");
            return false;
        }

        appDesign.save();

        return false;

    }

</script>