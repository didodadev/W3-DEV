<cfif not isdefined('attributes.record_num')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfquery name="GET_COMPANYXML_INFO" datasource="#DSN#">
			SELECT
				WORKXML_OUR_COMPANY,
				WORKXML_NAME,
				WORKXML_MEMBER_NO,
				WORKXML_USER,
				WORKXML_IP,
				WORKXML_ADRESS,
				WORKXML_PASSWORD,
				WORKXML_ID
			FROM 
				WORKXML_SERVICE 
			WHERE 
				COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cf_box title="#getLang('','Workcube Data Service','30197')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<form name="workxml" action="<cfoutput>#request.self#?fuseaction=member.popup_workxml_service</cfoutput>" method="post">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
				<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#GET_COMPANYXML_INFO.RECORDCOUNT#</cfoutput>">
				<cf_flat_list>
					<thead>
						<tr>
							<th width="15"><input type="button" class="eklebuton" onClick="add_row();" title="<cf_get_lang dictionary_id='57656.Servis'>"></th>
							<th width="200"><cf_get_lang dictionary_id ='30641.Servis Adı'></th>
							<th width="50"><cf_get_lang dictionary_id ='30642.Şirket ID'></th>
							<th width="200"><cf_get_lang dictionary_id='58723.Adres'>/<cf_get_lang dictionary_id='29761.URL'></th>
							<th width="100"><cf_get_lang dictionary_id ='57558.Üye No'></th>
							<th width="100"><cf_get_lang dictionary_id ='57551.Kullanıcı Adı'></th>
							<th width="100"><cf_get_lang dictionary_id ='57552.Şifre'></th>
							<th width="125"><cf_get_lang dictionary_id='32421.IP'></th>
						</tr>
					</thead>
					<tbody id="table1">
						<cfoutput query="GET_COMPANYXML_INFO">
						<tr name="frm_row#currentrow#" id="frm_row#currentrow#">
							<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
								<input type="hidden" name="workxml_id#currentrow#" id="workxml_id#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_ID#">
								<a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a>
							</td>
							<td><input type="text" name="workxml_name#currentrow#" id="workxml_name#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_NAME#"></td>
							<td><input type="text" name="workxml_our_company#currentrow#" id="workxml_our_company#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_OUR_COMPANY#" onkeyup="isNumber(this);"></td>
							<td><input type="text" name="workxml_adress#currentrow#" id="workxml_adress#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_ADRESS#"></td>
							<td><input type="text" name="workxml_member_no#currentrow#" id="workxml_member_no#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_MEMBER_NO#"></td>
							<td><input type="text" name="workxml_user#currentrow#" id="workxml_user#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_USER#"></td>
							<td><input type="text" name="workxml_password#currentrow#" id="workxml_password#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_PASSWORD#"></td>
							<td><input type="text" name="workxml_ip#currentrow#" id="workxml_ip#currentrow#" value="#GET_COMPANYXML_INFO.WORKXML_IP#"></td>
						</tr>
						</cfoutput>
					</tbody>
				</cf_flat_list>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='1' is_delete='0'>
				</cf_box_footer>
			</form>
		</cf_box>
	</div>
	<script type="text/javascript">
		row_count=<cfoutput>#GET_COMPANYXML_INFO.RECORDCOUNT#</cfoutput>;
		function sil(sy)
		{
			var my_element=eval("workxml.row_kontrol"+sy);
			my_element.value=0;
		
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
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
			document.workxml.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_name'+row_count+'" value="" style="width:200px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_our_company'+row_count+'" value="" style="width:50px;" onkeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_adress'+row_count+'" value="" style="width:200px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_member_no'+row_count+'" value="" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_user'+row_count+'" value="" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_password'+row_count+'" value="" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="workxml_ip'+row_count+'" value="" style="width:125px;">';
		}
	</script>
<cfelse>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
			<cfif len(evaluate("attributes.workxml_name#i#")) and len(evaluate("attributes.workxml_adress#i#")) and not isdefined("attributes.workxml_id#i#")>
				<cfquery name="add_par_rel" datasource="#DSN#">
					INSERT INTO 
						WORKXML_SERVICE 
					(
						COMPANY_ID,
						WORKXML_NAME,
						WORKXML_OUR_COMPANY,
						WORKXML_ADRESS,
						WORKXML_PASSWORD,
						WORKXML_USER,
						WORKXML_IP,
						WORKXML_MEMBER_NO,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					) 
					VALUES 
					(
						#attributes.company_id#,
						'#wrk_eval("attributes.WORKXML_NAME#i#")#',
						'#wrk_eval("attributes.WORKXML_OUR_COMPANY#i#")#',
						'#wrk_eval("attributes.WORKXML_ADRESS#i#")#',
						'#wrk_eval("attributes.WORKXML_PASSWORD#i#")#',
						'#wrk_eval("attributes.WORKXML_USER#i#")#',
						'#wrk_eval("attributes.WORKXML_IP#i#")#',
						'#wrk_eval("attributes.WORKXML_MEMBER_NO#i#")#',
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#'
					)
				</cfquery>
			<cfelseif len(evaluate("attributes.workxml_name#i#")) and len(evaluate("attributes.workxml_adress#i#")) and isdefined("attributes.workxml_id#i#") and len(evaluate("attributes.workxml_id#i#"))>
				<cfquery name="upd_par_rel" datasource="#DSN#">
					UPDATE 
						WORKXML_SERVICE
					SET
						WORKXML_NAME = '#wrk_eval("attributes.WORKXML_NAME#i#")#',
						WORKXML_ADRESS = '#wrk_eval("attributes.WORKXML_ADRESS#i#")#',
						WORKXML_OUR_COMPANY = '#wrk_eval("attributes.WORKXML_OUR_COMPANY#i#")#',
						WORKXML_PASSWORD = '#wrk_eval("attributes.WORKXML_PASSWORD#i#")#',
						WORKXML_USER = '#wrk_eval("attributes.WORKXML_USER#i#")#',
						WORKXML_IP = '#wrk_eval("attributes.WORKXML_IP#i#")#',
						WORKXML_MEMBER_NO = '#wrk_eval("attributes.WORKXML_MEMBER_NO#i#")#',
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#cgi.remote_addr#'
					WHERE WORKXML_ID = '#wrk_eval("attributes.workxml_id#i#")#'
				</cfquery>
			</cfif>
		<cfelseif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 0 and isdefined("attributes.workxml_id#i#") and len(evaluate("attributes.workxml_id#i#"))>
			<cfquery name="del_par_rel" datasource="#DSN#">
				DELETE FROM WORKXML_SERVICE WHERE WORKXML_ID=#evaluate("attributes.workxml_id#i#")#
			</cfquery>
		</cfif>
	</cfloop>
<cflocation url="#request.self#?fuseaction=member.popup_workxml_service&company_id=#attributes.company_id#" addtoken="no">
</cfif>
