<!---12.06.2019/Veritabanında columnlara classsification eklemesi yapılmısştır---->
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset aiclass=createObject("component", "V16.settings.cfc.aiclass" )>
<cfset get_ai_Class=aiclass.GetAiClass()>

<cfif isDefined("attributes.sub") and len(attributes.sub)>

 <cfset add_ai_Class=aiclass.add_ai_class(
        CLASS_NAME: isdefined("attributes.CLASS_NAME") ? attributes.CLASS_NAME : "",
        schema_name: attributes.schema_name,
        table_name: attributes.table_name,
        column_name: attributes.column_name
    )>
</cfif>
<cf_box title="#getLang('','classification',48970)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">    
    <cfform method="post" action="" name="add_ai">
        <cfset schema_name="#listGetAt(url.table, 1,".")#">
        <cfset table_name="#listGetAt(url.table, 2,".")#">
        <cfset column_name="#listGetAt(url.table, 3,".")#">

        <cfset str=mid(schema_name,(len(dsn)+2),4)>
        <cfif str eq 'prod'>
            <cfset schema_change ="#replace(schema_name,schema_name,"prodoct")#">
        <cfelseif len(str) eq 4>
            <cfset schema_change ="#replace(schema_name,schema_name,"Period")#">
        <cfelseif len(str) eq 0 >
            <cfset schema_change ="#replace(schema_name,schema_name,"Main")#">
        <cfelseif len(str) eq 1 >
            <cfset schema_change ="#replace(schema_name,schema_name,"Company")#">
        </cfif>
        <cfsavecontent variable="head"><cf_get_lang dictionary_id='48970'></cfsavecontent>
        <cfset add_ai_selected=aiclass.add_ai_Selected(schema_name:#schema_change#,table_name:#table_name#,column_name:#column_name#)>
        <cf_box_elements title="#head#">
            <input type="hidden" value="1" name="sub">
            <table class="workDevList">
                <tbody>
                    <cfoutput query="get_ai_Class">
                        <tr>    
                            <td>
                                #AI_CLASS#
                            </td>
                            <td>
                                <cfquery dbtype="query" name="varyok">
                                    SELECT COUNT(*) AS CNT FROM add_ai_selected WHERE AI_CLASS_ID=#AI_CLASS_ID#
                                </cfquery>
                                <input type="checkbox" value="#AI_CLASS_ID#" name="class_name" <cfif len(varyok.CNT) and varyok.CNT>checked</cfif>>
                            </td>
                        </tr>
                    </cfoutput>
                
                </tbody>
            </table>    
            <cfoutput>
                <input type="hidden" value="#schema_change#" name="SCHEMA_NAME">
                <input type="hidden" value="#table_name#" name="TABLE_NAME">
                <input type="hidden" value="#column_name#" name="COLUMN_NAME">
            </cfoutput>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons onclick="add_ai" add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_ai' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cfform>   
</cf_box>
<script>
</script>
   
              
    
                
            
