<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,IS_EXPENSE,INCOME_EXPENSE,IS_ACTIVE FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM_EXPENSE" dbtype="query">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE IS_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM_INCOME" dbtype="query">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE INCOME_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_TEMPLATE" datasource="#dsn2#">
	SELECT 
			TEMPLATE_ID,
			TEMPLATE_NAME,
			IS_ACTIVE,
			IS_INCOME,
			IS_DEPARTMENT,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP
	FROM 
		EXPENSE_PLANS_TEMPLATES 
	WHERE 
		TEMPLATE_ID = #attributes.template_id#
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT
</cfquery>
<cf_catalystHeader>
<cf_box>
<cfform name="add_costplan" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_cost_bill_template">
<cf_box_elements>
	<input type="hidden" name="template_id" id="template_id" value="<cfoutput>#attributes.template_id#</cfoutput>">
                	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-template_name">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',1097)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="template_name" id="template_name" value="#get_template.template_name#" maxlength="25">
                            </div>
                    	</div>
                        <div class="form-group" id="item-template_type">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',52)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <label><cfoutput>#getLang('main',1266)#</cfoutput><input type="radio" name="template_type" id="template_type" value="0" <cfif get_template.is_income eq 1>disabled<cfelse>checked</cfif>></label>
                        		<label><cfoutput>#getLang('main',1265)#</cfoutput> <input type="radio" name="template_type" id="template_type" value="1" <cfif get_template.is_income neq 1>disabled<cfelse>checked</cfif>></label>
                            </div>
                    	</div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    	<div class="form-group" id="item-is_active">
                            <label><cfoutput>#getLang('main',81)#/#getLang('main',82)#</cfoutput><input type="checkbox" name="is_active" id="is_active" <cfif get_template.is_active eq 1>checked</cfif>></label>
                    	</div>
                        <div class="form-group" id="item-is_department">
                            <label><cfoutput>#getLang('main',160)#/#getLang('budget',42)#</cfoutput><input type="checkbox" name="is_department" id="is_department" value="1" <cfif get_template.is_department eq 1>checked</cfif>></label>
                    	</div>
                    </div>
				</cf_box_elements>
	<cfquery name="GET_ROWS" datasource="#dsn2#">
		SELECT 
			TEMPLATE_ID,
			RATE,
			EXPENSE_ITEM_ID,
			EXPENSE_CENTER_ID,
			PROMOTION_ID,
			EXPENSE_PLANS_TEMPLATES_ROWS.COMPANY_ID,
			COMPANY_PARTNER_ID,
			ASSET_ID,
			EXPENSE_PLANS_TEMPLATES_ROWS.PROJECT_ID,
			MEMBER_TYPE,
			DEPARTMENT_ID,
			WORKGROUP_ID,
			SC.SUBSCRIPTION_NO,
			EXPENSE_PLANS_TEMPLATES_ROWS.SUBSCRIPTION_ID
		FROM 
			EXPENSE_PLANS_TEMPLATES_ROWS 
				LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = EXPENSE_PLANS_TEMPLATES_ROWS.SUBSCRIPTION_ID
		WHERE 
			TEMPLATE_ID = #attributes.template_id#
	</cfquery>
	<cfset satir_sayi = get_rows.recordcount>			
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#satir_sayi#</cfoutput>">
	<cf_basket id="cost_bill_bask">
		<cfif GET_TEMPLATE.IS_INCOME neq 1>
			<cf_grid_list name="table1" id="table1" class="detail_basket_list">
				<thead>
					<tr>
					  <th width="15"><a onClick="add_row();"><i class="fa fa-plus"></i></a></th>
					  <th width="40" nowrap>% *</th>
					  <th style="width:200px;" nowrap><cf_get_lang_main no='1048.Masraf Merkezi'> *</th>
					  <th style="width:200px;" nowrap><cf_get_lang_main no='1139.Gider Kalemi'> *</th>
					  <th style="width:200px;" nowrap><cf_get_lang_main no='160.Departman'></th>
					  <th style="width:200px;" nowrap><cf_get_lang no='90.Aktivite Tipi'></th>
					  <th style="width:200px;" nowrap><cf_get_lang_main no='728.İş Grubu'></th>
					  <th nowrap width="200"><cf_get_lang no='51.Harcama Yapan'></th>
					  <th width="105" nowrap><cf_get_lang_main no='1421.Fiziki Varlık'></th>
					  <th><cf_get_lang_main no='1705.Abone No'></th>
					  <th width="105" nowrap><cf_get_lang_main no='4.Proje'></th>
					</tr>
				</thead>
				<cfset rate_deger = 0>
				<cfoutput query="get_rows">
					<cfif len(ASSET_ID)>
						<cfquery name="GET_ROW_ASSET" datasource="#dsn#">
							SELECT
								ASSETP_ID,
								ASSETP
							FROM
								ASSET_P
							WHERE
								ASSETP_ID = #ASSET_ID#
						</cfquery>
					</cfif>
					<cfif len(PROJECT_ID)>
						<cfquery name="GET_ROW_PROJECT" datasource="#dsn#">	
							SELECT
								PROJECT_ID,
								PROJECT_HEAD
							FROM 
								PRO_PROJECTS
							WHERE
								PROJECT_ID=#PROJECT_ID#
						</cfquery>
					</cfif>
					<cfset rate_deger = rate_deger + rate>
					<tbody>
						<tr id="frm_row#currentrow#">
							<td nowrap="nowrap"><input type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a style="cursor:pointer" onclick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
							<td nowrap="nowrap"><input type="text" name="rate#currentrow#" id="rate#currentrow#" style="width:40px;" class="moneybox" value="#TLFormat(rate)#" onkeyup="return(FormatCurrency(this,event));"><!--- onBlur="hesapla();" ---></td>
							<td nowrap="nowrap"><select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" style="width:200px;" class="txt">
									<option value=""><cf_get_lang_main no='1048.Masraf Merkezi'></option>
									<cfset expense_satir = get_rows.expense_center_id>
									<cfloop query="get_expense_center">
										<option value="#expense_id#" <cfif expense_satir eq expense_id>selected</cfif>>#expense#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap="nowrap"><select name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" style="width:200px;" class="txt">
									<option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
									<cfset item_satir = get_rows.expense_item_id>
									<cfloop query="get_expense_item_expense">
										<option value="#expense_item_id#" <cfif item_satir eq expense_item_id>selected</cfif>>#expense_item_name#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap="nowrap">
								<cfif len(department_id)>
									<cfquery name="GET_DEP" dbtype="query">
										SELECT DEPARTMENT_HEAD FROM GET_DEPARTMENT WHERE DEPARTMENT_ID=#department_id#
									</cfquery>
									<input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="#department_id#">
									<input type="text" name="department#currentrow#" id="department#currentrow#" value="#GET_DEP.DEPARTMENT_HEAD#" style="width:150px;">
								<cfelse>
									<input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="">
									<input type="text" name="department#currentrow#" id="department#currentrow#" value="" style="width:150px;">
								</cfif>
								<a href="javascript://" onClick="pencere_ac_department(#currentrow#);" style="margin-left: 5px;"><img src="/images/plus_thin.gif" alt=""></a>
							</td>
							<td nowrap="nowrap"><select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:200px;" class="txt">
									<option value=""><cf_get_lang no='90.Aktivite Tipi'></option>
									<cfset activity_satir = get_rows.promotion_id>
									<cfloop query="get_activity_types">
										<option value="#activity_id#" <cfif activity_satir eq activity_id>selected</cfif>>#activity_name#</option>
									</cfloop>
								</select>
							</td>
							<td nowrap="nowrap">
								<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:200px;" class="txt">
									<option value=""><cf_get_lang_main no='728.İş Grubu'></option>
									<cfset workgroup_satir = get_rows.workgroup_id>
									<cfloop query="GET_WORKGROUPS">
									<option value="#workgroup_id#" <cfif workgroup_satir eq workgroup_id>selected</cfif>>#workgroup_name#</option>
									</cfloop>
								</select>
							</td>
							<cfif member_type eq 'partner'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_par_info(company_id,1,0,0)#" style="width:90px;">&nbsp;<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(company_partner_id,0,-1,0)#">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"> <img src="/images/plus_thin.gif"/></a>
							</td>
							<cfelseif member_type eq 'consumer'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_cons_info(company_partner_id,2,0)#" style="width:90px;">&nbsp;<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(company_partner_id,0,0)#">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"/></a>
							</td>
							<cfelseif member_type eq 'employee'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:90px;">
								<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(company_partner_id,1,0)#">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"/></a></td>
							<cfelse>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:90px;" >
								<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"></a>
							</td>
							</cfif>
							<td nowrap="nowrap"><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="#ASSET_ID#"><input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif len(ASSET_ID)>#GET_ROW_ASSET.ASSETP#</cfif>" style="width:70px;">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_asset('#currentrow#');"><img src="/images/plus_thin.gif"/></a></td>
							<td nowrap="nowrap">
								<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="#subscription_id#">
								<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" onFocus="AutoComplete_Create('subscription_name#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','150');" value="#subscription_no#" style="width:100px;">
								<a href="javascript://" onClick="pencere_ac_subs('#currentrow#');" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
							<td nowrap="nowrap"><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#PROJECT_ID#"><input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif len(PROJECT_ID)>#GET_ROW_PROJECT.PROJECT_HEAD#</cfif>" style="width:70px;">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_project('#currentrow#');"><img src="/images/plus_thin.gif"/></a></td>
						</tr>
					</tbody>
				</cfoutput>
			</cf_grid_list>
		<cfelse>
			<cf_grid_list name="table2" id="table2" class="detail_basket_list">
				<thead>
					<tr>
					  <th width="15"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
					  <th width="40" nowrap="nowrap">% *</th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='760.Gelir Merkezi'> *</th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='761.Gelir Kalemi'> *</th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='160.Departman'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang no='90.Aktivite Tipi'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='728.İş Grubu'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang no='89.Satış Yapan'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='1421.Fiziki Varlık'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='1705.Abone No'></th>
					  <th style="width:100px;" nowrap="nowrap"><cf_get_lang_main no='4.Proje'></th>
					</tr>
				</thead>
				<cfset rate_deger = 0>
				<cfoutput query="get_rows">
					<cfif len(ASSET_ID)>
						<cfquery name="GET_ROW_ASSET" datasource="#dsn#">
							SELECT
								ASSETP_ID,
								ASSETP
							FROM
								ASSET_P
							WHERE
								ASSETP_ID = #ASSET_ID#
						</cfquery>
					</cfif>
					<cfif len(PROJECT_ID)>
						<cfquery name="GET_ROW_PROJECT" datasource="#dsn#">	
							SELECT
								PROJECT_ID,
								PROJECT_HEAD
							FROM 
								PRO_PROJECTS
							WHERE
								PROJECT_ID=#PROJECT_ID#
						</cfquery>
					</cfif>
					<cfset rate_deger = rate_deger + rate>
			    <tbody>
					<tr id="frm_row#currentrow#">
						<td nowrap="nowrap"><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" ><a style="cursor:pointer" onclick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
						<td nowrap="nowrap"><input type="text" name="rate#currentrow#" id="rate#currentrow#" style="width:40px;" class="txt" value="#TLFormat(rate)#" onkeyup="return(FormatCurrency(this,event));"><!--- onBlur="hesapla();" ---></td>
						<td nowrap="nowrap"><select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" style="width:200px;" class="txt">
								<option value=""><cf_get_lang no='381.Gelir Merkezi'></option>
								<cfset expense_satir = get_rows.expense_center_id>
								<cfloop query="get_expense_center">
								<option value="#expense_id#" <cfif expense_satir eq expense_id>selected</cfif>>#expense#</option>
								</cfloop>
							</select>
						</td>
						<td nowrap="nowrap"><select name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" style="width:200px;" class="txt">
								<option value=""><cf_get_lang_main no='761.Gelir Kalemi'></option>
								<cfset item_satir = get_rows.expense_item_id>
								<cfloop query="get_expense_item_income">
								<option value="#expense_item_id#" <cfif item_satir eq expense_item_id>selected</cfif>>#expense_item_name#</option>
								</cfloop>
							</select>
						</td>
						<td nowrap="nowrap">
							<cfif len(department_id)>
								<cfquery name="GET_DEP" dbtype="query">
									SELECT DEPARTMENT_HEAD FROM GET_DEPARTMENT WHERE DEPARTMENT_ID=#department_id#
								</cfquery>
								<input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="#department_id#">
								<input type="text" name="department#currentrow#" id="department#currentrow#" style="width:200px;" value="#GET_DEP.DEPARTMENT_HEAD#">
							<cfelse>
								<input type="hidden" name="department_id#currentrow#" id="department_id#currentrow#" value="">
								<input type="text" name="department#currentrow#" id="department#currentrow#" value="" style="width:200px;">
							</cfif>
							<a href="javascript://" onClick="pencere_ac_department(#currentrow#);" style="margin-left: 5px;"><img src="/images/plus_thin.gif"  alt="" /></a>
						</td>
						<td nowrap="nowrap"><select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:200px;" class="txt">
								<option value="">Aktivite Tipi</option>
								<cfset activity_satir = get_rows.promotion_id>
								<cfloop query="get_activity_types">
								<option value="#activity_id#" <cfif activity_satir eq activity_id>selected</cfif>>#activity_name#</option>
								</cfloop>
							</select>
						</td>
						<td nowrap="nowrap">
							<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:200px;" class="txt">
								<option value=""><cf_get_lang_main no='728.İş Grubu'></option>
								<cfset workgroup_satir = get_rows.workgroup_id>
								<cfloop query="GET_WORKGROUPS">
								<option value="#workgroup_id#" <cfif workgroup_satir eq workgroup_id>selected</cfif>>#workgroup_name#</option>
								</cfloop>
							</select>
						</td>
						<cfif member_type eq 'partner'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_par_info(company_id,1,0,0)#" style="width:90px;">&nbsp;<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(company_partner_id,0,-1,0)#">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif" /></a>
							</td>
						<cfelseif member_type eq 'consumer'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_cons_info(company_partner_id,2,0)#" style="width:90px;">&nbsp;<input type="text" style="width:90px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(company_partner_id,0,0)#" >&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif" /></a>
							</td>
						<cfelseif member_type eq 'employee'>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:90px;">
								<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(company_partner_id,1,0)#" style="width:90px;">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"/></a>
							</td>
						<cfelse>
							<td nowrap="nowrap">
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:90px;" >
								<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="" style="width:90px;">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif" /></a>
							</td>
						</cfif>
						<td nowrap="nowrap"><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="#ASSET_ID#"><input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif len(ASSET_ID)>#GET_ROW_ASSET.ASSETP#</cfif>" style="width:100px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_asset('#currentrow#');"><img src="/images/plus_thin.gif"  /></a></td>
						<td nowrap="nowrap">
							<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="#subscription_id#">
							<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" onFocus="AutoComplete_Create('subscription_name#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','150');" value="#subscription_no#" style="width:100px;">
							<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_subs('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
						</td>
						<td nowrap="nowrap"><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#PROJECT_ID#"><input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif len(PROJECT_ID)>#GET_ROW_PROJECT.PROJECT_HEAD#</cfif>" style="width:100px;">&nbsp;<a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_project('#currentrow#');"><img src="/images/plus_thin.gif" /></a></td>
					</tr>
				</tbody>
				</cfoutput>
			 </cf_grid_list>
	    </cfif>
	</cf_basket>
	<cf_box_footer>
		<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
	</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	row_count=<cfoutput>#satir_sayi#</cfoutput>;
	function sil(sy)
	{
		var my_element = document.getElementById("row_kontrol"+sy);
		my_element.value = 0;
		var my_element = document.getElementById("frm_row"+sy);
		my_element.style.display = "none";
	}
	function kontrol_et()
	{
		if(row_count == 0) return false;
		else return true;
	}
	function add_row()
	{
		row_count++;
		console.log(row_count);
		var newRow;
		var newCell;
		var template_type=<cfif GET_TEMPLATE.IS_INCOME eq 1>1<cfelse>0</cfif>;
		if(template_type==0)
		{	
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.add_costplan.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="1048.Masraf Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="1139.Gider Kalemi"></option><cfoutput query="get_expense_item_expense"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:150px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="728.İş Grubu"></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:70px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"/></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:70px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
		}
		else
		{
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.add_costplan.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="0" style="width:40px;" class="txt" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="760.Gelir Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'"  style="width:200px;" class="txt"><option value=""><cf_get_lang_main no="761.Gelir Kalemi"></option><cfoutput query="GET_EXPENSE_ITEM_INCOME"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="department_id'+ row_count +'" id="department_id'+ row_count +'" value=""><input type="text" name="department'+ row_count +'" id="department'+ row_count +'" value="" style="width:200px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_department('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="activity_type' + row_count +'" id="activity_type' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang no="90.Aktivite Tipi"></option><cfoutput query="get_activity_types"><option value="#activity_id#">#activity_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="workgroup_id' + row_count +'" id="workgroup_id' + row_count +'" style="width:200px;" class="txt"><option value=""><cf_get_lang_main no='728.İş Grubu'></option><cfoutput query="GET_WORKGROUPS"><option value="#workgroup_id#">#workgroup_name#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value=""><input type="hidden" name="member_code'+ row_count +'" id="member_code'+ row_count +'" value=""><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value=""><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="" style="width:90px;" class="txt">&nbsp;<input type="text" style="width:90px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="" class="txt"><a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"/></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value=""><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="" style="width:100px;"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value=""><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="" style="width:100px;"><a style="margin-left: 5px;" href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" /></a>';
		}
	}
	
	function pencere_ac_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_costplan.asset_id' + no +'&field_name=add_costplan.asset' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	function pencere_ac_department(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_costplan.department_id' + no +'&field_name=add_costplan.department' + no,'list');
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no);
	}
	function pencere_ac_subs(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_costplan.subscription_id' + no +'&field_no=add_costplan.subscription_name' + no,'list');
	}
	function auto_subscription(no)
	{
		AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
	}
	function pencere_ac_company(no)
	{
		document.getElementById("member_type"+no).value = '';
		document.getElementById("member_id"+no).value = '';
		document.getElementById("member_code"+no).value = '';
		document.getElementById("company_id"+no).value = '';
		document.getElementById("company"+no).value = '';
		document.getElementById("authorized"+no).value = '';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_costplan.member_code' + no +'&field_id=add_costplan.member_id' + no +'&field_comp_name=add_costplan.company' + no +'&field_name=add_costplan.authorized' + no +'&field_comp_id=add_costplan.company_id' + no + '&field_type=add_costplan.member_type' + no + '&select_list=1,2,3','list');
	}
	function kontrol()
	{
		if(add_costplan.template_name.value == "")
		{
			alert("<cf_get_lang no='77.Lütfen Şablon Adı Giriniz'>!");
		}
		var toplam_satir = 0;	
		var sira_deger = 0;
		var rate_total = 0;
		for (var r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				toplam_satir = toplam_satir + 1;
				rate_value = parseFloat(filterNum(document.getElementById("rate"+r).value));
				rate_total += rate_value;
				
				form_expense_center_id = document.getElementById("expense_center_id"+r);
				form_expense_item_id = document.getElementById("expense_item_id"+r);
				
				sira_deger = sira_deger + 1;
				if(rate_value == "")
				{
					alert("" + sira_deger + ".<cf_get_lang no='73. Satırdaki Oranı Giriniz'>!");
					return false;
				}
				if(rate_value < 0)
				{
					alert("" + sira_deger + "<cf_get_lang dictionary_id='54520.Satırdaki Oran Negatif Olamaz'>");
					return false;
				}
				if(form_expense_center_id.value =="")
				{
					alert("" + sira_deger + ". <cf_get_lang no='72. Satırdaki Masraf Merkezini Seçiniz'>!");
					return false;
				}
				if(form_expense_item_id.value =="")
				{
					alert("" + sira_deger + ". <cf_get_lang no='71. Satırdaki Gider Kalemini Seçiniz'>!");
					return false;
				}
			}
		}
		if(toplam_satir== 0)
		{
			alert("<cf_get_lang no='76.Lütfen Masraf Şablonuna Satır Ekleyiniz'>!");
			return false;
		}
		if(wrk_round(rate_total) != 100) 
		{
			alert("<cf_get_lang dictionary_id='59039.Satır Oranlarının Toplamı %100 Olmalıdır. Lütfen Kontrol Ediniz.'>");
			return false;
		}
		for (var rc=1;rc<=row_count;rc++)
		{
			if(document.getElementById("row_kontrol"+rc).value == 1)
				document.getElementById("rate"+rc).value = filterNum(document.getElementById("rate"+rc).value);
		}
		return true;
	}
</script>
