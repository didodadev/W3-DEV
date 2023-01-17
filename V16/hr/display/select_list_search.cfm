<!--- bu safyaın aynısı myhome da aynı sayfa kullanılmaktadır.--->
<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
	<cfset attributes.date_dogum="01/01/#evaluate(session.ep.period_year-attributes.birth_date2)#">
	<cf_date tarih='attributes.date_dogum'>
</cfif>
<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
	<cfset attributes.date_dogum_1="01/01/#evaluate(session.ep.period_year-attributes.birth_date1)#">
	<cf_date tarih='attributes.date_dogum_1'>
</cfif>
<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
	<cfquery name="get_work_info" datasource="#dsn#">
		SELECT 
			EMPAPP_ID,
			Sum(EXP_FARK)/365 
		FROM 
			EMPLOYEES_APP_WORK_INFO 
		GROUP BY 
			EMPAPP_ID 
		HAVING 
			<cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>Sum(EXP_FARK)/365 >= #exp_year_s1#<cfif  isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>AND</cfif></cfif>
			<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>Sum(EXP_FARK)/365 <= #exp_year_s2#</cfif>
	</cfquery>
	<cfif get_work_info.recordcount>
		<cfset  exp_app_list = valuelist(get_work_info.empapp_id,',')>
	<cfelse>
		<cfset  exp_app_list = 0>
	</cfif>
</cfif>
<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_part") and len(attributes.edu4_part))>
	<cfquery name="get_edu_info" datasource="#dsn#">
		SELECT
			EMPAPP_ID
		FROM
			EMPLOYEES_APP_EDU_INFO
		WHERE
			EDU_ID IS NOT NULL AND
			EMPAPP_ID IS NOT NULL
			<cfif len(attributes.edu4)>AND EDU_ID=#attributes.edu4#</cfif> 
			<cfif len(attributes.edu4_part)>AND EDU_PART_ID = #attributes.edu4_part#</cfif>
	</cfquery>
	<cfif get_edu_info.recordcount>
		<cfset  edu_app_list = valuelist(get_edu_info.empapp_id,',')>
	<cfelse>
		<cfset  edu_app_list = 0>
	</cfif>
</cfif>
<cfquery name="GET_APPS" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP.EMPAPP_ID,
		null AS APP_POS_ID,
		null AS POSITION_ID,
		null AS POSITION_CAT_ID,
		null AS APP_DATE,
		EMPLOYEES_APP.NAME AS NAME,
		EMPLOYEES_APP.SURNAME,
		EMPLOYEES_APP.STEP_NO,
		null AS NOTICE_ID,
		EMPLOYEES_APP.APP_STATUS AS APP_POS_STATUS,
		<!--- EMPLOYEES_APP.VALIDATOR_POSITION_CODE, --->
		EMPLOYEES_APP.VALID_DATE,
		EMPLOYEES_APP.DRIVER_LICENCE,
		EMPLOYEES_APP_SEL_LIST_ROWS.LIST_ROW_ID,
		EMPLOYEES_APP_SEL_LIST_ROWS.UPDATE_DATE AS UPDATE_DATE,
		EMPLOYEES_APP_SEL_LIST_ROWS.UPDATE_EMP,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_APP_SEL_LIST_ROWS.STAGE,
		EMPLOYEES_APP_SEL_LIST_ROWS.ROW_STATUS
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_IDENTY,
		EMPLOYEES_APP_SEL_LIST_ROWS
	WHERE
			EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_SEL_LIST_ROWS.EMPAPP_ID 
			AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP_SEL_LIST_ROWS.EMPAPP_ID 
			AND EMPLOYEES_APP_SEL_LIST_ROWS.LIST_ID=#attributes.list_id#
		<cfif IsDefined('attributes.status') and len(attributes.status)>
			AND EMPLOYEES_APP_SEL_LIST_ROWS.ROW_STATUS=#attributes.status#
		</cfif>	
			AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
			AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
		<cfif isdefined("attributes.app_name") and len(attributes.app_name)>
			AND EMPLOYEES_APP.NAME LIKE '%#attributes.app_name#%'
		</cfif>
		<cfif isdefined("attributes.app_surname") and len(attributes.app_surname)>
			AND EMPLOYEES_APP.SURNAME LIKE '%#attributes.app_surname#%'
		</cfif>
		<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
			AND EMPLOYEES_IDENTY.BIRTH_DATE <= #attributes.date_dogum_1#
		</cfif>
 		<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
			AND EMPLOYEES_IDENTY.BIRTH_DATE >= #attributes.date_dogum#
		</cfif> 
		<cfif (IsDefined("attributes.SEX") AND LISTLEN(attributes.SEX))>
			AND EMPLOYEES_APP.SEX IN (#LISTSORT(attributes.sex,"NUMERIC")#) 
		</cfif>
		<cfif (IsDefined("attributes.MARRIED") AND LISTLEN(attributes.MARRIED))>
			AND EMPLOYEES_IDENTY.MARRIED IN (#LISTSORT(attributes.MARRIED,"NUMERIC")#)  
		</cfif>
		<cfif (IsDefined("attributes.military_status") AND LISTLEN(attributes.military_status))>
			AND EMPLOYEES_APP.MILITARY_STATUS IN (#LISTSORT(attributes.military_status,"NUMERIC")#) 
		</cfif>
		<!--- <cfif isdefined("attributes.edu4") and len(attributes.edu4)>
			AND (EMPLOYEES_APP.EDU4_ID=#attributes.edu4# OR
				EMPLOYEES_APP.EDU4_ID_2=#attributes.edu4#)
		</cfif>
		<cfif isdefined("attributes.edu4_part") and len(attributes.edu4_part)>
			AND (EMPLOYEES_APP.EDU4_PART_ID=#attributes.edu4_part# OR
				EMPLOYEES_APP.EDU4_PART_ID_2=#attributes.edu4_part#)
		</cfif> --->
		<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_part") and len(attributes.edu4_part))>
			AND EMPLOYEES_APP.EMPAPP_ID IN (#edu_app_list#)
		</cfif>
		<cfif isDefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
			AND DRIVER_LICENCE_TYPE LIKE '%#attributes.driver_licence_type#%'
		</cfif>
		<cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
			AND (DRIVER_LICENCE <> '' OR DRIVER_LICENCE_TYPE <> '')
		</cfif>
		<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
		  AND PREFERED_CITY LIKE '%#attributes.prefered_city#%'
		</cfif>
		<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
			AND EMPLOYEES_APP.EMPAPP_ID IN (#exp_app_list#)
		</cfif>
		<!--- <cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>
		  	AND (EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 >= #attributes.exp_year_s1#
		</cfif>
		<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>
			AND	(EXP1_FARK+EXP2_FARK+EXP3_FARK+EXP4_FARK)/365 <= #attributes.exp_year_s2#
		</cfif> --->
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58088.Arama Sonuçları"></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cfform name="select_list" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_select_list_rows&list_id=#attributes.list_id#" method="post">
<cf_grid_list>
<input type="hidden" name="is_popup" id="is_popup" value="1">
    <thead>
        <tr>
            <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th width="25"><cf_get_lang dictionary_id="30496.Yaş"></th>
            <th width="50"><cf_get_lang dictionary_id='57709.Okul'></th>
            <th width="75"><cf_get_lang dictionary_id='55912.Son Tecrübe'></th>
            <th width="75"><cf_get_lang dictionary_id='29437.Son Güncelleyen'></th>
            <th width="40"><cf_get_lang dictionary_id='57756.Durum'></th>
            <th width="70"><cf_get_lang dictionary_id="58859.Süreç"></th>
            <th><input type="checkbox" name="all_check" id="all_check" value="1" onclick="javascript: hepsi();"><input type="hidden" value="" name="del" id="del"></th>
        </tr>
    </thead>
	<cfif get_apps.recordcount>
      <cfset empapp_id_list=''>
      <cfoutput query="get_apps">
          <cfif not listfind(empapp_id_list,EMPAPP_ID)>
            <cfset empapp_id_list=listappend(empapp_id_list,EMPAPP_ID)>
         </cfif>
      </cfoutput>
      <cfset empapp_id_list=listsort(empapp_id_list,"numeric")>
      <tbody>
        <cfoutput query="get_apps">				
          <tr>
            <td>
                <!--- <cfif len(app_pos_id)>
                    <a href="#request.self#?fuseaction=hr.upd_app_pos&empapp_id=#empapp_id#&app_pos_id=#app_pos_id#" class="tableyazi" target="_blank">#currentrow#</a>
                <cfelse>
                    <a href="#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#empapp_id#" class="tableyazi"  target="_blank">#currentrow#</a>
                </cfif> --->#currentrow#
            </td>
            <td><a href="#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#empapp_id#" class="tableyazi"  target="_blank">#name# #surname#</a></td>
            <td>
              <cfif len(get_apps.BIRTH_DATE)>
                <cfset YAS = DATEDIFF("yyyy",get_apps.BIRTH_DATE,NOW())>
               <cfif YAS NEQ 0>
                 #YAS#
               </cfif>	
              </cfif>
            </td>
            <td>
                <cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                    SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
                </cfquery>
                <cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name# / #get_app_edu_info.edu_part_name#</cfif>
            </td>
            <td>
                <cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
                    SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
                </cfquery>
                <cfif get_app_work_info.recordcount>#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</cfif>
            </td>
            <td>#get_emp_info(get_apps.update_emp,0,1)#</td>
            <td><cfif row_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
            <td>
            <cfif len(stage)>
                <cfquery name="get_stage" datasource="#dsn#">
                SELECT 
                    PROCESS_TYPE_ROWS.STAGE
                FROM
                    PROCESS_TYPE_ROWS
                WHERE
                    PROCESS_ROW_ID=#get_apps.stage#
                </cfquery>
                    #get_stage.stage#
                </cfif>
            </td>
            <td align="center" width="15"><input type="checkbox" value="#get_apps.list_row_id#" name="list_row_id" id="list_row_id"></td>
          </tr>
          </cfoutput>
		</tbody>
        <tfoot>
            <tr>
            	<td colspan="2">
                    <cf_workcube_process 
                        is_upd='0' 
                        process_cat_width='150' 
                        is_detail='0'>
                </td>
                <td colspan="7" style="text-align:right;">
                	<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol_row2()' type_format="1">
                    <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol_row()' insert_info='Sil' type_format="1">
                </td>
            </tr>
        </tfoot>
    <cfelse>
    <tbody>
        <tr>
            <td colspan="9"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
        </tr>
    </tbody>
    </cfif>
</cf_grid_list>
</cfform>
<script type="text/javascript">
function kontrol_row()
{
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			select_list.del.value='1';
			return true;
		}
	}
	else
	{
		if(select_list.list_row_id.checked == true)
		{
			select_list.del.value='1';
			return true;
		}
	}
		alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>!");
		return false;
}

function kontrol_row2()
{
	if(select_list.list_row_id.length>0)
	{
		for(i=0;i<select_list.list_row_id.length;i++)
		if(select_list.list_row_id[i].checked == true)
		{
			return true;
		}
	}
	else
	{
		if(select_list.list_row_id.checked == true)
		{
			return true;
		}
	}
		alert("<cf_get_lang dictionary_id='30942.Listeden Satır Seçmelisiniz'>!");
		return false;
}

function hepsi()
{
	if (document.select_list.all_check.checked)
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<select_list.list_row_id.length;i++) select_list.list_row_id[i].checked = true;
	<cfelseif get_apps.recordcount eq 1>
		select_list.list_row_id.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<select_list.list_row_id.length;i++) select_list.list_row_id[i].checked = false;
	<cfelseif get_apps.recordcount eq 1>
		select_list.list_row_id.checked = false;
	</cfif>
		}
}
</script>