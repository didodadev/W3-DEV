<cf_xml_page_edit fuseact="purchase.detail_offer_ta">
<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.offer_id);</cfscript>
<cfinclude template="../query/get_offer_detail.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_taxes.cfm">
<cfif not get_offer_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_offer_currencies.cfm">
<cfinclude template="../query/get_setup_priority.cfm">
<cfinclude template="../query/get_stores.cfm">
<cfquery name="get_control_for_offer_id" datasource="#dsn3#">
	SELECT * FROM OFFER WHERE FOR_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>
<cfset attributes.basket_id = 5>
<cfquery name="get_related_internaldemand" datasource="#dsn3#">
    SELECT 
        I.INTERNAL_ID, 
        I.INTERNAL_NUMBER, 
        I.OTHER_MONEY, 
        I.OTHER_MONEY_VALUE,
        I.PROJECT_ID,
        I.WORK_ID,
        I.DEMAND_TYPE,
        CAST(I.INTERNAL_ID AS NVARCHAR) + ';' + CAST(IR.I_ROW_ID AS NVARCHAR) + ';' + OFR.WRK_ROW_RELATION_ID AS INTERNAL_REL_ID
    FROM 
        INTERNALDEMAND I,
        INTERNALDEMAND_ROW IR,
        OFFER_ROW OFR
    WHERE 
    	I.INTERNAL_ID = IR.I_ID AND
        IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
        (
        <cfif Len(get_offer_detail.internaldemand_id)>
            I.INTERNAL_ID IN (#get_offer_detail.internaldemand_id#) OR
        </cfif>
        I.INTERNAL_ID IN (SELECT INTERNALDEMAND_ID FROM INTERNALDEMAND_RELATION_ROW WHERE TO_OFFER_ID IN (#get_offer_detail.offer_id#))
        )
    ORDER BY
        INTERNAL_ID
</cfquery>
<cfset pageHead = "#getlang('main','Satınalma Teklifleri',30048)#: #get_offer_detail.offer_number#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=purchase.emptypopup_upd_offer">
				<cf_basket_form id="detail_offer">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_offer">
						<input type="hidden" name="old_company_ids" id="old_company_ids" value="#get_offer_detail.offer_to#">
						<input type="hidden" name="old_partner_ids" id="old_partner_ids" value="#get_offer_detail.offer_to_partner#">
						<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#">
						<input type="hidden" name="search_process_date" id="search_process_date" value="deliverdate">
						<input type="hidden" name="offer_id" id="offer_id" value="#url.offer_id#">
						<input type="hidden" name="offer_type" id="offer_type" value="ta">
						<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="#listdeleteduplicates(valuelist(get_related_internaldemand.INTERNAL_REL_ID))#">	
					</cfoutput>
					<cfset offer_head_ = Replace(get_offer_detail.offer_head,"'"," ","all")>
					<cfset offer_head_ = Replace(offer_head_,'"',' ','all')>
					<cfinclude template="detail_offer_ta_noeditor.cfm">
				</cf_basket_form>
				<cfset attributes.offer_id = attributes.offer_id>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<!--- <div id="other_details" align="center" style="display:none;">
	<div class="col col-9 col-xs-12">
			<!--- Gelen Teklifler (Teklif Karşılaştırma Tablosu) --->
			<cfif not len(get_offer_detail.for_offer_id)>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='198.Teklif Karşılaştırma Tablosu'></cfsavecontent>
				<cf_box title="#message#" collapsable="1" box_page="#request.self#?fuseaction=purchase.emptypopup_list_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#"></cf_box>
			</cfif>
            <!--- Iliskili Islemler --->
            <cf_get_related_rows action_id='#get_offer_detail.offer_id#' action_type="OFFER" is_popup="1">
			<!--- Iliskili Teminatlar --->
            <cfsavecontent variable="message_work"><cf_get_lang dictionary_id='264.Teminatlar'></cfsavecontent>
			<cf_box 
			closable="0"
			box_page="#request.self#?fuseaction=objects.emptypopup_list_purchase_guarantee&offer_id=#attributes.offer_id#&give_take=0"
			title="#message_work#"></cf_box>
	</div>		
	<div class="col col-3 col-xs-12">
		<!--- Iliskili Teklifler --->
		<cfif not len(get_offer_detail.for_offer_id)>
			<cf_box 
				closable="0"
				add_href="#request.self#?fuseaction=purchase.list_offer&event=add&for_offer_id=#attributes.offer_id#"
				box_page="#request.self#?fuseaction=purchase.ajax_offer_ta&offer_id=#attributes.offer_id#"
				title="#getLang('purchase',22)#">
			</cf_box>
		</cfif>
		<!--- Iliskili Siparisler --->
		<cf_box 
			closable="0"
			unload_body="1"
			box_page="#request.self#?fuseaction=purchase.ajax_related_offer_ta&offer_id=#attributes.offer_id#"
			title="#getLang('purchase',19)#">
		</cf_box>
		<!--- Iliskili Talepler --->
		<cfif get_related_internaldemand.recordcount>
		<cf_box title="#getLang('purchase',20)#">
			<cfif get_related_internaldemand.recordcount>
				<table class="ajax_list">
					<cfoutput query="get_related_internaldemand">
						<tr>
							<td>
								<cfif demand_type eq 0>
									<a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#internal_id#" class="tableyazi" target="_blank">#internal_number#</a> - #TLFormat(other_money_value)# #other_money#
								<cfelse>
									<a href="#request.self#?fuseaction=purchase.list_purchasedemand&event=upd&id=#internal_id#" class="tableyazi" target="_blank">#internal_number#</a> - #TLFormat(other_money_value)# #other_money#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</table>
			</cfif>
			</cf_box>
		</cfif>
		<!--- Iliskili Belgeler --->
		<cf_get_workcube_asset action_section='OFFER_ID' module_id='12' asset_cat_id="-11" action_id='#get_offer_detail.offer_id#' company_id='#session.ep.company_id#'>
		<!--- Iliskili Notlar --->
		<cf_get_workcube_note action_section='OFFER_ID' module_id='12' action_id='#get_offer_detail.offer_id#' company_id='#session.ep.company_id#' style='1'>
		<!--- Değerlendirme Formları---> 
		<cf_get_workcube_form_generator action_type='15' related_type='15' action_type_id='#url.offer_id#' design='1'>
	</div>
</div>	 --->
<script language="JavaScript">
	function sil(no,head)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.popup_del_offer&is_popup=1&offer_id='+ no + '&head='+ head ,'small');
	}
	function unformat_fields()
	{
		return true;
	}
	function kontrol()
	{
		//Bagli Teklifte Tekli Cari Secimi Kontrolu
		if(form_basket.partner_names != undefined && (form_basket.partner_names.value == "" || (form_basket.partner_ids.value == "" && form_basket.consumer_ids.value == "")))
		{
			alert ("<cf_get_lang dictionary_id='38619.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		//Ana Teklifte Teklif Istenenler Kontrolu, Public disinda zorunlu
		else if(form_basket.is_public_zone != undefined && form_basket.is_public_zone.checked == false)
		{
			var count = 0;
			var uzunluk_par = document.getElementsByName('to_par_ids').length;
			for(cind=0;cind<uzunluk_par;cind=cind+1)
			{
				my_obj_par = (uzunluk_par ==1)?document.getElementById('to_par_ids'):document.all.to_par_ids[cind];
				if(my_obj_par.value != '')//silinmemiş ise..
					count++;
			}
			var uzunluk_cons = document.getElementsByName('to_cons_ids').length;
			for(cid=0;cid<uzunluk_cons;cid=cid+1)
			{
				my_obj_cons = (uzunluk_cons ==1)?document.getElementById('to_cons_ids'):document.all.to_cons_ids[cid];
				if(my_obj_cons.value != '')//silinmemiş ise..
					count++;
			}
			if(count == 0)
			{
				alert ("<cf_get_lang dictionary_id='38662.Teklif İstenen Kişileri Seçmediniz'>!");
				return false;
			}
		}
		return (process_cat_control() && saveForm());
	}
	function opener_control()
	{
		var stock_id_list_ = '';
		if(document.all.product_id != undefined && form_basket.product_id.length >1)<!--- birden fazla satır var ise --->
		{
			var bsk_rowCount = document.all.product_id.length; 
			for(var brc=0; brc < bsk_rowCount; brc++)
			{	
				if(brc == 0)
					var stock_id_list_ = document.all.stock_id[brc].value;
				else
					var stock_id_list_ = stock_id_list_ +','+ document.all.stock_id[brc].value;
			}
		}
		else if (document.all.product_id != undefined && document.all.stock_id.value != '')<!--- tek satır var ise --->
		{
			var stock_id_list_ = document.all.stock_id.value;
		}
		var get_emp_ozel_code = wrk_query("SELECT SC.COMPANY_ID COMPANY_ID FROM SETUP_COMPANY_STOCK_CODE SC,STOCKS S WHERE SC.STOCK_ID = S.STOCK_ID AND S.STOCK_ID IN ("+stock_id_list_+") AND SC.IS_ACTIVE = 1","dsn1");
		if(get_emp_ozel_code.recordcount)
			document.all.comp_id_list.value = get_emp_ozel_code.COMPANY_ID;
	}
</script>