<cfinclude template="../query/get_inflation.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang(27,'Enflasyon tanımları',47289)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                    <th><cf_get_lang dictionary_id='58724.Ay'></th>
                    <th><cf_get_lang dictionary_id='58456.Oran'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th width="20" class="header_icn_none text-center"><cfoutput><a href="##" onClick="openBoxDraggable('#request.self#?fuseaction=account.list_inflation&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_inflation.recordcount>
                <cfset employee_id_list = ''>
                <cfoutput query="get_inflation">
                    <cfif len(record_emp)>
                        <cfif not listfind(employee_id_list,record_emp)>
                            <cfset employee_id_list=listappend(employee_id_list,record_emp)>
                        </cfif>
                    </cfif>
                </cfoutput>
                <cfif len(employee_id_list)>
                    <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                    <cfquery name="get_emp_list" datasource="#DSN#">
                        SELECT
                            EMPLOYEE_ID,
                            EMPLOYEE_NAME,
                            EMPLOYEE_SURNAME
                        FROM
                            EMPLOYEES
                        WHERE
                            EMPLOYEE_ID IN (#employee_id_list#)
                        ORDER BY
                            EMPLOYEE_ID
                    </cfquery>
                    <cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_emp_list.employee_id,',')),'numeric','ASC',',')>
                </cfif>
                </cfif>
                <cfif get_inflation.recordcount>
                <cfoutput query="get_inflation">
                    <tr>
                        <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=account.list_inflation&event=upd&inf_id=#inf_id#');" class="tableyazi">#INF_ID#</a></td>
                        <td>#inf_year#</td>
                        <td>#listgetat(ay_list(),inf_month)#</td>
                        <td>% #inf_rate#</td>
                        <td>#get_emp_list.employee_name[listfind(employee_id_list,record_emp,',')]##get_emp_list.employee_surname[listfind(employee_id_list,record_emp,',')]#</td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <td align="center"><a href="##" onClick="openBoxDraggable('#request.self#?fuseaction=account.list_inflation&event=upd&inf_id=#inf_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>