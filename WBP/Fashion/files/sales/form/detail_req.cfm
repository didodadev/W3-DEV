
<cfparam name="attributes.prop_id" default="">	
<cfparam name="attributes.product_size" default="">	
<cfparam name="attributes.color_size" default="">
<cfinclude template="../query/get_req.cfm">

<cfset attributes.pid=GET_OPPORTUNITY.product_id>	
<!--- <cfparam name="attributes.pid" default="">	 --->
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getSize = CreateCompenent.getSize(prop_id:#attributes.prop_id#);
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<cfoutput>
    <div class="row">
        <div class="col col-9 col-xs-12 uniqueRow">
			<div class="col col-12 col-md-12 col-xs-12" id="divTabMenu" style="padding:0;overflow:hidden;">
				<div id="slider" style="position:relative;">
					<div>	
				<cf_box id="sample_request" closable="0" unload_body = "1" title="MODEL & TASARIM YÖNETİMİ" >
					<cfform name="upd_opp" method="post" action="#request.self#?fuseaction=textile.emptypopup_upd_req" enctype="multipart/form-data">
						<cfset attributes.req_id=get_opportunity.req_id>
						<cfset attributes.is_saveimage=1>
						<cfinclude template="../display/dsp_sample_request.cfm">
					</cfform>	
				</cf_box>
					<cfsavecontent variable="message1"><cf_get_lang dictionary_id='62704.KUMAŞ DETAYLARI'></cfsavecontent>
					<cf_box id="list_supplier_k"
						box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&tableid=list_supplier_k&req_id=#attributes.req_id#&req_type=0&request_plan=1&req_stage=#get_opportunity.req_stage#"
						title="#message1#"
						closable="0">
				</cf_box>
				<cfsavecontent variable="message2"><cf_get_lang dictionary_id='62703.AKSESUAR DETAYLARI'></cfsavecontent>
				<cf_box id="list_supplier_a"
						box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier_a&tableid=list_supplier_a&req_id=#attributes.req_id#&req_type=1&request_plan=1&req_stage=#get_opportunity.req_stage#"
						title="#message2#"
						closable="0">
				</cf_box>
				<cfsavecontent variable="message2"><cf_get_lang dictionary_id='41264.İşçilik Fiyat Talepleri'></cfsavecontent>
				<cf_box id="list_process"
						box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_process_list&req_id=#attributes.req_id#&request_plan=1&req_stage=#get_opportunity.req_stage#&product_catid=#get_opportunity.PRODUCT_CAT_ID#"
						title="#message2#"
						closable="0">
				</cf_box>
				<cfsavecontent variable="message2"><cf_get_lang dictionary_id='62702.Diğer Giderler'></cfsavecontent>
				<cf_box id="list_process_gm"
						box_page="#request.self#?fuseaction=textile.emptypopup_ajax_req_process_list&req_id=#attributes.req_id#&gm&request_plan=1&req_stage=#get_opportunity.req_stage#"
						title="#message2#"
						closable="0">
					</cf_box>
					
						<!--- Belgeler --->
						<!---<cf_get_workcube_asset_textile id="olcu" title="ÖLÇÜ TABLOSU" company_id="#session.ep.company_id#" asset_cat_id="-3" module_id='99' action_section='OLCU_TABLO' action_id='#attributes.req_id#'>--->
					<cfquery name="get_images" datasource="#dsn3#">
						SELECT IMAGE_ID,MEASURE_FILENAME 
						FROM TEXTILE_SAMPLE_REQUEST_IMAGE 
						WHERE REQ_ID = #GET_OPPORTUNITY.req_id#
						ORDER BY IMAGE_ID DESC
					</cfquery>
					<!---ölçü tablosu--->
					<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62630.Ölçü Tablosu'>
					</cfsavecontent>
					<cf_box title="#message#">
						<cfform name="add_measure" action="#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=add" enctype="multipart/form-data">
						   <input type="file" name="olcu_tablo" value="">
						   <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#GET_OPPORTUNITY.req_id#</cfoutput>">
						   <input type="hidden" name="totalImagesCount" value="<cfoutput>#get_images.recordcount#</cfoutput>">
						   <input type="submit" value="Kaydet" height="80">
						   <div class="col col-12"> 	
								<table class="workDevList" id="body_olcu">
									<cfloop query="get_images">
										<tr>
											<td height="100"><a class="tableyazi" href="#request.self#?fuseaction=objects.popup_download_file&file_name=olcutablo/#get_images.measure_filename#"> #get_images.measure_filename#</a></td>
											<td height="100"> <a style="cursor:pointer;" onclick="javascript:if(confirm('#getLang('main',1057)#')) location.href='#request.self#?fuseaction=textile.emptypopup_sample_add_image&type=del&image_id=#get_images.IMAGE_ID#&req_id=#GET_OPPORTUNITY.req_id#'; else return false;"><i class="fa fa-minus" title="#getLang('','sil','57463')#"></i></a></td>
										</tr>
									</cfloop>
								</table>
						   </div>
					   </cfform>
					</cf_box>	
					<cf_get_textile_labor_critics company_id='#get_opportunity.company_id#' action_section='TEXTILE_SAMPLE_REQUEST' action_id='#attributes.req_id#'>
						<cf_box id="buttonsbar" >
							<div class="ui-form-list-btn">
								<div>
									<a href="javascript://" class="ui-btn ui-btn-success"id="btnstockcreate"><cf_get_lang dictionary_id='62705.Stok Oluştur'></a>
								</div>
								<div>
									<a href="javascsript://" class="ui-btn ui-btn-delete" id="btnorderadd"><cf_get_lang dictionary_id='41173.Sipariş Oluştur'></a>
								</div>
								<div>
									<a href="javacript://" class="ui-btn ui-btn-update" id="btnkanban"><cf_get_lang dictionary_id='38272.Kanban'></a>
								</div>
							</div>
						</cf_box>
					</div>	
				</div>
			</div>
        </div>
		<div class="col col-3 col-xs-12 uniqueRow">
			<cfinclude template="upd_req_sag.cfm">
		</div>
    </div>
</cfoutput>

<script type="text/javascript">
	
	function return_company()
	{
		if(document.getElementById('ref_member_type').value=='employee')
		{
			var emp_id=document.getElementById('ref_employee_id').value;
			var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
				document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
		}
		else
			return false;
	}
function fill_country(member_id,type)
{
	if(document.getElementById('country_id1') != undefined)
	{
		if(member_id==0)
		{
			if(document.getElementById('member_type').value=='partner')
			{
				member_id=document.getElementById('company_id1').value;
				type=1;
			}
			else if(document.getElementById('member_type').value=='consumer')
			{
				member_id=document.getElementById('member_id').value;
				type=2;
			}
		}
		document.getElementById('country_id1').value='';
		document.getElementById('sales_zone_id').value='';
		if(type == 1)
		{
			var sql = "SELECT COUNTRY,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id;
			get_country = wrk_query(sql,'dsn');
			if(get_country.COUNTRY!='' && get_country.COUNTRY!='undefined')
				document.getElementById('country_id1').value=get_country.COUNTRY;
			if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
		else if(type == 2)
		{
			var sql = "select SALES_COUNTY,TAX_COUNTRY_ID from CONSUMER WHERE CONSUMER_ID = " + member_id;
			get_country= wrk_query(sql,'dsn');
			if(get_country.TAX_COUNTRY_ID!='' && get_country.TAX_COUNTRY_ID!='undefined')
				document.getElementById('country_id1').value=get_country.TAX_COUNTRY_ID;
			if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;

		}
	}
}
function auto_sales_zone()
{
    var sql = "SELECT SZ.SZ_ID FROM SALES_ZONES_TEAM SZT,SALES_ZONES SZ WHERE SZ.SZ_ID = SZT.SALES_ZONES AND SZT.COUNTRY_ID = " + document.getElementById('country_id1').value;
	get_sales_zone_id = wrk_query(sql,'dsn');
    if(get_sales_zone_id.recordcount == 1)
    {
    	document.getElementById('sales_zone_id').value = get_sales_zone_id.SZ_ID;
		return false;
    }
	else if(get_sales_zone_id.recordcount == 0)
	{
		alert("<cf_get_lang no ='150.Ülke ile İlişkili Satış Bölgesi Bulunamadı'> !");
		return false;
	}
	else if(get_sales_zone_id.recordcount > 1)
	{
		alert("<cf_get_lang no ='153.Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır'> !");
		return false;
	}
}
// jQuery

        $(document).ready(function () {
				all_hide();

				$('#btnorderadd').click(function(){
					window.open('<cfoutput>#request.self#?fuseaction=textile.product_plan&event=add_order_assortment&pid=#get_opportunity.product_id#&req_id=#req_id#&project_id=#get_opportunity.project_id#&company_id=#get_opportunity.invoice_company_id#&partner_id=#get_opportunity.invoice_partner_id#&head=#get_opportunity_type.opportunity_type#&pcode=&type_id=#get_opportunity.req_type_id#</cfoutput>');
				});
				$('#btnstockcreate').click(function(){
					window.open('<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=add_stock&pid=#get_opportunity.product_id#&pcode=#get_opportunity.PRODUCT_CODE#&req_id=#req_id#</cfoutput>','list');
				});
				$('#btnkanban').click(function(){
					window.open('<cfoutput>#request.self#?fuseaction=project.projects&event=kanban&id=#get_opportunity.project_id#</cfoutput>');
				});

				<cfif isDefined("attributes.referal_page") and len(attributes.referal_page)>
						var open_box='<cfoutput>#attributes.referal_page#</cfoutput>';
						if(open_box=='fabric')
						{
							goster_('list_supplier_k');
						}
						else if(open_box=='accessory')
						{
							goster_('list_supplier_a');
						}
						else if(open_box=='list_process')
						{
							goster_('list_process');
						}
						else if(open_box=='list_process_gm')
						{
							goster_('list_process_gm');
						}
						else {
							goster_('sample_request');
						}
				<cfelse>
							goster_('sample_request');
				</cfif>
		});
		function goster_(goster_div)
		{
						var body_div='body_'+goster_div;
						var box=document.getElementById(body_div);
						
						if(box!=undefined && box.style.display=='none')
						{
							var a=$('#'+goster_div+' .pull-right a .catalyst-arrow-down').parent();
							a.click();

						}						
							
		}
		function gizle_goster_(gizle_div,goster_div)
		{
						var body_div='body_'+goster_div;
						var box=document.getElementById(body_div);
						
						if(box!=undefined && box.style.display=='none')
						{
							var a=$('#'+goster_div+' .pull-right a .catalyst-arrow-down').parent();
							a.click();

						}						
							var b=$('#'+gizle_div+' .pull-right a .catalyst-arrow-down').parent();
							b.click();
		}
		function box_refresh(div_)
		{
						var body_div='body_'+div_;
						var box=document.getElementById(body_div);
						
						
							var a=$('#'+div_+' .pull-right a .catalyst-refresh').parent();
							a.click();

										
						
		}
		function all_hide()
		{
			
	
			var body_div='body_'+'list_supplier_k';
			var box=document.getElementById(body_div);
						if(box!=undefined && box.style.display!='none')
						{
							var a=$('#list_supplier_k .pull-right a .catalyst-arrow-down').parent();
							a.click();
						}
			
			body_div='body_'+'list_supplier_a';
			box=document.getElementById(body_div);
						if(box!=undefined && box.style.display!='none')
						{
							var a=$('#list_supplier_a .pull-right a .catalyst-arrow-down').parent();
							a.click();
						}
			body_div='body_'+'list_process';
			box=document.getElementById(body_div);
						if(box!=undefined && box.style.display!='none')
						{
							var a=$('#list_process .pull-right a .catalyst-arrow-down').parent();
							a.click();
						}
						body_div='body_'+'list_process_gm';
			box=document.getElementById(body_div);
						if(box!=undefined && box.style.display!='none')
						{
							var a=$('#list_process_gm .pull-right a .catalyst-arrow-down').parent();
							a.click();
						}
			
			body_div='body_'+'sample_request';
			box=document.getElementById(body_div);
			if(box.style.display!='none')
						{
							var a=$('#sample_request .pull-right a .catalyst-arrow-down').parent();
							a.click();
						}
						
		
		}
		
		
</script>
<script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/WBP/Fashion/files/js/fileupload-min.js"></script>
<!---
  <style>
        .dropzone {
            border: 2px dashed #d3d3d3;
        }
    </style>
	--->