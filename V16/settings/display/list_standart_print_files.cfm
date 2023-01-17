<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.bp_code" default="">
<cfparam name="attributes.related_sectors" default="">
<cfparam name="attributes.related_wo" default="">
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.active" default="">
<cfparam name="attributes.field_id" default="">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.field_detail" default="">
<cfparam name="attributes.field_process_type" default="">
<cfparam name="attributes.standart" default="">

<cfset getComponent = createObject('component','WDO.development.cfc.output_template')>
<cfset get_output_templates = getComponent.get_output_templates(keyword : attributes.keyword,
                                                                bp_code : attributes.bp_code,
                                                                related_sectors : attributes.related_sectors,
                                                                related_wo : attributes.related_wo,
                                                                licence : attributes.licence,
                                                                active : attributes.active)> 
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfset adres="settings.popup_standart_print_files"> 
<cfparam name="attributes.totalrecords" default="#get_output_templates.recordcount#">
<cfparam name="attributes.is_submitted" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Standart Şablonlar',44563)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="list_output_templates" id="list_output_templates" action="#request.self#?fuseaction=#adres#" method="post">
            <cf_box_search more="0" id="search_div">
                <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                <cfoutput>
                    <input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#" />
                    <input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#" />
                    <input type="hidden" name="field_detail" id="field_detail" value="#attributes.field_detail#" />
                    <input type="hidden" name="field_process_type" id="field_process_type" value="#attributes.field_process_type#" />
                    <input type="hidden" name="standart" id="standart" value="#attributes.standart#" />
                </cfoutput>
                
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getlang('main','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="bp_code" id="bp_code" maxlength="50" value="#attributes.bp_code#" placeholder="WBP">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="related_sectors" id="related_sectors" value="#attributes.related_sectors#" placeholder="Sectors">
                </div>
                <div class="form-group">
                    <cfinput type="text" name="related_wo" id="related_wo" value="#attributes.related_wo#" placeholder="Related WO">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı!',57537)#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_output_templates' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>
                <th>#</th>
                <th><cf_get_lang dictionary_id='61332.Name'></th>
                <th><cf_get_lang dictionary_id='61646.Wbp'></th>
                <th><cf_get_lang dictionary_id='42197.Lisans'></th>
                <th width="20" class="text-center"><a href="javascript://"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='61999.WO Dashboard'>" alt="<cf_get_lang dictionary_id='61999.WO Dashboard'>"></i></a></th>                
                <th width="20" class="text-center"><a href="javascript://"><i class="fa fa-file-image-o" title="<cf_get_lang dictionary_id ='44564.Ön İzleme'>" alt="<cf_get_lang dictionary_id ='44564.Ön İzleme'>"></i></a></th>
                <th><cf_get_lang dictionary_id='52783.Author'></th>
            </thead>
            <tbody>
                <cfif get_output_templates.recordcount neq 0>
                <cfoutput query="get_output_templates" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >               
                    <tr>
                        <cfset get_print_cats=cfc.GetPrintCats(print_type:print_type)>
                        <td width="20">#currentrow#</td>
                        <td><a href="javascript://" class="tableyazi" onClick="gonder('#OUTPUT_TEMPLATE_PATH#','#PRINT_TYPE#','#get_print_cats.PRINT_MODULE_ID#');">#WRK_OUTPUT_TEMPLATE_NAME#</a></td>
                        <td>#BEST_PRACTISE_CODE#</td>
                        <td><cfif licence_type eq 1><cf_get_lang dictionary_id='33137.Standart'><cfelse><cf_get_lang dictionary_id='60146.Add-On'></cfif></td>
                        <td class="text-center">
                            <a href="javascript://"  onclick="cfmodal('V16/process/display/list_processfuseactions.cfm?id=#WRK_OUTPUT_TEMPLATE_ID#&output_template=1','warning_modal');"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='61999.WO Dashboard'>" alt="<cf_get_lang dictionary_id='61999.WO Dashboard'>"></i></a>
                        </td>
                        <td class="text-center"><a href="javascript://" onClick="windowopen('#OUTPUT_TEMPLATE_VIEW_PATH#','page');"><i class="fa fa-file-image-o" title="<cf_get_lang dictionary_id ='44564.Ön İzleme'>" alt="<cf_get_lang dictionary_id ='44564.Ön İzleme'>"></i></a></td>
                        <td>#AUTHOR_NAME#</td>
                    </tr>                
                </cfoutput>
                <cfelse>
                    <tr>
                        <tr>
                            <td colspan="7">
                                <cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>
                            </td>
                        </tr>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>    
            
            <cfif len(attributes.is_submitted)> 
                <cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.bp_code)>
                <cfset adres = "#adres#&bp_code=#attributes.bp_code#">
            </cfif>
            <cfif len(attributes.active)>
                <cfset adres = "#adres#&active=#attributes.active#">
            </cfif>
            <cfif len(attributes.licence)>
                <cfset adres = "#adres#&licence=#attributes.licence#">
            </cfif>
            <cfif len(attributes.related_sectors)>
                <cfset adres = "#adres#&related_sectors=#attributes.related_sectors#">
            </cfif>
            <cfif len(attributes.related_wo)>
                <cfset adres = "#adres#&related_wo=#attributes.related_wo#">
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	function gonder(id1,id2,id3)
	{
        <cfif len(attributes.field_id)>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.style.display='none';
        </cfif>
        <cfif len(attributes.field_name)>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.style.display='';
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=id1;
        </cfif>
        <cfif len(attributes.field_detail)>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_detail#</cfoutput>.value=id1;
        </cfif>
        <cfif len(attributes.field_process_type)>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_process_type#</cfoutput>.value=id2+"-"+id3;
        </cfif>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.getElementById("value1").style.display='none';
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.getElementById("value2").style.display='';
        <cfif not isdefined("attributes.draggable")>
            window.close();
        <cfelse>
            closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        </cfif>
        <cfif len(attributes.standart)>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.standart#</cfoutput>.value=1;
        </cfif>
	}
</script> 
