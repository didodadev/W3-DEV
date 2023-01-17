<!---
    File: V16\hr\ehesap\display\deductible_contribution_rate.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-09-07
    Description: Kesenek katkı oranları listeleme widget
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.deductible_contribution_rate") />
<cfset get_dcr = get_component.GET_DEDUCTIBLE_CONTRIBUTION_RATE()>
<cf_grid_list>
    <thead>
        <tr>
            <th width="300"><cf_get_lang dictionary_id='62933.Geçerli Tarih'></th>
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=AddDeductibleContributionRate','add_dcr','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='63742.Kesenek Katkı Oranı Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_dcr">
            <tr>
                <td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
                <td>#TITLE#</td>
                <td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=UpdDeductibleContributionRate&dcr_id=#deductible_contribution_rate_id#','upd_ratio_box','ui-draggable-box-large');"title="<cf_get_lang dictionary_id='63746.Kesenek Katkı Oranı Güncelle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>