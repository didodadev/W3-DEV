<cfset d_hata = 0>
<cfset a_hata = 0>
<cfquery name="GET_ALL_GROUPS" datasource="#DSN#">
    SELECT * FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#attributes.process_row_id#">
</cfquery>

<cfset mainworkgroupList = "">
<cfoutput query="GET_ALL_GROUPS">
    <cfif len( MAINWORKGROUP_ID )>
        <cfset mainworkgroupList = listAppend(mainworkgroupList,MAINWORKGROUP_ID)>
    </cfif>
</cfoutput>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='43250.Süreç Grupları'></cfsavecontent>
<cf_seperator title="#message#" id="processgroup">
<cf_flat_list id="processgroup">
    <thead>
        <tr>
            <th width="20"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=process.popup_list_process_workgroup&process_row_id=#attributes.process_row_id#</cfoutput>','medium')"><i class="fa fa-user-o" title="<cf_get_lang dictionary_id='52485.Grup'> <cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
            <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id="31787.Süreç Grubu"></th>
        </tr>
    </thead>
    <tbody>
        <cfif listLen(mainworkgroupList)>
            <cfquery name="GET_PROCESS_GROUPS" datasource="#DSN#">
                SELECT WORKGROUP_ID, WORKGROUP_NAME FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE WORKGROUP_ID IN(#mainworkgroupList#) AND WORKGROUP_NAME IS NOT NULL
            </cfquery>
            <cfif GET_PROCESS_GROUPS.recordCount>
                <cfoutput query="GET_PROCESS_GROUPS">
                    <tr>
                        <td>
                            <a href="javascript://" class="tableyazi" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_form_upd_group&workgroup_id=#WORKGROUP_ID#')"><i class="fa fa-pencil" title="Güncelle"></i></a>
                            <a href="javascript://" onclick="if (confirm('Süreç grubu silinecek!')) windowopen('index.cfm?fuseaction=process.emptypopup_del_process_group&workgroup_id=#WORKGROUP_ID#&process_row_id=#attributes.process_row_id#','small');"><img src="./images/delete_list.gif" title="<cf_get_lang dictionary_id='57463.Sil'> " border="0" align="absmiddle"></a>
                        </td>
                        <td>#currentrow#</td>
                        <td>#WORKGROUP_NAME#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Yok'> !</td></tr>
            </cfif>
        <cfelse>
            <tr><td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Yok'> !</td></tr>
        </cfif>
    </tbody>
</cf_flat_list>


<cf_seperator title="Maker - Checker Blokları" id="makerchecker">
    <cf_flat_list id="makerchecker">
	<thead>
        <tr>
            <th width="20">
                <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=process.popup_form_add_process_workgroup&process_row_id=#attributes.process_row_id#</cfoutput><cfif get_process_rows.is_confirm_first_chief eq 1 or get_process_rows.is_confirm_second_chief eq 1>&is_confirm_chief=1</cfif>')"><i class="fa fa-plus" align="absmiddle" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
            </th>
            <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
            <th>Maker (<cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'>)</th>
            <cfif get_process_rows.is_confirm_first_chief neq 1 and get_process_rows.is_confirm_second_chief neq 1>
                <th>Checker (<cf_get_lang dictionary_id='36200.Onay ve Uyarılacaklar'>)</th>
                <th>CC (<cf_get_lang dictionary_id='58773.Bilgi Verilecekler'>)</th>
            </cfif>
        </tr>
    </thead>
    <tbody>
        <cfset i = 1>
        <cfif GET_ALL_GROUPS.recordcount>
            <cfoutput query="GET_ALL_GROUPS">
                <cfif not len(MAINWORKGROUP_ID)>
                    <cfquery name="GET_PRO" datasource="#DSN#">
                        SELECT DISTINCT
                            PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID,
                            PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID,
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_POSID,
                            EMPLOYEE_POSITIONS
                        WHERE 
                            PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID = #workgroup_id# AND
                            EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
                        ORDER BY
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME
                    </cfquery>
                    <cfquery name="GET_PRO_PAR" datasource="#DSN#">
                        SELECT
                            PROCESS_TYPE_ROWS_POSID.PRO_PARTNER_ID,
                            PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID,
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_POSID,
                            COMPANY_PARTNER,
                            COMPANY
                        WHERE 
                            PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID = #workgroup_id# AND
                            COMPANY_PARTNER.PARTNER_ID = PROCESS_TYPE_ROWS_POSID.PRO_PARTNER_ID AND
                            COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
                        ORDER BY
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME
                    </cfquery>
                    <!---
                    upd: 15/11/2019 - UH 
                    #Süreç aşamasında checker bölümünde 1. ya da 2. amir seçilmişse sadece maker(yetkili pozisyonlar) görüntülenir.
                    ---->
                    <cfif get_process_rows.is_confirm_first_chief neq 1 and get_process_rows.is_confirm_second_chief neq 1>
                    <cfquery name="GET_CAU" datasource="#DSN#">
                        SELECT 
                            PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID,
                            PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID,
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_CAUID,
                            EMPLOYEE_POSITIONS
                        WHERE 
                            PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID = #workgroup_id# AND
                            EMPLOYEE_POSITIONS.POSITION_ID=PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID
                        ORDER BY
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME
                    </cfquery>
                    <cfquery name="GET_CAU_PAR" datasource="#DSN#">
                        SELECT
                            PROCESS_TYPE_ROWS_CAUID.CAU_PARTNER_ID,
                            PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID,
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_CAUID,
                            COMPANY_PARTNER,
                            COMPANY
                        WHERE 
                            PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID = #workgroup_id# AND
                            COMPANY_PARTNER.PARTNER_ID = PROCESS_TYPE_ROWS_CAUID.CAU_PARTNER_ID AND
                            COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
                        ORDER BY
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME
                    </cfquery>
                    <cfquery name="GET_INF" datasource="#DSN#">
                        SELECT 
                            PROCESS_TYPE_ROWS_INFID.INF_POSITION_ID,
                            PROCESS_TYPE_ROWS_INFID.WORKGROUP_ID,
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_INFID,
                            EMPLOYEE_POSITIONS
                        WHERE 
                            PROCESS_TYPE_ROWS_INFID.WORKGROUP_ID = #workgroup_id# AND
                            EMPLOYEE_POSITIONS.POSITION_ID=PROCESS_TYPE_ROWS_INFID.INF_POSITION_ID
                        ORDER BY
                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                            EMPLOYEE_POSITIONS.POSITION_NAME
                    </cfquery>
                    <cfquery name="GET_INF_PAR" datasource="#DSN#">
                        SELECT
                            PROCESS_TYPE_ROWS_INFID.INF_PARTNER_ID,
                            PROCESS_TYPE_ROWS_INFID.WORKGROUP_ID,
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME AS TITLE
                        FROM 
                            PROCESS_TYPE_ROWS_INFID,
                            COMPANY_PARTNER,
                            COMPANY
                        WHERE 
                            PROCESS_TYPE_ROWS_INFID.WORKGROUP_ID = #workgroup_id# AND
                            COMPANY_PARTNER.PARTNER_ID = PROCESS_TYPE_ROWS_INFID.INF_PARTNER_ID AND
                            COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
                        ORDER BY
                            COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                            COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                            COMPANY.NICKNAME
                    </cfquery>
                    </cfif>
                    <tr>
                        <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=process.popup_form_upd_process_workgroup&process_row_id=#attributes.process_row_id#&workgroup_id=#workgroup_id#<cfif get_process_rows.is_confirm_first_chief eq 1 or get_process_rows.is_confirm_second_chief eq 1>&is_confirm_chief=1</cfif>')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        <td>#i#</td>
                        <td>
                            <cfloop query="get_pro">#employee_name# #employee_surname# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                            <cfloop query="get_pro_par">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                        </td>
                        <cfif get_process_rows.is_confirm_first_chief neq 1 and get_process_rows.is_confirm_second_chief neq 1>
                            <td>
                                <cfloop query="get_cau">#employee_name# #employee_surname# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                                <cfloop query="get_cau_par">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                            </td>
                            <td>
                                <cfloop query="get_inf">#employee_name# #employee_surname# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                                <cfloop query="get_inf_par">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# <cfif len(TITLE)>(#TITLE#)</cfif><br/></cfloop>
                            </td>
                        </cfif>
                    </tr>
                    <cfset i++>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr>
            	<td colspan="5"><cf_get_lang dictionary_id='58486.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_flat_list>