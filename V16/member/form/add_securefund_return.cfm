<cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
	SELECT * FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = #url.securefund_id#
</cfquery>
<cfif len(get_company_securefund.return_process_cat)>
	<cfquery name="get_process_type" datasource="#dsn3#">
		SELECT 
			PROCESS_TYPE
		 FROM 
			SETUP_PROCESS_CAT 
		WHERE 
			PROCESS_CAT_ID = #get_company_securefund.return_process_cat#
	</cfquery>
</cfif>

<cfparam name="attributes.modal_id" default="">

<cfsavecontent variable="txt">
<cfif len(get_company_securefund.return_process_cat)>
	<cfoutput>
        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.securefund_id#&print_type=147','print_page','workcube_print');"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.securefund_id#&process_cat=#get_process_type.process_type#&period_id=#get_company_securefund.return_period_id#','page','add_secure_');"><img src="/images/extre.gif"  border="0" title="<cf_get_lang dictionary_id ='58452.Mahsup Fişi'>"></a>
	</cfoutput>
</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box  title="#iif(isDefined("attributes.draggable"),"getLang('','Teminat İade',29655)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_secure_" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_securefund_to_return">
			<input type="hidden" name="securefund_id" id="securefund_id" value="<cfoutput>#url.securefund_id#</cfoutput>">
			<cfif len(get_company_securefund.return_process_cat)>
				<input type="hidden" name="return_period_id" id="return_period_id" value="<cfoutput>#get_company_securefund.return_period_id#</cfoutput>">
			<cfelse>
				<input type="hidden" name="return_period_id" id="return_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
						<div class="col col-8">
							<cfif len(get_company_securefund.return_date)>
								<cf_workcube_process_cat process_cat=#get_company_securefund.return_process_cat# form_name="add_secure_"> 
							<cfelse>
								<cf_workcube_process_cat form_name="add_secure_">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-return_date">
						<label class="col col-4"><cf_get_lang dictionary_id='30267.İade Tarihi'> *</label>
						<div class="col col-8">
							<div class="input-group">
								<cfif len(get_company_securefund.return_date)>
									<cfinput type="text" name="return_date" value="#dateformat(get_company_securefund.return_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#getLang('','İade tarihini kontrol ediniz',30268)#" maxlength="10" style="width:150px">
								<cfelse>
									<cfinput type="text" name="return_date" value="#dateformat(now(),dateformat_style)#" required="yes" validate="#validate_style#" message="#getLang('','İade tarihini kontrol ediniz',30268)#" maxlength="10" style="width:150px">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="return_date"></span>
							</div>
						</div>
					</div>
					<cfif len(get_company_securefund.return_process_cat)>
						<div class="form-group" id="item-given_acc_id">
							<label class="col col-4"><cf_get_lang dictionary_id='58789.Teminat Borç Hesabı'></label>
							<div class="col col-8">
								<div class="input-group">
									<cfquery name="GET_ACC_2" datasource="#DSN2#">
										SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.RETURN_GIVEN_ACC_CODE#'
									</cfquery>
									<input type="hidden" name="given_acc_id" id="given_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.RETURN_GIVEN_ACC_CODE#</cfoutput>">
									<cfinput type="text" name="given_acc_name" id="given_acc_name" value="#GET_COMPANY_SECUREFUND.RETURN_GIVEN_ACC_CODE# - #GET_ACC_2.ACCOUNT_NAME#" style="width:150px;" onFocus="AutoComplete_Create('given_acc_name','CODE_NAME','CODE_NAME','get_account_code','0,0','ACCOUNT_CODE','given_acc_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure_.given_acc_name&field_id=add_secure_.given_acc_id</cfoutput>&account_code='+document.add_secure_.given_acc_id.value)"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-taken_acc_name">
							<label class="col col-4"><cf_get_lang dictionary_id='58790.Teminat Alacak Hesabı'></label>
							<div class="col col-8">
								<div class="input-group">
									<cfquery name="GET_ACC_1" datasource="#DSN2#">
										SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.RETURN_TAKEN_ACC_CODE#'
									</cfquery>
									<input type="hidden" name="taken_acc_id" id="taken_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.RETURN_TAKEN_ACC_CODE#</cfoutput>">
									<cfinput type="text" name="taken_acc_name" id="taken_acc_name" value="#GET_COMPANY_SECUREFUND.RETURN_TAKEN_ACC_CODE# - #GET_ACC_1.ACCOUNT_NAME#" style="width:150px;" onFocus="AutoComplete_Create('taken_acc_name','CODE_NAME','CODE_NAME','get_account_code','0,0','ACCOUNT_CODE','taken_acc_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure_.taken_acc_name&field_id=add_secure_.taken_acc_id</cfoutput>&account_code='+document.add_secure_.taken_acc_id.value)"></span>
								</div>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-given_acc_id">
							<label class="col col-4"><cf_get_lang dictionary_id='58789.Teminat Borç Hesabı'></label>
							<div class="col col-8">
								<div class="input-group">
									<cfquery name="GET_ACC_2" datasource="#DSN2#">
										SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#'
									</cfquery>
									<input type="hidden" name="given_acc_id" id="given_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE#</cfoutput>">
									<cfinput type="text" name="given_acc_name" id="given_acc_name" value="#GET_COMPANY_SECUREFUND.GIVEN_ACC_CODE# - #GET_ACC_2.ACCOUNT_NAME#" style="width:150px;" onFocus="AutoComplete_Create('given_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','given_acc_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure_.given_acc_name&field_id=add_secure_.given_acc_id</cfoutput>&account_code='+document.add_secure_.given_acc_id.value)"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-taken_acc_name">
							<label class="col col-4"><cf_get_lang dictionary_id='58790.Teminat Alacak Hesabı'></label>
							<div class="col col-8">
								<div class="input-group">
									<cfquery name="GET_ACC_1" datasource="#DSN2#">
										SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#'
									</cfquery>
									<input type="hidden" name="taken_acc_id" id="taken_acc_id" value="<cfoutput>#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE#</cfoutput>">
									<cfinput type="text" name="taken_acc_name" id="taken_acc_name" value="#GET_COMPANY_SECUREFUND.TAKEN_ACC_CODE# - #GET_ACC_1.ACCOUNT_NAME#" style="width:150px;" onFocus="AutoComplete_Create('taken_acc_name','CODE_NAME','CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','taken_acc_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_secure_.taken_acc_name&field_id=add_secure_.taken_acc_id</cfoutput>&account_code='+document.add_secure_.taken_acc_id.value)"></span>
								</div>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-process_cat">
						<label class="col col-4"><cf_get_lang dictionary_id="36199.Açıklama"></label>
						<div class="col col-8">
							<textarea name="return_detail" id="return_detail" value="" style="width:175px;height:55px;"><cfif len(get_company_securefund.RETURN_DETAIL)><cfoutput>#get_company_securefund.RETURN_DETAIL#</cfoutput></cfif></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_company_securefund" record_emp="return_record_emp" update_emp="return_update_emp" update_date="RETURN_UPDATE_DATE">
				<cfif len(get_company_securefund.return_process_cat)>
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=member.emptypopup_upd_securefund_to_return&return_period_id=#get_company_securefund.return_period_id#&securefund_id=#attributes.securefund_id#&is_delete=1' add_function='kontrol()'>
				<cfelse>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
	
					
		
<script type="text/javascript">
	function kontrol()
	{
		if(!chk_process_cat('add_secure_')) return false;
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_secure_' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
</script>
