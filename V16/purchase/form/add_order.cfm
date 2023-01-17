<div style="display:none;z-index:999;" id="phl_div"></div>
<cf_xml_page_edit fuseact="purchase.detail_order">
<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.active_company_id") and attributes.active_company_id neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='41966.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfscript>
	if (isdefined("url.company_id") and len(url.company_id)){
		attributes.comp_id = url.company_id;
		session_basket_kur_ekle(process_type:0);
	}
	else if(isdefined("url.consumer_id") and len(url.consumer_id)){
		attributes.cons_id = url.consumer_id;
		session_basket_kur_ekle(process_type:0);
	}
	else if(isdefined("attributes.offer_id") and len(attributes.offer_id))
		session_basket_kur_ekle(process_type:1,table_type_id:4,to_table_type_id:3,action_id:attributes.offer_id);
	else if(isdefined("attributes.order_id") and len(attributes.order_id))
		session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);
	else
		session_basket_kur_ekle(process_type:0);
</cfscript>
<!--- Toplu siparis ekranından gelen degerlerin siparise akrarilmasi icin eklendi. --->
<cfparam name="attributes.publishdate" default="">
<cfparam name="attributes.deliverdate" default="">
<cfparam name="attributes.deliver_dept_name" default="">
<cfparam name="attributes.deliver_dept_id" default="">
<cfparam name="attributes.deliver_loc_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.cat_id" default="">
<cfsavecontent variable="order"><cf_get_lang dictionary_id='38521.Siparişimiz'></cfsavecontent>
<cfset attributes.subject = '#order#'>
<cfset attributes.due_date = dateformat(now(),dateformat_style)>
<cfif not isdefined("attributes.order_date")>
	<cfset attributes.order_date = DateFormat(now(),dateformat_style)>
	<cfset attributes.deliverdate = DateFormat(now(),dateformat_style)>
<cfelse>
	<cfset attributes.order_date = attributes.order_date>
	<cfset attributes.deliverdate = attributes.deliverdate>
</cfif>
<cfif isdefined('attributes.from_project_material')>
	<cfinclude template="../../sales/query/get_project_metarial.cfm"><!--- Proje Malzeme İhtiyaç Planından ekleme yapmak için. --->
	<cfif not isdefined('attributes.from_project_material_id')>
		<cfquery name="GET_PRO_MATERIAL_IDS" datasource="#DSN#"><!--- Eğer proje id'si geliyorsa bu projeye ait metarial id'lerini buluyoruz--->
			SELECT PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PROJECT_ID = #attributes.from_project_material#
		</cfquery>
		<cfif GET_PRO_MATERIAL_IDS.recordcount>
			<cfset attributes.from_project_material_id = ValueList(GET_PRO_MATERIAL_IDS.PRO_MATERIAL_ID,',')>
		</cfif>
	<cfelseif isdefined('attributes.from_project_material_id')>
		<cfquery name="GET_PRO_MATERIAL_IDS" datasource="#DSN#">
			SELECT WORK_ID FROM PRO_MATERIAL WHERE PRO_MATERIAL_ID = #attributes.from_project_material_id#
		</cfquery>
		<cfset attributes.work_id =GET_PRO_MATERIAL_IDS.WORK_ID>
	</cfif>
<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)><!--- Siparis Kopyalama --->
	<cfinclude template="../query/get_order_detail.cfm">
	<cfset attributes.subject=get_order_detail.order_head>
	<cfset attributes.order_detail=get_order_detail.order_detail>
	<cfset attributes.project_id =get_order_detail.project_id>
	 <cfset attributes.work_id =get_order_detail.work_id> 
	<cfset ship_method = get_order_detail.ship_method>
	<cfif len(get_order_detail.paymethod)>
		<cfset attributes.paymethod_id = get_order_detail.paymethod>
	<cfelseif len(get_order_detail.card_paymethod_id)>
		<cfset attributes.card_paymethod_id = get_order_detail.card_paymethod_id>
	</cfif>
	<cfset attributes.order_date = DateFormat(get_order_detail.order_date,dateformat_style)>
	<cfset attributes.deliverdate = DateFormat(get_order_detail.deliverdate,dateformat_style)>
	<cfset attributes.publishdate = DateFormat(get_order_detail.publishdate,dateformat_style)>
	<cfset attributes.due_date = DateFormat(get_order_detail.due_date,dateformat_style)>
	<cfif len(get_order_detail.partner_id)>
		<cfset attributes.partner_id = get_order_detail.partner_id>
	<cfelse>
		<cfset attributes.partner_id = "">
	</cfif>
	<cfif len(get_order_detail.company_id)>
		<cfset attributes.company_id = get_order_detail.company_id>
	<cfelse>
		<cfset attributes.company_id = "">
	</cfif>
    <cfif len(get_order_detail.consumer_id)>
		<cfset attributes.consumer_id = get_order_detail.consumer_id>
	<cfelse>
		<cfset attributes.consumer_id = "">
	</cfif>
	<cfset attributes.priority_id = get_order_detail.priority_id>
	<cfset attributes.ship_method = get_order_detail.ship_method>
	<cfset attributes.ref_no = get_order_detail.ref_no>
	<cfset attributes.catalog_id = get_order_detail.catalog_id>
	<cfset attributes.reserved = get_order_detail.reserved>
	<cfset attributes.invisible = get_order_detail.invisible>
	<cfif len(get_order_detail.deliver_dept_id) and len(get_order_detail.location_id)>
		<cfset location_info_ = get_location_info(get_order_detail.deliver_dept_id,get_order_detail.location_id,1,1)>
		<cfset attributes.branch_id = listlast(location_info_,',')>
		<cfset attributes.deliver_loc_id = get_order_detail.location_id>
		<cfset attributes.deliver_dept_id = get_order_detail.deliver_dept_id>
		<cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
	</cfif>
<cfelseif (isdefined("attributes.offer_id") and len(attributes.offer_id)) or (isdefined("attributes.for_offer_id") and len(attributes.for_offer_id))><!--- Tekliften Sipearise Donusturme --->
	<cfif isdefined("attributes.for_offer_id")><cfset attributes.offer_id = attributes.for_offer_id></cfif>
	<cfinclude template="../query/get_offer_detail.cfm">
	<cfset attributes.subject=get_offer_detail.offer_head>
	<cfset attributes.order_detail=ReReplaceNoCase(get_offer_detail.offer_detail,"<[^>]*>","","ALL")>
	<cfset attributes.project_id =get_offer_detail.project_id>
	<cfset attributes.deliverdate = DateFormat(get_offer_detail.deliverdate,dateformat_style)>
	<cfset attributes.work_id =get_offer_detail.work_id> 
	<cfset attributes.paymethod_id =get_offer_detail.paymethod>
	<cfset attributes.ship_method = get_offer_detail.ship_method>
	<cfset attributes.ref_no = get_offer_detail.ref_no>
	<cfif len(get_offer_detail.deliver_place) and len(get_offer_detail.location_id)>
		<cfset location_info_ = get_location_info(get_offer_detail.deliver_place,get_offer_detail.location_id,1,1)>
		<cfset attributes.branch_id = listlast(location_info_,',')>
		<cfset attributes.deliver_loc_id = get_offer_detail.location_id>
		<cfset attributes.deliver_dept_id = get_offer_detail.deliver_place>
		<cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
	</cfif>
	<cfif len(get_offer_detail.partner_id)>
		<cfset attributes.partner_id = get_offer_detail.partner_id>
		<cfset attributes.company_id = get_offer_detail.company_id>
	<cfelseif listlen(get_offer_detail.offer_to_partner)>
		<cfset attributes.partner_id = listfirst(listdeleteduplicates(get_offer_detail.offer_to_partner))>
		<cfquery name="get_company_id" datasource="#dsn#">
			SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfset attributes.company_id = get_company_id.company_id>
		<cfquery name="get_company_paymethod" datasource="#dsn#">
			SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id# AND OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif Len(get_company_paymethod.paymethod_id)>
			<cfset attributes.paymethod_id = get_company_paymethod.paymethod_id>
		</cfif>
	<cfelse>
		<cfset attributes.partner_id = "">
		<cfset attributes.company_id = "">
	</cfif>
	<cfset attributes.invisible = get_offer_detail.is_partner_zone>
<cfelseif (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and not isdefined("attributes.internaldemand_row_id")) or
		  (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and isdefined("attributes.internaldemand_row_id"))><!--- ic talepten siparis olusturma, satır bazlı degil veya satir bazli tek talep --->
	<cfquery name="get_internaldemand_info" datasource="#dsn3#">
		SELECT 
			I.SUBJECT, 
			I.PROJECT_ID, 
			I.NOTES,
			I.WORK_ID,
			IR.PRO_MATERIAL_ID,
			I.INTERNAL_NUMBER
		FROM 
			INTERNALDEMAND I,
			INTERNALDEMAND_ROW IR
		WHERE 
			I.INTERNAL_ID = IR.I_ID AND
			INTERNAL_ID IN (#attributes.internaldemand_id#)
	</cfquery>
	<cfset attributes.subject=get_internaldemand_info.subject>
	<cfset attributes.order_detail=get_internaldemand_info.notes>
	<cfset attributes.project_id =get_internaldemand_info.project_id>
	<cfset attributes.ref_no = "">
	<cfloop query="get_internaldemand_info">
		<cfset attributes.ref_no &= get_internaldemand_info.internal_number & ",">
	</cfloop>
		<cfset attributes.ref_no = ListRemoveDuplicates(left(attributes.ref_no,len(attributes.ref_no)-1))>
	<cfset attributes.work_id =get_internaldemand_info.work_id>
	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
		<cfquery name="get_company_paymethod" datasource="#dsn#">
			SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id# AND OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>
		<cfif Len(get_company_paymethod.paymethod_id)>
			<cfset attributes.paymethod_id = get_company_paymethod.paymethod_id>
		</cfif>
	</cfif> 
<cfelseif not isdefined("attributes.order_id") and not isdefined("attributes.type") and not isdefined("attributes.related_order_id") and isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
	</cfquery>
    <cfif len(get_project_info.company_id) and len(get_project_info.partner_id)>
		<cfset attributes.company_id = get_project_info.company_id>
        <cfset attributes.partner_id = get_project_info.partner_id>
    </cfif>
</cfif>
<cfinclude template="../query/get_setup_priority.cfm">
    <cf_catalystHeader>
	<cfset fuseact = "emptypopup_add_order">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" enctype="multipart/form-data">
				<cf_basket_form id="add_order">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.#fuseact#">
						<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#"> 
						<input type="hidden" name="search_process_date" id="search_process_date" value="deliverdate">
						<input type="hidden" name="search_process_date_paper" id="search_process_date_paper" value="order_date">
						<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="<cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>#attributes.internaldemand_id#</cfif>">
						<input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="<cfif isdefined('attributes.from_project_material_id') and len(attributes.from_project_material_id)>#attributes.from_project_material_id#</cfif>">
						<input type="hidden" name="offer_id" id="offer_id" value="<cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>#attributes.offer_id#</cfif>">
						<input type="hidden" name="for_offer_id" id="for_offer_id" value="<cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>#attributes.for_offer_id#</cfif>">
						<cfif isdefined("attributes.order_id") and len(attributes.order_id)><input type="hidden" name="order_id" id="order_id" value="#attributes.order_id#"></cfif>
					</cfoutput>
					<cfinclude template="add_order_noeditor.cfm">
				</cf_basket_form>			
					<cfset attributes.basket_id = 6>
					<cfif (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)) or isdefined('attributes.internaldemand_row_id')> <!--- ic talepden siparis ekleniyorsa --->
						<cfset attributes.id = attributes.internaldemand_id>
						<cfset attributes.basket_sub_id = 6>
					<cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)>
						<cfset attributes.offer_id = attributes.offer_id>
						<cfset add_order_from_offer_=1>
						<cfset attributes.basket_id = 6>
					<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
						<cfset attributes.order_id = attributes.order_id>
						<cfset attributes.basket_sub_id = 6>
					<cfelseif isDefined("attributes.from_project_material_id") and Len(attributes.from_project_material_id)>
						<cfset attributes.basket_id = 4>
					<cfelseif not isdefined("attributes.type") and not isdefined("attributes.update_order") and not isdefined("attributes.file_format") and not isdefined("offer_row_check_info")>
					<cfset attributes.form_add = 1>
					<cfelseif isdefined("attributes.file_format")>
						<cfset attributes.basket_sub_id = 4>
					<cfelseif isdefined("attributes.type") and attributes.type is 'convert'>
						<cfset attributes.basket_id = 6>
						<cfset attributes.is_from_report = 1>
					</cfif>
					<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
function open_member_page()
{
	<cfoutput>
		if(document.form_basket.company_id.value != '')
			windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id='+document.form_basket.company_id.value,'medium');
		else if(document.form_basket.consumer_id.value != '')
			windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id='+document.form_basket.consumer_id.value,'medium');
	</cfoutput>
}
function open_contract_page()
{
	<cfoutput>
		if(document.form_basket.company_id.value != '')
			windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&company_id='+document.form_basket.company_id.value,'page');
		else if(document.form_basket.consumer_id.value != '')
			windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&consumer_id='+document.form_basket.consumer_id.value,'page');
	</cfoutput>
}

function kontrol()
{
	if(document.form_basket.partner_id.value == "" && document.form_basket.company_id.value == "" && document.form_basket.consumer_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='38619.Üye/Cari Hesap Girmelisiniz'> !");
		return false;
	}
	if(document.form_basket.deliverdate.value != "" && document.form_basket.order_date.value != "")
		{
			if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
		}
	<cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated eq 1>
		change_paper_duedate('deliverdate');
	<cfelse>
		change_paper_duedate('order_date');
	</cfif>
	<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
		project_field_name = 'project_head';
	<cfelse>
		project_field_name = '';
	</cfif>
	<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
		date_field_name = 'deliverdate';
	<cfelse>
		date_field_name = '';
	</cfif>
	apply_deliver_date(date_field_name,project_field_name);
	return (process_cat_control() && saveForm());
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
	{
		if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.company.value)+''+ str_adrlink);
				document.getElementById('deliver_cons_id').value = '';
				return true;
			}
		else
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.member_name.value)+''+ str_adrlink);
				document.getElementById('deliver_comp_id').value = '';
				return true;
			}
	}
	else
	{
		alert("<cf_get_lang dictionary_id='38658.Şirket Seçmelisiniz'> !");
		return false;
	}
}
$(document).ready(
	function(){
		<cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated eq 1>
			if(typeof(change_paper_duedate) !== 'undefined')
				change_paper_duedate('deliverdate');
		<cfelse>
			if(typeof(change_paper_duedate) !== 'undefined')
				change_paper_duedate('order_date');
		</cfif>
		}
);
function open_phl() {
		document.getElementById("phl_div").style.display ='';	
		$("#phl_div").css('margin-left',$("#tabMenu").position().left - 700);
		$("#phl_div").css('margin-top',$("#tabMenu").position().top + 50);
		$("#phl_div").css('position','absolute');	
		<cfif session.ep.isBranchAuthorization eq 0>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.add_order_from_file&from_where=1</cfoutput>','phl_div',1);
		<cfelse>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.add_order_from_file&from_where=2</cfoutput>','phl_div',1);
		</cfif>
		return false;
	}

<!---<cfif (isdefined("attributes.offer_id") and len(attributes.offer_id)) or (isdefined("attributes.for_offer_id") and len(attributes.for_offer_id))>
	get_money_info('form_basket','order_date');
</cfif>---><!--- Şirket akış parametrelerinde bir önceki belgenin kurunu alsın mı ? seçeneğini etkilediği için kapatıldı.---->
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
