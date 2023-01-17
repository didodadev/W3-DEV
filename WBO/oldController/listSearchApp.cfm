<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfset url_str = "">
    <cfquery name="GET_NOTICESS" datasource="#DSN#">
        SELECT NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES ORDER BY NOTICE_HEAD
    </cfquery>
    <cfset notice_list="">
    <cfoutput query="GET_NOTICESS">
        <cfset notice_list=listappend(notice_list,NOTICE_ID,',')>
        <cfset notice_list=listappend(notice_list,NOTICE_NO,',')>
        <cfset notice_list=listappend(notice_list,NOTICE_HEAD,',')>
    </cfoutput>
    <cfinclude template="../hr/query/get_search_app_emp.cfm">
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.totalrecords" default='#get_apps.recordcount#'>
    <cfif get_apps.recordcount>
		<cfset app_color_status_list =''>
        <cfset empapp_id_list = ''>
        <cfset training_level_list = ''>
        <cfset branhes_id_list = ''>
        <cfoutput query="get_apps">
            <cfif len(app_color_status) and (not listfind(app_color_status_list,app_color_status))>
                <cfset app_color_status_list = listappend(app_color_status_list,get_apps.app_color_status,',')>
            </cfif>
            <cfif not listfind(empapp_id_list,EMPAPP_ID)>
                <cfset empapp_id_list=listappend(empapp_id_list,EMPAPP_ID)>
           </cfif>
           <cfif len(training_level) and (not listfind(training_level_list,training_level))>
                <cfset training_level_list=listappend(training_level_list,TRAINING_LEVEL)>
           </cfif>
        </cfoutput>
        <cfset empapp_id_list=listsort(empapp_id_list,'numeric','ASC')>
        <cfset training_level_list=listsort(training_level_list,'numeric','ASC')>
        <cfif listlen(app_color_status_list)>
            <cfquery name="get_cv_status" datasource="#dsn#">
                SELECT STATUS_ID,STATUS,ICON_NAME FROM SETUP_CV_STATUS WHERE STATUS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#app_color_status_list#">) ORDER BY STATUS_ID
            </cfquery>
            <cfset app_color_status_list = listsort(valuelist(get_cv_status.status_id,','),"numeric","ASC",',')>
        </cfif>
        <cfif len(empapp_id_list)>
             <cfquery name="get_teacher_detail" datasource="#DSN#">
                SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#empapp_id_list#">) ORDER BY EMPAPP_ID
             </cfquery>
         </cfif>
         <cfset empapp_id_list = listsort(listdeleteduplicates(valuelist(get_teacher_detail.EMPAPP_ID,',')),'numeric','ASC',',')>
         <cfif len(training_level_list)>
            <cfquery name="get_edu_level" datasource="#DSN#">
                SELECT * FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#training_level_list#">) ORDER BY EDU_LEVEL_ID
            </cfquery>
         	<cfset training_level_list = listsort(listdeleteduplicates(valuelist(get_edu_level.EDU_LEVEL_ID,',')),'numeric','ASC',',')>
         </cfif>
    </cfif>
    <cfquery name="get_branches_info" datasource="#dsn#">
        SELECT * FROM SETUP_APP_BRANCHES_ROWS
    </cfquery>
    <cfquery name="get_all_info" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_APP_INFO
    </cfquery>
    <cfif get_apps.recordcount>
    	<cfoutput query="get_apps">
        	<!---<cfif len(get_apps.BIRTH_DATE)>
				<cfset yas = datediff("yyyy",get_apps.BIRTH_DATE,NOW())>	
            </cfif>
            <cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EDU_START DESC
            </cfquery>--->
            <cfif isdefined("attributes.report_dsp_type") and listfind(attributes.report_dsp_type,1,',')>
				<cfif len(empapp_id_list)>
                    <cfquery name="get_info" dbtype="query">
                        SELECT * FROM get_all_info WHERE EMPAPP_ID = #get_apps.empapp_id#
                    </cfquery>
                    <cfloop query="get_info">
                        <cfquery name="get_row_info" dbtype="query">
                            SELECT * FROM get_branches_info WHERE BRANCHES_ROW_ID = #get_info.BRANCHES_ROW_ID#
                        </cfquery>									
                    </cfloop>
                </cfif>
            </cfif>
            <!---<cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
                SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EXP_START DESC
            </cfquery>--->
        </cfoutput>
    </cfif>
</cfif>              
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function hepsi()
		{
			if (document.emp_list.all_check.checked)
				{
			<cfif get_apps.recordcount gt 1>	
				for(i=0;i<emp_list.ozgecmis_id.length;i++) 
				{
					emp_list.ozgecmis_id[i].checked = true;
				}
			<cfelseif get_apps.recordcount eq 1>
				emp_list.ozgecmis_id.checked = true;
			</cfif>
				}
			else
				{
			<cfif get_apps.recordcount gt 1>	
				for(i=0;i<emp_list.ozgecmis_id.length;i++) 
				{
					emp_list.ozgecmis_id[i].checked = false;
				}
			<cfelseif get_apps.recordcount eq 1>
				emp_list.ozgecmis_id.checked = false;
			</cfif>
				}
		}
		
		function send_mail()
		{
		<cfif get_apps.recordcount>
				for(i=0;i<emp_list.ozgecmis_id.length;i++) 
				{
					if(document.emp_list.ozgecmis_id[i].checked)
					{
						if(document.emp_list.mail.value.length==0) ayirac=''; else ayirac=',';
							document.emp_list.mail.value=document.emp_list.mail.value+ayirac+document.emp_list.ozgecmis_id[i].value;
					}
				}
				windowopen('','list','select_list_window');
				emp_list.action='<cfoutput>#request.self#?fuseaction=hr.popup_app_add_mail&mail_sum=1&is_refresh=0</cfoutput>';
				emp_list.target='select_list_window';emp_list.submit();
				document.emp_list.mail.value='';/* maileri yolladıktan sonra alanı boşaltıyoruz*/
		<cfelse>
			alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
		</cfif>
		}
		
		function add_select_list()
		{
		<cfif get_apps.recordcount>
			<cfif get_apps.recordcount gt 1> 
				for(i=0;i<emp_list.ozgecmis_id.length;i++)
					if(document.emp_list.ozgecmis_id[i].checked)
					{
						if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
						document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
						document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
					}
			<cfelse>
				if(document.emp_list.ozgecmis_id.checked)
				{
					document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
					document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
				}
			</cfif>
			if(document.list_app.list_empapp_id.value.length==0)
			{
				alert("<cf_get_lang no ='1755.Özgeçmiş Seçmelisiniz'>");
				return false;
			}
				windowopen('','list','select_list_window');
				list_app.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list</cfoutput>';
				list_app.target='select_list_window';list_app.submit();
				document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
				document.list_app.list_app_pos_id.value='';
		<cfelse>
			alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
		</cfif>
		}
		
		function edit_select_list()
		{
		<cfif get_apps.recordcount>
			<cfif get_apps.recordcount gt 1> 
				for(i=0;i<emp_list.ozgecmis_id.length;i++)
					if(document.emp_list.ozgecmis_id[i].checked)
					{
					if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
						document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
						document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
					}
			<cfelse>
				if(document.emp_list.ozgecmis_id.checked)
					document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
					document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
			</cfif>
			if(document.list_app.list_empapp_id.value.length==0)
			{
				alert("<cf_get_lang no ='1755.Özgeçmiş Seçmelisiniz'>");
				return false;
			}
				windowopen('','list','select_list_window');
				list_app.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_select_emp_list&old=1</cfoutput>';
				list_app.target='select_list_window';list_app.submit();
				document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
				document.list_app.list_app_pos_id.value='';
		<cfelse>
			alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
		</cfif>	
		}
		function edit_app_color()
		{
		<cfif get_apps.recordcount>
			<cfif get_apps.recordcount gt 1> 
					for(var i=0;i<<cfoutput>#get_apps.recordcount#</cfoutput>;i++)
					if(document.emp_list.ozgecmis_id[i].checked)
					{
					if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
						document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
					}
			<cfelse>
				if(document.emp_list.ozgecmis_id.checked)
					document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
			</cfif>
			if(document.list_app.list_empapp_id.value.length==0)
			{
				alert("<cf_get_lang no ='1755.Özgeçmiş Seçmelisiniz'>");
				return false;
			}
				windowopen('','small','select_list_window');
				list_app.action='<cfoutput>#request.self#?fuseaction=hr.popup_add_list_app_color_status</cfoutput>';
				list_app.target='select_list_window';list_app.submit();
				document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		<cfelse>
			alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
		</cfif>
		}
	</cfif>
</script>
<!-- sil -->
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_search_app';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_search_app.cfm';
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// List //
	if((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[1752]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "add_select_list();";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array.item[1753]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['onClick'] = "edit_select_list();";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
