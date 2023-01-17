<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.offer_type" default="1">
	
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
	<cfif attributes.offer_type eq 2>
		<cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite(action_type:"offer") />
		<cfset offer_id_list = valuelist(getFavorite.action_id,',')>
		<cfif len(offer_id_list)>
			<cfset getDemandOffer = createObject("component","V16.worknet.query.worknet_demand").getDemandOffer(
					keyword:attributes.keyword,
					offer_type:attributes.offer_type,
					demand_offer_id_list:offer_id_list
				) 
			/>
		<cfelse>
			<cfset getDemandOffer.recordcount = 0>
		</cfif>
	<cfelse>
		<cfset getDemandOffer = createObject("component","V16.worknet.query.worknet_demand").getDemandOffer(
			keyword:attributes.keyword,
			offer_type:attributes.offer_type
			) 
		/>
	</cfif>
	
	<cfparam name="attributes.totalrecords" default="#getDemandOffer.recordcount#">
	<div class="haber_liste">
		<div class="haber_liste_1">
			<cfform name="search_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.my_offers" method="post">
				<div class="haber_liste_11"><h1><cf_get_lang no="90.TEKLİFLER"></h1></div>
				<div class="haber_liste_12" style="width:32px;">
					<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
				</div>
				<div class="haber_liste_12" style="width:85px;">
					<select name="offer_type" id="offer_type" style="border:none;padding-bottom:3px; width:80px;">
						<option value="1" <cfif attributes.offer_type eq 1>selected</cfif>><cf_get_lang_main no ='1562.Gelen'></option>
						<option value="0" <cfif attributes.offer_type eq 0>selected</cfif>><cf_get_lang_main no ='1563.Giden'></option>
						<option value="2" <cfif attributes.offer_type eq 2>selected</cfif>><cf_get_lang no ='235.Favorilerim'></option>
					</select>
				</div>
				<div class="haber_liste_12" style="width:210px;">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
				</div>
			</cfform>
		</div>
		
		<div class="haber_liste_2">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
                <tr class="mesaj_31">
                    <td width="15" class="mesaj_311_1">No</td>
                    <td class="mesaj_311_1"><cf_get_lang_main no="246.Üye"></td>
                    <td class="mesaj_311_1"><cf_get_lang no="88.Talep"></td>
                    <td class="mesaj_311_1"><cf_get_lang no="83.Teklif Tarihi"></td> 
                    <td class="mesaj_311_1"><cf_get_lang no="81.Talep Türü"></td>
                    <td width="50" class="mesaj_311_1"></td>
                    <cfif attributes.offer_type eq 1>
	                    <td class="mesaj_311_1"></td>
                    </cfif>
                </tr>
				<cfif getDemandOffer.recordcount>
                    <cfoutput query="getDemandOffer" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <tr <cfif offer_status eq 1>style="font-weight:bold;"</cfif> <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                            <td class="tablo1">#currentrow#</td>
                            <td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#company_id#">#fullname# / #partner_name#</a></td>
                            <td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">#demand_head#</a></td>
                            <td class="tablo1">#dateformat(record_date,dateformat_style)#</td>
                            <td class="tablo1"><cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif></td>
                            <td class="tablo1"><a href="javascript://" onClick="open_div_offer(#currentrow#,#demand_offer_id#,#partner_id#)"><cf_get_lang_main no ='359.Detay'></a></td>
                            <cfif attributes.offer_type eq 1>
                                <td class="tablo2" style="padding-left:5px; padding-right:5px;">
                                    <cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite
										(action_id:demand_offer_id,
										action_type:"offer"
										) />					
									<cfif getFavorite.recordcount>
										<div class="talep_detay_21" style="display:none; margin-top:0px" id="add_favorite#currentrow#">
											<a href="javascript:" onClick="addFavorite(#currentrow#,#demand_offer_id#);"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
										</div>
										<div class="talep_detay_21" style="display:block; margin-top:0px" id="remove_favorite#currentrow#">
											<a href="javascript:" onClick="removeFavorite(#currentrow#,#demand_offer_id#);"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
										</div>
									<cfelse>
										<div class="talep_detay_21" style="display:block; margin-top:0px" id="add_favorite#currentrow#">
											<a href="javascript:" onClick="addFavorite(#currentrow#,#demand_offer_id#);"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
										</div>
										<div class="talep_detay_21" style="display:none; margin-top:0px" id="remove_favorite#currentrow#">
											<a href="javascript:" onClick="removeFavorite(#currentrow#,#demand_offer_id#);"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
										</div>
									</cfif>
                                </td>
                            </cfif>
                        </tr>
                        <tr>
                            <td colspan="7"><div id="detail_offer#currentrow#" style="display:none;background-color: #colorrow#;outset cccccc;"></div></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="mesaj_34">
                      <td class="tablo1" colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
           </table>
		</div>
		<div class="maincontent">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset urlstr="&keyword=#attributes.keyword#&offer_type=#attributes.offer_type#">
			
						  <cf_paging page="#attributes.page#" 
							page_type="1"
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#attributes.fuseaction##urlstr#">
						
			</cfif>
		</div>
	</div>
	<cfoutput>
	<script type="text/javascript">
		function open_div_offer(no,demand_offer_id,partner_id)
		{
			show_hide('detail_offer' + no);
			AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_display_detail_offer&offer_type=#attributes.offer_type#&demand_offer_id='+demand_offer_id +'&partner_id='+partner_id, 'detail_offer' + no,1);
		}
		
		function addFavorite(no,offer_id)
		{
			document.getElementById('add_favorite'+no).style.display = 'none';
			document.getElementById('remove_favorite'+no).style.display = 'block';
			AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id='+offer_id +'&action_type=offer&add=1',2);
		}
		function removeFavorite(no,offer_id)
		{
			document.getElementById('remove_favorite'+no).style.display = 'none';
			document.getElementById('add_favorite'+no).style.display = 'block';
			AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id='+offer_id +'&action_type=offer&add=0');
		}
	</script>
	</cfoutput>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
