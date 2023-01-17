<!---
    File: V16\hr\ehesap\form\add_grade_step_params.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-30
    Description: Memur Gösterge Tablosu Listeleme
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.grade_step_params") />
<cfset get_grade_step = get_component.GET_EMPLOYEES_GRADE_STEP_PARAMS() />
<cf_grid_list>
    <thead>
        <tr>
            <th width="300"><cf_get_lang dictionary_id='62933.Geçerli Tarih'></th>
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=AddGradeStepParams','add_ratio_box','ui-draggable-box-large');" title="<cf_get_lang dictionary_id='53057.Sigorta Prim Oranı Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_grade_step" group="START_DATE">
            <tr>
                <td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
                <td>#TITLE#</td>
                <td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=UpdGradeStepParams&start_date=#start_date#&finish_date=#finish_date#','upd_ratio_box','ui-draggable-box-large');"title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>