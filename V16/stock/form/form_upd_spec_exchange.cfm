<cf_xml_page_edit fuseact="stock.form_add_spec_exchange">
<cfscript>
	xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1')); 
</cfscript>
<cfquery name="GET_STOCK_EXCHANGE" datasource="#DSN2#">
	SELECT
		STOCK_EXCHANGE.EXCHANGE_NUMBER,
		STOCK_EXCHANGE.STOCK_ID,
		STOCK_EXCHANGE.PRODUCT_ID,
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		STOCK_EXCHANGE.PROCESS_CAT,
		STOCK_EXCHANGE.PROCESS_DATE,
		STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID OLD_SPECT_MAIN_ID,
		STOCK_EXCHANGE.SPECT_MAIN_ID,
		STOCK_EXCHANGE.RECORD_EMP,
		STOCK_EXCHANGE.RECORD_DATE,
		STOCK_EXCHANGE.UPDATE_EMP,
		STOCK_EXCHANGE.UPDATE_DATE,
		STOCK_EXCHANGE.AMOUNT,
		STOCK_EXCHANGE.DEPARTMENT_ID,
		STOCK_EXCHANGE.LOCATION_ID
	FROM
		STOCK_EXCHANGE,
		#dsn3_alias#.STOCKS S
	WHERE
		STOCK_EXCHANGE.STOCK_EXCHANGE_ID = #attributes.exchange_id# AND
		S.STOCK_ID = STOCK_EXCHANGE.STOCK_ID
</cfquery>
<cfquery name="GET_SPEC_NEW" datasource="#dsn3#">
	SELECT
    	SMR.RELATED_MAIN_SPECT_ID,
		SM.SPECT_MAIN_NAME,
		SMR.AMOUNT,
		SMR.PRODUCT_NAME,
		IS_SEVK,
		S.STOCK_CODE,
		SMR.PRODUCT_ID,
		SMR.STOCK_ID
	FROM
		SPECT_MAIN SM,
		SPECT_MAIN_ROW SMR,
		#dsn1_alias#.STOCKS S
	WHERE 
		SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
		SM.SPECT_MAIN_ID = #GET_STOCK_EXCHANGE.SPECT_MAIN_ID# AND
		SMR.STOCK_ID = S.STOCK_ID
</cfquery>
<cfquery name="GET_SPEC_OLD" datasource="#dsn3#">
	SELECT
    	SMR.RELATED_MAIN_SPECT_ID,
		SM.SPECT_MAIN_NAME,
		SMR.AMOUNT,
		SMR.PRODUCT_NAME,
		IS_SEVK,
		S.STOCK_CODE,
		SMR.PRODUCT_ID,
		SMR.STOCK_ID
	FROM
		SPECT_MAIN SM,
		SPECT_MAIN_ROW SMR,
		#dsn1_alias#.STOCKS S
	WHERE 
		SM.SPECT_MAIN_ID = SMR.SPECT_MAIN_ID AND
		SM.SPECT_MAIN_ID = #GET_STOCK_EXCHANGE.OLD_SPECT_MAIN_ID# AND
		SMR.STOCK_ID = S.STOCK_ID
</cfquery>
<cf_catalystHeader>
<cf_box>
<cfform name="add_virman" action="#request.self#?fuseaction=stock.empytpopup_upd_spec_exchange" method="post">
	<input type="hidden" name="exchange_id" id="exchange_id" value="<cfoutput>#attributes.exchange_id#</cfoutput>">
	<input type="hidden" name="spect_name" id="spect_name">
	<input type="hidden" name="old_process_cat" id="old_process_cat" value="<cfoutput>#GET_STOCK_EXCHANGE.PROCESS_CAT#</cfoutput>">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"><!--- islem yapılırken donem degirse kontrol etmek icin --->
		        <cf_box_elements>
                	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    	<div class="form-group" id="item-exchange_no_">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fis No'> *</label>
                            <div class="col col-8 col-xs-12">
                            	<input type="text" name="exchange_no_" id="exchange_no_" value="<cfoutput>#GET_STOCK_EXCHANGE.EXCHANGE_NUMBER#</cfoutput>" readonly style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-product_name">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57657.Ürün'>*</label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
                                	<input type="hidden" name="stock_code" id="stock_code" value="<cfoutput>#GET_STOCK_EXCHANGE.STOCK_CODE#</cfoutput>">
                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#GET_STOCK_EXCHANGE.PRODUCT_ID#</cfoutput>">
                                    <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#GET_STOCK_EXCHANGE.STOCK_ID#</cfoutput>">
                                    <input type="text" name="product_name" id="product_name" value="<cfoutput>#GET_STOCK_EXCHANGE.PRODUCT_NAME#</cfoutput>" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_code=add_virman.stock_code&product_id=add_virman.product_id&field_id=add_virman.stock_id&field_name=add_virman.product_name&keyword='+encodeURIComponent(document.add_virman.product_name.value),'list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-amount">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57635.Miktar'></label>
                            <div class="col col-8 col-xs-12">
                            	<input type="text" name="amount" id="amount" value="<cfoutput>#TLFormat(GET_STOCK_EXCHANGE.AMOUNT,3)#</cfoutput>" style="width:150px;" class="moneybox" onKeyUp="return FormatCurrency(this,event,3);">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    	<div class="form-group" id="item-process_cat">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57124.İşlem Kategorisi'></label>
                            <div class="col col-8 col-xs-12">
                            	<cf_workcube_process_cat process_cat="#GET_STOCK_EXCHANGE.PROCESS_CAT#" slct_width="150">
                            </div>
                        </div>
                        <div class="form-group" id="item-location_id">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                            <div class="col col-8 col-xs-12">
								<cfquery name="GET_DEP" datasource="#dsn#">
                                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #GET_STOCK_EXCHANGE.DEPARTMENT_ID#
                                </cfquery>
                                <cfquery name="GET_LOCATION" datasource="#dsn#">
                                    SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = #GET_STOCK_EXCHANGE.DEPARTMENT_ID# AND LOCATION_ID=#GET_STOCK_EXCHANGE.LOCATION_ID#
                                </cfquery>
                                <!--- <input type="hidden" name="department_id" value="<cfoutput>#GET_STOCK_EXCHANGE.DEPARTMENT_ID#</cfoutput>">
								<input type="text" name="department_name" value="<cfoutput>#GET_DEP.DEPARTMENT_HEAD#</cfoutput>" style="width:150px;"> --->
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldId="location_id"
									fieldName="department_name"
									department_fldId="department_id"
									xml_all_depo = "#xml_all_depo#"
									department_id="#GET_STOCK_EXCHANGE.DEPARTMENT_ID#"
									location_id="#GET_STOCK_EXCHANGE.LOCATION_ID#"
									location_name="#GET_DEP.DEPARTMENT_HEAD#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									width="150">
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    	<div class="form-group" id="item-process_date">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group x-11">
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="process_date" maxlength="10" value="#dateformat(GET_STOCK_EXCHANGE.PROCESS_DATE,dateformat_style)#"  validate="#validate_style#" required="yes" message="#message#" style="width:65px;">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
				</cf_box_elements>
               <cf_box_footer>
                    	<cf_record_info query_name="GET_STOCK_EXCHANGE">
                    	<cf_workcube_buttons add_function='control()' is_upd="1" delete_page_url="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_spec_exchange&exchange_id=#attributes.exchange_id#&process_type=#GET_STOCK_EXCHANGE.PROCESS_CAT#">
						</cf_box_footer>
						&nbsp;

    	<div class="col col-12">
			
            		<div class="col col-6 col-xs-12">
                	
					<cf_grid_list id="table_old_spec">
				 <thead>
                    <tr>
                        <th nowrap="nowrap"><cf_get_lang dictionary_id ='45637.Çıkan Spec'></th>
                        <th colspan="4" nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
							<input type="hidden" name="main_spec_id" id="main_spec_id" value="<cfoutput>#GET_STOCK_EXCHANGE.OLD_SPECT_MAIN_ID#</cfoutput>">
							<input type="text" name="main_spec_name" id="main_spec_name" value="<cfoutput>#GET_SPEC_OLD.SPECT_MAIN_NAME#</cfoutput>" style="width:175px;">
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
				<tbody>
					<cfoutput query="GET_SPEC_OLD">
						<tr class="color-row" height="30">
							<td>#STOCK_CODE#</td>
							<td>#PRODUCT_NAME#</td>
							<td align="right" style="text-align:right;">#RELATED_MAIN_SPECT_ID#</td>
							<td align="right" style="text-align:right;">#TLFormat(AMOUNT,3)#</td>
							<td><cfif IS_SEVK eq 1>*</cfif></td>
						</tr>
					</cfoutput>
                </tbody>
			</cf_grid_list>
            		
                    </div>
					<div class="col col-6 col-xs-12">

			 	<cf_grid_list id="table_new_spec">
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
                 <tbody>
				 	<cfset sb_count=0>
                    <cfoutput query="GET_SPEC_NEW">
						<cfif IS_SEVK eq 0>
							<cfset sb_count=sb_count+1>
							<tr class="color-row" height="30" id="sb_row#currentrow#">
								<td></td>
								<td>#STOCK_CODE#</td>
								<td>#PRODUCT_NAME#</td>
								<td align="right" style="text-align:right;">#RELATED_MAIN_SPECT_ID#</td>
								<td align="right" style="text-align:right;">#TLFormat(AMOUNT,3)#</td>
								<td></td>
							</tr>
						<cfelse>
							<cfset sb_count=sb_count+1>
							<tr class="color-row" height="30" id="sb_row#currentrow#">
								<td><input type="hidden" name="sb_row_kontrol#currentrow#" id="sb_row_kontrol#currentrow#" value="1"><a href="javascript://" onClick="sil_sb_row(#currentrow#)"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='50765.Ürün Sil'>" border="0"></a></td>
								<td><input type="text" name="sb_stock_code#currentrow#" id="sb_stock_code#currentrow#" value="#STOCK_CODE#" style="width:120px" readonly>
                                    <input type="hidden" name="sb_product_id#currentrow#" id="sb_product_id#currentrow#" value="#PRODUCT_ID#">
                                    <input type="hidden" name="sb_stock_id#currentrow#" id="sb_stock_id#currentrow#" value="#STOCK_ID#"></td>
								<td><div class="form-group"><div class="input-group"><input type="text" name="sb_product_name#currentrow#" id="sb_product_name#currentrow#" value="#PRODUCT_NAME#" style="width:300px" readonly><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>" onClick="open_sb_add_row(#currentrow#)"></span><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='33929.Ürün Detay'>"  onClick="open_product_detail(add_virman.sb_product_id#currentrow#.value,add_virman.sb_stock_id#currentrow#.value)"></span></div></div></td>
								<td><div class="form-group"><div class="input-group"><input type="text" style="width:80px;text-align:right;" name="related_spect_main_id#currentrow#" id="related_spect_main_id#currentrow#" value="#RELATED_MAIN_SPECT_ID#" readonly><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="open_spec_page(#currentrow#);"></span></div></div></td>
								<td><input type="text" name="sb_amount#currentrow#" id="sb_amount#currentrow#" value="#TLFormat(AMOUNT,3)#" class="moneybox" style="width:50px" align="right" onKeyUp="return FormatCurrency(this,event,3);"></td>
								<td><input type="checkbox" name="sb_is_sevk#currentrow#" id="sb_is_sevk#currentrow#" value="1" checked disabled="disabled"></td>
							</tr>						
						</cfif>
					</cfoutput>
                </tbody>
			</cf_grid_list>
		</div>
	</div>
</cfform>
</cf_box>
<script type="text/javascript">
var row_count=<cfoutput>#GET_SPEC_NEW.RECORDCOUNT#</cfoutput>;
document.add_virman.sb_record_num.value=<cfoutput>#sb_count#</cfoutput>;
function control()
{
	if(document.add_virman.stock_id.value=="" || document.add_virman.product_name.value=="" )
	{
		alert("<cf_get_lang dictionary_id='58227.Ürün seçmeniz gerekmektedir'>.");
		return false;
	}else if(document.add_virman.department_name.value=="" || document.add_virman.location_id.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45684.Depo seçmeniz gerekmektedir'>.");
		return false;
	}else if(document.add_virman.main_spec_id.value=="" || document.add_virman.main_spec_name.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45638.Spec seçmeniz gerekmektedir'>.");
		return false;
	}
	document.add_virman.amount.value=filterNum(document.add_virman.amount.value);
	for(var row=0;row <= row_count;row++)
	{
		if(eval('document.add_virman.sb_amount'+row)!=undefined)
			eval('document.add_virman.sb_amount'+row).value=filterNum(eval('document.add_virman.sb_amount'+row).value);
	}
	if(!chk_period(add_virman.process_date)) return false;
	if (!chk_process_cat('add_virman')) return false;
	if(!check_display_files('add_virman')) return false;
	return true;
}
function product_control()/*Ürün seçmeden spect seçemesin.*/
{
	if(document.add_virman.stock_id.value=="" || document.add_virman.product_name.value=="" )
	{
		alert("<cf_get_lang dictionary_id ='45639.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>.");
		return false;
	}else if(document.add_virman.department_name.value=="" || document.add_virman.location_id.value=="")
	{
		alert("<cf_get_lang dictionary_id ='45640.Spect Seçmek için öncelikle depo seçmeniz gerekmektedir'>.");
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
		alert("<cf_get_lang dictionary_id ='45638.Spec seçmeniz gerekmektedir'>.");
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
	document.add_virman.sb_record_num.value = parseInt(document.add_virman.sb_record_num.value)+1;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'" value="1"><a  title="<cfoutput>#getlang('','Sil','57463')#</cfoutput>" href="javascript://" onClick="sil_sb_row('+row_count+')"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'" value="" style="width:120px" readonly><input type="hidden" id="sb_product_id'+row_count+'" name="sb_product_id'+row_count+'" value=""><input type="hidden" id="sb_stock_id'+row_count+'"  name="sb_stock_id'+row_count+'" value="">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="sb_product_name'+row_count+'" value="" style="width:300px" readonly><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id="29410.Ürün Ekle">" href="javascript://" onclick="open_sb_add_row('+row_count+')"></span><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ="46799.Ürün Detay">" href="javascript://" onclick="open_product_detail(add_virman.sb_product_id'+row_count+'.value,add_virman.sb_stock_id'+row_count+'.value)"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" style="width:80px;text-align:right;" id="related_spect_main_id'+row_count+'" name="related_spect_main_id'+row_count+'" value="" readonly><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="open_spec_page('+row_count+');"></span></div></div>';	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("align", "right");	
	newCell.innerHTML = '<input type="text" name="sb_amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" style="width:50px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
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
			newCell.innerHTML = '<input type="hidden" name="sb_row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="sil_sb_row('+row_count+')"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ="50765.Ürün Sil">"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="sb_stock_code'+row_count+'" value="'+stock_code+'" style="width:120px" readonly><input type="hidden" name="sb_product_id'+row_count+'" value="'+prod_id+'"><input type="hidden" name="sb_stock_id'+row_count+'" value="'+stock_id+'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="sb_product_name'+row_count+'" value="'+prod_name+'" style="width:300px" readonly><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_sb_add_row('+row_count+')" title="<cf_get_lang dictionary_id="29410.Ürün Ekle">"></span><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ="46799.Ürün Detay">" onclick="open_product_detail(add_virman.sb_product_id'+row_count+'.value,add_virman.sb_stock_id'+row_count+'.value)"></span></div></div>';
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

function get_spec_row()
{
	//yeni bastan eklendigi iscin row_count sıfırlanıyor ve satırlar siliniyor
	row_count=0;
	table_clear();
	var get_row=wrk_safe_query('stk_get_row_spec','dsn3',0,document.add_virman.main_spec_id.value);
	for(var rw=0;rw<get_row.recordcount;rw++)
	{
		add_row_spec('txt','table_old_spec',rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
		add_row_spec('form','table_new_spec',rw,get_row.STOCK_ID[rw],get_row.PRODUCT_ID[rw],get_row.STOCK_CODE[rw],get_row.PRODUCT_NAME[rw],get_row.AMOUNT[rw],get_row.IS_SEVK[rw],get_row.RELATED_MAIN_SPECT_ID[rw]);
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
function open_spec_page(row_count){
	var _stock_id_ =  $("#sb_stock_id"+row_count).val();
	if(_stock_id_ != undefined && _stock_id_ != "")
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_virman.related_spect_main_id'+row_count+'&is_display=1&is_stock=1&stock_id='+_stock_id_,'list');
}
</script>
