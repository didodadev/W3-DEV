<cfquery name="get_emp_app" datasource="#dsn#">
	SELECT
		LR.LIST_ROW_ID,
		LR.EMPAPP_ID,
		LR.APP_POS_ID,
		EA.NAME,
		EA.SURNAME,
		LR.RECORD_DATE,
		LR.RECORD_EMP,
		LR.UPDATE_DATE,
		LR.UPDATE_EMP,
		LR.STAGE
	FROM
		EMPLOYEES_APP_SEL_LIST_ROWS AS LR,
		EMPLOYEES_APP EA
	WHERE
		LR.LIST_ID=#attributes.list_id#
		AND LR.EMPAPP_ID=EA.EMPAPP_ID
		AND LR.ROW_STATUS=0
</cfquery>
<cfset employee_id_list = ''>
<cfif get_emp_app.recordcount>
	<cfoutput query="get_emp_app">
		<cfif len(RECORD_EMP) and not listfind(employee_id_list,RECORD_EMP)>
			<cfset employee_id_list=listappend(employee_id_list,RECORD_EMP)>
		</cfif>
		<cfif len(UPDATE_EMP) and not listfind(employee_id_list,UPDATE_EMP)>
			<cfset employee_id_list=listappend(employee_id_list,UPDATE_EMP)>
		</cfif>		
	</cfoutput>
</cfif>
<cfif len(employee_id_list)>
	<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
	<cfquery name="get_emp_detail" datasource="#dsn#">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56042.Listeden Silinenler"></cfsavecontent>
    <cf_box title="#message#">
        <cfform name="select_list" action="#request.self#?fuseaction=hr.emptypopup_upd_select_list_rows&list_id=#attributes.list_id#" method="post">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='57570.Adı Soyadı'></th>
                        <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id ='57899.Kaydeden'></th>
                        <th><cf_get_lang dictionary_id ='57891.Güncelleyen'></th>
                        <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id ='57756.Durum'></th>
                        <th width="20"><a href="javascript://"><i class="fa fa-file"></th>
                        <th width="20"><a href="javascript://"><i class="fa fa-plus"></i></a></th>
                        <th width="20"><a href="javascript://"><i class="fa fa-print"></i></a></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_emp_app.recordcount>
                        <cfoutput query="get_emp_app">
                        <tr>
                            <td><a href="#request.self#?fuseaction=hr.form_upd_cv&empapp_id=#get_emp_app.empapp_id#" class="tableyazi" target="_blank">#get_emp_app.name# #get_emp_app.surname#</a></td>
                            <td>#dateformat(date_add('h',session.ep.time_zone,get_emp_app.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_emp_app.record_date),timeformat_style)#)</td>
                            <td>#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</td>
                            <td>#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,UPDATE_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,UPDATE_EMP,',')]#</td>
                            <td>#dateformat(date_add('h',session.ep.time_zone,get_emp_app.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_emp_app.update_date),timeformat_style)#)</td>
                            <cfif len(stage)>
                                <cfquery name="get_stage" datasource="#dsn#">
                                SELECT 
                                    PROCESS_TYPE_ROWS.STAGE
                                FROM
                                    PROCESS_TYPE_ROWS
                                WHERE
                                    PROCESS_ROW_ID=#get_emp_app.stage#
                                </cfquery>
                                <td>#get_stage.stage#</td>
                            <cfelse>
                                <td></td>
                            </cfif>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_app_mail_quiz&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&list_row_id=#get_emp_app.list_row_id#<cfif len(get_emp_app.app_pos_id)>&app_pos_id=#get_emp_app.app_pos_id#</cfif>','list');"><i class="fa fa-file" title="<cf_get_lang no ='1623.Tüm Değerlendirme ve Yazışmalar'>"></i></a></td>					
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56710.Seçili Kişiyi Tekrar Listeye Eklemek İstediğinizden Emin misiniz'></cfsavecontent>
                            <td><a href="javascript://" onClick="javascript:if (confirm('#alert#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_select_list_empapp&list_id=#attributes.list_id#&empapp_id=#get_emp_app.empapp_id#&app_pos_id=#get_emp_app.app_pos_id#&add=1','small'); else return false;"><i class="fa fa-plus" title="<cf_get_lang no ='1624.Listeye Ekle'>"></i></a></td>
                            <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#empapp_id#&print_type=170','woc');"><i class="fa fa-print"></i></a></td>
                        </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt yok'> !</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </cfform>
    </cf_box>
</div>

