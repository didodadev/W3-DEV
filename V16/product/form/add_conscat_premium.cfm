<cf_get_lang_set module_name="product">
<cfset xml_page_control_list = 'premium_level_count'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="product.popup_add_conscat_premium">
<cfif not isdefined("premium_level_count")>
	<cfset premium_level_count = 3>
</cfif>
<cfquery name="get_cons_cat" datasource="#dsn#">
	SELECT * FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37691.Üye Kategorisi Prim Tanımları'></cfsavecontent>
	<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_premium" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_conscat_premium">
			<cfif isdefined("attributes.campaign_id")>
				<input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#attributes.campaign_id#</cfoutput>">
			<cfelseif isdefined("attributes.catalog_id")>
				<input type="hidden" name="catalog_id" id="catalog_id" value="<cfoutput>#attributes.catalog_id#</cfoutput>">
			<cfelseif isdefined("attributes.promotion_id")>	
				<input type="hidden" name="promotion_id" id="promotion_id" value="<cfoutput>#attributes.promotion_id#</cfoutput>">
			<cfelseif isdefined("attributes.prom_rel_id")>	
				<input type="hidden" name="prom_rel_id" id="prom_rel_id" value="<cfoutput>#attributes.prom_rel_id#</cfoutput>">
			</cfif>
			<cfset record_emp = 0>
			
				<cfoutput query="get_cons_cat">
					<cfif isdefined("attributes.campaign_id")>
						<cfquery name="get_row_premium" datasource="#dsn3#">
							SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #attributes.campaign_id# AND CONSCAT_ID = #get_cons_cat.conscat_id# ORDER BY PREMIUM_LEVEL,ISNULL((SELECT HIERARCHY FROM #dsn_alias#.CONSUMER_CAT CC WHERE CC.CONSCAT_ID =REF_MEMBER_CAT),0)
						</cfquery>
					<cfelseif isdefined("attributes.catalog_id")>
						<cfquery name="get_row_premium" datasource="#dsn3#">
							SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE CATALOG_ID = #attributes.catalog_id# AND CONSCAT_ID = #get_cons_cat.conscat_id# ORDER BY PREMIUM_LEVEL,ISNULL((SELECT HIERARCHY FROM #dsn_alias#.CONSUMER_CAT CC WHERE CC.CONSCAT_ID =REF_MEMBER_CAT),0)
						</cfquery>
					<cfelseif isdefined("attributes.promotion_id")>	
						<cfquery name="get_row_premium" datasource="#dsn3#">
							SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE PROMOTION_ID = #attributes.promotion_id# AND CONSCAT_ID = #get_cons_cat.conscat_id# ORDER BY PREMIUM_LEVEL,ISNULL((SELECT HIERARCHY FROM #dsn_alias#.CONSUMER_CAT CC WHERE CC.CONSCAT_ID =REF_MEMBER_CAT),0)
						</cfquery>
					<cfelseif isdefined("attributes.prom_rel_id")>
						<cfquery name="get_row_premium" datasource="#dsn3#">
							SELECT * FROM SETUP_CONSCAT_PREMIUM WHERE PROM_REL_ID = #attributes.prom_rel_id# AND CONSCAT_ID = #get_cons_cat.conscat_id# ORDER BY PREMIUM_LEVEL,ISNULL((SELECT HIERARCHY FROM #dsn_alias#.CONSUMER_CAT CC WHERE CC.CONSCAT_ID =REF_MEMBER_CAT),0)
						</cfquery>
					</cfif>
					<cf_seperator id="level_process_detail#conscat_id#" header="#conscat#" is_closed="1">
					<cf_grid_list id="level_process_detail#conscat_id#">
						<thead>
							<tr>
								<th width="20"><a style="cursor:pointer;" onclick="add_row(#conscat_id#);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th style="width:100px;"><cf_get_lang dictionary_id ='37692.Seviye'></th>
								<th style="width:170px;"><cf_get_lang dictionary_id ='37693.Bağlı Üye Net Satış Başlangıç'></th>
								<th style="width:170px;"><cf_get_lang dictionary_id ='37694.Bağlı Üye Net Satış Bitiş'></th>
								<th><cf_get_lang dictionary_id='37194.Bağlı Üye Kategorisi'></th>
								<th style="width:100px;"><cf_get_lang dictionary_id="37689.Bağlı Üye Sayısı"></th>
								<th><cf_get_lang dictionary_id ='37695.Prim Oranı'> %</th>
							</tr>
						</thead>
						<tbody  id="table1_#conscat_id#" name="table1_#conscat_id#">	
							<input type="hidden" name="record_num_#conscat_id#" id="record_num_#conscat_id#" value="#get_row_premium.recordcount#">
							<cfloop query="get_row_premium">
							<tr height="20" class="color-row" id="frm_row_#conscat_id#_#get_row_premium.currentrow#">
								<td class="text-center"><input type="hidden" name="row_kontrol_#conscat_id#_#get_row_premium.currentrow#" id="row_kontrol_#conscat_id#_#get_row_premium.currentrow#" value="1"><a style="cursor:pointer" onclick="sil(#conscat_id#,#get_row_premium.currentrow#);"><i class="fa fa-minus"></i></a></td>
								<td>
									<div class="form-group">
										<select name="premium_level_#conscat_id#_#get_row_premium.currentrow#" id="premium_level_#conscat_id#_#get_row_premium.currentrow#" style="width:100px;">
											<cfloop from="1" to="#premium_level_count#" index="jj">
												<option value="#jj#" <cfif jj eq get_row_premium.premium_level>selected</cfif>>#jj#. <cf_get_lang dictionary_id='56192.Seviye'></option>
											</cfloop>
											<option value="-1" <cfif -1 eq get_row_premium.premium_level>selected</cfif>>Sonsuzluk Primi</option>
										</select>
									</div>
								</td>
								<td>
									<input type="text" name="min_member_sale_#conscat_id#_#get_row_premium.currentrow#" id="min_member_sale_#conscat_id#_#get_row_premium.currentrow#" value="#Tlformat(get_row_premium.min_net_sale)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event));isNumber(this)" class="moneybox">
									#session.ep.money#
								</td>
								<td>
									<input type="text" name="max_member_sale_#conscat_id#_#get_row_premium.currentrow#" id="max_member_sale_#conscat_id#_#get_row_premium.currentrow#" value="#Tlformat(get_row_premium.max_net_sale)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
									#session.ep.money#
								</td>	
								<td>
									<select name="ref_member_cat_#conscat_id#_#get_row_premium.currentrow#" id="ref_member_cat_#conscat_id#_#get_row_premium.currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_cons_cat">
											<option value="#conscat_id#" <cfif conscat_id eq get_row_premium.ref_member_cat>selected</cfif>>#conscat#</option>
										</cfloop>
									</select>
								</td>	
								<td>
									<input type="text" name="ref_member_count_#conscat_id#_#get_row_premium.currentrow#" id="ref_member_count_#conscat_id#_#get_row_premium.currentrow#" value="#get_row_premium.ref_member_count#" style="width:100px;" onkeyup="isNumber(this,event);" class="moneybox">
								</td>				
								<td>
									<input type="text" name="premium_ratio_#conscat_id#_#get_row_premium.currentrow#" id="premium_ratio_#conscat_id#_#get_row_premium.currentrow#" value="#Tlformat(get_row_premium.premium_ratio)#" style="width:80px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								</td>
							</tr>
							<cfif get_row_premium.recordcount>
								<cfset record_emp = get_row_premium.record_emp>
								<cfset record_date = get_row_premium.record_date>
							</cfif>
							</cfloop>
						</tbody>
					</cf_grid_list>
				</cfoutput>
				<cf_box_footer>
					<div class="col col-6">
						<cfif record_emp gt 0>
							<cf_record_info query_name="get_row_premium">
						</cfif>
					</div>
					<div class="col col-6">
						<cf_workcube_buttons is_delete='0' is_upd='1' add_function='kontrol()' type_format="1">
					</div>
				</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function open_process(conscat_id)
	{
		gizle_goster(eval("document.getElementById('level_process_detail" + conscat_id + "')"));
	}
	<cfoutput>
	function sil(conscat_id,sy)
	{
		var my_element=eval("add_premium.row_kontrol_"+conscat_id+'_'+sy);
		my_element.value=0;
		var my_element=eval("frm_row_"+conscat_id+'_'+sy);
		my_element.style.display="none";
	}
	function add_row(conscat_id)
	{
		document.getElementById('record_num_'+conscat_id).value = parseFloat(document.getElementById('record_num_'+conscat_id).value) + 1;
		row_count = document.getElementById('record_num_'+conscat_id).value;
		var newRow;
		var newCell;
		newRow = eval("table1_"+conscat_id).insertRow();
		newRow.setAttribute("name","frm_row_"+conscat_id+'_'+row_count);
		newRow.setAttribute("id","frm_row_"+conscat_id+'_'+row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+conscat_id+'_'+row_count+'" value="1"><a href="javascript://" onclick="sil('+conscat_id+','+row_count+');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		a = '<div class="form-group"><select name="premium_level_'+conscat_id+'_'+row_count+'" class="text">';
		<cfloop from="1" to="#premium_level_count#" index="jj">		
			a += '<option value="#jj#">#jj#. Seviye</option>';
		</cfloop>
		a += '<option value="-1">Sonsuzluk Primi</option>';
		newCell.innerHTML =a+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="min_member_sale_'+conscat_id+'_'+row_count+'" value="'+commaSplit(0)+'" style="width:120px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"> #session.ep.money#';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="max_member_sale_'+conscat_id+'_'+row_count+'" value="'+commaSplit(0)+'" style="width:120px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"> #session.ep.money#';
		newCell = newRow.insertCell(newRow.cells.length);
		a = '<div class="form-group"><select name="ref_member_cat_'+conscat_id+'_'+row_count+'" class="text">';
		a += '<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
		<cfloop query="get_cons_cat">		
			a += '<option value="#conscat_id#">#conscat#</option>';
		</cfloop>
		newCell.innerHTML =a+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ref_member_count_'+conscat_id+'_'+row_count+'" value="0" style="width:100px;" class="moneybox" onKeyUp="isNumber(this);">';		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="premium_ratio_'+conscat_id+'_'+row_count+'" value="0" style="width:80px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">';
	}
	</cfoutput>
	function kontrol()
	{
		<cfoutput query="get_cons_cat">
			for(i=1;i<=eval("document.add_premium.record_num_"+#conscat_id#).value;i++)
			{
				deger1 = eval("document.add_premium.min_member_sale_"+#conscat_id#+'_'+i).value;
				deger2 = eval("document.add_premium.max_member_sale_"+#conscat_id#+'_'+i).value
				if(deger1.substring(0,1) == '-' || deger2.substring(0,1) == '-')
				{
					alert('Sadece pozitif değer girebilirsiniz!');
					return false;
				}
				eval("document.add_premium.min_member_sale_"+#conscat_id#+'_'+i).value = filterNum(eval("document.add_premium.min_member_sale_"+#conscat_id#+'_'+i).value);
				eval("document.add_premium.max_member_sale_"+#conscat_id#+'_'+i).value = filterNum(eval("document.add_premium.max_member_sale_"+#conscat_id#+'_'+i).value);
				eval("document.add_premium.premium_ratio_"+#conscat_id#+'_'+i).value = filterNum(eval("document.add_premium.premium_ratio_"+#conscat_id#+'_'+i).value);
			}
		</cfoutput>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
