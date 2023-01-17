
<cfquery name="GET_EMP_HISTORY" datasource="#dsn#">
    SELECT EH.EMPLOYEE_HISTORY_ID
    ,EH.EMPLOYEE_ID
    ,EH.EMPLOYEE_NAME
    ,EH.EMPLOYEE_SURNAME
    ,EH.EMPLOYEE_STATUS
    ,EH.MEMBER_CODE
    ,EH.EMPLOYEE_USERNAME
    ,EH.DIRECT_TELCODE
    ,EH.DIRECT_TEL
    ,EH.MOBILCODE
    ,EH.MOBILTEL
    ,EH.CORBUS_TEL
    ,EH.IS_IP_CONTROL
    ,EH.IP_ADDRESS
    ,EH.COMPUTER_NAME
    ,EH.GROUP_STARTDATE
    ,EH.DYNAMIC_HIERARCHY
    ,EH.DYNAMIC_HIERARCHY_ADD
    ,EH.HIERARCHY
    ,EH.OZEL_KOD
    ,EH.OZEL_KOD2
    ,EH.KIDEM_DATE
    ,EH.IZIN_DATE				
    ,EH.IN_COMPANY_REASON_ID
    ,EH.IS_CRITICAL
    ,EH.EXPIRY_DATE
    ,EH.EMPLOYEE_STAGE
    ,EH.BIOGRAPHY
    ,EH.WET_SIGNATURE
    ,EH.PER_ASSIGN_ID
    ,EH.IS_ACC_INFO
    ,EH.IZIN_DAYS
    ,EH.EMPLOYEE_NO
    ,EH.RECORD_DATE
    ,EH.RECORD_EMP
    ,EH.RECORD_IP
    ,(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EH.RECORD_EMP) AS RECORD_NAME
    FROM EMPLOYEES_HISTORY EH
    LEFT JOIN EMPLOYEES E ON EH.EMPLOYEE_ID = E.EMPLOYEE_ID
    WHERE 
		EH.EMPLOYEE_ID = #url.employee_id#
	ORDER BY
		EH.EMPLOYEE_HISTORY_ID desc
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32772.Çalışan Tarihçesi'></cfsavecontent>
<cf_box title="#message#:#get_emp_info(attributes.employee_id,0,0)#" closable="1"><!---Ücret Tarihçesi--->
<cfset title_list = "">
<!---<cfif GET_EMP_HISTORY.recordcount>--->
    <cfset temp_ = 0>
	<cfoutput query="GET_EMP_HISTORY">
		<cfset temp_ = temp_ +1>
        <cf_seperator id="history_#temp_#" header="#dateformat(record_date,"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_date),'HH:MM')#) - #RECORD_NAME#" is_closed="1">

        <table id="history_#temp_#" style="display:none;">
            <tr>
                <th><cf_get_lang dictionary_id='44688.Çalışan Adı'> - <cf_get_lang dictionary_id='58550.Soyadı'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'> <cf_get_lang dictionary_id ='43152.Statü'></th>
            </tr>
            <tr>
                <td><cfif len(#EMPLOYEE_NAME#) or len(#EMPLOYEE_SURNAME#) >#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#<cfelse>-</cfif></td>
                <td><cfif len(#EMPLOYEE_STATUS#)>#EMPLOYEE_STATUS#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='45128.Üye Kodu'></th>
                <th><cf_get_lang dictionary_id='57576.Çalışan'> <cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
            </tr>
            <tr>
                <td><cfif len(#MEMBER_CODE#)>#MEMBER_CODE#<cfelse>-</cfif></td>
                <td><cfif len(#EMPLOYEE_USERNAME#)>#EMPLOYEE_USERNAME#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='55445.Direkt Tel'> <cf_get_lang dictionary_id='32646.Kodu'></th>
                <th><cf_get_lang dictionary_id='55445.Direkt Tel'></th>
            </tr>
            <tr>
                <td><cfif len(#DIRECT_TELCODE#)>#DIRECT_TELCODE#<cfelse>-</cfif></td>
                <td><cfif len(#DIRECT_TEL#)>#DIRECT_TEL#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='29983.Mobil Kod'></th>
                <th><cf_get_lang dictionary_id='57406.Mobil Tel'></th>
            </tr>
            <tr>
                <td><cfif len(#MOBILCODE#)>#MOBILCODE#<cfelse>-</cfif></td>
                <td><cfif len(#MOBILTEL#)>#MOBILTEL#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='55111.IP Kontrol'></th>
                <th><cf_get_lang dictionary_id='55440.IP Adresi'></th>
            </tr>
            <tr>
                <td><cfif IS_IP_CONTROL eq 1><cf_get_lang dictionary_id='58564.Var'><cfelse><cf_get_lang dictionary_id='58546.Yok'></cfif></td>
                <td><cfif len(#IP_ADDRESS#)>#IP_ADDRESS#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
                <th><cf_get_lang dictionary_id='55112.Bilgisayar Adı'></th>
            </tr>
            <tr>
                <td><cfif len(#EMPLOYEE_NO#)>#EMPLOYEE_NO#<cfelse>-</cfif></td>
                <td><cfif len(#COMPUTER_NAME#)>#COMPUTER_NAME#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                <th><cf_get_lang dictionary_id='57761.Hiyerarşi'></th>
            </tr>
            <tr>
                <td><cfif len(#GROUP_STARTDATE#)>#GROUP_STARTDATE#<cfelse>-</cfif></td>
                <td><cfif len(#HIERARCHY#)>#HIERARCHY#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='30337.Özel Kod 1'></th>
                <th><cf_get_lang dictionary_id='30338.Özel Kod 2'></th>
            </tr>
            <tr>
                <td><cfif len(#OZEL_KOD#)>#OZEL_KOD#<cfelse>-</cfif></td>
                <td><cfif len(#OZEL_KOD2#)>#OZEL_KOD2#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='53512.Kıdem Tarihi'></th>
                <th><cf_get_lang dictionary_id='59811.İzin Tarihi'></th>
            </tr>
            <tr>
                <td><cfif len(#KIDEM_DATE#)>#KIDEM_DATE#<cfelse>-</cfif></td>
                <td><cfif len(#IZIN_DATE#)>#IZIN_DATE#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='60068.Kritik'></th>
                <th><cf_get_lang dictionary_id='60069.Expiry Tarihi'></th>
            </tr>
            <tr>
                <td><cfif len(#IS_CRITICAL#)>#IS_CRITICAL#<cfelse>-</cfif></td>
                <td><cfif len(#EXPIRY_DATE#)>#EXPIRY_DATE#<cfelse>-</cfif></td>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='57576.Çalışan'> <cf_get_lang dictionary_id='52765.Stage'></th>
                <th><cf_get_lang dictionary_id='31565.Biyografi'></th>
            </tr>
            <tr>
                <td><cfif len(#EMPLOYEE_STAGE#)>#EMPLOYEE_STAGE#<cfelse>-</cfif></td>
            </tr>
            
        </table>

    </cfoutput>

<!---</cfif>--->
</cf_box>
</div>
 




