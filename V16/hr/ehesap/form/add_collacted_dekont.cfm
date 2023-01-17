<cf_xml_page_edit fuseact="ehesap.popup_add_collacted_dekont">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfif attributes.is_virtual_puantaj eq 0>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfelse>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ_VIRTUAL">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_VIRTUAL">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT_VIRTUAL">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD_VIRTUAL">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
</cfif>
<cfparam name="attributes.action_employee_id" default="#session.ep.userid#">
<cfparam name="attributes.action_employee_name" default="#get_emp_info(session.ep.userid,0,0)#">
<cfparam name="attributes.paper_no" default="">
<cfif isdefined("attributes.dekont_type")>
	<cfquery name="get_people" datasource="#dsn#">
		SELECT
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES_IN_OUT_PERIOD.EXPENSE_CODE,
			EMPLOYEES_IN_OUT.IN_OUT_ID,
			EMPLOYEES_IN_OUT_PERIOD.EXPENSE_ITEM_ID,
			B.COMPANY_ID,
			(SELECT TOP 1 EA.ACC_TYPE_ID FROM EMPLOYEES_ACCOUNTS EA INNER JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EA.ACC_TYPE_ID WHERE EA.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND (SA.IS_SALARY_ACCOUNT = 1 OR SA.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#) ACC_TYPE_ID,
			(SELECT TOP 1 SC.ACC_TYPE_NAME FROM EMPLOYEES_ACCOUNTS EA,SETUP_ACC_TYPE SC WHERE SC.ACC_TYPE_ID = EA.ACC_TYPE_ID AND EA.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND (SC.IS_SALARY_ACCOUNT = 1 OR SC.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#) ACC_TYPE_NAME
		FROM			
			EMPLOYEES,
			EMPLOYEES_IDENTY,
			EMPLOYEES_IN_OUT,
			EMPLOYEES_IN_OUT_PERIOD,
			BRANCH B
		WHERE
			EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_IN_OUT_PERIOD.IN_OUT_ID AND
			EMPLOYEES_IN_OUT_PERIOD.PERIOD_ID = #session.ep.period_id# AND
			EMPLOYEES_IN_OUT.BRANCH_ID = B.BRANCH_ID AND
			EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND 
			EMPLOYEES_IN_OUT.IN_OUT_ID IN (#attributes.IN_OUT_ID_LIST#)
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
	</cfquery>
	<cfset get_puantaj_rows = QueryNew("EMPLOYEE_ID,IN_OUT_ID,TUTAR,NET_UCRET,EXPENSE_ITEM_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EXPENSE_CODE,VERGI_IADESI,ACC_TYPE_ID,ACC_TYPE_NAME","Integer,Integer,Double,Double,Integer,VarChar,VarChar,VarChar,Double,Integer,VarChar")>
	<cfset ROW_OF_QUERY = 0>	
	<cfset company_id_list = listdeleteduplicates(valuelist(get_people.COMPANY_ID))>	
	<cfif listlen(company_id_list) gt 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='59551.Farklı Şirketleri Tek Dekontla İşleyemezsiniz'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfset get_puantaj.company_id = get_people.COMPANY_ID>
	<cfset GET_PUANTAJ.sal_year = session.ep.period_year>
	<cfset GET_PUANTAJ.sal_mon = attributes.sal_mon>
	<cfset puantaj_gun_ = daysinmonth(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,1))>
	<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,1))>
	<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,puantaj_gun_)))>
	<cfoutput query="get_people">
		<cfset in_out_id_ = in_out_id>
		<cfset sira_ = listfindnocase(attributes.in_out_id_list,in_out_id_)>
		<cfif attributes.dekont_type eq 1>
			<cfset tutar_ = listgetat(attributes.gr_durum,sira_)>
		<cfelseif attributes.dekont_type eq 2>
			<cfset tutar_ = listgetat(attributes.resmi_durum,sira_)>
		<cfelseif attributes.dekont_type eq 3>
			<cfset tutar_ = listgetat(attributes.agi_durum,sira_)>
		<cfelseif attributes.dekont_type eq 4>
			<cfset tutar_ = listgetat(attributes.son_durum,sira_)>
		<cfelseif attributes.dekont_type eq 5>
			<cfset tutar_ = listgetat(attributes.son_durum,sira_)>
		<cfelseif attributes.dekont_type eq 6>
			<cfset tutar_ = listgetat(attributes.gr_avans_durum,sira_)>
		</cfif>
		<cfif tutar_ gt 0>
		<cfscript>
			ROW_OF_QUERY = ROW_OF_QUERY + 1;
			QueryAddRow(get_puantaj_rows,1);
			QuerySetCell(get_puantaj_rows,"EMPLOYEE_ID",employee_id,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"IN_OUT_ID",in_out_id,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"TUTAR",tutar_,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"NET_UCRET",tutar_,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"EXPENSE_ITEM_ID",EXPENSE_ITEM_ID,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"EMPLOYEE_NAME",employee_name,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"EMPLOYEE_SURNAME",employee_surname,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"EXPENSE_CODE",EXPENSE_CODE,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"ACC_TYPE_ID",ACC_TYPE_ID,ROW_OF_QUERY);
			QuerySetCell(get_puantaj_rows,"ACC_TYPE_NAME",ACC_TYPE_NAME,ROW_OF_QUERY);
		</cfscript>
		</cfif>
	</cfoutput>
<cfelse>
	<cfquery name="GET_PUANTAJ" datasource="#dsn#">
		SELECT
			EP.*,
			B.COMPANY_ID,
			B.BRANCH_ID
		FROM
			#main_puantaj_table# EP,
			BRANCH B
		WHERE
			<!---EP.SSK_OFFICE_NO = B.SSK_NO AND
			EP.SSK_OFFICE = B.SSK_OFFICE AND--->
			EP.SSK_BRANCH_ID = B.BRANCH_ID AND
			EP.PUANTAJ_ID = #attributes.puantaj_id#
	</cfquery>
	<cfset puantaj_gun_ = daysinmonth(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,1))>
	<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,1))>
	<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,puantaj_gun_)))>
	<cfquery name="get_puantaj_rows" datasource="#dsn#">
		SELECT DISTINCT
			EMPLOYEES_PUANTAJ_ROWS.*,
			EMPLOYEES.HIERARCHY,
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.GROUP_STARTDATE,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES_IN_OUT.USE_SSK,
			EMPLOYEES_IN_OUT_PERIOD.EXPENSE_CODE,
			EMPLOYEES_IN_OUT_PERIOD.EXPENSE_ITEM_ID,
			BRANCH.BRANCH_ID,
			ISNULL(
			(
				SELECT 
					SUM(#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT))
				FROM
					EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
					EMPLOYEES_PUANTAJ_ROWS EPR
				WHERE
					EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
					AND EPR.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
					AND EPR.PUANTAJ_ID = #get_puantaj.puantaj_id#
					AND EPR.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
					AND EXT.EXT_TYPE = 1
			)
			,0) KESINTI,
			(SELECT TOP 1 EA.ACC_TYPE_ID FROM EMPLOYEES_ACCOUNTS EA INNER JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EA.ACC_TYPE_ID WHERE EA.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND (SA.IS_SALARY_ACCOUNT = 1 OR SA.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#) ACC_TYPE_ID,
			(SELECT TOP 1 SC.ACC_TYPE_NAME FROM EMPLOYEES_ACCOUNTS EA,SETUP_ACC_TYPE SC WHERE SC.ACC_TYPE_ID = EA.ACC_TYPE_ID AND EA.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND (SC.IS_SALARY_ACCOUNT = 1 OR SC.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#) ACC_TYPE_NAME
            <cfif isdefined('xml_vergi_iadesi_acc_type_id') and len(xml_vergi_iadesi_acc_type_id)>
				,(SELECT TOP 1 EA.ACC_TYPE_ID FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND EA.ACC_TYPE_ID = #xml_vergi_iadesi_acc_type_id# AND EA.PERIOD_ID = #session.ep.period_id#) VERGI_IADESI_ACC_TYPE_ID
				,(SELECT TOP 1 SC.ACC_TYPE_NAME FROM EMPLOYEES_ACCOUNTS EA,SETUP_ACC_TYPE SC WHERE SC.ACC_TYPE_ID = EA.ACC_TYPE_ID AND EA.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND EA.ACC_TYPE_ID = #xml_vergi_iadesi_acc_type_id# AND EA.PERIOD_ID = #session.ep.period_id#) VERGI_IADESI_ACC_TYPE_NAME
			</cfif>
		FROM
			#row_puantaj_table# AS EMPLOYEES_PUANTAJ_ROWS,
			#main_puantaj_table# AS EMPLOYEES_PUANTAJ,
			EMPLOYEES,
			EMPLOYEES_IDENTY,
			EMPLOYEES_IN_OUT,
			EMPLOYEES_IN_OUT_PERIOD,
			BRANCH
		WHERE
			EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_IN_OUT_PERIOD.IN_OUT_ID AND
			EMPLOYEES_IN_OUT_PERIOD.PERIOD_ID = #session.ep.period_id# AND	
			EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND
			EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = #get_puantaj.PUANTAJ_ID# AND
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
			EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND
			EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
			EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
			EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND 
			EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# AND 
			(EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
	</cfquery>
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		MONEY, 
		RATE1, 
		RATE2, 
		MONEY_STATUS, 
		PERIOD_ID, 
		COMPANY_ID, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfif len(session.ep.other_money)>
	<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
		SELECT 
			MONEY, 
			RATE1, 
			RATE2, 
			MONEY_STATUS, 
			PERIOD_ID, 
			COMPANY_ID, 
			RECORD_DATE, 
			RECORD_EMP, 
			RECORD_IP, 
			UPDATE_DATE, 
			UPDATE_EMP, 
			UPDATE_IP 
		FROM 
			SETUP_MONEY 
		WHERE 
			PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY = '#session.ep.other_money#'
	</cfquery>
<cfelse>
	<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
		SELECT 
			MONEY, 
			RATE1, 
			RATE2, 
			MONEY_STATUS, 
			PERIOD_ID, 
			COMPANY_ID, 
			RECORD_DATE, 
			RECORD_EMP, 
			RECORD_IP, 
			UPDATE_DATE, 
			UPDATE_EMP, 
			UPDATE_IP 
		FROM 
			SETUP_MONEY 
		WHERE 
			PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND MONEY = '#session.ep.money2#'
	</cfquery>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='29946.Ücret Dekontu'></cfsavecontent>
	<cf_box title="#head#">
		<cfform name="add_dekont" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_collacted_dekont">
			<cf_basket_form id="collacted_dekont">
				<input type="hidden" name="is_virtual" id="is_virtual" value="<cfoutput>#attributes.is_virtual_puantaj#</cfoutput>">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="sal_year" id="sal_year" value="<cfoutput><cfif isdefined("GET_PUANTAJ.sal_year")>#GET_PUANTAJ.sal_year#<cfelse>#session.ep.period_year#</cfif></cfoutput>">
				<input type="hidden" name="sal_mon" id="sal_mon" value="<cfoutput><cfif isdefined("GET_PUANTAJ.sal_mon")>#GET_PUANTAJ.sal_mon#<cfelse>#month(now())#</cfif></cfoutput>">
				<cfif not isdefined("attributes.dekont_type")>
					<input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#get_puantaj.puantaj_id#</cfoutput>"> 
					<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_puantaj.branch_id#</cfoutput>">
				<cfelse>
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id_list#</cfoutput>">
				</cfif>
				<input type="hidden" name="xml_code_control" id="xml_code_control" value="<cfoutput>#xml_code_control#</cfoutput>">
				
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'> *</label>
							<div class="col col-9 col-xs-12"><cf_workcube_process_cat></div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57880.Belge No'> *</label>
							<div class="col col-9 col-xs-12"><input type="text" name="paper_no" id="paper_no" style="width:130px;" value="<cfoutput>#attributes.paper_no#</cfoutput>"></div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-9 col-xs-12"><textarea name="action_detail" id="action_detail" style="width:130px;height:45px;"></textarea></div>
						</div>							
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'>*</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57879.İşlem Tarihi'></cfsavecontent>
									<cfinput type="text" name="action_date" value="#dateformat(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,puantaj_gun_),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" style="width:120px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="action_employee_id" id="action_employee_id" value="<cfoutput>#attributes.action_employee_id#</cfoutput>">
									<input type="text" name="action_employee_name" id="action_employee_name" value="<cfoutput>#attributes.action_employee_name#</cfoutput>">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_dekont.action_employee_id&field_name=add_dekont.action_employee_name&select_list=1','list');"></span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cfif session.ep.company_id eq get_puantaj.company_id or session.ep.period_year eq get_puantaj.sal_year>
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					<cfelse>
						<cf_get_lang dictionary_id="59552.İşlem Yapmak İçin İlgili Döneme Geçiniz">!
					</cfif>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="collacted_dekont_bask">
				<cf_grid_list sort="0"  id="table1">
					<thead>
						<tr>
							<th style="width:20px;"><a href="javascript://" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"><i clasS="fa fa-plus"></i></a></th>
							<th style="min-width:200px;"><cf_get_lang dictionary_id ='53363.Çalışan Hesap'></th>
							<cfif x_show_exp_center neq 0>
								<th style="min-width:150px;"><cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cfif x_show_exp_center eq 2>*</cfif></th>
							</cfif>
							<cfif x_show_exp_item neq 0>
								<th style="min-width:200px;"><cf_get_lang dictionary_id='58551.Gider Kalemi'> <cfif x_show_exp_item eq 2>*</cfif></th>
							</cfif>
							<th style="min-width:100px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th style="min-width:100px;"><cf_get_lang dictionary_id ='53364.Döviz Tutar'></th>
						</tr>
					</thead>
					<cfset toplam_tutar = 0> 
					<cfset toplam_tutar_p = 0>
					<cfset expense_id_list=''>
					<cfoutput query="get_puantaj_rows">
						<cfif len(expense_item_id) and not listfind(expense_id_list,expense_item_id)>
							<cfset expense_id_list=listappend(expense_id_list,expense_item_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(expense_id_list)>
						<cfset expense_id_list=listsort(expense_id_list,"numeric","ASC",',')>
						<cfquery name="get_exp_item" datasource="#dsn2#">
							SELECT
								EXPENSE_ITEM_NAME,
								EXPENSE_ITEM_ID
							FROM 
								EXPENSE_ITEMS 
							WHERE
								EXPENSE_ITEM_ID IN (#expense_id_list#)
							ORDER BY
								EXPENSE_ITEM_ID
						</cfquery>
						<cfset main_expense_id_list = listsort(listdeleteduplicates(valuelist(get_exp_item.expense_item_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfset currentrow_ = 0>
					<cfif get_puantaj_rows.recordcount>
						<cfoutput query="get_puantaj_rows">
							<cfif isdefined("get_puantaj_rows.EMPLOYEE_PUANTAJ_ID")>
								<!--- cari hesap tipi seçilmiş ek ödenekler ayrı satırda gelecek --->
								<cfquery name="get_rows_ext" datasource="#dsn#">
									SELECT 
										SUM(AMOUNT_PAY) TOTAL_AMOUNT,
										SC.ACC_TYPE_ID,
										SC.ACC_TYPE_NAME
									FROM
										EMPLOYEES_PUANTAJ_ROWS_EXT,
										SETUP_ACC_TYPE SC
									WHERE
										EXT_TYPE = 0
										AND EMPLOYEE_PUANTAJ_ID = #get_puantaj_rows.EMPLOYEE_PUANTAJ_ID#
										AND EMPLOYEES_PUANTAJ_ROWS_EXT.ACC_TYPE_ID = SC.ACC_TYPE_ID
									GROUP BY
										SC.ACC_TYPE_ID,
										SC.ACC_TYPE_NAME
								</cfquery>
								<cfquery name="get_total_ext" dbtype="query">
									SELECT SUM(TOTAL_AMOUNT) TOTAL_AMOUNT FROM get_rows_ext
								</cfquery>
							<cfelse>
								<cfset get_total_ext.recordcount = 0>
							</cfif>
							<cfif not len(get_puantaj_rows.vergi_iadesi)>
								<cfset get_puantaj_rows.vergi_iadesi = 0>
							</cfif>
							<cfif get_total_ext.recordcount and len(get_total_ext.total_amount)>
								<cfset ext_total_amount = get_total_ext.total_amount>
							<cfelse>
								<cfset ext_total_amount = 0>
							</cfif>
							
							<cfif isdefined("attributes.dekont_type")>
								<cfif xml_vergi_iadesi eq 1>
									<cfset satir_tutar_ = get_puantaj_rows.tutar-get_puantaj_rows.vergi_iadesi>
								<cfelse>
									<cfset satir_tutar_ = get_puantaj_rows.tutar>
								</cfif>
							<cfelse>
								<cfif xml_vergi_iadesi eq 1>
									<cfset satir_tutar_ = net_ucret + KESINTI - get_puantaj_rows.vergi_iadesi>
								<cfelse>
									<cfset satir_tutar_ = net_ucret + KESINTI>
								</cfif>
							</cfif>
							<cfset satir_tutar_ = satir_tutar_ - ext_total_amount>
							
							<cfset currentrow_ = currentrow_ +1>
							<tr id="frm_row#currentrow_#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td><input type="hidden"  value="1"  name="row_kontrol#currentrow_#" id="row_kontrol#currentrow_#"><a href="javascript://" onClick="sil('#currentrow_#');"><i class="fa fa-minus"></i></a></td>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="employee_id#currentrow_#" id="employee_id#currentrow_#" value="#employee_id#<cfif len(acc_type_id)>_#acc_type_id#</cfif>">
											<input type="hidden" name="in_out_id#currentrow_#" id="in_out_id#currentrow_#" value="#in_out_id#">
											<input type="text" name="employee_name#currentrow_#" id="employee_name#currentrow_#" value="#employee_name# #employee_surname#<cfif len(acc_type_name)> - #acc_type_name#</cfif>" class="boxtext" style="width:185px;" readonly><span class="input-group-addon" onClick="pencere_ac_employee('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>		
										</div>								
									</div>
								</td>
								<cfif x_show_exp_center neq 0>
									<td>
										<div class="form-group">
											<select name="expense_center#currentrow_#" id="expense_center#currentrow_#" style="width:150px;" class="boxtext">
												<option value=""><cf_get_lang dictionary_id ='53365.Masraf/Gelir Merkezi'></option>
												<cfset deger_expense = expense_code>
												<cfloop query="get_expense_center">
													<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_code>selected</cfif>>#expense#</option>
												</cfloop>
											</select>
										</div>
									</td>
								</cfif>
								<cfif x_show_exp_item neq 0>
									<td nowrap="nowrap">
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="expense_item_id#currentrow_#" id="expense_item_id#currentrow_#" value="#expense_item_id#">
												<input type="text" name="expense_item_name#currentrow_#" id="expense_item_name#currentrow_#"  value="<cfif len(expense_item_id) and len(expense_id_list)>#get_exp_item.expense_item_name[listfind(main_expense_id_list,expense_item_id,',')]#</cfif>" style="width:130px;" readonly="yes" class="boxtext">
												<span class="input-group-addon" onclick="pencere_ac_exp('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
											</div>
										</div>
									</td>
								</cfif>
								<td><div class="form-group"><input type="text" name="action_value#currentrow_#" id="action_value#currentrow_#"  onkeyup="return(FormatCurrency(this,event));" style="width:100px;" class="box" value="#tlformat(satir_tutar_)#" onBlur="hesapla(#currentrow_#);"></div></td>
								<td><div class="form-group"><input type="text" name="other_action_value#currentrow_#" id="other_action_value#currentrow_#"  readonly style="width:105px;" class="box" value="#tlformat((satir_tutar_)/get_money_rate.rate2)#"></div></td>
							</tr>
							<cfif get_puantaj_rows.vergi_iadesi gt 0 and xml_vergi_iadesi eq 1>
							<cfset satir_tutar_ = satir_tutar_ + get_puantaj_rows.vergi_iadesi>
							<cfset currentrow_ = currentrow_ + 1>
							<input type="hidden" name="is_tax_refund#currentrow_#" id="is_tax_refund#currentrow_#" value="1"><!---agi oldugunu belirten parametre--->
							<tr id="frm_row#currentrow_#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td><input  type="hidden"  value="1"  name="row_kontrol#currentrow_#" id="row_kontrol#currentrow_#"><a href="javascript://" onClick="sil('#currentrow_#');"><i class="fa fa-minus"></i></a></td>
								<td><div class="form-group">
									<div class="input-group">
										<input type="hidden" name="employee_id#currentrow_#" id="employee_id#currentrow_#" value="#employee_id#<cfif isdefined('xml_vergi_iadesi_acc_type_id') and len(xml_vergi_iadesi_acc_type_id) and isdefined('vergi_iadesi_acc_type_id') and len(vergi_iadesi_acc_type_id)>_#vergi_iadesi_acc_type_id#<cfelseif len(acc_type_id)>_#acc_type_id#</cfif>">
									<input type="hidden" name="in_out_id#currentrow_#" id="in_out_id#currentrow_#" value="#in_out_id#">
									<input type="text" name="employee_name#currentrow_#" id="employee_name#currentrow_#" value="#employee_name# #employee_surname#<cfif isdefined('xml_vergi_iadesi_acc_type_id') and len(xml_vergi_iadesi_acc_type_id) and isdefined('vergi_iadesi_acc_type_name') and len(vergi_iadesi_acc_type_name)> - #vergi_iadesi_acc_type_name#<cfelseif len(acc_type_name)> - #acc_type_name#</cfif>" class="boxtext" style="width:185px;" readonly><span class="input-group-addon" onClick="pencere_ac_employee('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								</div>										
							</div>
								</td>
								<cfif x_show_exp_center neq 0>
									<td>
										<div class="form-group">
										<select name="expense_center#currentrow_#" id="expense_center#currentrow_#" style="width:150px;" class="boxtext">
											<option value=""><cf_get_lang dictionary_id ='53365.Masraf/Gelir Merkezi'></option>
											<cfset deger_expense = expense_code>
											<cfloop query="get_expense_center">
												<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_code>selected</cfif>>#expense#</option>
											</cfloop>
										</select>
									</div>
									</td>
								</cfif>
								<cfif x_show_exp_item neq 0>
									<td nowrap="nowrap">
										<div class="form-group">
											<div class="input-group">
										<input type="hidden" name="expense_item_id#currentrow_#" id="expense_item_id#currentrow_#" value="#expense_item_id#">
										<input type="text" name="expense_item_name#currentrow_#" id="expense_item_name#currentrow_#"  value="<cfif len(expense_item_id) and len(expense_id_list)>#get_exp_item.expense_item_name[listfind(main_expense_id_list,expense_item_id,',')]#</cfif>" style="width:130px;" readonly="yes" class="boxtext">
										<span class="input-group-addon" onclick="pencere_ac_exp('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
									</div>
								</div>
									</td>
								</cfif>
								<td><div class="form-group"><input type="text" name="action_value#currentrow_#" id="action_value#currentrow_#"  onkeyup="return(FormatCurrency(this,event));" style="width:100px;" class="box" value="#tlformat(get_puantaj_rows.vergi_iadesi)#" onBlur="hesapla(#currentrow_#);"></div></td>
								<td><div class="form-group"><input type="text" name="other_action_value#currentrow_#" id="other_action_value#currentrow_#"  readonly style="width:105px;" class="box" value="#tlformat((get_puantaj_rows.vergi_iadesi)/get_money_rate.rate2)#"></div></td>
							</tr>
							</cfif>
							<cfif isdefined("get_puantaj_rows.EMPLOYEE_PUANTAJ_ID")>
							<cfloop query="get_rows_ext">
								<cfset currentrow_ = currentrow_ + 1>
								<input type="hidden" name="is_tax_refund#currentrow_#" id="is_tax_refund#currentrow_#" value="0">
								<tr id="frm_row#currentrow_#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
									<td><input  type="hidden"  value="1"  name="row_kontrol#currentrow_#" id="row_kontrol#currentrow_#"><a href="javascript://" onClick="sil('#currentrow_#');"><i class="fa fa-minus"></i></a></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="employee_id#currentrow_#" id="employee_id#currentrow_#" value="#get_puantaj_rows.employee_id#<cfif len(get_rows_ext.acc_type_id)>_#get_rows_ext.acc_type_id#</cfif>">
												<input type="hidden" name="in_out_id#currentrow_#" id="in_out_id#currentrow_#" value="#get_puantaj_rows.in_out_id#">
												<input type="text" name="employee_name#currentrow_#" id="employee_name#currentrow_#" value="#get_puantaj_rows.employee_name# #get_puantaj_rows.employee_surname#<cfif len(get_rows_ext.acc_type_name)> - #get_rows_ext.acc_type_name#</cfif>" class="boxtext" style="width:185px;" readonly>
												<span class="input-group-addon" onClick="pencere_ac_employee('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>			
											</div>							
										</div>
									</td>
									<cfif x_show_exp_center neq 0>
										<td>
											<div class="form-group">
												<select name="expense_center#currentrow_#" id="expense_center#currentrow_#" style="width:150px;" class="boxtext">
													<option value=""><cf_get_lang dictionary_id ='53365.Masraf/Gelir Merkezi'></option>
													<cfset deger_expense = get_puantaj_rows.expense_code>
													<cfloop query="get_expense_center">
														<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_code>selected</cfif>>#expense#</option>
													</cfloop>
												</select>
											</div>
										</td>
									</cfif>
									<cfif x_show_exp_item neq 0>
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="expense_item_id#currentrow_#" id="expense_item_id#currentrow_#" value="#get_puantaj_rows.expense_item_id#">
													<input type="text" name="expense_item_name#currentrow_#" id="expense_item_name#currentrow_#"  value="<cfif len(get_puantaj_rows.expense_item_id) and len(expense_id_list)>#get_exp_item.expense_item_name[listfind(main_expense_id_list,get_puantaj_rows.expense_item_id,',')]#</cfif>" style="width:130px;" readonly="yes" class="boxtext">
													<span class="input-group-addon" onclick="pencere_ac_exp('#currentrow_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
												</div>
											</div>
										</td>
									</cfif>
									<td><div class="form-group"><input type="text" name="action_value#currentrow_#" id="action_value#currentrow_#"  onkeyup="return(FormatCurrency(this,event));" style="width:100px;" class="box" value="#tlformat(get_rows_ext.total_amount)#" onBlur="hesapla(#currentrow_#);"></div></td>
									<td><div class="form-group"><input type="text" name="other_action_value#currentrow_#" id="other_action_value#currentrow_#"  readonly style="width:105px;" class="box" value="#tlformat((get_rows_ext.total_amount)/get_money_rate.rate2)#"></div></td>
								</tr>
							</cfloop>
							</cfif>
							<cfset toplam_tutar = toplam_tutar + satir_tutar_>
							<cfset toplam_tutar_p = toplam_tutar_p + net_ucret>
						</cfoutput>
						<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#currentrow_#</cfoutput>">
					<cfelse>
						<input name="record_num" id="record_num" type="hidden" value="0">
					</cfif>
				</cf_grid_list>
				<cf_basket_footer>
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<cfoutput>									
												<input id="kur_say" type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
												<cfloop query="get_money">
													<tr>
														<td>
															<cfif len(session.ep.other_money)><cfset money_type_new = session.ep.other_money><cfelse><cfset money_type_new = session.ep.money2></cfif>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="radio" name="rd_money_" id="rd_money_" value="#money#" onClick="toplam_hesapla();" <cfif money_type_new eq money>checked</cfif>>#money#
														</td>
														<td valign="bottom"><input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">#TLFormat(rate1,0)#/</td>
														<td><input type="text" class="box" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:100%;" onKeyUp="return(FormatCurrency(this,event,'#session.ep.our_company_info.rate_round_num#'));" onBlur="toplam_hesapla();"></td>
													</tr>
												</cfloop>
											</cfoutput>
										</table>  
							  
									</div>
								</div>
							</div>
							<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
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
												<td><cf_get_lang dictionary_id ='53366.Puantaj Toplam'></td>
												<td  style="text-align:right;">
													<input type="text" name="total_amount_puantaj" id="total_amount_puantaj" class="box" readonly="" value="<cfoutput>#tlformat(toplam_tutar_p)#</cfoutput>">
													<input type="text" name="tl_value_puantaj" id="tl_value_puantaj" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
												</td>							
											</tr>
											<tr>
												<td><cf_get_lang dictionary_id ='53368.Pauntaj Döviz Toplam'></td>
												<td  style="text-align:right;">
													<input type="text" name="other_puantaj_amount" id="other_puantaj_amount" class="box" readonly="" value="<cfoutput>#tlformat(toplam_tutar_p/get_money_rate.rate2)#</cfoutput>">&nbsp;
													<input type="text" name="tl_value1_puantaj" id="tl_value1_puantaj" class="box" readonly="" value="<cfoutput><cfif len(session.ep.other_money)>#session.ep.other_money#<cfelse>#session.ep.money2#</cfif></cfoutput>" style="width:40px;">
												</td>							
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='40163.Toplam Miktar'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody" id="totalAmountList">  
										<table>
											<tr>							
												<td><cf_get_lang dictionary_id ='53367.Dekont Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#tlformat(toplam_tutar)#</cfoutput>">
													<input type="text" name="tl_value" id="tl_value" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<tr>							
												<td><cf_get_lang dictionary_id ='53369.Dekont Döviz Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(toplam_tutar/get_money_rate.rate2)#</cfoutput>">&nbsp;
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput><cfif len(session.ep.other_money)>#session.ep.other_money#<cfelse>#session.ep.money2#</cfif></cfoutput>" style="width:40px;">
												</td>
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
	row_count=<cfoutput>#get_puantaj_rows.recordcount#</cfoutput>;
	record_exist=0;
	function kontrol()
	{
		if(!chk_process_cat('add_dekont')) return false;
		if(!check_display_files('add_dekont')) return false;
		if(!chk_period(document.getElementById('action_date'),"İşlem")) return false;
		if(document.add_dekont.paper_no.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57880.Belge No'>");
			return false;
		}
		if(document.add_dekont.action_employee_name.value=="" || document.add_dekont.action_employee_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='58586.İşlem Yapan'>");
			return false;
		}
		for(r=1;r<=add_dekont.record_num.value;r++)
		{
			if(eval("document.add_dekont.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_dekont.employee_name"+r).value == "" || eval("document.add_dekont.employee_id"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='53372.Lütfen Satırda Çalışan Hesap Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ r);
					return false;
				}
				<cfif x_show_exp_center eq 2>
					if (eval("document.add_dekont.expense_center"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='53373.Lütfen Masraf Merkezi Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ r);
						return false;
					}
				</cfif>
				<cfif x_show_exp_item eq 2>
					if (eval("document.add_dekont.expense_item_name"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='53374.Lütfen Gider Kalemi Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ r);
						return false;
					}
				</cfif>
				if ((eval("document.add_dekont.action_value"+r).value == "")||(eval("document.add_dekont.action_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'> <cf_get_lang dictionary_id ='58508.Satır'>:"+ r);
					return false;
				}
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='58508.Satır'>");
				return false;
			}
		return true;
	}
	function sil(sy)
	{
		var my_element=eval("add_dekont.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.add_dekont.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell();
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_id'+ row_count +'" value=""><input type="text" style="width:185px;" name="employee_name'+ row_count +'" value="" class="boxtext"><span class="input-group-addon" onClick="pencere_ac_employee('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></span></div></div>';
		<cfif x_show_exp_center neq 0>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="expense_center' + row_count  +'" style="width:150px;" class="boxtext"><option value="">Masraf/Gelir Merkezi</option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select></div>';
		</cfif>
		<cfif x_show_exp_item neq 0>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="expense_item_id' + row_count +'" ><input type="text" readonly="yes" style="width:133px;" name="expense_item_name' + row_count +'" class="boxtext"><span class="input-group-addon"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="action_value' + row_count +'" value=""  style="width:100%;" class="box" onBlur="hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="other_action_value' + row_count +'" style="width:100%;" class="box" readonly></div>';
	}
	function hesapla(satir)
	{
		if(eval("document.add_dekont.row_kontrol"+satir).value==1)
		{
			deger_total =  filterNum(eval("document.add_dekont.action_value"+satir).value);//tutar
			for(i=1;i<=add_dekont.kur_say.value;i++)
			{
				if(document.add_dekont.rd_money_[i-1].checked == true)
				{
					form_txt_rate2 = filterNum(eval("document.add_dekont.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_dekont.other_action_value'+satir).value = commaSplit(deger_total/form_txt_rate2);
				}
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		for (var t=1; t<=add_dekont.kur_say.value; t++)
		{		
			if(document.add_dekont.rd_money_[t-1].checked == true)
			{
				for(k=1;k<=add_dekont.record_num.value;k++)
				{		
					deger_diger_para = document.add_dekont.rd_money_[t-1].value;
					rate2_value = filterNum(eval("document.add_dekont.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('add_dekont.other_action_value'+k).value = commaSplit(filterNum(eval('add_dekont.action_value'+k).value)/rate2_value);
				}
			}
		}
		var total_amount = 0;
		var other_total_amount = 0;
		for(j=1;j<=add_dekont.record_num.value;j++)
		{		
			if(eval("document.add_dekont.row_kontrol"+j).value==1)
			{
				total_amount += parseFloat(filterNum(eval('add_dekont.action_value'+j).value));
			}
		}
		other_total_amount = total_amount/rate2_value;
		add_dekont.other_puantaj_amount.value = commaSplit(filterNum(add_dekont.total_amount_puantaj.value)/rate2_value);
		add_dekont.tl_value1_puantaj.value = deger_diger_para;
		add_dekont.tl_value1.value = deger_diger_para;
		add_dekont.total_amount.value = commaSplit(total_amount);
		add_dekont.other_total_amount.value = commaSplit(other_total_amount);
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_dekont.expense_item_id' + no +'&field_name=add_dekont.expense_item_name' + no +'&is_budget_items=1','list');
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_cari_action=1&field_emp_id=add_dekont.employee_id' + no +'&field_name=add_dekont.employee_name' + no +'&select_list=1,9','list');
	}
</script>
