<!--- Standart Print Sablonu Borc Alacak Dekontu FB 20080115 --->
<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
	<cfset columnName = 'MULTI_ACTION_ID'>
    <cfset attributes.action_id = multi_id>
<cfelse>
	<cfset columnName = 'ACTION_ID'>
</cfif>
<cfquery name="get_note" datasource="#dsn2#">
	SELECT * FROM CARI_ACTIONS WHERE #columnName# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfset fatura_verilen = ''>
<cfset adres = ''>
<cfset telcode =''>
<cfset tel =''>
<cfset faxcode =''>
<cfset fax =''>
<cfset actionTotal = 0>
<cfquery name="check" datasource="#dsn#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("session.ep.company_id")>
		COMP_ID = #session.ep.company_id#
	<cfelseif isDefined("session.pp.company")>	
		COMP_ID = #session.pp.company#
	</cfif>
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1 AND
		MONEY <> '#session.ep.money#'
</cfquery>
<br/>
<table width="650" border="1" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="3" height="100" valign="top"><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="center" colspan="2">
					<font size="2"><strong>
					<cfif get_note.ACTION_TYPE_ID eq 41><cf_get_lang dictionary_id='57849.BORÇ DEKONTU'></cfif>
					<cfif get_note.ACTION_TYPE_ID eq 42><cf_get_lang dictionary_id='57848.ALACAK DEKONTU'></cfif>
					</strong></font>
				</td>
			</tr>
            <tr>
                <td colspan="2">
                <cfoutput query="check">
                <table border="0" cellpadding="0" cellspacing="0" width="98%" align="center">
                    <tr>
                        <td width="60%">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td colspan="2" class="formbold"> #company_name#</td>
                            </tr>
                            <tr>
                                <td width="20" valign="top"><cf_get_lang dictionary_id='58723.ADRES'></td>
                                <td>: #address#</td>
                            </tr>
                            <tr>
                                <td valign="top"><cf_get_lang dictionary_id='57499.TEL'></td>
                                <td>: #tel_code# - #tel#  #tel2#  #tel3# #tel4#</td>
                            </tr>
                            <tr>
                                <td valign="top"><cf_get_lang dictionary_id='57488.FAX'></td>
                                <td>: #fax#</td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="40"><cf_get_lang dictionary_id='57946.Fiş No'></td>
                                <td>: #GET_NOTE.ACTION_ID#</td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id='57742.Tarih'></td>
                                <td>: #dateformat(GET_NOTE.ACTION_DATE,dateformat_style)#</td>
                            </tr>
                        </table>
                        </td>
                        <td width="40%" style="text-align:right;" valign="top">
                        <cf_get_server_file 
                        output_file="settings/#CHECK.asset_file_name2#" 
                        output_server="#CHECK.asset_file_name2_server_id#" 
                        output_type="5" image_width="300">
                        </td>
                    </tr>
                </table>
                </cfoutput>
                </td>
            </tr>
		</table>
		</td>
	</tr>
	<tr align="center" height="30" class="formbold">
		<td><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
		<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
		<td><cf_get_lang dictionary_id='57673.Tutar'></td>
	</tr>
    <cfoutput query="get_note">
        <tr height="30" class="formbold">
            <td>&nbsp;
              <cfif len(get_note.from_cmp_id)>
                #get_par_info(get_note.from_cmp_id,1,1,0)#
               <cfelseif len(get_note.to_cmp_id)>
                #get_par_info(get_note.to_cmp_id,1,1,0)#
              <cfelseif len(get_note.from_consumer_id)>
                #get_cons_info(get_note.from_consumer_id,0,0)#
              <cfelseif len(get_note.to_consumer_id)>
                #get_cons_info(get_note.to_consumer_id,0,0)#
            <cfelseif len(get_note.to_employee_id)>
                #get_emp_info(get_note.to_employee_id,0,0)#
             <cfelseif len(get_note.from_employee_id)>
                #get_emp_info(get_note.from_employee_id,0,0)#
              </cfif>
            </td>
            <td>&nbsp;#get_note.ACTION_DETAIL#</td>
            <td align="center">&nbsp;
				<cfset actionTotal += get_note.ACTION_VALUE>
                #tlformat(get_note.ACTION_VALUE)# #get_note.ACTION_CURRENCY_ID#
            </td>	
        </tr>
    </cfoutput>	
	<tr>
		<td colspan="3" valign="top"><br/>
		<table width="95%" border="0">
		<cfoutput>
			<tr>
				<td height="50" valign="top"><cf_get_lang dictionary_id='58957.İmza'> : </td>
			</tr>
			<tr>
				<td><cf_get_lang no="831.Yazıyla"> :
					<cfset myNumber = actionTotal>
					<cf_n2txt number="myNumber" para_birimi="#get_note.ACTION_CURRENCY_ID#">#myNumber#
				</td>
			</tr>
		</cfoutput>
		</table>
		</td>
	</tr>
</table>