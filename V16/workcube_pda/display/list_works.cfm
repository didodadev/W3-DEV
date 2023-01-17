<cfparam name="attributes.is_form_submitted" default="">
<cfif isDefined('xml_work_type') and xml_work_type eq 1>
    <cfquery name="GET_EMPS" datasource="#DSN#">
            SELECT 
                EMPLOYEE_ID,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND
                EMPLOYEE_ID IS NOT NULL       
		UNION
            SELECT 
                EMPLOYEE_ID,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND
                EMPLOYEE_ID IS NOT NULL        
        UNION 
            SELECT 
                EMPLOYEE_ID,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND
                EMPLOYEE_ID IS NOT NULL                 
    </cfquery>
</cfif>

<cfif len(attributes.is_form_submitted) and attributes.is_form_submitted eq 1>
	<cfinclude template="../query/get_works.cfm">
<cfelse>
	<cfset get_works.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_works.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">İşlerim</td>
        <td align="right"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.form_add_work" class="txtsubmenu"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%">	
	<cfif isDefined('xml_work_filter') and xml_work_filter eq 1>
        <tr>
            <td align="right">
                <cfform name="get_works" action="#request.self#?fuseaction=#attributes.fuseaction#">
                    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1" />
                    <cfif isDefined('xml_work_type') and xml_work_type eq 1>
                        <select name="my_members" id="my_members" style="width:150px;">
                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                            <cfoutput query="get_emps">
                                <option value="#employee_id#" <cfif isDefined('attributes.my_members') and attributes.my_members eq employee_id>selected</cfif>>#employee_name# #employee_surname#</option>
                            </cfoutput>
                        </select>
                    </cfif>
                    <select name="work_status" id="work_status" style="width:70px;">
                        <option value="" <cfif isDefined('attributes.work_status') and not len(attributes.work_status)>selected</cfif>>Tümü</option>                            	
                        <option value="1" <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status eq 1>selected</cfif>>Aktif</option>
                        <option value="0" <cfif isDefined('attributes.work_status') and len(attributes.work_status) and attributes.work_status eq 0>selected</cfif>>Pasif</option>
                    </select>
                    <cf_wrk_search_button is_excel='0'>
                </cfform>
            </td>
        </tr>
    </cfif>
	<tr>
		<td class="color-row">
			<table cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%">
				<tr class="color-header">
					<td class="form-title" style="width:30px;">No</td>
					<td class="form-title">İş</td>
                    <cfif isDefined('xml_project_emp') and xml_project_emp eq 1><td class="form-title">Görevli</td></cfif>        
                    <cfif isDefined('xml_stage') and xml_stage eq 1><td class="form-title">Aşama</td></cfif>
                    <cfif isDefined('xml_priority') and xml_priority eq 1><td class="form-title">Öncelik</td></cfif>
					<td class="form-title" style="width:25%">Tarih</td>
				</tr>
				<cfif get_works.recordcount>
					<cfoutput query="get_works">
                        <tr class="color-row">
                            <td>#currentrow# -</td>
                            <td><a href="#request.self#?fuseaction=pda.form_upd_work&work_id=#work_id#<cfif len(project_id)>&project_id=#project_id#</cfif>" class="tableyazi">#get_works.work_head#</a></td>
                            <cfif isDefined('xml_project_emp') and xml_project_emp eq 1><td>#get_emp_info(project_emp_id,0,0)#</td></cfif>
                            <cfif isDefined('xml_stage') and xml_stage eq 1><td>#stage#</td></cfif>
                            <cfif isDefined('xml_priority') and xml_priority eq 1><td>#priority#</td></cfif>
                            <td>#dateformat(get_works.target_start,'dd/mm/yyyy')# - #dateformat(get_works.target_finish,'dd/mm/yyyy')#</td>
                        </tr>
                    </cfoutput>
               	<cfelse>
					<tr class="color-row">
						<td colspan="4"><cfif isDefined('attributes.is_form_submitted')>Filtre Ediniz!<cfelse>Kayıt Bulunamadı!</cfif></td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
<br/>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_string = ''>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:30px;">
    	<tr>
      		<td> 
            	<cf_pages page="#attributes.page#"
			  		maxrows="#attributes.maxrows#"
			  		totalrecords="#attributes.totalrecords#"
			  		startrow="#attributes.startrow#"
			  		adres="#attributes.fuseaction##url_string#&is_form_submitted=#attributes.is_form_submitted#"> </td>
     		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_works.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    	</tr>
  	</table>
</cfif>


