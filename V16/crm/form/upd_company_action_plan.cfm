<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
	SELECT 
		COMPANY_ACTION_PLAN_NOTES.PROCESS_CAT_ID,
		COMPANY_ACTION_PLAN_NOTES.ACTION_PLAN_ID,
		COMPANY_ACTION_PLAN_NOTES.SUBJECT,
		COMPANY_ACTION_PLAN_NOTES.DETAIL,
		COMPANY_ACTION_PLAN_NOTES.RECORD_DATE,
		PROCESS_TYPE_ROWS.STAGE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID		
	FROM
		COMPANY_ACTION_PLAN_NOTES,
		PROCESS_TYPE_ROWS,
		EMPLOYEES,
		BRANCH
	 WHERE
		COMPANY_ACTION_PLAN_NOTES.BRANCH_ID = BRANCH.BRANCH_ID AND
		COMPANY_ACTION_PLAN_NOTES.COMPANY_ID = #attributes.cpid# AND
		COMPANY_ACTION_PLAN_NOTES.PROCESS_CAT_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND 
		COMPANY_ACTION_PLAN_NOTES.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND 
		COMPANY_ACTION_PLAN_NOTES.ACTION_PLAN_ID = #attributes.action_plan_id#
</cfquery>
<cfquery name="GET_COMPANY_SECUREFUND_1" datasource="#DSN#">
	SELECT 
		COMPANY_ACTION_PLAN_NOTES.RECORD_EMP,
		COMPANY_ACTION_PLAN_NOTES.ACTION_PLAN_ID,
		COMPANY_ACTION_PLAN_NOTES.DETAIL,
		COMPANY_ACTION_PLAN_NOTES.RECORD_DATE,
		PROCESS_TYPE_ROWS.STAGE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		BRANCH.BRANCH_NAME
	FROM
		COMPANY_ACTION_PLAN_NOTES,
		PROCESS_TYPE_ROWS,
		EMPLOYEES,
		BRANCH
	 WHERE
		COMPANY_ACTION_PLAN_NOTES.BRANCH_ID = BRANCH.BRANCH_ID AND
		COMPANY_ACTION_PLAN_NOTES.COMPANY_ID = #attributes.cpid# AND
		COMPANY_ACTION_PLAN_NOTES.PROCESS_CAT_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND 
		COMPANY_ACTION_PLAN_NOTES.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND 
		RELATED_ACTION_ID = #attributes.action_plan_id#
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
	DISTINCT 
		COMPANY_BRANCH_RELATED.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM  
		COMPANY_BRANCH_RELATED,
		BRANCH 
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND 
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=crm.popup_add_company_action_plan&CPID=#cpid#</cfoutput>"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Eylem Planı','51560')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_notes" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_action_plan">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
			<input type="hidden" name="action_plan_id" id="action_plan_id" value="<cfoutput>#attributes.action_plan_id#</cfoutput>">
			<input type="hidden" name="kontrol_date" id="kontrol_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
			<input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(date_add('d',15,get_company_securefund.record_date),dateformat_style)#</cfoutput>">
			<input type="hidden" name="subject" id="subject" value="<cfoutput>#get_company_securefund.subject#</cfoutput>">
			<input type="hidden" name="issearch" id="issearch" value="1">
			<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-subject">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="subject" id="subject" value="#get_company_securefund.subject#" maxlength="150">
						</div>
					</div>
					<div class="form-group" id="item-get_branch">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="hidden" name="branch_id" id="branch_id" value="#get_company_securefund.branch_id#">
							<cfinput type="text" name="branch_n" id="branch_n" readonly value="#get_company_securefund.branch_name#">
						</div>
					</div>
					<div class="form-group" id="item-workcube_process">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='280' is_detail='1' select_value='#get_company_securefund.process_cat_id#'>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea style="width:280px;height:110px;" name="detail" id="detail"></textarea>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
					<cf_flat_list>
						<thead>
							<tr>
								<th width="30"><cf_get_lang_main no="75.No"></th>
								<th><cf_get_lang_main no="217.Açıklama"></th>
								<th width="200"><cf_get_lang_main no="41.Şube"></th>
								<th width="200"><cf_get_lang_main no="71.Kayıt"></th>
								<th width="100"><cf_get_lang_main no="1447.Süreç"></th>
								<th width="20"><i class="fa fa-check-square"></i></th>
								<th width="20"></th>
							</tr>
						</thead>
						<tbody>
							<cfset klmslsm = 0>
								<cfoutput query="get_company_securefund">
									<cfset klmslsm = klmslsm + 1>
									<tr>
										<td>#klmslsm#</td>
											<td>#detail#</td>
											<td>#branch_name#</td>
											<td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
											<td>#stage#</td>
											<td><i class="fa fa-check-square" style="color:green"></i></td>
											<td>&nbsp;</td>
										</tr>
								</cfoutput>
								<cfoutput query="get_company_securefund_1">
									<cfset klmslsm = klmslsm + 1>
									<tr>
										<td>#klmslsm#</td>
										<td>#detail#</td>
										<td>#branch_name#</td>
										<td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
										<td>#stage#</td>
										<td><i class="fa fa-check-square" style="color:red"></i></td>
										<td><cfif record_emp eq session.ep.userid><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.emptypopup_del_company_action_plan&action_plan_id=#action_plan_id#&cpid=#attributes.cpid#</cfoutput>','small');"><i class="fa fa-minus"></i></a></cfif></td>
									</tr>
								</cfoutput>
						</tbody>
					</cf_flat_list>
				</div>
			</cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function kontrol()
{
	
	if(document.add_notes.detail.value=="")
	{
		alert("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>!");
		return false;
	}
	t = (200 - document.add_notes.detail.value.length);
	if ( t < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'>" + ((-1) * t) + "<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
	
	if(!date_check(document.add_notes.kontrol_date,document.add_notes.finish_date, "<cf_get_lang dictionary_id='33526.Eylem Planına 15 Gün İçince Yorum Girilebilir'>"))
	{	
		return false;
	}

	return process_cat_control();
}
</script>
