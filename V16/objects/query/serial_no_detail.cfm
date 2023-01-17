<cf_xml_page_edit fuseact="objects.popup_add_upper_serial_operations">
<cfsetting showdebugoutput="no">
<cfset variable = '1'>
<cfset variable2 = '2'>
<cfset process_type = 1719><!--- Sarf yerine yeni sanal bir işlem tipi kullanıyoruz.  --->
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
    	STOCK_ID
</cfquery>
<cfquery name="GET_COMP_INFO" datasource="#DSN#">
	SELECT 
    	IS_SERIAL_CONTROL 
    FROM 
    	#DSN_ALIAS#.OUR_COMPANY_INFO 
    WHERE
    	<cfif isDefined('session.ep')> 	
    		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfelse>
    		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">        
        </cfif>
</cfquery>
<cfset process_id1 = "">
<cfset process_no1 = "">
<cfset process_ids = "">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang_main no='106.Stok Kodu'></th>
            <th><cf_get_lang no='1512.Stok Adı'></th>
            <th>Spec No</th>
            <th>Miktar</th>	
            <th>Seri No</th>	
            <th>Kalan Miktar</th>	
			<cfif GET_COMP_INFO.IS_SERIAL_CONTROL EQ 0>               
                <th>İşlem</th>
            </cfif>
        </tr>
    </thead>
    <tbody>
    <cfoutput query="GET_ROW_EXIT" group="STOCK_ID">
    	<cfset 'amount_#stock_id#' = 0>
    </cfoutput>
	<cfoutput query="GET_ROW_EXIT" group="STOCK_ID">
    	<cfoutput>
			<cfset 'amount_#stock_id#' = evaluate('amount_#stock_id#') + amount>
		</cfoutput>
        <cfquery name="GET_PRODUCT" datasource="#DSN1#">
            SELECT 
                PRODUCT.PRODUCT_NAME,
                STOCKS.PRODUCT_UNIT_ID,
                STOCKS.STOCK_CODE,
                STOCKS.STOCK_ID
            FROM 
                PRODUCT,
                STOCKS,
                PRODUCT_UNIT            
            WHERE 
                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
                PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
        </cfquery>
		<cfset fark = 0>
		<!---<cfif GET_FIS_SARF.recordcount>--->
            <cfset process_id1 = attributes.process_id>
            <cfset process_no1 = "USC-"&attributes.process_id>
            <cfquery name="get_serials_" datasource="#DSN3#">
            	SELECT
                    SERIAL_NO,
                    PROCESS_ID,
                    PROCESS_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    STOCK_ID = #GET_PRODUCT.STOCK_ID# AND
                    PROCESS_CAT = 111 AND
		    <cfif isDefined('session.ep.userid')>
	                    PERIOD_ID = #session.ep.period_id# AND
		    <cfelseif isDefined('session.pp.userid')>
	                    PERIOD_ID = #session.pp.period_id# AND
		    </cfif> 
                    MAIN_PROCESS_ID = #attributes.process_id# AND
                    MAIN_PROCESS_TYPE = #attributes.process_cat# AND
                    MAIN_SERIAL_NO = '#attributes.serial_no#'
                UNION ALL
                SELECT
                    SERIAL_NO,
                    PROCESS_ID,
                    PROCESS_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    STOCK_ID = #GET_PRODUCT.STOCK_ID# AND
                    PROCESS_ID = #process_id1# AND
                    PROCESS_CAT = #process_type# AND
		    <cfif isDefined('session.ep.userid')>
	                    PERIOD_ID = #session.ep.period_id# AND
		    <cfelseif isDefined('session.pp.userid')>
	                    PERIOD_ID = #session.pp.period_id# AND
		    </cfif> 
                    MAIN_PROCESS_ID = #attributes.process_id# AND
                    MAIN_PROCESS_TYPE = #attributes.process_cat# AND
                    MAIN_SERIAL_NO = '#attributes.serial_no#'
                UNION ALL
                SELECT
                    SERIAL_NO,
                    PROCESS_ID,
                    PROCESS_NO
                FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    STOCK_ID = #GET_PRODUCT.STOCK_ID# AND
                    MAIN_PROCESS_ID = #attributes.process_id# AND
                    MAIN_PROCESS_NO = '#attributes.process_no#' AND
                    MAIN_PROCESS_TYPE = #attributes.process_cat# AND
                    MAIN_SERIAL_NO = '#attributes.serial_no#' AND
                    IS_SARF = 0
            </cfquery>
            <cfset seri_no_ = valuelist(get_serials_.SERIAL_NO,"<br>")>
            <cfset process_ids = listappend(process_ids,valuelist(get_serials_.PROCESS_ID))>
        <!---<cfelse>
            <cfset get_serials_.recordcount = 0>
            <cfset seri_no_ = "">
            <cfset process_id1 = "">
            <cfset process_no1 = "">
        </cfif>--->
        <cfset miktar =  evaluate('amount_#stock_id#')/attributes.amount>
        <tr><!---hatırlatma   !!!!!!!!!!!!!! stok id yi sil debug kapat --->
            <td>#GET_PRODUCT.STOCK_CODE#</td>
            <td <cfif len(get_row_exit.spect_id) or len(get_row_exit.SPEC_MAIN_ID)>style="color:##F69"</cfif>>#GET_PRODUCT.PRODUCT_NAME#</td>
            <td>
            	<cfif len(get_row_exit.SPEC_MAIN_ID)>
                    #get_row_exit.SPEC_MAIN_ID#
                </cfif>
            </td>
            <td><div id="serial_no_amount_#stock_id#">#evaluate('amount_#stock_id#')/attributes.amount#</div>
            </td>
            <td>
                <div id="serial_no_list_#GET_PRODUCT.stock_id#">#seri_no_#</div>
                <cfset fark = '#miktar-get_serials_.recordcount#'>
                <input type="hidden" name="fark_" id="fark_" value="#fark#">
            </td>
            <td><div id="serial_no_fark_#GET_PRODUCT.stock_id#"><cfif len(get_row_exit.SPEC_MAIN_ID)>#fark#<cfelse>#fark#</cfif></div></td>		
			<cfif GET_COMP_INFO.IS_SERIAL_CONTROL EQ 0>               
			<td style="width:240px;">   
            	<cfif len(get_row_exit.SPEC_MAIN_ID)> 
		<cfif fark gte 1>
                    	Seri No Ekle&nbsp;<input type="text" value="" id="add_new_serial_no#GET_PRODUCT.stock_id#" name="add_new_serial_no#GET_PRODUCT.stock_id#"  onkeyup="return(add_serial_no_control_(event,#GET_PRODUCT.stock_id#,0,#get_row_exit.SPEC_MAIN_ID#));"/>&nbsp;
                        <a href="javascript://" id="add_new_serial_no_button#GET_PRODUCT.stock_id#" onclick="add_serial_no_2(#GET_PRODUCT.stock_id#,#get_row_exit.SPEC_MAIN_ID#)"><img src="images/pod_add_list.gif" valign="bottom" /></a><br />
                    </cfif>
                        Seri No Çıkar<input type="text" value="" id="delete_old_serial_no#GET_PRODUCT.stock_id#" name="delete_old_serial_no#GET_PRODUCT.stock_id#" onkeyup="return(del_serial_no_control_(event,#GET_PRODUCT.stock_id#));"/>&nbsp;
                        <a href="javascript://" id="delete_old_serial_no_button#GET_PRODUCT.stock_id#" onclick="del_serial_no_(#GET_PRODUCT.stock_id#)"><img src="images/pod_delete_list.gif" valign="bottom" /></a>
                <cfelse>
                	<cfif fark gte 1>
                        Seri No Ekle&nbsp;<input type="text" value="" id="add_new_serial_no#GET_PRODUCT.stock_id#" name="add_new_serial_no#GET_PRODUCT.stock_id#"  onkeyup="return(add_serial_no_control_(event,#GET_PRODUCT.stock_id#,1));"/>&nbsp;
                        <a href="javascript://" id="add_new_serial_no_button#GET_PRODUCT.stock_id#" onclick="add_serial_no_(#GET_PRODUCT.stock_id#)"><img src="images/pod_add_list.gif" valign="bottom" /></a><br />
                    </cfif>
                        Seri No Çıkar<input type="text" value="" id="delete_old_serial_no#GET_PRODUCT.stock_id#" name="delete_old_serial_no#GET_PRODUCT.stock_id#" onkeyup="return(del_serial_no_control_(event,#GET_PRODUCT.stock_id#));"/>&nbsp;
                        <a href="javascript://" id="delete_old_serial_no_button#GET_PRODUCT.stock_id#" onclick="del_serial_no_(#GET_PRODUCT.stock_id#)"><img src="images/pod_delete_list.gif" valign="bottom" /></a>
                </cfif>
            </td>
            </cfif> 
        </tr>
	</cfoutput>
    </tbody>
</cf_grid_list>
<cfset process_ids = listdeleteduplicates(process_ids)>
<script type="text/javascript">
<cfoutput>
	function button_disable()
	{
		<cfif GET_ROW_EXIT.recordcount>
		if(document.getElementById('fark_').value != '' && document.getElementById('fark_').value < 1)
			document.getElementById('add_new_serial_no_button'+stock_id).disabled = true;
		</cfif>
	}

	function button_disable(stock_id)
	{
		<cfif GET_ROW_EXIT.recordcount>
		if(document.getElementById('son_fark'+stock_id).value != '' && document.getElementById('son_fark'+stock_id).value < 1)
			document.getElementById('add_new_serial_no_button'+stock_id).disabled = true;
		</cfif>
	}

<!---	function add_operation(seri_no,stock_id,amount)
	{
		document.getElementById('islem_'+stock_id).innerHTML = seri_no;
		adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=relation&process_id=#process_id_#&process_no=#process_no_#&process_cat=#attributes.process_cat#&spect_id=';
		adres_ = adres_ + '&stock_id=' +stock_id;
		adres_ = adres_ + '&main_process_id=#attributes.process_id#';
		adres_ = adres_ + '&main_process_no=#attributes.process_no#';
		adres_ = adres_ + '&main_process_cat=#attributes.process_cat#';
		adres_ = adres_ + '&main_serial_no=#attributes.serial_no#';
		adres_ = adres_ + '&amount='+amount;
		adres_ = adres_ + '&serial_no=';
		adres_ = adres_ + seri_no ;
		AjaxPageLoad(adres_,'action_div',1,'İlişki Kuruluyor');
	}--->
	function add_serial_no_control_(e,number,type,spect)
	{
		if(!e) return false;/*if(!e) var e = window.event;*/
		var key=e.keyCode || e.which;
		if(key == 13)
			{
				if(type==0)
				add_serial_no_2(number,spect);
				else
				add_serial_no_(number);
				document.getElementById('add_new_serial_no'+number).value = '';
			}
	}
	
	function del_serial_no_control_(e,number)
	{
		if(!e) return false;/*if(!e) var e = window.event;*/
		var key=e.keyCode || e.which;
		if(key == 13)
			{
				
					del_serial_no_(number);
				
				document.getElementById('delete_old_serial_no'+number).value = '';
			}
	}
	
	function del_serial_no_(stock_id)
	{
		serial_no_ = document.getElementById('delete_old_serial_no'+stock_id).value;	
		if(serial_no_=='')
			{
			alert('Seri No Giriniz!');
			return false;
			}
		else
			{
			var adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=del&process_id=#process_id1#&process_no=#process_no1#&main_process_id=#attributes.process_id#&main_process_cat=#attributes.process_cat#&process_cat=#process_type#&main_serial_no=#attributes.serial_no#&stock_id='+stock_id+'&serial_no=' +serial_no_;
			AjaxPageLoad(adres_,'action_div',1);
			}
	}

	function add_serial_no_(stock_id)
	{
		serial_no_ = document.getElementById('add_new_serial_no'+stock_id).value;
		if(serial_no_=='')
			{
			alert('Seri No Giriniz!');
			return false;
			}
		else
			{
				adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=add&process_id=#process_id1#&process_no=#process_no1#&process_cat=#process_type#&spect_id=';
				adres_ = adres_ + '&main_process_id=#attributes.process_id#';
				adres_ = adres_ + '&main_process_no=#attributes.process_no#';
				adres_ = adres_ + '&main_process_cat=#attributes.process_cat#';
				adres_ = adres_ + '&main_serial_no=#attributes.serial_no#';
				adres_ = adres_ + '&stock_id=' +stock_id;
				adres_ = adres_ + '&serial_no=';
				adres_ = adres_ + serial_no_ ;
				AjaxPageLoad(adres_,'action_div',1);
			}
	}
	
	function add_serial_no_2(stock_id,spect_id)
	{
		serial_no_ = document.getElementById('add_new_serial_no'+stock_id).value;
		if(serial_no_=='')
			{
			alert('Seri No Giriniz!');
			return false;
			}
		else
			{
				adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&is_product=1&action_type=add&process_id=#process_id1#&process_no=#process_no1#&process_cat=#process_type#&spect_id=';
				adres_ = adres_ + spect_id ;
				adres_ = adres_ + '&main_process_id=#attributes.process_id#';
				adres_ = adres_ + '&main_process_no=#attributes.process_no#';
				adres_ = adres_ + '&main_process_cat=#attributes.process_cat#';
				adres_ = adres_ + '&main_serial_no=#attributes.serial_no#';
				adres_ = adres_ + '&stock_id=' +stock_id;
				adres_ = adres_ + '&serial_no=';
				adres_ = adres_ + serial_no_ ;
				//alert(adres_);
				AjaxPageLoad(adres_,'action_div',1);
			}
	}
		
	function del_serial_no_2(stock_id)
	{
		serial_no_ = document.getElementById('delete_old_serial_no'+stock_id).value;		
		if(serial_no_=='')
			{
			alert('Seri No Giriniz!');
			return false;
			}
		else
			{
			var adres_ = '#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action&action_type=relation&process_id=#process_ids#&process_no=#process_no1#&main_process_no=#attributes.process_no#&main_process_id=#attributes.process_id#&main_process_cat=#attributes.process_cat#&main_serial_no=#attributes.serial_no#&rel=1&stock_id='+stock_id+'&serial_no=' +serial_no_;
			AjaxPageLoad(adres_,'action_div',1);
			}
	}

</cfoutput>
</script>


