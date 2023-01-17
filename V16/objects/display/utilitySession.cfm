<cfscript>
    loadedJsonString = FileRead(ExpandPath( "./" ) & "/WDO/catalogs\session.json");
    loadedJson = deserializeJSON(loadedJsonString);
</cfscript>

<cfset local.session = session.ep />
<cfset response = arrayNew(1) />
<cfset counter = 1 />

<cfloop collection="#local.session#" item="item">
    <cfset data = ArrayFilter( loadedJson, function( dataItem, dataIndex ){ return LCase(item) eq LCase(dataItem.key); } ) />
    <cfset response[counter] = arrayLen(data) ? data[1] : { key: '#item#', title: '', description: '' } />
    
    <cfif isStruct(local.session[item])>
        
        <cfset counterExtraInfo = 1 />
        <cfset response[counter]["extra"] = arrayNew(1) />

        <cfloop collection="#local.session[item]#" item="item_extra">
            <cfset data = ArrayFilter( ArrayFilter( loadedJson, function( dataItem ){ return LCase(item) eq LCase(dataItem.key); } ), function( ourCompInfo ){ return lCase(ourCompInfo.key) eq lCase(item_extra); } ) />
            <cfset response[counter]["extra"][counterExtraInfo] = arrayLen(data) ? data[1] : { key: '#item_extra#', title: '', description: '' } />
            <cfset counterExtraInfo++ />
        </cfloop>

    </cfif>
    <cfset counter++ />
</cfloop>

<cf_grid_list>
    <thead>
        <tr>
            <th>Variable</th>
            <th>Title</th>
            <th>Description</th>
        </th>
    </thead>
    <tbody>
        <cfif arrayLen(response)>
            <cfloop array = "#response#" item = "item"> 
                <tr>
                    <td><cfif not structKeyExists(item, "extra")><a href="javascript:void(0);" onclick="setValue('ep.<cfoutput>#item.key#</cfoutput>','<cfoutput>#len(item.title) ? item.title : item.key#</cfoutput>');"><cfoutput>#item.key#</cfoutput></a><cfelse><cfoutput>#item.key#</cfoutput></cfif></td>
                    <td><span><cfoutput>#item.title#</cfoutput></td>
                    <td><span><cfoutput>#item.description#</cfoutput></td>
                </tr>
                <cfif structKeyExists(item, "extra")>
                    <tr>
                        <td colspan="3">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th>Variable</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                    </th>
                                </thead>
                                <tbody>
                                    <cfloop array = "#item['extra']#" item = "itemExtra">
                                        <tr>
                                            <td><a href="javascript:void(0);" onclick="setValue('ep.<cfoutput>#item.key#</cfoutput>.<cfoutput>#itemExtra.key#</cfoutput>','<cfoutput>#len(itemExtra.title) ? itemExtra.title : item.key & "." & itemExtra.key #</cfoutput>');"><cfoutput>#itemExtra.key#</cfoutput></a></td>
                                            <td><span><cfoutput>#itemExtra.title#</cfoutput></td>
                                            <td><span><cfoutput>#itemExtra.description#</cfoutput></td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </cf_grid_list>
                        </td>
                    </tr> 
                </cfif>
            </cfloop>
        </cfif>
    </tbody>
</cf_grid_list>

<script type="text/javascript">
    function setValue(key, title) {
        window.opener.setFieldValue({ type: "session", formula: key, value: "Session=>" + title, name: "session_" + key });
        window.close();
    }
</script>