<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/add_icra.cfm">
<cfelse>
	<cfinclude template="../display/calc_icra.cfm">
	
<cfquery name="get_types" datasource="#dsn#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE STATUS = 1 AND COMMENT_TYPE IS NULL
</cfquery>
<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_traffic_penalty" id="add_traffic_penalty" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=ehesap.emptypopup_add_execution">
			<cfinput type="hidden" value="1" name="is_submit">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company_status">  
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63841.Kesinti Çalışan Onayı'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="emp_approve" id="emp_approve" value="">
						</div>
					</div> 
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59555.İcra Sahibi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="employee_id" id="employee_id" value="">
								<cfinput type="text" name="employee_name"  value="" style="width:200px;" onFocus="AutoComplete_Create('employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','3,0,0','EMPLOYEE_ID','employee_id','','3','250',true,'');">				
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_emp_name=add_traffic_penalty.employee_name&field_emp_id=add_traffic_penalty.employee_id','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58520.Dosya Türü'></label>
						<div class="col col-8 col-xs-12">
							<select name="commandment_type" id="commandment_type" style="width:170px">
								<option value="1"><cf_get_lang dictionary_id='50363.İcra'></option>
								<option value="2"><cf_get_lang dictionary_id='45514.Nafaka'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
						<div class="col col-8 col-xs-12">
							<select name="priority" id="priority" style="width:170px">
								<cfloop from="1" to="10" index="a">
									<cfoutput><option value="#a#">#a#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id='53302.Dosya No'>*</label>
						<div class="col col-2 col-sm-6">
							<cfinput type="text" name="serial_no" id="serial_no" value="" maxlength="4" style="width:50px">
						</div>
						<div class="col col-4 col-sm-6">	
							<cfinput type="text" name="serial_number" id="serial_number" value="" maxlength="50" style="width:116px;">
						</div>	
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40295.İcra Dairesi'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="commandment_office" id="commandment_office" value="" style="width:170px">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59556.İcra Tutarı'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" class="moneybox" name="commandment_value" id="commandment_value" value="" maxlength="50" onkeyup="return(FormatCurrency(this,event,2));">	
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59666.Önceki Dönem Ödenen'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="pre_commandment_value" id="pre_commandment_value" value="" class="moneybox" maxlength="50" style="width:170px" onkeyup="return(FormatCurrency(this,event,2));">	
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59557.İcra Oranı'></label>
						<div class="col col-8 col-xs-12">
							<select name="rate_value" id="rate_value" style="width:170px" onChange="rateValueChange(this.value)">
								<option value="100">1/1</option>
								<option value="25">1/4</option>
								<option value="33">1/3</option>
                                <option value="1"><cf_get_lang dictionary_id='58544.Sabit'></option>
							</select>
						</div>
					</div>
                    <cfset rateList = "100.0,33.0,25.0">
					<div class="form-group" id="item-rate_value_static" style="display:none;" onChange="rateValueChange(this.value)">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62479.Sabit Tutar'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="rate_value_static" id="rate_value_static" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" value="">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53082.Ek Ödenek'></label>
						<div class="col col-8 col-xs-12">
							<select name="add_payment_type" id="add_payment_type" style="width:170px">
								<option value="0"><cf_get_lang dictionary_id='59557.icra oranı'></option>
								<option value="1"><cf_get_lang dictionary_id='33273.tam'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59558.Kesinti Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="type_id" id="type_id" style="width:170px">
								<cfoutput query="get_types"><option value="#odkes_id#">#comment_pay#</option></cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59559.İcra Detayı'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="commandment_detail" id="commandment_detail" style="width:170px;height:40px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-acc_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53329.Hesap Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select id="acc_type_id" name="acc_type_id" style="width:160px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_ch_types">
									<option value="#acc_type_id#">#acc_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id='63842.Çalışan Onay Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='63842.Çalışan Onay Tarihi'>!</cfsavecontent>
								<cfinput type="text" name="employee_approve_date" id="employee_approve_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image  date_field="employee_approve_date">
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-account_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="account_code" id="account_code" value="">
								<cfinput type="text" name="account_name" id="account_name" value="" style="width:160px;" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_traffic_penalty.account_code&field_name=add_traffic_penalty.account_name','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31746.İcra Tarihi'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='48287.Ceza Tarihi'>!</cfsavecontent>
								<cfinput type="text" name="commandment_date" id="commandment_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image  date_field="commandment_date">
								</span>
							</div>
						</div>
						<cfoutput>
						<div class="col col-2 col-xs-12">
							<select name="commandment_date_hour" id="commandment_date_hour">
								<cfloop from="0" to="23" index="i">
									<option value="#numberformat(i,00)#" <cfif hour(now()) eq i>selected</cfif>>#numberformat(i,00)#</option>
								</cfloop>
							</select>
						</div>
						<div class="col col-2 col-xs-12">
							<select name="commandment_date_min" id="commandment_date_min">
								<cfloop from="0" to="59" index="i">
									<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
								</cfloop>
							</select>
						</div>
						</cfoutput>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59667.Ödenecek IBAN'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="iban_no" id="iban_no" value="" maxlength="26" style="width:170px;">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya'>*</label>
						<div class="col col-8 col-xs-12">
						<cfinput type="file" value="" name="commandment_file">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="record_date" readonly="yes" value="#dateformat(now(),'dd/mm/yyyy')# (#timeformat(now(),'HH:MM')#)" style="width:170px;"/>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id='55812.Kayıt Eden'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
							<input type="text" name="record_emp" id="record_emp" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly style="width:170px;">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
	
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('employee_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='59560.Lütfen İcra Çalışan Seçiniz'>");
			return false;
		}
			
		if(document.getElementById('commandment_value').value=="")
		{
			alert("<cf_get_lang dictionary_id='48499.Ceza Tutarı Giriniz'>");
			return false;
		}
		
		if(document.getElementById('commandment_date').value=="")
		{
			alert("<cf_get_lang dictionary_id='48498.Ceza Tarihi Giriniz'>");
			return false;
		}
			
		if(document.getElementById('commandment_detail').value=="")
		{
			alert("<cf_get_lang dictionary_id='59561.Lütfen İcra Detayı Giriniz'>");
			return false;
		}
		
		if(document.getElementById('serial_no').value=="")
		{
			alert("<cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'>");
			return false;
		}
		
		if(document.getElementById('serial_number').value=="")
		{
			alert("<cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'>");
			return false;
		}
		
	}
    function rateValueChange(val){
        const rateList = ["100","33","25"];
        if( rateList.includes(val) ) {
            $("#item-rate_value_static").hide();
        }else{
            $("#item-rate_value_static").show();
        }
    }
	</script>
</cfif>