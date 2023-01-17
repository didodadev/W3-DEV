 <!--- <cfparam name="attributes.COMMANDMENT_ID" default="1"> --->
 
 <cfset  attributes.COMMANDMENT_ID= attributes.id>

<cfif isdefined("attributes.action") and attributes.action is 'dlt'>
	<cfinclude template="../query/del_icra.cfm">
<cfelseif isdefined("attributes.is_submit")>
	<cfinclude template="../query/upd_icra.cfm">
<cfelse>
	<cfinclude template="../display/calc_icra.cfm">
	
	<cfquery name="get_icra" datasource="#dsn#">
		SELECT * FROM COMMANDMENT WHERE COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
	</cfquery>

	<cfquery name="get_icra_rows" datasource="#dsn#">
		SELECT * FROM COMMANDMENT_ROWS WHERE COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
	</cfquery>
	
	<cfquery name="get_types" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE STATUS = 1 AND COMMENT_TYPE IS NULL
	</cfquery>

	<cfquery name="get_other_docs" datasource="#DSN#">
	SELECT
		*
	FROM
		(
		SELECT
			EP.*,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT_EDEN,
			(SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = EP.EMPLOYEE_ID) AS ILGILI
		FROM
			COMMANDMENT EP,
			EMPLOYEES E
		WHERE
			EP.RECORD_EMP = E.EMPLOYEE_ID
			AND 
			EP.EMPLOYEE_ID = #get_icra.employee_id#
			AND ISNULL(EP.IS_REFUSE,0) = 0
		) T1
	WHERE
		(COMMANDMENT_VALUE - PRE_COMMANDMENT_VALUE - ODENEN) > 0
	ORDER BY
		RECORD_DATE ASC
	</cfquery>
	<cfquery name="get_ch_types" datasource="#dsn#">
		SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
	</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="add_traffic_penalty" id="add_traffic_penalty" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=ehesap.emptypopup_upd_execution&id=#attributes.id#">
			<cfinput type="hidden" name="commandment_id" value="#attributes.commandment_id#">
			<cfinput type="hidden" value="1" name="is_submit">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true"> 
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-company_status">  
						<label class="col-xs-12"><cf_get_lang dictionary_id="35209.Kabul"><input type="checkbox" name="is_apply" id="is_apply" <cfif get_icra.is_apply eq 1>checked</cfif>> </label>
					</div> 
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-company_status">  
						<label class="col-xs-12"><cf_get_lang dictionary_id="29537.Red"><input type="checkbox" name="is_refuse" id="is_refuse" <cfif get_icra.is_refuse eq 1>checked</cfif>> </label>
					</div> 
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-company_status">  
						<label class="col-xs-12"><cf_get_lang dictionary_id="58500.Manuel"> <cf_get_lang dictionary_id="57553.Kapat"><input type="checkbox" name="is_manuel_closed" id="is_manuel_closed" <cfif get_icra.is_manuel_closed eq 1>checked</cfif>> </label>
					</div> 
				
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company_status">  
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63841.Kesinti Çalışan Onayı'></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="emp_approve" id="emp_approve"  <cfif get_icra.emp_approve eq 1>checked</cfif>>
						</div>
					</div> 
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' select_value='#get_icra.process_stage#' process_cat_width='180' is_detail='1'>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59555.İcra Sahibi"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="employee_id" id="employee_id" value="#get_icra.employee_id#">
								<cfinput type="text" name="employee_name"  value="#get_emp_info(get_icra.employee_id,0,0)#" style="width:200px;" onFocus="AutoComplete_Create('employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','3,0,0','EMPLOYEE_ID','employee_id','','3','250',true,'');">				
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_emp_name=add_traffic_penalty.employee_name&add_traffic_penalty=add_worktime.employee_id','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
						<div class="col col-8 col-xs-12">
							<select name="commandment_type" id="commandment_type" style="width:170px">
								<option value="1" <cfif get_icra.commandment_type eq 1>selected</cfif>><cf_get_lang dictionary_id="50070.İcra"></option>
								<option value="2" <cfif get_icra.commandment_type eq 2>selected</cfif>><cf_get_lang dictionary_id="45514.Nafaka"></option>
							</select>
						</div>	
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57485.Öncelik"></label>
						<div class="col col-8 col-xs-12">
							<select name="priority" id="priority" style="width:170px">
								<cfloop from="1" to="10" index="a">
									<cfoutput><option value="#a#" <cfif get_icra.priority eq a>selected</cfif>>#a#</option></cfoutput>
								</cfloop>
							</select>
						</div>	
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id="53302.Dosya No">*</label>
						<div class="col col-2 col-sm-6">
							<cfinput type="text" name="serial_no" id="serial_no" value="#get_icra.serial_no#" maxlength="4" style="width:50px">
						</div>
						<div class="col col-4 col-sm-6">	
							<cfinput type="text" name="serial_number" id="serial_number" value="#get_icra.serial_number#" maxlength="50" style="width:116px;">
						</div>	
					</div>	
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="40295.İcra Dairesi"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="commandment_office" id="commandment_office" value="#get_icra.commandment_office#" style="width:170px">
						</div>	
					</div>
					<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59556.İcra Tutarı"></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="commandment_value" id="commandment_value" value="#tlformat(get_icra.commandment_value)#" class="moneybox" maxlength="50" onkeyup="return(FormatCurrency(this,event,2));">	
							</div>	
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59666.Önceki Dönem Ödenen"></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="pre_commandment_value" id="pre_commandment_value" value="#tlformat(get_icra.pre_commandment_value)#" class="moneybox" maxlength="50" onkeyup="return(FormatCurrency(this,event,2));">	
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59557.İcra Oranı"></label>
						<div class="col col-8 col-xs-12">
							<select name="rate_value" id="rate_value" style="width:170px" onChange="rateValueChange(this.value)">
								<option value="100" <cfif get_icra.rate_value eq 100>selected</cfif>>1/1</option>
								<option value="25" <cfif get_icra.rate_value eq 25>selected</cfif>>1/4</option>
								<option value="33" <cfif get_icra.rate_value eq 33>selected</cfif>>1/3</option>
                                <option value="1" <cfif get_icra.rate_value eq 1>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
							</select>
						</div>
					</div>
                    <cfset rateList = "100.0,33.0,25.0">
					<div class="form-group" id="item-rate_value_static" <cfif ListContains(rateList, get_icra.rate_value) neq 0>style="display:none;"</cfif>>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62479.Sabit Tutar'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="rate_value_static" id="rate_value_static" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" value="#tlformat(get_icra.rate_value_static)#"><!--- #tlformat(get_icra.rate_value_static)# --->
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53082.Ek Ödenek'></label>
						<div class="col col-8 col-xs-12">
							<select name="add_payment_type" id="add_payment_type" style="width:170px">
								<option value="0" <cfif get_icra.add_payment_type eq 0>selected</cfif>><cf_get_lang dictionary_id='59557.icra oranı'></option>
								<option value="1" <cfif get_icra.add_payment_type eq 1>selected</cfif>><cf_get_lang dictionary_id='33273.tam'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59558.Kesinti Tipi"></label>
						<div class="col col-8 col-xs-12">
							<select name="type_id" id="type_id" style="width:170px">
								<cfoutput query="get_types"><option value="#odkes_id#" <cfif get_icra.type_id eq odkes_id>selected</cfif>>#comment_pay#</option></cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59559.İcra Detayı"></label>
						<div class="col col-8 col-xs-12">
							<textarea name="commandment_detail" id="commandment_detail" style="width:170px;height:40px;"><cfoutput>#get_icra.commandment_detail#</cfoutput></textarea>							
						</div>
					</div>
					<div class="form-group" id="item-acc_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53329.Hesap Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select id="acc_type_id" name="acc_type_id" style="width:160px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_ch_types">
									<option value="#acc_type_id#" <cfif get_icra.acc_type_id eq acc_type_id>selected</cfif>>#acc_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-employee_approve_date">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63842.Çalışan Onay Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="employee_approve_date" id="employee_approve_date" value="#dateformat(get_icra.emp_approve_date,'dd/mm/yyyy')#" validate="eurodate">
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
								<cfinput type="hidden" name="account_code" id="account_code" value="#get_icra.account_code#">
								<cfinput type="text" name="account_name" id="account_name" value="#get_icra.account_name#" style="width:160px;" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_traffic_penalty.account_code&field_name=add_traffic_penalty.account_name','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="31746.İcra Tarihi"></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="48287.Ceza Tarihi">!</cfsavecontent>
								<cfinput type="text" name="commandment_date" id="commandment_date" value="#dateformat(get_icra.commandment_date,'dd/mm/yyyy')#" validate="eurodate" style="width:62px;" message="#message#">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="commandment_date">
								</span>
							</div>
						</div>
							<cfoutput>
						<div class="col col-2 col-xs-12">
							<select name="commandment_date_hour" id="commandment_date_hour">
								<cfloop from="0" to="23" index="i">
									<option value="#numberformat(i,00)#" <cfif hour(get_icra.commandment_date) eq i>selected</cfif>>#numberformat(i,00)#</option>
								</cfloop>
							</select>
						</div>
						<div class="col col-2 col-xs-12">
							<select name="commandment_date_min" id="commandment_date_min">
								<cfloop from="0" to="59" index="i">
									<option value="#numberformat(i,00)#" <cfif minute(get_icra.commandment_date) eq i>selected</cfif>>#numberformat(i,00)#</option>
								</cfloop>
							</select>
						</div>	
							</cfoutput>
					</div>
					<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59667.Ödenecek IBAN"></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="iban_no" id="iban_no" value="#get_icra.iban_no#" maxlength="26">
							</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57691.Dosya">*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="file" value="" name="commandment_file">
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57691.Dosya"></label>
						<cfif len(get_icra.commandment_file)>
							<label><a href="javascript://" onclick="windowopen('/documents/<cfoutput>#get_icra.commandment_file#</cfoutput>','medium');"><img src="/images/file.gif"/></a></label>
						<cfelse>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52730.Dosya Yok">!</label>
						</cfif>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id="57627.Kayıt Tarihi">*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="record_date" readonly="yes" value="#dateformat(get_icra.RECORD_DATE,'dd/mm/yyyy')# (#timeformat(get_icra.RECORD_DATE,'HH:MM')#)" style="width:170px;"/>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-sm-12 control-label"><cf_get_lang dictionary_id="55812.Kayıt Eden">*</label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#get_icra.record_emp#</cfoutput>">
							<input type="text" name="record_emp" id="record_emp" value="<cfoutput>#get_emp_info(get_icra.record_emp,0,0)#</cfoutput>" readonly style="width:170px;">
						</div>
					</div>	
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_icra">
				<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_execution&id=#attributes.id#' add_function='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Yapılan Ödemeler',59692)#">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57879.işlem Tarihi"></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
				</tr>
			<thead>
			<tbody>
				<cfif len(get_icra.pre_commandment_value)>
					<tr>
						<td><cf_get_lang dictionary_id="47338.Önceki Dönem"></td>
						<td style="text-align:right;"><cfoutput>#tlformat(get_icra.pre_commandment_value)#</cfoutput></td>
					</tr>
				</cfif>
				<cfoutput query="get_icra_rows">
					<tr>
						<td>#sal_mon# - #sal_year#</td>
						<td style="text-align:right;">#tlformat(closed_amount)#</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_flat_list>
	</cf_box>
	<cfif get_other_docs.recordcount>
		<cf_box title="#getLang('','Tüm',39076)##getLang('','Takipler',57325)#">
			<cf_flat_list>
				<thead>
					<tr>
						<th width="15"><cf_get_lang dictionary_id="58577.Sıra"></th>
						<th><cf_get_lang dictionary_id="57487.No"></th>
						<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
						<th><cf_get_lang dictionary_id="31746.İcra Tarihi"></th>
						<th><cf_get_lang dictionary_id="57982.Tür"></th>
						<th><cf_get_lang dictionary_id="45515.İcra No"></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id="58661.Kapatılan"></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id="58444.Kalan"></th>
						<th width="35"><cf_get_lang dictionary_id="57691.Dosya"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_other_docs">
						<tr>
							<td width="15" style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#currentrow#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>"><a href="#request.self#?fuseaction=ehesap.list_executions&event=upd&id=#COMMANDMENT_ID#" class="tableyazi">IC-#COMMANDMENT_ID#</a></td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>"><cfif COMMANDMENT_TYPE eq 1><cf_get_lang dictionary_id="50070.İcra"><cfelse><cf_get_lang dictionary_id="45514.Nafaka"></cfif></td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#serial_no# #serial_number#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(COMMANDMENT_VALUE)#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(PRE_COMMANDMENT_VALUE + ODENEN)#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(COMMANDMENT_VALUE - ODENEN - PRE_COMMANDMENT_VALUE)#</td>
							<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">
								<cfif len(COMMANDMENT_FILE)><a href="javascript://" onclick="windowopen('/documents/#COMMANDMENT_FILE#','medium');"><center><img src="/images/file.gif"/></center></a></cfif>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_flat_list>
		</cf_box>
	</cfif>	
</div>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	<script type="text/javascript">
	function control()
	{
		if(document.getElementById('is_apply').checked == true && document.getElementById('is_refuse').checked == true)
		{
			alert("<cf_get_lang dictionary_id='59688.Lütfen Kabul veya Red Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('employee_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='59560.Lütfen İcra Çalışan Seçiniz'>");
			return false;
		}
		
		
		if(document.getElementById('commandment_value').value=="")
		{
			alert("<cf_get_lang dictionary_id='48499.Lütfen Ceza Tutarı Giriniz'>");
			return false;
		}
		
		if(document.getElementById('commandment_date').value=="")
		{
			alert("<cf_get_lang dictionary_id='48498.Lütfen Ceza Tarihi Giriniz'>");
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