<cf_get_lang_set module_name="objects2">
<cfif isdefined("session.ep")>
	<cfif year(now()) neq session.ep.period_year>
		<script type="text/javascript">
			alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
			window.location.href='<cfoutput>#request.self#?fuseaction=myhome.welcome</cfoutput>';
		</script>
	</cfif>
</cfif>
<cfif not isdefined('session.ep')>
	<cfinclude template="../login/send_login.cfm">
</cfif>
<cfquery name="GET_ALL_PRE_ORDER_ROWS" datasource="#DSN3#">
	SELECT 
		TO_CONS,
		TO_PAR,
		TO_COMP
	FROM
		ORDER_PRE_ROWS
	WHERE
		<cfif isdefined("session.pp")>
            RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
        <cfelseif isdefined("session.ww.userid")>
            RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
        <cfelseif isdefined("session.ep.userid")>
            RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
        <cfelse>
            1=2 AND
        </cfif>
		STOCK_ID IS NOT NULL
</cfquery>

<cfif isdefined("session.ww.userid") or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
	<cfquery name="GET_BLOCK_INFO" datasource="#DSN#">
		SELECT 
			BG.BLOCK_GROUP_PERMISSIONS AS BLOCK_STATUS
		FROM 
			COMPANY_BLOCK_REQUEST CBL,
			BLOCK_GROUP BG 
		WHERE 
			CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND 
			CBL.BLOCK_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			ISNULL(CBL.BLOCK_FINISH_DATE,GETDATE()) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			<cfif isdefined("session.ww.userid")>
                CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelse>
                CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>

	</cfquery>
	<cfquery name="GET_REF_MEMBERS" datasource="#DSN#">
		SELECT 
			CONSUMER_ID 
		FROM 
			CONSUMER 
		WHERE 
			<cfif isdefined("session.ww.userid")>
                REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelse>
                REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
	</cfquery>
<cfelse>
	<cfset get_block_info.recordcount = 0>
</cfif>
<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,2,',') eq 1)>
	<table>
		<tr>
			<td>Blok kaydınız olduğu için sipariş kaydı yapamazsınız !</td>
		</tr>
	</table>
</cfif>
<cfif not isDefined('session.ep.userid')>
	<cfset attributes.partner_id=''>
    <cfset attributes.company_id=''>
</cfif>
<cfif not isdefined("attributes.consumer_id")>
	<cfset attributes.consumer_id=''>
</cfif>
<cfscript>
	if(get_all_pre_order_rows.recordcount gt 0)
	{
		basket_express_cons_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_cons)),'numeric','asc');
		basket_express_partner_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_par)),'numeric','asc');
		basket_express_comp_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_comp)),'numeric','asc');
	}
	else
	{
		basket_express_cons_list='';
		basket_express_partner_list='';
		basket_express_comp_list='';
	}
	//if(not isdefined("session.ep.userid") and len(basket_express_cons_list))
	if(len(basket_express_cons_list))
	{
		attributes.consumer_id=listfirst(basket_express_cons_list);
	}
	else if(len(basket_express_partner_list) and len(basket_express_comp_list))
	{
		attributes.partner_id=listfirst(basket_express_partner_list);
		attributes.company_id=listfirst(basket_express_comp_list);
	}
	else if(isdefined("session.pp.userid"))
	{
		attributes.partner_id=session.pp.userid;
		attributes.company_id=session.pp.company_id;
	}
	else if(isdefined("session.ww.userid") )
		attributes.consumer_id=session.ww.userid;
	
	if(isdefined("session.ww"))
		session.ww.basket_cons_id = attributes.consumer_id;
</cfscript>
<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,2,',') eq 0) or get_block_info.recordcount eq 0>
	<cfform name="add_basket_exp" action="#request.self#?fuseaction=objects2.emptypopup_add_basket_row_expres" method="post" enctype="multipart/form-data">
    	<input type="hidden" name="fuseact" id="fuseact" value="<cfoutput>#attributes.fuseaction#<cfif isDefined('attributes.company_id') and len(attributes.company_id)>&company_id=#attributes.company_id#</cfif><cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif><cfif isDefined('attributes.partner_id') and len(attributes.partner_id)>&partner_id=#attributes.partner_id#</cfif></cfoutput>">
		<input type="hidden" name="use_prod_code_type" id="use_prod_code_type" value="<cfif isdefined('attributes.x_use_product_code_type') and attributes.x_use_product_code_type eq 1>1<cfelseif isdefined('attributes.x_use_product_code_type') and attributes.x_use_product_code_type eq 2>2<cfelse>3</cfif>">
		<input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#now()#</cfoutput>">
        <input type="hidden" name="is_stock_change" id="is_stock_change" value="<cfif isDefined('attributes.is_stock_change') and len(attributes.is_stock_change)><cfoutput>#attributes.is_stock_change#</cfoutput></cfif>">
		<input type="hidden" name="is_zero_stock_dept" id="is_zero_stock_dept" value="<cfif isdefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept)><cfoutput>#attributes.is_zero_stock_dept#</cfoutput></cfif>">
		<table>
			<cfif isdefined('session.ww.userid') or isdefined('session.pp.userid') or isdefined('session.ep.userid')>
				<tr>
					<td class="expres-title"><cfif isDefined('attributes.company_id') and len(attributes.company_id)>Kurumsal Üye<cfelse><cf_get_lang_main no ='174.Bireysel Üye'></cfif></td>
					<td class="expres-title">
						<cfoutput>
						<input type="hidden" name="basket_expres_consumer_id" id="basket_expres_consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
						<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
						</cfoutput>
						<cfif isdefined('session.ww.userid')>
							<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
								SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							</cfquery>
							<!--- BK 20100120 cfqueryparam cf_sql_time kullanımı sorun cikartti degistirme --->
							<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
								SELECT 
									CAMP_ID,
									CAMP_HEAD
								FROM 
									CAMPAIGNS 
								WHERE 
									CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
									CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							</cfquery>
							
							<cfif get_camp_id.recordcount>
								<cfquery name="GET_LEVEL" datasource="#DSN3#">
									SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
								</cfquery>
								<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
							<cfelse>
								<cfset ref_count = 0>
							</cfif>
							<cfquery name="GET_REF_INFO" datasource="#DSN#">
								SELECT 
									CC.IS_REF_ORDER 
								FROM 
									CONSUMER C,
									CONSUMER_CAT CC
								WHERE 
									C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
									C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">                              
							</cfquery>
							<cfif get_ref_info.recordcount and get_ref_info.is_ref_order eq 0>
								: <cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>
								<input type="hidden" name="consumer" id="consumer" <cfif len(basket_express_cons_list) or len(basket_express_partner_list) or get_ref_members.recordcount eq 0>readonly</cfif> value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>">
							<cfelse>
								<input type="text" name="consumer" id="consumer" <cfif len(basket_express_cons_list) or len(basket_express_partner_list) or get_ref_members.recordcount eq 0>readonly</cfif> value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>" <cfif not len(basket_express_cons_list) and not len(basket_express_partner_list) and get_ref_members.recordcount gt 0>onFocus="AutoComplete_Create('consumer','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_objects2','\'2\',<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,5,',') eq 1) or get_ref_info.recordcount and get_ref_info.is_ref_order eq 0>\'2\'<cfelse>\'0\'</cfif>,\'\',\'2\',\'1\',\'0\',\'<cfoutput>#ref_count#</cfoutput>\'','CONSUMER_ID','basket_expres_consumer_id','add_basket_exp','3','150');"</cfif>>
							</cfif>
						<cfelseif isdefined('session.pp')>
							<input type="text" name="consumer" id="consumer" style="width:120px;" onfocus="AutoComplete_Create('consumer','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'0\',\'0\',\'\',\'2\',\'0\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID','company_id,partner_id,basket_expres_consumer_id','add_basket_exp','3','250');" value="<cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput>" <cfif len(basket_express_cons_list) or len(basket_express_partner_list)>readonly</cfif> autocomplete="off">
						<cfelse>
                        	<cfif isDefined('attributes.partner_id') and len(attributes.partner_id)>
                                <cfquery name="GET_PARTNER_NAME" datasource="#DSN#">
                                    SELECT
                                        COMPANY_PARTNER_NAME,
                                        COMPANY_PARTNER_SURNAME
                                    FROM
                                        COMPANY_PARTNER
                                     WHERE
                                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
                                </cfquery>
                            </cfif>
							<input type="text" name="consumer" id="consumer" style="width:120px;" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,0,0)# - #get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</cfoutput></cfif>" <cfif not len(basket_express_cons_list) and not len(basket_express_partner_list)>onFocus="AutoComplete_Create('consumer','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_objects2','\'2\',\'0\',\'\',\'2\',\'1\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID','company_id,partner_id,basket_expres_consumer_id','add_basket_exp','3','250');"</cfif>  <cfif len(basket_express_cons_list) or len(basket_express_partner_list)>readonly</cfif>>
						</cfif>
					</td>
				</tr>
			</cfif>
			<cfif isdefined("session.ep")>
				<td class="form-title"><cf_get_lang_main no ='1384.Sipariş Veren'></td>
				<td>
					<input type="hidden" name="sales_member_id" id="sales_member_id" value="">
					<input type="hidden" name="sales_cons_id" id="sales_cons_id" value="<cfif isdefined('attributes.sales_cons_id') and len(attributes.sales_cons_id)><cfoutput>#attributes.sales_cons_id#</cfoutput></cfif>">
					<input type="hidden" name="sales_member_type" id="sales_member_type" value="<cfif isdefined('attributes.sales_cons_id') and len(attributes.sales_cons_id)>consumer</cfif>">
					<input type="text" name="sales_member" id="sales_member" style="width:120px;" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'2\',\'0\',\'0\',\'0\',\'2\',\'0\'','PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','sales_member_id,sales_cons_id,sales_member_type','add_basket_exp','3','250');" value="<cfif isdefined('attributes.sales_cons_id') and len(attributes.sales_cons_id)><cfoutput>#get_cons_info(attributes.sales_cons_id,0,0)#</cfoutput></cfif>" autocomplete="off">
				  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_cons&field_partner=add_basket_exp.sales_member_id&field_consumer=add_basket_exp.sales_cons_id&field_name=add_basket_exp.sales_member&field_type=add_basket_exp.sales_member_type<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=3','list','popup_list_pars');"><img src="/images/plus_list.gif"  align="absmiddle" border="0"></a>
				</td>
			</cfif>
			<cfif isdefined("attributes.x_excel_import") and attributes.x_excel_import eq 1 and get_all_pre_order_rows.recordcount eq 0>
				<tr id="excel_form1">
					<td class="expres-title"><cf_get_lang_main no='56.Belge'> *</td>
					<td class="expres-title"><input type="file" name="uploaded_file" id="uploaded_file" style="width:185px;"></td>
				</tr>
			</cfif>
		</table>
		<table>
			<cfif isdefined("attributes.x_excel_import") and attributes.x_excel_import eq 1 and get_all_pre_order_rows.recordcount eq 0>						
				<tr>
					<td colspan="3" id="excel_form2"><input type="submit" style="width:180px;" value="Basketi Doldur" onclick="add_excel_row();"></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="3" id="excel_form3">
					<input type="button" style="width:100px;" value="<cf_get_lang_main no ='154.Ürün Araştır'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_view_product_list</cfoutput>','wide2','popup_view_product_list');">&nbsp;
					<input type="submit" style="width:100px;"  value="Sepetime Ekle" onclick="return kontrol();">
				</td>
			</tr>
			<tr>
				<td>
					<table id="table_list">
						<tr>
							<td></td>
							<td class="expres-title"><cf_get_lang_main no='1388.Ürün Kodu'></td>
							<td class="expres-title"><cf_get_lang_main no ='223.Miktar'></td>
							<td></td>
						</tr>
						<cfoutput>
							<cfloop from="1" to="20" index="i">
								<cfif isdefined('attributes.is_stock_change') and attributes.is_stock_change eq 1> 
									<tr id="check_stock_#i#" title="Lütfen ürün kodunu girdikten sonra ENTER tuşuna basınız açılan pencereden sipariş etmek istediğiniz ürünü seçiniz.">
										<td>#i#</td>
										<td>
											<input type="hidden" name="product_code#i#" id="product_code#i#" value="" />
											<input type="text" name="special_code#i#" id="special_code#i#" value="" style="width:150px;" onkeypress="if(event.keyCode==13){check_stock(#i#); return false};"/>
											<div id="check_stock_layer#i#" style="position:absolute; width:150px; "></div>
										</td>
										<td style="width:50px;"><input type="text" name="amount#i#" id="amount#i#" class="moneybox" maxlength="2" autocomplete="off" onkeyup="return(FormatCurrency(isNumber(this,event),0));" style="width:50px;"></td>
										<td style="width:25px;"><a href="javascript://" onclick="delRow(#i#);"><img src="/images/delete_list.gif" align="absmiddle" title="Satırı Temizle" border="0"></a></td>
									</tr>
								<cfelse>
									<tr>
										<td>#i#</td>
										<td><input type="text" name="product_code#i#" id="product_code#i#" value="" autocomplete="off" style="width:100px;"></td>
										<td><input type="text" name="amount#i#" id="amount#i#" class="moneybox" maxlength="2" autocomplete="off" onkeyup="return(FormatCurrency(isNumber(this,event),0));" style="width:50px;"></td>
										<td><a href="javascript://" onclick="delRow(#i#);"><img src="/images/delete_list.gif" align="absmiddle" title="Satırı Temizle" border="0"></a></td>
									</tr>
								</cfif>
							</cfloop>
						</cfoutput>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center"><a href="javascript://" onclick="addRow();" class="add_row_sepet" title="<cf_get_lang_main no ='295.Satır Ekle'>"></a></td>
			</tr>
			<input type="hidden" name="rowCount" id="rowCount" value="">
		</table>
	</cfform>
	<div id="show_list_page" style="display:none"></div>
	<div id="upd_cons" style="display:none"></div>
	<iframe src="" name="add_excel_form" id="add_excel_form" width="1" height="1"></iframe> 
	<script type="text/javascript">
		rowCount = 20;
		document.getElementById('rowCount').value = rowCount;
		
		function control_member()
		{
			<cfif isdefined('session.ep')>
				if(document.getElementById('basket_expres_consumer_id').value=='' &&  document.getElementById('partner_id').value=='' && document.getElementById('company_id').value=='')
				{
					alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'>!");
					document.getElementById('consumer').focus();
					return false;
				}
			</cfif>
			if(document.getElementById('basket_expres_consumer_id').value != '')
			{
				var valid_date = document.getElementById('search_process_date').value;
				var listParam = document.getElementById('basket_expres_consumer_id').value + "*" + valid_date;
				var get_cons_info = wrk_safe_query("obj2_get_cons_info",'dsn',0,listParam);
				if(get_cons_info.recordcount > 0 && list_getat(get_cons_info.BLOCK_GROUP_PERMISSIONS[0],2,',') == 1)
				{
					alert("Seçitiğiniz Temsilcinin Blok Kaydı Olduğu İçin Sipariş Kaydedemezsiniz !");
					document.getElementById('basket_expres_consumer_id').value = '';
					document.getElementById('consumer').value = '';
					document.getElementById('consumer').select();
					return false;
				}
				else
				{
					<cfif isdefined("session.ww")>
						AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_ajax_upd_cons_session&cons_id='+document.getElementById('basket_expres_consumer_id').value,'upd_cons',1);
					</cfif>
				}
			}
			return true;
		}
		
		function add_stock_reserve_(reserve_type_,stock_code,amount,row_id)
		{
			<cfif fusebox.use_stock_speed_reserve>
				if((amount != '' && stock_code!='') || reserve_type_ ==0)
				{
					AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_ajax_add_reserved_stock&reserve_type_='+reserve_type_+'&product_row_id_='+row_id+'&r_stock_code='+stock_code+'&r_amount='+amount+'&use_prod_code_type='+document.add_basket_exp.use_prod_code_type.value,'show_list_page',1);
				}
			</cfif>
		}
		function add_excel_row()
		{   
			add_basket_exp.action='';
			if(document.getElementById('uploaded_file').value=='')
			{
				alert("Belge Seçiniz !");
				return false;
			}
			if(document.getElementById('consumer').value=='' || (document.getElementById('basket_expres_consumer_id').value=='' &&  document.getElementById('partner_id').value=='' && document.getElementById('company_id').value==''))
			{	
				alert("<cf_get_lang_main no ='303.Önce Üye Seçiniz'>!");
				document.add_basket_exp.consumer.focus();
				return false;
			}
			else
			{  
				document.add_basket_exp.target = 'add_excel_form';
				document.add_basket_exp.submit();
				add_basket_exp.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_ajax_add_row_from_excel';
			}
		}
		
		function kontrol()
		{   
			if(!control_member()) return false;
			for (var j=1; j < rowCount; j++)
			{
				if ((!document.getElementById('product_code'+j).value == '') && (((document.getElementById('amount'+j).value == '')) || ((document.getElementById('amount'+j).value == 0))))
				{
					alert((j) + ".<cf_get_lang no ='1449.Satırda Miktar Girmelisiniz'> !");
					return false;
				}
				else if ((document.getElementById('product_code'+j).value == '') && ( (!document.getElementById('amount'+j).value == '')))
				{
					alert((j) + ".<cf_get_lang no ='1450.Satırda Ürün Kodu Girmelisiniz'> !");
					return false;
				}
				if (document.getElementById('product_code'+j).value != '' && document.getElementById('amount'+j).value != '')
					add_stock_reserve_(1,document.getElementById('product_code'+j).value,document.getElementById('amount'+j).value ,j);
			}
		}
		
		function addRow()
		{
			rowCount++;
			document.add_basket_exp.rowCount.value = rowCount;
			var newRow;
			var newCell;
			newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = rowCount;
			newCell = newRow.insertCell(newRow.cells.length);
			
			<cfif isdefined('attributes.is_stock_change') and attributes.is_stock_change eq 1>
				newCell.innerHTML =  '<input type="hidden" name="product_code'+ rowCount +'" id="product_code'+ rowCount +'" tabindex="1" autocomplete="off" style="width:100px;"><input type="text" name="special_code'+ rowCount +'" id="special_code'+ rowCount +'" tabindex="1" autocomplete="off" style="width:100px;" onkeyup="check_stock('+ rowCount +');"><div id="check_stock_layer'+ rowCount +'" style="position:absolute; width:150px; "></div>';
				newCell = newRow.insertCell(newRow.cells.length);
			
				newCell.innerHTML = '<input type="text" name="amount'+ rowCount +'" id="amount'+ rowCount +'" value="" tabindex="1" class="moneybox" maxlength="2" onkeyup="return(FormatCurrency(this,event));" style="width:50px;">';
				newCell = newRow.insertCell(newRow.cells.length);
			
				newCell.innerHTML = '<a href="javascript://" onClick="delRow(' + rowCount + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
			<cfelse>
				newCell.innerHTML =  '<input type="text" name="product_code'+ rowCount +'" id="product_code'+ rowCount +'" tabindex="1" autocomplete="off" style="width:100px;">';
				newCell = newRow.insertCell(newRow.cells.length);
			
				newCell.innerHTML = '<input type="text" name="amount'+ rowCount +'" id="amount'+ rowCount +'" value="" tabindex="1" class="moneybox" maxlength="2" onkeyup="return(FormatCurrency(this,event));" style="width:50px;">';
				newCell = newRow.insertCell(newRow.cells.length);
			
				newCell.innerHTML = '<a href="javascript://" onClick="delRow(' + rowCount + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
			</cfif>
		}
		
		function delRow(yer)
		{   
			temp_element = eval("document.getElementById('product_code"+yer+"')");
			temp_element1 = eval("document.getElementById('amount"+yer+"')");
			temp_element.value = '';
			temp_element1.value = '';
			/*if(eval("document.add_basket_exp.special_code"+yer).value != undefined || eval("document.add_basket_exp.special_code"+yer).value != '')*/
			specialCode = eval("document.getElementById('special_code"+yer+"')");
			specialCode.value = '';	
		}

		function check_stock(no)
		{
			specialCodeValue = eval("document.getElementById('special_code"+no+"')").value;
			specialCodeValueLength = specialCodeValue.length;
			specialCode = encodeURIComponent(specialCodeValue);
			if(specialCodeValueLength >= 5)
			{
				div_name_ = eval("check_stock_layer" + no);
				goster(div_name_);
				
				AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_get_basket_expres_stock&use_prod_code_type=<cfoutput>#attributes.x_use_product_code_type#</cfoutput>&satirNo='+no+'&specialCode='+specialCode,"check_stock_layer" + no,1);
			}
		}
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
