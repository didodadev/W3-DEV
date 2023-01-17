<!---
File: draw_organization_hierarchy.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 11.02.2020
Controller: -
Description: Organizasyon Şema Chart
--->
<script src="/JS/GoJS_master/release/go.js"></script>
<link rel="stylesheet" href="/JS/GoJS_master/extensions/dataInspector.css" />
<script src="/JS/GoJS_master/extensions/dataInspector.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/JS/assets/plugins/vue.js"></script>


<cfset components = createObject('component','V16.hr.cfc.organization_chart')>
<cfset getHeadquarters = components.getHeadquarters()><!--- Üst Düzey Birim --->
<cfset getCompanies = components.getCompanies()><!--- Şirket --->
<div class="row" id="">
    <div class="col col-12 uniqueRow">
        <div class="row" type="row">
            <div class="col col-2 col-md-2 col-sm-12 col-xs-12" type="column" index="1" sort="true">
              <cfsavecontent  variable="head"><cf_get_lang dictionary_id="57460.Filtre">
              </cfsavecontent>
                <cf_box title="#head#" id="list_org_search" closable="0" collapsable="1">
                    <cfform name="organization_chart" id="organization_chart" method="post" action="">
                        <div class = "form-group" id="item-type">
                            <label class = "col col-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                            <div class="col col-12"> 
                                <select id = "type" name = "type" onChange="open_div(this.value)">
                                    <option value = "1"><cf_get_lang dictionary_id = "57972.Organizasyon"></option>
                                    <option value = "2"><cf_get_lang dictionary_id = "58497.Pozisyon"></option>
                                </select>
                            </div>
                        </div>
                        <!--- ORGANIZASYON --->
                        <div id="organization">
                            <div class = "form-group" id="item-headquarters_id">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "42984.Üst Düzey Birim"></label>
                                <div class="col col-12"> 
                                    <select id = "headquarters_id" name = "headquarters_id">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                        <cfoutput query="getHeadquarters">
                                            <option value = "#id#">#name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class = "form-group" id="item-company_id">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57574.Şirket"></label>
                                <div class="col col-12"> 
                                    <select id = "company_id" name = "company_id"  onChange="showBranch(this.value)">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                        <cfoutput query="getCompanies">
                                            <option value = "#id#">#name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class = "form-group" id="item-branch_id">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57453.Şube"></label>
                                <div class="col col-12" id="BRANCH_PLACE"> 
                                    <select id = "branch_id" name = "branch_id">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                    </select>
                                </div>
                            </div>
                            <div class = "form-group"  id="item-DEPARTMENT_ID">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57572.Departman"></label>
                                <div class="col col-12" id="DEPARTMENT_PLACE"> 
                                    <select id = "DEPARTMENT_ID" name = "DEPARTMENT_ID">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                    </select>
                                </div>
                            </div>
                            <div class = "form-group"  id="item-management_id">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "51174.Yönetici"></label>
                                <div class="col col-12"> 
                                    <select id = "management_id" name = "management_id">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                        <option value = "1"><cf_get_lang dictionary_id = "51174.Yönetici"> 1</option>
                                        <option value = "2"><cf_get_lang dictionary_id = "51174.Yönetici"> 2</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_date">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "60292.Organizasyon tarihi"></label>
                                <div class="col col-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="58492.Tarihi Kontrol ediniz">!</cfsavecontent>
                                        <cfinput type="text" name="organization_date" value="#dateformat(now(), dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                         <span class="input-group-addon"> <cf_wrk_date_image date_field="organization_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class = "form-group"  id="item-checkbox_div">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "58497.Pozisyon"><input type="checkbox" name="is_position" id="is_position" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "59004.Pozisyon Tipi"><input type="checkbox" name="is_position_type" id="is_position_type" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "55110.Fotoğraf"><input type="checkbox" name="is_photo" id="is_photo" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57571.Ünvan"><input type="checkbox" name="is_title" id="is_title" value="1"></label>
                            </div>
                        </div>
                        <!--- POZISYON ---->
                        <div id="Position" style="display:none">
                            <div class = "form-group" id="item-company_id_" >
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57574.Şirket"></label>
                                <div class="col col-12"> 
                                    <select id = "company_id_" name = "company_id_"  onChange="showBranch(this.value)">
                                        <option value = ""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
                                        <cfoutput query="getCompanies">
                                            <option value = "#id#">#name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class = "form-group" id="item-upper_position">
                                <label class = "col col-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                                <div class="col col-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="upper_position_code" id="upper_position_code" value="">
                                        <input type="text" name="upper_position" id="upper_position"  onFocus="AutoComplete_Create('upper_position','FULLNAME','POSITION_NAME','get_emp_pos','','POSITION_CODE,POSITION_NAME','upper_position_code,upper_position','organization_chart','3','162');" value="" style="width:190px;">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=organization_chart.upper_position_code&position_employee=organization_chart.upper_position&show_empty_pos=1','list','popup_list_positions');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group"  id="item-baglilik">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58427.Bağlılık'></label>
                                <label class="col col-6 col-xs-6">
                                    <input type="radio" name="baglilik" id="baglilik" value="1" checked><cf_get_lang dictionary_id="58428.İdari">
                                </label>    
                                <label class="col col-6 col-xs-6">    
                                    <input type="radio" name="baglilik" id="baglilik" value="2"><cf_get_lang dictionary_id="58429.Fonksiyonel">							
                                </label>    
                            </div>
                            <div class="form-group" id="item-alt_cizim_sayisi">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57671.Basamak"></label>
                                <div class="col col-6 col-xs-6">
                                    <select name="alt_cizim_sayisi" id="alt_cizim_sayisi">
                                        <option value="1"><cf_get_lang dictionary_id="55781.Aşağı"></option>
                                        <cfoutput>
                                            <cfloop from="1" to="10" index = "i">
                                                <option value="#i#">#i#</option>
                                            </cfloop>
                                        </cfoutput>
                                        <option value="9999"><cf_get_lang dictionary_id="56850.Sınırsız"></option>
                                    </select>
                                </div>    
                                <div class="col col-6 col-xs-6" id="item-ust_cizim_sayisi">
                                    <select name="ust_cizim_sayisi" id="ust_cizim_sayisi">
                                        <option value="0"><cf_get_lang dictionary_id="55780.Yukarı"></option>
                                        <cfoutput>
                                            <cfloop from="1" to="10" index = "i">
                                                <option value="#i#">#i#</option>
                                            </cfloop>
                                            <option value="9999"><cf_get_lang dictionary_id="56850.Sınırsız"></option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_date_2">
                                <label class = "col col-12"><cf_get_lang dictionary_id = "60292.Organizasyon tarihi"></label>
                                <div class="col col-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="58492.Tarihi Kontrol ediniz">!</cfsavecontent>
                                        <cfinput type="text" name="organization_date_2" value="#dateformat(now(), dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="organization_date_2"></span>
                                    </div>
                                </div>
                            </div>
                            <div class = "form-group" id="item-check_box" >
                                <label class = "col col-12"><cf_get_lang dictionary_id = "58497.Pozisyon"><input type="checkbox" name="is_position_" id="is_position_" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "59004.Pozisyon Tipi"><input type="checkbox" name="is_position_type_" id="is_position_type_" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "55110.Fotoğraf"><input type="checkbox" name="is_photo_" id="is_photo_" value="1"></label>
                                <label class = "col col-12"><cf_get_lang dictionary_id = "57571.Ünvan"><input type="checkbox" name="is_title_" id="is_title_" value="1"></label>
                            </div>
                        </div>
                    </cfform>
                    <cf_box_footer>
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra">
                            <i class="fa fa-print" title="Yazdır" id="list_print_button"></i>
                        </a>
                        <cfsavecontent variable="cizim_yap"><cf_get_lang dictionary_id='56376.Çizim Yap'></cfsavecontent>
                        <cf_workcube_buttons extraButton="1" extraButtonText="#cizim_yap#" update_status="0" extraFunction = "kontrol()">
                    </cf_box_footer>
                </cf_box>
            </div>
            <div class="col col-10 col-md-8 col-sm-12 col-xs-12">
                <cfsavecontent  variable="org_schema">
                    <cf_get_lang dictionary_id="32211.Organizasyon şeması">
                </cfsavecontent>
                <cf_box title="#org_schema#" scroll="1" call_resize_function="zoom_func()" id="schema_div">
                    <div id="myDiagramDiv" style="background-color: #fff; border: none; height: 570px;"></div>
                    <div class="printThis" style="display:none"></div>
                </cf_box>
            </div>
        </div>
    </div>
</div>
<script id="code">
    function showBranch(comp_id){
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_ajax_list_branch&comp_id="+comp_id;
        AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
    }
    function showDepartment(branch_id)	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
    } 
    function open_div(this_val){
        if(this_val == 1)
        {
            $('#organization').css('display','');
            $('#Position').css('display','none');
        }
        else
        {
            $('#organization').css('display','none');
            $('#Position').css('display','');
        }
    }
    function kontrol(){
        if($('#type').val() == 1)
        {
            type = $('#type').val();
            headquarters_id = $('#headquarters_id').val();
            company_id = $('#company_id').val();
            branch_id = $('#branch_id').val();
            department_id = $('#DEPARTMENT_ID').val();
            management_id = $('#management_id').val();
            organization_date = $('#organization_date').val();
            if(headquarters_id == '' && company_id == '' )
            {
                alert("<cf_get_lang dictionary_id = '60297.	Üst Düzey Birim ya da Şirket Seçimi Yapmalısınız!'>");
                return false;
            }
            if( $('#is_position').is(':checked'))
                is_position = $('#is_position').val();
            else 
                is_position = 0;
            if( $('#is_position_type').is(':checked'))
                is_position_type = $('#is_position_type').val();
            else 
                is_position_type = 0;
            if($('#is_photo').is(':checked'))
                is_photo = $('#is_photo').val();
            else 
                is_photo = 0;
            if($('#is_title').is(':checked'))
                is_title = $('#is_title').val();
            else 
                is_title = 0;   
            parameters = 'V16/hr/display/draw_organization_chart.cfm?type='+type+'&organization_date='+organization_date+'&headquarters_id='+headquarters_id+'&company_id='+company_id+'&branch_id='+branch_id+'&department_id='+department_id+'&management_id='+management_id+'&is_position='+is_position+'&is_position_type='+is_position_type+'&is_photo='+is_photo+'&is_title='+is_title;
            $.ajax({
              url: parameters,
              type: "GET",   
              success: function (returnData) {  
                // $('#draw_div').append(returnData);
                var jsonString = '{"class":"go.TreeModel","nodeDataArray":'+returnData+'}';
                load(jsonString);
              },
              error: function () 
              {
                  console.log('CODE:8 please, try again..');
                  return false; 
              }
          });
        }
        else
        {
            type = $('#type').val();
            company_id_ = $('#company_id_').val();
            upper_position_code = $('#upper_position_code').val();
            upper_position = $('#upper_position').val();
            baglilik = $("#baglilik:checked").val();;
            alt_cizim_sayisi = $('#alt_cizim_sayisi').val();
            ust_cizim_sayisi = $('#ust_cizim_sayisi').val();
            organization_date = $('#organization_date_2').val();
            if(company_id_ == '')
            {
                alert("<cf_get_lang dictionary_id = '54613.Şirket giriniz'>");
                return false;
            }
            if(upper_position == '')
            {
                alert("<cf_get_lang dictionary_id = '56321.Pozisyon giriniz'>");
                return false;
            }
            if( $('#is_position_').is(':checked'))
                is_position = $('#is_position_').val();
            else 
                is_position = 0;
            if( $('#is_position_type_').is(':checked'))
                is_position_type = $('#is_position_type_').val();
            else 
                is_position_type = 0;
            if($('#is_photo_').is(':checked'))
                is_photo = $('#is_photo_').val();
            else 
                is_photo = 0;
            if($('#is_title_').is(':checked'))
                is_title = $('#is_title_').val();
            else 
                is_title = 0;   
           oapp.runChart();
            return false;
        }
       
       //AjaxPageLoad(parameters,'draw_div'); 
    }
    function init() {
      var $ = go.GraphObject.make;  // for conciseness in defining templates

      myDiagram =
        $(go.Diagram, "myDiagramDiv", // must be the ID or reference to div
          {
            maxSelectionCount: 1, // users can select only one part at a time
            validCycle: go.Diagram.CycleDestinationTree, // make sure users can only create trees
            "clickCreatingTool.archetypeNodeData": { // allow double-click in background to create a new node
              name: "(new person)",
              title: "",
              comments: ""
            },
            "clickCreatingTool.insertPart": function(loc) {  // scroll to the new node
              var node = go.ClickCreatingTool.prototype.insertPart.call(this, loc);
              if (node !== null) {
                this.diagram.select(node);
                this.diagram.commandHandler.scrollToPart(node);
                this.diagram.commandHandler.editTextBlock(node.findObject("NAMETB"));
              }
              return node;
            },
            layout:
              $(go.TreeLayout,
                {
                  treeStyle: go.TreeLayout.StyleLastParents,
                  arrangement: go.TreeLayout.ArrangementHorizontal,
                  // properties for most of the tree:
                  angle: 90,
                  layerSpacing: 35,
                  // properties for the "last parents":
                  alternateAngle: 90,
                  alternateLayerSpacing: 35,
                  alternateAlignment: go.TreeLayout.AlignmentBus,
                  alternateNodeSpacing: 20
                }),
            "undoManager.isEnabled": true // enable undo & redo
          });

      // when the document is modified, add a "*" to the title and enable the "Save" button
      myDiagram.addDiagramListener("Modified", function(e) {
        var button = document.getElementById("SaveButton");
        if (button) button.disabled = !myDiagram.isModified;
        var idx = document.title.indexOf("*");
        if (myDiagram.isModified) {
          if (idx < 0) document.title += "*";
        } else {
          if (idx >= 0) document.title = document.title.substr(0, idx);
        }
      });

      // manage boss info manually when a node or link is deleted from the diagram
      myDiagram.addDiagramListener("SelectionDeleting", function(e) {
        var part = e.subject.first(); // e.subject is the myDiagram.selection collection,
        // so we'll get the first since we know we only have one selection
        myDiagram.startTransaction("clear boss");
        if (part instanceof go.Node) {
          var it = part.findTreeChildrenNodes(); // find all child nodes
          while (it.next()) { // now iterate through them and clear out the boss information
            var child = it.value;
            var bossText = child.findObject("boss"); // since the boss TextBlock is named, we can access it by name
            if (bossText === null) return;
            bossText.text = "";
          }
        } else if (part instanceof go.Link) {
          var child = part.toNode;
          var bossText = child.findObject("boss"); // since the boss TextBlock is named, we can access it by name
          if (bossText === null) return;
          bossText.text = "";
        }
        myDiagram.commitTransaction("clear boss");
      });

      var levelColors = ["#AC193D", "#2672EC", "#8C0095", "#5133AB",
        "#008299", "#D24726", "#008A00", "#094AB2"];

      // override TreeLayout.commitNodes to also modify the background brush based on the tree depth level
      myDiagram.layout.commitNodes = function() {
        go.TreeLayout.prototype.commitNodes.call(myDiagram.layout);  // do the standard behavior
        // then go through all of the vertexes and set their corresponding node's Shape.fill
        // to a brush dependent on the TreeVertex.level value
        myDiagram.layout.network.vertexes.each(function(v) {
          if (v.node) {
            var level = v.level % (levelColors.length);
            var color = levelColors[level];
            var shape = v.node.findObject("SHAPE");
            if (shape) shape.stroke = $(go.Brush, "Linear", { 0: color, 1: go.Brush.lightenBy(color, 0), start: go.Spot.Left, end: go.Spot.Right });
          }
        });
      };

      // when a node is double-clicked, add a child to it
      function nodeDoubleClick(e, obj) {
        var clicked = obj.part;
        if (clicked !== null) {
          var thisemp = clicked.data;
          myDiagram.startTransaction("add employee");
          var newemp = {
            name: "(new person)",
            title: "",
            comments: "",
            parent: thisemp.key
          };
          myDiagram.model.addNodeData(newemp);
          myDiagram.commitTransaction("add employee");
        }
      }

      // this is used to determine feedback during drags
      function mayWorkFor(node1, node2) {
        if (!(node1 instanceof go.Node)) return false;  // must be a Node
        if (node1 === node2) return false;  // cannot work for yourself
        if (node2.isInTreeOf(node1)) return false;  // cannot work for someone who works for you
        return true;
      }

      // This function provides a common style for most of the TextBlocks.
      // Some of these values may be overridden in a particular TextBlock.
      function textStyle() {
        return { font: "9pt  Segoe UI,sans-serif", stroke: "#000" };
      }

      // This converter is used by the Picture.
      function findHeadShot(img) {
        if (img == "") return "/images/avatar_default.jpg"; // There are only 16 images on the server
        return img ;
      }

      // define the Node template
      myDiagram.nodeTemplate =
        $(go.Node, "Auto",
          { doubleClick: nodeDoubleClick },
          { // handle dragging a Node onto a Node to (maybe) change the reporting relationship
            mouseDragEnter: function(e, node, prev) {
              var diagram = node.diagram;
              var selnode = diagram.selection.first();
              if (!mayWorkFor(selnode, node)) return;
              var shape = node.findObject("SHAPE");
              if (shape) {
                shape._prevFill = shape.fill;  // remember the original brush
                shape.fill = "darkred";
              }
            },
            mouseDragLeave: function(e, node, next) {
              var shape = node.findObject("SHAPE");
              if (shape && shape._prevFill) {
                shape.fill = shape._prevFill;  // restore the original brush
              }
            },
            mouseDrop: function(e, node) {
              var diagram = node.diagram;
              var selnode = diagram.selection.first();  // assume just one Node in selection
              if (mayWorkFor(selnode, node)) {
                // find any existing link into the selected node
                var link = selnode.findTreeParentLink();
                if (link !== null) {  // reconnect any existing link
                  link.fromNode = node;
                } else {  // else create a new link
                  diagram.toolManager.linkingTool.insertLink(node, node.port, selnode, selnode.port);
                }
              }
            }
          },
          // for sorting, have the Node.text be the data.name
          new go.Binding("text", "name"),
          // bind the Part.layerName to control the Node's layer depending on whether it isSelected
          new go.Binding("layerName", "isSelected", function(sel) { return sel ? "Foreground" : ""; }).ofObject(),
          // define the node's outer shape
          $(go.Shape, "RoundedRectangle",
            {
              name: "SHAPE", fill: "white", stroke: 'white', strokeWidth: 1.75,
              // set the port properties:
              portId: "", fromLinkable: true, toLinkable: true, cursor: "pointer"
            }),
          $(go.Panel, "Horizontal",
            $(go.Picture,
              {
                name: "Picture",
                desiredSize: new go.Size(70, 70),
                margin: 1.5,
              },
              new go.Binding("source", "photo", findHeadShot)),
            // define the panel where the text will appear
            $(go.Panel, "Table",
              {
                minSize: new go.Size(130, NaN),
                maxSize: new go.Size(150, NaN),
                margin: new go.Margin(6, 10, 0, 6),
                defaultAlignment: go.Spot.Left
              },
              $(go.RowColumnDefinition, { column: 2, width: 4 }),
              $(go.TextBlock, textStyle(),  // the name
                {
                  row: 0, column: 0, columnSpan: 5,
                  font: "12pt Segoe UI,sans-serif",
                  editable: true, isMultiline: false,
                  minSize: new go.Size(10, 16)
                },
                new go.Binding("text", "name").makeTwoWay()),
              $(go.TextBlock, textStyle(),
                { name: "manager", row: 1, column: 0, }, // we include a name so we can access this TextBlock when deleting Nodes/Links
                new go.Binding("text", "manager", function(v) { return "Yönetici: " + v; }).makeTwoWay()),
              $(go.TextBlock, textStyle(),
                { row: 2, column: 0 },
                new go.Binding("text", "title", function(v) { return "<cf_get_lang dictionary_id='58497.Pozisyon'>: " + v; }).makeTwoWay()),
              $(go.TextBlock, textStyle(),
                { row: 3, column: 0 },
                new go.Binding("text", "title_id", function(v) { return "<cf_get_lang dictionary_id='57571.ünvan'>: " + v; }).makeTwoWay()),
              $(go.TextBlock, textStyle(),
                { name: "position_cat", row: 4, column: 0, }, // we include a name so we can access this TextBlock when deleting Nodes/Links
                new go.Binding("text", "position_cat", function(v) { return "<cf_get_lang dictionary_id='59004.Poziston tipi'>: " + v; }).makeTwoWay()),
             
              $(go.TextBlock, textStyle(),  // the comments
                {
                  row: 4, column: 0, columnSpan: 5,
                  font: "italic 9pt sans-serif",
                  wrap: go.TextBlock.WrapFit,
                  editable: true,  // by default newlines are allowed
                  minSize: new go.Size(10, 14)
                },
                new go.Binding("text", "comments").makeTwoWay())
            )  // end Table Panel
          ) // end Horizontal Panel
        );  // end Node

      // the context menu allows users to make a position vacant,
      // remove a role and reassign the subtree, or remove a department
      myDiagram.nodeTemplate.contextMenu =
        $("ContextMenu",
          $("ContextMenuButton",
            $(go.TextBlock, "Vacate Position"),
            {
              click: function(e, obj) {
                var node = obj.part.adornedPart;
                if (node !== null) {
                  var thisemp = node.data;
                  myDiagram.startTransaction("vacate");
                  // update the key, name, and comments
                  myDiagram.model.setDataProperty(thisemp, "name", "(Vacant)");
                  myDiagram.model.setDataProperty(thisemp, "comments", "");
                  myDiagram.commitTransaction("vacate");
                }
              }
            }
          ),
          $("ContextMenuButton",
            $(go.TextBlock, "Remove Role"),
            {
              click: function(e, obj) {
                // reparent the subtree to this node's boss, then remove the node
                var node = obj.part.adornedPart;
                if (node !== null) {
                  myDiagram.startTransaction("reparent remove");
                  var chl = node.findTreeChildrenNodes();
                  // iterate through the children and set their parent key to our selected node's parent key
                  while (chl.next()) {
                    var emp = chl.value;
                    myDiagram.model.setParentKeyForNodeData(emp.data, node.findTreeParentNode().data.key);
                  }
                  // and now remove the selected node itself
                  myDiagram.model.removeNodeData(node.data);
                  myDiagram.commitTransaction("reparent remove");
                }
              }
            }
          ),
          $("ContextMenuButton",
            $(go.TextBlock, "Remove Department"),
            {
              click: function(e, obj) {
                // remove the whole subtree, including the node itself
                var node = obj.part.adornedPart;
                if (node !== null) {
                  myDiagram.startTransaction("remove dept");
                  myDiagram.removeParts(node.findTreeParts());
                  myDiagram.commitTransaction("remove dept");
                }
              }
            }
          )
        );

      // define the Link template
      myDiagram.linkTemplate =
        $(go.Link, go.Link.Orthogonal,
          { corner: 5, relinkableFrom: true, relinkableTo: true },
          $(go.Shape, { strokeWidth: 1.5, stroke: "#7e8280" }));  // the link shape


      // support editing the properties of the selected person in HTML
      //Aşağıda açılan formun içerisinde değişiklikleri kaydetmek için kullanılır.
     /*  if (window.Inspector) myInspector = new Inspector("myInspector", myDiagram,
        {
          properties: {
            "key": { readOnly: true },
            "comments": {}
          }
        }); */
      /*document.getElementById('centerRoot').addEventListener('click', function() {
        myDiagram.scale = 1;
        myDiagram.commandHandler.scrollToPart(myDiagram.findNodeForKey(1));
      });*/

    } // end init
  // Setup zoom to fit function
  function zoom_func(){
    myDiagram.commandHandler.zoomToFit();
  }
    // Show the diagram's model in JSON format
    function save() {
      document.getElementById("mySavedModel").value = myDiagram.model.toJson();
      myDiagram.isModified = false;
    }
    function load(jsonString) {
      myDiagram.model = go.Model.fromJson(jsonString);
      // make sure new data keys are unique positive integers
      var lastkey = 1;
      myDiagram.model.makeUniqueKeyFunction = function(model, data) {
        var k = data.key || lastkey;
        while (model.findNodeDataForKey(k)) k++;
        data.key = lastkey = k;
        return k;
      };
    };
    var oapp = new Vue({
		data: {
			app_name: 'Organizasyon Tasarımcısı',
			org_json : [],
      json_data : [{ "class": "go.TreeModel", "nodeDataArray": [] }],
			error 	: []
		},
		methods: {
			lower : function(POSITION_CODE,C){
        if( $('#is_position_').is(':checked'))
           {is_position = $('#is_position_').val();}
        else 
          {is_position = 0;}

        if( $('#is_position_type_').is(':checked'))
          {is_position_type = $('#is_position_type_').val();}
        else 
          { is_position_type = 0;}

        if($('#is_photo_').is(':checked'))
          {is_photo = $('#is_photo_').val();}
        else 
          {is_photo = 0;}

        if($('#is_title_').is(':checked'))
           {is_title = $('#is_title_').val();}
        else 
          {is_title = 0;}

				if(POSITION_CODE){
					axios
						.get('/V16/hr/cfc/organization_chart.cfc', {
							params: {
								method	: 'org_chart_lower', 
								UPPER_POSITION_CODE	: POSITION_CODE,
							  DATE : $('#organization_date_2').val(),
                company_id_ : $('#company_id_').val(),
                baglilik : $("#baglilik:checked").val(),
                is_position : is_position,
                is_position_type : is_position_type,
                is_photo : is_photo,
                is_title : is_title
							}
						})
						.then(response => {	
							for (i=0; i<=response.data.DATA.length;i++)	{								
								if (C <= $('#alt_cizim_sayisi').val()){//attr low kaç kırılımsa / her parent kendi bazında attr kadar iner
									if(response.data.DATA[i].key){	
										oapp.lower(response.data.DATA[i].key,C+1);														
									}
									oapp.org_json.push(response.data.DATA[i]);
								}						
							}
							C = 0;							
						})
						.catch(e => {
							oapp.error.push({code: 1996, message:"Lower Gelmedi value:"+POSITION_CODE+" fn:lower" }) 
						})
				}
			},
			upper : function(UPPER_POSITION_CODE,C){				
			  if( $('#is_position_').is(':checked'))
           {is_position = $('#is_position_').val();}
        else 
          {is_position = 0;}

        if( $('#is_position_type_').is(':checked'))
          {is_position_type = $('#is_position_type_').val();}
        else 
          { is_position_type = 0;}

        if($('#is_photo_').is(':checked'))
          {is_photo = $('#is_photo_').val();}
        else 
          {is_photo = 0;}

        if($('#is_title_').is(':checked'))
           {is_title = $('#is_title_').val();}
        else 
          {is_title = 0;}

				if(UPPER_POSITION_CODE){
					axios
						.get('/V16/hr/cfc/organization_chart.cfc', {
							params: {
								method	: 'org_chart_upper', 
								POSITION_CODE	: UPPER_POSITION_CODE,
                DATE : $('#organization_date_2').val(),
                company_id_ : $('#company_id_').val(),
                upper_position_code : $('#upper_position_code').val(),
                baglilik : $("#baglilik:checked").val(),
                alt_cizim_sayisi : $('#alt_cizim_sayisi').val(),
                is_position : is_position,
                is_position_type : is_position_type,
                is_photo : is_photo,
                is_title : is_title
							}
						})
						.then(response => {								
								for (i=0; i<=response.data.DATA.length;i++){
									if (C <=  $('#ust_cizim_sayisi').val()){//attr up kaç kırılımsa / her parent kendi bazında attr kadar iner
										if(response.data.DATA[i].parent){
											oapp.upper(response.data.DATA[i].parent,C+1);
										}
										oapp.org_json.push(response.data.DATA[i]);
									}
								}
								C = 0;
						})
						.catch(e => {
							oapp.error.push({code: 1995, message:"Upper Gelmedi value:"+UPPER_POSITION_CODE+" fn:upper" }) 
						})
				}
			},
      runChart : function(){

        if( $('#is_position_').is(':checked'))
           {is_position = $('#is_position_').val();}
        else 
          {is_position = 0;}

        if( $('#is_position_type_').is(':checked'))
          {is_position_type = $('#is_position_type_').val();}
        else 
          { is_position_type = 0;}

        if($('#is_photo_').is(':checked'))
          {is_photo = $('#is_photo_').val();}
        else 
          {is_photo = 0;}

        if($('#is_title_').is(':checked'))
           {is_title = $('#is_title_').val();}
        else 
          {is_title = 0;}

        oapp.org_json = [];
        	axios
            .get('/V16/hr/cfc/organization_chart.cfc', {
              params: {
                method	: 'org_chart', 
                POSITION_CODE	: upper_position_code,
                DATE : $('#organization_date_2').val(),
                company_id_ : $('#company_id_').val(),
                upper_position_code : $('#upper_position_code').val(),
                baglilik : $("#baglilik:checked").val(),
                is_position : is_position,
                is_position_type : is_position_type,
                is_photo : is_photo,
                is_title : is_title
              }
            })
            .then(response => {
              oapp.org_json.push(response.data.DATA[0])
              oapp.lower(response.data.DATA[0].key,1);
              oapp.upper(response.data.DATA[0].parent,1);
            })
            .catch(e => {
              oapp.error.push({code: 1994, message:"İlk Kayıt Gelmedi fn:Mounted"}) 
            })	

      }
		},
		mounted () {
				
		},
    watch: {
      org_json: function() {
        oapp.json_data[0].nodeDataArray=oapp.org_json;
        load(JSON.stringify(oapp.json_data[0]));
      }
    }
	});

  $( "#list_print_button" ).click(function() {
    host = location.protocol.concat("//").concat(window.location.host);
    var newWindow = window.open("","print_org_chart");
    var newDocument = newWindow.document;
    var svg = myDiagram.makeSvg({
      document: newDocument,
      scale: 1
    });
    newDocument.body.appendChild(svg);
    var anchors = newDocument.getElementsByTagName("image");
    for (var i = 0; i < anchors.length; i++) {
        var _img = anchors[i].attributes.href.value;
        anchors[i].attributes.href.value = host + _img;
    }

    
    newWindow.print();
  });

</script>
<body onload="init()">
    <div id="sample">
      <div>
        <div id="myInspector">
        </div>
      </div>
    </div>
</body>