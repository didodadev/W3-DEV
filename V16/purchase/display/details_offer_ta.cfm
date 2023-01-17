<cf_xml_page_edit fuseact="purchase.detail_offer_ta">
<cfinclude template="../query/get_offer_detail.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_taxes.cfm">
<cfinclude template="../query/get_offer_currencies.cfm">
<cfinclude template="../query/get_setup_priority.cfm">
<cfinclude template="../query/get_stores.cfm">
<cfset attributes.basket_id = 5>
<cfif not get_offer_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
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
<cfset pageHead = "#getlang('main',2251)#: #get_offer_detail.offer_number#">
<cf_catalystHeader>
<div id="other_details">
	<div class="col col-9 col-xs-12">
		<!--- ÖZET --->
		<cfsavecontent variable="name_comp_box"><cf_get_lang dictionary_id="58052.Özet"></cfsavecontent>
		<cf_box id="offer_comparison" title="#name_comp_box#" collapsable="1" closable="0">
			<cfinclude template="list_offer_comparison.cfm">
		</cf_box>
		<!--- Gelen Teklifler (Teklif Karşılaştırma Tablosu) --->
		<cfif not len(get_offer_detail.for_offer_id)>
			<cf_box id="list_coming_offer" left_side="1" scroll="1" title="#getLang('','Gelen Teklifler',38685)#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=purchase.emptypopup_list_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#"></cf_box>
			
			<!--- Değerlendirmeler --->
			<cfsavecontent variable="title"><cf_get_lang dictionary_id="30955.Değerlendirmeler"></cfsavecontent>
			<cf_box 
				id="get_tech_avg_point_emp" 
				title="#title#" 
				collapsable="1" 
				closable="0"
				box_page="#request.self#?fuseaction=objects.technical_point&offer_id=#attributes.offer_id#">
			</cf_box>
		</cfif>
		
		<!--- Bağlantılı İşlemler --->
		<!--- <cf_get_related_rows action_id='#get_offer_detail.offer_id#' action_type="OFFER" is_popup="1"> --->
		<cfsavecontent variable="baglantili_islemler"><cf_get_lang dictionary_id="60115.Bağlantılı işlemler"></cfsavecontent>
		<cf_box title="#baglantili_islemler#" box_page="#request.self#?fuseaction=objects.emptypopup_ajax_dsp_relation_papers&action_id=#attributes.offer_id#&action_type=OFFER_ID"></cf_box>
		<!--- Iliskili Teminatlar --->
		<cfsavecontent variable="message_work"><cf_get_lang dictionary_id='57676.Teminatlar'></cfsavecontent>
		<cf_box 
		closable="0"
		box_page="#request.self#?fuseaction=objects.emptypopup_list_purchase_guarantee&offer_id=#attributes.offer_id#&give_take=0"
		title="#message_work#"></cf_box>
		<!--- Değerlendirme Formları---> 
		<cf_get_workcube_form_generator action_type='15' related_type='15' action_type_id='#url.offer_id#' design='1'>
		<!--- bütçe uygunluk kontrolü --->
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='60673.Bütçe Uygunluk Kontrolü'></cfsavecontent>
		<cf_box title="#title#" 
				closable="0" 
				refresh="1"
				box_page="#request.self#?fuseaction=objects.budget_compliance_check&offer_id=#attributes.offer_id#"
				>
		</cf_box>
	</div>		
	<div class="col col-3 col-xs-12">
		<!--- Süreç İşlemleri --->
		<cfquery name="get_coming_for_related_offer" datasource="#dsn3#">
			SELECT OFFER_ID,OFFER_NUMBER,OFFER_HEAD,OFFER_TO, OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE,REVISION_NUMBER FROM OFFER WHERE FOR_OFFER_ID = #attributes.offer_id# ORDER BY OFFER_TO_PARTNER, REVISION_OFFER_ID, REVISION_NUMBER
		</cfquery>
		<cfsavecontent variable="tender_method"><cf_get_lang dictionary_id="47808.İhale Yöntemi"></cfsavecontent>
		<cf_box id="process_management" title="#tender_method#" closable="0">
			<cfform name="form_process_management" method="post" action="" enctype="multipart/form-data">
				<cf_ajax_list>
					<tbody>
						<cfif isDefined("x_sales_tender_type") and x_sales_tender_type eq 1>
							<cfif len(get_offer_detail.TENDER_TYPE_ID)>
								<tr <cfif not isDefined("x_sales_tender_type") or not len(get_offer_detail.BARGAINING_TYPE_ID)>style="border-bottom:2px solid #D8D5D5;"</cfif>>
									<td colspan="2" class="text-center">
										<cfoutput>
											<cfquery name="get_tender_types" datasource="#dsn3#">
												SELECT TENDER_TYPE FROM PURCHASE_SALES_TENDER_TYPE WHERE TENDER_TYPE_ID = #get_offer_detail.TENDER_TYPE_ID#
											</cfquery>
											#get_tender_types.TENDER_TYPE#
										</cfoutput>
									</td>
								</tr>
							</cfif>
						</cfif>
						<cfif isDefined("x_sales_bargaining_type") and x_sales_bargaining_type eq 1>
							<cfif len(get_offer_detail.BARGAINING_TYPE_ID)>
								<cfset bargaining_list = "Açık Eksiltme,Açık Arttırma,Kapalı Zarf,Pazarlık Usulü">
								<tr>
									<td colspan="2" class="text-center">
										<cfoutput>
											#listGetAt(bargaining_list,get_offer_detail.BARGAINING_TYPE_ID)#
										</cfoutput>
									</td>
								</tr>
							</cfif>
						</cfif>
						<tr>
							<td>
								<cf_get_lang dictionary_id='38503.Teklif Son Tarihi'>:
							</td>
							<td>
								<cfoutput>
									<cfif len(get_offer_detail.offer_finishdate)>
										#dateformat(get_offer_detail.offer_finishdate,dateformat_style)# #NumberFormat("#datepart("H",get_offer_detail.offer_finishdate)#",00)#:#NumberFormat("#datepart("N",get_offer_detail.offer_finishdate)#",00)#
									<cfelse>
										-
									</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id='38607.Yayın Başlama'>:
							</td>
							<td>
								<cfoutput>
									<cfif len(get_offer_detail.startdate)>
										#dateformat(get_offer_detail.startdate,dateformat_style)# #NumberFormat("#datepart("H",get_offer_detail.startdate)#",00)#:#NumberFormat("#datepart("N",get_offer_detail.startdate)#",00)#
									<cfelse>
										-
									</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id='38611.Yayın Bitiş'>:
							</td>
							<td>
								<cfoutput>
									<cfif len(get_offer_detail.finishdate)>
										#dateformat(get_offer_detail.finishdate,dateformat_style)# #NumberFormat("#datepart("H",get_offer_detail.finishdate)#",00)#:#NumberFormat("#datepart("N",get_offer_detail.finishdate)#",00)#
									<cfelse>
										-
									</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id='38655.Teklif Tarihi'>:
							</td>
							<td>
								<cfoutput>
									<cfif len(get_offer_detail.offer_date)>
										#dateformat(get_offer_detail.offer_date,dateformat_style)# #NumberFormat("#datepart("H",get_offer_detail.offer_date)#",00)#:#NumberFormat("#datepart("N",get_offer_detail.offer_date)#",00)#
									<cfelse>
										-
									</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="form-group">
									<label>
										<cf_get_lang dictionary_id="59513.En uygun teklifi seçin">
									</label>
									<select name="selected_offer" id="selected_offer">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<cfoutput query="get_coming_for_related_offer">
											<option value="#OFFER_ID#" <cfif get_offer_detail.accepted_offer_id eq OFFER_ID>selected</cfif>>#get_par_info(listdeleteduplicates(offer_to_partner),0,1,0,1)#/#OFFER_NUMBER#<cfif REVISION_NUMBER neq ''>/R-#REVISION_NUMBER#</cfif></option>
										</cfoutput>
										<option value="0" <cfif get_offer_detail.accepted_offer_id eq 0 or not len(get_offer_detail.accepted_offer_id)>selected</cfif>><cf_get_lang dictionary_id="59647.Birden çok tedarikçiden"></option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="form-group">
									<label>
										<cf_get_lang dictionary_id='58859.Süreç'>*
									</label>
									<cf_workcube_process is_upd='0' select_value='#get_offer_detail.offer_stage#' process_cat_width='130' is_detail='1'>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="form-group">
									<label>
										<cf_get_lang dictionary_id='57742.Tarih'>
									</label>
									<div class="col col-12 col-xs-12 pdnl pdnr">
										<div class="input-group" style="border-collapse:collapse;">
											<cfif len(get_offer_detail.accepted_offer_date)>
												<cfset accepted_date = dateformat(get_offer_detail.accepted_offer_date,dateformat_style)>
											<cfelse>
												<cfset accepted_date = dateformat(now(),dateformat_style)>
											</cfif>
											<cfinput type="text" name="selected_date" value="#accepted_date#" validate="#validate_style#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="selected_date"></span>
										</div>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align:right;">
								<div class="form-group">
									<input type="button" id="Save" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='59031.Kaydet'>" onclick="if(confirm('Kaydetmek istediğinize emin misiniz?'))updatedOffer()"/>
								</div>
							</td>
						</tr>
					</tbody>
				</cf_ajax_list>
			</cfform>
		</cf_box>
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
		<!--- Ekip --->
		<cf_box 
			id="workgroup" 
			title="#getLang('campaign',44)#" 
			box_page="#request.self#?fuseaction=project.list_workgroup&action_field=OFFER_ID&action_id=#attributes.offer_id#">
		</cf_box>
		</div>
</div>
<script type="text/javascript">
	function updatedOffer() {
		if($("#selected_offer").val() == ''){
			alert("<cf_get_lang dictionary_id='58194.Zorunlu alan'>: <cf_get_lang dictionary_id='57545.Teklif'>");
			$("#selected_offer").focus();
			return false;
		}
		offer_id = <cfoutput>#attributes.offer_id#</cfoutput>;
		accepted_offer = $("#selected_offer").val();
		offer_stage = $("#process_stage").val();
		accepted_date = $("#selected_date").val();
		old_process_line = $("#old_process_line").val();
		fuseaction = "<cfoutput>#attributes.fuseaction#</cfoutput>";
		$.ajax({ 
            type:'POST',  
            url:'V16/purchase/cfc/offer_management.cfc?method=UPD_OFFER_PROCESS',
            data: { 
				offer_id : offer_id,
				accepted_offer:accepted_offer,
				offer_stage:offer_stage,
				accepted_date:accepted_date,
				old_process_line:old_process_line,
				fuseaction:fuseaction
            },
            success: function(returnData){
                if(returnData.substring(0,4) == "true"){
					alert("<cf_get_lang dictionary_id='44003.İşlem Başarılı'>");
					/* window.location.href = "<cfoutput>#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#attributes.offer_id#</cfoutput>"; */
				}
				else{
					alert("<cf_get_lang dictionary_id='29917.Hata oluştu'>");
					return false;
                }
            },
            error: function ()
            {
                console.log('CODE:8 please, try again..');
                return false;
            }
        });
		return false;
	}
</script>
</cfif>