<!---
File: list_designer.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: VisualDesignerController.cfm
Description: İş akış tasarımcısı listeleme ekranıdır.

Not : Include edilen sayfada action_section ve relative_id set edilmelidir.
Include Örn:
<cfset action_section = "PROJECT">
<cfset relative_id = attributes.project_id>
<cfinclude template="../../process/display/list_designer.cfm"> 
--->
<cfset closable=0>
<cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'process.qpic-r'>
    <cf_get_lang_set_main>
    <cfparam name="caller.lang_array_main" default="">
    <cfset closable=1>
</cfif>
<cfset getComponent = createObject('component','V16.process.cfc.get_design')>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="action_section" default="">
<cfparam name="relative_id" default="">
<cfset record_count_cf = 0>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = url.fuseaction>
<cfset get_list = getComponent.GET_LIST(
    startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
    maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
    keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
    start_date : '#iif(isdefined("attributes.start_date"),"attributes.start_date",DE(""))#',
    finish_date : '#iif(isdefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
    action_section : '#iif(len("action_section"),"action_section",DE(""))#',
    relative_id : '#iif(len("relative_id"),"relative_id",DE(""))#'
)>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="31037.Workflow Designer"></cfsavecontent>
<cfparam name="attributes.totalrecords" default='#get_list.query_count#'>
<cfset address = "">
<cfif len(action_section) and len(relative_id)>
    <cfset address = "&action_section=#action_section#&relative_id=#relative_id#">
</cfif>
<cf_box id="list_worknet_list" closable="#closable#" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=process.designer&event=concept#address#"> 
    <cfif not( len(action_section) and len(relative_id))> <!--- Action section ve relative_id yoksa filtreleme alanı gelmez --->
        <cfform name="release_notes" method="post" action="">
            <div class="ui-form-list flex-list">
                <div class="form-group">
                    <input type="text" name="keyword" id="keyword"  placeholder="Filtre ediniz!"  value="<cfoutput>#attributes.keyword#</cfoutput>">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group" id="form_ul_add">
                    <a class="ui-btn ui-btn-gray"  href="<cfoutput>#request.self#?fuseaction=process.designer&event=concept#address#</cfoutput>" target = "_blank"><i class="fa fa-plus"></i></a>						
                </div>
            </div>
        </cfform>
    </cfif>
    <table class="ajax_list ui-form">
        <div id="Note_list">
            <thead>
                <tr>
                    <th style="width:20px"><cf_get_lang dictionary_id='58577.sıra'></th>
                    <th><cf_get_lang dictionary_id='29800.FILE NAME'></th>
                    <th><cf_get_lang dictionary_id='43121.Kayıt Eden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th style="width:20px"><a href="javascript://"><i class="icon-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></th>
                </tr>
            </thead>
            <cfif get_list.recordcount>
                <cfset record_count_cf = get_list.recordcount>
                <cfoutput query="get_list">
                    <tbody>
                        <tr>
                            <td>#currentRow#</td>
                            <td><a href="#request.self#?fuseaction=process.designer&event=concept&id=#PROCESS_ID#" target = "_blank">#FILE_NAME#</a></td> 
                            <td>#get_emp_info(RECORD_EMP,0,1)#</td>         
                            <td>#dateFormat(record_date,dateformat_style)#</td> 
                            <td>
                                <input type="hidden" name="relative_id#currentrow#" id="relative_id#currentrow#" value="#get_list.relative_id#">
                                <a href="javascript://" onclick="sil_designer(#currentrow#,#process_id#);">
                                <i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                            </td>     
                        </tr>
                    </tbody>
                </cfoutput>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id ="57484.kayıt yok"></td>   
                    </tr>
                </tbody>
            </cfif>
        </div>
    </table>
</cf_box>
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&is_form_submitted=1">
    <script>
        row_count = '<cfoutput>#record_count_cf#</cfoutput>';
        function sil_designer(row_count,id)//Satır silme fonksiyonu
         {
            if(confirm ("<cf_get_lang dictionary_id='36628.Satırı silmek istediğinize emin misiniz?'> ? "))
            {
                if(id != undefined)
                {
                    $.ajax({ 
                        type:'POST',  
                        url:'V16/process/cfc/get_design.cfc?method=DEL_DESIGNER',  
                        data: { 
                            process_id : id
                        },
                        success: function (returnData) {
                            window.location.reload();
                        },
                        error: function () 
                        {
                            console.log('CODE:8 please, try again..');
                            return false; 
                        }
                    }); 
                }
                $( "[id = 'row_"+row_count+"']" ).each(function( index ) {
                    $( this ).remove();
                });
            }else return false;
        }
    </script>