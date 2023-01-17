<cf_xml_page_edit fuseact="account.form_upd_bill_opening">
	<cfparam name="attributes.is_excel" default="">
<cfinclude template="../query/get_acc_card.cfm">
<cfquery name="GET_ACCOUNT_ROWS_MAIN" dbtype="query">
	SELECT * FROM GET_ACCOUNT_ROWS_MAIN_ALL ORDER BY ACCOUNT_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('main',1344)#" add_href="openBoxDraggable('#request.self#?fuseaction=account.popup_add_bill_opening_other&add_bill_other')">
		<cfif attributes.fuseaction eq 'account.popup_upd_bill_opening'>
			<cfset my_url='emptypopup_upd_bill_opening_act'>
		<cfelse>
			<cfset my_url='upd_bill_opening'>
		</cfif>
		<cfform name="add_bill_opening" action="#request.self#?fuseaction=account.#my_url#&card_id=#attributes.card_id#" method="post">
			<cf_box_elements vertical="1">
				<div class="form-group col col-2">
					<label><cf_get_lang dictionary_id="61806.İşlem Tipi">*</label>
					<cf_workcube_process_cat process_cat="#get_account_card.card_cat_id#" slct_width="122">				
				</div>
				
				<div class="form-group col col-2">
					<label><cf_get_lang dictionary_id='57946.Fiş No'></label>
					<input type="text" readonly name="bill_no" id="bill_no" width="380" value="<cfoutput>#get_account_card.bill_no#</cfoutput>">
				</div>

				<div class="form-group col col-4">
					<label><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<textarea  name="bill_detail" id="bill_detail"><cfoutput>#get_account_card.CARD_DETAIL#</cfoutput></textarea>
				</div>	
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_account_card">
				<cfif isdefined("get_account_rows_main")>
					<cf_workcube_buttons type_format='1' is_upd='1' is_delete="0" add_function="control_defaul_process()">
				<cfelse>
					<cf_workcube_buttons type_format='1' is_upd='0'>					
				</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<div id="table_list_div"><cfinclude template="add_bill_frame_opening.cfm"></div>
</div>
<script type="text/javascript">
	function control_defaul_process()
	{
		if(!chk_process_cat('add_bill_opening')) return false;
		var get_default_process_ = wrk_safe_query('acc_new_ctrl_process','dsn3');
		var selected_ptype = document.add_bill_opening.process_cat.options[document.add_bill_opening.process_cat.selectedIndex].value;
		if(selected_ptype.length)
		{
			if(document.add_bill_opening.old_process_cat_id!=undefined && document.add_bill_opening.old_process_cat_id.value!='') 
			{
				if(document.add_bill_opening.old_process_cat_id.value ==get_default_process_.PROCESS_CAT_ID && get_default_process_.PROCESS_CAT_ID!=selected_ptype)
				{
					alert("<cf_get_lang dictionary_id='59048.Standart Açılış Fişinin İşlem Kategorisi Değiştirilemez'>!");
					return false;
				}
				else if(document.add_bill_opening.old_process_cat_id.value!=get_default_process_.PROCESS_CAT_ID && get_default_process_.PROCESS_CAT_ID==selected_ptype)//farklı islem kategordeki acılıs fisine default islem kat. seciliyor
				{
				
					var get_default_acc_card = wrk_safe_query('acc_ctrl_acc_card','dsn2',0,get_default_process_.PROCESS_CAT_ID);
					if(get_default_acc_card.recordcount)
					{
						alert("<cf_get_lang dictionary_id='59047.Default İşlem Kategorisi Seçilemez. Bu Kategoride Sisteme Kayıtlı Açılış Fişi Bulunmaktadır'>!");
						return false;
					}
					
				}
			}
		}
	}
</script>
