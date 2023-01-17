<!---
	parametre  department_id 
	bu department id sine gore calisanlar listelenecek.
	ve bu listelenen calisanlardin info bilgilerini erisim olabilecek.
	
açan penceredeki istenen alana seçilenleri kaydeder
	field_name : pozisyon adı gelecek
	field_id : pozisyon id si gelecek
	field_code: pozisyon kodu gelecek
	field_emp_id:employee_id
örnek kullaným :
	<a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_department_position&field_code=form_name.field_code&field_name=form_name.text_input_name</cfoutput>','list')"> Gidecekler </a>
--->
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="0">  
<cfquery name="get_dep_info" datasource="#DSN#">
	SELECT 
	DEPARTMENT.*,
	BRANCH.BRANCH_NAME,
	ZONE.ZONE_NAME
	FROM
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
	AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	AND
		BRANCH.ZONE_ID=ZONE.ZONE_ID	
</cfquery>
<cffunction  name="get_names_of_dep">
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

<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		EP.POSITION_NAME,
		EP.EMPLOYEE_ID,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.POSITION_CODE,
		EP.POSITION_ID,
		BRANCH.COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		<cfif isdefined("attributes.is_organization")>EP.IS_ORG_VIEW = 1 AND</cfif>
		EP.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
		BRANCH.ZONE_ID=ZONE.ZONE_ID AND		
		EP.EMPLOYEE_ID > 0 AND
		EP.POSITION_STATUS = 1
	<cfif len(attributes.KEYWORD)>
		AND
		(
			EP.POSITION_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EP.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EP.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
	<cfif attributes.DEPARTMENT_ID IS NOT "all">
		AND EP.DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
	</cfif>
	ORDER BY EP.POSITION_NAME
</cfquery>

<cfset url_string = "">
<cfif isdefined("attributes.is_organization")>
	<cfset url_string = "#url_string#" & "&is_organization=1">
</cfif>
<cfsavecontent variable="head_">
	<cfset attributes.COMP_ID=get_positions.COMPANY_ID>
	<cfif LEN(attributes.COMP_ID)>		  
		<cfinclude template="../query/get_our_comp_name.cfm">
		<cfoutput> #get_company_name.nick_name# </cfoutput>
	</cfif>
</cfsavecontent>
    <cf_box title="#head_#" draggable="1" closable="1" resize="0">
        <cfform action="#request.self#?fuseaction=objects.popup_list_department_position" method="post" name="search">
            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
            <cfinclude template="../query/get_departments.cfm">
            <cfif isdefined("attributes.is_organization")><input type="hidden" name="is_organization" id="is_organization" value="1"></cfif>
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent  variable="variable"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#variable#">
                </div>
                <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Sayı_Hatası_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group"><cf_wrk_search_button button_type="4"></div>
            </cf_box_search>
        </cfform>
        <div class="ui-card">
            <div class="ui-card-item">
                <p><cfoutput>#get_dep_info.zone_name# / #get_dep_info.branch_name#  #get_names_of_dep(get_dep_info.hierarchy_dep_id)#</cfoutput></p>
                <p> <b><cf_get_lang dictionary_id='29511.Yönetici'> : </b>
                    <cfif len(get_dep_info.admin1_position_code)><cfoutput>#get_emp_info(get_dep_info.admin1_position_code,1,0)#</cfoutput></cfif> 
                    <cfif len(get_dep_info.admin2_position_code)><cfoutput>,#get_emp_info(get_dep_info.admin2_position_code,1,0)#</cfoutput></cfif></p>
            </div>
        </div>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="20"></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th colspan="2"><cf_get_lang dictionary_id='57576.çalışan'></th>
                    <th width="20"><a href="javascript://"><i class="icon-detail"></i></a></th>
                </tr>
                </thead>
                <tbody>
                    <cfparam name="attributes.page" default=1>
                    <cfparam name="attributes.totalrecords" default='#get_positions.recordcount#'>
                    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                    <cfif get_positions.recordcount>
                    <cfset employee_list = ''>
                    <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset employee_list = listappend(employee_list,get_positions.employee_id,',')>
                    </cfoutput>
                    <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
                    <cfquery name="get_photos" datasource="#dsn#">
                    SELECT PHOTO,EMPLOYEE_ID,PHOTO_SERVER_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
                    </cfquery>
                    <cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_photos.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    <cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><CF_ONLINE id="#employee_id#" zone="ep"></td>
                            <td> 
                                <cfif IsDefined("attributes.field_pos_name") and IsDefined("attributes.field_code")>
                                    <a href="javascript://" class="tableyazi"  onClick="add_pos('#position_id#','#position_code#','#position_name#')"> #position_name# </a> 
                                <cfelse>
                                    #position_name#
                                </cfif>
                            </td>               
                        <td>
                        <cfif not isdefined("url.trans")>
                            <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&DEPARTMENT_ID=#DEPARTMENT_ID#&emp_id=#EMPLOYEE_ID#&POS_ID=#POSITION_CODE##url_string#','medium')">#employee_name# #employee_surname#</a>
                        <cfelse>
                            #employee_name# #employee_surname#
                        </cfif>
                    </td>
                    <td><cfif len(get_photos.PHOTO[listfind(main_employee_list,employee_id,',')])>
                    <cf_get_server_file output_file="hr/#get_photos.PHOTO[listfind(main_employee_list,employee_id,',')]#" output_server="#get_photos.PHOTO_SERVER_ID[listfind(main_employee_list,employee_id,',')]#" output_type="0" image_width="40" image_height="50" image_link="1">
                    </cfif>
                    </td>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_position_history&position_id=#get_positions.position_id#','large');"><i class="icon-detail"></i></a></td>
                    </tr>
                    </cfoutput>
                    <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>				
                    </cfif>
                </tbody>
        </cf_flat_list>
	    <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="objects.popup_list_department_position#url_string#&department_id=#attributes.department_id#"> 
        </cfif>
    </cf_box>

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
