<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfif application.systemParam.systemParam().fusebox.use_period eq true>
	<cfset dsn2="#dsn##session.ep.period_year##session.ep.company_id#">
<cfelse>
	<cfset dsn2 = dsn>
</cfif>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
</cfquery>		
<cf_box title="#getLang('','',51528)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_visit" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_activity_info#iif(isdefined('attributes.draggable'),DE('&draggable=1'),DE(''))#">
		<input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang no='515.Etkinlik Yapılan'> *</label>
                    <div class="col col-8">						
						<cfif isdefined("attributes.company_id")>
							<cfquery name="GET_MANAGER_ID" datasource="#dsn#">
								SELECT 
									COMPANY_PARTNER.PARTNER_ID
								FROM
									COMPANY,
									COMPANY_PARTNER
								WHERE
									COMPANY.COMPANY_ID = #attributes.company_id# AND
									COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
									COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID 
							</cfquery>
							<div class="col col-6">						
								<input name="company_id" id="company_id" type="hidden" value="<cfoutput>#attributes.company_id#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang no='405.ziyaret edilecek girmelisiniz'></cfsavecontent>
								<cfinput name="company_name" type="text" required="yes" readonly="yes" message="#message#" style="width:180px;" value="#get_par_info(attributes.company_id,1,0,0)#">
							</div>
							<div class="col col-6">						
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_manager_id.partner_id#</cfoutput>">
								<cfinput type="text" name="partner_name" style="width:180px;" readonly="yes" value="#get_par_info(get_manager_id.partner_id,0,-1,0)#" required="yes" message="Lütfen Partner Giriniz !"> 
							</div>
						<cfelse>
							<input name="company_id" id="company_id" type="hidden" value="">
							<cfsavecontent variable="message"><cf_get_lang no='405.Ziyaret Edilecek Giriniz '>!</cfsavecontent>
							<div class="col col-6">						
								<cfinput name="company_name" type="text" required="yes" readonly="yes" message="#message#" style="width:180px;" value="">
							</div>
							<input type="hidden" name="partner_id" id="partner_id">
							<cfsavecontent variable="message"><cf_get_lang no='457.LÜtfen Partner Giriniz '>!</cfsavecontent>
							<div class="col col-6">						
								<div class="input-group">
									<cfinput type="text" name="partner_name" style="width:180px;" readonly="yes" required="yes" message="#message#">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=add_visit.company_id&field_comp_name=add_visit.company_name&field_id=add_visit.partner_id&field_name=add_visit.partner_name&is_single=1','wide');"></span>
								</div>
							</div>
						</cfif>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='74.Kategori'> *</label>
                    <div class="col col-8">
						<cf_wrk_combo
						name="visit_type"
						query_name="GET_ACTIVITY_TYPES"
						option_name="activity_type"
						option_value="activity_type_id"
						width="180">
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
					<div class="col col-8">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang no='458.lütfen Gerçekleşme Tarihi Formatını Doğru Giriniz !'></cfsavecontent>
							<cfinput  type="text"  name="execute_start_date" style="width:65px;" validate="#validate_style#" message="#message#" value="">
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="execute_start_date">
							</span>
						</div>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='90.Bitiş'></label>
                    <div class="col col-8">
						<div class="input-group">
						<cfinput  type="text"  name="execute_finish_date" style="width:65px;" validate="#validate_style#" message="#message#" value="">
							<span class="input-group-addon">
								<cf_wrk_date_image date_field="execute_finish_date">
							</span>
						</div>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-8">
						<textarea name="detail" id="detail" style="width:175px;height:50px;"></textarea>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='272.Sonuç'> *</label>
                    <div class="col col-8">
						<cf_wrk_combo
						name="visit_stage"
						option_name="activity_stage"
						option_value="activity_stage_id"
						query_name="GET_ACTIVITY_STAGES"
						width="175">
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang no='85.Harcama'></label>
                    <div class="col col-8">
						<div class="col col-6">
							<cfsavecontent variable="message"><cf_get_lang no='407.Sayısal Değer Giriniz '>!</cfsavecontent>
							<cfinput type="text" name="visit_expense" validate="float" message="#message#" onKeyup="'return(FormatCurrency(this,event));'" value="0" style="width:117px;" class="moneybox">
						</div>
						<div class="col col-6 pr-0">
							<select name="money" id="money" style="width:55px;">
								<cfoutput query="get_money">
									<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>	
						</div>		
						<div class="col col-12 padding-top-5">
							<select name="expense_item" id="expense_item" style="width:175px;">
								<option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
								<cfoutput query="get_expense">
									<option value="#expense_item_id#">#expense_item_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group">
                    <label class="col col-4"><cf_get_lang_main no='157.Görevli'></label>
                    <div class="col col-8">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.position_code#</cfoutput>">
							<input type="text" name="employee_name" id="employee_name" style="width:175px;" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_visit.employee_id&field_name=add_visit.employee_name','list');"></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'></cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = document.add_visit.visit_type.selectedIndex;
	if (document.add_visit.visit_type[x].value == "")
	{ 
		alert ("<cf_get_lang no='459.Lütfen Etkinlik Nedeni Giriniz'> !");
		return false;
	}
	x = document.add_visit.visit_stage.selectedIndex;
	if (document.add_visit.visit_stage[x].value == "")
	{ 
		alert ("<cf_get_lang no='409.Sonuç Girmelisiniz'> !");
		return false;
	}
	tarih1_1 = add_visit.execute_start_date.value.substr(6,4) + add_visit.execute_start_date.value.substr(3,2) + add_visit.execute_start_date.value.substr(0,2);
	tarih2_2 = add_visit.today_value_.value.substr(6,4) + add_visit.today_value_.value.substr(3,2) + add_visit.today_value_.value.substr(0,2);
	if((add_visit.execute_start_date.value != "") && (tarih1_1 > tarih2_2))
	{
		alert("<cf_get_lang no='460.Lütfen Başlangıç Tarihini Bugünden Önce Giriniz'> !");
		return false;
	}
	tarih1_3 = add_visit.execute_finish_date.value.substr(6,4) + add_visit.execute_finish_date.value.substr(3,2) + add_visit.execute_finish_date.value.substr(0,2);
	tarih2_3 = add_visit.today_value_.value.substr(6,4) + add_visit.today_value_.value.substr(3,2) + add_visit.today_value_.value.substr(0,2);
	if((add_visit.execute_finish_date.value != "") && (tarih1_3 > tarih2_3))
	{
		alert("<cf_get_lang no='516.Lütfen Bitiş Tarihini Bugünden Önce Giriniz'> !");
		return false;
	}
	add_visit.visit_expense.value = filterNum(add_visit.visit_expense.value);
}
</script>
