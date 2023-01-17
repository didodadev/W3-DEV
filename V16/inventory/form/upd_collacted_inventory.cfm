<!--- Demirbas Guncelle 20121004 --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.invent_no" default="">
<cfparam name="attributes.account_code" default="">
<cfparam name="attributes.debt_account_code" default="">
<cfparam name="attributes.claim_account_code" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.invent_status" default="1">
<cfparam name="attributes.entry_date_1" default="">
<cfparam name="attributes.entry_date_2" default="">
<cfparam name="attributes.inventory_cat_id" default="">
<cfif isdate(attributes.entry_date_1)><cf_date tarih = "attributes.entry_date_1"></cfif>
<cfif isdate(attributes.entry_date_2)><cf_date tarih = "attributes.entry_date_2"></cfif>
<cfset value = '0'>
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="get_invent" datasource="#dsn3#">
		SELECT
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.ACCOUNT_ID,
			I.DEBT_ACCOUNT_ID,
			I.CLAIM_ACCOUNT_ID,
			I.EXPENSE_CENTER_ID,
			I.EXPENSE_ITEM_ID,
            I.INVENTORY_CATID,
			I.INVENTORY_DURATION,
			I.INVENTORY_DURATION_IFRS,
			I.AMORTIZATON_ESTIMATE,
			I.PROJECT_ID
		FROM
			INVENTORY I
		WHERE
			I.INVENTORY_ID IS NOT NULL	
			<cfif len(attributes.entry_date_1)>
				AND I.ENTRY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date_1#">
			</cfif>
			<cfif isdate(attributes.entry_date_2)>
				AND I.ENTRY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.entry_date_2)#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND I.INVENTORY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif len(attributes.invent_no)>
				AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.invent_no#%">
			</cfif>
			<cfif isdefined("inventory_number") and len(inventory_number)>
				AND I.INVENTORY_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#inventory_number#%">
			</cfif>  
			<cfif len(attributes.account_code)>
				AND I.ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#">
			</cfif>
			<cfif len(attributes.debt_account_code)>
				AND I.DEBT_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.debt_account_code#">
			</cfif>
			<cfif len(attributes.claim_account_code)>
				AND I.CLAIM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.claim_account_code#">
			</cfif>
			<cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
				AND I.EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_center_id#">
			</cfif>
			<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>
				AND I.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_id#">
			</cfif>
			<cfif isDefined("attributes.inventory_cat_id") and len(attributes.inventory_cat_id) and isDefined("attributes.inventory_cat") and len(attributes.inventory_cat)>
                    AND I.INVENTORY_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_cat_id#">
                </cfif>	
			<cfif len(attributes.project_id) and len(attributes.project_head)>
            	<cfif attributes.project_id eq -1>
                    AND I.PROJECT_ID IS NULL
                <cfelse>
                    AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.project_id#">
                </cfif> 
			</cfif>
			<cfif isDefined("attributes.invent_status") and len(attributes.invent_status)>
				<cfif attributes.invent_status eq 1>
					AND I.LAST_INVENTORY_VALUE > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
					AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
				<cfelse>
					AND 
					(
                        I.LAST_INVENTORY_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
                        OR 
                        ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = <cfqueryparam cfsqltype="cf_sql_float" value="#value#">
					)
				</cfif>
			</cfif>
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_invent.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=invent.upd_collacted_inventory" method="post">
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<cfoutput>
						<input type="text" name="invent_no" id="invent_no" value="<cfif isdefined("inventory_number") and len(inventory_number)>#inventory_number#<cfelse>#attributes.invent_no#</cfif>" maxlength="50" placeholder="<cf_get_lang dictionary_id="58878.Demirbaş No">">
					</cfoutput>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
						<cfinput type="text" name="entry_date_1" value="#dateFormat(attributes.entry_date_1,dateformat_style)#" validate="#validate_style#" maxlength="10" placeholder="#message#">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="entry_date_1"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
						<cfinput type="text" name="entry_date_2" value="#dateFormat(attributes.entry_date_2,dateformat_style)#" validate="#validate_style#" maxlength="10" placeholder="#message#">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="entry_date_2"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="invent_status" id="invent_status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0"<cfif isdefined('attributes.invent_status') and (attributes.invent_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1"<cfif isdefined('attributes.invent_status') and (attributes.invent_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='10.Sayı Hatası Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=invent.add_collacted_inventory"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-expense_item_id">
						<label><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
						<cf_wrkExpenseItem fieldId="expense_item_id" fieldName="expense_item_name" is_value="1" form_name="form" expense_item_id="#attributes.expense_item_id#" expense_item_name="#attributes.expense_item_name#" acc_code="account_code" img_info="plus_thin" width_info="150" income_type_info="0">
					</div>
					<div class="form-group" id="item-account_code">
						<label><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></label>
						<div class="input-group">
							<cfinput type="text" name="account_code" value="#attributes.account_code#" onFocus="AutoComplete_Create('account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id="58811.Muhasebe Kodu">" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form.account_code','list');"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-debt_account_code">
						<label><cf_get_lang dictionary_id="57587.Borç"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"></label>
						<div class="input-group">
							<cfinput type="text" name="debt_account_code" value="#attributes.debt_account_code#" onFocus="AutoComplete_Create('debt_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id="58811.Muhasebe Kodu">" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form.debt_account_code','list');"></span>
						</div>
					</div>
					<div class="form-group" id="item-expense_center">
						<cfif isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)></cfif>
						<label><cf_get_lang dictionary_id="58460.Masraf Merkezi"></label>
						<cf_wrkExpenseCenter fieldId="expense_center_id" is_value="1" fieldName="expense_center_name" form_name="form" expense_center_id="#attributes.expense_center_id#" expense_center_name="#attributes.expense_center_name#" img_info="plus_thin" width_info="150">
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-project">
						<label><cf_get_lang dictionary_id="57416.Proje"></label>
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.project_id") and Len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cfoutput>#getLang('main',4)#</cfoutput>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
						</div>
					</div>
					<div class="form-group" id="item-claim_account_code">
						<label><cf_get_lang dictionary_id="40435.Alacak Muhasebe Kodu"></label>
						<div class="input-group">
							<cfinput type="text" name="claim_account_code" value="#attributes.claim_account_code#" onFocus="AutoComplete_Create('claim_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form.claim_account_code','list');"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-inventory_cat">
						<label><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'></label>
						<div class="input-group">
							<input type="hidden" id="inventory_cat_id" name="inventory_cat_id" value="">
							<input type="text" id="inventory_cat" name="inventory_cat" value="<cfif len(attributes.inventory_cat_id)><cfoutput>#attributes.inventory_cat#</cfoutput></cfif>">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id&field_name=inventory_cat','list');"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="47192.Sabit Kıymet Güncelleme"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cfform name="form_" action="#request.self#?fuseaction=invent.emptypopup_add_inventory_history" method="post">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='58602.Demirbaş'><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='56905.Demirbaş Adı'></th>
						<th><cf_get_lang dictionary_id='57416.Proje'></th>
						<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
						<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th><cf_get_lang dictionary_id="57000.Borç Muh Kodu"></th>
						<th><cf_get_lang dictionary_id="57001.Alacak Muh Kodu"></th>
						<th><cf_get_lang dictionary_id='58456.Oran'></th>
						<th><cf_get_lang dictionary_id="57002.Ömür"></th>
						<th>IFRS <cf_get_lang dictionary_id="57002.Ömür"></th>
						<!-- sil --><th><cf_get_lang dictionary_id='58693.Seç'></th><!-- sil -->
					</tr>
				</thead>
					<cfif isdefined("attributes.form_varmi") and get_invent.recordcount>
						<tbody>
							<tr class="total">
								<td colspan="3"></td>
								<td nowrap="nowrap">	<!--- proje --->
									<input type="hidden" name="main_project_id" id="main_project_id" value="">
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="main_project_head" id="main_project_head" value="" onFocus="AutoComplete_Create('main_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','main_project_id','','3','150',true,'apply_row(1)');" autocomplete="off">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_.main_project_id&project_head=form_.main_project_head&function_name=apply_row&function_param=1');" alt="<cf_get_lang dictionary_id='57416.Proje'>"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap">	<!--- masraf merkezi --->
									<div class="form-group">
										<div class="input-group">	
											<input type="hidden" name="main_exp_center_id" id="main_exp_center_id" value="">
											<input type="text" name="main_exp_center_name" id="main_exp_center_name" value="" onFocus="AutoComplete_Create('main_exp_center_name','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','main_exp_center_id','','3','200',true,'apply_row(2)');"  autocomplete="off">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=form_.main_exp_center_id&field_name=form_.main_exp_center_name&call_function=apply_row(2)','list','popup_expense_center');"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap"><!--- gider kalemi --->
									<div class="form-group">
										<div class="input-group">	
											<input type="hidden" name="main_exp_item_id" id="main_exp_item_id" value="">
											<input type="text" name="main_exp_item_name" id="main_exp_item_name" value="" onFocus="AutoComplete_Create('main_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','0','EXPENSE_ITEM_ID,ACCOUNT_CODE','main_exp_item_id','','3','200',true,'apply_row(3)');" autocomplete="off">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_.main_exp_item_id&field_name=form_.main_exp_item_name&function_name=apply_row(3)','list','popup_list_exp_item');"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap">	<!--- muhasebe kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfinput type="text" name="main_acc_code" value="" onFocus="AutoComplete_Create('main_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225','apply_row(4)');">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.main_acc_code&function_name=apply_row(4)','list');" ></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap">	<!--- amortisman borc muh. kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfinput type="text" name="main_debt_acc_code" value="" onFocus="AutoComplete_Create('main_debt_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225','apply_row(5)');">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.main_debt_acc_code&function_name=apply_row(5)','list');"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap">	<!--- amortisman alacak muh. kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfinput type="text" name="main_claim_acc_code" value="" onFocus="AutoComplete_Create('main_claim_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225','apply_row(6)');">
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_.main_claim_acc_code&function_name=apply_row(6)','list');" ></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td nowrap="nowrap">
									<div class="form-group">	<!--- amortisman orani --->
										<cfinput type="text" name="main_inv_rate" value="" onBlur="apply_row(8);">
									</div>
								</td>
								<td>
									<div class="form-group"><cfinput type="text" name="main_inv_duration" value="" onKeyUp="isNumber(this)" onBlur="apply_row(7);"></div>
								</td>
								<td>
									<div class="form-group"><cfinput type="text" name="main_inv_duration_ifrs" value="" onKeyUp="isNumber(this)" onBlur="apply_row(9);"></div>
								</td>
								<td style="text-align:center;"><div class="form-group"><cfinput type="checkbox" name="all_check" value="1" onClick="wrk_select_all('all_check','row_check');"></div></td>
							</tr>
						<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_invent.recordcount#</cfoutput>">
						<cfset expense_item_id_list = "">
						<cfset expense_center_id_list = "">
						<cfset project_id_list = "">
						<cfoutput query="get_invent">
							<cfif len(expense_center_id) and not listfind(expense_center_id_list,expense_center_id)>
								<cfset expense_center_id_list=listappend(expense_center_id_list,expense_center_id)>
							</cfif>
							<cfif len(expense_item_id) and not listfind(expense_item_id_list,expense_item_id)>
								<cfset expense_item_id_list=listappend(expense_item_id_list,expense_item_id)>
							</cfif>
							<cfif len(project_id) and not listfind(project_id_list,project_id)>
								<cfset project_id_list=listappend(project_id_list,project_id)>
							</cfif>
						</cfoutput>
						<!--- masraf/gelir merkezleri --->
						<cfif len(expense_center_id_list)>
							<cfset expense_center_id_list=listsort(expense_center_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_inc_center_name" datasource="#dsn2#">
								SELECT EXPENSE, EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_id_list#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset expense_center_id_list = listsort(listdeleteduplicates(valuelist(get_exp_inc_center_name.expense_id,',')),'numeric','ASC',',')>
						</cfif>
						<!--- gider kalemleri --->
						<cfif len(expense_item_id_list)>
							<cfset expense_item_id_list=listsort(expense_item_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_detail" datasource="#dsn2#">
								SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_id_list#) ORDER BY EXPENSE_ITEM_ID
							</cfquery>
							<cfset expense_item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.expense_item_id,',')),'numeric','ASC',',')>
						</cfif>
						<!--- projeler --->
						<cfif len(project_id_list)>
							<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
							<cfquery name="get_project_head" datasource="#dsn#">
								SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
							</cfquery>
							<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_head.project_id,',')),'numeric','ASC',',')>
						</cfif>
						<cfoutput query="get_invent" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#currentrow#</td>
								<td>#inventory_number#</td>	
								<td><!--- <a href="#request.self#?fuseaction=invent.detail_invent&inventory_id=#inventory_id#" class="tableyazi">#INVENTORY_NAME#</a> --->
									<div class="form-group">
										<cfif attributes.fuseaction contains 'autoexcel'>
											#INVENTORY_NAME#
										<cfelse>
											<input type="text" name="inventory_name#currentrow#" id="inventory_name#currentrow#" value="#INVENTORY_NAME#">
										</cfif>
									</div>
								</td>
								<td><!--- proje --->
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#project_id#">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#get_project_head.project_head[listfind(project_id_list,project_id,',')]#
											<cfelse>
												<input type="text" name="project_head#currentrow#" id="project_head#currentrow#" value="<cfif isdefined("get_project_head")>#get_project_head.project_head[listfind(project_id_list,project_id,',')]#</cfif>" onFocus="AutoComplete_Create('project_head#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id#currentrow#','','3','150');" autocomplete="off">
											</cfif>
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_.project_id'+#currentrow#+'&project_head=form_.project_head'+#currentrow#);" alt="<cf_get_lang dictionary_id='57416.Proje'>"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- masraf merkezi --->
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="exp_center_id#currentrow#" id="exp_center_id#currentrow#" value="#expense_center_id#">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#get_exp_inc_center_name.expense[listfind(expense_center_id_list,expense_center_id,',')]#
											<cfelse>
												<input type="text" name="exp_center_name#currentrow#" id="exp_center_name#currentrow#" value="<cfif isdefined("get_exp_inc_center_name")>#get_exp_inc_center_name.expense[listfind(expense_center_id_list,expense_center_id,',')]#</cfif>" onFocus="AutoComplete_Create('exp_center_name#currentrow#','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','exp_center_id#currentrow#','','3','200',true,'');"  autocomplete="off">
											</cfif>
											<!-- sil --><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_expense_center&field_id=form_.exp_center_id'+#currentrow#+'&field_name=form_.exp_center_name'+#currentrow#,'list','popup_expense_center');"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- gider kalemi --->
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="exp_item_id#currentrow#" id="exp_item_id#currentrow#" value="#expense_item_id#">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#get_exp_detail.expense_item_name[listfind(expense_item_id_list,expense_item_id,',')]#
											<cfelse>
												<input type="text" name="exp_item_name#currentrow#" id="exp_item_name#currentrow#" value="<cfif isdefined("get_exp_detail")>#get_exp_detail.expense_item_name[listfind(expense_item_id_list,expense_item_id,',')]#</cfif>"  onFocus="AutoComplete_Create('exp_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','0','EXPENSE_ITEM_ID,ACCOUNT_CODE','exp_item_id#currentrow#,debt_acc_code#currentrow#','','3','200',true,'');" autocomplete="off">
											</cfif>
											<!-- sil --> 
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=form_.exp_item_id'+#currentrow#+'&field_name=form_.exp_item_name'+#currentrow#+'&field_account_no=form_.debt_acc_code'+#currentrow#,'list','popup_list_exp_item');"></span><!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- muhasebe kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#account_id#
											<cfelse>
												<cfinput type="text" name="acc_code#currentrow#" value="#account_id#" onFocus="AutoComplete_Create('acc_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
											</cfif>
											<!-- sil --> 
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=form_.acc_code'+#currentrow#,'list');" alt="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- amortisman borc muhasebe kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#debt_account_id#
											<cfelse>
												<cfinput type="text" name="debt_acc_code#currentrow#" value="#debt_account_id#" onFocus="AutoComplete_Create('debt_acc_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
											</cfif>
											<!-- sil -->
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=form_.debt_acc_code'+#currentrow#,'list');"  alt="<cf_get_lang dictionary_id='56968.Amortisman Borç Muhasebe Kodu'>"></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- amortisman alacak muhasebe kodu --->
									<div class="form-group">
										<div class="input-group">
											<cfif attributes.fuseaction contains 'autoexcel'>
												#claim_account_id#
											<cfelse>
												<cfinput type="text" name="claim_acc_code#currentrow#" value="#claim_account_id#" onFocus="AutoComplete_Create('claim_acc_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
											</cfif>
											<!-- sil --> 
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=form_.claim_acc_code'+#currentrow#,'list');" alt="<cf_get_lang dictionary_id='56970.Amortisman Alacak Muhasebe Kodu'>" ></span>
											<!-- sil -->
										</div>
									</div>
								</td>
								<td><!--- amortisman orani --->
									<div class="form-group">
										<cfif attributes.fuseaction contains 'autoexcel'>
											#TLFormat(amortizaton_estimate)#
										<cfelse>
											<cfinput type="text" name="inventory_rate#currentrow#" value="#TLFormat(amortizaton_estimate)#" onKeyup="return(FormatCurrency(this,event,8));">
										</cfif>
									</div>
								</td>
								<td><!--- faydali omur --->
									<div class="form-group">
										<cfif attributes.fuseaction contains 'autoexcel'>
											#inventory_duration#
										<cfelse>
											<cfinput type="text" name="inventory_duration#currentrow#" value="#inventory_duration#" onKeyUp="isNumber(this)">
										</cfif>
									</div>
								</td>
								<td><!--- faydali omur IFRS --->
									<div class="form-group">
										<cfif attributes.fuseaction contains 'autoexcel'>
											#inventory_duration_ifrs#
										<cfelse>
											<cfinput type="text" name="inventory_duration_ifrs#currentrow#" value="#inventory_duration_ifrs#" onKeyUp="isNumber(this)">
										</cfif>
									</div>
								</td>
								<!-- sil --><td style="text-align:center;"><div class="form-group"><input type="checkbox" name="row_check" id="row_check" value="#currentrow#"></div></td><!-- sil -->
							</tr>
							<input type="hidden" name="inventory_id#currentrow#" id="inventory_id#currentrow#" value="#inventory_id#">
						</cfoutput>
						</tbody>
						
						
					<cfelse>
						<tbody>
							<tr>
								<td colspan="13"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
							</tr>
						</tbody>
					</cfif>
						
			</cf_grid_list>
			<cfif isdefined("attributes.form_varmi") and get_invent.recordcount>
				<!-- sil -->
				<div class="ui-info-bottom flex-end">
					<cf_box_elements>
						<div class="form-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57879.Islem Tarihi'> </cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="action_date" placeholder="#message#"value="" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
							</div>
						</div>  
						<div class="form-group">
							<cf_workcube_buttons is_upd="0" is_cancel="0" add_function="control_form()" type_format="1" right="1">
						</div>
					</cf_box_elements>   
				</div> 
				<!-- sil -->
			</cfif>
		</cfform>

		<cfset adres="invent.upd_collacted_inventory&form_varmi=1">
		<cfif isdefined("attributes.entry_date_1")>
			<cfset adres=adres&'&entry_date_1=#attributes.entry_date_1#'>
		</cfif>
		<cfif isdefined("attributes.entry_date_2")>
			<cfset adres=adres&'&entry_date_2=#attributes.entry_date_2#'>
		</cfif>
		<cfif isdefined("attributes.keyword")>
			<cfset adres=adres&'&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.invent_no")>
			<cfset adres=adres&'&invent_no=#attributes.invent_no#'>
		</cfif>
		<cfif isdefined("attributes.account_code")>
			<cfset adres=adres&'&account_code=#attributes.account_code#'>
		</cfif>
		<cfif isdefined("attributes.debt_account_code")>
			<cfset adres=adres&'&debt_account_code=#attributes.debt_account_code#'>
		</cfif>
		<cfif isdefined("attributes.claim_account_code")>
			<cfset adres=adres&'&claim_account_code=#attributes.claim_account_code#'>
		</cfif>
		<cfif isdefined("attributes.expense_center_id")>
			<cfset adres=adres&'&expense_center_id=#attributes.expense_center_id#'>
		</cfif>
		<cfif isdefined("attributes.expense_center_name")>
			<cfset adres=adres&'&expense_center_name=#attributes.expense_center_name#'>
		</cfif>
		<cfif isdefined("attributes.expense_item_id")>
			<cfset adres=adres&'&expense_item_id=#attributes.expense_item_id#'>
		</cfif>
		<cfif isdefined("attributes.inventory_cat_id") and isdefined("attributes.inventory_cat")>
			<cfset adres=adres&'&inventory_cat_id=#attributes.inventory_cat_id#'>
		</cfif>
		<cfif isdefined("attributes.expense_item_name")>
			<cfset adres=adres&'&expense_item_name=#attributes.expense_item_name#'>
		</cfif>
		<cfif isdefined("attributes.project_id")>
			<cfset adres=adres&'&project_id=#attributes.project_id#'>
		</cfif>
		<cfif isdefined("attributes.project_head")>
			<cfset adres=adres&'&project_head=#attributes.project_head#'>
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
	document.getElementById('keyword').focus();
	function control_form()
	{
		if(document.getElementById('action_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57879.Islem Tarihi'>");
			return false;
		}
		var check_len = document.getElementsByName('row_check').length;
		var checked_row = 0;
		for(zz=0; zz < check_len; zz++)
		{
			if(document.getElementsByName('row_check')[zz] != undefined && document.getElementsByName('row_check')[zz].checked == true)
			{
				var checked_row = 1;
			}
		}
		if(checked_row == 0)
		{
			alert("<cf_get_lang dictionary_id='30050.Lütfen Satır Seçiniz'> !");
			return false;
		}
		return true;
	}
	function apply_row(type)
	{
		var check_len = document.getElementsByName('row_check').length;
		for(zz=0; zz < check_len; zz++)
		{
			if(document.getElementsByName('row_check')[zz] != undefined)
			{
				var yy=((document.getElementById('page').value-1)*document.getElementById('maxrows').value)+zz+1;
				if(type == 1)	//proje
				{
					if(document.getElementById('main_project_id').value != '' && document.getElementById('main_project_head').value != '')
					{
						document.getElementById('project_id'+yy).value = document.getElementById('main_project_id').value;
						document.getElementById('project_head'+yy).value = document.getElementById('main_project_head').value;
					}
				}
				else if(type == 2)	//masraf merkezi
				{	
					if(document.getElementById('main_exp_center_id').value != '' && document.getElementById('main_exp_center_name').value != '')
					{
						document.getElementById('exp_center_id'+yy).value = document.getElementById('main_exp_center_id').value;
						document.getElementById('exp_center_name'+yy).value = document.getElementById('main_exp_center_name').value;
					}
				}
				else if(type == 3)	//gider kalemi
				{
					if(document.getElementById('main_exp_item_id').value != '' && document.getElementById('main_exp_item_name').value != '')
					{
						document.getElementById('exp_item_id'+yy).value = document.getElementById('main_exp_item_id').value;
						document.getElementById('exp_item_name'+yy).value = document.getElementById('main_exp_item_name').value;
					}
				}
				else if(type == 4)	//muhasebe kodu
				{	
					if(document.getElementById('main_acc_code').value != '')
						document.getElementById('acc_code'+yy).value = document.getElementById('main_acc_code').value;
				}
				else if(type == 5)	//amortisman borc muhasebe kodu
				{
					if(document.getElementById('main_debt_acc_code').value != '')
						document.getElementById('debt_acc_code'+yy).value = document.getElementById('main_debt_acc_code').value;
				}
				else if(type == 6)	//amortisman alacak muhasebe kodu
				{
					if(document.getElementById('main_claim_acc_code').value != '')
						document.getElementById('claim_acc_code'+yy).value = document.getElementById('main_claim_acc_code').value;
				}
				else if(type == 7) //faydali omur
				{	
					if(document.getElementById('main_inv_duration').value != '')
						document.getElementById('inventory_duration'+yy).value = document.getElementById('main_inv_duration').value;
				}
				else if(type == 9) //faydali omur ifrs
				{	
					if(document.getElementById('main_inv_duration_ifrs').value != '')
						document.getElementById('inventory_duration_ifrs'+yy).value = document.getElementById('main_inv_duration_ifrs').value;
				}
				else if(type == 8) //amortisman orani
				{	
					if(document.getElementById('main_inv_rate').value != '')
						document.getElementById('inventory_rate'+yy).value = document.getElementById('main_inv_rate').value;
				}
			}
		}
	}
</script>
