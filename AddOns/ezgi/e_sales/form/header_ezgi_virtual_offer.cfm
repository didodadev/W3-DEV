<cfset module_name="prod">
<cfoutput>
<cf_object_main_table>	
    <cf_object_table column_width_list="100,435">
        <cfsavecontent variable="header_"><cf_get_lang_main no='1408.Başlık'></cfsavecontent>
        <cf_object_tr id="form_ul_virtual_offer_head" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='1408.Başlık'>*</cf_object_td>
            <cf_object_td colspan="3">
                <input type="text" maxlength="200" name="virtual_offer_head" id="virtual_offer_head" value="<cfif isDefined("attributes.virtual_offer_head") and len(attributes.virtual_offer_head)>#attributes.virtual_offer_head#</cfif>" required="yes" style="width:320px;">
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
    <cf_object_table column_width_list="100,170">
        <cfsavecontent variable="header_"><cf_get_lang_main no='41.Şube'></cfsavecontent>
        <cf_object_tr id="form_ul_virtual_offer_status"  Title="#header_#">
            <cf_object_td valign="top" type="text"><cf_get_lang_main no='41.Şube'></cf_object_td>
            <cf_object_td>
                <select name="branch_id" style="width:125px; height:20px">
                	<option value=""><cf_get_lang_main no='2329.Şube Seçiniz'></option>
                    <cfloop query="get_branch">
                    	<option value="#get_branch.BRANCH_ID#" <cfif get_branch.BRANCH_ID eq attributes.branch_id>selected</cfif>>#BRANCH_NAME#</option>
                    </cfloop>
                </select>
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
    <cf_object_table column_width_list="100,220">
        <cfsavecontent variable="header_">#getLang('sales',620)#</cfsavecontent>
        <cf_object_tr id="form_ul_detail" Title="#header_#">
            <cf_object_td valign="top" type="text">#getLang('sales',620)#</cf_object_td>
            <cf_object_td>
                <input type="hidden" name="sales_member_id" id="sales_member_id" value="#attributes.sales_partner_id#">
	          	<input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
	          	<input type="text" name="sales_member" id="sales_member" value="#get_par_info(attributes.sales_partner_id,0,-1,0)#" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off" style="width:200px">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type&select_list=2,3','list','popup_list_pars');">
                	<img src="/images/plus_thin.gif" align="absmiddle" border="0">
               	</a>
            </cf_object_td>
        </cf_object_tr>
  	</cf_object_table>
    <cf_object_table column_width_list="70">
        <cfsavecontent variable="header_"><cf_get_lang_main no='81.Aktif'></cfsavecontent>
        <cf_object_tr id="form_ul_virtual_offer_status" extra_checkbox="reserved" Title="#header_#">
            <cf_object_td type="text">
            	<cf_get_lang_main no='81.Aktif'>
                <!---<input type="checkbox" name="virtual_offer_status" id="virtual_offer_status"  value="1"  <cfif isdefined("attributes.virtual_offer_status") and attributes.virtual_offer_status eq 1>checked</cfif>>--->
                <cfif isdefined("attributes.virtual_offer_status") and attributes.virtual_offer_status eq 1>
                	<img src="images/ok_list.gif" border="0" title="Aktif" />
                    <input type="hidden" name="virtual_offer_status" value="1" />
                <cfelse>
                	<img src="images/ok_list_empty.gif" border="0" title="Aktif" />
                </cfif>
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
</cf_object_main_table>
<cf_object_main_table> 
    <cf_object_table column_width_list="100,150">
        <cfsavecontent variable="header_"><cf_get_lang_main no='107.Cari Hesap'></cfsavecontent>
        <cf_object_tr id="form_ul_company" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='107.Cari Hesap'>*</cf_object_td>
            <cf_object_td>
                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
                <input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#attributes.consumer_reference_code#">
                <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">	
                <input type="text" name="company" id="company" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#get_par_info(attributes.company_id,1,1,0)#<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0)#</cfif>" readonly style="width:125px;">	  
                <cfset str_linke_ait="&is_period_kontrol=0&field_comp_id=form_basket.company_id&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_name=form_basket.company&field_name=form_basket.member_name&field_type=form_basket.member_type">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars#str_linke_ait#','list','popup_list_all_pars');">
                <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='166.Yetkili'></cfsavecontent>
        <cf_object_tr id="form_ul_member_name" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='166.Yetkili'>*</cf_object_td>
            <cf_object_td>
                <input type="hidden" name="partner_reference_code" id="partner_reference_code" value="#attributes.partner_reference_code#">
                <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
                <input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,-1,0)#<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0,0)#</cfif>" style="width:125px;">
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='1382.Referans No'></cfsavecontent>
        <cf_object_tr id="form_ul_ref_no" Title="#header_#">
            <cf_object_td type="text">Nihai Müşteri</cf_object_td>
            <cf_object_td>
				<input type="text" name="ref_no" id="ref_no" value="<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)>#attributes.ref_no#</cfif>" maxlength="50" style="width:125px;">
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
    
    <cf_object_table column_width_list="100,180">
        <cfsavecontent variable="header_">Teklif Tarihi</cfsavecontent>
        <cf_object_tr id="form_ul_virtual_offer_date" Title="#header_#">
            <cf_object_td type="text">Teklif Tarihi*</cf_object_td>
            <cf_object_td>
                <cfsavecontent variable="message">Teklif Tarihi Girmelisiniz !</cfsavecontent>
                <cfinput type="text" name="virtual_offer_date" id="virtual_offer_date" required="yes" value="#attributes.virtual_offer_date#" validate="eurodate" message="#message#" maxlength="10" style="width:70px;" readonly>
                <cf_wrk_date_image date_field="virtual_offer_date">
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='233.Teslim Tarihi'></cfsavecontent>
        <cf_object_tr id="form_ul_deliverdate" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='233.Teslim Tarihi'>*</cf_object_td>
            <cf_object_td>
                <cfinput type="text" name="deliverdate" id="deliverdate" style="width:70px;" value="#attributes.deliverdate#" validate="eurodate" maxlength="10">
                <cf_wrk_date_image date_field="deliverdate">
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_">Geçerlilik Tarihi</cfsavecontent>
        <cf_object_tr id="form_ul_deliverdate" Title="#header_#">
            <cf_object_td type="text">Geçerlilik Tarihi*</cf_object_td>
            <cf_object_td>
                <cfinput type="text" name="finishdate" id="finishdate" style="width:70px;" value="#attributes.finishdate#" validate="eurodate" maxlength="10">
                <cf_wrk_date_image date_field="finishdate">
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
     <cf_object_table column_width_list="100,170">
        <cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
        <cf_object_tr id="form_ul_process_stage" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no="1447.Süreç"> *</cf_object_td>
            <cf_object_td>
            	<cfif isdefined('attributes.virtual_offer_id') and len(attributes.virtual_offer_id)>
                	<cf_workcube_process is_upd='0' select_value='#get_virtual_offer.virtual_offer_STAGE#' process_cat_width='125' is_detail='1'>
               	<cfelse>
                	<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
                </cfif>
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no ='228.Vade'></cfsavecontent>
        <cf_object_tr id="form_ul_basket_due_value" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no="228.Vade"></cf_object_td>
            <cf_object_td>
                <input type="text" name="basket_due_value" id="basket_due_value" value="<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>#attributes.basket_due_value#</cfif>" style="width:35px;">
                <cfinput type="text" name="basket_due_value_date_" id="basket_due_value_date_" value="#attributes.basket_due_value_date_#"  validate="eurodate" message="#message#" maxlength="10" style="width:65px;" readonly>
                <cf_wrk_date_image date_field="basket_due_value_date_">
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no ='73.Öncelik'></cfsavecontent>
        <cf_object_tr id="form_ul_priority_id" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no ='73.Öncelik'></cf_object_td>
            <cf_object_td>
				<select name="priority_id" id="priority_id" style="width:125px; height:20px">
                    <cfloop query="get_priorities">
                    <option value="#priority_id#" <cfif (isdefined("attributes.priority_id") and attributes.priority_id eq priority_id) or (not isdefined("attributes.priority_id") and priority_id eq 1)>selected</cfif>>#priority#</option>
                    </cfloop>
                </select>
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yontemi'></cfsavecontent>
        <cf_object_tr id="form_ul_priority_id" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='1703.Sevk Yontemi'></cf_object_td>
            <cf_object_td>
				<input type="hidden" name="ship_method_id" id="ship_method_id" value="#attributes.ship_method#">
                <cfif len(attributes.ship_method)>
		     		<cfinclude template="../../../../V16/sales/query/get_ship_method.cfm">
                    <cfset ship_method = GET_SHIP_METHOD.SHIP_METHOD>
                <cfelse>
                	<cfset ship_method = ''>
                </cfif>
	        	<input type="text" name="ship_method_name" id="ship_method_name" value="#SHIP_METHOD#" style="width:125px; height:20px"  onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');"  autocomplete="off">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');">
                	<img src="/images/plus_thin.gif" align="absmiddle" border="0">
                </a>
	                        
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
    
    <cf_object_table column_width_list="100,220">
        <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açıklama'></cfsavecontent>
        <cf_object_tr id="form_ul_detail" Title="#header_#">
            <cf_object_td valign="top" type="text"><cf_get_lang_main no='217.Açıklama'></cf_object_td>
            <cf_object_td>
				<textarea name="detail" id="detail" style="width:200px;height:45px;"><cfif isdefined("attributes.virtual_offer_detail") and len(attributes.virtual_offer_detail)>#attributes.virtual_offer_detail#<cfelseif isdefined("get_subscription.subscription_detail") and len(get_subscription.subscription_detail)>#get_subscription.subscription_detail#</cfif></textarea>
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='4.Proje'></cfsavecontent>
        <cf_object_tr id="form_ul_project_head" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='4.Proje'></cf_object_td>
            <cf_object_td>
				<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>"> 
                <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" style="width:200px;" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','200')"autocomplete="off">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>	
            </cf_object_td>
        </cf_object_tr>
        <cfsavecontent variable="header_"><cf_get_lang_main no='1104.Ödeme Yontemi'></cfsavecontent>
        <cf_object_tr id="form_ul_priority_id" Title="#header_#">
            <cf_object_td type="text"><cf_get_lang_main no='1104.Ödeme Yontemi'></cf_object_td>
            <cf_object_td>
            	<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                <cfif len(attributes.paymethod_id)>
		     		<cfinclude template="../../../../V16/sales/query/get_paymethod.cfm">
                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
		           	<input type="hidden" name="commission_rate" id="commission_rate" value="">
		          	<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_paymethod.payment_vehicle#">
		         	<input type="hidden" name="paymethod_id" id="paymethod_id" value="#attributes.paymethod_id#">
		       		<input type="text" name="paymethod" id="paymethod" value="#get_paymethod.paymethod#" style="width:200px">
                <cfelse>
                    <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
	             	<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
	          		<input type="hidden" name="commission_rate" id="commission_rate" value="">
	            	<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
	            	<input type="text" name="paymethod" id="paymethod" value="" style="width:200px">
                </cfif>
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=order_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#','list');">
                	<img src="/images/plus_thin.gif" align="absmiddle" border="0">
                </a>
            </cf_object_td>
        </cf_object_tr>
    </cf_object_table>
</cf_object_main_table>
</cfoutput>	
<table>
	<tr>
        <td colspan="9">
        	
        </td>
    </tr>
</table>
<cfif isdefined("attributes.virtual_offer_id")>
	<cf_record_info query_name="get_virtual_offer">
	<cfif not get_upd_control.recordcount and is_revision_small eq 0>
		<cfif get_del_control.recordcount >
            <span style="color:red; font-weight:bold">Gerçek Teklife Dönüştü</span>
            <cf_basket_form_button>
                <cf_workcube_buttons 
                    is_upd='1' 
                    is_delete='0'
                    add_function='kontrol()'
                >
            </cf_basket_form_button>
        <cfelse>
            <cf_basket_form_button>
                <cf_workcube_buttons 
                    is_upd='1' 
                    add_function='kontrol()'
                    delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_virtual_offer&virtual_offer_id=#attributes.virtual_offer_id#' 
                >
            </cf_basket_form_button>
        </cfif>
    </cfif>
<cfelse>
	<cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(form_basket.process_stage.value.length == 0)
		{
			alert("<cf_get_lang_main no='1430.Lütfen Süreç Seçiniz'>");
			return false;
		}
		if(form_basket.company_id.value.length == 0 && form_basket.consumer_id.value.length == 0)
		{
			alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>");
			return false;
		}
		if (form_basket.deliverdate.value.length == 0)
		{
			alert("Teslim Tarihi Girmelisiniz!");
			return false;
		}
		if (!date_check(document.form_basket.virtual_offer_date,document.form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
			return false;
		if(process_cat_control())
			return true;
		else
			return false;

	}
</script>