<cfset url_str = ''>
<!---<cfif isdefined("attributes.maxrows") and len(attributes.maxrows)>
   <cfset url_str = "#url_str#&maxrows=#attributes.maxrows#">
</cfif>--->
<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
  <cfquery name="get_type" datasource="#dsn#">
		SELECT #dsn#.Get_Dynamic_Language(REQ_TYPE_ID,'#session.ep.language#','POSITION_REQ_TYPE','REQ_TYPE',NULL,NULL,REQ_TYPE) AS REQ_TYPE FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID IN (#attributes.type_id#)
	</cfquery>
  <cfset counter = 1>
  <cfset emp_list = "">
  <cfif isdefined("attributes.coefficient") and len(attributes.coefficient)>
    <cfset co_list = "">
	<cfloop list="#attributes.type_id#" index="i">
	 <cfif counter lte listlen(attributes.coefficient)> 
	  <cfset co_deger = listgetat(attributes.coefficient,counter)>
	  <cfquery name="get_emp_id" datasource="#dsn#">
	    SELECT 
		  EMPLOYEE_ID 
		FROM 
		  EMPLOYEE_REQUIREMENTS 
		WHERE 
		  REQ_TYPE_ID = #i# 
		   AND
		  COEFFICIENT >= #co_deger#
	  </cfquery>
	  <cfoutput query="get_emp_id">
		<cfif NOT LISTCONTAINSNOCASE(emp_list,#EMPLOYEE_ID#)>
		 <cfset emp_list = listappend(emp_list,EMPLOYEE_ID)>
		</cfif> 
	  </cfoutput>
	    <cfset counter = counter + 1>
	 </cfif>
	</cfloop>
  </cfif>
</cfif>
<cfif isdefined("emp_list") and len(emp_list)>
	<cfquery name="get_emp" datasource="#dsn#">
		SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN  (#emp_list#)
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("emp_list") and len(emp_list)>
  <cfparam name="attributes.totalrecords" default=#get_emp.recordcount#>
<cfelse>
  <cfparam name="attributes.totalrecords" default=0> 
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cfform name="search" action="#request.self#?fuseaction=hr.fit_employees" method="post">
    <cf_box title="#getLang('','Uygun Çalışanlar','55251')#" nofooter="1" uidrop="1" hide_table_column="1" closable="0">
      <cf_box_elements>
        <cf_grid_list>
          <cfset counter = 1>
          <cfif GET_TYPE.RECORDCOUNT>
            <thead>
              <th colspan="3"><cf_get_lang dictionary_id='55471.Yeterlilikler'>: 
              <cfoutput query="GET_TYPE">
                  <cfset coefficient = listgetat(attributes.coefficient,counter)>
                      #req_type# <cfif isdefined("coefficient")>(#coefficient#)</cfif>,
                  <cfset counter = counter + 1>
              </cfoutput>
              <cfset coefficient = 0>
              </th>
          </cfif>
              <tr> 
                <th><cf_get_lang dictionary_id='57570.Adı Soyadı'></th>
                <th><cf_get_lang dictionary_id='57572.Departman'></th>
                <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
              </tr>
            </thead>
          <tbody>
          <cfif isdefined("emp_list") and len(emp_list)>
              <cfif  get_emp.recordcount>
                  <cfoutput query="get_emp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr>
                      <cfset attributes.EMPLOYEE_ID = "#EMPLOYEE_ID#">
                      <cfinclude template="../query/get_position.cfm">
                      <td>
                          <a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi"> #employee_name# #employee_surname#</a>
                      </td>
                      <td><cfif get_position.recordcount>#GET_POSITION.department_head#<cfelse>-</cfif></td>
                      <td><cfif get_position.recordcount>#get_position.position_name#<cfelse>-</cfif></td>
                  </tr>
                  </cfoutput> 
              <cfelse>
                  <tr>
                      <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                  </tr>
              </cfif>
              <!---</cfloop>--->
              <cfelse>
                  <tr>
                      <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                  </tr>
              </cfif>
          </tbody>
        </cf_grid_list>
      </cf_box_elements>
    </cf_box>
  </cfform>
</div>
<cfif isdefined("attributes.type_id") and len(attributes.type_id)>
	<cfset url_str = "#url_str#&type_id=#attributes.type_id#">
</cfif>
<cfif isdefined("attributes.coefficient") and len(attributes.coefficient)>
	<cfset url_str = "#url_str#&coefficient=#attributes.coefficient#">
</cfif>
<cf_paging page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="hr.fit_employees#url_str#">
    
