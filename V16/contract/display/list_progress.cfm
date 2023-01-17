<cf_xml_page_edit fuseact="contract.list_progress">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.progress_type" default="">
<cfparam name="attributes.is_invoice" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.order_progress" default="4">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
	<cfif Len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif Len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	<cfquery name="get_progress_payment" datasource="#dsn3#">
		SELECT
			PP.*,
			ISNULL(RC.CONTRACT_TAX,0) AS CONTRACT_TAX,
            ISNULL(RC.STOPPAGE_RATE,0) AS STOPPAGE_RATE,
            RC.STOPPAGE_RATE_ID,
			PRO_PROJECTS.PROJECT_HEAD,
			PRO_PROJECTS.DEPARTMENT_ID,
			PRO_PROJECTS.LOCATION_ID,
			COMPANY.FULLNAME AS COMPANY_NAME,
			CONSUMER.CONSUMER_NAME +' '+  CONSUMER.CONSUMER_SURNAME AS CONSUMER_NAME
		FROM 
			PROGRESS_PAYMENT PP
			LEFT JOIN RELATED_CONTRACT RC ON RC.CONTRACT_ID = PP.CONTRACT_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PP.PROJECT_ID
			LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = PP.COMPANY_ID
			LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = PP.CONSUMER_ID
            <cfif len(attributes.is_invoice)>
            	LEFT JOIN #dsn2_alias#.INVOICE ON INVOICE.PROGRESS_ID = PP.PROGRESS_ID AND FROM_PROGRESS = 1
            </cfif>
		WHERE
			1 = 1
			<cfif len(attributes.company_id) and len(attributes.company)>
				AND PP.COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.company)>
				AND PP.CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
			</cfif>
			<cfif len(attributes.keyword)>
				AND PP.PROGRESS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				AND PP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
				AND PP.RECORD_EMP = #attributes.record_emp_id#
			</cfif>
			<cfif attributes.is_invoice eq 1>
				AND INVOICE_NUMBER IS NOT NULL
			<cfelseif attributes.is_invoice eq 2>
				AND INVOICE_NUMBER IS NULL
			</cfif>
			<cfif attributes.progress_type eq 1>
				AND PP.PROGRESS_TYPE = 1
			<cfelseif attributes.progress_type eq 2>
				AND PP.PROGRESS_TYPE = 2
			</cfif>
			<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
				AND PROGRESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			<cfelseif isdate(attributes.startdate)>
				AND PROGRESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			<cfelseif isdate(attributes.finishdate)>
				AND PROGRESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			</cfif>
            <cfif len(attributes.order_progress)>
            	ORDER BY
				<cfif attributes.order_progress eq 1>
                    PROGRESS_DATE 
                <cfelseif attributes.order_progress eq 2>
                	PROGRESS_DATE DESC
     			<cfelseif attributes.order_progress eq 3>
                	CAST(REPLACE(PROGRESS_NO,'-','.')AS FLOAT)
                <cfelseif attributes.order_progress eq 4>
                	CAST(REPLACE(PROGRESS_NO,'-','.')AS FLOAT) DESC
                </cfif>
            </cfif>
	</cfquery>
<cfelse>
	<cfset get_progress_payment.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_progress_payment.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="related_contract" action="#request.self#?fuseaction=contract.list_progress" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:120px;" placeholder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="order_progress" id="order_progress">
						<option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
						<option value="1" <cfif attributes.order_progress eq 1>selected</cfif>><cf_get_lang dictionary_id='58925.Tarihe Göre'><cf_get_lang dictionary_id='29826.Artan'></option>
						<option value="2" <cfif attributes.order_progress eq 2>selected</cfif>><cf_get_lang dictionary_id='58925.Tarihe Göre'><cf_get_lang dictionary_id='29827.Azalan'></option>
						<option value="3" <cfif attributes.order_progress eq 3>selected</cfif>><cf_get_lang dictionary_id='57880.Belge No'><cf_get_lang dictionary_id='29826.Artan'></option>
						<option value="4" <cfif attributes.order_progress eq 4>selected</cfif>><cf_get_lang dictionary_id='57880.Belge No'><cf_get_lang dictionary_id='29827.Azalan'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="progress_type" id="progress_type">
						<option value="" <cfif attributes.progress_type eq ''>selected</cfif>><cf_get_lang dictionary_id='50779.Hakediş'> <cf_get_lang dictionary_id='58651.Türü'></option>
						<option value="1" <cfif attributes.progress_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58176.Alış'></option>
						<option value="2" <cfif attributes.progress_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="is_invoice" id="is_invoice">
						<option value="" <cfif attributes.is_invoice eq ''>selected</cfif>><cf_get_lang dictionary_id='57441.Fatura'><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1" <cfif attributes.is_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id='50721.Fatura Kesilmiş'></option>
						<option value="2" <cfif attributes.is_invoice eq 2>selected</cfif>><cf_get_lang dictionary_id='50723.Fatura Kesilmemiş'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-project_head">
							<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)>#attributes.project_id#</cfif>">
									<input type="text" name="project_head"  id="project_head" style="width:120px;"value="<cfif len(attributes.project_head)>#UrlDecode(attributes.project_head)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-record_emp_name">
							<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
									<input name="record_emp_name" type="text"  id="record_emp_name" style="width:120px;"  onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','form','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.record_emp_name&field_emp_id=form.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-company">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="#attributes.consumer_id#"</cfif>>			
									<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="#attributes.company_id#"</cfif>>
									<input type="text" name="company" id="company" value="<cfif len(attributes.company)>#attributes.company#</cfif>" style="width:120px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','related_contract','3','150');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=related_contract.company&field_comp_id=related_contract.company_id&field_consumer=related_contract.consumer_id&field_member_name=related_contract.company&select_list=2,3&keyword='+encodeURIComponent(document.related_contract.company.value),'list')" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-startdate">
							<label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
									<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_date#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
									<span class="input-group-addon no-bg"></span>
									<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_date#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(344,'Hakedişler',51044)#" uidrop="1" hide_table_column="1">
		<cfform name="add_hakedis_fatura" action="" method="post" target="_new">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th><cf_get_lang dictionary_id="58133.Fatura No"></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						<th><cf_get_lang dictionary_id='58716.KDV li Toplam'></th>
						<!-- sil --><th width="20" class="header_icn_none"></th><!-- sil -->
						<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=contract.list_progress&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif get_progress_payment.recordcount>
						<cfoutput query="get_progress_payment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">  
							<tr>
								<td>#currentrow#</td>
								<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=contract.list_progress&event=det&id=#progress_id#','wide');">#progress_no#</a></td>
								<td><cfquery name="get_invoice" datasource="#dsn2#">
										SELECT INVOICE_NUMBER FROM INVOICE WHERE PROGRESS_ID = #progress_id# AND FROM_PROGRESS = 1
									</cfquery>
									<cfif get_invoice.recordcount>
										#valuelist(get_invoice.invoice_number,',')#
									</cfif>
								</td>
								<td><cfif progress_type eq 1><cf_get_lang dictionary_id="50758.Alınan Hakediş Belgesi"><cfelse><cf_get_lang dictionary_id="50764.Verilen Hakediş Belgesi"></cfif></td>
								<td>#dateformat(progress_date,dateformat_style)#</td>
								<td>
								<cfif len(company_name)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#company_name#</a>
								<cfelseif len(consumer_name)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#consumer_name#</a>
								</cfif>
								</td>
								<td><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a></td></td>
								<td>#TLFormat(progress_value,2)#</td>
								<td>#PROGRESS_CURRENCY_ID#</td>
								<td><cfif CONTRACT_TAX neq 0>#TLFormat((progress_value+(progress_value*CONTRACT_TAX)/100),2)#<cfelse>#TLFormat(progress_value,2)#</cfif></td>
								<!-- sil --><td align="center" width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#progress_id#&print_type=481','print_page');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></a></td>
								<td align="center" width="15">
								<cfif x_total_amount eq 1>
									<cfquery name="get_kdv_total" datasource="#dsn2#">
										SELECT 
											SUM(IR.PRICE_OTHER) TOTAL
										FROM 
											INVOICE I,
											INVOICE_ROW IR
										WHERE
											I.INVOICE_ID=IR.INVOICE_ID AND
											I.CONTRACT_ID=#contract_id# AND
											I.IS_IPTAL = 0
											<cfif progress_type eq 1>
												AND I.PURCHASE_SALES = 0
											<cfelse>
												AND I.PURCHASE_SALES = 1
											</cfif> 
									</cfquery>
									<!---<cfif gross_progress_value lte get_kdv_total.TOTAL>
										<cfset x_display=1>
									</cfif>--->
								</cfif>
								<cfif not isdefined("get_kdv_total") or (isdefined('get_kdv_total') and gross_progress_value gt get_kdv_total.TOTAL)>
									<input type="image" src="/images/notkalem.gif" onClick="KontrolEt_Gonder(#progress_type#,#currentrow#);" title="Fatura Kes">
								</cfif>
							</td><!-- sil -->
							</tr>
							<input type="hidden" name="project_id_#currentrow#" id="project_id_#currentrow#" value="#project_id#" />
							<input type="hidden" name="department_id_#currentrow#" id="department_id_#currentrow#" value="#department_id#">
							<input type="hidden" name="location_id_#currentrow#" id="location_id_#currentrow#" value="#location_id#">
							<input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#stock_id#">
							<input type="hidden" name="net_total_#currentrow#" id="net_total_#currentrow#" value="#progress_value#" />
							<input type="hidden" name="net_total_money_#currentrow#" id="net_total_money_#currentrow#" value="#PROGRESS_CURRENCY_ID#" />
							<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#" />
							<input type="hidden" name="invoice_tax_#currentrow#" id="invoice_tax_#currentrow#" value="#contract_tax#" />
							<input type="hidden" name="contract_id_#currentrow#" id="contract_id_#currentrow#" value="#contract_id#" />
							<input type="hidden" name="progress_id_#currentrow#" id="progress_id_#currentrow#" value="#progress_id#" />
							<cfset stoppage_amount = (gross_progress_value*stoppage_rate)/100>
							<input type="hidden" name="stoppage_amount_#currentrow#" id="stoppage_amount_#currentrow#" value="#stoppage_amount#" />
							<input type="hidden" name="stoppage_rate_#currentrow#" id="stoppage_rate_#currentrow#" value="#stoppage_rate#" />
							<input type="hidden" name="stoppage_rate_id_#currentrow#" id="stoppage_rate_id_#currentrow#" value="#stoppage_rate_id#" />
						</cfoutput> 
					<cfelse>
						<tr>
							<td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
					</cfif>
					<input type="hidden" name="net_total_money" id="net_total_money" value="" />
					<input type="hidden" name="net_total" id="net_total" value="" />
					<input type="hidden" name="company_id" id="company_id" value="" />
					<input type="hidden" name="project_id" id="project_id" value="" />
					<input type="hidden" name="stock_id" id="stock_id" value="" />
					<input type="hidden" name="department_id" id="department_id" value="" />
					<input type="hidden" name="location_id" id="location_id" value="" />
					<input type="hidden" name="invoice_tax" id="invoice_tax" value="" />
					<input type="hidden" name="contract_id" id="contract_id" value="" />
					<input type="hidden" name="progress_id" id="progress_id" value="" />
					<input type="hidden" name="stoppage_amount" id="stoppage_amount" value="" />
					<input type="hidden" name="stoppage_rate" id="stoppage_rate" value="" />
					<input type="hidden" name="stoppage_rate_id" id="stoppage_rate_id" value="" />
				</tbody>
			</cf_grid_list>
		</cfform>
		<cfset url_str = "&form_submitted=1">
		<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
		<cfif isdefined("attributes.order_progress")><cfset url_str = "#url_str#&order_progress=#attributes.order_progress#"></cfif>
		<cfif Len(attributes.startdate)><cfset url_str = "#url_str#&startdate=#attributes.startdate#"></cfif>
		<cfif Len(attributes.finishdate)><cfset url_str = "#url_str#&finishdate=#attributes.finishdate#"></cfif>
		<cfif Len(attributes.company_id) and Len(attributes.company)><cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#"></cfif>
		<cfif Len(attributes.consumer_id) and Len(attributes.company)><cfset url_str = "#url_str#&company=#attributes.company#&consumer_id=#attributes.consumer_id#"></cfif>
		<cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset url_str = "#url_str#&project_head=#attributes.project_head#&project_id=#attributes.project_id#"></cfif>
		<cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)><cfset url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#&record_emp_name=#attributes.record_emp_name#"></cfif>
		<cfif Len(attributes.progress_type)><cfset url_str = "#url_str#&progress_type=#attributes.progress_type#"></cfif>
		<cfif Len(attributes.is_invoice)><cfset url_str = "#url_str#&is_invoice=#attributes.is_invoice#"></cfif>

		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction##url_str#"> 
	</cf_box>
</div>
<script language="javascript">
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if( !date_check(document.getElementById('startdate'),document.getElementById('finishdate'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	function KontrolEt_Gonder(type,satir_no)
	{
		document.add_hakedis_fatura.project_id.value = eval('add_hakedis_fatura.project_id_' + satir_no).value;
		document.add_hakedis_fatura.department_id.value = eval('add_hakedis_fatura.department_id_' + satir_no).value;
		document.add_hakedis_fatura.location_id.value = eval('add_hakedis_fatura.location_id_' + satir_no).value;
		document.add_hakedis_fatura.stock_id.value = eval('add_hakedis_fatura.stock_id_' + satir_no).value;
		document.add_hakedis_fatura.company_id.value = eval('add_hakedis_fatura.company_id_' + satir_no).value;
		document.add_hakedis_fatura.net_total.value = eval('add_hakedis_fatura.net_total_' + satir_no).value;
		document.add_hakedis_fatura.net_total_money.value = eval('add_hakedis_fatura.net_total_money_' + satir_no).value;
		document.add_hakedis_fatura.invoice_tax.value = eval('add_hakedis_fatura.invoice_tax_' + satir_no).value;
		document.add_hakedis_fatura.contract_id.value = eval('add_hakedis_fatura.contract_id_' + satir_no).value;
		document.add_hakedis_fatura.progress_id.value = eval('add_hakedis_fatura.progress_id_' + satir_no).value;
		
		document.add_hakedis_fatura.stoppage_amount.value = eval('add_hakedis_fatura.stoppage_amount_' + satir_no).value;
		document.add_hakedis_fatura.stoppage_rate.value = eval('add_hakedis_fatura.stoppage_rate_' + satir_no).value;
		document.add_hakedis_fatura.stoppage_rate_id.value = eval('add_hakedis_fatura.stoppage_rate_id_' + satir_no).value;
		
		if(type == 1)		
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>";
		else
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>";
			
		add_hakedis_fatura.submit();
	}
</script>
