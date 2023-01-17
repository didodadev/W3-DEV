<cfquery name="GET_SETUP_SALARIES" datasource="#dsn#">
    SELECT 
	    UPDATE_ID, 
        UPDATE_PERCENT, 
        SAL_MON,
        CHANGE_ALL, 
        VALID_EMP, 
        VALID_DATE, 
        VALID, 
        VALIDATOR_POSITION, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP
    FROM 
    	SALARY_UPDATE
</cfquery>
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td height="35" class="headbold"><cf_get_lang dictionary_id='53292.Maaş Güncellemeleri'></td>
    </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="97%" align="center">
    <tr class="color-border">
        <td>
            <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
                <tr class="color-header" height="22">
                    <td class="form-title" width="100"><cf_get_lang dictionary_id='58455.Yıl'></td>
                    <td class="form-title" width="100"><cf_get_lang dictionary_id='53132.Başlama Ayı'></td>
                    <td class="form-title"><cf_get_lang dictionary_id='53293.Kimler Etkilensin'></td>
                    <td class="form-title" width="100">(&plusmn;) <cf_get_lang dictionary_id='57635.Miktar'></td>
                    <td width="115" class="form-title"><cf_get_lang dictionary_id='53042.Onay Durumu'></td>
                    <td width="65" class="form-title"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></td>
                    <td width="15" align="center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_add_setup_salary','medium')"><img src="/images/plus_square.gif" border="0"></a></td>
                </tr>
                <cfif get_setup_salaries.recordcount>
                <cfoutput query="get_setup_salaries">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <cfquery name="get_setup_salary_yearS" datasource="#dsn#">
                    	SELECT 
        	                UPDATE_ID, 
                            SAL_YEAR 
                        FROM 
    	                    SALARY_UPDATE_YEARS 
                        WHERE 
	                        UPDATE_ID = #UPDATE_ID#
                    </cfquery>
                    <td>&nbsp;#ValueList(get_setup_salary_yearS.sal_year)#</td>
                    <td>&nbsp;#ListGetAt(ay_list(),SAL_MON)#</td>
                    <td>&nbsp;
						<cfif CHANGE_ALL EQ 1>
                            <cf_get_lang dictionary_id='53294.Sadece İşaretliler'>
                        <cfelse>
                            <cf_get_lang dictionary_id='58081.Herkes'>
                        </cfif>
                    </td>
                    <td>&nbsp;
						<cfif SGN(update_percent) EQ 1>
                            +
                        <cfelse>
                            -
                        </cfif>
                        % #ABS(update_percent-100)#</td>
                    <td>&nbsp;
						<cfif valid eq 1>
                            Onaylandı - #dateformat(valid_date,dateformat_style)#
                            #get_emp_info(valid_emp,0,0)#
                        <cfelseif valid eq 0>
                            <cf_get_lang dictionary_id='57617.Reddedildi'> - #dateformat(valid_date,dateformat_style)#
                            #get_emp_info(valid_emp,0,0)#
                        <cfelse>
                            <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                            #get_emp_info(validator_position,1,0)#
                        </cfif>
                    </td>
                    <td>&nbsp;
						<cfif len(update_date)>
                        	#dateformat(update_date,dateformat_style)#
                        <cfelse>
                        	#dateformat(record_date,dateformat_style)#
                        </cfif>
                    </td>
                    <td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_setup_salary&update_id=#update_id#','medium')"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
                </cfoutput>
                <cfelse>
                    <tr class="color-row" height="20">
                        <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </table>
        </td>
    </tr>
</table>
