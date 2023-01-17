<cfinclude template="../query/get_insurance_ratios.cfm">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='53049.Sigorta Primin Oranları'></th>
            <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.personal_payment&event=addRatio','add_ratio_box','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='53057.Sigorta Prim Oranı Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_insurance_ratios">
            <tr>
                <td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
                <td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.personal_payment&event=updRatio&ins_rat_id=#ins_rat_id#','upd_ratio_box','ui-draggable-box-medium');"title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>