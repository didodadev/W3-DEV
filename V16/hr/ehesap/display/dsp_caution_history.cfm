<cfquery name="get_hist" datasource="#dsn#">
	SELECT 
		ECH.CAUTION_HEAD,
        ECH.CAUTION_DATE,
        ECH.DECISION_NO,
        ECH.APOLOGY_DATE,
        ECH.CAUTION_DETAIL,
        ECH.APOLOGY,
        ECH.IS_DISCIPLINE_CENTER,
        ECH.IS_DISCIPLINE_BRANCH,
        SCT.CAUTION_TYPE,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS CAUTION_TO_NAME,
        E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME AS WARNER_NAME,
        PTR.STAGE,
        SSD.SPECIAL_DEFINITION,
        ECH.IS_ACTIVE,
        ECH.UPDATE_DATE,
        ECH.UPDATE_EMP
	FROM
		 EMPLOYEES_CAUTION_HISTORY ECH
         LEFT JOIN SETUP_CAUTION_TYPE SCT ON SCT.CAUTION_TYPE_ID = ECH.CAUTION_TYPE_ID
         LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = ECH.CAUTION_TO
         LEFT JOIN EMPLOYEES E2 ON E2.EMPLOYEE_ID = ECH.WARNER
         LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ECH.STAGE
         LEFT JOIN SETUP_SPECIAL_DEFINITION SSD ON SSD.SPECIAL_DEFINITION_ID = ECH.SPECIAL_DEFINITION_ID
	WHERE 
		CAUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_id#">
	ORDER BY 
		ECH.UPDATE_DATE DESC
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Tarihçe',57473)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
    	<thead>
        	<tr>
            	<th><cf_get_lang dictionary_id ='58820.Başlık'></th>
                <th><cf_get_lang dictionary_id ='57630.Tip'></th>
                <th><cf_get_lang dictionary_id ='53515.İşlem Yapılan'></th>
                <th><cf_get_lang dictionary_id ='58586.İşlem Yapan'></th>
                <th width="100"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
                <th><cf_get_lang dictionary_id ='58859.Süreç'></th>
                <th><cf_get_lang dictionary_id ='58772.İşlem No'></th>
                <th width="100"><cf_get_lang dictionary_id ="59305.Savunma Tarihi"></th>
                <th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id ='53092.Savunma'></th>
                <th><cf_get_lang dictionary_id ="54971.Özel Tanım"></th>
                <th><cf_get_lang dictionary_id ='53339.Merkez Disiplin Kurulu'></th>
                <th><cf_get_lang dictionary_id ='53340.Şube Disiplin Kurulu'></th>
                <th><cf_get_lang dictionary_id ="57756.Durum"></th>
                <th><cf_get_lang dictionary_id ="57891.Güncelleyen"></th>
                <th width="100"><cf_get_lang dictionary_id ="32449.Güncelleme Tarihi"></th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_hist">
            	<tr>
                	<td>#caution_head#</td>
                    <td>#caution_type#</td>
                    <td>#caution_to_name#</td>
                    <td>#warner_name#</td>
                    <td>#dateformat(caution_date,dateformat_style)#</td>
                    <td>#stage#</td>
                    <td>#decision_no#</td>
                    <td>#dateformat(apology_date,dateformat_style)#</td>
                    <td>#caution_detail#</td>
                    <td>#apology#</td>
                    <td>#special_definition#</td>
                    <td><cfif is_discipline_center eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td>
                    <td><cfif is_discipline_branch eq 1><cf_get_lang dictionary_id="57495.Evet"><cfelse><cf_get_lang dictionary_id="57496.Hayır"></cfif></td>
                    <td><cfif is_active eq 1><cf_get_lang dictionary_id="57493.Aktif"><cfelse><cf_get_lang dictionary_id="57494.Pasif"></cfif></td>
                    <td>#get_emp_info(update_emp,0,0)#</td>
                    <td>#dateformat(update_date,dateformat_style)#</td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
</cf_box>
