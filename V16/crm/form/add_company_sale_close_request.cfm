<cfif isdefined("attributes.is_page") and not isdefined("attributes.consumer_id")>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Satışa Kapama Talebi','52001')#">
			<cfform name="add_event" method="post" action="">
			<input type="hidden" name="is_page" id="is_page" value="">
				<cf_box_search plus="0">
					<div class="form-group">
						<label><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="input-group">
							<input type="hidden" name="consumer_id" id="consumer_id" value="">
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="hidden" name="partner_name" id="partner_name" value="" readonly>
							<input type="text" name="company_name" id="company_name" value="" readonly>
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&is_buyer_seller=0&field_id=add_event.partner_id&field_comp_name=add_event.company_name&field_name=add_event.partner_name&field_comp_id=add_event.consumer_id&is_single=1&select_list=2,6');"></span>
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='all_select()'>
					</div>
				</cf_box_search>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		function all_select()
		{
			if(document.add_event.consumer_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='52021.Lütfen Müşteri Seçiniz'> !");
				return false;
			}
			else
				return true;
		}
	</script>
<cfelse>
	<cfif attributes.fuseaction eq 'crm.list_sales_close_request'><cf_catalystHeader></cfif>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT 
			COMPANY_BRANCH_RELATED.RELATED_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY_BRANCH_RELATED.IS_SELECT <> 0 AND
			BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.consumer_id# AND 
			BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
			(COMPANY_BRANCH_RELATED.MUSTERIDURUM = 3 OR COMPANY_BRANCH_RELATED.MUSTERIDURUM = 4)
			
	</cfquery>
	<cfquery name="GET_RELATED_BRANCH" dbtype="query">
		SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-9 col-md-9 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Satışa Kapama Talebi','52001')#">
        		<cfform name="add_note" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_sale_close_request">
        			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
					<cf_box_elements>	
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-is_active">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <label><input type="checkbox" value="1" name="is_active" id="is_active" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
                                </div>
                            </div>
							<div class="form-group" id="item-branch_name">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52056.Talep Eden Şube'> *</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="branch_id" id="branch_id" onChange="degistir()">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_branch">
                                            <option value="#branch_id#" <cfif listgetat(session.ep.user_location,2,'-') eq branch_id>selected</cfif>>#branch_name# (#related_id#)</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
							<div class="form-group" id="item-consumer_id">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput type="text" readonly name="cust" value="#attributes.consumer_id#">
                                </div>
                            </div>
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_workcube_process is_upd='0'	process_cat_width='193' is_detail='0'>
                                </div>
                            </div>
							<div class="form-group" id="item-fullname">
                                <label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="hidden" name="fullname" id="fullname" value="<cfoutput>#get_par_info(attributes.consumer_id,1,1,0)#</cfoutput>">
									<cfinput type="text" readonly name="ecz_name" value="#get_par_info(attributes.consumer_id,1,1,0)#">
                                </div>
                            </div>
						</div>
                    </cf_box_elements>

					<!--- Eczane Bilgileri -Ortak- --->
					<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
					<div id="eczane_bilgi_detaylari_">
						<cfinclude template="../display/display_customer_info.cfm">
						<cf_box_elements>
							<div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
								<div class="form-group" id="item-detail">
									<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><textarea style="height:80px;" name="detail" id="detail" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea></div>
								</div>
							</div>
						</cf_box_elements>
					</div>
					
					<div class="col col-12">
						<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
					</div>
        		</cfform>
			</cf_box>
        </div>
		<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
            <div id="general">
                <cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#attributes.consumer_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
            </div>
        </div>
	</div>

	<script type="text/javascript">
		function kontrol()
		{
			x = document.add_note.branch_id.selectedIndex;
			if (document.add_note.branch_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
				return false;
			}
			if(document.add_note.detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='52066.Lütfen Açıklama Giriniz'>!");
				return false;
			}
			return process_cat_control();
		}
		
		function degistir()
		{
			deger_branch_id_ilk = "";
			if(document.add_note.branch_id.value != "")
			{
				deger_branch_id_ilk = document.add_note.branch_id.value;;
			}
			reload_member_frame('branch_id=' + deger_branch_id_ilk);
		}
	</script>
</cfif>
