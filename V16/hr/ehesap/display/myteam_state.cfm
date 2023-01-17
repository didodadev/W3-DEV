<!---
File: myteam_state.cfm
Author: Workcube - Esma Uysal <esmauysal@workcube.com>
Date: 13.10.2020
Description: Ekimdeki çalışan sayısı, departmanda çalışan sayısı, İzinliiler, Seyahattakiler, Eğitimdekiler'in sayılarını gösterir
---->

<cfset myObj = createObject("component","V16.myhome.cfc.my_team") />
<cfset offtimes_cmp = createObject("component","V16.myhome.cfc.offtimes") />

<!--- Benim departmanımdaki çalışan sayıları --->
<cfset MyDepartmentTeam = myObj.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = valuelist(MyDepartmentTeam.employee_id)>
<cfset mydepartments = listRemoveDuplicates(valuelist(MyDepartmentTeam.DEPARTMENT_ID))>
<!---- Bugün Seyahattekiler --->
<cfset  get_travel_demand = myObj.travel_demands
                        (
                            department_id : mydepartments,
							startdate : now(),
							finishdate :  now()
                        )>
<!--- Bugün izinlililer ---->
<cfset MyTeamOfftimes = myObj.get_offtimes(department_id : mydepartments) />
<!--- Bugün Eğitime Katılanlar ---->
<cfset MyTeamTraining = myObj.get_training(employee_ids : employee_ids) />

<div class="ui-dashboard ui-dashboard_type3">
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='59973.Seyahat'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <ul class="ui-list_type2">
                <cfoutput query="get_travel_demand">
                    <li>
                        <div class="ui-list-img">
                            <img src="#PHOTO#">
                        </div>
                        <div class="ui-list-text">
                            <span class="name">#EMPNAME_SURNAME#</span>
                            <span class="title">#DateFormat(DEPARTURE_DATE, dateformat_style)# - #DateFormat(DEPARTURE_OF_DATE, dateformat_style)#</span>
                        </div>
                    </li>
                </cfoutput>
            </ul>
        </div>
    </div>
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='58575.izin'>
        </div>
        <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
            <ul class="ui-list_type2">
                <cfoutput query="MyTeamOfftimes">
                    <li>
                        <div class="ui-list-img">
                            <img src="#PHOTOS#">
                        </div>
                        <div class="ui-list-text">
                            <span class="name">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</span>
                            <span class="title">#DateFormat(startdate, dateformat_style)# - #DateFormat(finishdate, dateformat_style)#</span>
                        </div>
                    </li>
                </cfoutput>
            </ul>
        </div>
    </div>
    <div class="ui-dashboard-item">
        <div class="ui-dashboard-item-title">
            <cf_get_lang dictionary_id='57419.Eğitim'>
        </div>
        <div class="ui-dashboard-item-text">
            <ul class="ui-list_type2">
                <cfoutput query="MyTeamTraining">
                    <li>
                        <div class="ui-list-img">
                            <img src="#PHOTOS#">
                        </div>
                        <div class="ui-list-text">
                            <span class="name">#get_emp_info(EMP_ID,0,0)#</span>
                            <span class="title">#DateFormat(start_date, dateformat_style)# - #DateFormat(finish_date, dateformat_style)#</span>
                        </div>
                    </li>
                </cfoutput>
            </ul>
        </div>
    </div>
</div>