<cfif isdefined('session.pp.userid')>
	<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(partner_id:session.pp.userid)>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
	<cfset getDemand = cmp.getDemand(demand_id:attributes.demand_id,my_demand=1) />
	<cfset getProductCat = cmp.getProductCat(demand_id:attributes.demand_id) />
	<cfif getDemand.recordcount and getDemand.company_id eq session.pp.company_id>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1><cfoutput>#getDemand.demand_head#</cfoutput></h1></div>
			</div>
			<div class="talep_detay">
				<div class="talep_detay_1">
					<cfform name="upd_demand" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_upd_demand">
						<input type="hidden" name="demand_id" id="demand_id" value="<cfoutput>#attributes.demand_id#</cfoutput>" />
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getDemand.company_id#</cfoutput>">
						<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#getDemand.partner_id#</cfoutput>">
						<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#session.pp.company#</cfoutput>">
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1" style="width:598px;">
									<h2><cf_get_lang no="89.Talep Bilgileri"></h2>
								</div>
								<div class="td_kutu_2">
									<table>
										<cfif session.pp.userid eq getPartner.manager_partner_id>
											<tr height="25">
												<td><cf_get_lang_main no='344.Durum'></td>
												<td><div class="ftd_kutu_21">
														<input type="checkbox" value="1" name="is_status" id="is_status" <cfif getDemand.is_status eq 1>checked</cfif> class="kutu_ckb_1"  /> 
														<samp><cf_get_lang_main no='81.Aktif'></samp>
													</div>
												</td>
											</tr>
											<tr>
												<td><cf_get_lang_main no="1447.S�re�"></td>
												<td><cf_workcube_process is_upd='0' select_value='#getDemand.stage_id#' process_cat_width="200" is_detail='1'></td>
											</tr>
										<cfelse>
											<input type="hidden" name="is_status" id="is_status" value="<cfoutput>#getDemand.is_status#</cfoutput>"  />
											<div style="display:none;"><cf_workcube_process is_upd='0' select_value='#getDemand.stage_id#' is_detail='1'></div>
										</cfif>
										<tr height="25">
											<td><cf_get_lang no="81.Talep T�r�"> *</td>
											<td><div class="ftd_kutu_21">
													<input type="radio" value="1" name="demand_type" id="demand_type" <cfif getDemand.demand_type eq 1>checked="checked"</cfif> class="kutu_ckb_1"  />
													<samp><cf_get_lang no='13.Alis Talebi'></samp>
													<input type="radio" value="2" name="demand_type" id="demand_type" <cfif getDemand.demand_type eq 2>checked="checked"</cfif> class="kutu_ckb_1"  />
													<samp><cf_get_lang no='16.Satis Talebi'></samp>
												</div>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang no='6.Yetkilendirme'> *</td>
											<td><div class="ftd_kutu_21">
													<input type="radio" value="1" name="order_member_type" id="order_member_type" <cfif getDemand.order_member_type eq 1>checked="checked"</cfif> class="kutu_ckb_1" />
													<samp><cf_get_lang no='9.Herkese Acik'></samp>
													<input type="radio" value="2" name="order_member_type" id="order_member_type" <cfif getDemand.order_member_type eq 2>checked="checked"</cfif> class="kutu_ckb_1" /> 
													<samp><cf_get_lang no='10.Uyelerime Acik'></samp>
												</div>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='167.Sekt�r'> *</td>
											<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Se�iniz'></cfsavecontent>
												<cf_wrk_selectlang 
													name="sector_cat_id"
													option_name="sector_cat"
													option_value="sector_cat_id"
													width="200"
													table_name="SETUP_SECTOR_CATS"
													option_text="#text#" value=#getDemand.SECTOR_CAT_ID#>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang no='88.Talep'> *</td>
											<td><input type="text" name="demand_head" id="demand_head"  value="<cfoutput>#getDemand.demand_head#</cfoutput>" maxlength="200" style="width:400px;"/></td>
										</tr>
										<tr height="25">
											<td valign="top"><cf_get_lang_main no='155.�r�n Kategorileri'> *</td>
											<td valign="top">
												<select name="product_category" id="product_category" style="width:400px; height:80px;" multiple>
													<cfif getProductCat.recordcount>
														<cfoutput query="getProductCat">
															<cfset hierarchy_ = "">
															<cfset new_name = "">
															<cfloop list="#HIERARCHY#" delimiters="." index="hi">
																<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
																<cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
																<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
															</cfloop>
															<option value="#product_catid#">#new_name#</option>
														</cfoutput>
													</cfif>
												</select>
												<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.upd_demand.product_category','medium');">
													<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
												</a>
												<a href="javascript://" onClick="remove_field('product_category');"><img src="../documents/templates/worknet/tasarim/icon_8.png" width="22" height="22" /></a>
											</td>
										 </tr>
										<tr height="25">
											<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
											<td><input type="text" name="demand_keyword" id="demand_keyword" maxlength="250" value="<cfoutput>#getDemand.demand_keyword#</cfoutput>" style="width:400px;"/></td>
										</tr>
										<tr>
											<td><cf_get_lang no='84.Yayin Tarihi'> *</td>
											<td>
												<div class="ftd_kutu_21">
													<input type="text" name="start_date" id="start_date" value="<cfoutput>#dateformat(getDemand.start_date,dateformat_style)#</cfoutput>" maxlength="10" style="float:left; width:70px;margin-right:5px;"/>
													<cf_wrk_date_image date_field="start_date">
													<input type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(getDemand.finish_date,dateformat_style)#</cfoutput>" maxlength="10" style="display:inline; margin-left:10px;float:left;width:70px;margin-right:5px;" />
													<cf_wrk_date_image date_field="finish_date">
												</div>
											</td>
										</tr>
										<tr height="10"><td>&nbsp;</td></tr>
										<tr>
											<td valign="top"><cf_get_lang_main no='217.A�iklama'> *</td>
											<td>
												<textarea 
													style="width:450px; height:200px;" 
													name="demand_detail" 
													id="demand_detail" ><cfoutput>#getDemand.detail#</cfoutput></textarea>
											</td>
										</tr>
										<tr height="25">
											<td><cf_get_lang_main no='487.Kaydeden'></td>
											<td><div class="ftd_kutu_21">
													<cfoutput><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getDemand.partner_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getDemand.partner_name# - 
													#dateformat(getDemand.record_date,dateformat_style)# #timeformat(date_add('h',session.pp.time_zone,getDemand.record_date),timeformat_style)#</cfoutput></a>
												</div>
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1" style="width:598px;">
									<h2><cf_get_lang no='12.Fiyat ve Teslimat'></h2>
								</div>
								<div class="td_kutu_2">
									<table>
										<tr>
											<td><cf_get_lang_main no='672.Fiyat'></td>
											<td>
												<cfinput type="text" name="total_amount" style="width:90px; float:left; margin-right:5px;" value="#tlformat(getDemand.total_amount)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
												<cfquery name="GET_MONEYS" datasource="#DSN#">
													SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id#
												</cfquery>
												<select name="MONEY" style="width:50px;">
												  <cfoutput query="get_moneys">
													<option value="#money#"<cfif money is getDemand.money>selected</cfif>>#money#</option>
												  </cfoutput>
												</select>
											</td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='233.Teslim Tarihi'></td>
											<td><div class="ftd_kutu_21">
													<input type="text" name="deliver_date" id="deliver_date" value="<cfoutput>#dateformat(getDemand.deliver_date,dateformat_style)#</cfoutput>" maxlength="10" style="float:left; width:70px;margin-right:5px;"/>
													<cf_wrk_date_image date_field="deliver_date">
												</div>
											</td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='1037.Teslim Yeri'></td>
											<td><input type="text" name="deliver_addres" id="deliver_addres" value="<cfoutput>#getDemand.deliver_addres#</cfoutput>" style="width:200px;" maxlength="250"> </td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='1104.�deme Y�ntemi'></td>
											<td><input type="text" name="paymethod" id="paymethod" value="<cfoutput>#getDemand.paymethod#</cfoutput>" style="width:200px;" maxlength="250"></td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='1703.Sevk Y�ntemi'></td>
											<td><input type="text" name="ship_method" id="ship_method" value="<cfoutput>#getDemand.ship_method#</cfoutput>" style="width:200px;" maxlength="250"></td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='223.Miktar'></td>
											<td><cfinput type="text" name="quantity" id="quantity" value="#tlformat(getDemand.quantity)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""" style="width:70px;" maxlength="50"></td>
										</tr>
										<tr>
											<td><cf_get_lang no='236.Renk'></td>
											<td><input type="text" name="colour" id="colour" value="<cfoutput>#getDemand.colour#</cfoutput>" style="width:200px;" maxlength="150" ></td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='519.Cins'></td>
											<td><input type="text" name="demand_kind" id="demand_kind" value="<cfoutput>#getDemand.type#</cfoutput>" style="width:200px;" maxlength="150" ></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
                        <div style="width:600px; text-align:right; margin-top:10px;">
                            <cfsavecontent variable="message"><cf_get_lang_main no="52.G�ncelle"></cfsavecontent>
                            <cfif session.pp.userid eq getPartner.manager_partner_id or session.pp.userid eq getDemand.partner_id>
                                <input class="btn_1" type="button" onClick="kontrol(1)" value="<cfoutput>#message#</cfoutput>" />
                            <cfelse>
                                <input class="btn_1" type="button" onClick="kontrol(2)" value="<cfoutput>#message#</cfoutput>" />
                            </cfif>
                        </div>
					</cfform>
				</div>
				<div class="talep_detay_2">
					<div style="margin-top:10px;">
						<div class="talep_detay_222">
							<ul>
								<li><a class="talep_detay_222a aktif"><cf_get_lang_main no='156.Belgeler'></a></li>
								<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
									<a href="javascript://" data-width="300px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
										<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
									</a>
								</cfif>
							</ul>
						</div>
						<cf_box id="relation_assets" style="width:290px;" title=" " design_type="1" closable="0" collapsable="0" refresh="0" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.demand_id#&action_section=DEMAND_ID&asset_cat_id=-11"
							add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#attributes.demand_id#&action_section=DEMAND_ID&asset_cat_id=-11','body_relation_assets',2,'Loading..')" class="pod_box1">
						</cf_box>
					</div>
					<!--- tiklanma sayisi --->
					<div class="dashboard_11">
						<span><img src="../documents/templates/worknet/tasarim/kutu_icon_8.png" class="chapterImage" alt="Icon" /></span>
					  <h2><cf_get_lang no='281.Tiklanma Sayilari'></h2>
					  <samp><cfoutput>#createObject("component","worknet.objects.worknet_objects").getVisit(process_type:'demand',process_id:attributes.demand_id)#</cfoutput></samp>
					</div>
				</div>
			</div>
		</div>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
	<script language="javascript">
		function select_all(selected_field)
		{
			var m = eval("document.upd_demand." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.upd_demand."+selected_field+"["+i+"].selected=true");
			}
		}
		function remove_field(field_option_name)
		{
			field_option_name_value = document.getElementById(field_option_name);
			for (i=field_option_name_value.options.length-1;i>-1;i--)
			{
				if (field_option_name_value.options[i].selected==true)
				{
					field_option_name_value.options.remove(i);
				}	
			}
		}
		function kontrol(record_type)
		{
			if(record_type == 2)
			{
				alert('Talebi g�ncellemek i�in talebi kaydeden kisiye ulasiniz l�tfen. Talebi kaydeden kisi g�ncelleyebilir.');
				return false;
			}
			else
			{
				select_all('product_category');
				document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);
				document.getElementById('quantity').value = filterNum(document.getElementById('quantity').value);
		
				if(document.getElementById('sector_cat_id').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='167.Sekt�r'>");
					document.getElementById('sector_cat_id').focus();
					return false;
				}
				
				if(document.getElementById('demand_head').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='88.Talep'>");
					document.getElementById('demand_head').focus();
					return false;
				}
				if(document.getElementById('product_category').value == '' )
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='155.�r�n Kategorileri'>");
					document.getElementById('product_category').focus();
					return false;
				}
				if(document.getElementById('demand_keyword').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>");
					document.getElementById('demand_keyword').focus();
					return false;
				}
				if(document.getElementById('demand_detail').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.A�iklama'>!");
					document.getElementById('demand_detail').focus();
					return false;
				}
				if(document.getElementById('start_date').value == '' || document.getElementById('finish_date').value == '')
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='84.Yayin Tarihi'>");
					document.getElementById('start_date').focus();
					return false;
				}
				
				if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang no='21.Yayin bitis tarihi baslangi� tarihinden �nce olamaz'>!"))
				return false;
				
				if(confirm("<cf_get_lang_main no='123.Kaydetmek Istediginizden Emin Misiniz?'>")); else return false;
				
				document.getElementById('upd_demand').submit();
			}
		}
	</script>
<cfelse>
	<cfset session.error_text_wp = "Bu sayfalara erismek i�in Kurumsal Giris Yapmalisiniz!">
	<cfinclude template="member_login.cfm">
</cfif>
