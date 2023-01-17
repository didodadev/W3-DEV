<!--- Firma adina gore  indirimleri getirip siparis sayfasina yonlendirmek icin hazirlanmistir.--->		
<cf_xml_page_edit>
<cfif isdefined("attributes.is_demand")>
	<cfparam name="attributes.is_demand" default="#attributes.is_demand#">
<cfelse>
	<cfparam name="attributes.is_demand" default="0">    
</cfif>
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfif not (isdefined('attributes.internal_row_info') and len(attributes.internal_row_info))> <!---iç talebi satır bazlı satınalma siparişine çevrilmiyorsa --->
    <cfparam name="attributes.id" default="">
	<cfinclude template="../query/get_internaldemand.cfm">
<cfelse>
	<cfset get_internaldemand.recordcount=0>
</cfif>
<cfset action_ = "#request.self#?fuseaction=purchase.list_order&event=add">
<cfform name="add_order" action="#action_#" method="post">
    <input type="hidden" name="price_form_pricecat" id="price_form_pricecat" value="<cfif isdefined('xml_price_form_pricecat') and xml_price_form_pricecat eq 1>1<cfelse>0</cfif>">
    <cfsavecontent variable="head_">
        <cfif attributes.is_demand eq 1><cf_get_lang dictionary_id ='38498.Satin Alma Talebini Siparise Donustur'><cfelse><cf_get_lang dictionary_id ='58451.İç Talebi Siparişe Dönüştür'></cfif>
    </cfsavecontent>
    <cf_box title='#head_#'>
        <cf_box_elements>
            <div class="col col-4 col-md-8 col-sm-12 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-company_name">			
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                            <cfif isdefined('attributes.internal_row_info') and len(attributes.internal_row_info)>
                                <cfscript>
                                    row_amount_list ="";
                                    row_id_list ="";
                                    interd_id_list ="";
                                    for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
                                    {
                                        temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
                                        if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
                                        {
                                            row_amount_list = listappend(row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
                                            row_id_list = listappend(row_id_list,listlast(temp_row_info_,';'));
                                            interd_id_list = listappend(interd_id_list,listfirst(temp_row_info_,';'));
                                        }
                                    }
                                </cfscript>
                                <cfoutput>
                                <input type="hidden" name="internal_row_info" id="internal_row_info" value="#attributes.internal_row_info#">
                                <input type="hidden" name="interd_row_amount_list" id="interd_row_amount_list" value="<cfif len(row_amount_list)>#row_amount_list#</cfif>">
                                <input type="hidden" name="internaldemand_id" id="internaldemand_id" value="<cfif len(interd_id_list)>#interd_id_list#</cfif>">
                                <input type="hidden" name="internaldemand_row_id" id="internaldemand_row_id" value="<cfif len(row_id_list)>#row_id_list#</cfif>">
                                </cfoutput>
                            <cfelse>
                                <cfoutput>
                                <input type="hidden" name="ship_method" id="ship_method" value="<cfif get_internaldemand.recordcount neq 0  and len(get_internaldemand.ship_method)>#get_internaldemand.ship_method#</cfif>">
                                <input type="hidden" name="ref_no" id="ref_no" value="<cfif get_internaldemand.recordcount neq 0  and len(get_internaldemand.ref_no)>#get_internaldemand.ref_no#</cfif>">
                                <input type="hidden" name="internaldemand_id" id="internaldemand_id" value="#attributes.id#">
                                <input type="hidden" name="id" id="id" value="#attributes.id#">
                                </cfoutput>
                            </cfif>
                            <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company_name)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_name)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                            <input type="hidden" name="partner_id" id="partner_id" <cfif len(attributes.company_name)> value="<cfoutput>#attributes.partner_id#</cfoutput>"</cfif>>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='38619.üye cari hesap girmelisiniz'></cfsavecontent>	
                            <cfinput type="text" name="company_name" id="company_name" style="width:150px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\,2\',\'\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID,MEMBER_PARTNER_NAME','company_id,consumer_id,partner_id,partner_name','','3','250','set_price_catid_options()');" value="" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=add_order.partner_name&field_partner=add_order.partner_id&field_comp_name=add_order.company_name&field_comp_id=add_order.company_id&field_consumer=add_order.consumer_id</cfoutput>','list')"></span>
                        </div>
                    </div>
                </div>    
                <div class="form-group" id="item-partner_name">			
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="partner_name" id="partner_name" value="" style="width:150px;" readonly>
                    </div>
                </div>    
                <div class="form-group" id="item-product_employee_id">			
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58448.Ürün Sorumlusu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group"> 
                            <input type="hidden" name="product_employee_id" id="product_employee_id"  value="">
                            <input type="text" name="employee_name" id="employee_name" style="width:150px;" value="">
                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_order.product_employee_id&field_name=add_order.employee_name&select_list=1','list');"></span>			
                        </div>
                    </div>
                </div>    
                <div class="form-group" id="item-deliver_dept_id">			
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58449.Teslim Yeri'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfif get_internaldemand.recordcount neq 0>
                            <cf_wrkdepartmentlocation 
                                returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="deliver_dept_name"
                                fieldid="deliver_loc_id"
                                department_fldId="deliver_dept_id"
                                department_id="#get_internaldemand.department_in#"
                                location_id="#get_internaldemand.location_in#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                line_info = 2
                                width="150">                    
                        <cfelse>
                            <cf_wrkdepartmentlocation 
                                returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                fieldName="deliver_dept_name"
                                fieldid="deliver_loc_id"
                                department_fldId="deliver_dept_id"
                                department_id=""
                                location_id=""
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                line_info = 2
                                width="150">
                        </cfif>
                        <!---<cfif get_internaldemand.recordcount neq 0 and len(get_internaldemand.department_in) and len(get_internaldemand.location_in)>
                            <cfset location_info_ = get_location_info(get_internaldemand.department_in,get_internaldemand.location_in,1,1)>
                            <cfset attributes.branch_id = listlast(location_info_,',')>
                            <cfset attributes.deliver_dept_id = get_internaldemand.department_in>
                            <cfset attributes.deliver_loc_id = get_internaldemand.location_in>
                            <cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
                        </cfif>
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                        <input type="hidden" name="deliver_dept_id" id="deliver_dept_id" value="<cfif isdefined('attributes.deliver_dept_id') and len(attributes.deliver_dept_id)><cfoutput>#attributes.deliver_dept_id#</cfoutput></cfif>">
                        <input type="hidden" name="deliver_loc_id" id="deliver_loc_id" value="<cfif isdefined('attributes.deliver_loc_id') and len(attributes.deliver_loc_id)><cfoutput>#attributes.deliver_loc_id#</cfoutput></cfif>">
                        <cfif isdefined('attributes.deliver_dept_name') and len(attributes.deliver_dept_name)>
                            <cfinput type="text" name="deliver_dept_name" required="yes" passthrough="readonly" style="width:150px;" message="Teslim Yeri Seçiniz!" value="#listfirst(location_info_,',')#">
                        <cfelse>
                            <cfinput type="text" name="deliver_dept_name" required="yes" passthrough="readonly" style="width:150px;" message="Teslim Yeri Seçiniz!" value="">
                        </cfif>
                        <cfset str_link_dep = "objects.popup_list_stores_locations&form_name=add_order&field_location_id=deliver_loc_id&field_name=deliver_dept_name&field_id=deliver_dept_id&branch_id=branch_id" >
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#str_link_dep#</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>--->
                    </div>
                </div>
                <div class="form-group" id="item-deliverdate">			
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif get_internaldemand.recordcount neq 0 and len(get_internaldemand.target_date)>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='38699.Teslim Tarihi giriniz'></cfsavecontent>
                                <cfinput type="text" name="deliverdate" id="deliverdate" style="width:150px;" value="#dateformat(get_internaldemand.target_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
                            <cfelse>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='38699.Teslim Tarihi giriniz'></cfsavecontent>
                                <cfinput type="text" name="deliverdate" id="deliverdate" style="width:150px;" value="" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                        </div>
                    </div>
                </div>   
                <cfif isdefined('xml_price_form_pricecat') and xml_price_form_pricecat eq 1>
                    <div class="form-group" id="item-order_date">			
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarih Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="order_date" id="order_date" validate="#validate_style#" value="" message="#message#" required="yes" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="order_date"></span>
                            </div>
                        </div>
                    </div>    
                    <div class="form-group" id="item-phl_price_catid_">			
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="phl_price_catid_" id="phl_price_catid_" style="width:150px;" onchange="check_company_info();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            </select>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-all_product_convert">			
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58450.Tüm ürünleri siparişe dönüştür'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="all_product_convert" id="all_product_convert" value="1">
                    </div>
                </div>
            </div>
        </cf_box_elements>       
        <cf_box_footer>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58126.Devam'></cfsavecontent>
            <cfsavecontent variable="message_2"><cf_get_lang dictionary_id='58587.devam etmek istediğinizden eminmisiniz'>?</cfsavecontent>
            <cf_workcube_buttons type_format='1' is_upd="0" insert_info='#message#' insert_alert="#message_2#" add_function="control()">
        </cf_box_footer>
        <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
            <cf_box>
                <div class="ui-cfmodal-close">×</div>
                <ul class="required_list"></ul>
                <div class="ui-form-list-btn">
                    <div>
                        <input type="submit" class="ui-btn ui-btn-success" value="Tamam" onClick="return true;">		
                    </div>
                </div>
            </cf_box>
        </div>
    </cf_box>
</cfform>

<script type="text/javascript">
    $('.ui-cfmodal-close').click(function(){
        $('.ui-cfmodal__alert').fadeOut();
    })
	function control()
	{
		if(document.getElementById('company_name').value == '' && document.getElementById('partner_name').value == '')
		{
			alert("<cf_get_lang dictionary_id='38619.üye cari hesap girmelisiniz'>");
			return false;
		}

		if(document.getElementById('deliver_dept_name').value == '')
		{
			alert("<cf_get_lang dictionary_id='38664.Teslim yeri seçiniz'>");
			return false;
		}
        $('.ui-cfmodal__alert .required_list li').remove();
        if($('#company_name').val() && document.getElementById('all_product_convert').checked == false) {
            var name_ = $('#company_name').val();
            
            $('.ui-cfmodal__alert .required_list').append(name_ + ' : <cf_get_lang dictionary_id='61979.talep sepetindeki ürünlerin tamamı/bazılarının tedarikçisi değildir. Seçilen cari hesabı...'>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
        }        
	}
	<cfif isdefined('xml_price_form_pricecat') and xml_price_form_pricecat eq 1>	
		function check_company_info()
		{
			if((document.getElementById('consumer_id').value == '' && document.getElementById('company_id').value=='') || document.getElementById('company_name').value=='')
			{
				alert("<cf_get_lang dictionary_id='58965.Önce Cari Hesap Seçiniz'>!");
				document.getElementById('phl_price_catid_').value='';
				return false;
			}
			else
			{
				var price_cat_length_ = document.add_order.phl_price_catid_.options.length;
				if(price_cat_length_ == 0)
					set_price_catid_options();
				return true;
			}
		}
		function set_price_catid_options()
		{
			<cfif session.ep.isBranchAuthorization>var is_store_module=1; <cfelse>	var is_store_module=0;</cfif>
				is_sale_product=1;
				var sepet_process_obj = findObj("process_cat");
				selected_process_type = -1;
				var temp_card_paymethod = '';
				temp_paymethod_vehicle = '';
				if(is_sale_product == 1) /*satıs */
				{
					{
						if(document.getElementById('company_id') != undefined && document.getElementById('company_id').value != '')
						{
							var get_credit_limit = wrk_safe_query('prch_get_credit_limit',"dsn",0,document.getElementById('company_id').value);
							
							var get_comp_cat = wrk_safe_query('prch_get_comp_cat',"dsn",0,document.getElementById('company_id').value);
				
							var str_price_cat_ = "prdp_get_price_cat";
							if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '')
								str_price_cat_ = 'prdp_get_price_cat_2';
							
		
							var listParam = get_comp_cat.COMPANYCAT_ID + "*" + get_credit_limit.PRICE_CAT_PURCHASE;
							var get_price_cat = wrk_safe_query(str_price_cat_,"dsn3",0,listParam);
		
							if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
								var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
							else if(get_price_cat.recordcount != 0)
								var selected_price_catid=get_price_cat.PRICE_CATID;
						}
						else if(document.getElementById('consumer_id') != undefined && document.getElementById('consumer_id').value != '')
						{
							var get_credit_limit = wrk_safe_query('prch_get_credit_limit_cons','dsn',0,document.getElementById('consumer_id').value);
			
							var get_comp_cat = wrk_safe_query('prch_get_cons_cat_2',"dsn",0,document.getElementById('consumer_id').value);
							
							var str_price_cat_ = "prdp_get_price_cat";
							if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != '' )
								var str_price_cat_ = 'prdp_get_price_cat_2';
		
							var listParam = get_credit_limit.PRICE_CAT_PURCHASE + "*" + get_comp_cat.CONSUMER_CAT_ID;
							var get_price_cat = wrk_safe_query(str_price_cat_,"dsn3",0,listParam);
							
							if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT_PURCHASE != 0)
								var selected_price_catid = get_credit_limit.PRICE_CAT_PURCHASE;
							else if(get_price_cat.recordcount != 0)
								var selected_price_catid=get_price_cat.PRICE_CATID;
						}
					}
				}
				if(get_price_cat != undefined && get_price_cat.recordcount!=0)
				{
					var price_cat_len = document.add_order.phl_price_catid_.options.length;
					if(price_cat_len!='') //fiyat listesi selectboxının içerigi silinip yeniden oluşturuluyor
					{ 
					  for (var i = price_cat_len- 1; i>2; i--)
						  document.add_order.phl_price_catid_.options.remove(i);
					}
					
					for(var jj=0;jj<get_price_cat.recordcount;jj++)
						document.add_order.phl_price_catid_.options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj],false,(get_price_cat.PRICE_CATID[jj]==selected_price_catid)? true : false); //new Option(text, value, defaultSelected, selected)
				}
			}
	</cfif>
</script>
