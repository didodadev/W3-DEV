<cfquery name="GET_FAILURE_HISTORY" datasource="#DSN#">
    SELECT 
        PTR.STAGE,
        AFNH.RECORD_DATE,
        AFNH.DETAIL,
        EMP.EMPLOYEE_NAME +' ' +EMP.EMPLOYEE_SURNAME  AS NAME
    FROM 
        ASSET_FAILURE_NOTICE_HISTORY  AFNH
        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID=AFNH.FAILURE_STAGE
        LEFT JOIN ASSET_FAILURE_NOTICE AFN ON AFN.FAILURE_ID=AFNH.FAILURE_ID
        LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID=AFNH.RECORD_EMP
    WHERE 
        AFNH.FAILURE_ID='#failure_id#'
</cfquery>

<cf_flat_list>
	<thead>
		<tr>
			<th width="100"><cf_get_lang_main no='330.Tarih'></th>
			<th width="75"><cf_get_lang_main no='70.Aşama'></th>
			<th width="125"><cf_get_lang_main no='1174.İşlem Yapan'></th>
			<th width="250"><cf_get_lang_main no='217.Açıklama'></th>
		</tr>
	</thead>	
	<tbody>
		<cfif GET_FAILURE_HISTORY.recordcount>
			<cfoutput query="GET_FAILURE_HISTORY"> 
				<tr>
                    <td>
						<cfif len(get_failure_history.record_date)>
                          	#DateFormat(record_date,dateformat_style)# (#TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
                        </cfif>
                    </td>
                    <td>#stage#</td>
                    <td>#NAME#</td>
				  	<td>#detail#</td>
			  	</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
