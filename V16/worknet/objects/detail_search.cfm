<cfheader name="expires" value="#now()#"> 
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<table id="container" style="width:900px;"><!--- Container table --->
	<tr><!--- Uye arama Formu tr --->
		<td>
			<div class="haber_liste_1" onclick="gizle_goster_image('uye_open','uye_closed','uye_');close_others('uye');">
				<div class="haber_liste_11">
					<a href="javascript://" onclick="gizle_goster_image('uye_open','uye_closed','uye_');close_others('uye');">
						<img src="../documents/templates/worknet/tasarim/stf_icon_3.png" onclick="gizle_goster_image('uye_open','uye_closed','uye_');close_others('uye');" border="0" id="uye_closed" style="display:none;  padding-right:10px;">
						<img src="../documents/templates/worknet/tasarim/stf_icon_15.png" onclick="gizle_goster_image('uye_open','uye_closed','uye_');close_others('uye');" id="uye_open" border="0" style="padding-right:10px;">
					</a>
						<h1><cf_get_lang_main no='5.Üye'></h1>
				</div>
			</div>
			<cfform name="detail_search_uye" id="detail_search_uye" method="post"  action="#request.self#?fuseaction=worknet.list_member">
				<table id="uye_"  style="width:100%"> 
					<tr style="height:25px;"> 
						<td style="width:80px; "><cf_get_lang_main no='48.Filtre'></td>
						<td style="width:160px">
							<input type="text" name="keyword" id="keyword_uye" style="width:150px;" >
						</td>
						<td style="width:80px"><cf_get_lang_main no='807.Ülke'> </td>
						<td style="width:160px"> <!--- Ülke --->
							<cfset getCountry = cmp.getCountry() />
                            <select name="country" id="country_uye" style="width:150px;" onChange="change_city('uye');">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="getCountry">
	                                <option value="#country_id#">#country_name#</option>
                                </cfoutput>
                            </select>
						</td>
						<td rowspan="3" valign="top"><cf_get_lang_main no='1604.Ürün Kategorisi'></td><!--- Ürün kategorisi --->
						<td rowspan="3" style="width:330px">
							<select name="product_catid" id="product_catid_uye" style="width:300px; height:75px;" multiple></select>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.detail_search_uye.product_catid&return_field=product_catid_uye','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
								<a href="javascript://" onClick="remove_field('product_catid_uye');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
							<input type="hidden" name="product_cat" id="product_cat_uye"  >
						</td>
                    </tr>
                    <tr style="height:25px">
                    	<!---Firma tipi --->
                    	<td><cf_get_lang no='31.Firma Tipi'></td>
                    	<td> 
                            <cf_multiselect_check 
                            table_name="SETUP_FIRM_TYPE"  
                            name="firm_type_uye"
                            width="150" 
                            option_name="firm_type" 
                            option_value="firm_type_id">
                    	</td>
                    	<td><cf_get_lang_main no='559.Şehir'></td>
                    	<td style="width:160px;">
                    	<!--- Sehir --->
							<cfset getCity = cmp.getCity() />
                            <select name="city" id="city_uye" style="width:150px;" onChange="change_county('uye');">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <!---<cfoutput query="getCity">
                                    <option value="#city_id#" >#city_name#</option>
                                </cfoutput>--->
                            </select> 
                    	</td>
                    </tr>
                    <tr style="height:25px;">  
                        <td><cf_get_lang_main no='167.Sektör'></td>
                        <td>
                        <!--- Sektor --->
                         <cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
                            <cf_wrk_selectlang 
                                name="sector"
                                option_name="sector_cat"
                                option_value="sector_cat_id"
                                width="150"
                                table_name="SETUP_SECTOR_CATS"
                                option_text="#text#" value="">
                        </td>
                        <td><cf_get_lang_main no='1226.İlçe'> </td>
                        <td style="width:160px;">
                        <!--- Ilce --->
                            <cfset getCounty = cmp.getCounty() />
                            <select name="county" id="county_uye" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <!---<cfoutput query="getCounty">
                                    <option value="#county_id#">#county_name#</option>
                                </cfoutput>--->
                            </select>
                        </td>
                    </tr>
                	<tr style="height:25px;">
                        <td colspan="5"></td>
                        <td>
                            <input type="button" name="submit_uye" id="submit_uye" onclick="kontrol('product_catid_uye','detail_search_uye','product_cat_uye')"  value="<cf_get_lang_main no='153.Ara'>" style="width:100px;" > 
                        </td>
					</tr>
				</table>
			</cfform>
		</td>
   </tr>
   <tr><!--- Talep Arama Formu tr --->
		<td>
			<div class="haber_liste_1" onclick="gizle_goster_image('talep_closed','talep_open','talep_');close_others('talep');" >
				<div class="haber_liste_11" ><a href="javascript://" onclick="gizle_goster_image('talep_closed','talep_open','talep_');close_others('talep');">
					<img src="../documents/templates/worknet/tasarim/stf_icon_3.png" onclick="gizle_goster_image('talep_closed','talep_open','talep_');close_others('talep');" border="0" id="talep_open" style="padding-right:10px">
						<img src="../documents/templates/worknet/tasarim/stf_icon_15.png" onclick="gizle_goster_image('talep_closed','talep_open','talep_');close_others('talep');" id="talep_closed" border="0" style="display:none; padding-right:10px;">
					</a><h1><cf_get_lang_main no='115.Talepler'></h1>
				</div>
			</div>
			<cfform name="detail_search_talep" id="detail_search_talep" action="#request.self#?fuseaction=worknet.list_demand">
			<table id="talep_" style="display:none; width:100%">
				<tr style="height:25px;">
					<td style="width:80px;"><cf_get_lang_main no='48.Filtre'></td>
					<td style="width:160px;">
						<input type="text" name="keyword" id="keyword" style="width:150px;" />
					</td>
					<td style="width:80px"><cf_get_lang_main no='807.Ülke'></td>
					<td style="width:160px;"><!--- Ülke --->
						<cfset getCountry = cmp.getCountry() />
						<select name="country" id="country_demand" style="width:150px;" onChange="change_city('demand');">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCountry">
								<option value="#country_id#">#country_name#</option>
							</cfoutput>
						</select>
					</td>
					 <td rowspan="3" valign="top"><cf_get_lang_main no='1604.Ürün Kategorisi'></td>
						<!--- Ürün kategorisi --->
					<td rowspan="3" style="width:330px;">
						<select name="product_catid" id="product_catid_talep" style="width:300px; height:75px;" multiple></select>
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.detail_search.product_catid_talep&return_field=product_catid_talep','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
                            <a href="javascript://" onClick="remove_field('product_catid_talep');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
						<input type="hidden" name="product_cat" id="product_cat_talep"  >
					</td>
				</tr>
				<tr style="height:25px;">
					<td><cf_get_lang_main no='167.Sektör'></td>
					<td><!--- Sektor --->
					 <cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
						<cf_wrk_selectlang 
							name="sector"
							option_name="sector_cat"
							option_value="sector_cat_id"
							width="150"
							table_name="SETUP_SECTOR_CATS"
							option_text="#text#" value="">
					</td>
					<td><cf_get_lang_main no='559.City'></td>
					<td>
						<!--- Sehir --->
						<cfset getCity = cmp.getCity() />
						<select name="city" id="city_demand" style="width:150px;" onChange="change_county('demand');">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<!---<cfoutput query="getCity">
								<option value="#city_id#" >#city_name#</option>
							</cfoutput>--->
						</select> 
					</td>
				 </tr>
				 <tr style="height:25px;">
					<td><cf_get_lang no='81.Talep Türü'></td>
					<td>
						<!--- Talep Türü --->
						<select name="demand_type" id="demand_type" style="width:150px;">
							<option value=""><cf_get_lang_main no='296.Tümü'></option>
							<option value="1"><cf_get_lang no='79.Alım'></option>
							<option value="2"><cf_get_lang no='80.Satım'></option>
						</select>
					 </td>
					 <td><cf_get_lang_main no='1226.İlçe'></td>
					 <td>
						<!--- Ilce --->
						<cfset getCounty = cmp.getCounty() />
						<select name="county" id="county_demand" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<!---<cfoutput query="getCounty">
								<option value="#county_id#">#county_name#</option>
							</cfoutput>--->
						</select>
					</td>
				</tr>
				<tr style="height:25px;">
					 <td><cf_get_lang no ='84.Yayin Tarihi'> </td>
					 <td colspan="2">
						<input type="text" name="start_date" id="start_date" value="" maxlength="10" style="width:65px; float:left">
						<cf_wrk_date_image date_field="start_date">
						<input type="text" name="finish_date" id="finish_date" value="" maxlength="10" style="width:65px;float:left">
						<cf_wrk_date_image date_field="finish_date">
					</td>
					<td colspan="2"></td>
					<td><input type="submit" name="submit_talep" id="submit_talep" onclick="return kontrol('product_catid_talep','detail_search_talep','product_cat_talep')"  value="<cf_get_lang_main no='153.Ara'>" style="width:90px;" ></td>
				</tr>
		</table>
		</cfform>
		</td>
	</tr>
	<tr><!--- Urun arama formu tr --->
		<td>
			<div class="haber_liste_1" onclick="gizle_goster_image('urun_closed','urun_open','urun_'); close_others('urun');"  >
				<div class="haber_liste_11" >
					<a href="javascript://" onclick="gizle_goster_image('urun_closed','urun_open','urun_'); close_others('urun');">
						<img src="../documents/templates/worknet/tasarim/stf_icon_3.png" onclick="gizle_goster_image('urun_closed','urun_open','urun_'); close_others('urun');" border="0" id="urun_open" style="padding-right:10px;">
						<img src="../documents/templates/worknet/tasarim/stf_icon_15.png" onclick="gizle_goster_image('urun_closed','urun_open','urun_'); close_others('urun');" id="urun_closed" border="0" style="display:none; padding-right:10px;">
					</a>
				 <h1><cf_get_lang_main no='152.Ürün'></h1>
				</div>
			</div>
			<cfform name="detail_search_urun" id="detail_search_urun" action="#request.self#?fuseaction=worknet.list_product">
				<table id="urun_" style="display:none; width:100%"> 
					<tr style="height:25px;"> 
						<td style="width:80px;"><cf_get_lang_main no='48.Filtre'></td>
						<td style="width:160px;">
							<input type="text" name="keyword" id="keyword" style="width:150px;"  />
						</td>
						<td style="width:80px;"><cf_get_lang_main no='807.Ülke'></td>
						<td style="width:160px"> <!--- Ülke --->
							<cfset getCountry = cmp.getCountry() />
								<select name="country" id="country_urun" style="width:150px;" onChange="change_city('urun');">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<cfoutput query="getCountry">
										<option value="#country_id#">#country_name#</option>
									</cfoutput>
								</select>
						</td>
						<td rowspan="3" valign="top"><cf_get_lang_main no='1604.Ürün Kategorisi'></td> <!--- Ürün kategorisi --->
						<td rowspan="3" style="width:330px;">
							<select name="product_catid" id="product_catid_urun" style="width:300px; height:75px;" multiple></select>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.detail_search.product_catid_urun&return_field=product_catid_urun','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
							<a href="javascript://" onClick="remove_field('product_catid_urun');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
							<input type="hidden" name="product_cat" id="product_cat_urun"  >
						</td>
					</tr>
					<tr style="height:25px;">
						 <!---Firma tipi --->
						 <td><cf_get_lang no='31.Firma Tipi'></td>
						 <td> 
							<cf_multiselect_check 
								table_name="SETUP_FIRM_TYPE"  
								name="firm_type"
								id="firm_type_urun"
								width="150" 
								option_name="firm_type" 
								option_value="firm_type_id">
						</td>
						<td><cf_get_lang_main no='559.City'></td>
						<td>
							<!--- Sehir --->
							<cfset getCity = cmp.getCity() />
                                <select name="city" id="city_urun" style="width:150px;" onChange="change_county('urun');">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <!---<cfoutput query="getCity">
                                        <option value="#city_id#" >#city_name#</option>
                                    </cfoutput>--->
                                </select> 
						</td>
					 </tr> 
					 <tr style="height:25px;">
						<td><cf_get_lang_main no='167.Sektör'></td>
						<td>
							<cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent> <!--- Sektör --->
								<cf_wrk_selectlang 
								name="sector"
								option_name="sector_cat"
								option_value="sector_cat_id"
								width="150"
								table_name="SETUP_SECTOR_CATS"
								option_text="#text#" value="">
						</td>
						<td rowspan="2" valign="top"><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<!--- Ilce --->
								<cfset getCounty = cmp.getCounty() />
								<select name="county" id="county_urun" style="width:150px;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<!---<cfoutput query="getCounty">
										<option value="#county_id#">#county_name#</option>
									</cfoutput>--->
								</select>
						</td>
					</tr>    
					<tr style="height:25px;"> 
						<td> <cf_get_lang no='239.Fotoğraf'></td>
						<td> <!--- fotoğraf --->
							<select name="photo_status" id="photo_status" style="width:150px;" >
								<option value=""><cf_get_lang_main no='296.Tümü'></option>
								<option value="1"><cf_get_lang_main no='83.Evet'></option>
								<option value="0"><cf_get_lang_main no='84.Hayır'></option>
							</select>
						</td> 
						<td colspan="2"></td> 
						<td><input type="button" name="submit_urun" id="submit_urun" onclick="kontrol('product_catid_urun','detail_search_urun','product_cat_urun')"  value="<cf_get_lang_main no='153.Ara'>" style="width:100px;" > </td>
				   </tr>
				</table>
			</cfform>
		 </td>
		</tr>
		<tr><!--- Kişi arama formu tr --->
			<td>
			<div class="haber_liste_1" onclick="gizle_goster_image('kisi_closed','kisi_open','kisi_');close_others('kisi');" >
				<div class="haber_liste_11" >
					<a href="javascript://" onclick="gizle_goster_image('kisi_closed','kisi_open','kisi_');close_others('kisi');" >
						<img src="../documents/templates/worknet/tasarim/stf_icon_3.png" onclick="gizle_goster_image('kisi_closed','kisi_open','kisi_');close_others('kisi');" border="0" id="kisi_open" style="padding-right:10px;">
						<img src="../documents/templates/worknet/tasarim/stf_icon_15.png" onclick="gizle_goster_image('kisi_closed','kisi_open','kisi_');close_others('kisi');" id="kisi_closed" border="0" style="display:none; padding-right:10px;">
					</a>
					<h1><cf_get_lang no='189.Kişi'></h1>
				</div>
			</div>
			<cfform name="detail_search_kisi" id="detail_search_kisi" action="#request.self#?fuseaction=worknet.list_partner">
				<table id="kisi_" style="display:none; width:100%">
                    <tr style="height:25px;">
                        <td style="width:80px;"><cf_get_lang_main no='48.Filtre'></td>
                        <td style="width:160px;">
                            <input type="text" name="keyword" id="keyword" style="width:150px;"  />
                        </td>
                        <td style="width:80px;"><cf_get_lang_main no='807.Ülke'></td>
                        <td style="width:160px;">
                            <cfset getCountry = cmp.getCountry() />
                            <select name="country" id="country_person" style="width:150px;" onChange="change_city('person');">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="getCountry">
                                    <option value="#country_id#">#country_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td rowspan="3" valign="top"><cf_get_lang_main no='1604.Ürün Kategorisi'></td>
                        <td rowspan="3" style="width:330px;">
                            <select name="product_catid" id="product_catid_kisi" style="width:300px; height:75px;" multiple></select>
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.detail_search.product_category&return_field=product_catid_kisi','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
                            <a href="javascript://" onClick="remove_field('product_category');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
                            <input type="hidden" name="product_cat" id="product_cat_kisi" value="">
                        </td>
                    </tr>
                    <tr style="height:25px;">
                        <td><cf_get_lang_main no='1085.Pozisyon'></td>
                        <td><!--- Posizyon Tipi --->
                            <cfset getPosition = cmp.getPartnerPositions() />
                            <select name="position" id="position" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="getPosition">
                                <option value="#PARTNER_POSITION_ID#">#PARTNER_POSITION#</option>
                            </cfoutput>
                            </select>
                        </td>
                        <td><cf_get_lang_main no='559.City'></td>
                        <td>
                        <!--- Sehir --->
                        <cfset getCity = cmp.getCity() />
                            <select name="city" id="city_person" style="width:150px;" onChange="change_county('person');">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <!---<cfoutput query="getCity">
                                        <option value="#city_id#" >#city_name#</option>
                                     </cfoutput>--->
                            </select> 
                   		</td>
                    </tr>
                    <tr style="height:25px;">
                    	<td><cf_get_lang_main no='167.Sektör'></td>   
						<td>
						  <!--- Sektor --->
							 <cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
								<cf_wrk_selectlang 
									name="sector"
									option_name="sector_cat"
									option_value="sector_cat_id"
									width="150"
									table_name="SETUP_SECTOR_CATS"
									option_text="#text#" value="">
						</td>
						<td><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<!--- Ilce --->
							<cfset getCounty = cmp.getCounty() />
							<select name="county" id="county_person" style="width:150px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<!---<cfoutput query="getCounty">
									<option value="#county_id#">#county_name#</option>
								</cfoutput>--->
							</select>
                   		</td>
                    </tr>
                    <tr style="height:25px;">
						<td><cf_get_lang_main no='344.Durum'></td>
						<td>
							<!--- Online Status --->
							<select name="is_online" id="is_online" style="width:150px;" >
								<option value=""><cf_get_lang_main no='296.Tümü'></option>
								<option value="1"><cf_get_lang no='56.Online'></option>
								<option value="0"><cf_get_lang no='142.Offline'></option>
							</select>
						</td>
						<td colspan="3">
						</td>
						<td>
							<input type="button" name="submit_kisi" id="submit_kisi" onclick="kontrol('product_catid_kisi','detail_search_kisi','product_cat_kisi')"  value="<cf_get_lang_main no='153.Ara'>" style="width:100px;" > 
						</td>
					</tr>
				</table>
			</cfform>
		</td>
	  </tr>
</table>
    
<script type="text/javascript">
	function close_others(keep_open)
	{
		if(keep_open == "urun")
		{
				if(document.getElementById('uye_').style.display != 'none'){
					gizle_goster_image('uye_open','uye_closed','uye_');
					document.getElementById('uye_').style.display = 'none';}
				if(document.getElementById('talep_').style.display != 'none' ){
					gizle_goster_image('talep_open','talep_closed','talep_');
					document.getElementById('talep_').style.display = 'none';}
				if(document.getElementById('kisi_').style.display != 'none' ){
					gizle_goster_image('kisi_open','kisi_closed','kisi_');
					document.getElementById('kisi_').style.display = 'none';}
		}
		if(keep_open == "kisi")
		{			
				if(document.getElementById('uye_').style.display != 'none')
				{
					gizle_goster_image('uye_open','uye_closed','uye_');
					document.getElementById('uye_').style.display = 'none';
				}
				if(document.getElementById('talep_').style.display != 'none' )
				{
					gizle_goster_image('talep_open','talep_closed','talep_');
					document.getElementById('talep_').style.display = 'none';
				}
				if(document.getElementById('urun_').style.display != 'none')
				{
					gizle_goster_image('urun_open','urun_closed','urun_');
					document.getElementById('urun_').style.display = 'none';
				}
		}
		if(keep_open == "talep")
		{			
				if(document.getElementById('uye_').style.display != 'none')
				{
					gizle_goster_image('uye_open','uye_closed','uye_');
					document.getElementById('uye_').style.display = 'none';
				}
				if(document.getElementById('kisi_').style.display != 'none' )
				{
					gizle_goster_image('kisi_open','kisi_closed','kisi_');
					document.getElementById('kisi_').style.display = 'none';
				}
				if(document.getElementById('urun_').style.display != 'none')
				{
					gizle_goster_image('urun_open','urun_closed','urun_');
					document.getElementById('urun_').style.display = 'none';
				}
		}
		if(keep_open == "uye")
		{			

				if(document.getElementById('kisi_').style.display != 'none')
				{
					gizle_goster_image('kisi_open','kisi_closed','kisi_');
					document.getElementById('kisi_').style.display = 'none';
				}
				if(document.getElementById('talep_').style.display != 'none' )
				{
					gizle_goster_image('talep_open','talep_closed','talep_');
					document.getElementById('talep_').style.display = 'none';
				}
				if(document.getElementById('urun_').style.display != 'none')
				{
					gizle_goster_image('urun_open','urun_closed','urun_');
					document.getElementById('urun_').style.display = 'none';
				}
		}
		
	}
	function change_city(area)
	{
		if(area == "uye")
		{
		var country_ = document.getElementById("country_uye").value;
		if(country_.length)
			LoadCity(country_,'city_uye','county_uye',0);
		}
		if(area == "urun")
		{
		var country_ = document.getElementById("country_urun").value;
		if(country_.length)
			LoadCity(country_,'city_urun','county_urun',0);
		}
		if(area == "person")
		{
		var country_ = document.getElementById("country_person").value;
		if(country_.length)
			LoadCity(country_,'city_person','county_person',0);
		}
		if(area == "demand")
		{
		var country_ = document.getElementById("country_demand").value;
		if(country_.length)
			LoadCity(country_,'city_demand','county_demand',0);
		}
	}
	function change_county(area)
	{
		if(area == "uye")
		{
		var city_ = document.getElementById("city_uye").value;
		if(city_.length)
			LoadCounty(city_,'county_uye');
		}
		if(area == "urun")
		{
		var city_ = document.getElementById("city_urun").value;
		if(city_.length)
			LoadCounty(city_,'county_urun');
		}
		if(area == "person")
		{
		var city_ = document.getElementById("city_person").value;
		if(city_.length)
			LoadCounty(city_,'county_person');
		}
		if(area == "demand")
		{
		var city_ = document.getElementById("city_demand").value;
		if(city_.length)
			LoadCounty(city_,'county_demand');
		}
	}
	function kontrol(element_item,form_name,hidden_id)
	{
		select_all(element_item,hidden_id);
		document.getElementById(form_name).submit();
	}
	function select_all(selected_field,hidden)
		{
			var m = document.getElementById(selected_field).options.length;
			if(m > 0)
			document.getElementById(hidden).value = document.getElementById(selected_field).options[0].text;
			for(i=0;i<m;i++)
			{
				document.getElementById(selected_field).options[i].selected = true;
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
	function renew()
		{
			document.getElementById('detail_search_uye').reset();
			document.getElementById('detail_search_kisi').reset();
			document.getElementById('detail_search_talep').reset();
			document.getElementById('detail_search_urun').reset();
						
		}
	
	window.onload = renew();
</script>
