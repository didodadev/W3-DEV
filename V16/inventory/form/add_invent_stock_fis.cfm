<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_INVENTORY_CATS" datasource="#dsn3#">
	SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
</cfquery>
<cfquery name="get_activity_types" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfset inventory_cat_list=valuelist(GET_INVENTORY_CATS.INVENTORY_CAT_ID)>
<cf_papers paper_type="stock_fis">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_invent_stock_fis" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_invent_stock_fis" onsubmit="return(unformat_fields());">
			<cf_box_elements id="invent_stock_fis"> 
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process_cat slct_width="120">
						</div>
					</div>
					<div class="form-group" id="item-fis_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fiş No'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57946.Fiş No'></cfsavecontent>
							<cfinput type="text" name="fis_number" value="#system_paper_no#" readonly="yes" maxlength="50" required="yes" message="#message1#">
						</div>
					</div>
					<div class="form-group" id="item-ref_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Ref No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="ref_no" id="ref_no" value="">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message3"><cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
								<cfinput type="text" name="start_date" validate="#validate_style#" required="yes" message="#message3#" value="#dateformat(now(),dateformat_style)#" maxlength="10" onblur="change_money_info('add_invent_stock_fis','start_date');">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-giris_depo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'></label>
						<div class="col col-8 col-xs-12">
							<cf_wrkdepartmentlocation
								returnInputValue="location_id,department_name,department_id,branch_id"
								returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldName="department_name"
								fieldid="location_id"
								department_fldId="department_id"
								branch_fldId="branch_id"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 1
								width="120">
						</div>
					</div>
					<div class="form-group" id="item-cikis_depo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_wrkdepartmentlocation
								returnInputValue="location_id_2,department_name_2,department_id_2,branch_id_2"
								returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldName="department_name_2"
								fieldid="location_id_2"
								department_fldId="department_id_2"
								branch_fldId="branch_id_2"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 2
								width="120">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-deliver_get">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57775.Teslim Alan'> <cf_get_lang dictionary_id='57613.Girmelsiniz'></cfsavecontent>
								<cfinput type="text" name="deliver_get" required="yes" message="#message#" readonly="yes" value="#session.ep.name# #session.ep.surname#">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57775.Teslim Alan'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_invent_stock_fis.deliver_get&field_emp_id2=add_invent_stock_fis.deliver_get_id</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.project_followup eq 1>
						<div class="form-group" id="item-project">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
										<cf_wrk_projects form_name='add_invent_stock_fis' project_id='project_id' project_name='project_head'>
										<input type="hidden" name="is_related_project" id="is_related_project" value="1">
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and  len(attributes.project_id)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_invent_stock_fis.project_id&project_head=add_invent_stock_fis.project_head');"></span>
									<cfelse>
										<cf_wrk_projects form_name='add_invent_stock_fis' project_id='project_id' project_name='project_head'>
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')><cfoutput>#attributes.pj_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)><cfoutput>#GET_PROJECT_NAME(attributes.pj_id)#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_invent_stock_fis.project_id&project_head=add_invent_stock_fis.project_head');"></span>
									</cfif>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-invoice_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57441.Fatura'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="related_invoice_id" id="related_invoice_id" value="<cfif isdefined('attributes.related_invoice_id') and len(attributes.related_invoice_id)><cfoutput>#attributes.related_invoice_id#</cfoutput></cfif>">
								<input type="text" name="related_invoice_number" id="related_invoice_number" readonly="yes" value="<cfif isdefined('attributes.related_invoice_number') and len(attributes.related_invoice_number)><cfoutput>#attributes.related_invoice_number#</cfoutput></cfif>">
								<cfset str_invoice_link="field_id=add_invent_stock_fis.related_invoice_id&field_name=add_invent_stock_fis.related_invoice_number&cat=0">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='59774.Sistem No'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_bills&frm_inventory=1&#str_invoice_link#'</cfoutput>,'list','popup_list_bills');"></span>
							</div>
						</div>
					</div>
					
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail"></textarea>
						</div>
					</div>
					<cfif session.ep.our_company_info.subscription_contract eq 1>
						<div class="form-group" id="item-subscription_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59774.Sistem No'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
									<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','2','100');" autocomplete="off">
									<cfset str_subscription_link="field_partner=&field_id=add_invent_stock_fis.subscription_id&field_no=add_invent_stock_fis.subscription_no">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='59774.Sistem No'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#'</cfoutput>,'list','popup_list_subscription');"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</div>
			</cf_box_footer>
			<cf_basket id="invent_stock_fis_bask">
				<cf_grid_list name="table1" id="table1" class="detail_basket_list">
					<thead>
						<tr>
							<th nowrap><input name="record_num" id="record_num" type="hidden" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)>1<cfelse>0</cfif>"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							<a onClick="windowopen('<cfoutput>#request.self#?fuseaction=invent.popup_purchase_invoice_list</cfoutput>','project');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> % </th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56994.Döviz Fiyat'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57677.Döviz'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='57002.Ömür'></th>
							<th nowrap="nowrap" style="text-align:right;"><cf_get_lang dictionary_id='58308.IFRS'> <cf_get_lang dictionary_id='57002.Ömür'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='29425.Amortisman türü'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58605.Periyod/Yıl'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56968.Borçlu Hesap Muhasebe Kodu'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56970.Alacak Hesabı Muhasebe Kodu'></th>
						</tr>
					</thead>
					<tbody>
						<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
							<cfquery name="get_project_periods" datasource="#dsn3#">
								SELECT
									INVENTORY_CAT_ID,
									INVENTORY_CODE,
									AMORTIZATION_METHOD_ID,
									AMORTIZATION_TYPE_ID,
									AMORTIZATION_EXP_CENTER_ID,
									AMORTIZATION_EXP_ITEM_ID,
									AMORTIZATION_CODE
								FROM 
									PROJECT_PERIOD
								WHERE
									PROJECT_ID = #attributes.project_id#
									AND PERIOD_ID = #session.ep.period_id#
							</cfquery>
							<cfquery name="get_project_inf" datasource="#dsn#">
								SELECT 
									PROJECT_HEAD,
									PROJECT_NUMBER
								FROM
									PRO_PROJECTS
								WHERE
									PROJECT_ID = #attributes.project_id#
							</cfquery>
							<cfset item_id_list=''>
							<cfset exp_center_id_list=''>
							<cfoutput query="get_project_periods">
								<cfif len(AMORTIZATION_EXP_ITEM_ID) and not listfind(item_id_list,AMORTIZATION_EXP_ITEM_ID)>
									<cfset item_id_list=listappend(item_id_list,AMORTIZATION_EXP_ITEM_ID)>
								</cfif>
								<cfif len(AMORTIZATION_EXP_CENTER_ID) and not listfind(exp_center_id_list,AMORTIZATION_EXP_CENTER_ID)>
									<cfset exp_center_id_list=listappend(exp_center_id_list,AMORTIZATION_EXP_CENTER_ID)>
								</cfif>
							</cfoutput>
							<cfif len(item_id_list)>
								<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
								<cfquery name="get_exp_detail" datasource="#dsn2#">
									SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
								</cfquery>
							</cfif>
							<cfif len(exp_center_id_list)>
								<cfquery name="get_expense_center" datasource="#dsn2#">
									SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE_ID
								</cfquery>
								<cfset exp_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.EXPENSE_ID,',')),'numeric','ASC',',')>
							</cfif>
							<cfif get_project_periods.recordcount>
								<cfoutput query="get_project_periods">
									<tr id="frm_row#currentrow#">
										<input type="hidden" name="invent_id#currentrow#" id="invent_id#currentrow#" class="boxtext" value="">
										<td nowrap="nowrap">
											<input  type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="">
											<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="">
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" class="boxtext" value="">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=add_invent_stock_fis.product_id#currentrow#&field_id=add_invent_stock_fis.stock_id#currentrow#&field_unit_name=add_invent_stock_fis.stock_unit#currentrow#&field_main_unit=add_invent_stock_fis.stock_unit_id#currentrow#&field_name=add_invent_stock_fis.product_name#currentrow#&field_tax_purchase=tax_rate#currentrow#&run_function=get_invent_info&run_function_param=#currentrow#','list');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
										</td>
										<td>
											<input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="">
											<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" class="boxtext" value="">
										</td>
										<td>
											<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="">
											<input type="hidden" name="wrk_row_relation_id#currentrow#" id="wrk_row_relation_id#currentrow#" value="">
											<input  type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="inventory_cat_id#currentrow#" id="inventory_cat_id#currentrow#" value="#inventory_cat_id#">
											<input type="text" name="inventory_cat#currentrow#" id="inventory_cat#currentrow#" class="boxtext" value="<cfif len(inventory_cat_id)>#GET_INVENTORY_CATS.INVENTORY_CAT[listfind(inventory_cat_list,inventory_cat_id)]#</cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="open_inventory_cat_list('#currentrow#');"></span></div></div>
										</td>
										<td><input type="text" name="invent_no#currentrow#" id="invent_no#currentrow#" class="boxtext" value="#get_project_inf.project_number#"></td>
										<td><input type="text" name="invent_name#currentrow#" id="invent_name#currentrow#" class="boxtext" value="#get_project_inf.project_head#" maxlength="100"></td>
										<td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" class="box" value="1" onBlur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event));"></td>
										<td>
											<input type="hidden" name="net_total#currentrow#" id="net_total#currentrow#" value="">
											<input type="text" name="row_total#currentrow#" id="row_total#currentrow#" value="" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla('#currentrow#');" class="box">
										</td>
										<td>
											<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" onChange="hesapla('#currentrow#');" class="box">
												<cfloop query="get_tax">
													<option value="#tax#">#tax#</option>
												</cfloop>
											</select>
										</td>
										<td><input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla('#currentrow#',1);" class="box"></td>
										<td><input type="text" name="row_other_total#currentrow#" id="row_other_total#currentrow#" value="" onkeyup="return(FormatCurrency(this,event));" class="box" readonly="yes"></td>
										<td>
											<select name="money_id#currentrow#" id="money_id#currentrow#" class="boxtext" onChange="hesapla('#currentrow#');">
												<cfloop query="get_money">
													<option value="#money#,#rate1#,#rate2#">#money#</option>
												</cfloop>
											</select>
										</td>
										<td><input type="text" name="inventory_duration#currentrow#" id="inventory_duration#currentrow#" width="100%" class="box" value="<cfif len(inventory_cat_id)>#GET_INVENTORY_CATS.inventory_duration[listfind(inventory_cat_list,inventory_cat_id)]#</cfif>" onkeyup="return(FormatCurrency(this,event));"></td>
										<td><input type="text" name="ifrs_inventory_duration#currentrow#" id="ifrs_inventory_duration#currentrow#" width="100%" class="box" value="<cfif len(inventory_cat_id)>#GET_INVENTORY_CATS.ifrs_inventory_duration[listfind(inventory_cat_list,inventory_cat_id)]#</cfif>" onkeyup="return(FormatCurrency(this,event));"></td>
										<td><input type="box" name="amortization_rate#currentrow#" id="amortization_rate#currentrow#" class="boxtext" value="<cfif len(inventory_cat_id)>#GET_INVENTORY_CATS.amortization_rate[listfind(inventory_cat_list,inventory_cat_id)]#</cfif>" onblur="return(amortisman_kontrol(#currentrow#));" onkeyup="return(FormatCurrency(this,event));"></td>
										<td>
											<select name="amortization_method#currentrow#" id="amortization_method#currentrow#" class="box">
												<option value="0" <cfif amortization_method_id eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
												<option value="1" <cfif amortization_method_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'></option>
											</select>
										</td>
										<td><select name="amortization_type#currentrow#" id="amortization_type#currentrow#" class="box"><option value="1" <cfif amortization_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id="29426.Kıst Amortismana Tabi"></option><option value="2" <cfif amortization_type_id eq 2>selected</cfif>><cf_get_lang dictionary_id="29427.Kıst Amortismana Tabi Değil"></option></select></td>
										<td nowrap="nowrap">
											<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#inventory_code#">
											<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" class="boxtext" value="#inventory_code#" onFocus="autocomp_account(#currentrow#);">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc('#currentrow#');"></span>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#AMORTIZATION_EXP_CENTER_ID#" >
											<input type="text"  name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" onFocus="exp_center(#currentrow#);" value="<cfif len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,AMORTIZATION_EXP_CENTER_ID,',')]#</cfif>" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_exp_center(#currentrow#);"></span>
										</td>
										<td nowrap="nowrap"><select name="activity_type#currentrow#" id="activity_type#currentrow#" class="boxtext">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_activity_types">
													<option value="#activity_id#" <cfif activity_type_ eq activity_id>selected</cfif>>#activity_name#</option>
												</cfloop>
											</select>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#amortization_exp_item_id#">
											<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" onFocus="exp_item(#currentrow#);" value="<cfif len(amortization_exp_item_id)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,amortization_exp_item_id,',')]#</cfif>" class="boxtext">
											<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('#currentrow#');"></span>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="hd_period#currentrow#" id="hd_period#currentrow#" value="">
											<input type="text" name="period#currentrow#" id="period#currentrow#" value="12" class="box"  onblur="return(period_kontrol(#currentrow#));" onkeyup="return(FormatCurrency(this,event,0));">
										</td>
										<td nowrap="nowrap">
											<cfif len(amortization_exp_item_id)>
												<cfquery name="get_debt_account_code" datasource="#dsn2#">
													SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #amortization_exp_item_id#
												</cfquery>
											</cfif>
											<input type="hidden" name="debt_account_id#currentrow#" id="debt_account_id#currentrow#" value="<cfif isdefined("get_debt_account_code") and len(get_debt_account_code.account_code)>#get_debt_account_code.account_code#</cfif>">
											<input type="text" name="debt_account_code#currentrow#" id="debt_account_code#currentrow#" class="boxtext" value="<cfif isdefined("get_debt_account_code") and len(get_debt_account_code.account_code)>#get_debt_account_code.account_code#</cfif>" onFocus="AutoComplete_Create('debt_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','debt_account_id#currentrow#','','3','225');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc2('#currentrow#');" ></span>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="claim_account_id#currentrow#" id="claim_account_id#currentrow#" value="#amortization_code#">
											<input type="text" name="claim_account_code#currentrow#" id="claim_account_code#currentrow#" class="boxtext" value="#amortization_code#" onFocus="AutoComplete_Create('claim_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','claim_account_id#currentrow#','','3','225');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc1('#currentrow#');"></span>
										</td>
									</tr>
								</cfoutput>
							</cfif>
						</cfif>
					</tbody>
				</cf_grid_list>
				<cf_basket_footer height="100">
					<div class="col col-12 col-xs-12">
						<div id="sepetim_total">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
											<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
												SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
											</cfquery>
											<cfoutput>
												<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
													<cfset selected_money=get_standart_process_money.STANDART_PROCESS_MONEY>
												<cfelseif len(session.ep.money2)>
													<cfset selected_money=session.ep.money2>
												<cfelse>
													<cfset selected_money=session.ep.money>
												</cfif>
												<cfloop query="get_money">
													<tr>
														<td>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif selected_money eq money>checked</cfif>>
														</td>
														<cfif session.ep.rate_valid eq 1>
															<cfset readonly_info = "yes">
														<cfelse>
															<cfset readonly_info = "no">
														</cfif>
														<td>#money#</td>
														<td>#TLFormat(rate1,0)#/</td>
														<td>
															<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla();">
														</td>
													</tr>
												</cfloop>
											</cfoutput>
										</table>                   
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody"> 
										<table>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="0"><cfoutput>#session.ep.money#</cfoutput>
												</td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56975.KDV li Toplam'></td>
												<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="0"><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='58124.Döviz Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody" id="totalAmountList"> 
										<table>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
												<td id="rate_value1" style="text-align:right;">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="0">
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<input type="hidden" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" value="0">
											<input type="hidden" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="0">
											<input type="hidden" name="tl_value2" id="tl_value2" class="box" readonly="" value="" style="width:40px;">
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56993.Döviz KDV li Toplam'></td>
												<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="0">
												<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>					
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('add_invent_stock_fis')) return false;
		if(!check_display_files('add_invent_stock_fis')) return false;
		if(add_invent_stock_fis.department_id_2.value=="" || add_invent_stock_fis.department_name_2.value=="")
		{
			alert("<cf_get_lang dictionary_id='29428.Çıkış Depo'>!");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent_stock_fis.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent_stock_fis.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.row_total"+r).value == "")||(eval("document.add_invent_stock_fis.row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.amortization_rate"+r).value == "")||(eval("document.add_invent_stock_fis.amortization_rate"+r).value < 0))
				{ 
					alert ("<cf_get_lang dictionary_id='56988.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent_stock_fis.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if(document.getElementById('is_related_project') == undefined)
				{
					if (eval("document.add_invent_stock_fis.product_id"+r).value == "" || eval("document.add_invent_stock_fis.stock_id"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id='57725.Lütfen Ürün Seçiniz'>!");
						return false;
					}
				}
			}
		}
		if (record_exist == 0)
		{
			alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
			return false;
		}
	}
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+x);
	
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang dictionary_id ='56960.Amortisman Oranı 100 den Büyük Olamaz'> !");
			deger_amortization_rate.value = 0;
			return false;
		}
	}
	function period_kontrol(no)
	{
		deger = eval("document.add_invent_stock_fis.period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang dictionary_id ='56959.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
	}
	function unformat_fields()
	{
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+r);
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+r);
			temp_inventory_duration= eval("document.add_invent_stock_fis.inventory_duration"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value);
		}
		document.add_invent_stock_fis.total_amount.value = filterNum(document.add_invent_stock_fis.total_amount.value);
		document.add_invent_stock_fis.kdv_total_amount.value = filterNum(document.add_invent_stock_fis.kdv_total_amount.value); 
		document.add_invent_stock_fis.net_total_amount.value = filterNum(document.add_invent_stock_fis.net_total_amount.value);
		document.add_invent_stock_fis.other_total_amount.value = filterNum(document.add_invent_stock_fis.other_total_amount.value);
		document.add_invent_stock_fis.other_kdv_total_amount.value = filterNum(document.add_invent_stock_fis.other_kdv_total_amount.value); 
		document.add_invent_stock_fis.other_net_total_amount.value = filterNum(document.add_invent_stock_fis.other_net_total_amount.value);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			eval('add_invent_stock_fis.txt_rate2_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent_stock_fis.txt_rate1_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("add_invent_stock_fis.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent_stock_fis.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent_stock_fis.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+satir);//kdv oranı
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent_stock_fis.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_total.value = commaSplit(deger_total.value);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
		}
			toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent_stock_fis.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent_stock_fis.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent_stock_fis.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
					{
						if(list_getat(document.add_invent_stock_fis.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent_stock_fis.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_total.value = filterNum(deger_total.value);
				deger_kdv_total.value = filterNum(deger_kdv_total.value);
				deger_net_total.value = filterNum(deger_net_total.value);
				deger_other_net_total.value = filterNum(deger_other_net_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value));
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				deger_net_total.value = commaSplit(deger_net_total.value);
				deger_total.value = commaSplit(deger_total.value);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			}
		}
		document.add_invent_stock_fis.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent_stock_fis.kdv_total_amount.value = commaSplit(toplam_dongu_2);
		document.add_invent_stock_fis.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent_stock_fis.kur_say.value == 1)
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money;
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent_stock_fis.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
	
		document.add_invent_stock_fis.tl_value1.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value2.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit,ifrs_inventory_duration,activitytypeid)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (net_total == undefined) net_total ="";
		if (tax_rate == undefined) tax_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_total == undefined) row_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id == undefined) money_id ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_center_name == undefined) expense_center_name ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name ="";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";
		if (product_id == undefined) product_id ="";
		if (stock_id == undefined) stock_id ="";
		if (product_name == undefined) product_name ="";
		if (stock_unit_id == undefined) stock_unit_id ="";
		if (stock_unit == undefined) stock_unit ="";
		if (ifrs_inventory_duration == undefined) ifrs_inventory_duration ="";
		if (activitytypeid == undefined) activitytypeid ="";
		
		
	
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.add_invent_stock_fis.record_num.value=row_count;
		newCell = newRow.insertCell();
		newCell.setAttribute("nowrap","nowrap");
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input type="hidden" name="wrk_row_relation_id' + row_count +'" id="wrk_row_relation_id' + row_count +'" value="">';
		newCell.innerHTML = x + '<input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><img src="images/copy_list.gif" border="0"></a><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" class="boxtext">'
							+'<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent_stock_fis.product_id" + row_count + "&field_id=add_invent_stock_fis.stock_id" + row_count + "&field_unit_name=add_invent_stock_fis.stock_unit" + row_count + "&field_main_unit=add_invent_stock_fis.stock_unit_id" + row_count + "&field_name=add_invent_stock_fis.product_name" + row_count + "&run_function=get_invent_info&run_function_param="+row_count+"','list');"+'"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="' + stock_unit_id +'"><input type="text" id="stock_unit' + row_count +'" name="stock_unit' + row_count +'" value="' + stock_unit +'" class="boxtext"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="inventory_cat_id' + row_count +'" id="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" name="inventory_cat' + row_count +'" id="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="invent_no' + row_count +'" id="invent_no' + row_count +'" value="' + invent_no +'" class="boxtext" maxlength="50"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="invent_name' + row_count +'" id="invent_name' + row_count +'" value="' + invent_name +'" class="boxtext" maxlength="100"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="' + quantity +'" class="box" value="1" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="net_total' + row_count +'" id="net_total' + row_count +'" value="' + net_total +'"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" class="box"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<div class="form-group"><select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_tax">
				if('#tax#' == tax_rate)
					a += '<option value="#tax#" selected>#tax#</option>';
				else
					a += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = a+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +',1);" class="box"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event));" class="box" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<div class="form-group"><select id="money_id' + row_count  +'" name="money_id' + row_count  +'" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="get_money">
				if('#money#,#rate1#,#rate2#' == money_id)
					b += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
				else
					b += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
			</cfoutput>
		newCell.innerHTML = b+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="' + inventory_duration +'" class="box" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="ifrs_inventory_duration' + row_count +'" name="ifrs_inventory_duration' + row_count +'" value="' + ifrs_inventory_duration +'" class="box" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="' + amortization_rate +'" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="amortization_method'+ row_count +'" id="amortization_method'+ row_count +'" class="box"><option value="0"><cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden"></option><option value="1"><cf_get_lang dictionary_id="29422.Sabit Miktar Üzeriden"></option></select></div>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" class="box"><option value="1"><cf_get_lang dictionary_id="29426.Kıst Amortismana Tabi"></option><option value="2" selected><cf_get_lang dictionary_id="29427.Kıst Amortismana Tabi Değil"></option>></select></div>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_exp_center('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<div class="form-group"><select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
		<cfoutput query="get_activity_types">
		if('#activity_id#' == activitytypeid)
			b += '<option value="#activity_id#" selected>#activity_name#</option>';
		else
			b += '<option value="#activity_id#">#activity_name#</option>';
		</cfoutput>
		newCell.innerHTML =b+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" value="' + expense_item_name +'" class="boxtext" onFocus="exp_item('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" class="box" value="12" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" name="debt_account_code' + row_count +'" id="debt_account_code' + row_count +'" value="' + debt_account_code +'" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_acc2('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" name="claim_account_code' + row_count +'" id="claim_account_code' + row_count +'" value="' + claim_account_code +'" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_acc1('+ row_count +');"></span></div></div>';
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total = document.getElementById("net_total" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total =  document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id =  document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_center_name" + no_info) == undefined) expense_center_name =""; else expense_center_name = document.getElementById("expense_center_name" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		if (document.getElementById("product_id" + no_info) == undefined) product_id =""; else product_id = document.getElementById("product_id" + no_info).value;
		if (document.getElementById("stock_id" + no_info) == undefined) stock_id =""; else stock_id = document.getElementById("stock_id" + no_info).value;
		if (document.getElementById("product_name" + no_info) == undefined) product_name =""; else product_name = document.getElementById("product_name" + no_info).value;
		if (document.getElementById("stock_unit_id" + no_info) == undefined) stock_unit_id =""; else stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
		if (document.getElementById("stock_unit" + no_info) == undefined) stock_unit =""; else stock_unit = document.getElementById("stock_unit" + no_info).value;
		if (document.getElementById("ifrs_inventory_duration" + no_info) == undefined) ifrs_inventory_duration =""; else ifrs_inventory_duration = document.getElementById("ifrs_inventory_duration" + no_info).value;
		if (document.getElementById("activity_type" + no_info) == undefined) activitytypeid =""; else activitytypeid = document.getElementById("activity_type" + no_info).value;
		
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit,ifrs_inventory_duration,activitytypeid);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent_stock_fis.expense_center_id' + no +'&field_name=add_invent_stock_fis.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","expense_item_id"+no+",debt_account_code"+no+",debt_account_id"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_debt_account(no)
	{
		AutoComplete_Create("debt_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","debt_account_id"+no,"",3);
	}
	function autocomp_claim_account(no)
	{
		AutoComplete_Create("claim_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","claim_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.account_id' + no +'&field_name=add_invent_stock_fis.account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.claim_account_id' + no +'&field_name=add_invent_stock_fis.claim_account_code' + no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.debt_account_id' + no +'&field_name=add_invent_stock_fis.debt_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent_stock_fis.expense_item_id' + no +'&field_name=add_invent_stock_fis.expense_item_name' + no +'&field_account_no=add_invent_stock_fis.debt_account_code' + no +'&field_account_no2=add_invent_stock_fis.debt_account_id' + no +'','list');
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=add_invent_stock_fis.inventory_cat_id' + no +'&field_name=add_invent_stock_fis.inventory_cat' + no +'&field_amortization_rate=add_invent_stock_fis.amortization_rate' + no +'&field_inventory_duration=add_invent_stock_fis.inventory_duration' + no +'','list');
	}
	function get_invent_info(row){
		product_id = $("#product_id"+row).val();
		var get_info = wrk_safe_query('get_amortization_info','dsn3',0, product_id);
		$("#inventory_cat_id"+row).val(get_info.INVENTORY_CAT_ID[0]);
		$("#inventory_cat"+row).val(get_info.INVENTORY_CAT[0]);
		$("#amortization_method"+row).val(get_info.AMORTIZATION_METHOD_ID[0]);
		$("#amortization_type"+row).val(get_info.AMORTIZATION_TYPE_ID[0]);
		$("#account_id"+row).val(get_info.INVENTORY_CODE[0]);
		$("#account_code"+row).val(get_info.INVENTORY_CODE[0]);
		$("#expense_center_id"+row).val(get_info.AMORTIZATION_EXP_CENTER_ID[0]);
		$("#expense_center_name"+row).val(get_info.EXPENSE[0]);
		$("#expense_item_id"+row).val(get_info.AMORTIZATION_EXP_ITEM_ID[0]);
		$("#expense_item_name"+row).val(get_info.EXPENSE_ITEM_NAME[0]);
		$("#tax_rate"+row).val(get_info.TAX[0]);
	}
</script>