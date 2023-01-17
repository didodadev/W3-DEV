<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<style>
    .devSettings input[type = 'text'], .devSettings select, .devSettings textarea{
        border:solid 1px rgb(204, 204, 204) !important;
    }
    .devSettings .input-group-addon{
        background-color:#eee !important;
    }
    #codeeditor .row:after, #codeeditor .row:before, #codeeditor .form-group:after, #codeeditor .form-group:before, #codeeditor div:after, #codeeditor div:before, .ace_editor .row:after, .ace_editor .row:before, .ace_editor .form-group:after, .ace_editor .form-group:before, .ace_editor div:after, .ace_editor div:before {
        display: none !important;
    }
    .seperator_nocode{height:37px;background: #f9f9f9;padding: 10px;margin:10px 0;}
    .seperator_nocode .seperator_title{width:95%;float:left;}
    .seperator_nocode .seperator_icon{width:5%;float:left;text-align:right;}
    .seperator_nocode a {font-weight: bold;font-size: 14px;color: #e08283!important;display:block;}
    .seperator_nocode i {font-size: 15px !important;}
</style>
<div id="appStruct">
    <cf_box title="Model" add_href="javascript:addStruct()">
        <cf_tab defaultOpen="editor" divId="editor,json,code" divLang="Design;Json Editor;Code Editor" beforeFunction="setMode('editor')|setMode('json')|setMode('code')">
            <div id="editor" data-bind="visible: viewMode() == 'editor'">
                <div data-bind="foreach: structCompositor">
                    <div class="dev-block mb-2">
                        <div class="seperator_nocode">
                            <div class="seperator_title">
                                <a href="javascript://" alt="Gizle/Göster" onclick="$(this).parent().parent().next().toggle();">
                                    STRUCT: <span data-bind="text: name"></span>
                                </a>
                            </div>
                            <div class="seperator_icon">
                                <i class="fa fa-trash row-trash" data-bind="click: function(data, event) { removeStruct($data, event); }" title="Remove Struct"></i>
                            </div>
                        </div>
                        <div>
                            <cf_box_elements>
                                <div class="col col-4 col-xs-12">
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-cube"></i> Struct/Function</label>
                                        <div class="col col-12">
                                            <input type="text" data-bind="value: name">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-cubes"></i> Struct Type</label>
                                        <div class="col col-12">
                                            <select data-bind="value: structType, event: { change: dataTypeChanged }">
                                                <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                <option>Main</option>
                                                <option>Sub</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-language"></i> Lang No</label>
                                        <div class="col col-12">
                                            <div class="input-group">
                                                <input type="text" data-bind="value: langNo">
                                                <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = langNo; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;module_name=dev&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-object-group"></i> Template</label>
                                        <div class="col col-12">
                                            <select data-bind="value: template">
                                                <option>Default</option>
                                                <option>Loop</option>
                                                <option>Add Row</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-tasks"></i> Method</label>
                                        <div class="col col-12">
                                            <div class="input-group">
                                                <input type="text" data-bind="value: method().value">
                                                <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.method; window.setFieldValue({value: ''}); window.getFieldValue('ses.sys.mtd.tag.cmp.tri'); }"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label col col-12"><i class="fa fa-chain"></i> Relation</label>
                                        <div class="col col-12">
                                            <select data-bind="value: relation, options: $root.relations($data)"></select>
                                        </div>
                                    </div>
                                </div>
                            </cf_box_elements>
                            <div>
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th colspan = "19">ELEMENTS</th>
                                        </tr>
                                        <tr>
                                            <th width="20"><i class="fa fa-plus" title="Add Element" data-bind="click: function() { addElement($data); };" title="Add Element"></i></th>
                                            <th width="100">Label</th>
                                            <th width="100">Lang No</th>
                                            <th width="60">Field Type</th>
                                            <th width="60">Data Type</th>
                                            <th width="60">Min. Size</th>
                                            <th width="60">Max. Size</th>
                                            <th width="60">Float Len</th>
                                            <th width="20"><i class="fa fa-key" title="Key"></i></th>
                                            <th width="20"><i class="fa fa-check" title="Default"></i></th>
                                            <th width="20"><i class="fa fa-asterisk" title="Required"></i></th>
                                            <th width="20"><a href="javascript:void()" data-bind="css: elementsAllAdd() ? 'selected' : '', click: function() { return elementsSetAdd(!elementsAllAdd()) }"><i class="fa fa-plus" title="Add"></i></a></th>
                                            <th width="20"><a href="javascript:void()" data-bind="css: elementsAllUpdate() ? 'selected' : '', click: function() { return elementsSetUpdate(!elementsAllUpdate()) }"><i class="fa fa-refresh" title="Update"></i></a></th>
                                            <th width="20"><a href="javascript:void()" data-bind="css: elementsAllList() ? 'selected' : '', click: function() { return elementsSetList(!elementsAllList()) }"><i class="fa fa-bars" title="List"></i></a></th>
                                            <th width="20"><a href="javascript:void()" data-bind="css: elementsAllSearch() ? 'selected' : '', click: function() { return elementsSetSearch(!elementsAllSearch()) }"><i class="fa fa-filter" title="Search"></i></a></th>
                                            <th width="20"><a href="javascript:void()" data-bind="css: elementsAllDash() ? 'selected' : '', click: function() { return elementsSetDash(!elementsAllDash()) }"><i class="fa fa-dashboard" title="Dashboard"></i></a></th>
                                            <th width="20"><i class="fa fa-codepen" title="Development Settings"></i></th>
                                            <th width="40">
                                                <i class="fa fa-caret-up" title="Move Up"></i>
                                                <i class="fa fa-caret-down" title="Move Down"></i>
                                            </th>
                                            <th width="20"><i class="fa fa-trash" title="Remove Element"></i></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- ko foreach: listOfElements -->
                                            <tr>
                                                <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                                <td>
                                                    <div class="form-group"><input type="text" data-bind="value: label, attr:{ readonly: isFixed }"></div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <div class="input-group">
                                                            <input type="text" data-bind="value: langNo">
                                                            <a href="javascript://" class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = langNo; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></a>    
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <select data-bind="value: fieldType, attr:{ disabled: isFixed }">
                                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                            <option>Input</option>
                                                            <option>Hidden Input</option>
                                                            <option>Select</option>
                                                            <option>Multi Select</option>
                                                            <option>Textarea</option>
                                                            <option>Radio Button</option>
                                                            <option>Checkbox</option>
                                                            <option>Upload File</option>
                                                            <option>Image</option>
                                                            <option>Button</option>
                                                            <option>Text</option>
                                                            <option>Custom Tag</option>
                                                            <option>Process Cat</option>
                                                            <option>Paper No</option>
                                                            <option>Workflow</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <select data-bind="value: dataType, attr:{ disabled: isFixed }">
                                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                            <option>Numeric</option>
                                                            <option>Alphanumeric</option>
                                                            <option>Date</option>
                                                            <option>Money</option>
                                                            <option>E-Mail</option>
                                                            <option>Password</option>
                                                            <option>Percent</option>
                                                            <option>Phone</option>
                                                            <option>Zip Code</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" data-bind="value: minSize, attr:{ readonly: isFixed, style: dataType() == 'Numeric' ? 'display: none' : '' }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" data-bind="value: maxSize, attr:{ readonly: isFixed, style: dataType() == 'Numeric' ? 'display: none' : '' }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" data-bind="value: floatSize, attr:{ readonly: isFixed, style: dataType() == 'Numeric' ? 'display: none' : '' }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isKey, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isDefault, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isRequired, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: devAdd, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: devUpdate, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: devList, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: devSearch, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: devDash, attr:{ disabled: isFixed }">
                                                    </div>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" style="" title="Development Settings" data-bind="click: function(data, event) { $(event.target).parent().parent().parent().next().toggle(100);$(event.target).toggleClass('color-maroon'); }"><i class="fa fa-codepen"></i></a>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" style="" data-bind="click: function() { $root.moveUp($parent.listOfElements, $index()); }" title="Move Up"><i class="fa fa-caret-up"></i></a>
                                                    <a href="javascript:void(0);" style="" data-bind="click: function() { $root.moveDown($parent.listOfElements, $index()); }" title="Move Down"><i class="fa fa-caret-down"></i></a>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" style="" data-bind="click: function() { removeElement($parent, $data, event); }" title="Remove Element"><i class="fa fa-trash"></i></a>
                                                </td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td colspan = "19" style="padding:0 0;">
                                                    <div class="dev-table">
                                                        <div class="tbody colorrow">
                                                            <div class="dev-form flipInX devSettings">
                                                                <div class="row">
                                                                    <div class="col col-12">
                                                                        <h2 class="mb-3 col">Development Settings</h2>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col col-3">
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-database"></i> DB Alias</label>
                                                                            <div class="col col-12">
                                                                                <input type="text" data-bind="value: devDBField().alias, attr: { list: label() + '_datalist' }">
                                                                                <datalist data-bind="attr: {id: label() + '_datalist'}">
                                                                                    <!-- ko foreach: $parent.aliasList() -->
                                                                                    <option data-bind="value: $data"></option>
                                                                                    <!-- /ko -->
                                                                                </datalist>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-database"></i> DB Table</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devDBField().table">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() {  $root.activeItem = $data.devDBField; window.setFieldValue({value: '', table: '', alias: '', shecme: '', type: 'db'}); window.getFieldValue('dbs'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-database"></i> DB Field</label>
                                                                            <div class="col col-12">
                                                                                <input type="text" data-bind="value: devDBField().field">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col col-3">
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-share-square-o"></i> Default Value</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devValue().value,attr:{ disabled: isFixed }">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { if ( $data.isFixed() ) return; $root.activeItem = $data.devValue; window.setFieldValue({value: ''}); window.getFieldValue('ses.sys.mtd.tag.cus'); } "></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group" data-bind="visible: fieldType() != 'Custom Tag'">
                                                                            <label class="form-label col col-12"><i class="fa fa-tasks"></i> Method</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devMethod().value,attr:{ readonly: isFixed}">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.devMethod; window.setFieldValue({value: ''}); window.getFieldValue('ses.sys.mtd.tag.cmp.tri.cus.wdt.lst'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group" data-bind="visible: fieldType() == 'Custom Tag'">
                                                                            <label class="form-label col col-12"><i class="fa fa-code"></i> Custom Tag</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devMethod().value,attr:{ readonly: isFixed }">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { function() { if ( $data.isFixed() ) return; $root.activeItem = $data.devMethod; window.setFieldValue({value: ''}); window.getFieldValue('tag'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-terminal"></i> Auto Complete</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devAutocomplete().value,attr:{ readonly: isFixed }">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { function() { if ( $data.isFixed() ) return; $root.activeItem = $data.devAutocomplete; window.setFieldValue({value: ''}); window.getFieldValue('cmp'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col col-3">
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-jsfiddle"></i> JS</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devJS().value">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.devJS; window.setFieldValue({value: ''}); window.getFieldValue('mtd.tag.cus'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-css3"></i> CSS</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devCSS().value">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.devCSS; window.setFieldValue({value: ''}); window.getFieldValue('mtd.tag.cus'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-chain"></i> Link</label>
                                                                            <div class="col col-12">
                                                                                <div class="input-group">
                                                                                    <input type="text" data-bind="value: devLink().value">
                                                                                    <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.devLink; window.setFieldValue({value: ''}); window.getFieldValue('cus'); }"></span>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col col-3">
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="catalyst-calculator"></i> Compute</label>
                                                                            <div class="col col-12">
                                                                                <select data-bind="value: dataCompute">
                                                                                    <option value="">None</option>
                                                                                    <option value="SUM">Sum</option>
                                                                                    <option value="COUNT">Count</option>
                                                                                    <option value="MIN">Min</option>
                                                                                    <option value="MAX">Max</option>
                                                                                    <option value="CONCAT">Concat</option>
                                                                                    <option value="Formula">Formula</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-calculator"></i> Formula</label>
                                                                            <div class="col col-12">
                                                                                <input type="text" data-bind="value: formula">
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group" data-bind="visible: fieldType() == 'Select' || fieldType() == 'Multi Select' || fieldType() == 'Radio Button'">
                                                                            <label class="form-label col col-12"><i class="fa fa-list"></i> List Source Indexes</label>
                                                                            <div class="col col-6">
                                                                                <input type="text" data-bind="value: listValueIndex" placeholder="Value Index Number">
                                                                            </div>
                                                                            <div class="col col-6">
                                                                                <input type="text" data-bind="value: listDisplayIndex" placeholder="Display Index Number">
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group">
                                                                            <label class="form-label col col-12"><i class="fa fa-archive"></i> Include Query</label>
                                                                            <div class="col col-6 col-xs-12 pdn-l-0">
                                                                                <div class="col col-3 pdn-l-0"><input type="checkbox" data-bind="checked: includeAdd"></div>
                                                                                <label class="col col-9 pdn-l-0">Add Query</label>
                                                                            </div>
                                                                            <div class="col col-6 col-xs-12 pdn-l-0">
                                                                                <div class="col col-3 pdn-l-0"><input type="checkbox" data-bind="checked: includeUpdate"></div>
                                                                                <label class="col col-9 pdn-l-0">Update Query</label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-group" data-bind="visible: devSearch">
                                                                            <label class="form-label col col-12"><i class="fa fa-filter"></i> Filter As Range</label>
                                                                            <div class="col col-6 pdn-l-0">
                                                                                <div class="col col-3 pdn-l-0"><input type="checkbox" data-bind="checked: filterAsRange"></div> 
                                                                                <label class="col col-9 pdn-l-0">Min and Max Inputs</label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col col-12 mt-4">
                                                                        <h2 class="mb-3 col">Connect to Property</h2>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <cf_grid_list>
                                                                        <thead>
                                                                            <tr>
                                                                                <th width="20"><i class="fa fa-plus" title="Add Connector" data-bind="click: function() { addElementPropertyMap($data.listOfPropertyMaps, null); }" title="Add Element"></i></th>
                                                                                <th>Type</th>
                                                                                <th>Target</th>
                                                                                <th><i class="fa fa-trash"></i></th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <!-- ko foreach: listOfPropertyMaps -->
                                                                            <tr>
                                                                                <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                                                                <td>
                                                                                    <div class="form-group">
                                                                                        <select data-bind="value: type">
                                                                                            <option value="valueOf">Value Of</option>
                                                                                            <option value="displayFor">Display For</option>
                                                                                        </select>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <div class="form-group">
                                                                                        <select data-bind="value: propertyName, options: $parents[1].listOfProperties, optionsText: 'label', optionsValue: 'label'">
                                                                                        </select>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <a href="javascript:void(0);" data-bind="click: function() { removeElementPropertyMap($parent, $data); }" title="Remove Property">
                                                                                        <i class="fa fa-trash"></i>
                                                                                    </a>
                                                                                </td>
                                                                            </tr>
                                                                            <!-- /ko -->
                                                                        </tbody>
                                                                    </cf_grid_list>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        <!-- /ko -->
                                    </tbody>
                                </cf_grid_list>
                            </div>
                            <div class="mt-3">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th colspan = "11">CONDITIONS</th>
                                        </tr>
                                        <tr>
                                            <th width="20"><i class="fa fa-plus" title="Add Element" data-bind="click: function() { addCondition($data); };" title="Add Condition"></i></th>
                                            <th width="60">Type</th>
                                            <th width="100">Left</th>
                                            <th width="60">Compare</th>
                                            <th width="100">Right</th>
                                            <th width="20"><i class="fa fa-plus" title="Add"></i></th>
                                            <th width="20"><i class="fa fa-refresh" title="Update"></i></th>
                                            <th width="20"><i class="fa fa-bars" title="List"></i></th>
                                            <th width="60">Join</th>
                                            <th width="40">
                                                <i class="fa fa-caret-up" title="Move Up"></i>
                                                <i class="fa fa-caret-down" title="Move Down"></i>
                                            </th>
                                            <th width="20"><i class="fa fa-trash" title="Remove Element"></i></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- ko foreach: listOfConditions -->
                                            <tr>
                                                <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                                <td>
                                                    <div class="form-group">
                                                        <select data-bind="value: type">
                                                            <option>Expression</option>
                                                            <option value="left">(</option>
                                                            <option value="right">)</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <div class="input-group">
                                                            <input type="text" data-bind="value: left().value()">
                                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.left; window.setFieldValue({value: '', table: '', alias: '', shecme: '', type: 'db'}); window.getFieldValue('dbs.ses.sys.mtd.tag.cus'); }"></span>
                                                            <input type="text" data-bind="value: left().alias(), attr: { list: 'condition_left_alias_' + $index() }">
                                                            <datalist data-bind="attr: { id: 'condition_left_alias_' + $index() }">
                                                                <!-- ko foreach: $parent.aliasList() -->
                                                                <option data-bind="value: $data"></option>
                                                                <!-- /ko -->
                                                            </datalist>
                                                        </div>
                                                        <input type="hidden" data-bind="value: left">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <select data-bind="value: comparison">
                                                            <option>=</option>
                                                            <option value="<>">&lt;&gt;</option>
                                                            <option value="<">&lt;</option>
                                                            <option value="<=">&lt;=</option>
                                                            <option value=">">&gt;</option>
                                                            <option value=">=">&gt;=</option>
                                                            <option>START WITH</option>
                                                            <option>END WITH</option>
                                                            <option>CONTAINS</option>
                                                            <option>NOT CONTAINS</option>
                                                            <option>IS</option>
                                                            <option>IS NOT</option>
                                                            <option>IN</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <div class="input-group">
                                                            <input type="text" data-bind="value: right().value">
                                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.right; window.setFieldValue({value: ''}); window.getFieldValue('dbs.ses.sys.mtd.tag.cus'); }"></span>
                                                            <input type="text" data-bind="value: right().alias, attr: { list: 'condition_right_alias_' + $index() }">
                                                            <datalist data-bind="attr: { id: 'condition_right_alias_' + $index() }">
                                                                <!-- ko foreach: $parent.aliasList() -->
                                                                <option data-bind="value: $data"></option>
                                                                <!-- /ko -->
                                                            </datalist>
                                                        </div>
                                                        <input type="hidden" data-bind="value: right">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <input type="checkbox" data-bind="checked: isAdd">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <input type="checkbox" data-bind="checked: isUpd">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() == 'Expression'">
                                                        <input type="checkbox" data-bind="checked: isList">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="visible: type() != 'left'">
                                                        <select data-bind="value: oper">
                                                            <option>AND</option>
                                                            <option>OR</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0)" style="" data-bind="click: function() { $root.moveUp($parent.listOfConditions, $index()); }" title="Move Up"><i class="fa fa-caret-up"></i></a>
                                                    <a href="javascript:void(0)" style="" data-bind="click: function() { $root.moveDown($parent.listOfConditions, $index()); }" title="Move Down"><i class="fa fa-caret-down"></i></a>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" style="" data-bind="click: function(data, event) { removeCondition($parent, $data, event); }" title="Remove Condition"><i class="fa fa-trash"></i></a>
                                                </td>
                                            </tr>
                                        <!-- /ko -->
                                    </tbody>
                                </cf_grid_list>
                            </div>
                            <div class="mt-3">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th colspan = "13">DYNAMIC PROPERTIES</th>
                                        </tr>
                                        <tr>
                                            <th><i class="fa fa-plus" title="Add Element" data-bind="click: function() { addProperty($data); }" title="Add Property"></i></th>
                                            <th>Label</th>
                                            <th>Lang No</th>
                                            <th>Type</th>
                                            <th>Value</th>
                                            <th>Help</th>
                                            <th><i class="fa fa-plus" title="Add"></i></th>
                                            <th><i class="fa fa-refresh" title="Update"></i></th>
                                            <th><i class="fa fa-bars" title="List"></i></th>
                                            <th><i class="fa fa-filter" title="Filter"></i></th>
                                            <th width="20"><i class="fa fa-codepen" title="Development Settings"></i></th>
                                            <th width="40">
                                                <i class="fa fa-caret-up" title="Move Up"></i>
                                                <i class="fa fa-caret-down" title="Move Down"></i>
                                            </th>
                                            <th width="20"><i class="fa fa-trash" title="Remove Element"></i></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- ko foreach: listOfProperties -->
                                            <tr>
                                                <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" data-bind="value: label">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <div class="input-group">
                                                            <input type="text" data-bind="value: langNo">
                                                            <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = langNo; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;module_name=dev&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <select data-bind="value: type">
                                                            <option value="value">Value</option>
                                                            <option value="options">Options</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="css: type() == 'value' ? 'hidden' : 'property-select', visible: type() == 'options'">
                                                        <div class="input-group">
                                                            <div class="col col-6"><input type="text" data-bind="arrayobjectvalue: { data: value, prop: 'value' }"></div>
                                                            <div class="col col-6"><input type="text" data-bind="arrayobjectvalue: { data: value, prop: 'valueName' }"></div>
                                                            <span class="input-group-addon" onclick="$(this).parent().parent().next().toggle();$(this).find('i').toggleClass('fa-caret-down fa-caret-right')"><i class="fa fa-caret-right"></i></span>
                                                        </div>
                                                    </div>
                                                    <!-- ko if: type() == 'options' -->
                                                        <div class="form-group" style="display: none;">
                                                            <!-- ko foreach: value -->
                                                                <div class="input-group">
                                                                    <div class="col col-6"><input type="text" data-bind="value: value" style="border:solid 1px #eee;"></div>
                                                                    <div class="col col-6"><input type="text" data-bind="value: valueName" style="border:solid 1px #eee;"></div>
                                                                    <span data-bind="click: function() { removePropertyValue($parent, $data) }"><i class="fa fa-minus"></i></span>
                                                                </div>
                                                            <!-- /ko -->
                                                            <div class="property-row text-right mt-1">
                                                                <button type="button" class="dev-btn dev-btn-primary-dark" data-bind="click: function() { addPropertyValue(value) }"><i class="fa fa-plus"></i> Add Row</button>
                                                            </div>
                                                        </div>
                                                    <!-- /ko -->
                                                </td>
                                                <td>
                                                    <div class="form-group" data-bind="css: type() == 'value' ? 'property-input' : 'property-select', visible: type() == 'options'">
                                                        <div class="input-group">
                                                            <input type="text" data-bind="value: help">
                                                            <span class="input-group-addon icon-ellipsis" data-bind="click: function() { $root.activeItem = langNo; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;module_name=dev&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isAdd">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isUpdate">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isList">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="checkbox" data-bind="checked: isSearch">
                                                    </div>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" title="Development Settings" onclick="$(this).parent().parent().next().toggle();$(this).children().toggleClass('color-maroon')"><i class="fa fa-codepen"></i></a>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" data-bind="click: function() { $root.moveUp($parent.listOfProperties, $index()); }" title="Move Up"><i class="fa fa-caret-up"></i></a>
                                                    <a href="javascript:void(0);" data-bind="click: function() { $root.moveDown($parent.listOfProperties, $index()); }" title="Move Down"><i class="fa fa-caret-down"></i></a>
                                                </td>
                                                <td>
                                                    <a href="javascript:void(0);" data-bind="click: function() { removeProperty($parent, $data); }" title="Remove Property"><i class="fa fa-trash"></i></a>
                                                </td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td colspan = "13" style="padding:0 0;">
                                                    <div class="dev-table">
                                                        <div class="tbody colorrow">
                                                            <div class="dev-form flipInX devSettings">
                                                                <div class="row">
                                                                    <div class="col col-12">
                                                                        <h2 class="mb-3 col">Conditions</h2>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <cf_grid_list>
                                                                        <thead>
                                                                            <tr>
                                                                                <th width="20"><i class="fa fa-plus" title="Add Connector" data-bind="click: function() { addPropertyCondition($data.listOfConditions, null); }" title="Add Condition"></i></th>
                                                                                <th>Type</th>
                                                                                <th>Left</th>
                                                                                <th>Compare</th>
                                                                                <th>Join</th>
                                                                                <th width="40">
                                                                                    <i class="fa fa-caret-up" title="Move Up"></i>
                                                                                    <i class="fa fa-caret-down" title="Move Down"></i>
                                                                                </th>
                                                                                <th width="20"><i class="fa fa-trash" title="Remove Condition"></i></th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <!-- ko foreach: listOfConditions -->
                                                                                <tr>
                                                                                    <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <select data-bind="value: type">
                                                                                                <option>Expression</option>
                                                                                                <option value="left">(</option>
                                                                                                <option value="right">)</option>
                                                                                            </select>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <div class="input-group" data-bind="visible: type() == 'Expression'">
                                                                                                <input type="text" data-bind="value: left().value">
                                                                                                <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.left; window.setFieldValue({value: '', table: '', alias: '', shecme: '', type: 'db'}); window.getFieldValue('dbs.ses.sys.mtd.tag.cus'); }"></span>
                                                                                                <input type="text" data-bind="value: left().alias(), attr: { list: 'property_condition_left_alias_' + $index() }">
                                                                                                <datalist data-bind="attr: { id: 'property_condition_left_alias_' + $index() }">
                                                                                                    <!-- ko foreach: $parents[1].aliasList() -->
                                                                                                    <option data-bind="value: $data"></option>
                                                                                                    <!-- /ko -->
                                                                                                </datalist>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <select data-bind="value: comparison" data-bind="visible: type() == 'Expression'">
                                                                                                <option>=</option>
                                                                                                <option value="<>">&lt;&gt;</option>
                                                                                                <option value="<">&lt;</option>
                                                                                                <option value="<=">&lt;=</option>
                                                                                                <option value=">">&gt;</option>
                                                                                                <option value=">=">&gt;=</option>
                                                                                                <option>START WITH</option>
                                                                                                <option>END WITH</option>
                                                                                                <option>CONTAINS</option>
                                                                                                <option>NOT CONTAINS</option>
                                                                                                <option>IS</option>
                                                                                                <option>IS NOT</option>
                                                                                                <option>IN</option>
                                                                                            </select>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div class="form-group">
                                                                                            <select data-bind="value: oper" data-bind="visible: type() != 'left'">
                                                                                                <option>AND</option>
                                                                                                <option>OR</option>
                                                                                            </select>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <a href="javascript:void(0)" style="" data-bind="click: function() { $root.moveUp($parent.listOfConditions, $index()); }" title="Move Up"><i class="fa fa-caret-up"></i></a>
                                                                                        <a href="javascript:void(0)" style="" data-bind="click: function() { $root.moveDown($parent.listOfConditions, $index()); }" title="Move Down"><i class="fa fa-caret-down"></i></a>
                                                                                    </td>
                                                                                    <td>
                                                                                        <a href="javascript:void(0);" data-bind="click: function() { removePropertyCondition($parent, $data); }" title="Remove Condition">
                                                                                            <i class="fa fa-trash"></i>
                                                                                        </a>
                                                                                    </td>
                                                                                </tr>
                                                                            <!-- /ko -->
                                                                        </tbody>
                                                                    </cf_grid_list>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        <!-- /ko -->
                                    </tbody>
                                </cf_grid_list>
                            </div>
                            <div class="mt-3" data-bind="visible: template() !== 'Default'">
                                <cf_grid_list>
                                    <thead>
                                        <tr>
                                            <th colspan = "9">SUMMARIES</th>
                                        </tr>
                                        <tr>
                                            <th width="20"><i class="fa fa-plus" title="Add Element" data-bind="click: function() { addSummary($data); }" title="Add Summary"></i></th>
                                            <th width="100">Label</th>
                                            <th width="100">Lang No</th>
                                            <th width="100">Type</th>
                                            <th width="100">Field</th>
                                            <th width="100">Group By</th>
                                            <th width="20"><i class="fa fa-codepen" title="Development Settings"></i></th>
                                            <th width="40">
                                                <i class="fa fa-caret-up" title="Move Up"></i>
                                                <i class="fa fa-caret-down" title="Move Down"></i>
                                            </th>
                                            <th width="20"><i class="fa fa-trash" title="Remove Element"></i></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- ko foreach: listOfSummaries -->
                                        <tr>
                                            <td class="text-center" data-bind="text: ($index() + 1)"></td>
                                            <td>
                                                <div class="form-group"><input type="text" data-bind="value: label"></div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <input type="text" data-bind="value: langNo">
                                                        <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = langNo; windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;module_name=dev&amp;is_use_send&amp;lang_dictionary_id=updFuseactionForm.dictionary_id&amp;lang_item_name=updFuseactionForm.head&invoke=1','list')}"></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <select data-bind="value: type">
                                                        <option>SUM</option>
                                                    </select>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <select data-bind="value: field, options: $root.summaryFieldList($parent)"></select>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-group">
                                                    <select data-bind="value: groupby, options: $root.summaryFieldList($parent)"></select>
                                                </div>
                                            </td>
                                            <td>
                                                <a href="javascript:void(0);" style="" title="Development Settings" onclick="$(this).parent().next().toggle(100);$(this).children().toggleClass('color-maroon')"><i class="fa fa-codepen"></i></a>
                                            </td>
                                            <td>
                                                <a href="#" style="" data-bind="click: function() { $root.moveUp($parent.listOfSummaries, $index()); }" title="Move Up"><i class="fa fa-caret-up"></i></a>
                                                <a href="#" style="" data-bind="click: function() { $root.moveDown($parent.listOfSummaries, $index()); }" title="Move Down"><i class="fa fa-caret-down"></i></a>
                                            </td>
                                            <td>
                                                <a href="javascript:void(0);" style="font-size: 18px;" data-bind="click: function(data, event) { removeSummary($parent, $data, event); }" title="Remove Summary"><i class="fa fa-trash"></i></a>
                                            </td>
                                        </tr>
                                        <tr style="display: none;">
                                            <td colspan = "9" style="padding:0 0;">
                                                <div class="dev-table">
                                                    <div class="tbody colorrow">
                                                        <div class="dev-form flipInX devSettings">
                                                            <div class="row">
                                                                <div class="col col-12">
                                                                    <h2 class="mb-3 col">Development Settings</h2>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col col-3">
                                                                    <div class="form-group">
                                                                        <label class="form-label col col-12"><i class="fa fa-database"></i> DB Field</label>
                                                                        <div class="col col-12">
                                                                            <div class="input-group">
                                                                                <input type="text" data-bind="value: DBField().value">
                                                                                <span class="input-group-addon icon-ellipsis btnPointer" data-bind="click: function() { $root.activeItem = $data.DBField; window.setFieldValue({value: ''}); window.getFieldValue('dbs'); }"></span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-group">
                                                                        <label class="form-label col col-12"><i class="fa fa-sitemap"></i> Data Type</label>
                                                                        <div class="col col-12">
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
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- /ko -->
                                    </tbody>
                                </cf_grid_list>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="json" data-bind="visible: viewMode() == 'json'">
                <div id="jsoneditor" style="width: 100%; height: 600px;"></div>
            </div>
            <div id="code" data-bind="visible: viewMode() == 'code'">
                <div id="codeeditor" style="width: 100%; height: 600px; box-shadow: 0px 3px 10px #ccc;"></div>
            </div>
        </cf_tab>  
        <cf_workcube_buttons insert_info="Save" add_function="app.save('save')">
        <cf_workcube_buttons insert_info="Save & Generate" add_function="app.save('generate')">
    </cf_box>
</div>