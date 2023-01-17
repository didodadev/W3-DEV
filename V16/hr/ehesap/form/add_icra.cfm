<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/add_icra.cfm">
<cfelse>
	<cfinclude template="../display/calc_icra.cfm">
	
	<cfquery name="get_types" datasource="#dsn#">
		SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE STATUS = 1 AND COMMENT_TYPE IS NULL
	</cfquery>
	
	<cfform name="add_traffic_penalty" id="add_traffic_penalty" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=ehesap.add_icra">
	<cfinput type="hidden" value="1" name="is_submit">
	<cf_form_box title="İcra Ekle">
		 <table cellpadding="10">
			<tr>
				<td>
				<cf_area width="310">
					<table>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="59555.İcra Sahibi"></td>
							<td>
								<cfinput type="hidden" name="employee_id" id="employee_id" value="">
								<cfinput type="text" name="employee_name"  value="" style="width:200px;" onFocus="AutoComplete_Create('employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','3,0,0','EMPLOYEE_ID','employee_id','','3','250',true,'');">				
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					<tr>
					
					<div class="form-group" id="item-process">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
                        <div class="col col-9 col-xs-12">
							<select name="commandment_type" id="commandment_type" style="width:170px">
								<option value="1"><cf_get_lang dictionary_id="50363.İcra"></option>
								<option value="2"><cf_get_lang dictionary_id="45514.Nafaka"></option>
							</select>
						</div>
                    </div>
					<tr>
						<td><cf_get_lang dictionary_id="57485.Öncelik"></td>
						<td>
							<select name="priority" id="priority" style="width:170px">
								<cfloop from="1" to="10" index="a">
									<cfoutput><option value="#a#">#a#</option></cfoutput>
								</cfloop>
							</select>
						</td>	
					</tr>
					<tr>
					<td><cf_get_lang dictionary_id="53302.Dosya No">*</td>
						<td>
							<cfinput type="text" name="serial_no" id="serial_no" value="" maxlength="4" style="width:50px">
							<cfinput type="text" name="serial_number" id="serial_number" value="" maxlength="50" style="width:116px;">
						</td>	
					</tr>
					
					<tr>
					<td><cf_get_lang dictionary_id="40295.İcra Dairesi"></td>
						<td>
							<cfinput type="text" name="commandment_office" id="commandment_office" value="" style="width:170px">
						</td>	
					</tr>
					
					<tr>
						<td><cf_get_lang dictionary_id="59556.İcra Tutarı"></td>
						<td><cfinput type="text" name="commandment_value" id="commandment_value" value="" maxlength="50" style="width:170px" onkeyup="return(FormatCurrency(this,event,2));"></td>	
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="59557.İcra Oranı"></td>
						<td>
							<select name="rate_value" id="rate_value" style="width:170px">
								<option value="100">1/1</option>
								<option value="25">1/4</option>
								<option value="33">1/3</option>
							</select>
						</td>	
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="59558.Kesinti Tipi"></td>
						<td>
							<select name="type_id" id="type_id" style="width:170px">
								<cfoutput query="get_types"><option value="#odkes_id#">#comment_pay#</option></cfoutput>
							</select>
						</td>	
					</tr>
					<tr>
							<td><cf_get_lang dictionary_id="59559.İcra Detayı"></td>
							<td valign="top">
								<textarea name="commandment_detail" id="commandment_detail" style="width:170px;height:40px;"></textarea>							
							</td>	
						</tr>	
						<tr>
							<td><cf_get_lang dictionary_id="31746.İcra Tarihi">*</td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="48287.Ceza Tarihi">!</cfsavecontent>
								<cfinput type="text" name="commandment_date" id="commandment_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" style="width:62px;" message="#message#">
								<cf_wrk_date_image date_field="commandment_date">
								<cfoutput>
								<select name="commandment_date_hour" id="commandment_date_hour">
									<cfloop from="0" to="23" index="i">
										<option value="#numberformat(i,00)#" <cfif hour(now()) eq i>selected</cfif>>#numberformat(i,00)#</option>
									</cfloop>
								</select>
								<select name="commandment_date_min" id="commandment_date_min">
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfloop>
								</select>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="50195.Ödenecek IBAN"></td>
							<td><cfinput type="text" name="iban_no" id="iban_no" value="" maxlength="26" style="width:170px;"></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="57691.Dosya">*</td>
							<td><cfinput type="file" value="" name="commandment_file"></td>
						</tr>
					</table>
				</cf_area>
				
				<!---2.Blok Başlangıç--->
				<cf_area>
					<table>
					<tr>
						<td><cf_get_lang dictionary_id="57627.Kayıt Tarihi">*</td>
						<td><cfinput type="text" name="record_date" readonly="yes" value="#dateformat(now(),'dd/mm/yyyy')# (#timeformat(now(),'HH:MM')#)" style="width:170px;"/></td>
					</tr>
					<tr>
						<td width="110px;"><cf_get_lang dictionary_id="55812.Kayıt Eden">*</td>
						<td>
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
							<input type="text" name="record_emp" id="record_emp" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly style="width:170px;">
						</td>
					</tr>
					
					</table>
				</cf_area>
				<!---2.Blok Bitiş--->
				</td>
		   </tr>
	  </table>
	  

		<br />
		<cf_form_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='control()'>
		</cf_form_box_footer>    
	</cf_form_box>
	</cfform>
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
	</script>
</cfif>