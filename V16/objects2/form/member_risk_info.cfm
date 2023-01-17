<cfif isdefined("session.ep")>
	<cfquery name="CHECK_COMPANY_RISK_TYPE" datasource="#DSN#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
		SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO FROM OUR_COMPANY_INFO WHERE COMP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
<cfelse>
	<cfquery name="CHECK_COMPANY_RISK_TYPE" datasource="#DSN#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
		SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO FROM OUR_COMPANY_INFO WHERE COMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
	</cfquery>
</cfif>
<table>
	<cfif isdefined('attributes.is_risc_bakiye') and attributes.is_risc_bakiye eq 1>
		<tr>
			<td class="txtbold" style="width:135px;"><cf_get_lang_main no ='177.Bakiye'></td>
			<td nowrap="nowrap"><input type="text" name="member_bakiye" id="member_bakiye" value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
		</tr>
	</cfif>
	<tr id="project_risk_" style="display:none;">
		<td class="txtbold"><cf_get_lang_main no="1446.Bağlantı Bakiyesi"></td>
		<td nowrap="nowrap"><input type="text" name="project_risk_limit_" id="project_risk_limit_" value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
	</tr>
	<tr id="prj_useable_limit_" style="display:none;">
		<td class="txtbold"><cf_get_lang_main no="1481.Bağlantı Kullanılabilir Limit"></td>
		<td nowrap="nowrap"><input type="text" name="prj_useable_limit" id="prj_useable_limit" value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
	</tr>		
	<tr>
		<td class="txtbold"><cf_get_lang_main no ='1210.Açık Siparişler'></td>
		<td nowrap="nowrap"><input type="text" name="member_order_value" id="member_order_value"  value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
	</tr>	
	<tr>
		<td class="txtbold"><cf_get_lang_main no ='1208.Üye Kullanılabilir Limit'></td>
		<td nowrap="nowrap"><input type="text" name="member_use_limit" id="member_use_limit" value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
	</tr>
	<tr style="color:#FF0000">
		<td><b><cf_get_lang_main no ='1209.Limit Aşımı'></b></td>
		<td nowrap="nowrap"><input type="text" name="limit_diff_value" id="limit_diff_value" value="<cfoutput>#tlformat(0)#</cfoutput>" class="box" disabled readonly> <cfoutput>#session_base.money#</cfoutput></td>
	</tr>
</table>
<script type="text/javascript">
	function set_project_risk_limit() /*proje baglantılarına gore bakıyeyi ve proje kullanılabilir limitini hesaplar*/
	{ 
		var prj_remainder_info=0;
		var open_order_limit=0;
		var prj_ship_total_=0;
		var total_prj_limit_=0; 
		if(document.getElementById('project_attachment')!=undefined && document.getElementById('project_attachment').value!='')
		{ 
			var project_id_=document.getElementById('project_attachment').value;
			if(project_id_!=undefined && project_id_ !='')
			{  
				if(document.getElementById('company_id')!=undefined && document.getElementById('company_id').value!='')
				{
					var listParam = document.getElementById('company_id').value + "*" + project_id_;
					var str_member_prj_risk_ = 'obj2_get_member_prj_risk_3';
					
					var listParam2 = project_id_ + "*" + document.getElementById('company_id').value + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";
					var str_prj_order_risk_='obj2_get_prj_order_risk_5';

					var listParam3 = document.getElementById('company_id').value + "*" + project_id_ + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
					var str_prj_ship_total_ = 'obj2_get_prj_ship_total_5';
				}
				else if(document.getElementById('consumer_id')!=undefined && document.getElementById('consumer_id').value!='')
				{
					var listParam = document.getElementById('consumer_id').value + "*" + project_id_;
					var str_member_prj_risk_ = 'obj2_get_member_prj_risk_4';
					
					var listParam2 = project_id_ + "*" + document.getElementById('consumer_id').value + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";
					var str_prj_order_risk_='obj2_get_prj_order_risk_6';
					
					var listParam3 = document.getElementById('consumer_id').value + "*" + project_id_ + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
					var str_prj_ship_total_ = 'obj2_get_prj_ship_total_6';
				}
				if(str_member_prj_risk_!=undefined)
				{
					var get_member_prj_risk = wrk_safe_query(str_member_prj_risk_,'dsn2',0,listParam);
					if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
					{
						prj_remainder_info=get_member_prj_risk.BAKIYE; //proje bakiyesi display edilen
						total_prj_limit_=(-1)*get_member_prj_risk.BAKIYE //proje bakiyesi hesaplamalarda kullanılan
					}
				}
				if(str_prj_order_risk_!=undefined)
				{
					var get_prj_order_risk_=wrk_safe_query(str_prj_order_risk_,'dsn2',0,listParam2);
					if(get_prj_order_risk_.recordcount!= 0 && get_prj_order_risk_.NETTOTAL!='' )
						open_order_limit=parseFloat(get_prj_order_risk_.NETTOTAL);
				}
				if(str_prj_ship_total_!=undefined)
				{
					var get_prj_ship_total_=wrk_safe_query(str_prj_ship_total_,'dsn2',0,listParam3);
					if(get_prj_ship_total_.recordcount!= 0 && get_prj_ship_total_.NETTOTAL!='' )
						prj_ship_total_=parseFloat(get_prj_ship_total_.NETTOTAL);
				}
			}
			//document.all.order_detail.value=str_prj_order_risk_;
			document.getElementById('project_risk_').style.display='';
			document.getElementById('project_risk_limit_').value=commaSplit(prj_remainder_info);	
			document.getElementById('prj_useable_limit_').style.display='';		
			document.getElementById('prj_useable_limit').value=commaSplit(total_prj_limit_-open_order_limit-prj_ship_total_);	
		 }
	}
	
	function find_risk()
	{
		var order_amount = 0;
		var ship_amount = 0;
		if(document.getElementById('consumer_id').value != '')
		{
			var get_consumer_cc_2 = wrk_safe_query("obj2_get_consumer_cc_2",'dsn2',0,document.getElementById('consumer_id').value);
			if(get_consumer_cc_2.recordcount)
			{	
				toplam_risk_2 = parseFloat(get_consumer_cc_2.TOTAL_RISK_LIMIT) - (parseFloat(get_consumer_cc_2.BAKIYE) + parseFloat(get_consumer_cc_2.SENET_KARSILIKSIZ) + parseFloat(get_consumer_cc_2.CEK_KARSILIKSIZ) + parseFloat(get_consumer_cc_2.CEK_ODENMEDI) + parseFloat(get_consumer_cc_2.SENET_ODENMEDI) + parseFloat(get_consumer_cc_2.KEFIL_SENET_ODENMEDI) + parseFloat(get_consumer_cc_2.KEFIL_SENET_KARSILIKSIZ));
				bakiye_2 = parseFloat(get_consumer_cc_2.BAKIYE);
			}
			else
			{
				toplam_risk_2 = 0;
				bakiye_2=0;
			}
			var listParam4 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + document.getElementById('consumer_id').value + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";
			var listParam5 = document.getElementById('consumer_id').value + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
			<cfif check_company_risk_type.recordcount neq 0 and check_company_risk_type.is_detailed_risk_info eq 1> /*detaylı risk takibi yapılıyor*/
				
				var risk_order='obj2_get_company_orders';
				
				var risk_ship = 'obj2_get_company_ship';
			<cfelse>
				var risk_order = 'obj2_get_company_orders_3';
				var risk_ship = '';
			</cfif>
		}
		else if(document.getElementById('company_id').value != '')
		{
			if(document.getElementById('add_member_button') != undefined)
				document.getElementById('add_member_button').style.display="none";
			if(document.getElementById('paper_button') != undefined)
				document.getElementById('paper_button').style.display='';
			var get_company_cc_2 = wrk_safe_query("obj2_get_company_cc_2",'dsn2',0,document.getElementById('company_id').value);
			if(get_company_cc_2.recordcount)
			{
				toplam_risk_2 = parseFloat(get_company_cc_2.TOTAL_RISK_LIMIT) - (parseFloat(get_company_cc_2.BAKIYE) + parseFloat(get_company_cc_2.SENET_KARSILIKSIZ) + parseFloat(get_company_cc_2.CEK_KARSILIKSIZ) + parseFloat(get_company_cc_2.CEK_ODENMEDI) + parseFloat(get_company_cc_2.SENET_ODENMEDI));
				bakiye_2 = parseFloat(get_company_cc_2.BAKIYE);
			}
			else
			{
				toplam_risk_2 = 0;
				bakiye_2=0;
			}
			var listParam4 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + document.getElementById('company_id').value + "*" + "<cfoutput>#dsn3_alias#</cfoutput>";	
			var listParam5 = document.getElementById('company_id').value + "*" + "<cfoutput>#dsn2_alias#</cfoutput>";
			<cfif check_company_risk_type.recordcount neq 0 and check_company_risk_type.is_detailed_risk_info eq 1> /*detaylı risk takibi yapılıyor*/
				
				var risk_order='obj2_get_company_orders_2';
		
				var risk_ship = 'obj2_get_company_ship_2';
			<cfelse>
				var risk_order = 'obj2_get_company_orders_4';
				var risk_ship ='';
			</cfif>
		}
		else
		{
			toplam_risk_2 = 0;
			bakiye_2=0;
		}
		
		if(risk_order != undefined && risk_order!='')
		{
			var get_company_orders = wrk_safe_query(risk_order,'dsn3',0,listParam4);
			if(get_company_orders.recordcount)
			{
				document.getElementById('member_order_value').value = commaSplit(get_company_orders.NETTOTAL);
				order_amount = parseFloat(get_company_orders.NETTOTAL);
			}
			else
				document.getElementById('member_order_value').value = commaSplit(0);;
		}
		else
			document.getElementById('member_order_value').value = commaSplit(0);
			
		if(risk_ship!=undefined && risk_ship!='')
		{
			var get_company_ship = wrk_safe_query(risk_ship,'dsn2',0,listParam5);
			if(get_company_ship.recordcount)
				ship_amount = parseFloat(get_company_ship.NETTOTAL);
		}

		if(document.getElementById('member_bakiye') != undefined)
			document.getElementById('member_bakiye').value = commaSplit(bakiye_2);
		if(document.getElementById('member_use_limit') != undefined)	
			document.getElementById('member_use_limit').value = commaSplit(toplam_risk_2-order_amount-ship_amount);
		toplam_limit_hesapla();
	}
	function toplam_limit_hesapla()
	{   
		total_member_limit = filterNum(document.getElementById('member_use_limit').value);
		total_value = parseFloat(document.getElementById('tum_toplam_kdvli').value-document.getElementById('tum_toplam_kdvli_risk').value);
		total_open_order = filterNum(document.getElementById('member_order_value').value);
		total_limit =  total_member_limit;
		if((total_value-total_limit) > 0)
		{
			document.getElementById('limit_diff_value').value = commaSplit(total_value-total_limit);	
			//document.all.risk_info.style.display='';
		}
		else
			document.getElementById('limit_diff_value').value = commaSplit(0);;	
		document.getElementById('limit_diff_value').style.color='FF0000'
		
		if(document.getElementById('lim_sales_credit') != undefined)
		{
			document.getElementById('lim_sales_credit').value = filterNum(document.getElementById('limit_diff_value').value);
			document.getElementById('lim_sales_credit_dsp').value = document.getElementById('limit_diff_value').value;
		}
		set_project_risk_limit();
	}
	find_risk();
</script>
