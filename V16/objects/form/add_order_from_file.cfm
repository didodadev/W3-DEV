<!--- Objects altında ortak kullanım için oluşturulan PHL sayfası
from_where : 1 ---- Satınalma Siparişinden
from_where : 2 ---- Şube Satınalma Siparişinden
from_where : 3 ---- Şube İç Talep Sayfasından
from_where : 4 ---- Satış Siparişinden
from_where : 5 ---- Satış Teklifinden
 --->
<cf_xml_page_edit>
<cfsavecontent variable="title_"> 
	<cfif from_where eq 3>
        <cf_get_lang dictionary_id='60009.Veri Aktarım'>
    <cfelseif ListFind("5,6",from_where)>
        <cf_get_lang dictionary_id='60009.Veri Aktarım'>
    <cfelse>
        <cf_get_lang dictionary_id='60009.Veri Aktarım'>
    </cfif>
	<cfif ListFind("1,2,3",from_where)>
		<cfset is_purchase = 1>
		<cfset is_sale = 0>
	<cfelse>
		<cfset is_purchase = 0>
		<cfset is_sale = 1>
	</cfif>
</cfsavecontent>
<cfif isdefined('attributes.frm_str_') and len(attributes.frm_str_) and attributes.from_where eq 3>
	<cfset internaldemand_referer_=attributes.frm_str_>
<cfelse>
	<cfset internaldemand_referer_="store">
</cfif>
<cfswitch expression="#attributes.from_where#">
	<cfcase value="1">
		<cfset str_link = "#request.self#?fuseaction=purchase.list_order&event=add">
	</cfcase>
	<cfcase value="2">
		<cfset str_link = "#request.self#?fuseaction=store.form_add_orders_purchase">
	</cfcase>
	<cfcase value="3">
    	<cfif isdefined("attributes.is_demand") and is_demand eq 1>
        	<cfset str_link = "#request.self#?fuseaction=#internaldemand_referer_#.list_purchasedemand&event=add">
		<cfelse>
        	<cfset str_link = "#request.self#?fuseaction=#internaldemand_referer_#.list_internaldemand&event=add">
		</cfif>
	</cfcase>
	<cfcase value="4">
		<cfset str_link = "#request.self#?fuseaction=sales.list_order&event=add">
	</cfcase>
	<cfcase value="5">
		<cfset str_link = "#request.self#?fuseaction=sales.list_offer&event=add">
	</cfcase>
	<cfcase value="6">
		<cfif isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>
			<cfset str_link = "#request.self#?fuseaction=purchase.list_offer&event=add&for_offer_id=#attributes.for_offer_id#&partner_ids=#attributes.partner_ids#&company_ids=#attributes.company_ids#">
		<cfelse>
			<cfset str_link = "#request.self#?fuseaction=purchase.list_offer&event=add">
		</cfif>
	</cfcase>
</cfswitch>
<div class="col col-12 col-xs-12">
    <cf_box title="#title_#" closable="1" draggable="1">
        <cfform name="form_basket_order" action="#str_link#" method="post" enctype="multipart/form-data">
                <input type="hidden" name="file_format" id="file_format" value="1">
                <input type="hidden" name="from_where" id="from_where" value="<cfoutput>#from_where#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cfif listfind('1,2,4,5',from_where)>
                            <div class="form-group" id="item-comp_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                        <input type="hidden" name="partner_id" id="partner_id" value="">
                                        <input type="hidden" name="company_id" id="company_id" value="">
                                        <input type="hidden" name="partner_name" id="partner_name" value="">
                                        <input type="hidden" name="adres" id="adres" value="">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57785.Uye Secmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="comp_name" id="comp_name" readonly="" required="yes" message="#message#" style="width:200px;" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID,MEMBER_PARTNER_NAME,WORK_ADDRESS','company_id,partner_id,consumer_id,partner_name,adres','','3','200','get_comp_cat()');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&function_name=get_comp_cat&select_list=2,3&field_partner=form_basket_order.partner_id&field_name=form_basket_order.comp_name&field_comp_name=form_basket_order.comp_name&field_comp_id=form_basket_order.company_id&field_consumer=form_basket_order.consumer_id&field_partner_name=form_basket_order.partner_name&come=stock&field_address=form_basket_order.adres</cfoutput>','list');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif from_where neq 5>
                            <div class="form-group" id="item-txt_departman_">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="branch_id" id="branch_id">
                                        <input type="hidden" name="deliver_loc_id" id="deliver_loc_id">						
                                        <input type="hidden" name="deliver_dept_id" id="deliver_dept_id">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33242.Depo girmelisiniz'> !</cfsavecontent>
                                        <cfif listfind('1,2,4',from_where)>
                                            <cfinput type="text" name="txt_departman_" required="yes" message="#message#" readonly="yes" style="width:138px;">
                                        <cfelse>
                                            <cfinput type="text" name="txt_departman_" required="yes" message="#message#" readonly="yes" style="width:200px;">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket_order&field_name=txt_departman_&field_id=deliver_dept_id&field_location_id=deliver_loc_id&branch_id=branch_id<cfif from_where eq 2 or from_where eq 3 and session.ep.isBranchAuthorization>&is_branch=1</cfif>','list')"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif from_where eq 5 or from_where eq 6>
                            <div class="form-group" id="item-offer_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46831.Teklif Tarihi'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
                                        <cfinput type="text" name="offer_date" validate="#validate_style#" value="" message="#message#" required="yes" style="width:138px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_date"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif from_where eq 3>
                            <div class="form-group" id="item-target_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarih Girmelisiniz'>!</cfsavecontent>
                                        <cfinput type="text" name="target_date" validate="#validate_style#" value="" message="#message#" required="yes" style="width:138px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="target_date"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-uploaded_file">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                            <div class="col col-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='32871.Belge Seçiniz'> !</cfsavecontent>
                                <cfinput type="file" name="uploaded_file" required="yes" message="#message#" style="width:197px;">
                            </div>
                        </div>
                        <cfif from_where eq 5 or from_where eq 6>
                            <div class="form-group" id="item-deliverdate">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarih Girmelisiniz'>!</cfsavecontent>
                                        <cfinput type="text" name="deliverdate" validate="#validate_style#" value="" message="#message#" required="yes" style="width:138px;">                                        
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                                    </div>
                                </div>
                            </div>						
                        </cfif>
                        <cfif listfind('1,2,4',from_where)>
                            <div class="form-group" id="item-order_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarih Girmelisiniz'>!</cfsavecontent>
                                        <cfinput type="text" name="order_date" validate="#validate_style#" value="" message="#message#" required="yes" style="width:138px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="order_date"></span>
                                    </div>
                                </div>
                            </div>					
                        </cfif>
                        <div class="form-group" id="item-stock_identity_type_">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58530.Aktarım Türü"></label>
                            <div class="col col-8 col-xs-12"> 
                                <select name="stock_identity_type_" id="stock_identity_type_" style="width:200;">
                                    <option value="1" selected><cf_get_lang dictionary_id ='57633.Barkod'></option>
                                    <option value="2"><cf_get_lang dictionary_id ='57518.Stok Kodu'></option>
                                    <option value="3"><cf_get_lang dictionary_id ='57789.Özel Kod'></option>
                                </select>
                            </div>
                        </div>
                        <cfif listfind('4,5',from_where)> <!--- satış siparişi, satış teklifi --->
                            <div class="form-group" id="item-phl_price_catid_">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <select name="phl_price_catid_" id="phl_price_catid_" style="width:140px;" onChange="check_company_info();">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                    </select>
                                </div>
                            </div>
                        <cfelseif from_where eq 1>
                            <div class="form-group" id="item-project_head">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>"> 
                                        <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" style="width:140px;" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket_order_2','3','200')"autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket_order.project_id&project_head=form_basket_order.project_head</cfoutput>');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif from_where eq 1>
                            <div class="form-group" id="item-price_catid">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'> *</label>
                                <div class="col col-8 col-xs-12"> 
                                    <select name="price_catid" id="price_catid" style="width:140px;" onChange="check_company_info();">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="-1"><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                        <cfif from_where eq 4>
                            <div class="form-group" id="item-project_head">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>"> 
                                        <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" style="width:140px;" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket_order_2','3','200')"autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket_order.project_id&project_head=form_basket_order.project_head</cfoutput>');"></span>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58594.Format'></label>
                        </div>
                        <div class="form-group" id="item-format">
                            <div class="col col-12"> 
                                <p><cf_get_lang dictionary_id='35657.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id='44487.Aktarım işlemi dosyanın ilk satırından itibaren başlar'><br>
                                <cf_get_lang dictionary_id='60207.Belgede en az ilk 2 alan olmalıdır, alanlar sırası ile'>;<br/>
                                1 - <cf_get_lang dictionary_id='57518.Stok Kodu'> ,<cf_get_lang dictionary_id='57633.Barkod'> <cf_get_lang dictionary_id='57789.Özel Kod'>'> (<cf_get_lang dictionary_id='58194.Zorunlu'>)<br/>
                                2 - <cf_get_lang dictionary_id='44965.Miktar(Zorunlu)'><br/>
                                <cfif attributes.from_where is 1 or attributes.from_where is 3>
                                    3 - <cf_get_lang dictionary_id='37354.Spect Main ID'><br/>
                                </cfif>
                                <cfif attributes.from_where eq 6>
                                    3 - <cf_get_lang dictionary_id='57125.Döviz Fiyat'><br/>
                                    4 - <cf_get_lang dictionary_id='57677.Döviz'><br/>
                                    5 - <cf_get_lang dictionary_id='57641.İskonto'>(<cf_get_lang dictionary_id='53135.Yüzde'>)<br/>
                                <cfelse>
                                    <cfif attributes.from_where is 1 or attributes.from_where is 3>4<cfelse>3</cfif> - <cf_get_lang dictionary_id='58084.Fiyat'><br/>
                                </cfif>
                                <cfif attributes.from_where is 4 or attributes.from_where is 5>
                                    4 - <cf_get_lang dictionary_id='37354.Spect Main ID'><br/>
                                </cfif>
                                <cfif attributes.from_where neq 5 and attributes.from_where neq 6>
                                    5 - <cf_get_lang dictionary_id='57645.Teslim Tarihi'><br/>
                                </cfif>
                                <cfif listfind('1,3,4',attributes.from_where)><!---  attributes.from_where is 1 or attributes.from_where is 3> --->
                                    6 - <cf_get_lang dictionary_id='47408.Satır Açıklama'><br/>
                                </cfif>
                                <cfif attributes.from_where is 1>
                                    7 - <cf_get_lang dictionary_id='45180.Sipariş Satır ID'><br/>
                                </cfif>
                                <cfif attributes.from_where is 3 >
                                    7 - <cf_get_lang dictionary_id='57416.Proje ID'><br/>
                                    8 - <cf_get_lang dictionary_id='38594.İş ID'>
                                </cfif>                                
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12">
                        <cfsavecontent variable="listmessage"><cf_get_lang dictionary_id='58715.Listele'></cfsavecontent>
                        <cfif from_where eq 1>
                            <cf_workcube_buttons type_format="1" insert_info='#listmessage#' add_function='ekle_form_action(1)' is_cancel='0'>
                            <cf_workcube_buttons type_format="1" add_function='ekle_form_action(2)'>
                        <cfelseif from_where eq 4>
                            <cf_workcube_buttons insert_info='#listmessage#' type_format="1" add_function='ekle_form_action(1)' is_cancel='0'>
                            <cf_workcube_buttons type_format="1" add_function='ekle_form_action(2)'>
                        <cfelse>
                            <cf_workcube_buttons type_format="1" insert_info='#listmessage#' add_function='ekle_form_action(1)' is_cancel='0'>
                            <cf_workcube_buttons type_format="1" add_function='ekle_form_action(2)'>
                        </cfif>
                    </div> 
                </cf_box_footer>       
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function get_comp_cat(c_id)
	{         
        var c_iid = (document.form_basket_order.company_id.value != '') ? document.form_basket_order.company_id.value : c_id;
;
		var get_comp_cat=wrk_query("SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID ="+c_iid,"dsn");
		var get_price_cat=wrk_query("SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS=1 AND <cfif is_purchase eq 1>IS_PURCHASE=1<cfelseif is_sale eq 1>IS_SALES=1</cfif> AND COMPANY_CAT LIKE '%,"+get_comp_cat.COMPANYCAT_ID+",%' ORDER BY PRICE_CAT","dsn3");
       
		if(document.getElementById("price_catid") != undefined)
		{
			var price_len = document.getElementById("price_catid").options.length;
			for(kk=price_len;kk>=0;kk--)
				document.getElementById("price_catid").options[kk] = null;	
				
			document.getElementById("price_catid").options[0] = new Option('Fiyat Listesi','');
			for(var jj=0;jj < get_price_cat.recordcount;jj++)
			{
				document.getElementById("price_catid").options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);
			}
			document.getElementById("price_catid").options[get_price_cat.recordcount+1]=new Option('Standart Alış',-1);
		}
		else
		{
			var price_len = document.getElementById("phl_price_catid_").options.length;
			for(kk=price_len;kk>=0;kk--)
				document.getElementById("phl_price_catid_").options[kk] = null;	
				
			document.getElementById("phl_price_catid_").options[0] = new Option('Fiyat Listesi','');
			for(var jj=0;jj < get_price_cat.recordcount;jj++)
				document.getElementById("phl_price_catid_").options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj]);
		}
	}
	function ekle_form_action(int_s_flag)
	{
        price_catid = $("#price_catid").val();
		<cfif attributes.from_where is 1>
			if(price_catid == '')
			{
				alert("<cf_get_lang dictionary_id='45954.Fiyat Listesi Seçmelisiniz'> !");
				return false;
			}
        </cfif>
        offer_date = $("#offer_date").val();
        deliverdate = $("#deliverdate").val();
		<cfif attributes.from_where is 5>
			if(offer_date == '')
			{
				alert("<cf_get_lang dictionary_id='38656.Teklif Tarihi Girmelisiniz'>!");
				return false;
			}
			if(deliverdate == '')
			{
				alert("<cf_get_lang dictionary_id='46856.Teslim Tarihi Girmelisiniz'>!");
				return false;
			}
        </cfif>
        project_id = $("#project_id").val();
        project_head = $("#project_head").val();
		<cfif attributes.from_where is 4>
			<cfif xml_is_project>
			if(project_id == '' && project_head == '')
			{
				alert("<cf_get_lang dictionary_id='32379.Lütfen Proje Seçiniz'>!");
				return false;
			}
			</cfif>
		</cfif>
		if(int_s_flag==1)
		{
            $("#form_basket_order").attr('action', '<cfoutput>#request.self#?fuseaction=objects.display_file_phl&from_where=#attributes.from_where#</cfoutput>');           
			return true;
		}
		else
		{
			form_basket_order.action = "<cfoutput>#str_link#</cfoutput>";
			return true;
		}
	}
	function check_company_info()
	{
		if((form_basket_order.consumer_id.value=='' && form_basket_order.company_id.value=='') || form_basket_order.comp_name.value=='')
		{
			alert("<cf_get_lang dictionary_id='58965.Önce Cari Hesap Seçiniz'>!");
			if(document.getElementById("phl_price_catid_") != undefined) 
                form_basket_order.phl_price_catid_.value='';
            else
                form_basket_order.price_catid.value='';
			return false;
		}
	}
</script>
