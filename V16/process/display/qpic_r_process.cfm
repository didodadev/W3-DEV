<script type="text/javascript" src="/JS/bootstrap.min.js"></script>
<!--- <link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css"> --->
<link rel="stylesheet" href="/css/assets/template/workdev/qpic.css">
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
<cfset list_action=createObject("component", "V16.process.cfc.list_main_process_qpic" )>
    <cfset list_process=list_action.listToRow()>    

<cfset head_action=createObject("component", "V16.process.cfc.list_main_process_qpic" )>
    <cfset head_process=head_action.listToHead()> 
        <div class="row">
            <div class="col col-12">
                <h4 class="wrkPageHeader">
                    <cfsavecontent variable="head"><cf_get_lang dictionary_id='48909.QPIC-RS'></cfsavecontent>
                    <cfoutput>#head#/#head_process.PROCESS_MAIN_HEADER# </cfoutput>
                </h4>
            </div>
        </div>
      <!---   <div class="row">
            <div class="col col-12">
                <select name="" id="" style="width:100px;">
                    <option value="">All Prosess</option>
                </select>
            </div>
        </div> --->
        <div id="mainDesign">
            <div class="row">
                <div class="wrkPageHeader">
                    <div class="form-group">
                        <div class="col col-12">
                            <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                                <div class="col col-4">
                                    <div class="col col-2 col-md-1 col-sm-1 col-md-1">
                                        <a href="javascript()" data-bind="click: function () { addRow() }"><i class="fa fa-plus"></i></a> 
                                    </div>
                                    <div class="col col-10 col-md-3 col-sm-3 col-md-3">Process</div>
                                </div>
                                <div class="col col-8">
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">Q</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">I</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">C</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">-R</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">Stage</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">Help</div>
                                    <div class="col col-1 col-md-1 col-sm-1 col-md-1">Ideas</div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" data-bind="foreach: tableRows">
                <div class="form-group hoverSelected">
                    <div class="col col-12">
                        <div class="col col-8 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-4 col-md-3 col-sm-3 col-md-3">
                                <div class="col col-2">
                                    <a href="javacript()" data-bind="click: function () {removeRow($data)}"><i class="icon-minus" ></i></a>
                                </div>
                                <div class="col col-1" style="padding-right:4px;">
                                    <a href="javacript()"><i class="catalyst-puzzle"></i></a>
                                </div>
                                <div class="col col-9">
                                    <input type="text" data-bind="value:process , visible:editMode()">
                                    <span data-bind="text:process , visible:!editMode()"></span>
                                </div>
                            </div>
                            <div class="col col-8 col-md-3"> 
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-paper-plane"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-grid"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-bell"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-user"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-shuffle"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-support"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <cfoutput>
                                        <a data-bind="attr:{href:'#request.self#?fuseaction=process.list_process&event=upd&process_id='+processID()}"><i class="catalyst-bulb"></i></a>
                                    </cfoutput>
                                </div>
                                <div class="col col-1 col-md-1 col-sm-1 col-md-1">
                                    <a href="javascript()" data-bind="visible: editMode(),click:function () {saveRow($data)}">
                                        <i class="icon-save"></i></a>
                                    <a href="javascript()" data-bind="visible: !editMode(),click:function () {editMode(true)}">
                                        <i class="fa fa-edit"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                var mainDesign = function () {
                    var self = this;
                    self.createField = function (box) {
                        return { process: ko.observable(box == null || box.process == undefined ? '' : box.process), 
                        processID:ko.observable(box == null || box.processID == undefined ? 0 : box.processID),
                        editMode: ko.observable(box == null || box.editMode == undefined ? true : box.editMode)
                        };
                    }
                    self.tableRows = ko.observableArray([]);                 
                    self.addRow = function () {
                        var row = self.createField(null);
                        self.tableRows.push(row);
                    }
                    self.saveRow = function (row) {
                        var objRow=Object.assign({},JSON.parse(ko.toJSON(row)));
                        objRow.mainID=<cfoutput>#attributes.mainid#</cfoutput>;
                        $.ajax({
                            url: "V16/process/cfc/add_main_process_qpic.cfc?method=saveToRow",
                            type: "POST",
                            data: objRow
                        }).done(function (result) {
                            console.log(result);
                            row.ProcessID(parseInt(result));
                        });
                        row.editMode(false);
                    }
                    self.removeRow = function (row) {
                    if (confirm("Kayıt Silinsin mi? ")) {
                        $.ajax({
                            url: "V16/process/cfc/add_main_process_qpic.cfc?method=deleteToRow",
                            type: "POST",
                            data: JSON.parse(ko.toJSON(row))
                        }).done(function (result) {
                            console.log(result);

                        });
                        self.tableRows.remove(row);
                    }
                }
                    return {
                        init: function () {

                            <cfoutput query="list_process">
                                self.tableRows.push(self.createField(
                    {process: '#DESIGN_TITLE#',processID:'#PROCESS_ID#',editMode:false
                                                    }));
                            </cfoutput>
                            ko.applyBindings(self, document.getElementById('mainDesign'));
                        }
                    }
                
    }();
                $(document).ready(function () {
                    mainDesign.init();
                });

            </script>