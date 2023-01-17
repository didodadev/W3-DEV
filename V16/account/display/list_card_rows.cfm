<cfsetting showdebugoutput="no"><!--- ajax kullanıldığı için debug kapalı olmalı --->
<cf_get_lang_set module_name="account">
<cf_xml_page_edit fuseact="account.popup_list_card_rows">
<cfinclude template="../query/get_card_rows.cfm">
<cfset refurl="#CGI.HTTP_REFERER#">
<cfif isdefined("refurl") and len(refurl)>
    <cfset refurl_len=find('fuseaction',refurl)+11>
    <cfset refmodule="#mid(refurl,refurl_len,find('.',refurl,refurl_len)-refurl_len )#">
<cfelse>
    <cfset refmodule="">
</cfif>
<cfset total_a=0>
<cfset total_b=0>

<cfif not len(get_card_rows.card_id)>
	<!--- islem id ve islem tipi gonderilmişse, birlestirilmis muhasebe fisi olup olmadıgı kontrol ediliyor --->
	<cfif isdefined('attributes.process_cat') and len(attributes.process_cat) and isdefined('attributes.action_id') and len(attributes.action_id)>
		<cfinclude template="../query/get_card_save.cfm">
		<cfif get_card_save.recordcount>
			<cfquery name="get_card_no" datasource="#dsn2#">
				SELECT CARD_TYPE_NO,CARD_ID FROM ACCOUNT_CARD WHERE CARD_ID = #get_card_save.NEW_CARD_ID#
			</cfquery>
			<br /><font class="bold"><cf_get_lang dictionary_id='47479.Hareket Birleştirme Yapılmıştır! Muhasebe Modülünde'> !</font>
			<cfoutput>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_card_save.NEW_CARD_ID#','page');" class="tableyazi">
			<b>#get_card_no.CARD_TYPE_NO#</b>
			</a>
			</cfoutput>
			<font class="bold"><cf_get_lang dictionary_id='47480.Numaralı Fişten Kontrol Edebilirsiniz'>  !</font>
			<cfexit method="exittemplate">
		<cfelseif isDefined("attributes.period_id") and attributes.period_id neq session.ep.period_id><!--- şirket dblerdeki kayıtlar için muh fişi görüntüleme (örn kk tahsilat)--->
			<br /><font class="bold"><cf_get_lang dictionary_id='47481.Muhasebe Fişi İlgili Dönemde Görüntülenmelidir'>!</font>
			<cfexit method="exittemplate">
		<cfelse>
			<br /><font class="bold"><cf_get_lang dictionary_id='47482.Seçtiğiniz İşlem İçin Muhasebe İşlemi Yapılmamaktadır'>!</font>
			<cfexit method="exittemplate">
		</cfif>
	<cfelse>
		<br /><font class="bold"><cf_get_lang dictionary_id='47482.Seçtiğiniz İşlem İçin Muhasebe İşlemi Yapılmamaktadır'>!</font>
		<cfexit method="exittemplate">
	</cfif>
</cfif>
<cfset acc_process_type= GET_CARD_ROWS.ACTION_TYPE><!--- get_acc_process_type_info.cfm'de kullanılıyor --->
<cfinclude template="../query/get_acc_process_type_info.cfm"><!--- money bilgileri --->
<cfif not (isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1) or isdefined("attributes.is_fast_sale")>
	<cfsavecontent variable="head">
		<cfif get_card_rows.card_type eq 10>
			<cf_get_lang dictionary_id='58756.Açılış Fişi'>
		  <cfelseif get_card_rows.card_type eq 11>
			<cf_get_lang dictionary_id='58844.Tahsil Fişi'>
		  <cfelseif get_card_rows.card_type eq 12>
			<cf_get_lang dictionary_id='58954.Tediye Fişi'>
		  <cfelseif get_card_rows.card_type eq 13>
			<cf_get_lang dictionary_id='58452.Mahsup Fişi'>
		  <cfelseif get_card_rows.card_type eq 14>
			<cf_get_lang dictionary_id='29435.Özel Fiş'>
		  </cfif>
		  <cf_get_lang dictionary_id='57487.No'>:
		  <cfoutput>
		  <cfif len(get_card_rows.card_type_no)>#get_card_rows.card_type_no#<cfelse>1</cfif>
		  - <cf_get_lang dictionary_id='39373.Yevmiye No'>: #get_card_rows.bill_no# - #dateformat(get_card_rows.action_date,dateformat_style)#
          <cfif session.ep.our_company_info.is_edefter eq 1><cfif len(GET_CARD_ROWS.document_type)> - <cf_get_lang dictionary_id='58533.Belge Tipi'> : #GET_CARD_ROWS.document_type#</cfif><cfif len(GET_CARD_ROWS.payment_type)> - <cf_get_lang dictionary_id='30057.Ödeme Şekli'> : #GET_CARD_ROWS.payment_type#</cfif></cfif>
          </cfoutput>
	</cfsavecontent>
	<cfsavecontent variable="right">
    	<cfif isDefined("attributes.card_id")>
	    	<cf_np tablename="ACCOUNT_CARD" primary_key = "CARD_ID" oby = "BILL_NO" dsn_var ="dsn2" pointer = "CARD_ID=#attributes.card_id#">
		</cfif>
		<cfoutput>
			<cfif get_card_rows.IS_COMPOUND eq 1 and session.ep.isBranchAuthorization eq 0>
				<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_cards&main_card_id=#get_card_rows.card_id#&is_add_page=1','longpage','muhasebe_list');"><i class="catalyst-plus" border="0" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='32032.Fiş Ekle'>" title= "<cf_get_lang dictionary_id='32032.Fiş Ekle'>"></i></a></li>
				<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_cards&form_varmi=1&fis_type=6&main_card_id=#get_card_rows.card_id#&is_delete_page=1','longpage','muhasebe_list');"><i class="fa fa-minus-circle" border="0" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='51822.Fiş Çıkar'>" title="<cf_get_lang dictionary_id='51822.Fiş Çıkar'>"></i></a></li>
				<!--- birleştirilmiş fiş gecici olarak çözülür, sonrasında geçiçi çözülmüş fişler listesinden birleştirilmiş fişi olusturan işlemlerin muhasebe fişleri yeniden birleştirilebilir. --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='47483.Birleştirilmiş Fiş Geçici Olarak Çözülecektir Emin misiniz'></cfsavecontent>
				<li><a href="##" onClick="javascript:if(confirm('#message#')) window.location.href='#request.self#?fuseaction=account.emptypopup_solve_card&card_id=#get_card_rows.CARD_ID#&is_temporary_solve=1'; else return false;"><i class="catalyst-lock-open" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='51827.Geçici Olarak Çözülecektir'>" title="<cf_get_lang dictionary_id='51827.Geçici Olarak Çözülecektir'>"></i></a></li>
				<cfsavecontent variable="massege"><cf_get_lang dictionary_id='47484.Birleştirilmiş Fiş Çözülecektir Emin misiniz'></cfsavecontent>
				<li><a href="##" onClick="javascript:if(confirm('#massege#')) window.location.href='#request.self#?fuseaction=account.emptypopup_solve_card&card_id=#get_card_rows.CARD_ID#'; else return false;"><i class="catalyst-lock" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='51833.Tamamen Çözülecektir'>" title="<cf_get_lang dictionary_id='51833.Tamamen Çözülecektir'>"></i></a></li>
			<cfelseif session.ep.our_company_info.is_edefter neq 1 and session.ep.isBranchAuthorization eq 0>
				<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_cards&card_id=#get_card_rows.card_id#&is_add_main_page=1','longpage','muhasebe_list');"><i class="catalyst-plus" border="0" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='51834.Birleştirilmiş Fişe Ekle'>" title="<cf_get_lang dictionary_id='51834.Birleştirilmiş Fişe Ekle'>"></i></a></li>
			</cfif>
			<cfset acc_control = 0>
			<cfif listfind('31',get_card_rows.action_type,',')>
				<cfquery name="get_expense_id" datasource="#dsn2#">
					SELECT
						EXPENSE_ID
					FROM 
						CASH_ACTIONS
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_expense_id.recordcount and len(get_expense_id.expense_id)>
					<cfset acc_control = 1>
					<li><a href="#request.self#?fuseaction=cost.upd_income_cost&expense_id=#get_expense_id.expense_id#" target="wwide1"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('24',get_card_rows.action_type,',')>
				<cfquery name="get_expense_id" datasource="#dsn2#">
					SELECT
						EXPENSE_ID
					FROM 
						BANK_ACTIONS
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_expense_id.recordcount and len(get_expense_id.expense_id)>
					<cfset acc_control = 1>
					<li><a href="#request.self#?fuseaction=cost.upd_income_cost&expense_id=#get_expense_id.expense_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('32',get_card_rows.action_type,',')>
				<cfquery name="get_expense_id" datasource="#dsn2#">
					SELECT
						EXPENSE_ID
					FROM 
						CASH_ACTIONS
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_expense_id.recordcount and len(get_expense_id.expense_id)>
					<cfset acc_control = 1>
					<li><a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#get_expense_id.expense_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('25',get_card_rows.action_type,',')>
				<cfquery name="get_expense_id" datasource="#dsn2#">
					SELECT
						EXPENSE_ID
					FROM 
						BANK_ACTIONS
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_expense_id.recordcount and len(get_expense_id.expense_id)>
					<cfset acc_control = 1>
				<li><a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#get_expense_id.expense_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('242',get_card_rows.action_type,',')>
				<cfquery name="get_expense_id" datasource="#dsn3#">
					SELECT
						EXPENSE_ID
					FROM 
						CREDIT_CARD_BANK_EXPENSE
					WHERE
						CREDITCARD_EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#"> AND 
						ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				</cfquery>
				<cfif get_expense_id.recordcount and len(get_expense_id.expense_id)>
					<cfset acc_control = 1>
				<li><a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#get_expense_id.expense_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			</cfif>
			<cfif acc_control eq 0 and isdefined('link_str') and len(link_str) and len(get_card_rows.process_cat) and get_card_rows.action_id neq 0 and get_card_rows.ACTION_TABLE neq 'INVOICE_COST'>
				<li><a href="javascript://" onClick="openBoxDraggable('#link_str##get_card_rows.action_id#');"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
			<cfelseif listfind('31',get_card_rows.action_type,',')>
				<cfquery name="get_order_id" datasource="#dsn3#">
					SELECT
						ORDER_ID
					FROM 
						ORDER_CASH_POS
					WHERE
						CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#"> AND 
						KASA_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				</cfquery>
				<cfif get_order_id.recordcount>
					<li><a href="#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id=#get_order_id.order_id#" target="invoice_window"><i class="fa fa-cube" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('241',get_card_rows.action_type,',')>
				<cfquery name="get_order_id" datasource="#dsn3#">
					SELECT
						ORDER_ID
					FROM 
						ORDER_CASH_POS
					WHERE
						POS_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_order_id.recordcount>
					<li><a href="#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id=#get_order_id.order_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('97',get_card_rows.action_type,',')>
				<cfquery name="get_voucher_id" datasource="#dsn2#">
					SELECT
						VOUCHER_ID
					FROM 
						VOUCHER
					WHERE
						VOUCHER_PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_voucher_id.recordcount>
					<li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=cheque.popup_view_voucher_detail&ID=#get_voucher_id.VOUCHER_ID#&draggable=1')"><i class="fa fa-cube" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('90',get_card_rows.action_type,',')>
				<cfquery name="get_order_id" datasource="#dsn2#">
					SELECT
						PAYMENT_ORDER_ID ORDER_ID
					FROM 
						PAYROLL
					WHERE
						ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif get_order_id.recordcount>
					<li><a href="#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id=#get_order_id.order_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
				</cfif>
			<cfelseif listfind('1043,1044',get_card_rows.action_type,',')>
				<cfquery name="get_cheque_id" datasource="#dsn2#">
					SELECT
						BA.CHEQUE_ID
					FROM 
						BANK_ACTIONS BA,
						CHEQUE C
					WHERE
						BA.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#"> AND 
						BA.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_type#"> AND
						BA.CHEQUE_ID = C.CHEQUE_ID
				</cfquery>
				<li><a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_cheque_id.cheque_id#','horizantal')"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
			<cfelseif get_card_rows.action_type eq 1046>
				<li><a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_card_rows.action_id#','horizantal')"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
			<cfelseif listfind('1053',get_card_rows.action_type,',')>
				<cfquery name="get_voucher_id" datasource="#dsn2#">
					SELECT
						BA.VOUCHER_ID
					FROM 
						BANK_ACTIONS BA,
						VOUCHER V
					WHERE
						BA.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#"> AND 
						BA.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_type#"> AND
						BA.VOUCHER_ID = V.VOUCHER_ID
				</cfquery>
				<li><a class="tableyazi" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#get_voucher_id.voucher_id#&draggable=1')"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
			<cfelseif get_card_rows.action_type eq 1056>
				<li><a class="tableyazi" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#get_card_rows.action_id#&draggable=1')"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='47461.İşlem Detay'>" title="<cf_get_lang dictionary_id='47461.İşlem Detay'>"></i></a></li>
			<cfelseif get_card_rows.ACTION_TABLE eq 'INVOICE_COST'>				
				<cfquery name="get_ship_id" datasource="#dsn2#">
					SELECT
						SHIP_ID,
						INVOICE_ID
					FROM 
						INVOICE_COST
					WHERE
						INVOICE_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_card_rows.action_id#">
				</cfquery>
				<cfif len(get_ship_id.ship_id)>
					<li><a href="#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id=#get_ship_id.ship_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='57447.Muhasebe'>" title="<cf_get_lang dictionary_id='57447.Muhasebe'>"></i></a></li>
				<cfelse>
					<li><a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_ship_id.invoice_id#" target="invoice_window"><i class="fa fa-cube" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='57447.Muhasebe'>" title="<cf_get_lang dictionary_id='57447.Muhasebe'>"></i></a></li>
				</cfif>
			</cfif>
			<li><a class="tableyazi" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#fusebox.circuit#.popup_list_card_rows_history&card_id=#get_card_rows.card_id#&action_id=#get_card_rows.action_id#&action_type=#get_card_rows.action_type#')"><i class="fa fa-history" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='57473.Tarihçe'>" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a></li>
			<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
				<li><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_table=#get_card_rows.action_table#&action_id=#attributes.action_id#&action_type=#attributes.process_cat#&print_type=290','page');"><i class="catalyst-printer" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></li>
			<cfelse>
				<li><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_table=#get_card_rows.action_table#&action_id=#attributes.card_id#&print_type=290','page');"><i class="catalyst-printer" style="vertical-align:middle" border="0" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></li>
			</cfif>
		</cfoutput> 
	</cfsavecontent>
<cfelse>
	<cfset head = ''>
	<cfset right = ''>
</cfif>
<cfloop from = "1" to = "#1 + session.ep.our_company_info.is_ifrs#" index = "s">
	<cfif s eq 1>
		<cfset card_head = head & ' Tek Düzen'>
	<cfelseif s eq 2>
		<cfset card_head = head & ' IFRS'>
		<cfquery name = "get_ifrs_card" datasource = "#dsn2#">
			SELECT
				AP.ACCOUNT_NAME,
				ACR.ACCOUNT_ID,
				ACR.IFRS_CODE,
				ACR.ACC_BRANCH_ID,
				ACR.DETAIL,
				ACR.QUANTITY,
				ACR.BA,
				ACR.AMOUNT,
				AC.IS_OTHER_CURRENCY,
				ACR.ACC_PROJECT_ID,
				ACR.AMOUNT_2,
				ACR.AMOUNT_CURRENCY_2,
				ACR.OTHER_AMOUNT,
				ACR.OTHER_CURRENCY
			FROM
				ACCOUNT_CARD AC
					LEFT JOIN ACCOUNT_ROWS_IFRS ACR ON ACR.CARD_ID = AC.CARD_ID
					LEFT JOIN ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE = ACR.ACCOUNT_ID
			WHERE
				AC.CARD_ID = #get_card_rows.card_id#
				AND ACR.CARD_ROW_ID IS NOT NULL
		</cfquery>
	</cfif>
	<cfif (s eq 1 and get_card_rows.recordcount) or (s eq 2 and get_ifrs_card.recordcount)>
		<cf_box title='#card_head#' right_images='#right#'>
			
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='38889.Hesap Kodu'></th>
						<th><cf_get_lang dictionary_id='32634.Hesap Adı'></th>
						<cfif session.ep.our_company_info.is_ifrs eq 1>
							<th><cf_get_lang dictionary_id='58130.UFRS Kod'></th>
						</cfif>
						<cfif isdefined('xml_acc_branch_info') and xml_acc_branch_info eq 1>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
						</cfif>
						<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
						<cfif xml_acc_project_info><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<cfif isdefined('is_dsp_quantity') and is_dsp_quantity eq 1>
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57587.Borç'></th>
						<th><cf_get_lang dictionary_id='57588.Alacak'></th>
						<cfif get_card_rows.is_other_currency eq 1 or (isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1)>
						<!-- sil -->
						<th><cf_get_lang dictionary_id='47485.Sistem 2 Döviz'></th>
						<!-- sil -->
						<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
						<th><cf_get_lang dictionary_id='57489.Para Br'></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfset dep_id_list=''>
					<cfset branch_id_list=''>
					
					<cfoutput query="get_card_rows">
						<cfif isdefined("acc_department_id") and len(acc_department_id) and not listfind(dep_id_list,acc_department_id)>
						<cfset dep_id_list=listappend(dep_id_list,acc_department_id)>
						</cfif>
						<cfif isdefined("acc_branch_id") and len(acc_branch_id) and not listfind(branch_id_list,acc_branch_id)>
							<cfset branch_id_list=listappend(branch_id_list,acc_branch_id)>
						</cfif>
						
						
					</cfoutput>
					<cfif listlen(dep_id_list)>
						<cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
						<cfquery name="get_dep_detail" datasource="#dsn#">
							SELECT
								D.DEPARTMENT_HEAD,
								B.BRANCH_NAME
							FROM
								DEPARTMENT D,
								BRANCH B
							WHERE
								D.BRANCH_ID=B.BRANCH_ID
								AND D.DEPARTMENT_ID IN (#dep_id_list#)
							ORDER BY
								D.DEPARTMENT_ID
						</cfquery>
					</cfif>
					<cfif listlen(branch_id_list)>
						<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
						<cfquery name="GET_BRANCH" datasource="#dsn#">
							SELECT
								BRANCH_ID,
								BRANCH_NAME
							FROM
								BRANCH               
							WHERE
								BRANCH_ID IN (#branch_id_list#)
							ORDER BY 
								BRANCH_ID
						</cfquery>
					</cfif>
					<cfif s eq 2>
						<cfset get_card_rows = get_ifrs_card>
					</cfif>
					<cfset total_a = 0>
					<cfset total_b = 0>
					<cfoutput query="get_card_rows">
						<tr>
							<td>
								
								<cfif ListLen(get_card_rows.account_id,'.') gt 0>
									<cfloop index="i" from="1" to="#ListLen(get_card_rows.account_id,'.')#">&nbsp;</cfloop>
								</cfif>
								#get_card_rows.account_id#
							</td>
							<td>#get_card_rows.account_name#</td>
							<cfif session.ep.our_company_info.is_ifrs eq 1>
								<td>
									#get_card_rows.ifrs_code#
								</td>
							</cfif>
							<cfif isdefined('xml_acc_branch_info') and xml_acc_branch_info eq 1>
								<td>
									<cfif len(get_card_rows.acc_branch_id)>
										#get_branch.branch_name[listfind(branch_id_list,get_card_rows.acc_branch_id,',')]#
									</cfif>
								</td>
							</cfif>
							<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
								<td>
									<cfif isdefined("ACC_DEPARTMENT_ID") and len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>
								</td>
							</cfif>
							
							<cfif xml_acc_project_info>
								<td>
									<cfif isdefined("get_card_rows.acc_project_id") and  len(get_card_rows.ACC_PROJECT_ID)>
										#GET_PROJECT_NAME(get_card_rows.ACC_PROJECT_ID)#
									</cfif>
								</td>
							</cfif>
							<td><p title="#get_card_rows.detail#">#left(get_card_rows.detail,50)#</p></td>
							<cfif isdefined('is_dsp_quantity') and is_dsp_quantity eq 1>
								<td>#get_card_rows.quantity#</td>
							</cfif>
							<td class="text-right">&nbsp;
								<cfif get_card_rows.BA eq 0>
									#TLFormat(get_card_rows.amount)#
									<cfset total_a=total_a+amount>
								</cfif>
							</td>
							<td class="text-right">&nbsp;
								<cfif get_card_rows.ba neq 0>
									#TLFormat(get_card_rows.amount)#
									<cfset total_b=total_b+amount>
				
								</cfif>
							</td>
							<cfif get_card_rows.is_other_currency eq 1 or (isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1)>
								<!-- sil -->
								<td class="text-right">&nbsp;#TLFormat(get_card_rows.AMOUNT_2)# #get_card_rows.amount_currency_2#</td>
								<!-- sil -->
								<td class="text-right">&nbsp;#TLFormat(get_card_rows.other_amount)#</td>
								<td>&nbsp;#get_card_rows.other_currency#</td>
							</cfif>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<cfset colspan_info = 3>
						<cfif session.ep.our_company_info.is_ifrs eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('xml_acc_branch_info') and xml_acc_branch_info eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('xml_acc_project_info') and xml_acc_project_info eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('is_dsp_quantity') and is_dsp_quantity eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><cfset colspan_info = colspan_info + 1></cfif>
						<td colspan="<cfoutput>#colspan_info#</cfoutput>" class="bold"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td class="bold text-right"><cfoutput>#TLFormat(total_a)#</cfoutput></td>
						<td class="bold text-right"><cfoutput>#TLFormat(total_b)#</cfoutput></td>
						<cfset colspan_info = colspan_info + 3>
						<td colspan="<cfoutput>#colspan_info#</cfoutput>"></td>
					</tr>
				</tfoot>
			</cf_grid_list>	
				<div class="ui-info-bottom">
					<div class="col col-10 col-md-10 col-xs-12">
						<cfset colspan_info = 3>
						<cfif session.ep.our_company_info.is_ifrs eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('xml_acc_branch_info') and xml_acc_branch_info eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('xml_acc_project_info') and xml_acc_project_info eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif isdefined('is_dsp_quantity') and is_dsp_quantity eq 1><cfset colspan_info = colspan_info + 1></cfif>
						<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><cfset colspan_info = colspan_info + 1></cfif>
						<cfif s eq 1>
							<label colspan="<cfoutput>#colspan_info#</cfoutput>" class="bold"><cf_get_lang dictionary_id='57492.Toplam'></label>
						</cfif>
						<cfif get_card_rows.is_other_currency eq 1>
							<label colspan="5"  class="bold text-right">
								<cfif s eq 1>
									<cfoutput query="GET_OTHER_MONEY_TOTALS">
										#other_currency# : #TLFormat(other_amount_toplam)# <cfif ba eq 1>(A)<cfelse>(B)</cfif><br />
									</cfoutput>
								</cfif>
							</label>
						<cfelseif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1>
							<label colspan="5" class="bold text-right">&nbsp;</label>
						</cfif>
					</div>
					<cfif not (isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1)>
						<div class="col col-2 col-md-2 col-xs-4">
							<cf_workcube_buttons extraButton="1" extraButtonText="Kapat" extraFunction="Close()" update_status="0">
						</div>
					</cfif>
				</div>				
		</cf_box>
	</cfif>
</cfloop>
<script type="text/javascript">
	function Close() {
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>