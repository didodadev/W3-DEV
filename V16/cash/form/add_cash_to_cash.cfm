<cf_get_lang_set module_name="cash">
<cf_xml_page_edit fuseact="cash.add_cash_to_cash">
<cf_papers paper_type="cash_to_cash">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box closable="0">
	<cfform name="add_cash_to_cash" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_cash_to_cash">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<input type="hidden" name="my_fuseaction" id="my_fuseaction" value="<cfoutput>#fusebox.fuseaction#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</cfoutput>
					</label>
					<div class="col col-8 col-xs-12"><cf_workcube_process_cat slct_width="150"></div>
				</div>
				<div class="form-group" id="item-from_cash_id">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='49792.Kasasından'> *</cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_Cash name="FROM_CASH_ID" id="FROM_CASH_ID" cash_status="1" currency_branch="0" onChange="kur_ekle_f_hesapla('FROM_CASH_ID');"><!---  yetkili olan kasa --->
					</div>
				</div>
				<div class="form-group" id="item-to_cash_id">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='49741.Kasasına'> *</cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_Cash name="TO_CASH_ID" id="TO_CASH_ID" is_virman= "1" cash_status="1" currency_branch="0" onChange="kur_ekle_f_hesapla('FROM_CASH_ID');change_currency_info();"><!--- tüm kasalar ---> 
					</div>
							
				</div>
				<div class="form-group" id="item-project_head">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57416.Proje'></cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden"  name="project_id" id="project_id"/>
								<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
							</cfoutput>
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-paper_code">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57880.Belge No'></cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="paper_number" maxlength="50" value="#paper_code & '-' & paper_number#">
					</div>
				</div>
				<div class="form-group" id="item-action_date">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57742.Tarih'> *</cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
							<cfinput name="ACTION_DATE" type="text" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#"  style="width:150px;" onBlur="change_money_info('add_cash_to_cash','ACTION_DATE');">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info"></span>
						</div>
					</div>
				</div>
				
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-cash_action_value">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57673.Tutar'> *</cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'></cfsavecontent>
						<cfinput type="text" name="CASH_ACTION_VALUE" value="" onBlur="kur_ekle_f_hesapla('FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event,2,'float'));" required="yes" message="#message#" class="moneybox" style="width:150px;">
					</div>
				</div>
				<div class="form-group" id="item-other_cash_act_value">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='58056.Dövizli Tutar'></cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="" onBlur="kur_ekle_f_hesapla('FROM_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event,2,'float'));" class="moneybox" style="width:150px;">
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-xs-12">
						<cfoutput><cf_get_lang dictionary_id='57629.Açıklama'></cfoutput>
					</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="56293.200 Karakterden Fazla Yazmayınız!"></cfsavecontent>
						<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px; height:60px;"maxlength="200" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-12 bold"><cf_get_lang dictionary_id='49802.İşlem Para Br.'></label>
					<div class="col col-12 scrollContent scroll-x2">
					<cfscript>f_kur_ekle(process_type:0,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_cash_to_cash',select_input:'FROM_CASH_ID',is_disable='1');</cfscript>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
</div>
<script type="text/javascript">
	change_currency_info();
	function unformat_fields()
	{
		add_cash_to_cash.CASH_ACTION_VALUE.value = filterNum(add_cash_to_cash.CASH_ACTION_VALUE.value);
		add_cash_to_cash.OTHER_CASH_ACT_VALUE.value = filterNum(add_cash_to_cash.OTHER_CASH_ACT_VALUE.value);
		add_cash_to_cash.system_amount.value = filterNum(add_cash_to_cash.system_amount.value);
		for(var i=1;i<=add_cash_to_cash.kur_say.value;i++)
		{
			eval('add_cash_to_cash.txt_rate1_' + i).value = filterNum(eval('add_cash_to_cash.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_cash_to_cash.txt_rate2_' + i).value = filterNum(eval('add_cash_to_cash.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	kur_ekle_f_hesapla('FROM_CASH_ID');
	function change_currency_info()
	{
		new_kur_say = document.all.kur_say.value;
		var currency_type_2 = list_getat(add_cash_to_cash.TO_CASH_ID.options[add_cash_to_cash.TO_CASH_ID.options.selectedIndex].value,2,';');
		for(var i=1;i<=new_kur_say;i++)
		{
			if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_type_2)
				eval('document.all.rd_money['+(i-1)+']').checked = true;
		}
		kur_ekle_f_hesapla('FROM_CASH_ID');
	}	
	function kontrol()
	{
		var dsn = '<cfoutput>#dsn2#</cfoutput>';
		if(!paper_no_control(0,dsn,'CASH_ACTIONS','ACTION_TYPE_ID*33','PAPER_NO','CASH_TO_CASH',0,'paper_number')) return false;
		if(!chk_process_cat('add_cash_to_cash')) return false;
		if(!check_display_files('add_cash_to_cash')) return false;
		if(!chk_period(add_cash_to_cash.ACTION_DATE,'İşlem')) return false;
		
		if ((document.add_cash_to_cash.ACTION_DETAIL.value.length) > 250)
		{
			alert("<cf_get_lang dictionary_id ='49916.Açıklama bilgisi 250 karakterden fazla girilemez'>!");
			return false;
		}
		if(document.add_cash_to_cash.TO_CASH_ID.value == document.add_cash_to_cash.FROM_CASH_ID.value)				
		{
			alert("<cf_get_lang dictionary_id='49762.Seçtiğiniz Kasalar Aynı!'>");		
			return false; 
		}
		kur_ekle_f_hesapla('FROM_CASH_ID');
		return unformat_fields();
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
