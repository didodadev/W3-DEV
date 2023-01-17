<cfparam name="attributes.op" default="list">
<cfobject name="infocomponent" component="V16.objects.query.info_customtags"> 
<cfswitch expression="#attributes.op#">
    <!--- detail page --->
    <cfcase value="detail">
        <cfset data=infocomponent.getDetail(attributes.path)>
        <cfset infocontent=infocomponent.getContent(attributes.path)>
        <div class="row">
            <div class="col col-12">
                <ul class="nav nav-tabs" id="mainTab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link" id="tabitemCustom" data-toggle="tab" href="#tabCustom" role="tab" aria-controls="tabCustom" aria-selected="false">Custom Code</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" id="tabitemParam" data-toggle="tab" href="#tabParam" role="tab" aria-controls="tabParam" aria-selected="true">Parameters</a>
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
                    <div class="row">
                        <div class="col col-12">
                            <h5>List of available attributes</h5>
                            <ul>
                                <cfloop from="1" to="#arrayLen(data.attrs)#" index="i">
                                <li><a href="javascript:void(0)" onclick="addAttrib('<cfoutput>#data.attrs[i]#</cfoutput>')"><cfoutput>#data.attrs[i]#</cfoutput></a></li>
                                </cfloop>
                            </ul>
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
            function addAttrib(elm) {
                var paramCustomVal = $("#paramCustom").val();
                if (paramCustomVal.indexOf(elm) < 0) {
                    $("#paramCustom").val(paramCustomVal + (paramCustomVal.length == 0 ? "" : " ") + elm + '=');
                    $("#paramCustom").focus();
                }
            }
            function buildFromParams() {
                var fields = $("#paramList input");
                var prefix = '';
                var postfix = '';
                var body = "";
                var params = {};
                for (i=0;i<fields.length;i++)
                {
                    if( $(fields[i]).val() != '' ){
                        params[$(fields[i]).prop("name")] = $(fields[i]).val();
                        body += $(fields[i]).prop("name") + '=' + '"' + $(fields[i]).val() + '"' + ' ';
                    }
                }
                body = body.substr(0, body.length - 1);
                setValue(prefix + body + postfix, params);
            }
            function buildFromCustom() {
                var customFieldVal = $("#paramCustom").val();
                var prefix = '';
                var postfix = '';
                var body = customFieldVal;
                var params = {};
                if( body != '' ){
                    var splited = body.split(' ');
                    for( var i = 0; i < splited.length; i++ ){
                        if( splited[i].split('=')[1] != '' ) params[splited[i].split('=')[0]] = splited[i].split('=')[1];
                    }
                }
                setValue(prefix + body + postfix, params);                
            }
            function setValue(val, params) {
                window.opener.setFieldValue({ type: "customTag", path: "<cfoutput>#attributes.path#</cfoutput>", tag: "<cfoutput>#listgetat(attributes.path, 1, '.')#</cfoutput>", formula: val, value: "customTag=><c" + "f_<cfoutput>#listgetat(attributes.path, 1, ".")#</cfoutput> " + val + ">", name: "customtag_<cfoutput>#listgetat(attributes.path,1,'.')#</cfoutput>", params: params });
                window.close();
            }
        </script>
    </cfcase>

    <!--- default list page --->
    <cfdefaultcase>
        <cfscript>
            dirlist = infocomponent.getList();
            elementList = infocomponent.getNames(dirlist);
        </cfscript>
        <cf_grid_list>
            <thead>
                <tr>
                    <th>Tag</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <cfloop from="1" to="#arrayLen(elementList)#" index="i">
                <cfset infodescription=infocomponent.getDescription(dirlist[i])>
                <tr>
                    <td><a href="javascript:void(0)" onclick="setDetailPage('<cfoutput>#elementList[i]#</cfoutput>')"><cfoutput>#elementList[i]#</cfoutput></a></td>
                    <td><cfoutput>#EncodeForHtml( infodescription.description)#</cfoutput></td>
                </tr>
                </cfloop>
            </tbody>
        </cf_grid_list>
        
        <script type="text/javascript">
            function setDetailPage(link) {
                ajaxPage('CustomTag&op=detail&path=' + link, 'CustomTag');
            }
            <cfif IsDefined("attributes.defaultValue") and len( attributes.defaultValue )>
                setDetailPage('<cfoutput>#attributes.defaultValue#</cfoutput>');
            </cfif>
        </script>
    </cfdefaultcase>
</cfswitch>
<cffunction name="getEditor">
    <cfparam name="name" type="string" default="editor">
    <cfparam name="editorType" type="string" default="text">
    <cfswitch expression="#editorType#">
        <cfdefaultcase>
            <input type="text" name="<cfoutput>#name#</cfoutput>">
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