<!---
    File: V16/hr/display/hr_dashboard.cfm
    Author: Workcube-Botan Kaygan <botankaygan@workcube.com>
    Date: 06.07.2020
    Controller: WBO/HRDashboardController.cfm
    Description: İK Dashboard sayfası
--->
<!--- HEADER --->
<cf_catalystHeader>
<!--- LEFT --->
<div class="col col-6 col-xs-12">
    <cfsavecontent variable="group_by_branch"><cf_get_lang dictionary_id="29434.Şubeler"></cfsavecontent>
    <cf_box id="box_group_by_branch" closable="0" collapsable="1" title="#group_by_branch#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_group_by_branches">
    </cf_box>

    <cfsavecontent variable="salary_group_by_positions"><cf_get_lang dictionary_id="61038.Pozisyon Tiplerine göre Maaşlar"></cfsavecontent>
    <cf_box id="box_salary_group_by_positions" closable="0" collapsable="1" title="#salary_group_by_positions#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_salary_group_by_positions">
    </cf_box>

    <cfsavecontent variable="list_payments"><cf_get_lang dictionary_id="53399.Ek Ödenekler"></cfsavecontent>
    <cf_box id="box_list_payments" closable="0" collapsable="1" title="#list_payments#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_list_payments">
    </cf_box>
</div>

<!--- RIGHT --->
<div class="col col-6 col-xs-12">
    <cfsavecontent variable="salary_group_by_branch"><cf_get_lang dictionary_id="61037.Şubelere göre Ücret Ödenek ve Kesinti"></cfsavecontent>
    <cf_box id="box_salary_group_by_branch" closable="0" collapsable="1" title="#salary_group_by_branch#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_salary_group_by_branches">
    </cf_box>

    <cfsavecontent variable="list_use_offtime"><cf_get_lang dictionary_id="61039.Kategorilere göre İzin Kullanımları"></cfsavecontent>
    <cf_box id="box_list_use_offtime" closable="0" collapsable="1" title="#list_use_offtime#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_list_use_offtime">
    </cf_box>

    <cfsavecontent variable="list_ext_worktime"><cf_get_lang dictionary_id="52970.Fazla Mesailer"></cfsavecontent>
    <cf_box id="box_list_ext_worktime" closable="0" collapsable="1" title="#list_ext_worktime#" uidrop="1" box_page="#request.self#?fuseaction=hr.emptypopup_dashboard_list_ext_worktime">
    </cf_box>
</div>