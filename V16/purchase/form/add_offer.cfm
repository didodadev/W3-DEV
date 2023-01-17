<cf_xml_page_edit fuseact="purchase.detail_offer_ta">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_taxes.cfm">
<cfinclude template="../query/get_setup_priority.cfm">
<cfinclude template="../query/get_offer_currencies.cfm">
<cfparam name="attributes.revision_offer_id" default="">
<cfquery name="Ger_Our_Comp_Info" datasource="#dsn#">
    SELECT IS_RATE_FROM_PRE_PAPER FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">           	
</cfquery>
<cfscript>
	if(Ger_Our_Comp_Info.Is_Rate_From_Pre_Paper eq 1)
	{
		if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id))
			session_basket_kur_ekle(process_type:1,table_type_id:7,action_id:attributes.internaldemand_id);
		else if(isdefined('attributes.offer_id') and len(attributes.offer_id))
			session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.offer_id);
		else if(isdefined('attributes.for_offer_id') and len(attributes.for_offer_id))
			session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.for_offer_id);
		else
			session_basket_kur_ekle(process_type:0);
	}
	else
	{
		if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id))
			session_basket_kur_ekle(process_type:1,table_type_id:7,action_id:0);
		else if(isdefined('attributes.offer_id') and len(attributes.offer_id))
			session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:0);
		else if(isdefined('attributes.for_offer_id') and len(attributes.for_offer_id))
			session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:0);
		else
			session_basket_kur_ekle(process_type:0);
	}
</cfscript>
<cfif isdefined('attributes.internal_row_info')>
	<cfscript>
		internald_row_amount_list ="";
		internald_row_id_list ="";
		internaldemand_id_list ="";
		for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
		{
			temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
			if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
			{
				internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
				internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
				if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
					internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
			}
		}
	</cfscript>
</cfif>
<cfif isdefined('attributes.offer_id') and len(attributes.offer_id) or isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>
	<cfinclude template="../query/get_offer_detail.cfm">
</cfif>
<cfif isdefined('attributes.offer_id') and len(attributes.offer_id) or isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>
	<cfscript>
		attributes.offer_head = get_offer_detail.offer_head;
		attributes.offer_detail = get_offer_detail.offer_detail;
		attributes.ship_method_id = get_offer_detail.ship_method;
		attributes.paymethod_id = get_offer_detail.paymethod;
		attributes.card_paymethod_id = get_offer_detail.card_paymethod_id;
		attributes.comission_rate = get_offer_detail.card_paymethod_rate;
		attributes.priority = get_offer_detail.priority_id;
		attributes.offer_currency = get_offer_detail.offer_currency;
		attributes.ref_no = get_offer_detail.ref_no;
		if(len(get_offer_detail.deliver_place) and len(get_offer_detail.location_id))
		{
			location_info_ = get_location_info(get_offer_detail.deliver_place,get_offer_detail.location_id,1,1);
			attributes.branch_id = listlast(location_info_,',');
			attributes.deliver_state_id = get_offer_detail.deliver_place;
			attributes.deliver_loc_id = get_offer_detail.location_id;
			attributes.deliver_state = listfirst(location_info_,',');
		}
		else
		{
			attributes.branch_id = "";
			attributes.deliver_state_id = "";
			attributes.deliver_loc_id = "";
			attributes.deliver_state = "";
		}
		attributes.project_id = get_offer_detail.project_id;
		attributes.work_id = get_offer_detail.work_id;
		if(not isdefined("attributes.deliverdate"))
		attributes.deliverdate = dateformat(get_offer_detail.deliverdate,dateformat_style);
		attributes.startdate = dateformat(get_offer_detail.startdate,dateformat_style);
		attributes.finishdate = dateformat(get_offer_detail.finishdate,dateformat_style);
		attributes.offer_finishdate = dateformat(get_offer_detail.offer_finishdate,dateformat_style);
		attributes.is_public_zone = get_offer_detail.is_public_zone;
		attributes.is_partner_zone = get_offer_detail.is_partner_zone;
	</cfscript>
<cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) or (isdefined("internaldemand_id_list") and len(internaldemand_id_list))>
	<cfquery name="get_internaldemand_info" datasource="#dsn3#">
		SELECT 
			I.SUBJECT,
			I.PROJECT_ID,
			I.DEPARTMENT_IN,
			I.LOCATION_IN,
			I.SHIP_METHOD,
			I.TARGET_DATE,
			I.NOTES,
			I.REF_NO,
			I.PRIORITY,
			I.WORK_ID,
			I.INTERNAL_NUMBER
		 FROM 
			 INTERNALDEMAND I
		 WHERE 
			<cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
				I.INTERNAL_ID = #attributes.internaldemand_id#
			<cfelseif Len(internaldemand_id_list)>
				I.INTERNAL_ID IN (#internaldemand_id_list#)
			</cfif>
	</cfquery>
	<cfset internal_number_list = listdeleteduplicates(valuelist(get_internaldemand_info.INTERNAL_NUMBER,','))>
	<cfscript>
		attributes.offer_head = get_internaldemand_info.subject;
		attributes.offer_detail = get_internaldemand_info.notes;
		attributes.ship_method_id = get_internaldemand_info.ship_method;
		attributes.paymethod_id = "";
		attributes.card_paymethod_id = "";
		attributes.comission_rate = "";
		attributes.priority = get_internaldemand_info.priority;
		attributes.offer_currency = "";
		attributes.ref_no = get_internaldemand_info.ref_no;
		if(len(get_internaldemand_info.department_in) and len(get_internaldemand_info.location_in))
		{
			location_info_ = get_location_info(get_internaldemand_info.department_in,get_internaldemand_info.location_in,1,1);
			attributes.branch_id = listlast(location_info_,',');
			attributes.deliver_state_id = get_internaldemand_info.department_in;
			attributes.deliver_loc_id = get_internaldemand_info.location_in;
			attributes.deliver_state = listfirst(location_info_,',');
		}
		else
		{
			location_info_ = "";
			attributes.branch_id = "";
			attributes.deliver_state_id = "";
			attributes.deliver_loc_id = "";
			attributes.deliver_state = "";
		}
		if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
			attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
		else
			attributes.project_id = "";
		if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
			attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
		else
			attributes.work_id = "";
		attributes.deliverdate = dateformat(get_internaldemand_info.target_date,dateformat_style);
		attributes.startdate = "";
		attributes.finishdate = "";
		attributes.offer_finishdate = "";
		attributes.is_public_zone = "";
		attributes.is_partner_zone = "";
	</cfscript>
<cfelse>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='38526.Teklif İstiyoruz'></cfsavecontent>
	<cfscript>
		attributes.offer_head = "#message#";
		attributes.offer_detail = "";
		attributes.ship_method_id = "";
		attributes.paymethod_id = "";
		attributes.card_paymethod_id = "";
		attributes.comission_rate = "";
		attributes.priority = "";
		attributes.offer_currency = "";
		attributes.ref_no = "";
		attributes.branch_id = "";
		attributes.deliver_state_id = "";
		attributes.deliver_loc_id = "";
		attributes.deliver_state = "";
		if(not isdefined("attributes.deliverdate"))
		attributes.deliverdate = "";
		attributes.startdate = "";
		attributes.finishdate = "";
		attributes.offer_finishdate = "";
		attributes.is_public_zone = "";
		attributes.is_partner_zone = "";
	</cfscript>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=purchase.emptypopup_add_offer" enctype="multipart/form-data">
				<cf_catalystHeader>
				<cf_basket_form id="add_offer">
					<cfoutput>
						<input type="hidden" name="revision_offer_id" id="revision_offer_id" value="#attributes.revision_offer_id#">
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_offer">
						<input type="hidden" name="old_company_ids" id="old_company_ids" value="<cfif isdefined('attributes.company_ids') and len(attributes.company_ids)>#attributes.company_ids#</cfif>">
						<input type="hidden" name="old_partner_ids" id="old_partner_ids" value="<cfif isdefined('attributes.partner_ids') and len(attributes.partner_ids)>#attributes.partner_ids#</cfif>">
						<input type="hidden" name="offer_id" id="offer_id" value="<cfif isdefined('attributes.offer_id') and len(attributes.offer_id)>#attributes.offer_id#</cfif>">
						<input type="hidden" name="for_offer_id" id="for_offer_id" value="<cfif isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>#attributes.for_offer_id#</cfif>">
						<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#"> 
						<input type="hidden" name="search_process_date" id="search_process_date" value="deliverdate">
						<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="<cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and get_internaldemand_info.recordcount><cfoutput>#attributes.internaldemand_id#</cfoutput><cfelseif isdefined("internaldemand_id_list") and len(internaldemand_id_list) and get_internaldemand_info.recordcount><cfoutput>#internaldemand_id_list#</cfoutput></cfif>">
					</cfoutput>
					<cfinclude template="add_offer_noeditor.cfm">
				</cf_basket_form>
				<cfif isdefined('attributes.internal_row_info')><!--- iç talepler listesinden olusturulacaksa --->
					<cfset attributes.basket_related_action = 1> 
				</cfif>
				<cfset attributes.basket_id=5>
				<cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
					<cfset attributes.id = attributes.internaldemand_id>
					<cfset attributes.basket_sub_id = 5>
				<cfelseif isdefined("attributes.internal_row_info") and len(attributes.internal_row_info)>
					<cfset attributes.internal_row_info = attributes.internal_row_info>
					<cfset attributes.basket_sub_id = 5>
				<cfelseif isdefined("attributes.sId") and len(attributes.sId) and isdefined("attributes.pType") and len(attributes.pType)>
					<cfset attributes.sId = attributes.sId>
					<cfset attributes.pType = attributes.pType>
					<cfset attributes.basket_sub_id = 5>
				<cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)>
					<cfset attributes.offer_id = url.offer_id>
				<cfelseif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id) and not isdefined("attributes.file_format")>
					<cfset attributes.offer_id = url.for_offer_id>
				<cfelseif not isdefined("attributes.file_format")>
					<cfset attributes.form_add = 1>
				<cfelse>
					<cfset attributes.basket_sub_id = 22>
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
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
		if(stock_id_list_ != '')
		{
			var get_emp_ozel_code = wrk_query("SELECT SC.COMPANY_ID COMPANY_ID FROM SETUP_COMPANY_STOCK_CODE SC,STOCKS S WHERE SC.STOCK_ID = S.STOCK_ID AND S.STOCK_ID IN ("+stock_id_list_+") AND SC.IS_ACTIVE = 1","dsn1");
			if(get_emp_ozel_code.recordcount)
				document.all.comp_id_list.value = get_emp_ozel_code.COMPANY_ID;
		}
	}
</script>
