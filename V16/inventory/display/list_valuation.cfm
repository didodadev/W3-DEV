<!--- 
    Author : Melek KOCABEY
    Create Date : 14/05/2022
    Desc :  Dosya ismi list_valuation.cfm 
            COMPONENT ismi inventory.cfc
            Sabit Kıymettin yeniden değerleme listesini getirir.
--->
<cfset components = createObject('component','V16.inventory.cfc.inventory')>
<cfset GetValuationInvent = components.ValuationInvent()>

<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_valuation" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GetValuationInvent.recordcount#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="maintenance_valuation" action="#request.self#?fuseaction=invent.valuation" method="post">
            <cf_box_search plus="0">
                <div class="form-group" id="item-invent">
                    <cfinput type="text" name="invent_no" id="invent_no"  value="" placeholder="#getLang('','demirbaş no',58878)#"/>
                </div>
                <div class="form-group" id="item-process">
                    <cf_workcube_process_cat slct_width="140" module_id="26">
                </div>
                <div class="form-group" id="item-branch">
                    <div class="input-group">
                        <cfinput type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#" />
                        <cfinput type="text" name="branch" id="branch"  value="#attributes.branch#" placeholder="#getLang('','Şube',57453)#"/>
                        <span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57453.Şube'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=maintenance_valuation.branch_id&field_branch_name=maintenance_valuation.branch');"></span>
                    </div>
                </div>
                <div class="form-group" id="item-project">
                    <div class="input-group">
                        <cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif>
                        <cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
                        <cfinput type="text" name="project_head" id="project_head" placeholder="#getLang(4,'Proje',57416)#" value="#attributes.project_head#" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=maintenance_valuation.project_id&project_head=maintenance_valuation.project_head');" title="<cfoutput>#getLang(4,'Proje',57416)#</cfoutput>"></span>
                    </div>
				</div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Demirbaş Değer Artışı ve Düşüşü İşlemleri',35929)#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.no'></th>
                    <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th><cf_get_lang dictionary_id='36760.işlem kategorisi'></th>
                    <th><cf_get_lang dictionary_id='40115.Eski Demirbaş'></th>
                    <th class="text-right"><cf_get_lang dictionary_id="33947.Eski Değer">-TL</th>
                    <th><cf_get_lang dictionary_id='29472.Yöntem'></th>
                    <th><cf_get_lang dictionary_id='33992.Yeni Demirbaş'></th>
                    <th class="text-right"><cf_get_lang dictionary_id="56950.Yeni değer">-TL</th>
                    <th class="text-right"><cf_get_lang dictionary_id="56950.Yeni değer">-USD</th>
                    <th width="20"><a href="javascript://"><i class="fa fa-pencil" title=""></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GetValuationInvent" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#DateFormat(valuation_date,dateformat_style)#</td>
                        <td>#paper_no#</td>
                        <td>#process_name#</td>
                        <td>#old_inventory_name#</td>
                        <td class="text-right">#tlformat(old_inventory_money)#</td>
                        <td><cfif valuation_method eq 0>#getLang('','ek',53841)#<cfelse>#getLang('','Yeni',58674)#</cfif></td>
                        <td>#new_inventory_name#</td>
                        <td class="text-right">#TLFORMAT(new_value_money)#</td>
                        <td class="text-right">#TLFORMAT(new_value_other_money)#</td>
                        <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=invent.valuation&event=add&id=#INVENTORY_ID#','medium');"><i class="fa fa-pencil"></i></a></td>                
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>