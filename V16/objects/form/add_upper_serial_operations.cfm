<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="objects">
<cfset kontrol_seri_no = 1>
<cfset stock_id = attributes.stock_id>
<cfinclude template="../query/get_product_name.cfm">
<cfif product_name.recordcount eq 0>
	<script>
		alert("<cf_get_lang dictionary_id='30375.Seçilen Ürün İçin Seri No Takibi Yapılmamaktadır'> !");
		window.close();
	</script>
</cfif>
<cfquery name="GET_ROWS" datasource="#DSN3#">
	SELECT
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.PRODUCT_ID,
		ORDER_ROW.SPEC_MAIN_ID SPECT_ID,
		SUM(ORDER_ROW.AMOUNT) QUANTITY
	FROM
		PRODUCTION_ORDER_RESULTS ORDER_ ,
		PRODUCTION_ORDER_RESULTS_ROW ORDER_ROW,
		STOCKS
	WHERE
		ORDER_.PR_ORDER_ID = #attributes.process_id# AND
		ORDER_.PR_ORDER_ID = ORDER_ROW.PR_ORDER_ID AND
		ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID AND
		STOCKS.IS_SERIAL_NO = 1 AND 
        ORDER_.PRODUCTION_ORDER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.belge_no#"> AND
		ORDER_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	GROUP BY
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.PRODUCT_ID,
		ORDER_ROW.SPEC_MAIN_ID
</cfquery>
<!---<cfquery name="GET_CAT_SARF" datasource="#DSN3#">
    SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 111
</cfquery>
<cfif GET_CAT_SARF.recordcount>
    <cfquery name="GET_FIS_SARF" datasource="#attributes.new_dsn2#">
        SELECT FIS_NUMBER,FIS_ID FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND FIS_TYPE = 111
    </cfquery>
</cfif>
<cfif not GET_FIS_SARF.recordcount>
	<script>
		alert('Stok Fişi Oluşturulmamış!');
	</script>
    <cfabort>
</cfif>--->

<!---<cfif GET_FIS_SARF.recordcount>--->
	<cfset sarf_process_id = attributes.process_id>
    <cfset sarf_process_no = "USC-"&attributes.process_id>
<!---<cfelse>
	<cfset sarf_process_id = "">
    <cfset sarf_process_no = "">
</cfif>--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32706.Hızlı Seri No Girişi'></cfsavecontent>
<cf_box title="#message# : #get_process_name(attributes.process_cat_id)# (#attributes.belge_no#)" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_upper_serial" action="#request.self#?fuseaction=objects.emptypopup_add_serial_action_detail">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-">
					<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='33860.Seri No Ara'></label>
					<div class="col col-4 col-md-4 col-xs-12">
				
					<input type="text" value="" id="search_serial_no" name="search_serial_no" onkeyup="return(search_serial_no_control(event,0));"/>
				</div><div class="col col-2 col-md-2 col-xs-12">
					<a style="cursor:pointer;" class="ui-btn ui-btn-green searchbuton" name="search_serial_no_button" id="search_serial_no_button" onclick="search_serial_no_(0);"/><i class="fa fa-search"></i></a>
					</div>
				</div>
				
			<cfif not isDefined('session.pp.userid')>
				<div class="form-group" id="item-">
					<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='32708.Seri No Ekle'></label>
					<div class="col col-6 col-md-6 col-xs-12">
						<div class="input-group">
						<input type="text" value="" id="add_new_serial_no" name="add_new_serial_no"  onkeyup="return(add_serial_no_control(event,0));">
						<span class="input-group-addon btnPointer icon-pluss" href="javascript://" id="add_new_serial_no_button" onclick="add_serial_no(0);">
						</span>
					</div>
				</div>
				</div>
		
				<div class="form-group" id="item-">
					<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='32711.Seri No Çıkar'></label>
					<div class="col col-6 col-md-6 col-xs-12">
						<div class="input-group">
						<input type="text" value="" id="delete_old_serial_no" name="delete_old_serial_no" onkeyup="return(del_serial_no_control(event,0));"/>
						<span class="input-group-addon btnPointer icon-minus" href="javascript://" id="delete_old_serial_no_button" onclick="del_serial_no(0);">
						</span>
					</div>
				</div>
			</div>
			</cfif>
			</div>
                <cfset variable = '1'>
				<cfset variable2 = '2'>
                <cfset process_type = 1719><!--- Sarf Tipi için 111 yerine bu process cat kullanılacak--->
                <cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
                    SELECT 
                        * 
                    FROM 
                        PRODUCTION_ORDER_RESULTS_ROW 
                    WHERE 
                        PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND 
                        TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> AND
                        STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE IS_SERIAL_NO = 1)
                    ORDER BY 
                        PR_ORDER_ROW_ID
                </cfquery>
                <cfset stock_list = valuelist(get_row_exit.stock_id)>
                <cfset process_id1 = "">
                <cfset process_no1 = "">
                <cfset process_ids = "">
<!---				<cfif GET_FIS_SARF.recordcount>
					<cfset process_id1 = GET_FIS_SARF.FIS_ID>
                    <cfset process_no1 = GET_FIS_SARF.FIS_NUMBER>
                </cfif>
--->                
				<cfset process_id1 = attributes.process_id>
                <cfset process_no1 = "USC-"&attributes.process_id>

				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-">
						<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='40196.Sarf'> <cf_get_lang dictionary_id ='33860.Seri No Ara'></label>
						<div class="col col-4 col-md-4 col-xs-12">
							<input type="text" id="sarf_search_serial_no" name="sarf_search_serial_no" value="" onkeyup="return(search_serial_no_control(event,1));"/>
								</div><div class="col col-2 col-md-2 col-xs-12">
							<a style="cursor:pointer;" name="sarf_search_serial_no_button" id="sarf_search_serial_no_button" class="ui-btn ui-btn-green searchbuton"  onclick="search_sarf_serial_no_(1);"/><i class="fa fa-search"></i></a>
						</div>
					</div>
					<div  id="sarf_div" style="display:none;">
					<div class="form-group" id="item-">
						<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='40196.Sarf'> <cf_get_lang dictionary_id='32708.Seri No Ekle'></label>
						<div class="col col-6 col-md-6 col-xs-12">
							<div class="input-group">
								<input type="text" id="sarf_add_new_serial_no" name="sarf_add_new_serial_no" value="" onkeyup="return(add_serial_no_control(event,1));"//>
								<span class="input-group-addon btnPointer icon-pluss" href="javascript://" id="sarf_add_new_serial_no_button" onclick="add_serial_no(1);">
							</span>
						</div>
						<!--- extra --->
						<div id="speedSeriDiv2"></div>
						<div id="speedSeriDiv" style="display:none; position: absolute; width: 300px; height: 100px; z-index: 1; border: 1px solid rgb(231, 231, 231);">
							<table cellpadding="2" cellspacing="0" width="100%" height="100%" class="color-border">
								<tr class="color-row">
									<td valign="top">
										<table>
											<tr>
												<td class="formbold"><cf_get_lang dictionary_id='60239.Uygun Ürünler'></td>
											</tr>
											<tr id="icerik">
												<td></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					<!--- extra bitiş--->
					</div>
					</div>
					<div class="form-group" id="item-">
						<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='40196.Sarf'> <cf_get_lang dictionary_id='32711.Seri No Çıkar'></label>
						<div class="col col-6 col-md-6 col-xs-12">
							<div class="input-group">
								<input type="text" name="sarf_delete_old_serial_no" id="sarf_delete_old_serial_no" value="" onkeyup="return(del_serial_no_control(event,1));"/>
								<span class="input-group-addon btnPointer icon-minus" href="javascript://" id="sarf_delete_old_serial_no_button" onclick="del_serial_no(1);">
							</span>
						</div>
						<!--- extra --->
						<div id="speedSeriDivDel2"></div>
						<div id="speedSeriDivDel" style="display:none; position: absolute; width: 300px; height: 100px; z-index: 1; border: 1px solid rgb(231, 231, 231);">
							<table cellpadding="2" cellspacing="0" width="100%" height="100%" class="color-border">
								<tr class="color-row">
									<td valign="top">
										<table>
											<tr>
												<td class="formbold"><cf_get_lang dictionary_id='60239.Uygun Ürünler'></td>
											</tr>
											<tr id="icerik2">
												<td></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					<!--- extra bitiş--->
					</div>
					</div>
				</div>
				</div>
        </cf_box_elements>
        <div id="action_div"></div>
		<cf_grid_list>
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th><cf_get_lang dictionary_id='33902.Stok Adı'></th>
                    <th><cf_get_lang dictionary_id='57718.Seri Nolar'></th>
                    <th><cf_get_lang dictionary_id='60240.Üretim Çıkış'></th>	
                    <th><cf_get_lang dictionary_id='45736.Kalan Miktar'></th>			
                    <th><cf_get_lang dictionary_id='60241.İşlem Gören'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_rows">
                    <cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
                        SELECT
                            SG.LOT_NO,
                            SG.SERIAL_NO
                        FROM
                            SERVICE_GUARANTY_NEW AS SG
                        WHERE
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                            PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
                            SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                           <!--- <cfif len(attributes.spect_id)>
                                AND SPECT_ID = #attributes.spect_id#
                            </cfif>--->
                    </cfquery>
                    <input type="hidden" id="son_fark_" name="son_fark_" value="<cfoutput>#quantity-get_serial_info.recordcount#</cfoutput>">
                    <input type="hidden" id="seri_list" name="seri_list" value="<cfoutput>#ValueList(get_serial_info.serial_no)#</cfoutput>">
                    <tr height="20" id="tr#stock_id#">
                        <td></td>
                        <td>#stock_code#</td>
                        <td>#product_name#</td>
                        <td>
                        	<div id="serial_no_list_#stock_id#" style="max-height:375px; overflow:auto;">
                                <cfloop index="cc" list="#ValueList(get_serial_info.serial_no)#">
                                	<cfset renk_list = "">
                                    <cfset my_col = "">
                                	<cfloop list="#listdeleteduplicates(stock_list)#" index="kk">
										<cfset equal_ = 0>
                                        <cfset some_ = 0>
                                        <cfset empty_ = 0>
                                        <cfset renk = "">
                                        <cfquery name="GET_AMOUNT" dbtype="query">
                                            SELECT SUM(AMOUNT) AS COUNT1 FROM GET_ROW_EXIT WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kk#">
                                        </cfquery>
                                        <cfset amount_ = "#get_amount.count1/get_rows.quantity#">
                                        <cfquery name="GET_SARF_INFO" datasource="#DSN3#">
                                        	SELECT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kk#"> AND  PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND PROCESS_CAT = 111 AND MAIN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cc#"> AND MAIN_PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat_id#"> AND MAIN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND MAIN_PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#">
                                            UNION ALL
                                            SELECT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kk#"> AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id1#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND PROCESS_CAT = #process_type# AND MAIN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cc#"> AND MAIN_PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat_id#"> AND MAIN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND MAIN_PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#">
                                           	UNION ALL
                                            SELECT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#kk#"> AND MAIN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cc#"> AND IS_SARF = 0 AND MAIN_PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat_id#"> AND MAIN_PROCESS_ID = #attributes.process_id# AND MAIN_PROCESS_NO = '#attributes.process_number#'
                                        </cfquery>
                                        <cfif amount_ eq get_sarf_info.recordcount>
                                        	<cfset renk = "blue">
										<cfelseif get_sarf_info.recordcount gt 0 and amount_ gt get_sarf_info.recordcount>
                                        	<cfset renk = "green">
                                        <cfelseif not get_sarf_info.recordcount>
                                        	<cfset renk = "red">
                                        </cfif>
                                        <cfset renk_list = listappend(renk_list,renk)>
                                    </cfloop>
                                    <!-- hiç girilmemiş kırmızı
                                    	 bir kısmı girilmiş yeşil
                                         tamamı girilmiş mavi
                                     -->
                                    <cfif listfind(renk_list,"red") and not listfind(renk_list,"green") and not listfind(renk_list,"blue")>
                                    	<cfset my_col = "red">
                                    <cfelseif (listfind(renk_list,"red") and listfind(renk_list,"green") and listfind(renk_list,"blue")) or (listfind(renk_list,"green") and not listfind(renk_list,"red") and not listfind(renk_list,"blue")) or (listfind(renk_list,"blue") and listfind(renk_list,"green") and not listfind(renk_list,"red")) or (listfind(renk_list,"red") and listfind(renk_list,"green") and not listfind(renk_list,"blue")) or (listfind(renk_list,"red") and listfind(renk_list,"blue") and not listfind(renk_list,"green")) >
                                   		<cfset my_col = "green">
                                    <cfelseif listfind(renk_list,"blue") and not listfind(renk_list,"green") and not listfind(renk_list,"red")>
                                    	<cfset my_col = "blue">
                                    </cfif>
                                	<a  style="color:#my_col#;" id="serial_no_list_#stock_id#" onclick="open_detail_div('#cc#',#stock_id#,#spect_id#)">#cc#</a><br />
                                </cfloop>
                            </div>
                        </td>
                        <td id="serial_no_amount_#stock_id#">#quantity#</td>				
                        <td id="serial_no_fark_#stock_id#">#quantity-get_serial_info.recordcount#</td>
                        <td id="serial_no_selected_value_#stock_id#"></td>
                    </tr>
                </cfoutput>
             </tbody>
		</cf_grid_list>
        <div id="detail_div" style="width:770px;"></div>
	</cfform>
</cf_box>
<script type="text/javascript">
	<cfoutput>
	button_dis();
	seri_list = '';
	seri_list_ind  =0;
	
	
	if(document.getElementById('son_fark_').value == 0)
		document.getElementById('search_serial_no').focus();
	else
		document.getElementById('add_new_serial_no').focus();
		
	<cfif isdefined("get_serial_info.recordcount") and get_serial_info.recordcount>
		seri_list = '#valuelist(get_serial_info.serial_no)#' ;
		seri_list_ind = '#listlen(valuelist(get_serial_info.serial_no))#';
	</cfif>
	
	function button_dis()
	{
		<cfif get_rows.recordcount and not isDefined('session.pp.userid')>
			if(document.getElementById('son_fark_').value != '' && document.getElementById('son_fark_').value < 1)
				document.getElementById('add_new_serial_no_button').disabled = true;
		</cfif>
	}
	
	function search_serial_no_control(e,type)
	{
		if(!e) return false;
		var key=e.keyCode || e.which;
		if(key == 13)
			{
				if(type==0){
					search_serial_no_(type);
				}
				else{
					search_sarf_serial_no_(type);
				}
			}
	}
	
	function search_serial_no_(type)
	{	
		my_val = document.getElementById('search_serial_no').value;
		if(my_val != '')
		{
			a = 0;
			seri_list = document.add_upper_serial.seri_list.value;
			temp =  seri_list.split(',');
			for(i=0;i<seri_list_ind;i++)
			{
				if(my_val==temp[i])
				a  = 1;
			}
			
			//alert(a);
			if(a!=0)
			{
				document.getElementById('serial_no_selected_value_#attributes.stock_id#').innerHTML = '<font color="##01DF01">'+my_val+'</font>';
				document.getElementById('sarf_div').style.display = '';
				open_detail_div(my_val,#attributes.stock_id#,#attributes.spect_id#);
				document.getElementById('search_serial_no').value = '';
				document.getElementById('sarf_add_new_serial_no').focus();
			}
			else{
				alert('<cf_get_lang dictionary_id='60242.Böyle bir seri bulunmamaktadır'>.');
				return false;	
			}
		}
		else{
			alert('<cf_get_lang dictionary_id='57701.Filtre Ediniz'>!');
			}
	}
	
	function search_sarf_serial_no_(type)
	{
		my_seri = $("##sarf_search_serial_no").val();
		my_seri = ("'"+my_seri+"'");
		<cfif len(stock_list)>
			my_str = 'SELECT DISTINCT A.SERIAL_NO,B.STOCK_ID FROM SERVICE_GUARANTY_NEW A , SERVICE_GUARANTY_NEW B WHERE B.PROCESS_CAT = #process_type# AND B.STOCK_ID IN (#stock_list#) AND B.SERIAL_NO = '+ my_seri +' AND B.MAIN_SERIAL_NO = A.SERIAL_NO AND A.STOCK_ID = #attributes.stock_id# AND A.PROCESS_ID = B.MAIN_PROCESS_ID AND A.PROCESS_ID = #attributes.process_id#' ;
		<cfelse>
			my_str = 'SELECT DISTINCT A.SERIAL_NO,B.STOCK_ID FROM SERVICE_GUARANTY_NEW A , SERVICE_GUARANTY_NEW B WHERE B.PROCESS_CAT = #process_type# AND B.SERIAL_NO = '+ my_seri +' AND B.MAIN_SERIAL_NO = A.SERIAL_NO AND A.STOCK_ID = #attributes.stock_id# AND A.PROCESS_ID = B.MAIN_PROCESS_ID AND A.PROCESS_ID = #attributes.process_id#' ;	
		</cfif>
		my_s_query = wrk_query(my_str,'dsn3'); 
		if(my_s_query.recordcount != 0){
			document.getElementById('serial_no_selected_value_#attributes.stock_id#').innerHTML = '<font color="##01DF01">'+my_s_query.SERIAL_NO+'</font>';
			document.getElementById('sarf_div').style.display = '';
			/*$(document).ready(function(e) {*/
				open_detail_div(my_s_query.SERIAL_NO,#attributes.stock_id#,#attributes.spect_id#);
			/*});*/
			my_tr = 'serial_no_list_'+my_s_query.STOCK_ID;
			setTimeout(function(){document.getElementById(my_tr).style.backgroundColor = 'red'}, 1000);
		}
		else if (my_s_query.recordcount == 0){
			alert("<cf_get_lang dictionary_id='60242.Böyle bir seri bulunamadı'>.");
			return false;	
		}
		
	}
	
	function open_detail_div(deger,stock_id,spect_id)
	{
		document.getElementById('serial_no_selected_value_'+stock_id).innerHTML = '<font color="##01DF01">'+deger+'</font>';
		adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_action_detail&p_order_id=#attributes.p_order_id#&amount=#get_rows.QUANTITY#&process_id=#attributes.process_id#&process_cat=#attributes.process_cat_id#&process_no=#attributes.process_number#&stock_id=#attributes.stock_id#&new_dsn2=#attributes.new_dsn2#&serial_no=';
		adres_ = adres_+deger;
		adres_ = adres_ +'&spect_id=' +spect_id;
		AjaxPageLoad(adres_,'detail_div',1);
		document.getElementById('sarf_div').style.display = '';
	}
	
	function del_serial_no_control(e,number)
	{
		if(!e) return false;/*if(!e) var e = window.event;*/
		var key=e.keyCode || e.which;
		if(key == 13)
			{
				del_serial_no(number);
				document.getElementById('delete_old_serial_no').value = '';
			}
	}
	function add_serial_no_control(e,number)
	{
		if(!e) return false;/*if(!e) var e = window.event;*/
		var key=e.keyCode || e.which;
		if(key == 13)
			{
				add_serial_no(number);
				document.getElementById('add_new_serial_no').value = '';
			}
	}
	function add_serial_no(number)
	{//??? yukarıdan eklerken hangi stoğa eklenecek
			if(number == 0)
				{
				serial_no_ = document.getElementById('add_new_serial_no').value;
				if(document.getElementById('son_fark_').value == 0)
					{
						alert('#get_rows.stock_code# <cf_get_lang dictionary_id='60243.Stok Kodlu Ürün İçin Seri No Girişi Tamamlanmıştır'>. <cf_get_lang dictionary_id='60245.Seri No Giremezsiniz'>!');
						return false;	
					}
					
				}
			else
				serial_no_ = document.getElementById('sarf_add_new_serial_no').value;
			if(serial_no_=='')
				{
				alert('Seri No Giriniz!');
				return false;
				}
			else
				{
				if(number == 0){
					adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&is_line=1&action_type=add&process_id=#attributes.process_id#&process_no=#attributes.process_number#&process_cat=#attributes.process_cat_id#&spect_id=#attributes.spect_id#&stock_id=#attributes.stock_id#&serial_no='; 
					adres_ = adres_ + serial_no_ ;
					AjaxPageLoad(adres_,'action_div',1);}
				else{
	
					ust_seri = $('##serial_no_selected_value_#attributes.stock_id# font').text();
					ust_seri1 = "'"+ust_seri+"'";
					my_val = document.getElementById('sarf_add_new_serial_no').value ;
					my_val_2 = ("'"+my_val+"'");
					my_str = "SELECT GUARANTY_ID,SERIAL_NO,STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE PROCESS_CAT IN (110,76,77,82,84,114,115,171,811) AND SERIAL_NO NOT IN (SELECT S2.SERIAL_NO FROM SERVICE_GUARANTY_NEW S2 WHERE S2.IS_SALE = 1 AND S2.SERIAL_NO = SERIAL_NO) AND SERIAL_NO = "+my_val_2;
					my_q = wrk_query(my_str,"DSN3");//sistemde giriş halinde böyle bir seri var mı
					if(my_q.recordcount > 1)
					{
						my_stock_id = my_q.STOCK_ID;
						my_q_ctrl = wrk_query("SELECT SUM(AMOUNT) AMOUNT,SPEC_MAIN_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #attributes.process_id# AND TYPE=2 AND STOCK_ID IN ("+ my_stock_id +") GROUP BY SPEC_MAIN_ID","DSN3");
						if(my_q_ctrl.recordcount!=0)
						{
							
										addr = '#request.self#?fuseaction=objects.serial_no_detail2&stock_id=#attributes.stock_id#&stock_list=#stock_list#&seri_no='+my_val+'&amount='+my_q_ctrl.AMOUNT+'&my_stock_id='+ my_stock_id+'&ust_seri='+ust_seri+'&ust_seri1='+ust_seri1+'&spect_id='+my_q_ctrl.SPEC_MAIN_ID;
										AjaxPageLoad(addr,'speedSeriDiv2',1);
										/*$('##speedSeriDiv').css('display','block');
										document.getElementById('icerik').innerHTML = "<a onclick="+alert(my_s_query.STOCK_ID)+" href=''>"+my_s_query.PRODUCT_NAME+"</a>";
										alert(my_s_query.PRODUCT_NAME);*/
	
						}
							
					}
					if(my_q.recordcount==1)
					{
						my_stock_id = my_q.STOCK_ID;
						my_q2  = wrk_query("SELECT SUM(AMOUNT) AMOUNT,SPEC_MAIN_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #attributes.process_id# AND TYPE=2 AND STOCK_ID = "+my_stock_id +" GROUP BY SPEC_MAIN_ID","DSN3");
						if(my_q2.recordcount == 0)
						alert('Böyle bir kayıtlı seri bulunamadı.');
					}
					else if(my_q.recordcount==0)
						alert('Böyle bir kayıtlı seri bulunamadı.');
					if(my_q.recordcount==1 && my_q2.recordcount!=0)
					{
						add_settings(my_q2.AMOUNT,my_stock_id,ust_seri1,my_q2.SPEC_MAIN_ID,my_val,ust_seri);
					}
				}
				}
				return false;
	}
	
	function add_settings(amount,my_stock_id,ust_seri1,spect_id,my_val,ust_seri)
	{
		my_q2  = wrk_query("SELECT SUM(AMOUNT) AMOUNT,SPEC_MAIN_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #attributes.process_id# AND TYPE=2 AND STOCK_ID = "+my_stock_id +" GROUP BY SPEC_MAIN_ID","DSN3");
		amount = my_q2.AMOUNT;
		my_amount =parseInt(amount/#get_rows.QUANTITY#);
		if(ust_seri1.indexOf("'") == -1)
		ust_seri1 = ("'"+ust_seri1+"'");
		my_control_str = "SELECT SG.SERIAL_NO,S.STOCK_CODE FROM SERVICE_GUARANTY_NEW SG,STOCKS S  WHERE SG.STOCK_ID =  S.STOCK_ID AND SG.STOCK_ID = " + my_stock_id +"  AND SG.MAIN_SERIAL_NO = " + ust_seri1+ "  AND SG.MAIN_PROCESS_ID = #attributes.process_id#";
		my_control_q = wrk_query(my_control_str,"DSN3");//ÜST SERİSİ BU OLAN KAÇ TANE SERİ GİRİLDİ BU STOK İÇİN
		if( my_control_q.recordcount != 0 && my_control_q.recordcount >= my_amount)
		{
			alert(my_control_q.STOCK_CODE +' Stok Kodlu Ürün İçin Seri Girişi Tamamlanmıştır. Seri Girişi Yapılamaz!');
			document.getElementById('sarf_add_new_serial_no').value = '';
			return false;	
		}
		adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&is_line=1&action_type=add&stock_list=#stock_list#&process_id=#sarf_process_id#&process_no=#sarf_process_no#&process_cat=#process_type#'
		adres_ = adres_ + '&main_process_no=#attributes.process_number#';
		adres_ = adres_ + '&main_process_id=#attributes.process_id#';
		adres_ = adres_ + '&main_process_cat=#attributes.process_cat_id#';
		adres_ = adres_ + '&amount='+my_amount;
		if(spect_id!= 'NULL' && spect_id.length != 0)
		adres_ = adres_ + '&spect_id='+spect_id;
		adres_ = adres_ + '&main_serial_no='+ust_seri;
		adres_ = adres_ + '&stock_id=' +my_stock_id;
		adres_ = adres_ + '&serial_no='+my_val;
		AjaxPageLoad(adres_,'action_div',1);
		document.getElementById('sarf_add_new_serial_no').value = '';
	
		
	}
	function del_serial_no(number)
	{
			if(number == 0)
				serial_no_ = document.getElementById('delete_old_serial_no').value;
			else
				serial_no_ = document.getElementById('sarf_delete_old_serial_no').value;		
			if(serial_no_=='')
				{
				alert('<cf_get_lang dictionary_id="41875.Seri No Giriniz">!');
				return false;
				}
			else{
				if(number == 0){
					AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=del&process_id=#attributes.process_id#&process_cat=#attributes.process_cat_id#&is_line=1&stock_id=#attributes.stock_id#&serial_no=' + serial_no_,'action_div',1);}
				else{
					ust_seri = $('##serial_no_selected_value_#attributes.stock_id# font').text();
					my_val_2 = ("'"+serial_no_+"'");
					my_str = "SELECT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE PROCESS_CAT = #process_type# AND STOCK_ID IN (#stock_list#) AND SERIAL_NO = "+my_val_2;
					my_q = wrk_query(my_str,"DSN3");//BU SERİ SARF EDİLMİŞ Mİ?
					if(my_q.recordcount == 0)
						alert('Böyle bir kayıtlı seri bulunamadı.');
					else if(my_q.recordcount == 1){
						adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&is_line=1&action_type=del&process_cat=#process_type#&process_id=#sarf_process_id#&process_no=#sarf_process_no#&main_process_no=#attributes.process_number#&main_process_id=#attributes.process_id#&main_process_cat=#attributes.process_cat_id#&stock_list=#stock_list#&main_serial_no='+ust_seri+'&stock_id='+my_q.STOCK_ID+'&serial_no=' +serial_no_;
						AjaxPageLoad(adres_,'action_div',1);
						}
					else if(my_q.recordcount > 1){
							addr = '#request.self#?fuseaction=objects.serial_no_detail2&is_del=1&process_id=#sarf_process_id#&process_no=#sarf_process_no#&main_process_no=#attributes.process_number#&main_process_id=#attributes.process_id#&main_process_cat=#attributes.process_cat_id#&main_serial_no='+ust_seri+'&stock_id=#attributes.stock_id#&stock_list=#stock_list#&seri_no='+serial_no_;						
							AjaxPageLoad(addr,'speedSeriDivDel2',1);
						
					}
					
					}
				}
	}
	</cfoutput>
</script>

