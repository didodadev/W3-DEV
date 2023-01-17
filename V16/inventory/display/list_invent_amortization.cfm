<cf_xml_page_edit fuseact="invent.list_invent_amortization">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.accounting_target" default="0">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.form_exist")>
	<cfquery name="get_invent_main" datasource="#DSN3#">
		SELECT 
			INVENTORY_AMORTIZATION_MAIN.*,
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME
	    FROM
			INVENTORY_AMORTIZATION_MAIN
				LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = INVENTORY_AMORTIZATION_MAIN.RECORD_EMP
		WHERE
			INV_AMORT_MAIN_ID IS NOT NULL
	   <cfif len(attributes.start_date)>
		    AND INVENTORY_AMORTIZATION_MAIN.RECORD_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
		    AND INVENTORY_AMORTIZATION_MAIN.RECORD_DATE <= #attributes.finish_date#
		</cfif>
		AND INVENTORY_AMORTIZATION_MAIN.ACCOUNTING_TYPE = #attributes.accounting_target#
		<cfif isDefined("attributes.invent_no") and len(attributes.invent_no)>
			AND INV_AMORT_MAIN_ID IN
			(
				SELECT 
					IA.INV_AMORT_MAIN_ID
				FROM
					<cfif attributes.accounting_target eq 0>
						INVENTORY_AMORTIZATON IA,
					<cfelseif attributes.accounting_target eq 1>
						INVENTORY_AMORTIZATON_IFRS IA,
					</cfif>
					INVENTORY I
				WHERE
					IA.INVENTORY_ID = I.INVENTORY_ID
					AND I.INVENTORY_NUMBER = '#attributes.invent_no#'
			) 			
		</cfif>  
		ORDER BY RECORD_DATE
	</cfquery>
<cfelse>
	<cfset get_invent_main.recordcount=0>	
</cfif>
<cfif len(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date,dateformat_style)>
</cfif>
<cfif len(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date,dateformat_style)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_invent_main.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=invent.list_invent_amortization">
			<input type="hidden" name="form_exist" id="form_exist" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="58878.Demişbaş No"></cfsavecontent>
					<cfinput type="text" name="invent_no" placeholder="#message#" value="#attributes.invent_no#" maxlength="50">
				</div>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" placeholder="#place#" maxlength="10">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#" placeholder="#place#" maxlength="10"  style="width:65px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-accounting_target">
					<select name="accounting_target" id="accounting_target" style="width:160px;">
						<option value="0" <cfif attributes.accounting_target eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
						<option value="1" <cfif attributes.accounting_target eq 1>selected</cfif>>IFRS</option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56992.Değerleme"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
					<th><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id ='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none">
						<a href="<cfoutput>#request.self#?fuseaction=invent.list_invent_amortization&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<th width="20" class="header_icn_none"></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_invent_main.recordcount>
					<cfoutput query="GET_INVENT_MAIN" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#get_process_name(process_type)#</td>
							<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
							<td>#name#</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<!-- sil -->
							<td>
								<cfif is_update_list eq 1>
									<a href="#request.self#?fuseaction=invent.list_invent_amortization&event=upd&inv_id=#INV_AMORT_MAIN_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=invent.popup_print_invent_amortization&action_id=#INV_AMORT_MAIN_ID#','wwide');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>	
								</cfif>
							</td>
							<cfquery name="GET_INVENT" datasource="#dsn3#">
								SELECT DISTINCT
									INVENTORY_AMORTIZATON.*,
									INVENTORY.LAST_INVENTORY_VALUE,
									INVENTORY.ACCOUNT_ID,
									INVENTORY.INVENTORY_NUMBER,
									INVENTORY.INVENTORY_NAME,
									INVENTORY.PROJECT_ID,
									INVENTORY.EXPENSE_ITEM_ID,
									INVENTORY.EXPENSE_CENTER_ID,
									ISNULL(INVENTORY_AMORTIZATON.INV_QUANTITY,INVENTORY.QUANTITY) QUANTITY,
									INVENTORY.AMOUNT,
									INVENTORY_ROW.STOCK_IN
								FROM
									INVENTORY,
									INVENTORY_ROW,
									<cfif attributes.accounting_target eq 0>
										INVENTORY_AMORTIZATON
									<cfelseif attributes.accounting_target eq 1>
										INVENTORY_AMORTIZATON_IFRS INVENTORY_AMORTIZATON
									</cfif>
								WHERE
									INVENTORY.INVENTORY_ID=INVENTORY_ROW.INVENTORY_ID AND 
									INVENTORY_ROW.STOCK_IN > 0 AND 
									INVENTORY.INVENTORY_ID=INVENTORY_AMORTIZATON.INVENTORY_ID AND
									INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#INV_AMORT_MAIN_ID#">		
							</cfquery>
						<cfset inv_list = valuelist(get_invent.inventory_id)>
							<cfif ListLen(inv_list)>
								<cfquery name="get_amortization" datasource="#dsn3#">
									SELECT 
										IA.INV_AMORT_MAIN_ID
									FROM 
										<cfif attributes.accounting_target eq 0>
											INVENTORY_AMORTIZATON IA,
										<cfelseif attributes.accounting_target eq 1>
											INVENTORY_AMORTIZATON_IFRS IA,
										</cfif>
										INVENTORY_AMORTIZATION_MAIN IAM
									WHERE 
										IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
										AND IA.INVENTORY_ID IN (#inv_list#)
										AND IAM.RECORD_DATE > #createodbcdatetime(get_invent_main.record_date)#
								</cfquery>
							<cfelse>
								<cfset get_amortization.recordcount = 0>
						</cfif>
							<td nowrap="nowrap">
								<a class="tableyazi" href="##" onclick="javascript:window.location.href='#request.self#?fuseaction=invent.emptypopup_get_excel&inv_id=#inv_amort_main_id#';">
									<img src="/images/excel.gif" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='57858.Excel Getir'>" title="<cf_get_lang dictionary_id='57858.Excel Getir'>"></a>
								<cfif get_amortization.recordcount eq 0>
									<a class="tableyazi" href="##" onclick="javascript:if(confirm('Değerleme İşlemini Silmek İstediğinize Emin Misiniz?')) window.location.href='#request.self#?fuseaction=invent.emptypopup_del_invent_amortization&is_from_list=1&old_process_type=18&inv_main_id=#inv_amort_main_id#'; else return false;">
										<img src="/images/delete_list.gif" style="vertical-align:middle" alt="Sil" title="Sil">
									</a>
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="7" class="color-row" height="20"><cfif isdefined("attributes.form_exist")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres="invent.list_invent_amortization&form_exist=1">
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset adres=adres&'&start_date=#attributes.start_date#'>
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset adres=adres&'&finish_date=#attributes.finish_date#'>
		</cfif>
		<cfif isdefined("attributes.invent_no") and len(attributes.invent_no)>
			<cfset adres=adres&'&invent_no=#attributes.invent_no#'>
		</cfif>
		<cfif isdefined("attributes.accounting_target") and len(attributes.accounting_target)>
			<cfset adres=adres&'&accounting_target=#attributes.accounting_target#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('invent_no').focus();
</script>
