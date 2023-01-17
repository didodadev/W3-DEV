<div class="pageMainLayout">
    <div id="appMapper">
        <div class="row m-b-2">
            <div class="col col-6">
                <div class="dev-block">
                    <div class="title">Source</div>
                    <div class="row">
                        <div class="col col-2 form-group">
                            <label>Fuse Action</label>
                        </div>
                        <div class="col col-4 form-group">
                            <div class="input-group">
                            <input type="text" data-bind="value: self.sourceFuseaction">
                            <span class="input-group-addon">
                                <a href="javascript:void(0)" data-bind="click: function() { self.getStructList(self.sourceFuseaction(), 'source'); }"><i class="fa fa-search"></i></a>
                            </span>
                            </div>
                        </div>
                        <div class="col col-2 form-group">
                            <label>Structs</label>
                        </div>
                        <div class="col col-4 form-group">
                            <div class="input-group">
                                <select data-bind="options: self.sourceStructs, value: self.sourceStruct"></select>
                                <span class="input-group-addon">
                                    <a href="javascript:void(0)" data-bind="click: function() { self.getStruct(self.sourceFuseaction(), self.sourceStruct(), 'source') }"><i class="fa fa-refresh"></i></a>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6">
                <div class="dev-block">
                    <div class="title">Target</div>
                    <div class="row">
                        <div class="col col-2 form-group">
                            <label>Fuse Action</label>
                        </div>
                        <div class="col col-4 form-group">
                            <div class="input-group">
                            <input type="text" data-bind="value: self.targetFuseaction">
                            <span class="input-group-addon">
                                <a href="javascript:void(0)" data-bind="click: function() { self.getStructList(self.targetFuseaction(), 'target'); }"><i class="fa fa-search"></i></a>
                            </span>
                            </div>
                        </div>
                        <div class="col col-2 form-group">
                            <label>Structs</label>
                        </div>
                        <div class="col col-4 form-group">
                            <div class="input-group">
                                <select data-bind="options: self.targetStructs, value: self.targetStruct"></select>
                                <span class="input-group-addon">
                                    <a href="javascript:void(0)" data-bind="click: function() { self.getStruct(self.targetFuseaction(), self.targetStruct(), 'target') }"><i class="fa fa-refresh"></i></a>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col col-9">
                <div class="dev-block">
                    <div class="title">Mappings</div>
                    <div class="row">
                        <div class="col col-12 text-right">
                            <i class="fa fa-plus" data-bind="click: function() { self.addMap(); }"></i>
                        </div>
                    </div>
                    <div class="dev-form">
                        <!-- ko foreach: mappingModel -->
                        <div class="maps m-b-2">
                            <div class="row m-b-2">
                                <div class="col col-12 text-right">
                                    <h6 style="float: left;">CONVERT</h6>
                                    <i class="fa fa-caret-up" data-bind="click: function() { self.mapUpOne($data); }"></i>&nbsp;&nbsp;&nbsp;
                                    <i class="fa fa-caret-down" data-bind="click: function() { self.mapDownOne($data); }"></i>&nbsp;&nbsp;&nbsp;
                                    <i class="fa fa-close" data-bind="click: function() { self.mapRemove($data); }"></i>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col col-4">
                                    <div class="form-group">
                                        <label>Conditions:</label>
                                    </div>
                                </div>
                                <div class="col col-8">
                                    <div class="dev-table">
                                        <div class="thead">
                                            <div class="cell" style="width: 20%">
                                                Type
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                Left
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                Equality
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                Right
                                            </div>
                                            <div class="cell" style="width: 10%">
                                                And/Or
                                            </div>
                                            <div class="cell text-right" style="width: 10%">
                                                <i class="fa fa-plus" data-bind="click: function() { self.addCondition($data) }"></i>
                                            </div>
                                        </div>
                                        <!-- ko foreach: conditions -->
                                        <div class="tbody">
                                            <div class="cell" style="width: 20%">
                                                <div class="form-group">
                                                    <select data-bind="value: type">
                                                        <option value="exp">Expression</option>
                                                        <option value="leftgrp">(</option>
                                                        <option value="rightgrp">)</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                <div class="form-group">
                                                    <select data-bind="visible: type() == 'exp', value: left, options: self.sourceList, optionsText: 'label', optionsValue: 'label'">
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                <div class="form-group">
                                                    <select data-bind="visible: type() == 'exp'">
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
                                            </div>
                                            <div class="cell" style="width: 20%">
                                                <div class="form-group">
                                                    <select data-bind="visible: type() == 'exp', value: right, options: self.sourceList, optionsText: 'label', optionsValue: 'label'">
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="cell" style="width: 10%">
                                                <div class="form-group">
                                                    <select data-bind="value: join">
                                                        <option value="and">And</option>
                                                        <option value="or">Or</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="cell text-right" style="width: 10%">
                                                <div class="form-group">
                                                    <i class="fa fa-minus" data-bind="click: function() { self.removeCondition($parent, $data); }"></i>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /ko -->
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col col-4">
                                    <div class="form-group">
                                    <label>Converter:</label>
                                    </div>
                                </div>
                                <div class="col col-8">
                                    <div class="input-group" style="max-width: 100%;">
                                    <input type="text" data-bind="value: name" style="max-width: 100%;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="getFieldValue('exp')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col col-4">
                                    <div class="form-group">
                                    <label>Output Field Label:</label>
                                    </div>
                                </div>
                                <div class="col col-8">
                                    <div class="form-group">
                                        <input type="text" class="form-control" data-bind="value: label">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /ko -->
                    </div>
                </div>
            </div>
            <div class="col col-3">
                <div class="dev-block">
                    <div class="title">Target Assign</div>
                    <ul id="targetmodel" class="dev-list" data-bind="foreach: targetModel">
                        <li><select data-bind="options: mappedList, optionsText: 'label', optionsValue: 'label'" style="max-width: 200px;"></select> <span style="float: right" data-bind="text: label"></span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>