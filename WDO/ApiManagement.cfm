<cfset getObj = CreateObject("component","cfc.system")>
<cfset getDataCfc = getObj.GET_CONTROLLERNAME(WoFuseaction : attributes.fuseact, userFriendly : attributes.userfriendly)>

<cfset CrObj = createObject("component","#getDataCfc.DATA_CFC#")>
<cfset Data = getMetadata(CrObj)>
<cf_box id="wo_search_area" title="Api Management" closable="0" collapsable="0">
    <div class="ui-info-text">
        <ul>
            <cfoutput>
                <li><b>Name : </b>#data.FULLNAME#</li>
                <li><b>Path : </b>#data.PATH#</li>
                <li><b>Functions Count : </b>#arrayLen(data.functions)#</li>
                <li><b>Type : </b>#data.TYPE#</li>
            </cfoutput>
        </ul>
    </div>
    <cfloop from="1" to="#arrayLen(data.functions)#" index="item">     
        <cf_seperator id="functions#item#" title="[ Name : #data.functions[item]["NAME"]# ] - [ Parameters Count : #arrayLen(data.functions[item]["PARAMETERS"])# ] - [ Returntype : #(data.functions[item]["RETURNTYPE"])?:''# ] - [ Hint : #(data.functions[item]["HINT"])?:''# ]">
            <div id="functions<cfoutput>#item#</cfoutput>">   
                <cf_grid_list >   
                    <thead>
                        <tr>
                            <th width="200" style="text-align:center;">Parameter Name</th>
                            <th width="200" style="text-align:center;">Required</th>
                            <th width="200" style="text-align:center;">Default</th>
                            <th width="200" style="text-align:center;" colspan="2">Hint</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput>
                            <cfif arrayLen(data.functions[item]["PARAMETERS"]) gt 0>
                                <tbody>
                                    <cfloop array="#data.functions[item]["PARAMETERS"]#" item="currentItem" index="currentIndex">
                                        <tr>
                                            <td width="50">#currentItem.name#</td>
                                            <td width="50">#(currentItem.Required)?:''#</td>
                                            <td></td>
                                            <td width="50" colspan="2">#(currentItem.hint)?:''#</td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </cfif>
                        </cfoutput>
                </cf_grid_list> 
                <div class="ui-info-bottom">
                    <p><a href="javascript://" onclick="GoToWex('<cfoutput>#data.functions[item]["NAME"]#</cfoutput>','<cfoutput>#data.FULLNAME#</cfoutput>')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="wrk-uF0041 fa-1x"></i> WEX - API <cf_get_lang dictionary_id='58966.Oluştur'></a></p>
                </div>
            </div>
        </cfloop>
</cf_box>

<script>
    function GoToWex(restName, filePath) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=dev.wex&event=add&restName='+restName+'&filePath='+filePath, '_blank');
    }
</script>