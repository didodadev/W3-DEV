<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
    <cf_papers paper_type="stock_fis">
    <cf_xml_page_edit fuseact="stock.form_add_stock_exchange">
    <cfif isdefined("paper_full") and isdefined("paper_number")>
        <cfset system_paper_no = paper_full>
        <cfset system_paper_no_add = paper_number>
    <cfelse>
        <cfset system_paper_no = "">
        <cfset system_paper_no_add = "">
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_papers paper_type="stock_fis">
    <cf_xml_page_edit fuseact="stock.form_add_stock_exchange">
   <cfif isdefined("paper_full") and isdefined("paper_number")>
        <cfset system_paper_no = paper_full>
        <cfset system_paper_no_add = paper_number>
    <cfelse>
        <cfset system_paper_no = "">
        <cfset system_paper_no_add = "">
    </cfif>
    <cfif not len(attributes.exchange_id)>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
        <cfquery name="GET_STOCK_EXCHANGE_NUMBER" datasource="#DSN2#">
            SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE.STOCK_EXCHANGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.exchange_id#">
        </cfquery>
        <cfquery name="GET_STOCK_EXCHANGE" datasource="#DSN2#">
            SELECT
                STOCK_EXCHANGE.STOCK_EXCHANGE_ID,
                STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE,
                STOCK_EXCHANGE.EXCHANGE_NUMBER,
                STOCK_EXCHANGE.PROCESS_CAT,
                STOCK_EXCHANGE.PROCESS_TYPE,
                STOCK_EXCHANGE.PROCESS_DATE,
                STOCK_EXCHANGE.RECORD_EMP,
                STOCK_EXCHANGE.RECORD_DATE,
                STOCK_EXCHANGE.UPDATE_EMP,
                STOCK_EXCHANGE.UPDATE_DATE,
                STOCK_EXCHANGE.DEPARTMENT_ID,
                STOCK_EXCHANGE.LOCATION_ID,
                STOCK_EXCHANGE.SHELF_NUMBER,
                STOCK_EXCHANGE.STOCK_ID,
                STOCK_EXCHANGE.PRODUCT_ID,
                STOCK_EXCHANGE.LOT_NO,
                S1.STOCK_CODE,
                S1.PRODUCT_NAME,
                STOCK_EXCHANGE.SPECT_MAIN_ID,
                STOCK_EXCHANGE.AMOUNT,
                STOCK_EXCHANGE.SPECT_MAIN_ID,
                STOCK_EXCHANGE.UNIT,
                STOCK_EXCHANGE.UNIT_ID,
                STOCK_EXCHANGE.UNIT2,
                STOCK_EXCHANGE.DETAIL,
                STOCK_EXCHANGE.EXIT_DEPARTMENT_ID,
                STOCK_EXCHANGE.EXIT_LOCATION_ID,
                STOCK_EXCHANGE.EXIT_SHELF_NUMBER,
                STOCK_EXCHANGE.EXIT_STOCK_ID,
                STOCK_EXCHANGE.EXIT_PRODUCT_ID,
                S2.STOCK_CODE EXIT_STOCK_CODE,
                S2.PRODUCT_NAME EXIT_PRODUCT_NAME,
                STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,
                STOCK_EXCHANGE.EXIT_AMOUNT,
                STOCK_EXCHANGE.EXIT_UNIT,
                STOCK_EXCHANGE.EXIT_UNIT_ID,
                STOCK_EXCHANGE.EXIT_UNIT2,
                STOCK_EXCHANGE.UPD_STATUS,
                STOCK_EXCHANGE.SPECT_ID,
                STOCK_EXCHANGE.EXIT_SPECT_ID,
                STOCK_EXCHANGE.EXIT_LOT_NO,
                STOCK_EXCHANGE.WRK_ROW_ID
            FROM
                STOCK_EXCHANGE,
                #dsn3_alias#.STOCKS S1,
                #dsn3_alias#.STOCKS S2
            WHERE
                STOCK_EXCHANGE.EXCHANGE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_STOCK_EXCHANGE_NUMBER.EXCHANGE_NUMBER#"> AND
                S1.STOCK_ID = STOCK_EXCHANGE.STOCK_ID AND
                S2.STOCK_ID = STOCK_EXCHANGE.EXIT_STOCK_ID 
        </cfquery>
        <cfif not GET_STOCK_EXCHANGE.recordcount>
            <cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../../dsp_hata.cfm">
        <cfelse>
            <cfquery name="get_max_exchange_number" dbtype="query">
                SELECT
                    MAX(STOCK_EXCHANGE_ID) STOCK_EXCHANGE_ID
                FROM 
                    GET_STOCK_EXCHANGE
            </cfquery>
            <cfquery name="get_upd_status" dbtype="query">
                SELECT
                    UPD_STATUS 
                FROM 
                    GET_STOCK_EXCHANGE
                WHERE 
                    STOCK_EXCHANGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_exchange_number.STOCK_EXCHANGE_ID#">
            </cfquery>
            <cfquery name="get_acc_id" datasource="#dsn2#">
                SELECT ACTION_ID FROM ACCOUNT_CARD WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_STOCK_EXCHANGE_NUMBER.EXCHANGE_NUMBER#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK_EXCHANGE.PROCESS_TYPE#">
            </cfquery>
            <cfquery name="get_acc_id_save" datasource="#dsn2#">
                SELECT ACTION_ID FROM ACCOUNT_CARD_SAVE WHERE PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_STOCK_EXCHANGE_NUMBER.EXCHANGE_NUMBER#"> AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK_EXCHANGE.PROCESS_TYPE#">
            </cfquery>
            
            <cfif get_acc_id.recordcount><cfset acc_id_ = get_acc_id.ACTION_ID><cfelseif get_acc_id_save.recordcount><cfset acc_id_ = get_acc_id_save.action_id><cfelse><cfset acc_id_ = -1></cfif>
            <cfset exchange_list=valuelist(GET_STOCK_EXCHANGE.STOCK_EXCHANGE_ID,',')>
            <cfset exchange_spec_list=listsort(valuelist(GET_STOCK_EXCHANGE.SPECT_MAIN_ID,','),'numeric','ASC')>
            <cfset exchange_spec_list=listsort(listappend(exchange_spec_list,valuelist(GET_STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID,',')),'numeric','ASC')>
            <cfset exit_shelf_list_=listsort(valuelist(GET_STOCK_EXCHANGE.EXIT_SHELF_NUMBER,','),'numeric','ASC')>
            <cfset shelf_list_=listsort(valuelist(GET_STOCK_EXCHANGE.SHELF_NUMBER,','),'numeric','ASC')>
            <cfset shelf_list_=listdeleteduplicates(listappend(shelf_list_,exit_shelf_list_,','))>
            
            <cfif listlen(exchange_spec_list,',')>
                <cfquery name="GET_SPEC_NAME_ALL" datasource="#dsn3#">
                    SELECT 
                        SPECT_MAIN_ID,
                        SPECT_MAIN_NAME 
                    FROM 
                        SPECT_MAIN 
                    WHERE 
                        SPECT_MAIN_ID IN (#exchange_spec_list#)
                </cfquery>
            </cfif>
            <cfif listlen(shelf_list_)>
                <cfquery name="GET_ALL_SHELF_CODE" datasource="#dsn3#">
                    SELECT 
                        SHELF_CODE,
                        PRODUCT_PLACE_ID 
                    FROM 
                        PRODUCT_PLACE 
                    WHERE 
                        PRODUCT_PLACE_ID IN (#shelf_list_#)
                    ORDER BY
                        PRODUCT_PLACE_ID
                </cfquery>
                <cfset shelf_list_=listsort(valuelist(GET_ALL_SHELF_CODE.PRODUCT_PLACE_ID),'numeric','asc')>
            </cfif>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		 <cfif not isdefined("attributes.event") or attributes.event is 'add'>
			 row_count=0;
			 silinen_satir_toplam = 0;
		 <cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			 row_count=<cfoutput>#GET_STOCK_EXCHANGE.RECORDCOUNT#</cfoutput>;
			 silinen_satir_toplam = 0;
		 </cfif>
		});
		
	function repeat_control(row,type)
	{
		if(type == 0)
		{
			if(document.getElementById('old_exit_stock_id'+row) != null)
			{
				process_id = document.getElementById('stock_exchange_id'+row).value;
				old_stock_id = document.getElementById('old_exit_stock_id'+row).value ;
				stock_id = document.getElementById('exit_stock_id'+row).value ;
				if(old_stock_id.length != 0 && stock_id.length != 0 && old_stock_id != stock_id )
				{
					str_query = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE PROCESS_CAT = 116 AND PROCESS_ID = " + process_id + "AND STOCK_ID = " + old_stock_id;
					rec = wrk_query(str_query,'dsn3');
					if(rec.recordcount > 0)
					return 0;
					else return 1;
				}
				else
				return 1;
			}
			else return 1;
		}
		else
		{
			if( document.getElementById('old_stock_id'+row) != null)
			{
				process_id = document.getElementById('stock_exchange_id'+row).value;
				old_stock_id = document.getElementById('old_stock_id'+row).value ;
				stock_id = document.getElementById('stock_id'+row).value ;
				if(old_stock_id.length != 0 && stock_id.length != 0 && old_stock_id != stock_id)
				{
					str_query = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE PROCESS_CAT = 116 AND PROCESS_ID = " + process_id + "AND STOCK_ID = " + old_stock_id;
					rec = wrk_query(str_query,'dsn3');
					if(rec.recordcount > 0)
					return 0;
					else return 1;
				}
				else
				return 1;
			}
			else return 1;			
		}
	}	
	
	<cfif not isdefined("attributes.event") or attributes.event is 'add'>
		function add_seri_no(row_no)
		{
			if(document.getElementById('stock_id'+row_no).value.length!=0)
			{
				amount = filterNum(document.getElementById('amount'+row_no).value);
				product_id = document.getElementById('product_id'+row_no).value;
				stock_id = document.getElementById('stock_id'+row_no).value;
				//wrk_row_id = document.all.wrk_row_id[row_no-1].value;
				process_date = document.getElementById('process_date').value;
				process_id = 0;
				process_cat = 116;
				if(document.getElementById('location_id').value == '')
				{
					alert('Giriş Depo Seçmelisiniz!');
					return false;
				}
				else{
				var location_id_ = document.getElementById('location_id').value;
				var department_id_ = document.getElementById('department_id').value;}
				var	paper_number_ = document.getElementById('exchange_no_').value;
				var	wrk_row_id = document.getElementById('wrk_row_id'+row_no).value;
				<cfoutput>
				windowopen('#request.self#?fuseaction=objects.popup_upd_stock_serialno&wrk_row_id='+wrk_row_id+'&process_id='+process_id+'&is_line=1&process_number='+paper_number_+'&product_amount='+amount+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date+'&process_cat='+process_cat+'&sale_product=0&company_id=&con_id=&location_out=&department_out=&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id=','list');
				</cfoutput>
			}
			else{
				alert('<cf_get_lang_main no="313.Önce Ürün Seçiniz">!');
				return false;	
			}
		}
		function open_serial_no(row,type)
			{
				if(document.getElementById('exit_stock_id'+row) != null && document.getElementById('exit_stock_id'+row).value.length!=0){
					if(document.getElementById('stock_exchange_id'+row) != null)
						var process_id = document.getElementById('stock_exchange_id'+row).value;
					else
						var process_id = 0;
					if(document.getElementById('exit_wrk_row_id'+row)!=null)
						wrk_row_id = document.getElementById('exit_wrk_row_id'+row).value;
					else 
						wrk_row_id = 0;
					product_id = document.getElementById('exit_product_id'+row).value;
					stock_id = document.getElementById('exit_stock_id'+row).value;
					spec_main_id = document.getElementById('exit_spec_main_id'+row).value;
					amount = document.getElementById('exit_amount'+row).value;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no='+document.getElementById('exchange_no_').value+'&process_cat_id=116&process_id='+process_id+'&wrk_row_id='+wrk_row_id+'&stock_id='+stock_id +'&product_id='+product_id+'&amount='+filterNum(amount)+'&spect_id='+spec_main_id,'list');
				}
				else{
					alert('<cf_get_lang_main no="313.Önce Ürün Seçiniz">!');
					return false;	
				}
			}
		
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function add_seri_no(row_no)
		{
			if(document.getElementById('stock_id'+row_no).value.length!=0)
			{
				<cfoutput>
					my_control = repeat_control(row_no,1);
					amount = filterNum(document.getElementById('amount'+row_no).value);
					product_id = document.getElementById('product_id'+row_no).value;
					stock_id = document.getElementById('stock_id'+row_no).value;
					if(document.getElementById('wrk_row_id'+row_no)!=null)
						wrk_row_id = document.getElementById('wrk_row_id'+row_no).value;
					else 
						wrk_row_id = 0;
					process_date = document.getElementById('process_date').value;
					if(document.getElementById('stock_exchange_id'+row_no)!= null)
						var process_id = document.getElementById('stock_exchange_id'+row_no).value;
					else
						var process_id = 0;
					if(document.getElementById('spec_main_id'+row_no).value != '')
						spec_id = document.getElementById('spec_id'+row_no).value
					else
						spec_id = '';
					process_cat = 116;
					if(document.getElementById('location_id').value == '')
					{
						alert('Giriş Depo Seçmelisiniz!');
						return false;
					}
					else{
					var location_id_ = document.getElementById('location_id').value
					var department_id_ = document.getElementById('department_id').value
					var	paper_number_ = document.getElementById('exchange_no').value
					}
					if(my_control == 1)
					{
						windowopen('#request.self#?fuseaction=objects.popup_upd_stock_serialno&is_in_out=1&wrk_row_id='+wrk_row_id+'&process_id='+process_id+'&is_line=1&process_number='+paper_number_+'&product_amount='+amount+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date+'&process_cat='+process_cat+'&sale_product=0&company_id=&con_id=&location_out=&department_out=&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id='+spec_id,'list');
					}
					else
					{
						old_stock_id = document.getElementById('old_stock_id'+row_no).value;
						answer = confirm('<cf_get_lang no="8.Ürünü Değiştirdiğinizde Girilen Seriler Silinecektir Seriler Silinsin mi">');
						if(answer == true)
							{
								params  = process_id + '*' + old_stock_id;
								document.getElementById('del_serials').value = document.getElementById('del_serials').value + ',' + params;
								windowopen('#request.self#?fuseaction=objects.popup_upd_stock_serialno&is_in_out=1&wrk_row_id='+wrk_row_id+'&process_id='+process_id+'&is_line=1&process_number='+paper_number_+'&product_amount='+amount+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date+'&process_cat='+process_cat+'&sale_product=0&company_id=&con_id=&location_out=&department_out=&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id='+spec_id,'list');
							}
					}
					
				</cfoutput>
			}
			else{
				alert('<cf_get_lang_main no="313.Önce Ürün Seçiniz">!');
				return false;	
			}
			
		}
		function open_serial_no(row,type)
		{
			if(document.getElementById('exit_stock_id'+row) != null && document.getElementById('exit_stock_id'+row).value.length!=0){
				my_control = repeat_control(row,0);
				if(document.getElementById('stock_exchange_id'+row)!= null)
					var process_id = document.getElementById('stock_exchange_id'+row).value;
				else
					var process_id = 0;
				if(document.getElementById('exit_wrk_row_id'+row)!=null)
					wrk_row_id = document.getElementById('exit_wrk_row_id'+row).value;
				else 
					wrk_row_id = 0;
				stock_id = document.getElementById('exit_stock_id'+row).value;
				if(document.getElementById('exit_spec_main_id'+row).value != '')
					spect_id_ = document.getElementById('exit_spec_id'+row).value
				else
					spect_id_ = '';
	
				if(my_control == 1)
				{
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no='+document.getElementById('exchange_no').value+'&process_cat_id=116&process_id='+process_id+'&wrk_row_id='+wrk_row_id+'&stock_id='+stock_id+'&product_id='+document.getElementById('exit_product_id'+row).value+'&amount='+filterNum(document.getElementById('exit_amount'+row).value)+'&spect_id='+spect_id_,'list');
				}
				else
				{
					old_stock_id = document.getElementById('old_exit_stock_id'+row).value;
					answer = confirm('Ürünü Değiştirdiğinizde Girilen Seriler Silinecektir. Seriler Silinsin mi?');
					if(answer == true)
						{
							params  = process_id + '*' + old_stock_id;
							document.getElementById('del_serials').value = document.getElementById('del_serials').value + ',' + params;
							//my_q = wrk_safe_query('del_old_serials','dsn3',1,params);
							windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no='+document.getElementById('exchange_no').value+'&process_cat_id=116&process_id='+process_id+'&wrk_row_id='+wrk_row_id+'&stock_id='+stock_id+'&product_id='+document.getElementById('exit_product_id'+row).value+'&amount='+filterNum(document.getElementById('exit_amount'+row).value)+'&spect_id='+document.getElementById('exit_spec_id'+row).value+'&is_change=1','list');
						}
				}
			}
			else{
				alert('<cf_get_lang_main no="313.Önce Ürün Seçiniz">!');
				return false;	
			}
		}
		
	</cfif>
	function table_clear()
	{
		if(row_count==0)
		{
			var oTable=document.getElementById("table_old_stock");
			while(oTable.rows.length>1)
				oTable.deleteRow(oTable.rows.length-1);
		}
	}
	
	function delete_row(sy)
	{
		document.getElementById('row_kontrol'+sy).value;
		document.getElementById('stock_row'+sy).style.display="none";
		silinen_satir_toplam++;
	}
	
	function add_row()
	{
		table_clear();
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_old_stock").insertRow(document.getElementById("table_old_stock").rows.length);
		newRow.setAttribute("className", "color-row");
		newRow.setAttribute("name","stock_row" + row_count);
		newRow.setAttribute("id","stock_row" + row_count);		
		newRow.setAttribute("NAME","stock_row" + row_count);
		newRow.setAttribute("ID","stock_row" + row_count);
		newRow.setAttribute("height","30");
		document.getElementById('stock_record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a href="javascript://" onClick="delete_row('+row_count+')"><i class="icon-trash-o" alt="Ürün Sil"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="exit_stock_code'+row_count+'" id="exit_stock_code'+row_count+'" value="" style="width:100px" readonly><input type="hidden" id="exit_product_id'+row_count+'" name="exit_product_id'+row_count+'" value=""><input type="hidden" id="exit_stock_id'+row_count+'" name="exit_stock_id'+row_count+'" value=""><input type="hidden" id="exit_spec_id'+row_count+'" name="exit_spec_id'+row_count+'" value="">';
		pid_e = document.getElementById('exit_product_id'+row_count).value;
		sid_e = document.getElementById('exit_stock_id'+row_count).value;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="exit_product_name'+row_count+'" id="exit_product_name'+row_count+'" value="" style="width:100px"><a href="javascript://" onclick="open_add_product('+row_count+',1)"> <i class="icon-ellipsis"  alt="Ürün Ekle" align="absmiddle"></i></a><a href="javascript://" onclick="open_product_detail('+row_count+',1)"> <i class="icon-ellipsis-p"  alt="Ürün Detay" align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="exit_spec_main_id'+row_count+'" id="exit_spec_main_id'+row_count+'" value=""><input type="text" name="exit_spec_main_name'+row_count+'"  id="exit_spec_main_name'+row_count+'" value="" style="width:100px" readonly><a href="javascript://" onClick="open_spec('+row_count+',1)"> <i class="icon-ellipsis"  align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<a href="javascript://" onClick="open_serial_no('+row_count+',1)"><img src="/images/barcode_add.gif" border="0" title="<cf_get_lang_main no="305.Garanti">-<cf_get_lang_main no="306.Seri Nolar"> Ekle"></a>';
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="exit_shelf_id'+row_count+'" id="exit_shelf_id'+row_count+'" value=""><input type="text" name="exit_shelf_code'+row_count+'"  id="exit_shelf_code'+row_count+'"value="" style="width:100px"><a href="javascript://" onClick="open_shelf(row_count,1);"> <i class="icon-ellipsis"  align="absmiddle"></i></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="exit_amount'+row_count+'" id="exit_amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" style="width:50px" align="right" onKeyUp="return FormatCurrency(this,event,3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="exit_unit_id'+row_count+'" id="exit_unit_id'+row_count+'" value=""><input type="text" name="exit_unit'+row_count+'" value="" style="width:75px" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="exit_unit2_'+row_count+'" id="exit_unit2_'+row_count+'" value="" style="width:75px"><input type="hidden" id="exit_wrk_row_id'+row_count+'"  name="exit_wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'">';
		<cfif isdefined('is_lot_no') and is_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="exit_lot_no'+row_count+'" id="exit_lot_no'+row_count+'" value="" onKeyup="lotno_control('+row_count+',1);" style="width:74px;"> <i class="icon-ellipsis"  onClick="pencere_ac_list_product('+document.getElementById('exit_product_id'+row_count).value+','+document.getElementById('exit_stock_id'+row_count).value,row_count+');" align="absbottom"></i>';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("className", "color-list");
		newCell.innerHTML = '';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="stock_code'+row_count+'" id="stock_code'+row_count+'" value="" style="width:100px" readonly><input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value=""><input type="hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value=""><input type="hidden" name="spec_id'+row_count+'" id="spec_id'+row_count+'" value="">';
		newCell = newRow.insertCell(newRow.cells.length);
		pid = document.getElementById('product_id'+row_count).value;
		sid = document.getElementById('stock_id'+row_count).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="product_name'+row_count+'" id="product_name'+row_count+'" value="" style="width:100px"><a href="javascript://" onclick="open_add_product('+row_count+',2)"> <i class="icon-ellipsis"  alt="Ürün Ekle" align="absmiddle"></i></a><a href="javascript://" onclick="open_product_detail('+row_count+',2)"> <i class="icon-ellipsis-p"  alt="Ürün Detay" align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="spec_main_id'+row_count+'" id="spec_main_id'+row_count+'" value=""><input type="text" name="spec_main_name'+row_count+'" id="spec_main_name'+row_count+'" value="" style="width:100px" readonly><a href="javascript://" onClick="open_spec('+row_count+',0);"> <i class="icon-ellipsis"  align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<a href="javascript://" onclick="add_seri_no('+row_count+')"><img src="/images/serialno.gif" title="<cf_get_lang_main no="305.Garant">-<cf_get_lang_main no="306.Seri Nolar">"></a>';
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="hidden" name="shelf_id'+row_count+'" id="shelf_id'+row_count+'" value=""><input type="text" name="shelf_code'+row_count+'" id="shelf_code'+row_count+'" value="" style="width:100px"><a href="javascript://" onClick="open_shelf(row_count,0);"> <i class="icon-ellipsis"  align="absmiddle"></i></a>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="amount'+row_count+'" id="amount'+row_count+'" value="'+commaSplit(1,3)+'" class="moneybox" style="width:75px" align="right" onkeyup="return(FormatCurrency(this,event,3));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="unit_id'+row_count+'" id="unit_id'+row_count+'" value=""><input type="text" name="unit'+row_count+'" id="unit'+row_count+'" value="" style="width:75px" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="unit2_'+row_count+'" id="unit2_'+row_count+'" value="" style="width:75px"><input type="hidden" id="wrk_row_id'+row_count+'"  name="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'">';
		<cfif isdefined('is_lot_no') and is_lot_no eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="lot_no'+row_count+'" id="lot_no'+row_count+'" value="" onKeyup="lotno_control('+row_count+',2);" style="width:74px;">';
		</cfif>
		return true;
	}
	
	function open_spec(row,type)
	{
		if(type == 1){
			pro_id = document.getElementById('exit_product_id'+row).value;
			s_id = document.getElementById('exit_stock_id'+row).value;
		}
		else{
			pro_id = document.getElementById('product_id'+row).value;
			s_id = document.getElementById('stock_id'+row).value;
		}
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!=''){
			if(type == 1)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=stockVirman.exit_spec_main_id'+row+'&field_name=stockVirman.exit_spec_main_name'+row+'&is_display=1&stock_id='+s_id,'list');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=stockVirman.spec_main_id'+row+'&field_name=stockVirman.spec_main_name'+row+'&is_display=1&stock_id='+s_id,'list');
		}
		else
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], _, `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 1)
			lot_no = document.getElementById('exit_lot_no'+crntrow);
		else if(type == 2)
			lot_no = document.getElementById('lot_no'+crntrow);
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	function open_shelf(row_no,is_exit_part)
	{	
		kontrol_info = 0;
		if(is_exit_part==1)
		{
			if(document.getElementById('exit_product_id'+row_no).value != '')
			{
				kontrol_info = 1;
				var name_field='exit_shelf_code';
				var code_field='exit_shelf_id';
				var shelf_department_id=document.getElementById('exit_department_id').value;
				var shelf_location_id=document.getElementById('exit_location_id').value;
				<cfif is_show_all_shelf eq 0>
					var shelf_prod_id=document.getElementById('exit_product_id'+row_no).value;
				<cfelse>
					var shelf_prod_id='';	
				</cfif>
			}
			else
				alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		}
		else
		{
			if(document.getElementById('product_id'+row_no).value != '')
			{
				kontrol_info = 1;
				var name_field='shelf_code';
				var code_field='shelf_id';
				var shelf_department_id=document.getElementById('department_id').value;
				var shelf_location_id=document.getElementById('location_id').value;
				<cfif is_show_all_shelf eq 0>
					var shelf_prod_id=document.getElementById('product_id'+row_no).value;
				<cfelse>
					var shelf_prod_id='';	
				</cfif>
			}
			else
				alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
		}
		if(kontrol_info == 1)
		{		
			if(shelf_department_id!='' && shelf_location_id!= '')
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_shelves&is_array_type=0&form_name=stockVirman&field_code='+name_field+'&field_id='+code_field+'&department_id='+shelf_department_id+'&location_id='+shelf_location_id+'&row_id='+row_no+'&shelf_product_id='+shelf_prod_id,'small','form_add_stock_exchange');
			else
			{	
				if(is_exit_part==1)
					alert('Önce Çıkış Depo Seçiniz!');
				else
					alert('Önce Giriş Depo Seçiniz!');
				return false;
			}
		}
	}
	function open_product_detail(row,type)
	{
		if(type == 1){
			pro_id = document.getElementById('exit_product_id'+row).value;
			s_id = document.getElementById('exit_stock_id'+row).value;
		}
		else{
			pro_id = document.getElementById('product_id'+row).value;
			s_id = document.getElementById('stock_id'+row).value;
		}
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!='')
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
		else
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
	}
	
	function open_add_product(sy,type)
	{
		if(type==1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=empty_spect&run_function_param1='+sy+'&run_function_param=1&field_id=stockVirman.exit_stock_id'+sy+'&field_name=stockVirman.exit_product_name'+sy+'&product_id=stockVirman.exit_product_id'+sy+'&field_code=stockVirman.exit_stock_code'+sy+'&field_unit_name=stockVirman.exit_unit'+sy+'&is_form_submitted=1&field_unit=stockVirman.exit_unit_id'+sy,'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&run_function=empty_spect&run_function_param1='+sy+'&run_function_param=2&field_id=stockVirman.stock_id'+sy+'&field_name=stockVirman.product_name'+sy+'&product_id=stockVirman.product_id'+sy+'&field_code=stockVirman.stock_code'+sy+'&field_unit_name=stockVirman.unit'+sy+'&is_form_submitted=1&field_unit=stockVirman.unit_id'+sy,'list');
	}
	
	function pencere_ac_list_product(pro_id,s_id,no)//satira lot_no ekliyor
	{
		if(pro_id!= undefined && pro_id!='' && s_id!= undefined && s_id!='')
		{
			form_stock_code = document.getElementById("exit_stock_code"+no).value;
			lot_no = document.getElementById("exit_lot_no"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no='+lot_no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
	}
	
	function empty_spect(row_no,type)
	{
		if(type == 1)
		{
			document.getElementById('exit_spec_main_id'+row_no).value = '';
			document.getElementById('exit_spec_main_name'+row_no).value = '';
		}
		else
		{
			document.getElementById('spec_main_id'+row_no).value = '';
			document.getElementById('spec_main_name'+row_no).value = '';
		}
	}
	function control()
	{
		if(document.getElementById('department_name').value=="" || document.getElementById('location_id').value=="")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		if(document.getElementById('exit_department_name').value=="" || document.getElementById('exit_location_id').value=="")
		{
			alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
			return false;
		}
	
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
			var exit_shelf_list_js_='';
			var shelf_list_js_='';
		</cfif>
		for(var i=1;i <= row_count;i++)
		{
			if(document.getElementById('row_kontrol'+i).value == 1 && (document.getElementById('exit_stock_code'+i).value == '' || document.getElementById('stock_code'+i).value == '' || document.getElementById('product_name'+i).value == '' || document.getElementById('exit_product_name'+i).value == ''))
			{
				alert(i+".<cf_get_lang no ='458.Satırda Ürünleri Seçiniz'>!");
				return false;
			}
			<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
				<cfif isdefined('is_lot_no') and is_lot_no eq 1>
					if(check_lotno('stockVirman'))//işlem kategorisinde lot no zorunlu olsun seçili ise
					{
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("exit_stock_id"+i).value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.getElementById("exit_lot_no"+i).value == '')
							{
								alert(i+'. satırdaki '+ document.getElementById("exit_product_name"+i).value + ' ürünü için lot no takibi yapılmaktadır!');
								return false;
							}
						}
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id"+i).value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.getElementById("lot_no"+i).value == '')
							{
								alert(i+'. satırdaki '+ document.getElementById("product_name"+i).value + ' ürünü için lot no takibi yapılmaktadır!');
								return false;
							}
						}
					}
				</cfif>
			</cfif>
			<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
				if(document.getElementById('row_kontrol'+i).value == 1 && document.getElementById('exit_shelf_id'+i).value != '' && document.getElementById('exit_shelf_code'+i).value != '' )
				{
					if(list_len(exit_shelf_list_js_)==0)
						exit_shelf_list_js_=document.getElementById('exit_shelf_id'+i).value;
					else
						exit_shelf_list_js_= exit_shelf_list_js_+','+document.getElementById('exit_shelf_id'+i).value;
				}
				if(document.getElementById('row_kontrol'+i).value == 1 && document.getElementById('shelf_id'+i).value != '' && document.getElementById('shelf_code'+i).value != '' )
				{
					if(list_len(exit_shelf_list_js_)==0)
						shelf_list_js_=document.getElementById('shelf_id'+i).value;
					else
						shelf_list_js_= shelf_list_js_+','+document.getElementById('shelf_id'+i).value;
				}
			</cfif>
		}
		<cfif isdefined('is_show_shelf_info') and is_show_shelf_info eq 1><!--- raf bilgisi seçilmişse satır raf bilgileriyle depolar karsılastırılıyor --->
			if(exit_shelf_list_js_!='')
			{
				var listParam = exit_shelf_list_js_ + "*" + document.getElementById('exit_department_id').value + "*" + document.getElementById('exit_location_id').value;
				var get_exit_shelf_sql = wrk_safe_query("stk_get_exit_shelf_sql",'dsn3',0,listParam);
				if(get_exit_shelf_sql.recordcount)
				{
					alert_exit_shelf_str = 'Çıkış Depoya Bağlı Olmayan Raflar:\n';
					for(var cnt_ii=0;cnt_ii<get_exit_shelf_sql.recordcount;cnt_ii=cnt_ii+1)
						alert_exit_shelf_str = alert_exit_shelf_str +' '+get_exit_shelf_sql.SHELF_CODE[cnt_ii] + '\n';
					alert(alert_exit_shelf_str +'\n Çıkan Stoklar Bölümünde Çıkış Deponun Rafları Seçilebilir!');
					return false;
				}
			}
			if(shelf_list_js_!='')
			{
	
				var listParam = shelf_list_js_ + "*" + document.getElementById('department_id').value + "*" + document.getElementById('location_id').value;
				var get_shelf_sql = wrk_safe_query("stk_get_exit_shelf_sql",'dsn3',0,listParam);
				if(get_shelf_sql.recordcount)
				{
					alert_shelf_str = 'Çıkış Depoya Bağlı Olmayan Raflar:\n';
					for(var shlf_ii=0;shlf_ii<get_shelf_sql.recordcount;shlf_ii=shlf_ii+1)
						alert_shelf_str = alert_shelf_str +' '+get_shelf_sql.SHELF_CODE[shlf_ii] + '\n';
					alert(alert_shelf_str +'\n Stok Giriş Bölümünde Giriş Deposunun Rafları Seçilebilir!');
					return false;
				}
			}
		</cfif>
		if(!chk_period(document.getElementById('process_date'))) return false;
		if (!chk_process_cat('stockVirman')) return false;
		if(!check_display_files('stockVirman')) return false;
		if(silinen_satir_toplam== row_count){
		alert('Satır Ekleyiniz!');return false;
		}
		if (!zero_stock_control('stockVirman')) return false;
		pre_submit_clear();		
		return true;
	}
	
	function pre_submit_clear(){
		
		for(var i=1;i <= row_count;i++)
		{
			document.getElementById('exit_amount'+i).value = filterNum(document.getElementById('exit_amount'+i).value,3);
			document.getElementById('amount'+i).value = filterNum(document.getElementById('amount'+i).value,3);
		}
		return true;
	}
	
	
	function zero_stock_control()
	{
		var stock_id_list='0';
		var stock_amount_list='0';
		var main_spec_id_list='0';
		var main_spec_amount_list='0';
		var hata='';
		var lotno_hata='';
		var get_process = wrk_safe_query('stk_get_process','dsn3',0,document.getElementById('process_cat').value);
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			<cfif isdefined('is_lot_no') and is_lot_no eq 1>
				try{
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('stockVirman') != undefined && check_lotno('stockVirman'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							for(i=1;i<=row_count;i++)
							{
								if(document.getElementById('exit_spec_main_id'+i).value != '')
									varName = "lot_no_" + document.getElementById('exit_stock_id'+i).value + document.getElementById('exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_') + document.getElementById('exit_spec_main_id'+i).value;
								else
									varName = "lot_no_" + document.getElementById('exit_stock_id'+i).value + document.getElementById('exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_');								
								this[varName] = 0;
							}
							for(i=1;i<=row_count;i++)
							{
								if(document.getElementById('row_kontrol'+i).value==1)
								{	
									if(document.getElementById('exit_spec_main_id'+i).value != '')
									{
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById('exit_stock_id'+i).value);
										if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
										{
											var spec_main_id_ = document.getElementById('exit_spec_main_id'+i).value;
											var stock_id_ = document.getElementById('exit_stock_id'+i).value;
											var lot_no_ = document.getElementById('exit_lot_no'+i).value;
											var loc_id = document.getElementById('exit_location_id').value;
											var dep_id = document.getElementById('exit_department_id').value;
											var paper_date_kontrol = js_date(date_add('d',1,document.getElementById('process_date').value));
											varName = "lot_no_" + document.getElementById('exit_stock_id'+i).value + document.getElementById('exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_') + document.getElementById('exit_spec_main_id'+i).value;
											var xxx = String(this[varName]);
											var yyy = document.getElementById('exit_amount'+i).value;
											this[varName] = parseFloat( filterNum(xxx,3) ) + parseFloat( filterNum(yyy,3) );
											<cfif xml_zero_stock_date eq 1>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&spec_main_id='+ spec_main_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											<cfelse>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_7&lot_no='+ encodeURIComponent(lot_no_) +'&spec_main_id='+ spec_main_id_ +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											</cfif>
											$.ajax({
													url: url_,
													dataType: "text",
													cache:false,
													async: false,
													success: function(read_data) {
													data_ = jQuery.parseJSON(read_data);
													if(data_.DATA.length != 0)
													{
														$.each(data_.DATA,function(i){
															var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
															var PRODUCT_NAME = data_.DATA[i][1];
															var STOCK_CODE = data_.DATA[i][2];
															var SPECT_MAIN_ID  = data_.DATA[i][3];
															if(eval(varName) > PRODUCT_TOTAL_STOCK)
															{
																if(SPECT_MAIN_ID > 0)
																	lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+') (Main Spec Id:'+SPECT_MAIN_ID+')\n';
																else
																	lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
															}
														});
													}
													else
													{
														lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
													}
												}
											});
										}
									}
									else if(document.getElementById('exit_stock_id'+i).value != '' )
									{
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById('exit_stock_id'+i).value);
										if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
										{
											var stock_id_ = document.getElementById('exit_stock_id'+i).value;
											var lot_no_ =document.getElementById('exit_lot_no'+i).value;
											var loc_id = document.getElementById('exit_location_id').value;
											var dep_id = document.getElementById('exit_department_id').value;
											var paper_date_kontrol = js_date(document.getElementById('process_date').value);
											varName = "lot_no_" + document.getElementById('exit_stock_id'+i).value + document.getElementById('exit_lot_no'+i).value.replace(/-/g, '_').replace(/\./g, '_');
											var xxx = String(this[varName]);
											var yyy = document.getElementById('exit_amount'+i).value;
											this[varName] = parseFloat( filterNum(xxx,3) ) + parseFloat( filterNum(yyy,3) );
											<cfif xml_zero_stock_date eq 1>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											<cfelse>
												url_= '/V16/stock/cfc/get_stock_detail.cfc?method=stk_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
											</cfif>
											$.ajax({
													url: url_,
													dataType: "text",
													cache:false,
													async: false,
													success: function(read_data) {
													data_ = jQuery.parseJSON(read_data);
													if(data_.DATA.length != 0)
													{
														$.each(data_.DATA,function(i){
															var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
															var PRODUCT_NAME = data_.DATA[i][1];
															var STOCK_CODE = data_.DATA[i][2];
															var SPECT_MAIN_ID  = data_.DATA[i][3];
															if(eval(varName) > PRODUCT_TOTAL_STOCK)
															{
																lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
															}
														});
													}
													else
													{
														lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
													}
												}
											});
										}
									}
								}
							}
						}
					</cfif>
				}
				catch(e)
				{}
			</cfif>
			for(var i=1;i <= row_count;i++)
			{
				if(document.getElementById('row_kontrol'+i).value==1)
				{
					if(document.getElementById('exit_spec_main_id'+i).value!='')
					{
						var yer=list_find(main_spec_id_list,document.getElementById('exit_spec_main_id'+i).value,',');
						if(yer){
							top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById('exit_amount'+i).value,3));
							main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
						}else{
							main_spec_id_list=main_spec_id_list+','+document.getElementById('exit_spec_main_id'+i).value;
							main_spec_amount_list=main_spec_amount_list+','+filterNum(document.getElementById('exit_amount'+i).value,3);
						}
					}
					else
					{
						var yer=list_find(stock_id_list,document.getElementById('exit_stock_id'+i).value,',');
						if(yer){
							top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById('exit_amount'+i).value,3));
							stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						}else{
							stock_id_list=stock_id_list+','+document.getElementById('exit_stock_id'+i).value;
							stock_amount_list=stock_amount_list+','+filterNum(document.getElementById('exit_amount'+i).value,3);
						}
					}
				}	
			}
			if(list_len(stock_id_list,',')>1)
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + document.getElementById('exit_location_id').value + "*" + document.getElementById('exit_department_id').value + "*" + js_date(document.getElementById('process_date').value);
				<cfif xml_zero_stock_date eq 1>
				var new_sql = "stk_get_total_stock_4";
				<cfelse>
				var new_sql = "stk_get_total_stock_5";
				</cfif>
				var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
				if(get_total_stock.recordcount)
				{
					var query_stock_id_list='0';
					for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
					{
						query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
						var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					}
				}
				var diff_stock_id='0';
				for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
				{
					var stk_id=list_getat(stock_id_list,lst_cnt,',')
					if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
						diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				}
				if(list_len(diff_stock_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					var get_stock = wrk_safe_query('stk_get_stock','dsn3',0,diff_stock_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
				}
				get_total_stock='';
			}
			if(list_len(main_spec_id_list,',')>1){
	
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + document.getElementById('exit_location_id').value + "*" + document.getElementById('exit_department_id').value + "*" + js_date(document.getElementById('process_date').value);
				<cfif xml_zero_stock_date eq 1>
				var new_sql = "stk_get_total_stock_6";
				<cfelse>
				var new_sql = "stk_get_total_stock_7";		
				</cfif>	
				var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
				if(get_total_stock.recordcount)
				{
					var query_spec_id_list='0';
					for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
					{
						query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];
						var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					}
				}
				var diff_spec_id='0';
				for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
				{
					var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
					if(query_spec_id_list==undefined || query_spec_id_list=='0' || list_find(query_spec_id_list,spc_id,',') == '0')
						diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
				}
				if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					var get_stock = wrk_safe_query('stk_get_stock_2','dsn3',0,diff_spec_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+') (main spec id:'+get_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
		}
		if(lotno_hata != '')
		{
				alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
			lotno_hata='';
			return false;
		
		}
		if(hata!='')
		{
			alert(hata+"\n\n<cf_get_lang no ='459.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo lokasyonundaki miktarları kontrol ediniz'> !");
			return false;
		}
		else
			return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_stock_exchange';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_add_stock_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_stock_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_stock_exchange&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('detail_stock_exchange','detail_stock_exchange_bask')";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_add_stock_exchange&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_stock_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_stock_exchange.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_stock_exchange&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'exchange_id=##attributes.station_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.exchange_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('stock_exchange','cf_basket_form_bask')";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.emptypopup_del_stock_exchange&exchange_id=#attributes.exchange_id#&process_type=#GET_STOCK_EXCHANGE.PROCESS_CAT#&is_stock=1&acc_id=#acc_id_#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/del_stock_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/del_stock_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'old_process_type';
	}
	
	if(attributes.event is 'upd')       
	{

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if( get_module_user(22) and listfind("116",GET_STOCK_EXCHANGE.PROCESS_TYPE)){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[2402]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#acc_id_#&process_cat='+document.getElementById('old_process_type').value,'page','form_upd_fis')";
		}
		if( session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#GET_STOCK_EXCHANGE.EXCHANGE_NUMBER#&process_cat_id=#GET_STOCK_EXCHANGE.PROCESS_TYPE#&process_id=#attributes.exchange_id#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['target'] = "blank_";
		}
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_stock_exchange&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.exchange_id#&print_type=31','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockExchange';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_EXCHANGE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	if(attributes.event is 'add'){
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-exchange_no_','item-process_cat','item-process_date','item-department_name','item-exit_department_name']";
	}
	else if(attributes.event is 'upd'){
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-exchange_no','item-process_cat','item-process_date','item-department_name','item-exit_department_name']";
	}
</cfscript>
