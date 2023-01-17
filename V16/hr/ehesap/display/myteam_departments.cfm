<!---
File: myteam_departments.cfm
Author: Workcube - Esma Uysal <esmauysal@workcube.com>
Date: 02.09.2020
Description: Ekimdeki çalışan sayısı, departmanda çalışan sayısı, İzinliiler, Seyahattakiler, Eğitimdekiler'in sayılarını gösterir
---->
<cfset myObj = createObject("component","V16.myhome.cfc.my_team") />
<cfset offtimes_cmp = createObject("component","V16.myhome.cfc.offtimes") />

<!--- Benim departmanımdaki çalışan sayıları --->
<cfset MyDepartmentTeam = myObj.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = valuelist(MyDepartmentTeam.employee_id)>
<cfset mydepartments = listRemoveDuplicates(valuelist(MyDepartmentTeam.DEPARTMENT_ID))>
<!--- Departmanlarım --->
<cfset MyTeamDepartment = myObj.get_team(session.ep.position_code) />
<!--- 1. ve 2. amiri olduklarım --->
<cfset MyTeam = myObj.get_positions_upper(position_code : session.ep.position_code, department_id : mydepartments) />
<!--- Bugün izinlililer ---->
<cfset MyTeamOfftimes = myObj.get_offtimes(department_id : mydepartments) />
<!--- Bugün Eğitime Katılanlar ---->
<cfset MyTeamTraining = myObj.get_training(employee_ids : employee_ids) />
<!--- Şuan online ---->
<cfset OnlineUser = myObj.get_online_user(employee_ids : employee_ids) />
<!---- Bugün Seyahattekiler --->
<cfset get_demands = createObject("component","V16.myhome.cfc.get_travel_demands")>
<cfset  get_travel_demand = myObj.travel_demands
                        (
                            department_id : mydepartments,
							startdate : now(),
							finishdate :  now()
                        )>
<!--- QOQ --->
<cfquery name="first_upper" dbtype="query">
    SELECT EMPLOYEE_ID FROM MyTeam WHERE UPPER_POSITION_CODE = <cfqueryparam value = "#session.ep.position_code#" CFSQLType = "cf_sql_integer"> AND POSITION_STATUS = 1
</cfquery>
 <cfquery name="second_upper" dbtype="query">
    SELECT EMPLOYEE_ID FROM MyTeam WHERE UPPER_POSITION_CODE2 = <cfqueryparam value = "#session.ep.position_code#" CFSQLType = "cf_sql_integer"> AND POSITION_STATUS = 1
</cfquery>
<cfoutput>
     <div>
        <cfloop query="MyTeamDepartment">
            #MyTeamDepartment.department_head#<cfif MyTeamDepartment.recordcount neq CurrentRow>, </cfif>
        </cfloop>
        <br>
    </div>
    <div class="ui-dashboard ui-dashboard_type3">
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                #getLang('myhome','',61177,'Ekibim')#
            </div>
            <div class="ui-dashboard-item-text ui-dashboard-item-text_type2">
                <a href="javascript://" title="#getLang('','1.Ekip',65061)#">#first_upper.recordcount#</a>
                <a href="javascript://" title="#getLang('','2.Ekip',65067)#">#second_upper.recordcount#</a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                #getLang('','Aktif Çalışanlar',53226)#
            </div>
            <div class="ui-dashboard-item-text">
                <a href="javascript://" onclick="gotoEmploye('#valuelist(MyDepartmentTeam.EMPLOYEE_ID)#')">
                    #MyDepartmentTeam.recordcount#
                    <i>#OnlineUser.recordcount#</i>
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                #getLang('','İzindekiler',65064)#
            </div>
            <div class="ui-dashboard-item-text">
                <a href="javascript://" onclick="gotoEmploye('#valuelist(MyTeamOfftimes.EMPLOYEE_ID)#')">
                    #MyTeamOfftimes.recordcount#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                #getLang('','Seyahattekiler',65065)#
               
            </div>
            <div class="ui-dashboard-item-text">
                <a href="javascript://" onclick="gotoEmploye('#valuelist(get_travel_demand.EMPLOYEE_ID)#')">
                     #get_travel_demand.recordcount#
                </a>
            </div>
        </div>
        <div class="ui-dashboard-item">
            <div class="ui-dashboard-item-title">
                #getLang('','Eğitimdekiler',65066)#
            </div>
            <div class="ui-dashboard-item-text">
                <a href="javascript://" onclick="gotoEmploye('#valuelist(MyTeamTraining.EMP_ID)#')">
                    #MyTeamTraining.recordcount#
                </a>
            </div>
        </div>
    </div>
</cfoutput>

<script>

    function gotoEmploye( employee_id ) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&form_submitted=1&employee_id='+ employee_id+'','Project');
    }

</script>