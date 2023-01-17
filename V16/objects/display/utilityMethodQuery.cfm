<cfparam name="attributes.op" default="list">
<cfobject name="infoComponent" component="V16.objects.query.info_component">
<cfswitch expression="#attributes.op#">
    <!--- functions list --->
    <cfcase value="functions">
        <cfscript>
            dirpath = ExpandPath( "./" ) & "\Utility\";
            infodetail = infoComponent.getDetail(dirpath & attributes.path);
            infocontent = infoComponent.getContent(dirpath & attributes.path);
        </cfscript>
        <cfset funcNames=listToArray(structKeyList(infodetail.funcs, ","), ",", false, false)>
        <cf_grid_list>
            <thead>
                <tr>
                    <th>Fonksiyon Ad&iota;</th>
                </tr>
            </thead>
            <tbody>
                <cfloop from="1" to="#arrayLen(funcNames)#" index="i">
                <tr>
                    <td><a href="javascript:void(0);" onclick="setDetailPage('<cfoutput>#attributes.path#</cfoutput>', '<cfoutput>#funcNames[i]#</cfoutput>')"><cfoutput>#funcNames[i]#</cfoutput></a></td>
                </tr>
                </cfloop>
            </tbody>
        </cf_grid_list>
        <cfoutput>#getComponentContent(content=infocontent)#</cfoutput>
        <script type="text/javascript">
            function setDetailPage(link, method) {
                ajaxPage('MethodQuery&op=detail&path=' + link + '&method=' + method, 'MethodQuery');
            }
        </script>
    </cfcase>

    <!--- detail page --->
    <cfcase value="detail">
        <cfscript>
            dirpath = ExpandPath( "./" ) & "\Utility\";
            infodetail = infoComponent.getDetail(dirpath & attributes.path);
            infocontent = infoComponent.getContent(dirpath & attributes.path);
            funcStruct = infodetail.funcs[attributes.method];
        </cfscript>
        <cfset paramNames=listToArray(structKeyList(funcStruct, ","), ",", false, false)>
        <div class="row">
            <div class="col col-12" id="funcParams">
                <cfloop from="1" to="#ArrayLen(paramNames)#" index="i">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cfoutput>#paramNames[i]#<cfif funcStruct[paramNames[i]]['required'] eq "yes"> *</cfif></cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput>#getEditor(name=paramNames[i])#</cfoutput>
                        <small><cfoutput>#funcStruct[paramNames[i]]['hint']#</cfoutput></small>
                    </div>
                </div>
                </cfloop>
            </div>
            <div class="col col-12 text-right">
                <button type="button" class="btn btn-primary" onclick="buildFields()"><cf_get_lang dictionary_id='58676.Aktar'></button>
            </div>
        </div>
        <cfoutput>#getComponentContent(content=infocontent)#</cfoutput>
        <script type="text/javascript">
            function buildFields() {
                var fields = $("#funcParams input");
                var prefix = "<cfoutput>#attributes.method#</cfoutput>(";
                var postfix = ")";
                var body = "";
                for (i=0;i<fields.length;i++) {
                    body += $(fields[i]).prop("name") + '=' + $(fields[i]).val() + ","
                }
                body = body.substr(0, body.length - 1);
                setValue(prefix + body + postfix);
            }
            function setValue(val) {

                window.opener.setFieldValue({ type: "MethodQuery", path: "<cfoutput>#attributes.path#</cfoutput>", formula: val, value: "MethodQuery=><cfoutput>#listgetat(attributes.path, 1, '.')#:</cfoutput>" + val, name: "methodquery_<cfoutput>#listgetat(attributes.path,1,'.')#</cfoutput>" });
                window.close();
            }
            </script>
    </cfcase>

    <!--- default list page --->
    <cfdefaultcase>
        <cfscript>
            dirpath = ExpandPath( "./" ) & "\Utility\";
            dirlist = infoComponent.getList(dirpath);
            elementlist = infoComponent.getNames(dirlist);
        </cfscript>

        <cf_grid_list>
            <thead>
                <tr>
                    <th>Component</th>
                    <th>Last Modified</th>
                    <th>Description</th>
                </th>
            </thead>
            <tbody>
                <cfloop from="1" to="#arrayLen(elementlist)#" index="i">
                <cfset infodescription = infoComponent.getDescription(dirlist[i])>
                <cfif isNull(infodescription.description) eq 0>
                <tr>
                    <td><a href="javascript:void(0);" onclick="setDetailPage('<cfoutput>#elementlist[i]#</cfoutput>')"><cfoutput>#elementlist[i]#</cfoutput></a></td>
                    <td><cfoutput>#infodescription.devdate#</cfoutput></td>
                    <td><cfoutput><span data-toggle="tooltip" title=""><pre>#infodescription.description#</pre></span></cfoutput></td>
                </tr>
                </cfif>
                </cfloop>
            </tbody>
        </cf_grid_list>
        <script type="text/javascript">
            function setDetailPage(link) {
                ajaxPage('MethodQuery&op=functions&path=' + link, 'MethodQuery');
            }
        </script>

    </cfdefaultcase>
</cfswitch>
<cffunction name="getComponentContent">
    <cfparam name="content" type="string" default="">
        <div class="component-content">
            <h4>Dosya &Iota;&ccedil;erigi</h4>
            <pre><cfdump var="#content#"></pre>
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
<cffunction name="getEditor">
    <cfparam name="name" type="string" default="editor">
    <cfparam name="editorType" type="string" default="text">
    <cfswitch expression="#editorType#">
        <cfdefaultcase>
            <input type="text" name="<cfoutput>#name#</cfoutput>">
        </cfdefaultcase>
    </cfswitch>
</cffunction>