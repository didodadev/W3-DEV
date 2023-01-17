<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.related_company" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.pay_mon" default="">
<cfparam name="attributes.pay_year" default="#year(now())#">
<cfquery name="get_related_company" datasource="#dsn#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = 1 AND
		BRANCH_ID IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
			RELATED_COMPANY
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT DISTINCT
		BRANCH_NAME,
		BRANCH_ID,
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = 1 AND
		BRANCH_ID IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfset branch_id_list=''>
<cfset comp_id_list=''>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="get_bank_payments" datasource="#DSN#">
		SELECT DISTINCT
		  	EBP.OUR_COMPANY_ID,
			EBP.BRANCH_ID,
			EBP.RECORD_DATE,
			EBP.RELATED_COMPANY,
			EBP.PAYMENT_TYPE,
			EBP.PAY_YEAR,
			EBP.PAY_MON,
			EBP.TOTAL_ROWS,
			EBP.TOTAL_AMOUNT,
			EBP.TOTAL_AMOUNT_MONEY,
			EBP.PAY_DATE,
			EBP.XML_FILE_NAME,
			EBP.XML_FILE_SERVER_ID,
			EBP.BANK_PAYMENT_ID,
			EBP.BANK_NAME,
			(SELECT FTP_SERVER_NAME FROM SETUP_BANK_TYPES WHERE BANK_ID= EBP.BANK_ID) FTP_SERVER_NAME,
			SBT.EXPORT_TYPE
		FROM 
			EMPLOYEES_BANK_PAYMENTS EBP
			LEFT JOIN SETUP_BANK_TYPES SBT ON SBT.BANK_ID = EBP.BANK_ID
		WHERE
			EBP.BANK_PAYMENT_ID IS NOT NULL
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND	EBP.BRANCH_ID = #attributes.branch_id#
			</cfif>
			<cfif isdefined('attributes.related_company') and len(attributes.related_company)>
				AND	EBP.RELATED_COMPANY = '#attributes.related_company#'
			</cfif>
			<cfif isdefined('attributes.PAYMENT_TYPE_ID') and len(attributes.PAYMENT_TYPE_ID)>
				AND	EBP.PAYMENT_TYPE = #attributes.PAYMENT_TYPE_ID#
			</cfif>
            <cfif isdefined('attributes.pay_mon') and len(attributes.pay_mon)>
				AND	EBP.PAY_MON = #attributes.pay_mon#
			</cfif>
            <cfif isdefined('attributes.pay_year') and len(attributes.pay_year)>
				AND	EBP.PAY_YEAR = #attributes.pay_year#
			</cfif>
			<cfif not session.ep.ehesap>
				AND 
				(
					(
						EBP.BRANCH_ID IS NOT NULL AND EBP.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
					)
				OR
				<CFOUTPUT query="get_related_company">
					(
						EBP.RELATED_COMPANY LIKE '%#RELATED_COMPANY#%' 
					)
					<cfif currentrow neq recordcount>OR</cfif>
				</CFOUTPUT>
				OR
					(
					EBP.OUR_COMPANY_ID = #session.ep.company_id#
					AND
					EBP.BRANCH_ID IS NULL AND EBP.RELATED_COMPANY IS NULL
					)
				)
			</cfif>
		ORDER BY
			EBP.PAY_YEAR DESC,
			EBP.PAY_MON DESC,
			EBP.RECORD_DATE DESC,
			EBP.RELATED_COMPANY DESC
	</cfquery>
	<cfif get_bank_payments.recordcount>
		<cfoutput query="get_bank_payments">
			<cfif len(branch_id) and not listfind(branch_id_list,branch_id)>
				<cfset branch_id_list=listappend(branch_id_list,branch_id)>
			</cfif>
			<cfif len(our_company_id) and not listfind(comp_id_list,our_company_id)>
				<cfset comp_id_list=listappend(comp_id_list,our_company_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(branch_id_list)>
			<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",',')>
			<cfquery name="GET_BRANCH_NAME" datasource="#dsn#">
				SELECT
					BRANCH_NAME,
					BRANCH_ID
				FROM 
					BRANCH
				WHERE
					BRANCH_ID IN (#branch_id_list#)
				ORDER BY
					BRANCH_ID
			</cfquery>
		</cfif>
		<cfif listlen(comp_id_list)>
			<cfset comp_id_list=listsort(comp_id_list,"numeric","ASC",',')>
			<cfquery name="get_our_companies" datasource="#DSN#">
				SELECT
					NICK_NAME,
					COMP_ID
				FROM
					OUR_COMPANY
				WHERE
					COMP_ID IN (#comp_id_list#)
				ORDER BY
					COMP_ID
			</cfquery>
		</cfif>
	</cfif>

	<cfset arama_yapilmali=0>
	<cfparam name="attributes.totalrecords" default="#get_bank_payments.recordcount#">
<cfelse>
	<cfset get_bank_payments.recordcount=0>
	<cfset arama_yapilmali=1>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset excel_exp_type_list = '7,8,9,11'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_payments" method="post" action="#request.self#?fuseaction=ehesap.list_bank_payment_emps">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cf_box_search>
				<div class="form-group">
					<select name="PAYMENT_TYPE_ID" id="PAYMENT_TYPE_ID">
						<option value=""><cf_get_lang dictionary_id='58928.Ödeme Tipi'></option>								
						<option value="1" <cfif isdefined("attributes.PAYMENT_TYPE_ID") and attributes.PAYMENT_TYPE_ID EQ 1>selected</cfif>><cf_get_lang dictionary_id ='58544.Sabit'></option>
						<option value="3" <cfif isdefined("attributes.PAYMENT_TYPE_ID") and attributes.PAYMENT_TYPE_ID EQ 3>selected</cfif>><cf_get_lang dictionary_id ='53558.Primli'></option>								
						<option value="2" <cfif isdefined("attributes.PAYMENT_TYPE_ID") and attributes.PAYMENT_TYPE_ID EQ 2>selected</cfif>><cf_get_lang dictionary_id ='58204.Avans'></option>								
					</select> 
				</div>
				<div class="form-group">
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
						<cfoutput query="get_branch">
							<option value="#branch_id#" <cfif attributes.branch_id is branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="related_company" id="related_company">
						<option value=""><cf_get_lang dictionary_id ='53776.İlişkili Şirket'></option>
						<cfoutput query="get_related_company">
							<cfif len(related_company)>
								<option value="#related_company#" <cfif attributes.related_company is related_company>selected</cfif>>#related_company#</option>
							</cfif>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="pay_mon" id="pay_mon">
						<option value=""><cf_get_lang dictionary_id ='58724.Ay'></option>
						<cfoutput>
						<cfloop from="1" to="12" index="i">
							<option value="#i#" <cfif attributes.pay_mon is i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
						</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="pay_year" id="pay_year">
						<option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
						<cfloop from="-3" to="3" index="i">
							<cfoutput><option value="#year(now()) + i#"<cfif attributes.pay_year eq (year(now()) + i)> selected</cfif>>#year(now()) + i#</option></cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53480.Banka Ödeme Emirleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
					<th><cf_get_lang dictionary_id ='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='58455.Yıl'></th>
					<th><cf_get_lang dictionary_id='58724.Ay'></th>
					<th><cf_get_lang dictionary_id ='29831.Kişi'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
					<th width="20"><a title="<cf_get_lang dictionary_id='29728.Dosya İndir'>"><i class="fa fa-download"></i></a></th>
					<th width="20"><a title="FTP <cf_get_lang dictionary_id='58743.Gönder'>"><i class="fa fa-upload"></i></a></th>
					<th width="20"><a title="<cf_get_lang dictionary_id ='53780.Excel Olarak Gönder'>"><i class="fa fa-file-excel-o"></i></a></th>
					<!-- sil -->
					<th width="20" style="text-align:center;" nowrap="nowrap" class="header_icn_none text-center">
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_bank_payment_emps&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_varmi") and get_bank_payments.recordcount>
					<cfoutput query="get_bank_payments"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<cfif len(branch_id)>
										#get_branch_name.BRANCH_NAME[listfind(branch_id_list,branch_id,',')]#
									<cfelseif len(related_company)>
										#related_company#
									<cfelseif len(our_company_id)>
										#get_our_companies.nick_name[listfind(comp_id_list,OUR_COMPANY_ID,',')]#		
								</cfif>
							</td>
							<td>#bank_name#</td>
							<td><cfif payment_type eq 1>
										<cf_get_lang dictionary_id ='58544.Sabit'>
									<cfelseif payment_type eq 2>
										<cf_get_lang dictionary_id ='58204.Avans'>
									<cfelseif payment_type eq 3>
										<cf_get_lang dictionary_id ='53558.Primli'>
									<cfelseif payment_type eq 4>
										<cf_get_lang dictionary_id ='53785.Sabit Primli'>	
								</cfif>
							</td>
							<td>#pay_year#</td>
							<td>#listgetat(ay_list(),pay_mon,',')#</td>
							<td>#total_rows#</td>
							<td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount)#"> #total_amount_money#</td>
							<td>#dateformat(pay_date,dateformat_style)#</td>
							<!-- sil -->
							<td>
								<cfif fusebox.server_machine eq xml_file_server_id>
								<a title="<cf_get_lang dictionary_id='29728.Dosya İndir'>" href="#request.self#?fuseaction=objects.popup_download_file&file_name=hr/eislem/#xml_file_name#"><i class="fa fa-download"></i></a>
							<cfelse>
								<cf_get_server_file output_file="hr/eislem/#xml_file_name#" output_server="#xml_file_server_id#" output_type="2" icon="fa fa-download" alt="#getLang('','settings',29728)#" image_link="2">
							</cfif>
							</td>
							<td>
								<cfif len(ftp_server_name)>
									<a title="FTP <cf_get_lang dictionary_id='58743.Gönder'>" href="#request.self#?fuseaction=ehesap.emptypopup_send_file_ftp&payment_id=#bank_payment_id#"><i class="fa fa-upload"></i></a>
								</cfif>
							</td>
							<td>
								<cfif listfind(excel_exp_type_list,export_type)>
									<cfif find('.',xml_file_name) gt 0 and (right(xml_file_name,len(xml_file_name)-find('.',xml_file_name)) is 'xls' or right(xml_file_name,len(xml_file_name)-find('.',xml_file_name)) is 'xlsx')>
										<cfif fusebox.server_machine eq xml_file_server_id>
											<a title="<cf_get_lang dictionary_id ='53780.Excel Olarak Gönder'>" href="#request.self#?fuseaction=objects.popup_download_file&file_name=hr/eislem/#xml_file_name#"><i class="fa fa-file-excel-o"></i></a>
										<cfelse>
											<cf_get_server_file output_file="hr/eislem/#xml_file_name#" output_server="#xml_file_server_id#" output_type="2" icon="fa fa-file-excel-o" alt="#getLang('','settings',53780)#" image_link="2">
										</cfif>
									</cfif>
								<cfelse>
									<a title="<cf_get_lang dictionary_id ='53780.Excel Olarak Gönder'>" href="#request.self#?fuseaction=ehesap.emptypopup_generate_bank_to_excel&payment_id=#bank_payment_id#"><i class="fa fa-file-excel-o"></i></a>
								</cfif>
							</td>
							<td align="center" nowrap="nowrap" id="bank_info_td_#bank_payment_id#"><div style="display:;" id="bank_info_#bank_payment_id#"></div>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53795.Ödeme Emrini Siliyorsunuz Emin Misiniz'></cfsavecontent>
								<a href="javascript://" onClick="if(confirm('#message#')) AjaxPageLoad('#request.self#?fuseaction=ehesap.emptypopup_del_bank_payment_emps&payment_id=#bank_payment_id#','bank_info_#bank_payment_id#',0,'Siliniyor',''); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>" alt="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="13"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres="ehesap.list_bank_payment_emps">
		<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
			<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#" >
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfset adres = "#adres#&branch_id=#attributes.branch_id#" >
		</cfif>
		<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
			<cfset adres = "#adres#&related_company=#attributes.related_company#" >
		</cfif>
		<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
			<cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#" >
		</cfif>
		<cfif isdefined("attributes.pay_mon") and len(attributes.pay_mon)>
			<cfset adres = "#adres#&pay_mon=#attributes.pay_mon#" >
		</cfif>
		<cfif isdefined("attributes.pay_year") and len(attributes.pay_year)>
			<cfset adres = "#adres#&pay_year=#attributes.pay_year#" >
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>