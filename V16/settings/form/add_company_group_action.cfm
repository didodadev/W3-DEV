<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_sale_order_type" datasource="#dsn#">
	SELECT
		PTR.STAGE NAME,
		PTR.PROCESS_ROW_ID ID,
		PTO.OUR_COMPANY_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_purchase_order_type" datasource="#dsn#">
	SELECT
		PTR.STAGE NAME,
		PTR.PROCESS_ROW_ID ID,
		PTO.OUR_COMPANY_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_sale_invoice_type" datasource="#dsn3#">
	<cfoutput query="get_company">
		SELECT
			PROCESS_CAT_ID ID,
			PROCESS_CAT NAME,
			#get_company.comp_id# OUR_COMPANY_ID,
			PROCESS_TYPE 
		FROM
			#dsn#_#get_company.comp_id#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(50,52,53,531,532,56,57,58,62,561,54,55,51,63,48,49,5311)
		<cfif get_company.currentrow neq get_company.recordcount>UNION ALL</cfif>
	</cfoutput>
	ORDER BY
		PROCESS_CAT
</cfquery>
<cfquery name="get_purchase_invoice_type" datasource="#dsn3#">
	<cfoutput query="get_company">
		SELECT
			PROCESS_CAT_ID ID,
			PROCESS_CAT NAME,
			#get_company.comp_id# OUR_COMPANY_ID ,
			PROCESS_TYPE 
		FROM
			#dsn#_#get_company.comp_id#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE IN(49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691)
		<cfif get_company.currentrow neq get_company.recordcount>UNION ALL</cfif>
	</cfoutput>
	ORDER BY
		PROCESS_CAT
</cfquery>
<cfquery name="get_sale_ship_type" datasource="#dsn3#">
	<cfoutput query="get_company">
		SELECT
			PROCESS_CAT_ID ID,
			PROCESS_CAT NAME,
			#get_company.comp_id# OUR_COMPANY_ID
		FROM
			#dsn#_#get_company.comp_id#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE = 71
		<cfif get_company.currentrow neq get_company.recordcount>UNION ALL</cfif>
	</cfoutput>
	ORDER BY
		PROCESS_CAT
</cfquery>
<cfquery name="get_purchase_ship_type" datasource="#dsn3#">
	<cfoutput query="get_company">
		SELECT
			PROCESS_CAT_ID ID,
			PROCESS_CAT NAME,
			#get_company.comp_id# OUR_COMPANY_ID
		FROM
			#dsn#_#get_company.comp_id#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE = 76
		<cfif get_company.currentrow neq get_company.recordcount>UNION ALL</cfif>
	</cfoutput>
	ORDER BY
		PROCESS_CAT
</cfquery>
<cfquery name="get_purhase_ship_type" datasource="#dsn3#">
	<cfoutput query="get_company">
		SELECT
			PROCESS_CAT_ID ID,
			PROCESS_CAT NAME,
			#get_company.comp_id# OUR_COMPANY_ID 
		FROM
			#dsn#_#get_company.comp_id#.SETUP_PROCESS_CAT
		WHERE
			PROCESS_TYPE = 76
		<cfif get_company.currentrow neq get_company.recordcount>UNION ALL</cfif>
	</cfoutput>
	ORDER BY
		PROCESS_CAT
</cfquery>
<cfquery name="get_actions" datasource="#dsn#">
	SELECT 
        FROM_OUR_COMP_ID, 
        FROM_ACT_TYPE, 
        FROM_COMPANY_ID, 
        FROM_PROCESS_STAGE, 
        FROM_PROCESS_TYPE, 
        TO_OUR_COMP_ID, 
        TO_ACT_TYPE, 
        TO_COMPANY_ID, 
        TO_PROCESS_STAGE, 
        TO_PROCESS_TYPE, 
        TO_PAYMETHOD_ID, 
        TO_LOC_ID, 
        TO_DEPT_ID, 
        TO_PRICE_CAT, 
        TO_SALE_EMP, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
    	COMPANY_GROUP_ACTIONS
</cfquery>
<cf_box title="Grup İçi İşlemler" >
	<cfform name="form_action" action="#request.self#?fuseaction=settings.emptypopup_add_company_group_action" method="post">
	<cf_box_elements>
		<cfoutput>
		<cf_grid_list>
		<thead>
			<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_actions.recordcount#</cfoutput>">
			<th></th>
			<th colspan="5" style="text-align:center"><cf_get_lang dictionary_id='63003.Kaydedilen'><cf_get_lang dictionary_id='57468.Belge'></th>
			<th colspan="9"  style="text-align:center"><cf_get_lang dictionary_id='63004.Oluşan'><cf_get_lang dictionary_id='57468.Belge'></th>
		</thead><thead>
			<th style="width:10px;"><a style="cursor:pointer" onclick="add_row();" title="<cf_get_lang dictionary_id='44630.Ekle'>"><i class="fa fa-plus"></i></a></th>
			<th class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58578.Belge Türü'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th class="form-title"><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58578.Belge Türü'></th>
			<th class="form-title"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th class="form-title"><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58763.Depo'></th>
			<th class="form-title"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
			<th class="form-title"><cf_get_lang dictionary_id='33008.Satış Yapan'>/<cf_get_lang dictionary_id='57775.Teslim Alan'></th>
		</thead>
		<tbody id="table1" name="table1">
			<cfloop query="get_actions">
				<cfif len(to_company_id)>
					<cfquery name="get_comp_cat" datasource="#dsn#">
						SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = #to_company_id#
					</cfquery>
					<cfset new_dsn3 = "#dsn#_#get_actions.to_our_comp_id#">
					<cfif to_act_type eq 1 or to_act_type eq 3>
						<cfquery name="get_price" datasource="#new_dsn3#">
							SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_SALES=1 AND COMPANY_CAT LIKE '%,#get_comp_cat.COMPANYCAT_ID#,%'
						</cfquery>
					<cfelse>
						<cfquery name="get_price" datasource="#new_dsn3#">
							SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_PURCHASE=1 AND COMPANY_CAT LIKE '%,#get_comp_cat.COMPANYCAT_ID#,%'
						</cfquery>
					</cfif>
				</cfif>
				<cfset new_dsn3 = "#dsn#_#get_actions.to_our_comp_id#">
				<tr id="frm_row#get_actions.currentrow#">
					<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><a style="cursor:pointer" onclick="sil(#currentrow#);" title="<cf_get_lang dictionary_id='57463.Sil'>" ><i class="fa fa-minus"></i></a></td>
					<td>
						<select name="from_our_company#currentrow#" id="from_our_company#currentrow#" style="width:120px;" onchange="change_process_type(#currentrow#,0);">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfloop query="get_company">
								<option value="#get_company.comp_id#" <cfif comp_id eq get_actions.from_our_comp_id>selected</cfif>>#get_company.company_name#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="from_act_type#currentrow#" id="from_act_type#currentrow#" style="width:100px;" onClick="control_comp(#currentrow#,0);" onchange="change_process_type(#currentrow#,0);">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<option value="1" <cfif get_actions.from_act_type eq 1>selected</cfif>>Satış Siparişi</option>
							<option value="2" <cfif get_actions.from_act_type eq 2>selected</cfif>>Alış Siparişi</option>
							<option value="3" <cfif get_actions.from_act_type eq 3>selected</cfif>>Satış Faturası</option>
							<option value="4" <cfif get_actions.from_act_type eq 4>selected</cfif>>Alış Faturası</option>
							<option value="5" <cfif get_actions.from_act_type eq 5>selected</cfif>>Satış İrsaliyesi</option>
							<option value="6" <cfif get_actions.from_act_type eq 6>selected</cfif>>Alış İrsaliyesi</option>
						</select>
					</td>
					<td nowrap>
						<input type="hidden" name="from_member_code#currentrow#" id="from_member_code#currentrow#" value="">
						<input type="hidden" name="from_member_type#currentrow#" id="from_member_type#currentrow#" value="">
						<input type="hidden" name="from_company_id#currentrow#" id="from_company_id#currentrow#"  value="#get_actions.from_company_id#">
						<input type="hidden" name="from_consumer_id#currentrow#" id="from_consumer_id#currentrow#"  value="">
						<input type="text" name="from_comp_name#currentrow#" id="from_comp_name#currentrow#" onFocus="autocomp(#currentrow#,0);"  value="#get_par_info(get_actions.from_company_id,1,0,0)#" style="width:120px" class="text"><a href="javascript://" onClick="pencere_ac_company(#currentrow#,0);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt='<cf_get_lang dictionary_id="57734.Seçiniz">'></a>
					</td>
					<td>
						<select name="from_process_stage#currentrow#" id="from_process_stage#currentrow#" style="width:140px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif get_actions.from_act_type eq 1>
								<cfloop query="get_sale_order_type">
									<cfif get_sale_order_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_sale_order_type.id#" <cfif get_actions.from_process_stage eq get_sale_order_type.id>selected</cfif>>#get_sale_order_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.from_act_type eq 2>
								<cfloop query="get_purchase_order_type">
									<cfif get_purchase_order_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_purchase_order_type.id#" <cfif get_actions.from_process_stage eq get_purchase_order_type.id>selected</cfif>>#get_purchase_order_type.name#</option>
									</cfif>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td>
						<select name="from_process_type#currentrow#" id="from_process_type#currentrow#" style="width:140px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif get_actions.from_act_type eq 3>
								<cfloop query="get_sale_invoice_type">
									<cfif get_sale_invoice_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_sale_invoice_type.id#" <cfif get_actions.from_process_type eq get_sale_invoice_type.id>selected</cfif>>#get_sale_invoice_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.from_act_type eq 4>
								<cfloop query="get_purchase_invoice_type">
									<cfif get_purchase_invoice_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_purchase_invoice_type.id#" <cfif get_actions.from_process_type eq get_purchase_invoice_type.id>selected</cfif>>#get_purchase_invoice_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.from_act_type eq 5>
								<cfloop query="get_sale_ship_type">
									<cfif get_sale_ship_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_sale_ship_type.id#" <cfif get_actions.from_process_type eq get_sale_ship_type.id>selected</cfif>>#get_sale_ship_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.from_act_type eq 6>
								<cfloop query="get_purchase_ship_type">
									<cfif get_purchase_ship_type.our_company_id eq  get_actions.from_our_comp_id>
										<option value="#get_purchase_ship_type.id#" <cfif get_actions.from_process_type eq get_purchase_ship_type.id>selected</cfif>>#get_purchase_ship_type.name#</option>
									</cfif>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td>
						<select name="to_our_company#currentrow#" id="to_our_company#currentrow#" style="width:120px;" onchange="change_process_type(#currentrow#,1);">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfloop query="get_company">
								<option value="#get_company.comp_id#" <cfif comp_id eq get_actions.to_our_comp_id>selected</cfif>>#get_company.company_name#</option>
							</cfloop>
						</select>
					</td>
					<td>
						<select name="to_act_type#currentrow#" id="to_act_type#currentrow#" style="width:100px;" onClick="control_comp(#currentrow#,1);" onchange="change_process_type(#currentrow#,1);">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<option value="1" <cfif get_actions.to_act_type eq 1>selected</cfif>>Satış Siparişi</option>
							<option value="2" <cfif get_actions.to_act_type eq 2>selected</cfif>>Alış Siparişi</option>
							<option value="3" <cfif get_actions.to_act_type eq 3>selected</cfif>>Satış Faturası</option>
							<option value="4" <cfif get_actions.to_act_type eq 4>selected</cfif>>Alış Faturası</option>
							<option value="5" <cfif get_actions.to_act_type eq 5>selected</cfif>>Satış İrsaliyesi</option>
							<option value="6" <cfif get_actions.to_act_type eq 6>selected</cfif>>Alış İrsaliyesi</option>
						</select>
					</td>
					<td nowrap>
						<input type="hidden" name="to_member_code#currentrow#" id="to_member_code#currentrow#" value="">
						<input type="hidden" name="to_member_type#currentrow#" id="to_member_type#currentrow#" value="">
						<input type="hidden" name="to_company_id#currentrow#" id="to_company_id#currentrow#"  value="#get_actions.to_company_id#">
						<input type="hidden" name="to_consumer_id#currentrow#" id="to_consumer_id#currentrow#"  value="">
						<input type="text" name="to_comp_name#currentrow#" id="to_comp_name#currentrow#" onFocus="autocomp(#currentrow#,1);"  value="#get_par_info(get_actions.to_company_id,1,0,0)#" style="width:120px" class="text"><a href="javascript://" onClick="pencere_ac_company(#currentrow#,1);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
					</td>
					<td>
						<select name="to_process_stage#currentrow#" id="to_process_stage#currentrow#" style="width:140px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif get_actions.to_act_type eq 1>
								<cfloop query="get_sale_order_type">
									<cfif get_sale_order_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_sale_order_type.id#" <cfif get_actions.to_process_stage eq get_sale_order_type.id>selected</cfif>>#get_sale_order_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.to_act_type eq 2>
								<cfloop query="get_purchase_order_type">
									<cfif get_purchase_order_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_purchase_order_type.id#" <cfif get_actions.to_process_stage eq get_purchase_order_type.id>selected</cfif>>#get_purchase_order_type.name#</option>
									</cfif>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td>
						<select name="to_process_type#currentrow#" id="to_process_type#currentrow#" style="width:140px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif get_actions.to_act_type eq 3>
								<cfloop query="get_sale_invoice_type">
									<cfif get_sale_invoice_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_sale_invoice_type.id#" <cfif get_actions.to_process_type eq get_sale_invoice_type.id>selected</cfif>>#get_sale_invoice_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.to_act_type eq 4>
								<cfloop query="get_purchase_invoice_type">
									<cfif get_purchase_invoice_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_purchase_invoice_type.id#" <cfif get_actions.to_process_type eq get_purchase_invoice_type.id>selected</cfif>>#get_purchase_invoice_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.to_act_type eq 5>
								<cfloop query="get_sale_ship_type">
									<cfif get_sale_ship_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_sale_ship_type.id#" <cfif get_actions.to_process_type eq get_sale_ship_type.id>selected</cfif>>#get_sale_ship_type.name#</option>
									</cfif>
								</cfloop>
							<cfelseif get_actions.to_act_type eq 6>
								<cfloop query="get_purchase_ship_type">
									<cfif get_purchase_ship_type.our_company_id eq  get_actions.to_our_comp_id>
										<option value="#get_purchase_ship_type.id#" <cfif get_actions.to_process_type eq get_purchase_ship_type.id>selected</cfif>>#get_purchase_ship_type.name#</option>
									</cfif>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td nowrap>
						<cfif len(to_paymethod_id)>
							<cfquery name="get_paymethod_detail" datasource="#dsn#">
								SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #to_paymethod_id#
							</cfquery>
						</cfif>
						<input type="hidden" name="paymethod_id#currentrow#" id="paymethod_id#currentrow#" value="#to_paymethod_id#">
						<input type="text" name="paymethod#currentrow#" id="paymethod#currentrow#" style="width:100px;" value="<cfif len(to_paymethod_id)>#get_paymethod_detail.paymethod#</cfif>"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_action.paymethod_id#currentrow#&field_name=form_action.paymethod#currentrow#&is_paymethods=1','list');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
					</td>
					<td nowrap>
						<cfif len(to_dept_id) and len(to_loc_id)>
							<cfquery name="get_dept" datasource="#DSN#">
								SELECT
									D.DEPARTMENT_ID,
									D.DEPARTMENT_HEAD,
									SL.COMMENT
								FROM
									DEPARTMENT D,
									STOCKS_LOCATION SL
								WHERE
									D.DEPARTMENT_ID = #to_dept_id#
									AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
									AND SL.LOCATION_ID = #to_loc_id# 
							</cfquery>
						</cfif>
						<input type="hidden" name="deliver_dept_id#currentrow#" id="deliver_dept_id#currentrow#" value="#to_dept_id#-#to_loc_id#">
						<input type="text" name="deliver_dept#currentrow#" id="deliver_dept#currentrow#" style="width:120px;" value="<cfif len(to_dept_id) and len(to_loc_id)>#get_dept.department_head#-#get_dept.comment#</cfif>"><a href="javascript://" onClick="open_dept(#currentrow#);"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
					</td>
					<td>
						<select name="price_catid#currentrow#" id="price_catid#currentrow#" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif len(to_company_id)>
								<cfloop query="get_price">
									<option value="#get_price.price_catid#" <cfif get_actions.to_price_cat eq get_price.price_catid>selected</cfif>>#get_price.price_cat#</option>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td nowrap>
						<input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#to_sale_emp#">
						<input type="text" style="width:115px;" onFocus="autocomp_employee(#currentrow#);" name="employee_name_#currentrow#" id="employee_name_#currentrow#" value="#get_emp_info(to_sale_emp,0,0)#" class="text">
						<a href="javascript://" onClick="pencere_ac_employee1(#currentrow#);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>
					</td>
				</tr>
			</cfloop>
		</tbody>
		</cf_grid_list>
	</cfoutput>
	</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_actions">
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	var row_count="<cfoutput>#get_actions.recordcount#</cfoutput>";
	function sil(sy)
	{
		var my_element=eval("form_action.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function autocomp(no,type)
	{
		if(type == 0)
			AutoComplete_Create("from_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1\",0,0,0","ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID","from_member_code"+no+",from_member_type"+no+",from_company_id"+no+",from_consumer_id"+no+"","",3,250,"get_comp_cat("+ row_count +")");
		else
			AutoComplete_Create("to_comp_name"+no,"MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE","get_member_autocomplete","\"1\",0,0,0","ACCOUNT_CODE,MEMBER_TYPE,COMPANY_ID,CONSUMER_ID","to_member_code"+no+",to_member_type"+no+",to_company_id"+no+",to_consumer_id"+no+"","",3,250,"get_comp_cat("+ row_count +")");
	}
	function pencere_ac_company(sira_no,type)
	{
		if(type == 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&row_no='+sira_no+'&select_list=2&field_comp_id=form_action.from_company_id'+ sira_no +'&field_member_name=form_action.from_comp_name'+ sira_no +'&field_member_account_code=form_action.from_member_code'+ sira_no +'&field_type=form_action.from_member_type' + sira_no + '&field_name=form_action.from_comp_name' + sira_no +'&field_consumer=form_action.from_consumer_id'+ sira_no +'&call_function=get_comp_cat('+sira_no+')','list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&row_no='+sira_no+'&select_list=2&field_comp_id=form_action.to_company_id'+ sira_no +'&field_member_name=form_action.to_comp_name'+ sira_no +'&field_member_account_code=form_action.to_member_code'+ sira_no +'&field_type=form_action.to_member_type' + sira_no + '&field_name=form_action.to_comp_name' + sira_no +'&field_consumer=form_action.to_consumer_id'+ sira_no +'&call_function=get_comp_cat('+sira_no+')','list');
	}
	function open_dept(sira_no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&system_company_id='+eval('document.all.to_our_company'+sira_no).value+'</cfoutput>&field_id=deliver_dept_id'+ sira_no +'&field_name=deliver_dept'+ sira_no +'&form_name=form_action','list');
	}
	function pencere_ac_employee1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_action.employee_id_' + no +'&field_name=form_action.employee_name_' + no +'&select_list=1,9','list');
	}
	function autocomp_employee(no)
	{
		AutoComplete_Create("employee_name_"+no,"MEMBER_NAME","MEMBER_NAME","get_member_autocomplete","3","EMPLOYEE_ID","employee_id_"+no,"",3,140);
	}
	function get_comp_cat(row_no)
	{
		new_dsn3_ = "<cfoutput>#dsn#</cfoutput>_"+eval('document.all.to_our_company'+row_no).value+"";
		if(eval('document.all.to_act_type'+row_no).value == 1 || eval('document.all.to_act_type'+row_no).value == 3)
		{
			var get_comp_cat=wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID ="+eval('document.all.to_company_id'+row_no).value,"dsn");
			var get_price_cat=wrk_query("SELECT PRICE_CATID,PRICE_CAT FROM "+new_dsn3_+".PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_SALES=1 AND COMPANY_CAT LIKE '%,"+get_comp_cat.COMPANYCAT_ID+",%'","dsn3");
			var price_len = eval('document.getElementById("price_catid"+row_no)').options.length;
			for(kk=price_len;kk>=0;kk--)
				eval('document.getElementById("price_catid"+row_no)').options[kk] = null;	
				
			eval('document.getElementById("price_catid"+row_no)').options[0] = new Option('Seçiniz','');
	
			for(var jj=0;jj < get_price_cat.recordcount;jj++)
				eval('document.getElementById("price_catid"+row_no)').options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);
		}
		else
		{
			var get_comp_cat=wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID ="+eval('document.all.to_company_id'+row_no).value,"dsn");
			var get_price_cat=wrk_query("SELECT PRICE_CATID,PRICE_CAT FROM "+new_dsn3_+".PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND IS_PURCHASE=1 AND COMPANY_CAT LIKE '%,"+get_comp_cat.COMPANYCAT_ID+",%'","dsn3");
			var price_len = eval('document.getElementById("price_catid"+row_no)').options.length;
			for(kk=price_len;kk>=0;kk--)
				eval('document.getElementById("price_catid"+row_no)').options[kk] = null;	
				
			eval('document.getElementById("price_catid"+row_no)').options[0] = new Option('Seçiniz','');
	
			for(var jj=0;jj < get_price_cat.recordcount;jj++)
				eval('document.getElementById("price_catid"+row_no)').options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);
		}
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.form_action.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');" title="<cf_get_lang dictionary_id='57463.Sil'>" ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="from_our_company'+row_count+'" id="from_our_company'+row_count+'"  style="width:120px;" onchange="change_process_type(' + row_count + ',0);"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_company"><option value="#comp_id#">#company_name#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="from_act_type'+row_count+'" id="from_act_type'+row_count+'" style="width:100px;" onClick="control_comp(' + row_count + ',0);" onchange="change_process_type(' + row_count + ',0);"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option value="1">Satış Siparişi</option><option value="2">Alış Siparişi</option><option value="3">Satış Faturası</option><option value="4">Alış Faturası</option><option value="5">Satış İrsaliyesi</option><option value="6">Alış İrsaliyesi</option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="from_member_code' + row_count +'" id="from_member_code' + row_count +'" value=""><input type="hidden" name="from_member_type' + row_count +'" id="from_member_type' + row_count +'" value=""><input type="hidden" name="from_company_id' + row_count +'" id="from_company_id' + row_count +'"  value=""><input type="hidden" name="from_consumer_id' + row_count +'" id="from_consumer_id' + row_count +'"  value=""><input type="text" name="from_comp_name' + row_count +'" id="from_comp_name' + row_count +'" onFocus="autocomp('+row_count+',0);"  value="" style="width:120px;" class="text"><a href="javascript://" onClick="pencere_ac_company('+ row_count +',0);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="from_process_stage'+row_count+'" id="from_process_stage'+row_count+'" style="width:140px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="from_process_type'+row_count+'" id="from_process_type'+row_count+'" style="width:140px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="to_our_company'+row_count+'" id="to_our_company'+row_count+'" style="width:120px;" onchange="change_process_type(' + row_count + ',1);"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_company"><option value="#comp_id#">#company_name#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="to_act_type'+row_count+'" id="to_act_type'+row_count+'" style="width:100px;" onClick="control_comp(' + row_count + ',1);" onchange="change_process_type(' + row_count + ',1);"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option value="1">Satış Siparişi</option><option value="2">Alış Siparişi</option><option value="3">Satış Faturası</option><option value="4">Alış Faturası</option><option value="5">Satış İrsaliyesi</option><option value="6">Alış İrsaliyesi</option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="to_member_code' + row_count +'" id="to_member_code' + row_count +'" value=""><input type="hidden" name="to_member_type' + row_count +'" id="to_member_type' + row_count +'" value=""><input type="hidden" name="to_company_id' + row_count +'" id="to_company_id' + row_count +'"  value=""><input type="hidden" name="to_consumer_id' + row_count +'" id="to_consumer_id' + row_count +'"  value=""><input type="text" name="to_comp_name' + row_count +'" id="to_comp_name' + row_count +'" onFocus="autocomp('+row_count+',1);"  value="" style="width:120px;" class="text"><a href="javascript://" onClick="pencere_ac_company('+ row_count +',1);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="to_process_stage'+row_count+'" id="to_process_stage'+row_count+'" style="width:140px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="to_process_type'+row_count+'" id="to_process_type'+row_count+'" style="width:140px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="card_paymethod_id' + row_count +'" value=""><input type="hidden" name="paymethod_id' + row_count +'" value=""><input type="text" name="paymethod' + row_count +'" style="width:100px;" value=""><a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_paymethods</cfoutput>&field_id=form_action.paymethod_id" + row_count + "&field_name=form_action.paymethod" + row_count + "&is_paymethods=1','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="deliver_dept_id' + row_count +'" value=""><input type="text" name="deliver_dept' + row_count +'" value="" class="text" style="width:120px;"><a href="javascript://" onClick="open_dept('+row_count+');"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="price_catid'+row_count+'" id="price_catid'+row_count+'" style="width:120px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="employee_id_' + row_count +'" name="employee_id_' + row_count +'"><input type="text" id="employee_name_' + row_count +'" name="employee_name_' + row_count +'" style="width:115px;" onFocus="autocomp_employee('+row_count+');">&nbsp;<a onclick="javascript:pencere_ac_employee1(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	}
	function control_comp(row_no,type)
	{
		if(type == 0)
		{
			if(eval('document.all.from_our_company'+row_no).value == "")
			{
				alert("Lütfen Şirket Seçiniz !");
				return false;
			}
		}
		else
		{
			if(eval('document.all.to_our_company'+row_no).value == "")
			{
				alert("Lütfen Şirket Seçiniz !");
				return false;
			}
		}
	}
	function change_process_type(row_no,type)
	{
		if(type == 0)
		{
			var process_id_len = eval('document.getElementById("from_process_stage"+row_no)').options.length;
			for(j=process_id_len;j>=0;j--)
				eval('document.getElementById("from_process_stage"+row_no)').options[j] = null;	
			var process_id_len = eval('document.getElementById("from_process_type"+row_no)').options.length;
			for(j=process_id_len;j>=0;j--)
				eval('document.getElementById("from_process_type"+row_no)').options[j] = null;	
			eval('document.getElementById("from_process_stage"+row_no)').options[0] = new Option('Seçiniz','');
			eval('document.getElementById("from_process_type"+row_no)').options[0] = new Option('Seçiniz','');
			
			
			if(eval('document.all.from_act_type'+row_no).value == 1)//satış siparişi
			{
				jj = 0;
				var listParam = 'sales.list_order' + "*" + eval('document.all.from_our_company'+row_no).value;
				var get_sales_order = wrk_safe_query('get_group_action1','dsn',0,listParam);
				for(i=0;i < get_sales_order.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sales_order.ID[i];
					name = get_sales_order.NAME[i];
					eval('document.getElementById("from_process_stage"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.from_act_type'+row_no).value == 2)//alış siparişi
			{
				jj = 0;
				var listParam = 'purchase.list_order' + "*" + eval('document.all.from_our_company'+row_no).value;
				var get_purchase_order = wrk_safe_query('get_group_action1','dsn',0,listParam);
				for(i=0;i < get_purchase_order.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_order.ID[i];
					name = get_purchase_order.NAME[i];
					eval('document.getElementById("from_process_stage"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.from_act_type'+row_no).value == 3)//satış faturası
			{
				jj = 0;
				var sale_invoice_list = '50,52,53,531,532,56,57,58,62,561,54,55,51,63,48,49,5311';
				var listParam = eval('document.all.from_our_company'+row_no).value + "*" + sale_invoice_list;
				var get_sale_invoice = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_sale_invoice.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sale_invoice.ID[i];
					name = get_sale_invoice.NAME[i];
					eval('document.getElementById("from_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.from_act_type'+row_no).value == 4)//alış faturası
			{
				jj = 0;
				var purchase_invoice_list = '49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691';
				var listParam = eval('document.all.from_our_company'+row_no).value + "*" + purchase_invoice_list;
				var get_purchase_invoice = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_purchase_invoice.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_invoice.ID[i];
					name = get_purchase_invoice.NAME[i];
					eval('document.getElementById("from_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.from_act_type'+row_no).value == 5)//satış irsaliyesi
			{
				jj = 0;
				var sale_ship_list = '71';
				var listParam = eval('document.all.from_our_company'+row_no).value + "*" + sale_ship_list;
				var get_sale_ship = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_sale_ship.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sale_ship.ID[i];
					name = get_sale_ship.NAME[i];
					eval('document.getElementById("from_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.from_act_type'+row_no).value == 6)//alış irsaliyesi
			{
				jj = 0;
				var purchase_ship_list = '76';
				var listParam = eval('document.all.from_our_company'+row_no).value + "*" + purchase_ship_list;
				var get_purchase_ship = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_purchase_ship.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_ship.ID[i];
					name = get_purchase_ship.NAME[i];
					eval('document.getElementById("from_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
		}
		else
		{
			var process_id_len = eval('document.getElementById("to_process_stage"+row_no)').options.length;
			for(j=process_id_len;j>=0;j--)
				eval('document.getElementById("to_process_stage"+row_no)').options[j] = null;	
			var process_id_len = eval('document.getElementById("to_process_type"+row_no)').options.length;
			for(j=process_id_len;j>=0;j--)
				eval('document.getElementById("to_process_type"+row_no)').options[j] = null;	
			eval('document.getElementById("to_process_stage"+row_no)').options[0] = new Option('Seçiniz','');
			eval('document.getElementById("to_process_type"+row_no)').options[0] = new Option('Seçiniz','');
				
			if(eval('document.all.to_act_type'+row_no).value == 1)//satış siparişi
			{
				jj = 0;
				var listParam = 'sales.list_order' + "*" + eval('document.all.to_our_company'+row_no).value;
				var get_sales_order = wrk_safe_query('get_group_action1','dsn',0,listParam);
				for(i=0;i < get_sales_order.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sales_order.ID[i];
					name = get_sales_order.NAME[i];
					eval('document.getElementById("to_process_stage"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.to_act_type'+row_no).value == 2)//alış siparişi
			{
				jj = 0;
				var listParam = 'purchase.list_order' + "*" + eval('document.all.to_our_company'+row_no).value;
				var get_purchase_order = wrk_safe_query('get_group_action1','dsn',0,listParam);
				for(i=0;i < get_purchase_order.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_order.ID[i];
					name = get_purchase_order.NAME[i];
					eval('document.getElementById("to_process_stage"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.to_act_type'+row_no).value == 3)//satış faturası
			{
				jj = 0;
				var sale_invoice_list = '50,52,53,531,532,56,57,58,62,561,54,55,51,63,48,49,5311';
				var listParam = eval('document.all.to_our_company'+row_no).value + "*" + sale_invoice_list;
				var get_sale_invoice = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_sale_invoice.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sale_invoice.ID[i];
					name = get_sale_invoice.NAME[i];
					eval('document.getElementById("to_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.to_act_type'+row_no).value == 4)//alış faturası
			{
				jj = 0;
				var purchase_invoice_list = '49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691';
				var listParam = eval('document.all.to_our_company'+row_no).value + "*" + purchase_invoice_list;
				var get_purchase_invoice = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_purchase_invoice.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_invoice.ID[i];
					name = get_purchase_invoice.NAME[i];
					eval('document.getElementById("to_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.to_act_type'+row_no).value == 5)//satış irsaliyesi
			{
				jj = 0;
				var sale_ship_list = '71';
				var listParam = eval('document.all.to_our_company'+row_no).value + "*" + sale_ship_list;
				var get_sale_ship = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_sale_ship.recordcount;i++)
				{
					jj = jj + 1;
					id = get_sale_ship.ID[i];
					name = get_sale_ship.NAME[i];
					eval('document.getElementById("to_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
			else if(eval('document.all.to_act_type'+row_no).value == 6)//alış irsaliyesi
			{
				jj = 0;
				var purchase_ship_list = '76';
				var listParam = eval('document.all.to_our_company'+row_no).value + "*" + purchase_ship_list;
				var get_purchase_ship = wrk_safe_query('get_group_action2','dsn3',0,listParam);
				for(i=0;i < get_purchase_ship.recordcount;i++)
				{
					jj = jj + 1;
					id = get_purchase_ship.ID[i];
					name = get_purchase_ship.NAME[i];
					eval('document.getElementById("to_process_type"+row_no)').options[jj]=new Option(''+name+'',''+id+'');
				}
			}
		}
	}
	function kontrol()
	{
		for(i=1;i<=row_count;i++)
		{
			if (eval("form_action.row_kontrol"+i).value == 1)
			{
				if(eval("form_action.from_our_company"+i).value=='' || eval("form_action.to_our_company"+i).value=='')
				{	
					alert("<cf_get_lang no ='1909.Lütfen Her Satırda Şirket Seçiniz'> !");
					return false;
				}
				if(eval("form_action.from_act_type"+i).value=='' || eval("form_action.to_act_type"+i).value=='')
				{	
					alert("Lütfen Her Satırda Belge Türü Seçiniz !");
					return false;
				}
				if(eval("form_action.to_act_type"+i).value==1 || eval("form_action.to_act_type"+i).value==2)
				{
					if(eval("form_action.to_process_stage"+i).value=='')
					{	
						alert("Lütfen Oluşacak Belge İçin Süreç Seçiniz !");
						return false;
					}
					if(eval("form_action.employee_id_"+i).value=='')
					{	
						alert("Lütfen Oluşacak Belge İçin Satış Yapan Seçiniz !");
						return false;
					}
				}
				else
				{
					if(eval("form_action.to_process_type"+i).value=='')
					{	
						alert("Lütfen Oluşacak Belge İçin İşlem Kategorisi Seçiniz !");
						return false;
					}
					if(eval("form_action.deliver_dept_id"+i).value=='' || eval("form_action.deliver_dept"+i).value=='')
					{	
						alert("Lütfen Oluşacak Belge İçin Depo Seçiniz !");
						return false;
					}
					if(eval("form_action.employee_id_"+i).value=='')
					{	
						alert("Lütfen Oluşacak Belge İçin Teslim Alan Seçiniz !");
						return false;
					}
				}
			}
		}
		return true;
	}
</script>
