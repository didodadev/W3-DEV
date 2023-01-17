<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<script type="text/javascript">
	function add_pos(id,code,pos_name)
		{
			<cfif isdefined("attributes.field_pos_name")>
				opener.<cfoutput>#field_pos_name#</cfoutput>.value = pos_name;
			</cfif>
			<cfif isdefined("attributes.field_code")>
				opener.<cfoutput>#field_code#</cfoutput>.value = code;
			</cfif>
			window.close();
		}
</script>
<cffunction name="get_emp_admin_name">
	<cfargument name="emp_id">
	<cfquery datasource="#DSN#" name="get_emp_nm">
		SELECT
			*
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_ID=#emp_id#
	</cfquery>
	<cfreturn #get_emp_nm.EMPLOYEE_NAME# & " " & #get_emp_nm.EMPLOYEE_SURNAME# >
</cffunction>

<cffunction name="get_names_of_dep">
  <cfargument name="hier">
  <cfset str_dep="">
  <cfloop from="1" to="#ListLen(hier,".")#"  index="i">
		  <cfquery name="get_dep_all" datasource="#DSN#">
			SELECT 
				*
			FROM
				DEPARTMENT
			WHERE
				DEPARTMENT_ID=#ListGetAt(hier,i,".")#
		  </cfquery>
		  <cfset str_dep=str_dep& "/#get_dep_all.DEPARTMENT_HEAD#">
  </cfloop>	
  <cfreturn #str_dep#>
</cffunction>

<cfinclude template="../query/get_positions.cfm">
<cfset url_string = "">

<cfif get_positions.recordcount>
    <cfsavecontent variable="txt">
    <cfset attributes.COMP_ID=get_positions.COMPANY_ID>
            <cfif LEN(attributes.COMP_ID)>		  
                <cfinclude template="../query/get_our_comp_name.cfm">
                <cfoutput> #get_company_name.NICK_NAME# </cfoutput>
            </cfif>
    </cfsavecontent>
    <cf_medium_list_search title="#txt#">
        <cf_medium_list_search_area>
            <cfform action="#request.self#?fuseaction=hr.popup_list_department_position" method="post" name="search">
            <table>
                <tr>
                <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                <cfinclude template="../query/get_departments.cfm">
                <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
                <td><cf_wrk_search_button></td>
                </tr>
            </table> 
            </cfform>
        </cf_medium_list_search_area>
    </cf_medium_list_search>
    <cf_medium_list>
        <thead>
            <tr>
                <th colspan="4"><cfoutput>#get_positions.ZONE_NAME# / #get_positions.BRANCH_NAME#  #get_names_of_dep(get_positions.HIERARCHY_DEP_ID)#</cfoutput></th>
            </tr>
            <tr>
                <th colspan="4"><cf_get_lang dictionary_id='29511.Yönetici'> 1: <cfif len(get_positions.ADMIN1_POSITION_CODE)><cfoutput>#get_emp_admin_name(get_positions.ADMIN1_POSITION_CODE)#</cfoutput></cfif></th>
            </tr>
            <tr>
                <th colspan="4"><cf_get_lang dictionary_id='29511.Yönetici'> 2: <cfif len(get_positions.ADMIN2_POSITION_CODE)><cfoutput>#get_emp_admin_name(get_positions.ADMIN2_POSITION_CODE)#</cfoutput></cfif></th>
            </tr>
            <tr>
                <th width="20"></th>
                <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                <th width="20"></th>
            </tr>
        </thead>
        <tbody>
            <cfparam name="attributes.page" default=1>
            <cfparam name="attributes.totalrecords" default=#get_positions.recordcount#>
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td align="center"> <CF_ONLINE id="#employee_id#" zone="ep"> </td>
                    <td> 
                    <cfif IsDefined("attributes.field_pos_name") AND IsDefined("attributes.field_code")>
                        <a href="##" class="tableyazi"  onClick="add_pos('#position_id#','#position_code#','#position_name#')"> #POSITION_NAME# </a> 
                    <cfelse>
                        #POSITION_NAME#
                    </cfif>
                    </td>               
                    <td>
                    <cfif not isdefined("url.trans")>
                        <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&DEPARTMENT_ID=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&POS_ID=#POSITION_CODE##url_string#','medium')">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
                    <cfelse>
                        #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
                    </cfif>
                    </td>
                    <td align="center"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_position_history&position_id=#get_positions.position_id#','large');"><img src="/images/report_square2.gif" border="0"></a></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_medium_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
    <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
      <tr>
        <td> <cf_pages page="#attributes.page#"
                  maxrows="#attributes.maxrows#"
                  totalrecords="#attributes.totalrecords#"
                  startrow="#attributes.startrow#"
                  adres="hr.popup_list_department_position#url_string#"> </td>
        <!-- sil --><td  style="text-align:right;"> <cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
      </tr>
    </table>
    </cfif>
<cfelse>
  <cfquery name="GET_ZONE" datasource="#dsn#">
	  SELECT
		  *
	  FROM
		  DEPARTMENT,
		  BRANCH,
		  ZONE
	  WHERE 
		  DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	  AND 
		  BRANCH.ZONE_ID=ZONE.ZONE_ID 
	  AND 
		  DEPARTMENT.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
  </cfquery>
    <cfsavecontent variable="txt">		
  		<cfset attributes.COMP_ID=GET_ZONE.COMPANY_ID>	  
		<cfif LEN(attributes.COMP_ID)>
			<cfinclude template="../query/get_our_comp_name.cfm">
			<cfoutput><cf_get_lang_main no='162.şirket'> : #get_company_name.NICK_NAME# </cfoutput>	  
		</cfif>
    </cfsavecontent>
  <cf_medium_list_search title="#txt#"></cf_medium_list_search>
  <cf_medium_list>
  	<thead>
    	<tr>
        	<th colspan="4"><cfoutput>#GET_ZONE.ZONE_NAME# / #GET_ZONE.BRANCH_NAME#  #get_names_of_dep(GET_ZONE.HIERARCHY_DEP_ID)#  <!--- / #GET_ZONE.DEPARTMENT_HEAD# ---></cfoutput></th>
        </tr>
        <tr>
        	<th colspan="4"><cf_get_lang dictionary_id='29511.Yönetici'> 1: <cfif LEN(get_positions.ADMIN1_POSITION_CODE)><cfoutput>#get_emp_admin_name(get_positions.ADMIN1_POSITION_CODE)#</cfoutput></cfif></th>
        </tr>
        <tr>
        	<th colspan="4"><cf_get_lang dictionary_id='29511.Yönetici'> 2: <cfif LEN(get_positions.ADMIN2_POSITION_CODE)><cfoutput>#get_emp_admin_name(get_positions.ADMIN2_POSITION_CODE)#</cfoutput></cfif></th>
        </tr>
        <tr>
            <th width="20"></th>
            <th width="120"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="20"></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
    </tbody>
  </cf_medium_list>
</cfif>
