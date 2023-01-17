<cfquery name="GET_CONSUMER_TRANSFER" datasource="#DSN#">
	SELECT 
    	CT.CONSUMER_TRANSFER_ID,
     	CT.CITY_ID,
      	CT.DELEGATE_ID,
      	CT.SCORE,
      	CT.RECORD_DATE,
      	CT.RECORD_EMP,
      	CT.RECORD_IP,
	  	C.CONSUMER_NAME	+ ' '+  C.CONSUMER_SURNAME as DELEGATE_NAME
  	FROM 
    	CONSUMER_TRANSFER CT
  	LEFT JOIN CONSUMER C ON C.CONSUMER_ID=CT.DELEGATE_ID
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
    	CITY_ID,
        CITY_NAME
   FROM
       SETUP_CITY
</cfquery>
<cfset partition_row = get_consumer_transfer.recordcount>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Temsilci Tanımlama Ekranı','61276')#">
		<cfform name="list_delegate" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_delegate">
			<cf_flat_list name="table1" id="table1">
				<thead>
					<tr>
						<th width="20"><input name="record_num" id="record_num" type="hidden" value="0"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang_main no='170.Ekle'>" alt="<cf_get_lang_main no='170.Ekle'>"></i></a></th>
						<th width="200"><cf_get_lang_main no='496.Temsilci'> *</th>
						<th width="130"><cf_get_lang_main no='1196.İl'> *</th>
					</tr>
				</thead>
				<tbody>
					<cfif get_consumer_transfer.recordcount>
						<cfoutput query="get_consumer_transfer">
							<tr id="frm_row#currentrow#">
								<td >
									<input type="hidden" name="consumer_transfer_id#currentrow#" id="consumer_transfer_id#currentrow#" value="#CONSUMER_TRANSFER_ID#">
									<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
									<input type="hidden" name="transfer_id#currentrow#" id="transfer_id#currentrow#" value="#consumer_transfer_id#">
									<a style="cursor:pointer" onClick="sil(#currentrow#);"><img src="images/delete_list.gif" title="<cf_get_lang_main no='51.Sil'>" border="0" align="absmiddle"></a>
								</td>
								<td nowrap="nowrap"><input type="hidden" name="ref_pos_code#currentrow#" id="ref_pos_code#currentrow#" value="#delegate_id#" style="width:50px;">
									<input type="text" name="ref_pos_code_name#currentrow#" id="ref_pos_code_name#currentrow#" value="#delegate_name#" style="width:150px;" >
									<a href="javascript://" onClick="pencere_ac2(#currentrow#);"><img src="/images/plus_thin.gif" align="absmiddle"></a></td>
								<td>
									<select name="delegate_city_id#currentrow#" id="city_id#currentrow#" style="width:130px;">
										<cfset value_city_id = city_id>
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfloop query="GET_CITY">
												<option value="#city_id#" <cfif value_city_id eq city_id>selected</cfif>>#city_name#</option>
											</cfloop>
									</select>
								</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>			  
			</cf_flat_list>
			<cf_box_footer>
				<cf_record_info query_name="get_consumer_transfer">
				<cfif get_consumer_transfer.recordcount>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
				<cfelse>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	row_count=<cfoutput>#partition_row#</cfoutput>;
	kontrol_row_count = <cfoutput>#partition_row#</cfoutput>;
	document.list_delegate.record_num.value=row_count;
	function add_row()
	{		
		row_count++;
		kontrol_row_count++;
		var newRow;
		var newCell;
	
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		
		document.list_delegate.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" value="" name="consumer_transfer_id' + row_count +'" id="consumer_transfer_id' + row_count +'"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="ref_pos_code' + row_count +'" value=""><div class="form-group"><div class="input-group"><input type="text" name="ref_pos_code_name' + row_count +'" style="width:150px;" maxlength="28"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac2('+ row_count +');"></span></div></div>';
							
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.setAttribute("id","delegate_city_id" + row_count + "_td");
		newCell.innerHTML = '<div class="form-group"><select name="delegate_city_id' + row_count +'" id="delegate_city_id' + row_count +'"  style="width:130px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_city"><option value="#city_id#">#city_name#</option></cfoutput></select></div>'; //add_general_prom();
		
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		kontrol_row_count--;
	}
	function kontrol()
	{
		static_row=0;
		if(row_count<=0)
		{
			alert("Lütfen Satır Ekleyerek Kayıt Girmeye Başlayınız");
			return false;
		}
		else
		{
		for(r=1;r<=row_count;r++)		
		{
			if(eval("document.list_delegate.row_kontrol"+r).value == 1)			
			{	
				static_row++;
				deger_ref_pos_code_name = eval("document.list_delegate.ref_pos_code_name"+r);
				deger_delegate_city_id = eval("document.list_delegate.delegate_city_id"+r);
				
				if(deger_ref_pos_code_name.value=="")
				{
					alert(static_row+". Satır İçin Temsilci Seçiniz");
					return false;
				}
			
				if(deger_delegate_city_id.value=="")
				{
					alert(static_row+". Satır İçin İl Seçiniz");
					return false;
				}
		
			}
		}
		}
		return true;
	}
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_cons&field_id=list_delegate.ref_pos_code'+ no +'&field_name=list_delegate.ref_pos_code_name'+ no +'&select_list=3','list','popup_list_cons');
	}
</script>

