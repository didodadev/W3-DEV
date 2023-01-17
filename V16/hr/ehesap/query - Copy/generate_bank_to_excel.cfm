<cfsetting showdebugoutput="no">
<cfquery name="get_payment_info" datasource="#dsn#">
	SELECT 
    	BANK_PAYMENT_ID, 
        BANK_ID, 
        BANK_NAME, 
        PAY_YEAR, 
        PAY_MON, 
        PAY_DATE, 
        XML_FILE_NAME, 
        XML_FILE_SERVER_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        OUR_COMPANY_ID, 
        RELATED_COMPANY, 
        BRANCH_ID, 
        PAYMENT_TYPE, 
        TOTAL_ROWS, 
        TOTAL_AMOUNT, 
        TOTAL_AMOUNT_MONEY 
    FROM
	    EMPLOYEES_BANK_PAYMENTS 
    WHERE 
    	BANK_PAYMENT_ID = #attributes.payment_id#
</cfquery>
<cfif get_payment_info.XML_FILE_SERVER_ID neq fusebox.server_machine>
	<script type="text/javascript">
		alert('Farklı Kurulumda Oluşturulan Dosyayı Burada Yorumlayamazsınız!');
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cffile action="read" file="#upload_folder##get_payment_info.XML_FILE_NAME#" variable="dosya">
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya1 = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya1);
</cfscript>

<cfquery name="get_bank_info" datasource="#dsn#">
	SELECT 
    	BANK_ID, 
        BANK_NAME, 
        COMPANY_ID, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        EXPORT_TYPE 
    FROM 
	    SETUP_BANK_TYPES 
    WHERE 
    	BANK_ID = #get_payment_info.bank_id#
</cfquery>
<cfset export_type_ = get_bank_info.export_type>

<cfif len(get_payment_info.BRANCH_ID)>
	<cfquery name="get_branch_info" datasource="#dsn#">
		SELECT BRANCH_FULLNAME FROM BRANCH WHERE BRANCH_ID = #get_payment_info.BRANCH_ID#
	</cfquery>
	<cfset branch_name_ = get_branch_info.BRANCH_FULLNAME>
<cfelse>
	<cfset branch_name_ = "">
</cfif>
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#get_payment_info.XML_FILE_NAME#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfset exp_type_list = '1,2,3,4,5,6'>
<cfif listfind(exp_type_list,export_type_,',')>
	<table>
		<tr class="formbold">
			<td>Sıra</td>
			<td>TC Kimlik</td>
			<td>Ad Soyad</td>
			<td>Şube</td>
			<td>İlgili Şirket</td>
			<td>Banka Şubesi</td>
			<td>Banka Hesap No</td>
			<td>İlgili Ay</td>
			<td>İlgili Yıl</td>
			<td>Ödeme Tarihi</td>
			<td>Tutar</td>
		</tr>
	<cfif export_type_ eq 1><!--- yapi kredi --->
		<cfloop from="2" to="#line_count#" index="i">
			<cfset bank_hesap_no = val(trim(left(dosya1[i],8)))>
			<cfset tutar_ = trim(mid(dosya1[i],43,15))>
			<cfset tam_kisim = val(listfirst(tutar_,'.'))>
			<cfset ondalik_kisim = listlast(tutar_,'.')>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
					(
					<cfloop from="#len(bank_hesap_no)#" to="8" index="ccc">
						EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO = '<cfloop from="1" to="#8-ccc#" index="mmm">0</cfloop>#bank_hesap_no#' <cfif ccc neq 8>OR</cfif>
					</cfloop>
					)
			</cfquery>
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#i-1#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tam_kisim#.#ondalik_kisim#</td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	<cfelseif export_type_ eq 2><!--- teb --->
		<cfloop from="2" to="#line_count-1#" index="i">
			<cfset bank_hesap_no = val(trim(mid(dosya1[i],11,8)))>
			<cfset tutar_ = trim(mid(dosya1[i],23,19))>
			<cfset tam_kisim = val(listfirst(tutar_,'.'))>
			<cfset ondalik_kisim = listlast(tutar_,'.')>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
					(
					<cfloop from="#len(bank_hesap_no)#" to="8" index="ccc">
						EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO = '<cfloop from="1" to="#8-ccc#" index="mmm">0</cfloop>#bank_hesap_no#' <cfif ccc neq 8>OR</cfif>
					</cfloop>
					)
			</cfquery>
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#i-1#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tam_kisim#.#ondalik_kisim#</td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	<cfelseif export_type_ eq 3><!--- isbank --->
		<cfloop from="2" to="#line_count-1#" index="i">
			<cfset bank_hesap_no = val(trim(mid(dosya1[i],7,7)))>
			<cfset tutar_ = trim(mid(dosya1[i],14,16))>
			<cfset tam_kisim = val(listfirst(tutar_,'.'))>
			<cfset ondalik_kisim = listlast(tutar_,'.')>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
					(
					<cfloop from="#len(bank_hesap_no)#" to="7" index="ccc">
						EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO = '<cfloop from="1" to="#7-ccc#" index="mmm">0</cfloop>#bank_hesap_no#' <cfif ccc neq 7>OR</cfif>
					</cfloop>
					)
			</cfquery>
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#i-1#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tutar_#<!---#tam_kisim#.#ondalik_kisim#---></td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	<cfelseif export_type_ eq 4><!--- denizbank --->
		<cfloop from="2" to="#line_count-1#" index="i">
			<cfset bank_hesap_no = trim(mid(dosya1[i],2,26))>
			<cfset tutar_ = trim(mid(dosya1[i],29,18))>
            <cfset tam_kisim = val(listfirst(tutar_,'.'))>
            <cfset ondalik_kisim = listlast(tutar_,'.')>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
					EMPLOYEES_BANK_ACCOUNTS.IBAN_NO = '#bank_hesap_no#'
			</cfquery>			
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#currentrow#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tam_kisim#.#ondalik_kisim#</td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	<cfelseif export_type_ eq 5><!--- akbank --->
		<cfloop from="2" to="#line_count#" index="i">
			<cfset bank_hesap_no = trim(mid(dosya1[i],23,26))>
			<cfset tam_kisim = trim(mid(dosya1[i],77,4))>
			<cfset ondalik_kisim = trim(mid(dosya1[i],81,2))>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE,
					EMPLOYEES_BANK_ACCOUNTS.IBAN_NO
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
                    EMPLOYEES_BANK_ACCOUNTS.IBAN_NO ='#bank_hesap_no#'

			</cfquery>
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#i#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tam_kisim#.#ondalik_kisim#</td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	<cfelseif export_type_ eq 6><!--- hsbc --->
		<cfloop from="1" to="#line_count#" index="i">
			<cfset bank_hesap_no = val(trim(mid(dosya1[i],19,12)))>
			<cfset tam_kisim = val(trim(mid(dosya1[i],74,12)))>
			<cfset ondalik_kisim = trim(mid(dosya1[i],87,2))>
			<cfquery name="get_user_" datasource="#dsn#">
				SELECT
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_NAME,
					EMPLOYEES_BANK_ACCOUNTS.BANK_BRANCH_CODE
				FROM
					EMPLOYEES_BANK_ACCOUNTS,
					EMPLOYEES,
					EMPLOYEES_IDENTY
				WHERE
                	EMPLOYEES.EMPLOYEE_STATUS = 1 AND
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_BANK_ACCOUNTS.EMPLOYEE_ID AND 
					EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
					EMPLOYEES_BANK_ACCOUNTS.BANK_ID = #get_payment_info.bank_id# AND
					(
					<cfloop from="#len(bank_hesap_no)#" to="12" index="ccc">
						EMPLOYEES_BANK_ACCOUNTS.BANK_ACCOUNT_NO = '<cfloop from="1" to="#12-ccc#" index="mmm">0</cfloop>#bank_hesap_no#' <cfif ccc neq 12>OR</cfif>
					</cfloop>
					)
			</cfquery>
			<cfif get_user_.recordcount>
				<cfoutput query="get_user_">
				<tr>
					<td>#i#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#branch_name_#</td>
					<td>#get_payment_info.RELATED_COMPANY#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#BANK_ACCOUNT_NO#</td>
					<td>#get_payment_info.PAY_MON#</td>
					<td>#get_payment_info.PAY_YEAR#</td>
					<td>#dateformat(get_payment_info.PAY_DATE,dateformat_style)#</td>
					<td>#tam_kisim#.#ondalik_kisim#</td>
				</tr>
				</cfoutput>
			</cfif>
		</cfloop>
	</cfif>
	</table>
</cfif>
