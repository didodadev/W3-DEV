<cf_papers paper_type="stock_fis">
<cf_xml_page_edit fuseact="stock.form_add_spec_exchange">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
 </cfif> 
<cfscript>
xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'));
</cfscript>
<cf_catalystHeader>
<cf_box>
<cfform name="add_virman" action="#request.self#?fuseaction=stock.empytpopup_add_spec_exchange" method="post">
<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"><!--- islem yapılırken donemmi kontrol etmek icin --->
<input type="hidden" name="spect_name" id="spect_name">
	<cf_box_elements>
                	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-exchange_no_">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fis No'> *</label>
                            <div class="col col-8 col-xs-12">
                            	<input type="text" name="exchange_no_" id="exchange_no_" value="<cfoutput>#system_paper_no#</cfoutput>" readonly style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57657.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
                                	<input type="hidden" name="product_id" id="product_id" value="">
                                    <input type="hidden" name="stock_id" id="stock_id" value="">
                                    <input type="hidden" name="stock_code" id="stock_code" value="">
                                    <input type="text" name="product_name" id="product_name" value="" style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_code=add_virman.stock_code&product_id=add_virman.product_id&field_id=add_virman.stock_id&field_name=add_virman.product_name&keyword='+encodeURIComponent(document.add_virman.product_name.value),'list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-amount">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57635.Miktar'></label>
                            <div class="col col-8 col-xs-12">
                            	<input type="text" name="amount" id="amount" value="<cfoutput>#TLFormat(1,3)#</cfoutput>" style="width:150px;" class="moneybox" onKeyUp="return FormatCurrency(this,event,3);">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    	<div class="form-group" id="item-process_cat">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57124.İşlem Kategorisi'></label>
                            <div class="col col-8 col-xs-12">
                            	<cf_workcube_process_cat slct_width="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-location_id">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                            <div class="col col-8 col-xs-12">
								<!--- <input type="hidden" name="department_id" value="">
                                <input type="text" name="department_name" value="" style="width:150px;"> --->
                                <cf_wrkdepartmentlocation
                                    returnInputValue="location_id,department_name,department_id"
                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldId="location_id"
									xml_all_depo = "#xml_all_depo#"
                                    fieldName="department_name"
                                    department_fldId="department_id"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    width="137">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    	<div class="form-group" id="item-process_date">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group x-11">
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                					<cfinput type="text" name="process_date" maxlength="10" value="#dateformat(now(),dateformat_style)#"  validate="#validate_style#" required="yes" message="#message#" style="width:65px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                </div>
                            </div>
                        </div>
                        <!--- <cf_get_lang no ='2234.Lokasyon'> --->
						<!--- <input type="hidden" name="location_id" value="">
                        <input type="text" name="location_name" value="" style="width:150px;">
                        <a href="javascript://" onclick="open_location_popup();"><img src="/images/plus_list.gif" alt="<cf_get_lang no='322.seçiniz'>" border="0" align="absmiddle"></a> --->
                    </div>
     
                </cf_box_elements>
               <cf_box_footer>
                    	<cf_workcube_buttons add_function='control()'>
				</cf_box_footer>
				&nbsp;			
    <div class="col col-12">
            <div class="col col-6 col-xs-12">
                    <cf_grid_list >
                        <thead>
                            <tr>
                                <th nowrap="nowrap"><cf_get_lang dictionary_id ='45637.Çıkan Spec'></th>
                                <th colspan="4" nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
                                    <input type="hidden" name="main_spec_id" id="main_spec_id" value="">
                                    <input type="text" name="main_spec_name" id="main_spec_name" value="" style="width:500px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="product_control();"></span>
									</div></div>
								</th>
                            </tr>
                            <tr> 
                                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                                <th><cf_get_lang dictionary_id ='57647.Spec'></th>
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th><cf_get_lang dictionary_id ='45712.SB'></th>
                            </tr>
                        </thead>
                        <tbody id="table_old_spec">
                            <tr class="color-row">
                                <td colspan="6"><cf_get_lang dictionary_id ='45638.Spec Seçiniz'></td>
                            </tr>
                        </tbody>
                    </cf_grid_list>					
            </div>
            <div class="col col-6 col-xs-12">
                    <cf_grid_list >
                    <thead>
                        <tr>
                            <th height="23" colspan="6"><cf_get_lang dictionary_id ='57554.Giriş'></th>
                        </tr>
                        <input type="hidden" name="sb_record_num" id="sb_record_num" value="0">
                        <tr class="color-header">
                            <th width="15"><a onClick="add_row();"><i class="fa fa-plus" title="Ekle" alt="Ekle"></i></a></th>
                            <th style="width:120px"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th style="width:300px"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                            <th style="width:80px"><cf_get_lang dictionary_id ='57647.Spec'></th>
                            <th style="width:50px"><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id ='45712.SB'></th>
                        </tr>
                     </thead>
                     <tbody id="table_new_spec">
                        <tr>
                            <td colspan="6"><cf_get_lang dictionary_id ='45638.Spec Seçiniz'></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
             </div>
         </div>
</cfform>
</cf_box>
<script type="text/javascript">
var row_count=0;
function control()
{
	if(document.add_virman.stock_id.value=="" || document.add_virman.product_name.value=="" )
	{
		alert("<cf_get_lang dictionary_id='58227.Ürün seçmeniz gerekmektedir'>");
		return false;
	}else if(document.add_virman.department_name.value=="" || document.add_virman.location_id.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45372.Depo seçmeniz gerekmektedir'>.");
		return false;
	}else if(document.add_virman.main_spec_id.value=="" || document.add_virman.main_spec_name.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45638.Spec seçmeniz gerekmektedir'>.");
		return false;
	}
	if(!chk_period(add_virman.process_date)) return false;
	if (!chk_process_cat('add_virman')) return false;
	if(!check_display_files('add_virman')) return false;
	document.add_virman.amount.value=filterNum(document.add_virman.amount.value);
	for(var row=0;row <= row_count;row++)
	{
		if(eval('document.add_virman.sb_amount'+row)!=undefined)
			eval('document.add_virman.sb_amount'+row).value=filterNum(eval('document.add_virman.sb_amount'+row).value);
	}
	return true;
}
function product_control()/*Ürün seçmeden spect seçemesin.*/
{
	if(document.add_virman.stock_id.value=="" || document.add_virman.product_name.value=="" )
	{
		alert("<cf_get_lang dictionary_id ='45639.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
	}else if(document.add_virman.department_name.value=="" || document.add_virman.location_id.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45640.Spect Seçmek için öncelikle depo seçmeniz gerekmektedir'>");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_virman.main_spec_id&field_name=add_virman.main_spec_name&function_name=get_spec_row&is_display=1&is_stock=1&process_date='+document.add_virman.process_date.value+'&department_id='+document.add_virman.department_id.value+'&location_id='+document.add_virman.location_id.value+'&stock_id='+document.add_virman.stock_id.value,'list');
}

function open_product_detail(pro_id,s_id)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
}

function open_sb_add_row(sy)
{//sadece alternatifler gelmesi isin is_only_alternative v.s. parametreleri eklendi
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_virman.sb_stock_id'+sy+'&field_name=add_virman.sb_product_name'+sy+'&product_id=add_virman.sb_product_id'+sy+'&field_code=add_virman.sb_stock_code'+sy+'&is_form_submitted=1&is_only_alternative=1&alternative_product='+eval("document.add_virman.sb_product_id"+sy).value,'list');
}

function table_clear()
{
	document.getElementById("table_old_spec").innerHTML = "";
	document.getElementById("table_new_spec").innerHTML = "";
	var oTable=document.getElementById("table_old_spec");
	while(oTable.rows.length>1)
		oTable.deleteRow(oTable.rows.length-1);
	var nTable=document.getElementById("table_new_spec");
	while(nTable.rows.length>1)
		nTable.deleteRow(nTable.rows.length-1);
}

function sil_sb_row(sy)
{
	var my_element=eval("add_virman.sb_row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("sb_row"+sy);
	my_element.style.display="none";
}


function add_row()
{
	if(document.add_virman.main_spec_id.value=="" || document.add_virman.main_spec_name.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45638.Spec seçmeniz gerekmektedir'>");
		return false;
	}
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_new_spec").insertRow(document.getElementById("table_new_spec").rows.length);
	//newRow.setAttribute("class","color-row");
	newRow.setAttribute("className", "color-row");
	newRow.setAttribute("name","sb_row" + row_count);
	newRow.setAttribute("id","sb_row" + row_count);		
	newRow.setAttribute("NAME","sb_row" + row_count);
	newRow.setAttribute("ID","sb_row" + row_count);
	newRow.setAttribute("height","30");
	document.add_virman.sb_record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="sil_sb_row('+row_count+')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='50765.Ürün Sil'>"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'" value="" style="width:110px" readonly><input type="hidden" name="sb_product_id'+row_count+'" value=""><input type="hidden" id="sb_stock_id'+row_count+'" name="sb_stock_id'+row_count+'" value="">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="sb_product_name'+row_count+'" value="" style="width:260px" readonly><span class="input-group-addon icon-ellipsis btnPointer" title="<cfoutput>#getlang('','Ürün Ekle','29410')#</cfoutput>" onclick="open_sb_add_row('+row_count+')"></span><span class="input-group-addon icon-ellipsis btnPointer" title="<cfoutput>#getlang('','Ürün Detay','45644')#</cfoutput>" onclick="open_product_detail(add_virman.sb_product_id'+row_count+'.value,add_virman.sb_stock_id'+row_count+'.value)"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" style="width:60px;" name="related_spect_main_id'+row_count+'" value="" readonly><span class="input-group-addon icon-ellipsis btnPointer" title="<cfoutput>#getlang('','Spekt Ekle','32446')#</cfoutput>" onClick="open_spec_page('+row_count+');"></span></div></div>';	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("align", "right");
	newCell.innerHTML = '<input type="text" name="sb_amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" style="width:40px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="checkbox" name="sb_is_sevk'+row_count+'" value="1" checked disabled="disabled">';	
}

function add_row_spec(type,table_id,rw,stock_id,prod_id,stock_code,prod_name,amount,is_sb,related_spect_main_id)
{
	var newRow;
	var newCell;
	newRow = eval('document.all.'+table_id).insertRow();
	//newRow.setAttribute("class","color-row");
	newRow.setAttribute("className", "color-row"); 
	newRow.setAttribute("height","30");
	if(type=='txt')
	{
		//eskisi uzerind duzenleme olmayacagından bu sekilde gelmesi yeterli
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = stock_code;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = prod_name;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = related_spect_main_id;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = commaSplit(amount,3);
		newCell.setAttribute("align", "right");
		newCell = newRow.insertCell(newRow.cells.length);
		if(is_sb==1) newCell.innerHTML = '*'; else newCell.innerHTML ='';
	}else
	{
		//formsa id vermekyeter text olarak eklenende gerek yok
		newRow.setAttribute("name","sb_row" + rw);
		newRow.setAttribute("id","sb_row" + rw);		
		newRow.setAttribute("NAME","sb_row" + rw);
		newRow.setAttribute("ID","sb_row" + rw);
		row_count=row_count+1;
		document.add_virman.sb_record_num.value=row_count;
		if(is_sb==0)
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = stock_code;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = prod_name;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = related_spect_main_id;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("align", "right");
			newCell.innerHTML = commaSplit(amount,3);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}
		else
		{			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="sil_sb_row('+row_count+')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='50765.Ürün Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'" value="'+stock_code+'" style="width:120px" readonly><input type="hidden" name="sb_product_id'+row_count+'" value="'+prod_id+'"><input type="hidden" id="sb_stock_id'+row_count+'" name="sb_stock_id'+row_count+'" value="'+stock_id+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="sb_product_name'+row_count+'" value="'+prod_name+'" style="width:300px" readonly><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>" onclick="open_sb_add_row('+row_count+')"></span><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='45644.Ürün Detay'>" onclick="open_product_detail(add_virman.sb_product_id'+row_count+'.value,add_virman.sb_stock_id'+row_count+'.value)"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" style="width:80px;text-align:right;" name="related_spect_main_id'+row_count+'" value="'+related_spect_main_id+'" readonly><span class="input-group-addon icon-ellipsis btnPointer" onClick="open_spec_page('+row_count+');"></span></div></div>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("align", "right");
			newCell.innerHTML = '<input type="text" name="sb_amount'+row_count+'" value="'+commaSplit(amount,3)+'" class="moneybox" style="width:50px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="sb_is_sevk'+row_count+'" value="1" checked disabled="disabled">';	
		}	
	}
}
function open_spec_page(row_count){
	var _stock_id_ = document.getElementById('sb_stock_id'+row_count).value;
	if(_stock_id_ != undefined && _stock_id_ != "")
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_virman.related_spect_main_id'+row_count+'&is_display=1&is_stock=1&stock_id='+_stock_id_,'list');
}
function get_spec_row()
{
	//yeni bastan eklendigi iscin row_count sıfırlanıyor ve satırlar siliniyor
	row_count=0;
	table_clear();
	var get_row = wrk_safe_query('stk_get_row_spec','dsn3',0,document.add_virman.main_spec_id.value);
	for(var rw=0;rw<get_row.recordcount;rw++)
	{
		var str_rw = rw+1;
		add_row_spec('txt','table_old_spec',str_rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
		add_row_spec('form','table_new_spec',str_rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
	}
}

function open_location_popup()
{
	if(document.add_virman.main_spec_id.value!="" || document.add_virman.main_spec_name.value!="")
	{
		if(confirm("<cf_get_lang dictionary_id ='45641.Spec Seçmişsiniz Depo Değiştirseniz Spec Boşaltılacaktır'>!"))
		{
			document.add_virman.main_spec_id.value="";
			document.add_virman.main_spec_name.value="";
			table_clear();
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=add_virman&field_name=department_name&field_location_id=location_id&field_id=department_id&field_location=location_name</cfoutput>','medium');
		}
	}
	else
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=add_virman&field_name=department_name&field_location_id=location_id&field_id=department_id&field_location=location_name</cfoutput>','medium');
	}
	return true;
}
</script>
