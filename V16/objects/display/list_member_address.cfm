<!--- 
Kurumsal ve bireysel üye için adres popup ıdır
Kurumsal Uye -- Kurumsal Uye Adresleri + Subeleri 
Bireysel Uye -- Bireysel Uye Ev ve Is adresleri + Subelerinin Adresleri
AE 20051118
 --->
 <cfsetting showdebugoutput="yes">
 <cf_xml_page_edit fuseact="objects.popup_list_member_address">
<cfparam name="attributes.is_comp" default="1">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.tc_num" default=''>
<cfparam name="attributes.categories" default=''>
<cfparam name="attributes.select_list" default='1,2'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_select" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_list_member_adress.cfm">
<cfif isdefined("attributes.is_county_related_company")>
    <cfquery name="get_related" datasource="#dsn#"><!--- todo: SALES_ZONES_TEAM tablosundaki County alanı virgülle tutuluyor.Ayrı Bir tabloya taşınacak.Mail atıldı.DB adminden onay bekleniyor. --->
        SELECT
            C.COMPANY_ID,
            C.NICKNAME,
            SZTC.COUNTY_ID
        FROM 
            SALES_ZONES SZ,
            SALES_ZONES_TEAM SZT,
            SALES_ZONES_TEAM_COUNTY SZTC,
            COMPANY C
        WHERE 
            C.COMPANY_ID = SZ.RESPONSIBLE_COMPANY_ID AND
            SZ.SZ_ID = SZT.SALES_ZONES AND
            SZTC.COUNTY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(get_member.county,',')#" list="yes"> )
    </cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_member.query_count#'>
<cfset url_string = "">
<cfif isdefined("attributes.basket_cheque")>
	<cfset url_string = "#url_string#&basket_cheque=1">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_adres")>
	<cfset url_string = "#url_string#&field_adres=#attributes.field_adres#">
</cfif>
<cfif isdefined("attributes.field_long_adres")>
	<cfset url_string = "#url_string#&field_long_adres=#attributes.field_long_adres#">
</cfif>
<cfif isdefined("attributes.field_city")>
	<cfset url_string = "#url_string#&field_city=#attributes.field_city#">
</cfif>
<cfif isdefined("attributes.field_city_name")>
	<cfset url_string = "#url_string#&field_city_name=#attributes.field_city_name#">
</cfif>
<cfif isdefined("attributes.field_county")>
	<cfset url_string = "#url_string#&field_county=#attributes.field_county#">
</cfif>
<cfif isdefined("attributes.field_county_name")>
	<cfset url_string = "#url_string#&field_county_name=#attributes.field_county_name#">
</cfif>
<cfif isdefined("attributes.field_country")>
	<cfset url_string = "#url_string#&field_country=#attributes.field_country#">
</cfif>
<cfif isdefined("attributes.field_country_name")>
	<cfset url_string = "#url_string#&field_country_name=#attributes.field_country_name#">
</cfif>
<cfif isdefined("attributes.field_postcode")>
	<cfset url_string = "#url_string#&field_postcode=#attributes.field_postcode#">
</cfif>
<cfif isdefined("attributes.field_semt")>
	<cfset url_string = "#url_string#&field_semt=#attributes.field_semt#">
</cfif>
<cfif isdefined("attributes.field_member_id")>
	<cfset url_string = "#url_string#&field_member_id=#attributes.field_member_id#">
</cfif>
<cfif isdefined("attributes.field_adress_id")>
	<cfset url_string = "#url_string#&field_adress_id=#attributes.field_adress_id#">
</cfif>
<cfif isdefined("attributes.is_comp")>
	<cfset url_string = "#url_string#&is_comp=#attributes.is_comp#">
</cfif>
<cfif isdefined("attributes.select_list")>
	<cfset url_string = "#url_string#&select_list=#attributes.select_list#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isdefined("attributes.is_county_related_company")>
	<cfset url_string = "#url_string#&is_county_related_company=1">
</cfif>
<cfif isdefined("attributes.related_company")>
	<cfset url_string = "#url_string#&related_company=#attributes.related_company#">
</cfif>
<cfif isdefined("attributes.related_company_id")>
	<cfset url_string = "#url_string#&related_company_id=#attributes.related_company_id#">
</cfif>
<cfif isdefined("attributes.company_branch_id")>
	<cfset url_string = "#url_string#&company_branch_id=#attributes.company_branch_id#">
</cfif>
<cfif isdefined("attributes.company_branch_name")>
	<cfset url_string = "#url_string#&company_branch_name=#attributes.company_branch_name#">
</cfif>
<cfif isdefined("attributes.coordinate_1")>
	<cfset url_string = "#url_string#&coordinate_1=#attributes.coordinate_1#">
</cfif>
<cfif isdefined("attributes.coordinate_2")>
	<cfset url_string = "#url_string#&coordinate_2=#attributes.coordinate_2#">
</cfif>
<cfif isdefined("attributes.sales_zone")>
	<cfset url_string = "#url_string#&sales_zone=#attributes.sales_zone#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_string = "#url_string#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_string = "#url_string#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.member_type")>
	<cfset url_string = "#url_string#&member_type=#attributes.member_type#">
</cfif>
<cfif isdefined("attributes.member_name")>
	<cfset url_string = "#url_string#&member_name=#attributes.member_name#">
</cfif>
<cfif isdefined("attributes.alias")>
	<cfset url_string = "#url_string#&alias=#attributes.alias#">
</cfif>
<cfif isdefined("attributes.is_select") and not isdefined("attributes.alias")>
	<cfset url_string = "#url_string#&alias=#attributes.is_select#">
</cfif>

<!--- <table class="harfler">
	<tr>
		<td>
			<cfoutput>
				<td>&nbsp;</td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#">123</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=A">A</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=B">B</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=C">C</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Ç">Ç</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=D">D</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=E">E</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=F">F</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=G">G</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Ğ">Ğ</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=H">H</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=I">I</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=İ">İ</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=J">J</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=K">K</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=L">L</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=M">M</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=N">N</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=O">O</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Ö">Ö</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=P">P</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Q">Q</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=R">R</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=S">S</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Ş">Ş</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=T">T</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=U">U</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Ü">Ü</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=V">V</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=W">W</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Y">Y</a></td>
				<td><a href="#request.self#?fuseaction=objects.popup_list_member_address#url_string#&keyword=Z">Z</a></td>
				<td>&nbsp;</td>
			</cfoutput>
		</td>
	</tr>
</table> ---><!--- 
<cfset url_string = "#url_string#&keyword=#attributes.keyword#&tc_num=#attributes.tc_num#"> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Adresler',31388)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_comp" id="search_comp" method="post" action="#request.self#?fuseaction=objects.popup_list_member_address">
			<cfif isdefined("attributes.field_adres")>
				<input type="hidden" name="field_adres" id="field_adres" value="<cfoutput>#attributes.field_adres#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_adress_id")>
				<input type="hidden" name="field_adress_id" id="field_adress_id" value="<cfoutput>#attributes.field_adress_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.alias")>
				<input type="hidden" name="alias" id="alias" value="<cfoutput>#attributes.alias#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_long_adres")>
				<input type="hidden" name="field_long_adres" id="field_long_adres" value="<cfoutput>#attributes.field_long_adres#</cfoutput>">
			</cfif>			
			<cfif isdefined("attributes.field_name")>
				<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_id")>
				<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_city")>
				<input type="hidden" name="field_city" id="field_city" value="<cfoutput>#attributes.field_city#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_city_name")>
				<input type="hidden" name="field_city_name" id="field_city_name" value="<cfoutput>#attributes.field_city_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_county")>
				<input type="hidden" name="field_county" id="field_county" value="<cfoutput>#attributes.field_county#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_county_name")>
				<input type="hidden" name="field_county_name" id="field_county_name" value="<cfoutput>#attributes.field_county_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_country")>
				<input type="hidden" name="field_country" id="field_country" value="<cfoutput>#attributes.field_country#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_country_name")>
				<input type="hidden" name="field_country_name" id="field_country_name" value="<cfoutput>#attributes.field_country_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_postcode")>
				<input type="hidden" name="field_postcode" id="field_postcode" value="<cfoutput>#attributes.field_postcode#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_semt")>
				<input type="hidden" name="field_semt" id="field_semt" value="<cfoutput>#attributes.field_semt#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.field_member_id")>
				<input type="hidden" name="field_member_id" id="field_member_id" value="<cfoutput>#attributes.field_member_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.is_comp")>
				<input type="hidden" name="is_comp" id="is_comp" value="<cfoutput>#attributes.is_comp#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.select_list")>
				<input type="hidden" name="select_list" id="select_list" value="<cfoutput>#attributes.select_list#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.is_store_module")>
				<input type="hidden" name="is_store_module" id="is_store_module" value="<cfoutput>#attributes.is_store_module#</cfoutput>">
			</cfif>	
			<cfif isdefined("attributes.is_county_related_company")>
				<input type="hidden" name="is_county_related_company" id="is_county_related_company" value="1">
			</cfif>	
			<cfif isdefined("attributes.related_company")>
				<input type="hidden" name="related_company" id="related_company" value="<cfoutput>#attributes.related_company#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.related_company_id")>
				<input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#attributes.related_company_id#</cfoutput>">
			</cfif>	
			<cfif isdefined("attributes.company_branch_id")>
				<input type="hidden" name="company_branch_id" id="company_branch_id" value="<cfoutput>#attributes.company_branch_id#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.company_branch_name")>
				<input type="hidden" name="company_branch_name" id="company_branch_name" value="<cfoutput>#attributes.company_branch_name#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.coordinate_1")>
				<input type="hidden" name="coordinate_1" id="coordinate_1" value="<cfoutput>#attributes.coordinate_1#</cfoutput>">
			</cfif>
			<cfif isdefined("attributes.coordinate_2")>
				<input type="hidden" name="coordinate_2" id="coordinate_2" value="<cfoutput>#attributes.coordinate_2#</cfoutput>">
			</cfif>	
			<cfif isdefined("attributes.sales_zone")>
				<input type="hidden" name="sales_zone" id="sales_zone" value="<cfoutput>#attributes.sales_zone#</cfoutput>">
			</cfif>	
			<cfif isdefined("attributes.is_select")>
				<input type="hidden" name="is_select" id="is_select" value="<cfoutput>#attributes.is_select#</cfoutput>">
			</cfif>	
			<cf_box_search more="0">
				<div class="form-group" id="keyword">
					<cfif isdefined("attributes.is_compname_readonly") and #attributes.is_compname_readonly# eq 1>
						<cfinput name="keyword" id="keyword" type="text" placeholder="#getLang('','Filtre',57460)#" maxlength="50" readonly="readonly" value="#URLDecode(attributes.keyword)#">
					<cfelse>
						<cfinput name="keyword" id="keyword" type="text" placeholder="#getLang('','Filtre',57460)#" maxlength="50" value="#URLDecode(attributes.keyword)#">
					</cfif>
				</div> 
				<div class="form-group" id="categories">
					<select name="categories" id="categories" onChange="form_cagir(this.value);">
						<cfif listcontainsnocase(attributes.select_list,1)><option value="1" <cfif attributes.is_comp eq 1>selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option></cfif>
						<cfif listcontainsnocase(attributes.select_list,2)><option value="0" <cfif attributes.is_comp eq 0>selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option></cfif>
					</select>
				</div>
				<div class="form-group" id="member_name">
					<div class="input-group">  
						<cfif listcontainsnocase(attributes.select_list,1) and attributes.is_comp eq 1>
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<cfif isdefined("attributes.is_compname_readonly") and #attributes.is_compname_readonly# eq 1><!--- MCP tarafından #75351 iş için E Fatura Tanımlarında Şube Kontrolü için Eklendi --->
							<input type="text" name="member_name" id="member_name" placeholder= "<cfoutput>#getLang('','Cari Hesap',57519)#</cfoutput>" readonly="readonly" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1\'','COMPANY_ID,MEMBER_TYPE','company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
							<cfelse>
							<input type="text" name="member_name" id="member_name" placeholder= "<cfoutput>#getLang('','Cari Hesap',57519)#</cfoutput>"  onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1\'','COMPANY_ID,MEMBER_TYPE','company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
							<cfset str_linke_ait="&field_comp_id=search_comp.company_id&field_member_name=search_comp.member_name&field_type=search_comp.member_type">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7&keyword='+encodeURIComponent(document.search_comp.member_name.value));"></span>
							</cfif>
						<cfelseif listcontainsnocase(attributes.select_list,2) and attributes.is_comp eq 0>
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<input type="text" name="member_name" id="member_name" placeholder= "<cfoutput>#getLang('','Cari Hesap',57519)#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'2\'','CONSUMER_ID,MEMBER_TYPE','consumer_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
							<cfset str_linke_ait="&field_consumer=search_comp.consumer_id&field_member_name=search_comp.member_name&field_type=search_comp.member_type">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_cons<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=8&keyword='+encodeURIComponent(document.search_comp.member_name.value));"></span>
						</cfif>
					</div>
				</div>   
				<div class="form-group" id="tc_num">
					<cfinput name="tc_num" id="tc_num" type="text" placeholder= "#getLang('','TC Kimlik No',58025)#" onKeyUp="isNumber(this)" maxlength="11" value="#attributes.tc_num#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows"  value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_comp' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<cfif isDefined("attributes.field_member_id") and len(attributes.field_member_id)>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.no'></th>
						<th><cf_get_lang dictionary_id='57658.Üye'></th>
						<cfif session.ep.our_company_info.IS_EFATURA eq 1>
						<th><cf_get_lang dictionary_id='32646.Kodu'></th>
						<th><cf_get_lang dictionary_id='60078.Alias'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='58723.Adres'></th>
						<th><cf_get_lang dictionary_id='57499.Telefon'></th>
						<th>
							<cfoutput>
								<cfif attributes.is_comp eq 0>                                  
									<th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_adress&cid=#attributes.field_member_id#&is_comp=#attributes.is_comp#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<cfelse>
									<th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_branch&cpid=#attributes.field_member_id#&is_comp=#attributes.is_comp#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								</cfif>
							</cfoutput>
						</th>
					</tr>
				</thead>
				<tbody>
					<cfif get_member.recordcount>
						<cfoutput query="get_member">
							<cfset str_company_address ="#district_name##ADDRESS#">
							<cfset str_company_address = replace(str_company_address,"#Chr(13)##chr(10)#"," ","all")>
							<cfset str_company_address = replace(str_company_address,"'"," ","all")>
							<cfset related_company_id_ = "">
							<cfset related_company_ = "">
							<cfif isdefined("attributes.is_county_related_company") and len(county)>
								<cfquery name="get_related_" dbtype="query">
									SELECT * FROM get_related WHERE COUNTY_ID = #get_member.COUNTY_ID# 
								</cfquery>
								<cfif get_related_.recordcount>
									<cfset related_company_id_ = get_related_.COMPANY_ID>
									<cfset related_company_ = get_related_.NICKNAME>
								</cfif>
							</cfif>
							<cfif address_type eq ''>
								<cfset no=0>
							<cfelseif address_type eq 'Fatura Adresi'>
								<cfset no=1>
							<cfelseif address_type eq 'Ev Adresi'>
								<cfset no=2>
							<cfelseif address_type eq 'Is Adresi'>
								<cfset no=3>
							</cfif>
							<tr>
								<td>#member_code#</td>
								<td><a href="javascript://" onClick="add_company('#member_id#','#fullname#','#str_company_address#','#str_company_address# #postcode# #semt# <cfif len(county)>#county_name#</cfif> <cfif len(city)>#city_name#</cfif> <cfif len(country)>#country_name#</cfif>','#city#','<cfif len(city)>#city_name#</cfif>','#county#','<cfif len(county)>#county_name#</cfif>','#country#','<cfif len(country)>#country_name#</cfif>','#postcode#','#semt#','#related_company_id_#','#related_company_#','#branch_id#','#branch_name#','#compbranch_id#','#coordinate_1#','#coordinate_2#','#sz_id#','#alias#');" class="tableyazi">#fullname# - #address_type#</a></td>
								<cfif session.ep.our_company_info.IS_EFATURA eq 1 >
								<td>#code#</td>
								<td>#alias#</td>
								</cfif>
								<td>#district_name##address# - #semt# 
									<br/>- #postcode#  <cfif len(county)>-#county_name#</cfif>
									<cfif len(city)> - #city_name#</cfif>
									<cfif len(country)> - #country_name#</cfif>
								</td>
								<td>#telcode# #tel#</td>
								<td width="15">
									<cfif attributes.is_comp eq 0>                                  
										<cfif branch_id eq -1>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_address&consumer_id=#attributes.field_member_id#&no=#no#&is_comp=#attributes.is_comp#','small');"<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif branch_id neq -1>	
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_adress&contactid=#branch_id#&cid=#member_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									<cfelse>
										<cfif branch_id eq -1>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_address&consumer_id=#attributes.field_member_id#&no=#no#&is_comp=#attributes.is_comp#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>	
										<cfif branch_id neq -1>				  
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_branch&brid=#branch_id#&cpid=#member_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									</cfif>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>	
				</tbody>
			<cfelse>
				<thead>
					<tr> 
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57658.Üye'></th>
						<cfif session.ep.our_company_info.IS_EFATURA eq 1 >
						<th><cf_get_lang dictionary_id='32646.Kodu'></th>
						<th><cf_get_lang dictionary_id='60078.Alias'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='58723.Adres'></th>
						<th><cf_get_lang dictionary_id='57499.Telefon'></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_member.recordcount>
						<cfoutput query="get_member" >
							<cfset district_=''>
							<cfset str_company_address ="#district_name##ADDRESS#">
							<cfset str_company_address = replace(str_company_address,"#Chr(13)##chr(10)#"," ","all")>
							<cfset str_company_address = replace(str_company_address,"'"," ","all")>
							<cfif isdefined("attributes.is_county_related_company") and len(county)>
								<cfquery name="get_related_" dbtype="query">
									SELECT * FROM get_related WHERE COUNTY_ID = #get_member.COUNTY# 
								</cfquery>
								<cfif get_related_.recordcount>
									<cfset related_company_id_ = get_related_.COMPANY_ID>
									<cfset related_company_ = get_related_.NICKNAME>
								<cfelse>
									<cfset related_company_id_ = "">
									<cfset related_company_ = "">
								</cfif>
							<cfelse>
								<cfset related_company_id_ = "">
								<cfset related_company_ = "">
							</cfif>
							<tr>
								<td>#member_code#</td>
								<td><a href="javascript://" onClick="add_company('#member_id#','#fullname#','#str_company_address#','#str_company_address# #postcode# #semt# <cfif len(county)>#county_name#</cfif> <cfif len(city)>#city_name#</cfif> <cfif len(country)>#country_name#</cfif>','#city#','<cfif len(city)>#city_name#</cfif>','#county#','<cfif len(county)>#county_name#</cfif>','#country#','<cfif len(country)>#country_name#</cfif>','#postcode#','#semt#','#related_company_id_#','#related_company_#','#branch_id#','#branch_name#','#compbranch_id#','#coordinate_1#','#coordinate_2#','#sz_id#',<cfif len(city)>'#alias#'<cfelse>''</cfif>);" class="tableyazi">#fullname# - #address_type#</a></td>
								<cfif session.ep.our_company_info.IS_EFATURA eq 1 >
								<td>#code#</td>
								<td>#alias#</td>
								</cfif>
								<td>#district_name##address# - #semt# 
									<br/>- #postcode#  <cfif len(county)>-#county_name#</cfif>
									<cfif len(city)> - #city_name#</cfif>
									<cfif len(country)> - #country_name#</cfif>
								</td>
								<td>#telcode# #tel#</td>
								<td width="15">
									<cfif attributes.is_comp eq 0>                                  
										<cfif branch_id eq -1>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_adress&cid=#member_id#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
										</cfif>
										<cfif branch_id neq -1>	
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_adress&contactid=#branch_id#&cid=#member_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									<cfelse>
										<cfif branch_id eq -1>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_branch&cpid=#member_id#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
										</cfif>	
										<cfif branch_id neq -1>				  
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_branch&brid=#branch_id#&cpid=#member_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									</cfif>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
					</tbody>
			</cfif>
		</cf_grid_list>
		<cfif get_member.recordcount and (attributes.totalrecords gt attributes.maxrows)>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_list_member_address#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
function form_cagir(member_type)
{ 
	if (member_type == 1){
		document.getElementById('is_comp').value = 1;
		document.getElementById('consumer_id').value = '';
	}
	else{
		document.getElementById('is_comp').value = 0;
		document.getElementById('company_id').value = '';
	}
	<cfif isdefined("attributes.draggable")>loadPopupBox("search_comp",<cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>document.search_comp.submit();</cfif>
}
function add_company(id,name,adres,long_adres,city,city_name,county,county_name,country,country_name,postcode,semt,related_company_id,related_company,branch_id,branch_name,adress_id,coordinate_1,coordinate_2,sales_zone,alias)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_adress_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_adress_id#</cfoutput>.value = adress_id;
	</cfif>
	<cfif isdefined("attributes.alias")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#alias#</cfoutput>.value = alias;
	</cfif>
	<cfif isdefined("attributes.field_adres")>	
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_adres#</cfoutput>.value = adres;
	</cfif>
	<cfif isdefined("attributes.field_long_adres")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_long_adres#</cfoutput>.value = long_adres;
	</cfif>
	<cfif isdefined("attributes.field_country")>
		<cfif attributes.is_select eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_country,".")#</cfoutput>").select2().val(country).trigger('change');
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_country#</cfoutput>.value = country;
		</cfif>
	</cfif>
	<!--- <cfif isdefined("attributes.field_country_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_country_name#</cfoutput>.value = country_name;
	</cfif> --->
	<cfif isdefined("attributes.field_city")>
		<cfif attributes.is_select eq 2>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.$("#<cfoutput>#listLast(field_city,".")#</cfoutput>").select2().val(city).trigger('change');
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_city#</cfoutput>.value = city;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_city_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_city_name#</cfoutput>.value = city_name;
	</cfif>
	<cfif isdefined("attributes.field_county")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_county#</cfoutput>.value = county;
	</cfif>
	<cfif isdefined("attributes.field_county_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_county_name#</cfoutput>.value = county_name;
	</cfif>
	<cfif isdefined("attributes.field_postcode")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_postcode#</cfoutput>.value = postcode;
	</cfif>
	<cfif isdefined("attributes.field_semt")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_semt#</cfoutput>.value = semt;
	</cfif>
	<cfif isdefined("attributes.is_county_related_company")>	
		<cfif isdefined("attributes.related_company")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.related_company#</cfoutput>.value = related_company;
		</cfif>
		<cfif isdefined("attributes.related_company_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.related_company_id#</cfoutput>.value = related_company_id;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.company_branch_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.company_branch_id#</cfoutput>.value = branch_id;
	</cfif>
	<cfif isdefined("attributes.company_branch_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.company_branch_name#</cfoutput>.value = branch_name;
	</cfif>
	<cfif isdefined("attributes.coordinate_1")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.coordinate_1#</cfoutput>.value = coordinate_1;
	</cfif>
	<cfif isdefined("attributes.coordinate_2")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.coordinate_2#</cfoutput>.value = coordinate_2;
	</cfif>
	<cfif isdefined("attributes.sales_zone")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.sales_zone#</cfoutput>.value = sales_zone;
	</cfif>	
	<cfif isdefined("attributes.basket_cheque")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.reload_basket();
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>

