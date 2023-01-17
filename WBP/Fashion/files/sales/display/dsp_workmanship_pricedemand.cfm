<!--------NUMUNE SAYFASI İŞÇİLİK FİYAT TALEPLERİ EKRANI--------------------->
<cfparam name="attributes.product_edit" default="0">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.category" default="">

<cfinclude template="../../../../../V16/objects/query/get_product_cat2.cfm">
<cfset textile_round=3>
<cfsetting showdebugoutput="no">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_req_supplier_rival");
	get_money = CreateCompenent.getMoney();
	get_workstation=CreateCompenent.getWorkstation();
	get_operation=CreateCompenent.getOperation();
	plan_id=attributes.plan_id;
	if(attributes.request_plan eq 1)//plana gore bakmasına gerek yok diye dusunuyoruz
	plan_id='';
	getAuthority=CreateCompenent.getProcessAuthority(process_stage:full_stage_id);
	if (attributes.request_plan eq 1)
		get_process=CreateCompenent.getReqProcess(req_id:attributes.req_id,pcatid:workshipman_pcatid,plan_id:plan_id);
	else if (attributes.workmanship_plan eq 1 and getAuthority eq 0){
		get_process=CreateCompenent.getReqProcess(req_id:attributes.req_id,pcatid:workshipman_pcatid,plan_status:1,access:1,plan_id:plan_id);
		}
	else if (attributes.workmanship_plan eq 1 and getAuthority gt 0){
		get_process=CreateCompenent.getReqProcess(req_id:attributes.req_id,pcatid:workshipman_pcatid,plan_status:1,plan_id:plan_id);
	}
</cfscript>
<cfform name="add_req_process" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req_process" enctype="multipart/form-data">
	<cf_grid_list>
		<cfoutput>
			<input type="hidden" name="req_id" id="req_id" value="#attributes.req_id#">
			<input type="hidden" name="referal_page" value="list_process">
            <input type="hidden" name="record_num" id="record_num" value="#get_process.RECORDCOUNT#">
			<input type="hidden" name="product_catid" value="#workshipman_pcatid#">
			<cfif attributes.request_plan eq 1>
				<input type="hidden" name="supplier_page" value="request_plan">
			<cfelseif attributes.workmanship_plan eq 1>
				<input type="hidden" name="supplier_page" value="workmanship_plan">
			</cfif>
			<cfif isDefined("attributes.plan_id") and len(attributes.plan_id)>
				<input type="hidden" name="plan_id" id="plan_id" value="#attributes.plan_id#">
			</cfif>
		</cfoutput>
        <thead >
            <tr>
				<th width="250"><cf_get_lang dictionary_id='57777.İşlemler'>*</th>
				<cfif attributes.request_plan eq 1><th><cf_get_lang dictionary_id='58445.İş'></th></cfif>
				<th><cf_get_lang dictionary_id='57756.Durum'></th>
				<th><cf_get_lang dictionary_id='62708.Asıl/Revize'></th>
				<th width="170"><cf_get_lang dictionary_id='58693.Seç'>*</th>
				<th width="150"><cf_get_lang dictionary_id='29419.Operasyon'></th>
				<th width="170"><cf_get_lang dictionary_id='58084.Fiyat'>*</th>
				<th width="170"><cf_get_lang dictionary_id='40935.Revize'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
				<th width="50"><cf_get_lang dictionary_id='62709.Parabirim'>*</th>
				<th width="50"><cf_get_lang dictionary_id='62710.Orjinal'></th>
				<th width="150"><cf_get_lang dictionary_id='36199.Açıklama'></th>
				<th width="170"><cf_get_lang dictionary_id='57514.Resim Ekle'></th>
            </tr>
        </thead>
        <tbody id="tablewm">
		<cfoutput query="get_process">
			<tr name="frow#currentrow#" id="frow#currentrow#" class="<cfif is_status eq 0>lock</cfif>">
				<td   nowrap="nowrap">
					<cfif attributes.request_plan eq 1><!---sadece numune tarafında silme kopyalama islemleri yapılabilir--->
						<cfif sec gt 0 and is_status neq 0>
						       <a style="cursor:pointer" onclick="copy_workmanship(#currentrow#);"><img  src="images/copy_list.gif" border="0"></a>
						</cfif>
					</cfif>
					#product_name#
						<input type="hidden" name="pname#currentrow#" value="#product_name#">
					    <input type="hidden" name="process#currentrow#" value="#process#">
						<input type="hidden" name="product_id#currentrow#" value="#product_id#">
						<input type="hidden" name="stock_id#currentrow#" value="#stock_id#">
						<input type="hidden" name="row_id#currentrow#" value="#id#">
				</td>
				<cfif attributes.request_plan eq 1>
				<td  nowrap="nowrap">
					<cfif len(plan_id)>
						<cfif trim(product_name) neq "Yıkama İşçiliği">
						<a href="javacript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=textile.workmanship_plan&event=upd&plan_id=#plan_id#','page')">#plan_id#</a>
						<cfelse>
						<a href="javacript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=textile.wash_plan&event=upd&plan_id=#plan_id#','page')">#plan_id#</a>
						</cfif>
					</cfif>
				</td>
				</cfif>
				<td  nowrap="nowrap">
					<select name="status#currentrow#" id="status#currentrow#">
							<option value="1" <cfif is_status neq 0>selected</cfif>><cf_get_lang dictionary_id='57493.Active'></option>
							<option value="0" <cfif is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</td>
				<td  nowrap="nowrap">
					<select name="revize#currentrow#"  id="revize#currentrow#">
							<option value="0" <cfif is_revision neq 1>selected</cfif>><cf_get_lang dictionary_id='31403.Asıl'></option>
							<option value="1" <cfif is_revision eq 1>selected</cfif>><cf_get_lang dictionary_id='40935.Revize'></option>
					</select>
				</td>
				<td nowrap="nowrap">
					<cfif attributes.request_plan eq 1>
						<input type="checkbox" name="chk_proc#currentrow#" value="" <cfif sec gt 0>checked</cfif>>
					<cfelse>
						<input type="hidden" name="chk_proc#currentrow#" value="" >
						<i class="fa fa-check fa-lg"></i>
					</cfif>
				</td>
				<cfif isDefined("attributes.product_catid")>
					<cfset product_cat_operation = CreateCompenent.get_supplier_by_productcat(productcat_id:attributes.product_catid)>
					<cfset product_cat_operationST = deserializeJson(product_cat_operation)>
				</cfif>
				<td nowrap="nowrap">
					<select style="width:140px;" <cfif attributes.request_plan eq 0>disabled<cfelse>required</cfif> name="operation#currentrow#" id="operation_work#currentrow#">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop query="get_operation"><option value="#operation_type_id#" <cfif (((get_operation.OPERATION_TYPE_ID eq get_process.operation_id) or (isDefined("product_cat_operationST") and product_cat_operationST.STATUS eq true and get_operation.OPERATION_TYPE_ID eq product_cat_operationST.SUPLIERS_ID)) and trim(get_process.product_name) neq "Yıkama İşçiliği") or trim(get_process.product_name) eq "Yıkama İşçiliği">selected</cfif>>#OPERATION_TYPE#</option></cfloop>
					</select>
				</td>
				<td nowrap="nowrap">
					<input type="text"  name="price#currentrow#"   class="moneybox" value="#tlformat(req_price,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));"  style="width:100px;">
				</td>
					<td nowrap="nowrap">
					<input type="text"  name="revize_price#currentrow#"   class="moneybox" value="#tlformat(revize_price,textile_round)#" onkeyup="return(FormatCurrency(this,event,#textile_round#));"  style="width:100px;">
				</td>
				<td nowrap="nowrap">
					<select name="money#currentrow#" id="money#currentrow#"  <cfif attributes.request_plan eq 1>disabled</cfif> style="width:60px;">
					<cfloop query="get_money">
						<option value="#get_money.money#" <cfif get_money.money eq get_process.REQ_MONEY>selected</cfif>>#get_money.money#</option>
					</cfloop>
					</select>
				</td>
				<td nowrap="nowrap">
						<input type="checkbox" name="chk_orj#currentrow#" value="" <cfif sec_orj gt 0>checked</cfif>>
					</td>
				<td nowrap="nowrap">
					<input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#get_process.detail_#" style="width:155px;">	
				</td>
				<td nowrap="nowrap">
					<cfif len(IMAGE_PATH)>
						<input type="hidden"  name="image_var#currentrow#" id="image_var#currentrow#" value="#IMAGE_PATH#">
						<input type="file" style="width:180px;" name="image_#currentrow#" id="image_#currentrow#" value="">
						<a href="/documents/textile/iscilik/#IMAGE_PATH#">#IMAGE_PATH#</a>
					<cfelse>
							<input type="file" style="width:180px;"  name="image_#currentrow#" id="image_#currentrow#" value="">
					</cfif>
				</td>
			</tr>	
		</cfoutput>
        </tbody>
		
   </cf_grid_list>
   <cf_box_footer>
	<tr>
	      
		<div class="col col-12 ui-form-list-btn">
				<cfif get_process.RECORDCOUNT eq 0>
					<cf_workcube_buttons is_upd='0' add_function='kontrol_w()' type_format="1">
				<cfelse>
						<cfif isDefined("attributes.req_stage") and attributes.req_stage neq request_accept_stage_id>
							<div class="form-group">	
								<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left"><i class="fa fa-plus"></i><cf_get_lang dictionary_id='30828.Talep'>-<cf_get_lang dictionary_id='58868.İş Emri'></a>
							</div>
							<div class="form-group">
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol_w()' type_format="1">
							</div>
						<cfelseif not isDefined("attributes.req_stage")>
							<div class="form-group">	
								<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left"><i class="fa fa-plus"></i><cf_get_lang dictionary_id='30828.Talep'>-<cf_get_lang dictionary_id='58868.İş Emri'></a>
							</div>
							<div class="form-group">
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol_w()' type_format="1">
							</div>
						</cfif>
				</cfif>
			</div>
			<div style="float:left;" id="show_user_message1_b"></div>
		
</cf_box_footer>
</cfform>
<script type="text/javascript">
rcount=<cfoutput>#get_process.RECORDCOUNT#</cfoutput>;


	function kontrol_w()
	{
			//AjaxFormSubmit(add_req_process,'show_user_message1_b',0,'&nbsp;Kaydediliyor','&nbsp;Kaydedildi','#request.self#?fuseaction=textile.emptypopup_add_req_process"&req_id=#attributes.req_id#','div_list_process');return false;
		
		static_row=0;
		for(r=1;r<=rcount;r++)		
		{
			<cfif attributes.request_plan eq 1>
				if(eval("document.add_req_process.chk_proc"+r).checked == true)
				{	
					static_row++;
					deger_op_id = eval("document.add_req_process.operation"+r);
					if(deger_op_id.value =="")
					{
						alert(static_row+".Satır Operasyon seçmelisiniz !");
						return false;
					}
					
					
				}
			<cfelse>
					static_row++;
					deger_price = eval("document.add_req_process.price"+r);
					deger_money = eval("document.add_req_process.money"+r);
					if(deger_price.value =="")
					{
						alert(static_row+".Satır Fiyat girişi yapmalısınız !");
						return false;
					}
					if(deger_money.value =="")
					{
						alert(static_row+".Satır Para birimi girişi yapmalısınız !");
						return false;
					}					
			</cfif>
		}
		
		
		return true;
	}
	function copy_workmanship(sy)
	{
	
	if(eval('document.add_req_process.status'+sy).value==0)
	{
		return;
	}
	
	eval('document.add_req_process.status'+sy).value=0;
	eval('document.add_req_process.revize'+sy).value=0;
	var pname=eval('document.add_req_process.pname'+sy).value;
	var process=eval('document.add_req_process.process'+sy).value;
	var stock_id=eval('document.add_req_process.stock_id'+sy).value;
	var product_id=eval('document.add_req_process.product_id'+sy).value;
	var row_id=eval('document.add_req_process.row_id'+sy).value;
	var price=0;//eval('document.add_req_process.price'+sy).value;
	var revize_price=0;//eval('document.add_req_process.revize_price'+sy).value;
	var money=eval('document.add_req_process.money'+sy).value;
	var chk_proc=eval('document.add_req_process.chk_proc'+sy).checked;
	var chk_orj=eval('document.add_req_process.chk_orj'+sy).checked;
	var detail=eval('document.add_req_process.detail'+sy).value;
	var image_=eval('document.add_req_process.image_'+sy).value;

			rcount++;
			var newRow;
			var newCell;
			newRow = document.getElementById("tablewm").insertRow(document.getElementById("tablewm").rows.length);
			newRow.setAttribute("name","frow" + rcount);
			newRow.setAttribute("id","frow" + rcount);	
			newRow.setAttribute("NAME","frow" + rcount);
			newRow.setAttribute("ID","frow" + rcount);	
			document.add_req_process.record_num.value=rcount;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = pname+' <input type="hidden" name="process'+rcount+'" value="'+process+'"><input type="hidden" name="product_id'+rcount+'" value="'+product_id+'"><input type="hidden" name="stock_id'+rcount+'" value="'+stock_id+'"><input type="hidden" name="row_id'+rcount+'" value="">';
			

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<select name="status'+rcount+'" id="status'+rcount+'"><option value="1">Aktif</option><option value="0">Pasif</option></select>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<select name="revize'+rcount+'" id="revize'+rcount+'"><option value="0">Asıl</option><option value="1">Revize</option></select>';

			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<input type="checkbox" name="chk_proc'+rcount+'" value="" checked>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<select style="width:140px;" <cfif attributes.request_plan eq 0>disabled</cfif> name="operation'+rcount+'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_operation"><option value="#operation_type_id#" <cfif get_operation.OPERATION_TYPE_ID eq get_process.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<input type="text"  name="price'+rcount+'"   class="moneybox" value="'+price+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));"  style="width:100px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML ='<input type="text"  name="revize_price'+rcount+'"   class="moneybox" value="'+revize_price+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));"  style="width:100px;">';

		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<select name="money'+rcount+'" id="money'+rcount+'"  style="width:60px;"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="checkbox" name="chk_orj'+rcount+'" value="">';
			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="detail'+rcount+'" id="detail'+rcount+'" value="'+detail+'" style="width:155px;">';

					
					newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="file"  name="image_'+rcount+'" id="image_'+rcount+'">';
		
			eval('document.add_req_process.money'+rcount).value=money;
		
			eval('document.add_req_process.revize'+rcount).value=1;

			eval('document.add_req_process.chk_orj'+rcount).checked=chk_orj;
			
			colorchangews(sy,rcount);
	
		}
colorchangews();
function colorchangews(sy,newrow)
{
  if(sy!=undefined)
  {
	$('#tablewm #'+'frow'+sy+' td').css("background-color", "#CD6155");
	$('#tablewm #'+'frow'+sy+' td').css("color", "#000");
	
	if(eval('document.add_req_process.revize'+newrow).value=='1')
		{
			$('#tablewm #'+'frow'+newrow+' td').css("background-color", "yellow");
			$('#tablewm #'+'frow'+newrow+' td').css("color", "#000");
		}
  }
  else
  {
	for(var i=1;i<=rcount;i++)
	{	if(eval('document.add_req_process.status'+i).value=='0')
		{
			$('#tablewm #'+'frow'+i+' td').css("background-color", "#CD6155");
			$('#tablewm #'+'frow'+i+' td').css("color", "#000");
		}
		if(eval('document.add_req_process.revize'+i).value=='1')
		{
			$('#tablewm #'+'frow'+i+' td').css("background-color", "#ABEBC6");
			$('#tablewm #'+'frow'+i+' td').css("color", "#000");
		}
		
	}
  
  }
	
}
$(document).ready(function(){
	$('.lock input').prop('readonly','true');
	$('.lock select').prop('disabled','true');
	$('.lock input[type=checkbox]').prop('readonly',true);
});


</script>
