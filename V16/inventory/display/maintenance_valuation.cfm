<!--- 
    Author : Melek KOCABEY
    Create Date : 10/05/2022
    Desc :  COMPONENT ismi inventory.cfc
            Tamir Bakım Fişlerini ,harcamalarını satırlar bazında girilen fiziki varlıkları getiren list sayfasısır.
            Aynı zamanda Fiziki Varlıkların bağlı olduğu demirbaşlarda listelenir.
---> 
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_valuation" default="">
<cfparam name="attributes.is_form_submitted" default="0">

<cfset components = createObject('component','V16.inventory.cfc.inventory')>
<cfset GetMaintennanceValuation = components.GetMaintennanceValuation(
    is_valuation:attributes.is_valuation,
    branch_id : attributes.branch_id,
    branch : attributes.branch,
    project_id : attributes.project_id,
    project_head : attributes.project_head
)>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GetMaintennanceValuation.recordcount#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="maintenance_valuation" action="#request.self#?fuseaction=invent.maintenance_valuation" method="post">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group" id="item-branch">
                    <div class="input-group">
                        <cfinput type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#" />
                        <cfinput type="text" name="branch" id="branch"  value="#attributes.branch#" placeholder="#getLang('','Şube',57453)#" onFocus="AutoComplete_Create('branch','BRANCH_NAME','BRANCH_NAME','get_branch_name','','BRANCH_ID','branch_id','','','');"/>
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
                <div class="form-group" id="item-is_valuation">
                    <select name="is_valuation" id="is_valuation">
                        <option value="0" <cfif attributes.is_valuation eq 0>selected</cfif>><cf_get_lang dictionary_id='46879.Değer Arttırılmamış'></option>
                        <option value="1" <cfif attributes.is_valuation eq 1>selected</cfif>><cf_get_lang dictionary_id='51553.Değer Arttırılmış'></option>                         
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>                       
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','',32923)#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.no'></th>
                    <th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
                    <th><cf_get_lang dictionary_id='56905.Demirbaş Adı'></th>
                    <th><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th class="text-right"><cf_get_lang dictionary_id="47544.Harcama">-TL</th>
                    <th class="text-right"><cf_get_lang dictionary_id="47544.Harcama">-USD</th>
                    <th width="20"><a href="javascript://"><i class="fa fa-cubes" title=""></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif GetMaintennanceValuation.recordcount and (attributes.is_form_submitted eq 1)>
                    <cfoutput query="GetMaintennanceValuation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#inventory_number#</td>
                            <td>#inventory_name#</td>
                            <td>#assetp#</td>
                            <td><cfif len(project_id)>#get_project_name(project_id)#<cfelse>projesiz</cfif></td>
                            <td>#BRANCH_NAME#</td>
                            <td class="text-right">#TLFORMAT(amount)#</td>
                            <td class="text-right">#TLFORMAT(amount_2)#</td>
                            <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=invent.valuation&event=add&id=#INVENTORY_ID#','medium');"><i <cfif IS_INVENTORY_ASSET_VALUATION eq 1> style="color:green!important;"<cfelse>style="color:red!important;" </cfif> class="fa fa-cubes" title="<cf_get_lang dictionary_id='58166.Stoklar'>"></i></a></td>                
                        </tr>
                    </cfoutput>
                </tbody>
            <cfelse>
                <tr> 
                    <td colspan="9" height="20"><cfif attributes.is_form_submitted eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
        </cf_grid_list>
        <cfset adres = #url.fuseaction#>
        <cfif len(attributes.is_valuation)>
            <cfset adres = '#adres#&is_valuation=#attributes.is_valuation#'>
        </cfif>
        <cfif len(attributes.project_id)>
            <cfset adres = '#adres#&project_id=#attributes.project_id#'>
        </cfif>
        <cfif len(attributes.project_head)>
            <cfset adres = '#adres#&project_head=#attributes.project_head#'>
        </cfif>
        <cfif len(attributes.branch_id)>
            <cfset adres = '#adres#&branch_id=#attributes.branch_id#'>
        </cfif>
        <cfif len(attributes.branch)>
            <cfset adres = '#adres#&branch=#attributes.branch#'>
        </cfif>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#&is_form_submitted=1">
    </cf_box>
</div>