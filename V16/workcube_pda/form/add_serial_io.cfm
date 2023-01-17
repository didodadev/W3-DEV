<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cfif attributes.fuseaction contains 'sale'>Satış<cfelse>Alış</cfif> İrsaliyesi Seri Giriş/Çıkış İşlemleri</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
            <cfform name="find_ship" method="post" action="" onsubmit="return (find_ship_f())">
                <table>
                    <tr>
                        <td>Belge No</td>
                        <td style="text-align:right; vertical-align:middle;">
                            <input type="text" name="find_ship_number" id="find_ship_number" value="<cfif isDefined('attributes.find_ship_number') and len(attributes.find_ship_number)><cfoutput>#attributes.find_ship_number#</cfoutput></cfif>">
                            <input type="hidden" name="my_input" id="my_input" value="0">
                            <input type="hidden" name="circuit" id="circuit" value="<cfoutput>#fusebox.circuit#</cfoutput>">
                        </td>
                        <td style="text-align:right; vertical-align:bottom;"><cf_wrk_search_button search_function='find_ship_f()' is_excel='0'></td>
                    </tr>
		    		<cfif isDefined('xml_is_serial_search') and xml_is_serial_search eq 1>
						<cfoutput>
                        <tr>
                            <td>Seri No Ekle</td>
                            <td><input type="text" name="add_new_serial_no" id="add_new_serial_no" value="" onkeypress="if(event.keyCode==13){add_serial_no(); return false};" onkeyup="return(add_serial_no_control(event));"//></td>
                            <td><input type="button" name="add_new_serial_no_button" id="add_new_serial_no_button" value="+" style="width:50px;" onclick="add_serial_no();"></td>
                        </tr>
                        </cfoutput>
				    </cfif>
                </table>
            </cfform>
			<cfif isDefined('attributes.ship_id') and len(attributes.ship_id)>
                <cfquery name="GET_SHIP_ROWS" datasource="#DSN2#">
                    SELECT
                        SUM(SR.AMOUNT) QUANTITY,
                        S.SHIP_NUMBER,
                        S.COMPANY_ID,
                        S.PARTNER_ID,
                        SR.STOCK_ID,
                        S.SHIP_ID,
                        S.PURCHASE_SALES,
                        S.SHIP_TYPE,
                        CASE WHEN(S.PURCHASE_SALES = 1) THEN S.DELIVER_STORE_ID ELSE S.DEPARTMENT_IN END AS DEPARTMENT,
                        CASE WHEN(S.PURCHASE_SALES = 1) THEN S.LOCATION ELSE S.LOCATION_IN END AS LOCATION,
                        P.PRODUCT_NAME,
                        ST.STOCK_CODE_2,
                        SR.WRK_ROW_RELATION_ID,
                        SR.SPECT_VAR_ID
                    FROM
                        SHIP S,
                        SHIP_ROW SR,
                        #dsn1_alias#.STOCKS ST,
                        #dsn1_alias#.PRODUCT P          
                    WHERE
                        ST.PRODUCT_ID = P.PRODUCT_ID AND 
                        SR.STOCK_ID = ST.STOCK_ID AND
                        S.SHIP_ID = SR.SHIP_ID AND
                        S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
		    		GROUP BY
                        S.SHIP_NUMBER,
                        S.COMPANY_ID,
                        S.PARTNER_ID,
                        SR.STOCK_ID,
                        S.SHIP_ID,
                        S.PURCHASE_SALES,
                        S.SHIP_TYPE,
                        CASE WHEN(S.PURCHASE_SALES = 1) THEN S.DELIVER_STORE_ID ELSE S.DEPARTMENT_IN END,
                        CASE WHEN(S.PURCHASE_SALES = 1) THEN S.LOCATION ELSE S.LOCATION_IN END,
                        P.PRODUCT_NAME,
                        ST.STOCK_CODE_2,
                        SR.WRK_ROW_RELATION_ID,
                        SR.SPECT_VAR_ID
                    ORDER BY
                        SR.STOCK_ID ASC
                </cfquery>
                <cfquery name="GET_SERIAL_NOS" datasource="#DSN3#">
                    SELECT 
                        STOCK_ID, 
                        SERIAL_NO 
                    FROM 
                        SERVICE_GUARANTY_NEW
                    WHERE
                        PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
                </cfquery>
                <cfform name="add_service_gn" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_serial_io">
                    <input type="hidden" name="in_out" id="in_out" value="<cfif len(get_ship_rows.purchase_sales) and get_ship_rows.purchase_sales eq 1>0<cfelse>1</cfif>" />
		    		<input type="hidden" name="fuseact_" id="fuseact_" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                    <input type="hidden" name="process_cat" id="process_cat" value="<cfoutput>#get_ship_rows.ship_type#</cfoutput>" />
                    <input type="hidden" name="process_id" id="process_id" value="<cfoutput>#attributes.ship_id#</cfoutput>" />
                    <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_ship_rows.department#</cfoutput>" />
                    <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_ship_rows.location#</cfoutput>" />
		    		<input type="hidden" name="process_no" id="process_no" value="<cfoutput>#get_ship_rows.ship_number#</cfoutput>" />
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_ship_rows.company_id#</cfoutput>" />
		    		<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_ship_rows.partner_id#</cfoutput>" />
                    <div id="mydiv">
                        <table>
                            <tr id="order_info" style="display:<cfif get_ship_rows.recordcount gt 0>''<cfelse>none</cfif>;">
                                <td colspan="2">
                                <table>
                                    <tr>
                                        <td colspan="3" class="txtboldblue">İrsaliye Bilgileri</td>
                                    </tr>
                                    <tr>
                                        <td style="width:27px;">Miktar</td>
                                        <td style="width:27px;">İşlenen</td>
                                        <td>Özel Kod</td>
                                    </tr>
                                </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <cfoutput>
                                        <cfloop from="1" to="50" index="no">
                                            <cfset serial_nos = ''>
                                            <cfif len(get_ship_rows.stock_id[no])>
                                                <cfquery name="GET_SERIAL_NO" dbtype="query">
                                                    SELECT * FROM GET_SERIAL_NOS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_rows.stock_id[no]#">
                                                </cfquery>
                                                <cfif get_serial_no.recordcount>
                                                    <cfloop query="get_serial_no">
                                                        <cfset serial_nos = '#serial_nos##get_serial_no.serial_no##chr(13)##chr(10)#'>
                                                    </cfloop>
                                                </cfif>
                                            <cfelse>
                                                <cfset serial_nos = ''>
                                                <cfset get_serial_no.recordcount = 0>
                                            </cfif>
                                            <div id="n_my_div#no#" style="display:<cfif get_ship_rows.recordcount gte no>''<cfelse>none</cfif>;">
                                            <table cellpadding="1" cellspacing="0">
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="<cfif get_ship_rows.recordcount lte no>1<cfelse>0</cfif>">
                                                        <input type="hidden" name="spect_var_id#no#" id="spect_var_id#no#" value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.spect_var_id[no]#</cfif>">
                                                        <input type="hidden" name="sid#no#" id="sid#no#" value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.stock_id[no]#</cfif>">
                                                        <input type="hidden" name="row_ship_id#no#" id="row_ship_id#no#" value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.stock_id[no]#</cfif>">
                                                        <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.wrk_row_relation_id[no]#</cfif>">
                                                        <input type="text" name="amount#no#" id="amount#no#" style="width:25.5px;" readonly value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.quantity[no]#<cfelse>1</cfif>" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                                        <input type="text" name="amount_diff#no#" id="amount_diff#no#" style="width:25.5px;" readonly value="#get_serial_no.recordcount#" class="moneybox" onkeyup="FormatCurrency(this,2);" <cfif isdefined('session.pda.use_onkeydown_enter')>onkeydown<cfelse>onchange</cfif>="<cfif isDefined('session.pda.use_onkeydown_enter')>if(event.keyCode == 13)</cfif> clear_barcode();">
                                                        <input type="text" name="barcode#no#" id="barcode#no#" style="width:100px;" value="<cfif get_ship_rows.recordcount gte no>#get_ship_rows.stock_code_2[no]#</cfif>">
                                                        <!--- <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" align="absmiddle" border="0"></a> --->
                                                        <a href="javascript://" onclick="ac_kapa(#no#);"><img  src="images/plus_ques.gif" align="absmiddle" border="0"></a>
                                                        <!---<a href="javascript://" onclick="data_transfer(1,#no#);"><img  src="images/copy_list.gif" align="absmiddle" border="0"></a>--->
                                                    </td>
                                                </tr>
                                                <script language="javascript">
                                                    function ac_kapa(nmb)
                                                    {
                                                        gizle_goster(eval("document.getElementById('tek_tek" + nmb + "')"));
                                                    }
                                                </script>
                                                <tr id="tr_product_name#no#" style="display:;">
                                                    <td colspan="2"><input type="text" name="product_name#no#" id="product_name#no#" style="width:250px;" value="#get_ship_rows.product_name[no]#" readonly></td>
                                                </tr>
                                                <tr id="tek_tek#no#" style="display:none;vertical-align:top;">
                                                    <td>Ürün Seri Nolar</td>
                                                    <td>
                                                        <input type="hidden" name="enter_key" id="enter_key" value="#chr(13)##chr(10)#" />
                                                        <textarea name="ship_start_nos#no#" id="ship_start_nos#no#" style="width:179px;height:147px;">#serial_nos#</textarea><br/>
                                                        <font color="red">.Enter Tuşu İle Ayırınız...</font>
                                                    </td>
                                                </tr> 
                                            </table>
                                            </div>
                                        </cfloop>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center"><input type="submit" name="submit" value="Kaydet" onclick="return control();"></td>
                            </tr>
                        </table>
                    </div>
                </cfform>
            </cfif>
        </td>
    </tr>
</table>

<script type="text/javascript">
	<cfif attributes.fuseaction contains 'sale'>
		var ship_type = 1;
	<cfelse>
		var ship_type = 0;
	</cfif>
	function find_ship_f()
	{
		if(document.getElementById('find_ship_number').value.length)
		{
			/*if(find_ship.department_list != undefined)
				var listParam = find_ship.find_ship_number.value + "*" + find_ship.department_list.value;
			else*/
			var listParam = document.getElementById('find_ship_number').value + "*" + ship_type;
			/*if (find_ship.circuit.value == 'store')
				var new_sql = "stk_get_ship";
			else*/
			var new_sql = "stk_get_ship_2";
			var get_ship = wrk_safe_query(new_sql,'dsn2',0,listParam);

			if(get_ship.recordcount)
			{
				<!---if(get_ship.PURCHASE_SALES[0] == 1)<!--- satis --->
					if(get_ship.SHIP_TYPE[0] == 81)<!--- sevk irsaliyesi ise --->
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_ship_dispatch&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else if(get_ship.SHIP_TYPE[0] == 811)<!--- ithal mal girisi ise --->
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_stock_in_from_customs&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_sale&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
				else<!--- alis --->
					find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_purchase&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];--->
				document.find_ship.action = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];	
				document.find_ship.submit();
				return false;
			}
			else 
			{
				alert("<cf_get_lang_main no='1074.Kayıt Bulunamadı'>");
				return false;
			}
		}
		else 
		{ 
			alert("<cf_get_lang_main no='1231.İrsaliye Nosu Eksik'>");
			return false;
		}
	}

	/*function add_serial_no_control(e)
	{
		var key=e.keyCode || e.which;
		if(key == 13)
		{
			add_serial_no();
			document.getElementById('add_new_serial_no').value = '';
		}
	}*/
	
	function control()
	{
		if(confirm("Kaydetmek istediğinizden emin misiniz?")); else {return false};	
	}
	
	function add_serial_no()
	{
		var listParam = document.getElementById('add_new_serial_no').value + '*' + ' ORDER BY STOCK_ID ASC';
		
		get_serial_ = wrk_safe_query("obj_get_serial",'dsn3',0,listParam);
		var is_serial = 0;
		if(get_serial_.recordcount)
		{
			<cfif isDefined('attributes.ship_id') and len(attributes.ship_id)>
				<cfoutput query="get_ship_rows">
					var is_exist = eval('document.getElementById("ship_start_nos#currentrow#")').value.search("" + document.getElementById('add_new_serial_no').value + "");
					if(is_exist >= 0)
					{
						alert('Bu seri numarası zaten eklenmiş');
						return false;	
					}
					if(get_serial_.STOCK_ID == '#stock_id#')
					{
						is_serial = 1;
						eval('document.getElementById("ship_start_nos#currentrow#")').value = eval('document.getElementById("ship_start_nos#currentrow#")').value + '' + document.getElementById('add_new_serial_no').value + '' + document.getElementById('enter_key').value;
						eval('document.getElementById("amount_diff#currentrow#")').value = parseInt(eval('document.getElementById("amount_diff#currentrow#")').value) + 1;
						goster(eval("document.getElementById('tek_tek#currentrow#')"));
					}
					else
						gizle(eval("document.getElementById('tek_tek#currentrow#')"));
				</cfoutput> 
			</cfif>
		}
		else
		{
			alert('Sistemde böyle bir seri bulunmamaktadır');
			return false;	
		}
		
		if(is_serial == 0)
		{
			alert('Girilen seri no bu belgedeki bir ürüne ait değildir');	
			return false;
		}
				
		document.getElementById('add_new_serial_no').value = '';
	}
</script>
