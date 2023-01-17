<cfparam name="attributes.op" default="list">
<cfobject name="infocomponent" component="V16.objects.query.info_autocomplete">
<cfswitch expression="#attributes.op#">

    <cfcase value="detail">
        <cfscript>
            data = infocomponent.getDetail(expandPath("./workdata/") & attributes.path);
            infocontent = infocomponent.getContent(expandPath("./workdata/") & attributes.path);
        </cfscript>
        <div class="row">
            <div class="col col-12">
                <ul class="nav nav-tabs" id="mainTab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link" id="tabitemCustom" data-toggle="tab" href="#tabCustom" role="tab" aria-controls="tabCustom" aria-selected="false">Custom Code</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" id="tabitemParam" data-toggle="tab" href="#tabParam" role="tab" aria-controls="tabParam" aria-selected="true">Arguments</a>
                    </li>
                </ul>
            </div>
            <div class="tab-content" id="tabSelector">
                <div class="tab-pane show" id="tabParam">
                    <div class="row">
                        <div class="col col-12" id="paramList">
                            <cfloop from="1" to="#arrayLen(data.params)#" index="i">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cfoutput>#data.params[i]#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>#getEditor(name=data.params[i])#</cfoutput>
                                </div>
                            </div>
                            </cfloop>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12">Find Fields</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="findfield">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12">Visible Fields</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="visible_field">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12">Data Field</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="datafield">
                                </div>
                            </div>
                        </div>
                        <div class="col col-12 text-right">
                            <button type="button" class="btn btn-primary" onclick="buildFromParams()">Aktar</button>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="tabCustom">
                    <div class="form-group custom-form-field">
                        <input type="text" id="paramCustom">
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">Find Fields</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="findfield">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">Visible Fields</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="visible_field">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12">Data Field</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="datafield">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col col-12 text-right">
                            <a href="javascript:void(0)" class="btn btn-primary" onclick="buildFromCustom()">Aktar</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col col-12">
                <cfoutput>#getComponentContent(content=infocontent)#</cfoutput>
            </div>
        </div>
        <style rel="stylesheet">
            ul.nav-tabs {
                list-style: none;
                margin: 0;
                clear: both;
            }
            ul.nav-tabs li {
                display: block;
                border: 1px solid #999;
                float: right;
                margin-left: 6px;
            }
            ul.nav-tabs li a {
                padding: 10px;
                background-color: #dedede;
                display: block;
            }
            ul.nav-tabs li a.active {
                background-color: #fff;
            }
            .tab-content {
                clear: both;
            }
            .tab-content .tab-pane {
                display: none;
            }
            .tab-content .tab-pane.show {
                display: block;
            }
            .custom-form-field {
                margin: 10px auto;
            }
            .tab-pane ul li {
                display: block;
                padding: 6px;
            }
            .tab-pane ul li a {
                color: blue;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function() {
                $("#mainTab[role='tablist'] .nav-link").click(function() {
                    $("#mainTab[role='tablist'] .nav-link.active").removeClass("active");
                    $(this).addClass("active");
                    $("#tabSelector .tab-pane.show").removeClass("show");
                    var activeTabId = $(this).attr("href");
                    $(activeTabId).addClass("show");
                })
            });
            function buildFromParams() {
                var fields = $("#paramList input[data-variable]");
                var prefix = '';
                var postfix = '';
                var body = "";
                for (i=0;i<fields.length;i++)
                {
                    body += $(fields[i]).prop("name") + '=' + $(fields[i]).val() + ',';
                }
                body = body.substr(0, body.length - 1);
                findfieldVal = $('#paramList input[name="findfield"]').val();
                visible_fieldVal = $('#paramList input[name="visible_field"]').val();
                datafieldVal = $('#paramList input[name="datafield"]').val();
                setValue(prefix + body + postfix, findfieldVal, visible_fieldVal, datafieldVal);
            }
            function buildFromCustom() {
                var customFieldVal = $("#paramCustom").val();
                var prefix = '';
                var postfix = '';
                var body = customFieldVal;
                findfieldVal = $('#paramCustom input[name="findfield"]').val();
                visible_fieldVal = $('#paramCustom input[name="visible_field"]').val();
                datafieldVal = $('#paramCustom input[name="datafield"]').val();
                setValue(prefix + body + postfix, findfieldVal, visible_fieldVal, datafieldVal);               
            }
            function setValue(val, findfield, visible_field, datafield) {
                window.opener.setFieldValue({ type: "autocomplete", name: "autocomplete_<cfoutput>#listgetat(attributes.path, 1, '.')#</cfoutput>", path: "<cfoutput>#attributes.path#</cfoutput>", formula: val, value: "AutoComplete=><cfoutput>#listgetat(attributes.path, 1, '.')#</cfoutput>:" + val, findfield: findfield, visible_field: visible_field, datafield: datafield });
                window.close();
            }
        </script>
    </cfcase>

    <!--- default list page --->
    <cfdefaultcase>
        <cfscript>
            dirlist = infocomponent.getList("workdata");
            elementList = infocomponent.getNames(dirlist);
        </cfscript>
        <cf_grid_list>
            <thead>
                <tr>
                    <th>Component</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <cfloop from="1" to="#arrayLen(elementList)#" index="i">
                <tr>
                    <td><a href="javascript:void(0)" onclick="setDetailPage('<cfoutput>#elementList[i]#</cfoutput>')"><cfoutput>#elementList[i]#</cfoutput></a></td>
                    <td></td>
                </tr>
                </cfloop>
            </tbody>
        </cf_grid_list>
        <script type="text/javascript">
            function setDetailPage(link) {
                ajaxPage('Autocomplete&op=detail&path=' + link, 'Autocomplete');
            }
        </script>
    </cfdefaultcase>
</cfswitch>
<cffunction name="getEditor">
    <cfparam name="name" type="string" default="editor">
    <cfparam name="editorType" type="string" default="text">
    <cfswitch expression="#editorType#">
        <cfdefaultcase>
            <input type="text" name="<cfoutput>#name#</cfoutput>" data-variable>
        </cfdefaultcase>
    </cfswitch>
</cffunction>
<cffunction name="getComponentContent">
    <cfparam name="content" type="string" default="">
        <div class="component-content">
            <h4>Dosya &Iota;&ccedil;erigi</h4>
            <pre><cfoutput>#encodeForHTML(content)#</cfoutput></pre>
        </div>
        <style rel="stylesheet">
            .component-content {
                margin-top: 10px;
                border-top: 1px dotted #666;
            }
            .component-content h4 {
                text-align: center;
                padding: 10px;
                margin-bottom: 15px;
                border-bottom: 2px solid #ddd;
            }
            .component-content pre {
                overflow: scroll;
                height: 400px;
            }
        </style>
</cffunction>