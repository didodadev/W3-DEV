<cfinclude template="model.cfm">
<cfset attributes.modeldata = loadModel( attributes.fuseact )>

<script type="text/javascript" src="/JS/bootstrap.min.js"></script>
<script type="text/javascript" src="JS/assets/lib/interactjs/interact.min.js"></script>
<link rel="stylesheet" href="/css/assets/template/workdev/printd.min.css" />
<style>
    .left-block{position:relative;}
</style>
<cf_box title="Output/Layout">
<div id="printLayout">
    <div class="left-block">
        <div class="tab-container">
            <div class="tab-header-container clearfix">
                <div class="tab-header" data-bind="style: { backgroundColor: self.tabManager.visibleTab( self.tabManager.tabs.template ) ? '#ebebeb' : 'transparent' }, click: function() { self.tabManager.activateTab(self.tabManager.tabs.template); }">
                    <i class="fa fa-asterisk"></i>
                </div>
                <div class="tab-header" data-bind="style: { backgroundColor: self.tabManager.visibleTab( self.tabManager.tabs.pages ) ? '#ebebeb' : 'transparent' }, click: function() { self.tabManager.activateTab(self.tabManager.tabs.pages); }">
                    <i class="fa fa-copy"></i>
                </div>
                <div class="tab-header" data-bind="style: { backgroundColor: self.tabManager.visibleTab( self.tabManager.tabs.system ) ? '#ebebeb' : 'transparent' }, click: function() { self.tabManager.activateTab(self.tabManager.tabs.system); }">
                    <i class="fa fa-cubes"></i>
                </div>
                <div class="tab-header" data-bind="style: { backgroundColor: self.tabManager.visibleTab( self.tabManager.tabs.model ) ? '#ebebeb' : 'transparent' }, click: function() { self.tabManager.activateTab(self.tabManager.tabs.model); }">
                    <i class="fa fa-database"></i>
                </div>
            </div>
            <div class="tab-content-container">
                <div class="tab-content" data-bind="visible: self.tabManager.visibleTab( self.tabManager.tabs.template )">
                    <div class="row">
                        <div class="col col-12">
                            <label class="form-label col col-12">Template Name</label>
                            <div class="col col-12">
                                <input class="form-control" data-bind="value: settings.templateName">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col col-6">
                            <label class="form-label col col-12">Size</label>
                            <div class="col col-12">
                                <select class="form-control" data-bind="value: settings.size, options: lists.sizes"></select>
                            </div>
                        </div>
                        <div class="col col-6">
                            <label class="form-label col col-12">Measure</label>
                            <div class="col col-12">
                                <select class="form-control" data-bind="value: settings.measure, options: lists.measures, optionsText: 'text', optionsValue: 'id'"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col col-6">
                            <label class="form-label col col-12">Width</label>
                            <div class="col col-12">
                                <input type="text" class="form-control" data-bind="value: settings.width">
                            </div>
                        </div>
                        <div class="col col-6">
                            <label class="form-label col col-12">Height</label>
                            <div class="col col-12">
                                <input type="text" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <h6 class="form-label col col-12">Event Type</h6>
                        <div class="col col-12">
                            <label class="form-label col col-12"><input type="radio"> Update - Detail</label>
                            <label class="form-label col col-12"><input type="radio"> List</label>
                            <label class="form-label col col-12"><input type="radio"> Dashboard</label>                            
                        </div>
                    </div>
                    <div class="row">
                        <h6 class="form-label col col-12">Size Of</h6>
                        <div class="col col-12">
                            <div class="row">
                                <div class="col col-12">
                                    <label class="form-label col col-6">Top Margin</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-6">Bottom Margin</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-6">Left Margin</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-6">Right Margin</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-6">Header Height</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-6">Footer Height</label>
                                    <div class="col col-6">
                                        <input type="text" class="form-control">
                                    </div>
                                </div>
                                <div class="col col-12">
                                    <label class="form-label col col-12">Notes</label>
                                    <div class="col col-12">
                                        <textarea class="form-control" rows="4" style="height: auto;"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-content" data-bind="visible: self.tabManager.visibleTab( self.tabManager.tabs.pages )">
                    <div class="row">
                        <div class="col col-12">
                            <label class="col col-12 form-label">Add Pages</label>
                            <div class="col col-12">
                                <select class="form-control"></select>
                            </div>
                            <div class="col col-12 mt-sm">
                                <input type="text" class="form-control">
                            </div>
                            <div class="col col-12 mt-sm pull-right">
                                <button type="button" class="small-button"><i class="fa fa-plus"></i> Append</button>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="row">
                        <div class="col col-12">
                            <ul class="page-list">
                                <li></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<cfinclude template="appengine.cfm">
</cf_box>