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

	<cfform name="add_traffic_penalty" id="add_traffic_penalty" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=ehesap.upd_icra">
	<cfinput type="hidden" name="commandment_id" value="#attributes.commandment_id#">
	<cfinput type="hidden" value="1" name="is_submit">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="59668.İcra Güncelleme"></cfsavecontent>
	<cf_form_box title="#message#">
		 <table cellpadding="10">
			<tr>
				<td>
				<cf_area width="400">
					<table>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="checkbox" name="is_apply" id="is_apply" <cfif get_icra.is_apply eq 1>checked</cfif>> <cf_get_lang dictionary_id="30974.Kabul">
								<input type="checkbox" name="is_refuse" id="is_refuse" <cfif get_icra.is_refuse eq 1>checked</cfif>> <cf_get_lang dictionary_id="29537.Red">
								<input type="checkbox" name="is_manuel_closed" id="is_manuel_closed" <cfif get_icra.is_manuel_closed eq 1>checked</cfif>> <cf_get_lang dictionary_id="58500.Manuel"> <cf_get_lang dictionary_id ="57553.Kapat">
							</td>
						<tr>
						<tr>
							<td><cf_get_lang dictionary_id="59555.İcra Sahibi"></td>
							<td>
								<cfinput type="hidden" name="employee_id" id="employee_id" value="#get_icra.employee_id#">
								<cfinput type="text" name="employee_name"  value="#get_emp_info(get_icra.employee_id,0,0)#" style="width:200px;" onFocus="AutoComplete_Create('employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','3,0,0','EMPLOYEE_ID','employee_id','','3','250',true,'');">				
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
						<td><cf_get_lang dictionary_id="58520.Dosya Türü"></td>
						<td>
							<select name="commandment_type" id="commandment_type" style="width:170px">
								<option value="1" <cfif get_icra.commandment_type eq 1>selected</cfif>><cf_get_lang dictionary_id="50363.İcra"></option>
								<option value="2" <cfif get_icra.commandment_type eq 2>selected</cfif>><cf_get_lang dictionary_id="45514.Nafaka"></option>
							</select>
						</td>	
					</tr>
					
					<tr>
						<td><cf_get_lang dictionary_id="57485.Öncelik"></td>
						<td>
							<select name="priority" id="priority" style="width:170px">
								<cfloop from="1" to="10" index="a">
									<cfoutput><option value="#a#" <cfif get_icra.priority eq a>selected</cfif>>#a#</option></cfoutput>
								</cfloop>
							</select>
						</td>	
					</tr>
					<tr>
					<td><cf_get_lang dictionary_id="53302.Dosya No">*</td>
						<td>
							<cfinput type="text" name="serial_no" id="serial_no" value="#get_icra.serial_no#" maxlength="4" style="width:50px">
							<cfinput type="text" name="serial_number" id="serial_number" value="#get_icra.serial_number#" maxlength="50" style="width:116px;">
						</td>	
					</tr>
					<tr>
					<td><cf_get_lang dictionary_id="40295.İcra Dairesi"></td>
						<td>
							<cfinput type="text" name="commandment_office" id="commandment_office" value="#get_icra.commandment_office#" style="width:170px">
						</td>	
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="59556.İcra Tutarı"></td>
						<td><cfinput type="text" name="commandment_value" id="commandment_value" value="#tlformat(get_icra.commandment_value)#" maxlength="50" style="width:170px" onkeyup="return(FormatCurrency(this,event,2));"></td>	
					</tr>
					
					<tr>
						<td><cf_get_lang dictionary_id="59666.Önceki Dönem Ödenen"></td>
						<td><cfinput type="text" name="pre_commandment_value" id="pre_commandment_value" value="#tlformat(get_icra.pre_commandment_value)#" maxlength="50" style="width:170px" onkeyup="return(FormatCurrency(this,event,2));"></td>	
					</tr>
					
					<tr>
						<td><cf_get_lang dictionary_id="59557.İcra Oranı"></td>
						<td>
							<select name="rate_value" id="rate_value" style="width:170px">
								<option value="100" <cfif get_icra.rate_value eq 100>selected</cfif>>1/1</option>
								<option value="25" <cfif get_icra.rate_value eq 25>selected</cfif>>1/4</option>
								<option value="33" <cfif get_icra.rate_value eq 33>selected</cfif>>1/3</option>
							</select>
						</td>	
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id="59558.Kesinti Tipi"></td>
						<td>
							<select name="type_id" id="type_id" style="width:170px">
								<cfoutput query="get_types"><option value="#odkes_id#" <cfif get_icra.type_id eq odkes_id>selected</cfif>>#comment_pay#</option></cfoutput>
							</select>
						</td>	
					</tr>
					<tr>
							<td><cf_get_lang dictionary_id="59559.İcra Detayı"></td>
							<td valign="top">
								<textarea name="commandment_detail" id="commandment_detail" style="width:170px;height:40px;"><cfoutput>#get_icra.commandment_detail#</cfoutput></textarea>							
							</td>	
						</tr>	
						<tr>
							<td><cf_get_lang dictionary_id="31746.İcra Tarihi">*</td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="48287.Ceza Tarihi">!</cfsavecontent>
								<cfinput type="text" name="commandment_date" id="commandment_date" value="#dateformat(get_icra.commandment_date,'dd/mm/yyyy')#" validate="eurodate" style="width:62px;" message="#message#">
								<cf_wrk_date_image date_field="commandment_date">
								<cfoutput>
								<select name="commandment_date_hour" id="commandment_date_hour">
									<cfloop from="0" to="23" index="i">
										<option value="#numberformat(i,00)#" <cfif hour(get_icra.commandment_date) eq i>selected</cfif>>#numberformat(i,00)#</option>
									</cfloop>
								</select>
								<select name="commandment_date_min" id="commandment_date_min">
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#" <cfif minute(get_icra.commandment_date) eq i>selected</cfif>>#numberformat(i,00)#</option>
									</cfloop>
								</select>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="59667.Ödenecek IBAN"></td>
							<td><cfinput type="text" name="iban_no" id="iban_no" value="#get_icra.iban_no#" maxlength="26" style="width:170px;"></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="57691.Dosya">*</td>
							<td><cfinput type="file" value="" name="commandment_file"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="57691.Dosya"></td>
							<cfif len(get_icra.commandment_file)>
								<td><a href="javascript://" onclick="windowopen('/documents/ehesap/<cfoutput>#get_icra.commandment_file#</cfoutput>','medium');"><img src="/images/file.gif"/></a></td>
							<cfelse>
								<td><cf_get_lang dictionary_id="52730.Dosya Yok">!</td>
							</cfif>
						</tr>
					</table>
				</cf_area>
				<!---2.Blok Başlangıç--->
				<cf_area>
					<table>
					<tr>
						<td><cf_get_lang dictionary_id="57627.Kayıt Tarihi">*</td>
						<td><cfinput type="text" name="record_date" readonly="yes" value="#dateformat(get_icra.RECORD_DATE,'dd/mm/yyyy')# (#timeformat(get_icra.RECORD_DATE,'HH:MM')#)" style="width:170px;"/></td>
					</tr>
					<tr>
						<td width="110px;"><cf_get_lang dictionary_id="55812.Kayıt Eden">*</td>
						<td>
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#get_icra.record_emp#</cfoutput>">
							<input type="text" name="record_emp" id="record_emp" value="<cfoutput>#get_emp_info(get_icra.record_emp,0,0)#</cfoutput>" readonly style="width:170px;">
						</td>
					</tr>				
					</table>
					<br>
					<cfif get_other_docs.recordcount>
						<cf_medium_list_search title="Tüm Takipler"></cf_medium_list_search>
						<cf_ajax_list>
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
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>"><a href="#request.self#?fuseaction=ehesap.upd_icra&COMMANDMENT_ID=#COMMANDMENT_ID#" class="tableyazi">IC-#COMMANDMENT_ID#</a></td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>"><cfif COMMANDMENT_TYPE eq 1><cf_get_lang dictionary_id="39719.İcra"><cfelse><cf_get_lang dictionary_id="45514.Nafaka"></cfif></td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">#serial_no# #serial_number#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(COMMANDMENT_VALUE)#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(PRE_COMMANDMENT_VALUE + ODENEN)#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>text-align:right;">#tlformat(COMMANDMENT_VALUE - ODENEN - PRE_COMMANDMENT_VALUE)#</td>
									<td style="<cfif commandment_id eq attributes.COMMANDMENT_ID>background-color:##66cc66;</cfif>">
										<a href="javascript://" onclick="windowopen('/documents/ehesap/#COMMANDMENT_FILE#','medium');"><center><img src="/images/file.gif"/></center></a>
									</td>
								</tr>
							</cfoutput>
						</tbody>
					</cf_ajax_list>
					</cfif>
					<br>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="59692.Yapılan Ödemeler"></cfsavecontent>
					<cf_medium_list_search title="#message#"></cf_medium_list_search>
					<cf_ajax_list>
						<thead>
							<tr>
								<th><cf_get_lang dictionary_id="57879.İşlem Tarihi"></th>
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
					</cf_ajax_list>
				</cf_area>
				<!---2.Blok Bitiş--->
				</td>
		   </tr>
	  </table>
		<br />
		<cf_form_box_footer>	
				<cf_record_info query_name="get_icra">
				<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=ehesap.upd_icra&action=dlt&commandment_id=#attributes.commandment_id#' add_function='control()'>
		</cf_form_box_footer>    
	</cf_form_box>
	</cfform>
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

	</script>
</cfif>