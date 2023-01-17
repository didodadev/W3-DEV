<!---
File: myteam_departments.cfm
Author: Workcube - Esma Uysal <esmauysal@workcube.com>
Date: 02.09.2020
Controller: -
Description: Ekimdeki çalışan sayısı, departmanda çalışan sayısı, İzinliiler, Seyahattakiler, Eğitimdekiler'in sayılarını gösterir
---->

<cffunction name="get_positions" access="public" returntype="void" output="true">
  <cfargument name="position_code" default="">
  <cfquery name="LOCAL.Children"  datasource="#dsn#">
    SELECT
      *,
      CASE 
          WHEN EMPLOYEES.PHOTO IS NOT NULL AND LEN(EMPLOYEES.PHOTO) > 0 
              THEN '/documents/hr/'+EMPLOYEES.PHOTO 
          WHEN EMPLOYEES.PHOTO IS NULL AND EMPLOYEES_DETAIL.SEX = 0
              THEN  '/images/female.jpg'
      ELSE '/images/male.jpg' END AS PHOTOS
    FROM
      EMPLOYEE_POSITIONS
      INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
      INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
    WHERE
      EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
      AND
      (
        EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
        OR
        EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = <cfqueryparam value = "#arguments.position_code#" CFSQLType = "cf_sql_integer">
      )
      AND EMPLOYEES.EMPLOYEE_STATUS = 1
      AND POSITION_STATUS = 1
    ORDER BY
      EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
      EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
  </cfquery>
  <cfif LOCAL.Children.RecordCount>
    <ul>
      <cfloop query="LOCAL.Children">
        <li>
          <img src="#PHOTOS#" width="30" height="30" class="usersListLeft img-circle btnPointer"  onclick="cfmodal('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#LOCAL.Children.employee_id#','warning_modal');">
          #LOCAL.Children.EMPLOYEE_NAME# #LOCAL.Children.EMPLOYEE_SURNAME#
          <cfset get_positions(
            position_code = LOCAL.Children.position_code
            ) /> 
        </li>
      </cfloop>
    </ul>
  </cfif>
  <cfreturn>
</cffunction>
<!--- Gelen Pozisyon Id'nin altındaki pozisyon listesidir. Esma R. Uysal ---->
<ul class="position">
  <cfset MyTeam = get_positions(position_code : session.ep.position_code) />
</ul>