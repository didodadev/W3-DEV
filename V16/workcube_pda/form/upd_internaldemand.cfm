<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfparam name="attributes.company_id" default=""><!--- papoğlu --->
<cfparam name="attributes.consumer_id" default=""><!--- papoğlu --->
<cfparam name="attributes.to_position_code" default="10"><!--- papoğlu - Muhammet Demirtaş--->
<cfparam name="attributes.position_code" default="Muhammet Demirtaş"><!--- papoğlu --->

<cfquery name="GET_INTERNALDEMAND" datasource="#DSN3#">
	SELECT 
    	I.DEPARTMENT_IN, 
        I.DEPARTMENT_OUT, 
        I.LOCATION_OUT, 
        I.LOCATION_IN,
        I.INTERNALDEMAND_STAGE,
        IR.QUANTITY,
        IR.I_ROW_ID,
       	SB.STOCK_ID,
		SB.BARCODE 
    FROM 
    	INTERNALDEMAND I,
        INTERNALDEMAND_ROW IR,
		STOCKS_BARCODES SB 
    WHERE 
    	SB.STOCK_ID = IR.STOCK_ID AND
    	I.INTERNAL_ID = IR.I_ID AND
    	I.INTERNAL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internal_id#">
</cfquery>

<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
    SELECT 
        DEPARTMENT_ID,
        DEPARTMENT_HEAD,
        BRANCH_ID 
    FROM 
    	DEPARTMENT
    WHERE
        IS_STORE <> 2 AND 
        BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">)
</cfquery>

<cfquery name="GET_LOCATIONS" datasource="#DSN#">
    SELECT 
    	COMMENT,
        LOCATION_ID,
        DEPARTMENT_ID 
    FROM 
    	STOCKS_LOCATION 
</cfquery>
                
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:30px;">
		<td class="headbold">İç Talep Güncelle</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">
	<tr>
		<td class="color-row">
			<cfform name="add_internaldemand" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_internaldemand" enctype="multipart/form-data">  
			<table>            	
				<!---<cfset proc_cat = 12>
				<cfif cgi.HTTP_HOST contains 'pdacube'>
                	<cfset proc_cat = 55>
				</cfif> --->
                <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.internal_id#</cfoutput>" />
				<!---<input type="hidden" name="process_stage" id="process_stage" value="<cfoutput>#proc_cat#</cfoutput>">---><!--- PAPOĞLUNDAKİ DEĞER: 12 --->				
                <input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="<cfif isdefined('pro_material_id_list') and len(pro_material_id_list)><cfoutput>#pro_material_id_list#</cfoutput></cfif>">
                <input type="hidden" name="subject" id="subject" maxlength="200" value="<cfoutput>#session.pda.name# #session.pda.surname# - #dateformat(now(),'dd/mm/yyyy')# #timeformat(now(),'HH:mm:ss')#</cfoutput>">
				<input type="hidden" name="priority" id="priority" value="1">
                <input type="hidden" name="notes" id="notes" value="">
                <input type="hidden" name="from_position_code" id="from_position_code" value="<cfoutput>#session.pda.userid#</cfoutput>">
                <input type="hidden" name="from_position_name" id="from_position_name" value="<cfoutput>#get_emp_info(session.pda.userid,0,0)#</cfoutput>">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                <input type="hidden" name="to_position_code" id="to_position_code" value="<cfoutput>#attributes.to_position_code#</cfoutput>">
                <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#attributes.position_code#</cfoutput>">
				<input type="hidden" name="ship_method" id="ship_method" value="">
				<input type="hidden" name="ship_method_name" id="ship_method_name" value="">                
				<input type="hidden" name="project_id" id="project_id" value="">
				<input type="hidden" name="project_head" id="project_head" value="">                
				<input type="hidden" name="target_date" id="target_date" value="">
				<input type="hidden" name="ref_no" id="ref_no" value="">
				<input type="hidden" name="is_active" id="is_active" value="1">			
				<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_bskt.recordcount#</cfoutput>">
				<cfoutput query="get_money_bskt">
					<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
					<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
					<input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
					<input type="hidden" name="#money_type#" id="#money_type#" value="#rate2#">
					<cfif money_type is 'TL'>
						<input type="hidden" name="basket_money" id="basket_money" value="TL">
						<input type="hidden" name="basket_rate1" id="basket_rate1" value="#rate1#">
						<input type="hidden" name="basket_rate2" id="basket_rate2" value="#rate2#">
					</cfif>
				</cfoutput>
                <cfif isDefined("get_internaldemand.department_out") and len(get_internaldemand.department_out)>
                    <cfquery name="GET_DEPARTMENT" dbtype="query">
                        SELECT 
                        	* 
                        FROM 
                        	GET_DEPARTMENTS 
                        WHERE 
                        	DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.department_out#">
                    </cfquery>
                    <cfif get_department.recordcount>
						<cfset attributes.department_name_out = get_department.department_head>
                    <cfelse>
						<cfset attributes.department_name_out = "">
                    </cfif>
                </cfif>
                <cfif isDefined("get_internaldemand.location_out") and Len(get_internaldemand.location_out)>
                    <cfquery name="GET_LOCATION" dbtype="query">
                        SELECT 
                        	* 
                        FROM 
                        	GET_LOCATIONS 
                        WHERE 
                        	LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.location_out#"> AND 
                            DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.department_out#">
                    </cfquery>
                    <cfif get_location.recordcount>
						<cfset attributes.location_name_out = get_location.comment>
                    <cfelse>
						<cfset attributes.location_name_out = "">
                    </cfif>
                </cfif>
                <cfif isDefined("attributes.department_name_out") and Len(attributes.department_name_out) and isDefined("attributes.location_name_out") and Len(attributes.location_name_out)>
                    <cfset attributes.department_location_out = "#attributes.department_name_out# - #attributes.location_name_out#">
				<cfelse>
                	<cfset attributes.department_location_out = "">
                </cfif>
                <cfif isDefined("get_internaldemand.department_in") and len(get_internaldemand.department_in)>
                    <cfquery name="GET_DEPARTMENT" dbtype="query">
                        SELECT 
                        	* 
                        FROM 
                        	GET_DEPARTMENTS 
                        WHERE 
                        	DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.department_in#">
                    </cfquery>
                    <cfif get_department.recordcount>
						<cfset attributes.department_name_in = get_department.department_head>
                    <cfelse>
						<cfset attributes.department_name_in = "">
                    </cfif>
                </cfif>
                <cfif isDefined("get_internaldemand.location_in") and Len(get_internaldemand.location_in)>
                    <cfquery name="GET_LOCATION" dbtype="query">
                        SELECT 
                        	* 
                        FROM 
                        	GET_LOCATIONS 
                        WHERE 
                        	LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.location_in#"> AND 
                            DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_internaldemand.department_in#">
                    </cfquery>
                    <cfif get_location.recordcount>
						<cfset attributes.location_name_in = get_location.comment>
                    <cfelse>
						<cfset attributes.location_name_in = "">
                    </cfif>
                </cfif>
                <cfif isDefined("attributes.department_name_in") and Len(attributes.department_name_in) and isDefined("attributes.location_name_in") and Len(attributes.location_name_in)>
                    <cfset attributes.department_location_in = "#attributes.department_name_in# - #attributes.location_name_in#">
				<cfelse>
                	<cfset attributes.department_location_in = "">				
                </cfif>
                <tr style="display:none;">
                	<td><cf_workcube_process is_upd='0' select_value='#get_internaldemand.internaldemand_stage#' process_cat_width='130' is_detail='1'></td>
                </tr>
				<tr>
					<td style="width:70px;">Çıkış Depo *</td>
					<td style="width:200px;">
						<!--- <cfinclude template="../query/get_department_location.cfm"> --->
						<cfoutput>
						<input type="hidden" name="location_id" id="location_id" value="#get_internaldemand.location_out#">
						<input type="hidden" name="department_id" id="department_id" value="#get_internaldemand.department_out#">
						<input type="hidden" name="branch_id" id="branch_id" value="">
						<cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
						<cfinput type="text" name="department_location" id="department_location" value="#attributes.department_location_out#" required="yes" message="#message#" style="width:120px;">
						<a href="javascript://" onclick="get_turkish_letters_div('document.add_ship_dispatch.department_location','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onclick="get_location_all_div('open_all_div','add_ship_dispatch','branch_id','department_id','location_id','department_location');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</cfoutput>
					</td>
			  	</tr>
			  	<tr>
					<td>Giriş Depo*</td>
					<td><cfoutput>
						<input type="hidden" name="location_in_id" id="location_in_id" value="#get_internaldemand.location_in#">
						<input type="hidden" name="department_in_id" id="department_in_id" value="#get_internaldemand.department_in#">
						<input type="hidden" name="branch_in_id" id="branch_in_id" value="">
						<cfsavecontent variable="message">Depo Seçmelisiniz!</cfsavecontent>
						<cfinput type="text" name="department_location_in" id="department_location_in" value="#attributes.department_location_in#" required="yes" message="#message#" style="width:120px;">
						<a href="javascript://" onclick="get_turkish_letters_div('document.add_ship_dispatch.department_location_in','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onclick="get_location_all_div('open_all_div','add_ship_dispatch','branch_in_id','department_in_id','location_in_id','department_location_in');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
						</cfoutput>
					</td>
			  	</tr> 
				<tr style="height:25px;">
					<td colspan="2"><div id="open_all_div"></div></td>
				</tr>
				<tr>
					<td style="width:70px;">Barkod</td>
					<td>
						<div id="show_prod_dsp">
							<input type="text" name="search_product" id="search_product" style="width:120px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.Use_onKeyDown_Enter>if(event.keyCode == 13)</cfif> {return add_barcode2(document.getElementById('row_count').value,add_internaldemand.search_product.value);}">
							<a href="javascript://" onclick="add_barcode2(document.getElementById('row_count').value,add_internaldemand.search_product.value);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
							<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_internaldemand.recordcount#</cfoutput>">
						</div>												
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="mydiv">
                            <cfloop from="1" to="200" index="no">
                                <cfif no lte get_internaldemand.recordcount>
                                    <cfoutput>
                                        <div id="n_my_div#no#">
                                            <input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="1">
                                            <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0"></a>
                                            <input type="text" name="barcode#no#" id="barcode#no#" value="#get_internaldemand.barcode[no]#" style="width:150px;">
                                            <input type="text" name="amount#no#" id="amount#no#" value="#get_internaldemand.quantity[no]#" class="moneybox" onkeyup="FormatCurrency(this,2);" style="width:30px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <input type="hidden" name="sid#no#" id="sid#no#" value="#get_internaldemand.stock_id[no]#">
                                            <input type="hidden" name="product_name#no#" id="product_name#no#" value="">
                                            <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="">
                                            <input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="#get_internaldemand.i_row_id[no]#">
                                        </div><!---  onBlur="stock_reserve(#no#)" --->
                                    </cfoutput>
                                <cfelse>
                                    <cfoutput>
                                        <div id="n_my_div#no#" style="display:none">
                                            <input  type="hidden" name="row_kontrol#no#" id="row_kontrol#no#" value="0">
                                            <a href="javascript://" onclick="sil(#no#);"><img  src="images/delete_list.gif" border="0"></a>
                                            <input type="text" name="barcode#no#" id="barcode#no#" value="" style="width:150px;">
                                            <input type="text" name="amount#no#" id="amount#no#" value="1" class="moneybox" onkeyup="FormatCurrency(this,2);" style="width:30px;" <cfif session.pda.use_onkeydown_enter>onkeydown<cfelse>onchange</cfif>="<cfif session.pda.use_onkeydown_enter>if(event.keyCode == 13)</cfif> clear_barcode();">
                                            <input type="hidden" name="sid#no#" id="sid#no#" value="">
                                            <input type="hidden" name="product_name#no#" id="product_name#no#" value="">
                                            <input type="hidden" name="wrk_row_relation_id#no#" id="wrk_row_relation_id#no#" value="">
                                            <input type="hidden" name="action_row_id#no#" id="action_row_id#no#" value="">
                                        </div><!---  onBlur="stock_reserve(#no#)" --->
                                    </cfoutput>
                                </cfif>
                            </cfloop>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">						
						<div id="show_buttons" style="display:none">
							<table cellpadding="0" cellspacing="1" border="0" style="width:98%;">
								<tr>
									<td><cf_get_lang_main no='80.Toplam'>Tutar (YTL)</td>
									<td>Toplam Adet</td>
									<td>Toplam Çeşit</td>
								</tr>
								<tr>
									<td>
										<input type="hidden" name="nettotal_usd" id="nettotal_usd" value="0" readonly="yes" class="moneybox" style="width:80px;"> <!--- USD --->
										<input type="text" name="nettotal" id="nettotal" value="0" readonly="yes" class="moneybox" style="width:100px;"> <!--- YTL --->
										<input type="hidden" name="sa_discount" id="sa_discount" value="0"><!---  onChange="FormatCurrency(this);toplam_hesapla();" class="moneybox"  style="width:80px;" --->
										<input type="hidden" name="basket_net_total_usd" id="basket_net_total_usd" value="0"><!---  readonly="yes" class="moneybox" style="width:80px;" --->
										<input type="hidden" name="basket_net_total" id="basket_net_total" value="0" > <!--- readonly="yes" class="moneybox" style="width:80px;" --->
									</td>
									<td>
										<input type="text" name="net_adet" id="net_adet" value="" readonly="yes" class="moneybox" style="width:60px;">
									</td>
									<td>
										<input type="text" name="net_cesit" id="net_cesit" value="" readonly="yes" class="moneybox" style="width:60px;">
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>	
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="Güncelle" onclick="return control_inputs();">
					</td>
				</tr>
			</table>
        	</cfform>
		</td>
	</tr>
</table>
<br/>

<cfinclude template="basket_js_functions.cfm"><!--- basket_js_functions_internaldemand kaldirilarak ortak hale getirildi FBS 20111001 --->
<cf_get_lang_set module_name="correspondence"><!--- sayfanin en ustunde acilisi var --->
