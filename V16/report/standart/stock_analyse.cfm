<cfquery name="get_cost_type" datasource="#dsn#">
	SELECT ISNULL(INVENTORY_CALC_TYPE,3) AS INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<!--- debug ı acık bırakmayın, acık bırakıldıgında csv dosya olusturuken sorun olusuyor --->
<cfif isdefined('attributes.ajax')><!--- Kümüle Raporlar için Dönem ve şirket farklı gönderilebilir! --->
	<cfif isdefined('attributes.new_sirket_data_source')>
		<cfset dsn3 = attributes.new_sirket_data_source>
	</cfif>
	<cfif isdefined('attributes.new_donem_data_source')>
		<cfset dsn2 = attributes.new_donem_data_source>
	</cfif>
</cfif>
<cfset product_cat_list = "50,79,412,55,159,46,546,456,667,52,547,607,545,48,164,44">
<!--- DONEM BASI VE DONEM SONU STOK PRODUCT_COST TABLOSUNDAKİ "PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST_SYSTEM" ALANLARINDAN HESAPLANIR
Raporda; 
	attributes.report_type 1 : Stok Bazında
	attributes.report_type 2 : Ürün Bazında
	attributes.report_type 3 : Kategori Bazında
	attributes.report_type 4 : Ürün Sorumlusu Bazında
	attributes.report_type 5 : Marka Bazında
	attributes.report_type 6 : Tedarikci Bazında
	attributes.report_type 7 : Belge Bazında
	DİKKAT: 
		-dönem bası ve dönem sonu stok hesaplamalarına, 3.parti kurum ve kişilere ait lokasyonlardaki stok hareketleri katılmaz. 
		-Rapor tipi olarak kategori, marka veya sorumlu bazında rapor tipi secildiginde; filtrede işaretlenen seçenekler gözardı edilerek sadece dönem sonu stok miktarı ve dönem sonu stok maliyeti goruntulenir.
		-Seçilen para birimine göre, Dönem Sonu ve Dönem Bası maliyeti hesaplanırken, başlangıç ve bitiş tarihlerine en yakın kurlar alınır. MONEY_HISTORY tablosunda bu tarihlerde ya da öncesine ait kur kaydı bulunamazsa maliyetler sistem para birimine göre hesaplanır.
		-stok yaşı donem sonu stok miktarına gore hareketlere donem sonundan gecmise dogru giderek yasları bulunuyor ve agirlikli ortalama yontemi ile hesaplaniyor. kategori,marka,tedarik bazında ise tum o bolum urunlerinin agirlikli ortalaması aliniyor
OZDEN 20061002 
Güncelleme:TolgaS 20070201 (stok yası ile ilgili duzenleme ve tedarikci bazında tipi eklendi) positive stock
 			OZDEN20070223 Belge Bazında Raporlama eklendi
			OZDEN20070321 (is_stock_action, is_belognto_institution, from_invoice_actions )
			TolgaS 20070507  
			OZDEN20070920 sistem 2. para birimine göre maliyet (is_system_money_2 ) eklendi. Aynı dönem içinde sistem 2.para biriminin değiştirilmesi ihtimali gözardı edildi.
DIKKAT: rapor listesine excel bölümü eklendi.. display liste yeni bir bölüm eklendiginde her iki tarafada yazılmalı
Net Fatura Satış Maliyeti = (Fatura Satış Miktarı-Fatura Satış İade Miktarı)* Donem Sonu Birim Maliyet--->
<cf_get_lang_set module_name="report">
<cf_xml_page_edit fuseact="report.stock_analyse">
<cfsetting requesttimeout="60000">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.sup_company" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.date" default="#createodbcdatetime('#session.ep.period_year#-#month(now())#-1')#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_id_new" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.cost_money" default="#session.ep.money#">
<cfparam name="attributes.process_type_detail" default="">
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.control_total_stock" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.volume_unit" default="1">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfif attributes.is_excel eq 0><!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
	<cfflush interval="1000">
</cfif>
<cfset tr_kapat_ = '</tr>'>
<cfif attributes.is_excel eq 1>
	<cfset function_td_type = 1><!--- excel --->
<cfelseif attributes.is_excel eq 2>
	<cfset function_td_type = 0><!--- csv --->
<cfelse>
	<cfset function_td_type = 2>
</cfif>
<cfif attributes.maxrows gt 1000><cfset attributes.maxrows = 250></cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.report_type eq 1>
	<cfset ALAN_ADI = 'STOCK_ID'>
<cfelseif listfind('2,3,4,5,6',attributes.report_type)>
	<cfset ALAN_ADI = 'PRODUCT_ID'>
<cfelseif listfind('9',attributes.report_type)>
	<cfset ALAN_ADI = 'STORE'>
<cfelseif listfind('10',attributes.report_type)>
	<cfset ALAN_ADI = 'STORE_LOCATION'>
<cfelseif attributes.report_type eq 8>
	<cfset ALAN_ADI = "STOCK_SPEC_ID">
<cfelseif attributes.report_type eq 12>
	<cfset ALAN_ADI = "STOCK_LOT_NO">
</cfif>
<cfset process_cat_list =''>
<cfif attributes.report_type neq 7>
    <cfloop list="#attributes.process_type_detail#" index="ind_process_type">
        <cfset attributes.process_type=listappend(attributes.process_type,listfirst(ind_process_type,'-'))>
        <cfif listlen(ind_process_type,'-') eq 3>
            <cfset process_cat_list = listappend(process_cat_list,listlast(ind_process_type,'-'))>
        </cfif>
    </cfloop>
<cfelse>
	<cfset process_cat_list =''>
</cfif>
<cfset islem_tipi = '78,81,82,83,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>
<cfquery name="GET_LOCATION" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_STATUS,
		SL.COMMENT,
		SL.LOCATION_ID,
		SL.STATUS
	FROM
		BRANCH B,
		DEPARTMENT D,
		STOCKS_LOCATION SL
	WHERE
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
        <cfif x_show_pasive_departments eq 0>
            D.DEPARTMENT_STATUS = 1 AND
            SL.STATUS = 1 AND
        </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID,
		SL.COMMENT
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_STATUS
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
         <cfif x_show_pasive_departments eq 0>
            D.DEPARTMENT_STATUS = 1 AND
        </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID
</cfquery>
<cfset branch_dep_list=valuelist(get_location.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfif listlen(branch_dep_list,',') eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1484.Departman ve Lokasyon Yetkilerinizi Kontrol Ediniz'>!");
	</script>
	<cfabort>
</cfif>
<cfquery name="Get_Category" datasource="#dsn3#">
	SELECT PRODUCT_CAT,PRODUCT_CATID,HIERARCHY,IS_SUB_PRODUCT_CAT FROM PRODUCT_CAT ORDER BY HIERARCHY,PRODUCT_CAT
</cfquery>
<cfif session.ep.isBranchAuthorization><cfset is_store=1><cfelse><cfset is_store=0></cfif><!--- şube modülü kontrolü --->
<cfset page_totals = arraynew(2)>
<cfset RECORDCOUNT.recct = 0>
<cfif attributes.report_type neq 11>
		<cfinclude template="../query/get_stock_analyse.cfm"> <!--- tum queryler ve sayfada listelenen degiskenler bu include da. --->
<cfelse>
	<cfinclude template="../query/get_stock_analyse_product_by_group.cfm">	
</cfif>
<cfset toplam_alis_miktar_2 = 0>
<cfset toplam_alis_iade_miktar_2 = 0>
<cfset toplam_net_alis_2 = 0>
<cfset toplam_satis_iade_miktar_2 = 0>
<cfset toplam_satis_miktar_2 = 0>
<cfset toplam_net_satis_miktar_2 = 0>
<cfset toplam_fatura_satis_miktar_2 = 0>
<cfset toplam_fatura_satis_iade_miktar_2 = 0>
<cfset toplam_uretim_miktar_2 = 0>
<cfset toplam_sarf_miktar_2 = 0>
<cfset toplam_uretim_sarf_miktar_2 = 0>
<cfset toplam_fire_miktar_2 = 0>
<cfset toplam_sayim_miktar_2 = 0>
<cfset toplam_demontaj_giris_miktar_2 = 0>
<cfset toplam_demontaj_giden_miktar_2 = 0>
<cfset toplam_ithal_mal_giris_miktari_2 = 0>
<cfset toplam_ithal_mal_cikis_miktari_2 = 0>
<cfset toplam_stok_virman_giris_miktari_2 = 0>
<cfset toplam_stok_virman_cikis_miktari_2 = 0>
<cfform name="rapor" action="#request.self#?fuseaction=#fusebox.Circuit#.stock_analyse" method="post">
	<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
	<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
	<cf_report_list_search title="#getLang('main',606)#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="product_code" id="product_code" value="<cfif len(attributes.product_cat) and len(attributes.product_code)><cfoutput>#attributes.product_code#</cfoutput></cfif>">
												<input type="text" name="product_cat" id="product_cat" style="width:135px;"  value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_code','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.product_code&field_name=rapor.product_cat&keyword='+encodeURIComponent(document.rapor.product_cat.value));"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no ='245.Ürün'></label>
										<div class="col col-12">
											<div class="input-group">    
												<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name) and len(attributes.product_id)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
												<input type="text" name="product_name" id="product_name" style="width:135px;" value="<cfoutput>#attributes.product_name#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&product_id=rapor.product_id&field_name=rapor.product_name&keyword='+encodeURIComponent(document.rapor.product_name.value),'list');"></span>	
											</div>		
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1736.Tedarikçi'></label>
										<div class="col col-12">
											<div class="input-group">
												<cfoutput>
													<input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif len(attributes.sup_company)>#attributes.sup_company_id#</cfif>">
													<input type="text" name="sup_company" id="sup_company" style="width:135px;" value="<cfif len(attributes.sup_company)>#attributes.sup_company#</cfif>" onfocus="AutoComplete_Create('sup_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','sup_company_id','','3','250');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_comp_name=rapor.sup_company&field_comp_id=rapor.sup_company_id&select_list=2&keyword='+encodeURIComponent(document.rapor.sup_company.value),'list');"></span>
												</cfoutput>	
											</div>		
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1036.Ürün Sorumlusu'></label>
										<div class="col col-12">
											<div class="input-group">
												<cfoutput>
													<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name) and len(attributes.product_employee_id)>#attributes.product_employee_id#</cfif>">
													<input type="text" name="employee_name" id="employee_name" style="width:135px;" value="<cfif len(attributes.employee_name)>#attributes.employee_name#</cfif>" maxlength="255" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','product_employee_id','','3','135');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.rapor.employee_name.value),'list');"></span>
												</cfoutput>	
											</div>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
										<div class="col col-12">
											<div class="input-group">
											    <cfoutput>	
													<input type="hidden" name="brand_id" id="brand_id"  value="<cfif len(attributes.brand_name)>#attributes.brand_id#</cfif>">
													<input type="text" name="brand_name" id="brand_name" style="width:135px;" value="<cfif len(attributes.brand_name)>#attributes.brand_name#</cfif>" maxlength="255" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','135');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_id=rapor.brand_id&brand_name=rapor.brand_name&keyword='+encodeURIComponent(document.rapor.brand_name.value),'small');"></span>
												</cfoutput>
											</div>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='1353.Ürün Grubu'></label>
										<div class="col col-12">
											<cf_get_lang_set module_name="product">
											<select name="product_types" style="width:135px;">
												<option value=""><cf_get_lang_main no='322.Seciniz'></option>
												<option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang no='159.Tedarik Edilmiyor'></option>
												<option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang no='50.Tedarik Ediliyor'></option>
												<option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang no='79.Hizmetler'></option>
												<option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang no='44.Envantere Dahil'></option>
												<option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang no='412.Mallar'></option>
												<option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang no='55.Terazi'></option>
												<option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang no='46.Üretiliyor'></option>
												<option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang no='545.Maliyet Takip Ediliyor'></option>
												<option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>>Kalite <cf_get_lang no="164.Takip Ediliyor"></option>
												<option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang no='546.Seri No Takip'></option>
												<option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang no='456.Karma Koli'></option>
												<option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang_main no='667.İnternet'></option>
												<option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang_main no='607.Extranet'></option>
												<option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang no='52.Özelleştirilebilir'></option>
												<option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang no='547.Sıfır Stok İle Çalış'></option>
												<option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang no='48.Satışta'></option>
											</select>
											<cf_get_lang_set module_name="report">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12" id="project_id_" <cfif attributes.report_type neq 7>style="display:none"</cfif>><cf_get_lang_main no='4.Proje'></label>
											<div class="col col-12" valign="top" id="project_id_2" <cfif attributes.report_type neq 7>style="display:none"</cfif>>
												<div class="input-group">
													<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
													<input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>  	
												</div>												
											</div>
									</div>
								</div>
							</div>
						    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
							    <div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1351.Depo'></label>
										<div class="col col-12" id="dept_id" <cfif attributes.report_type eq 9 or attributes.report_type eq 10>style="display:none;"</cfif>>
											<!--- departman veya lokasyon pasifse ilgili bolumun rengi değiştiriliyor --->
											<select name="department_id" id="department_id" multiple="multiple" style="height:117px">
												<cfoutput query="get_location" group="DEPARTMENT_ID">
													<option value="#department_id#" <cfif DEPARTMENT_STATUS neq 1>style="color:##FF0000"</cfif> <cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
													<cfoutput>
														<option <cfif get_location.status neq 1>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif listfind(attributes.department_id,'#department_id#-#location_id#',',')>selected</cfif>>&nbsp;&nbsp;#comment#</option>
													</cfoutput>
													</optgroup>					  
												</cfoutput>
											</select>
										</div>
										<div class="col col-12" id="dept_id2" <cfif attributes.report_type neq 9 and attributes.report_type neq 10>style="display:none;"</cfif>>
										<select name="department_id_new" multiple>
											<cfoutput query="get_department">
												<option value="#department_id#" <cfif listfind(attributes.department_id_new,department_id,',')>selected</cfif>>&nbsp;&nbsp;#department_head#</option>
											</cfoutput>
										</select>				
									</div>
								</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
										<cfoutput>
											<div class="col col-12" id="member_report_type1" <cfif attributes.report_type eq 7>style="display:none"</cfif>>
												<cfquery name="GET_ALL_PROCESS_TYPES" datasource="#dsn3#">
													SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (110,111,112,119) ORDER BY PROCESS_TYPE
												</cfquery>
												<select name="process_type_detail" multiple="multiple" style="height:117px">
													<option value="2" <cfif listfind(attributes.process_type_detail,2)>selected</cfif>><cf_get_lang no ='1032.Alış ve Alış İadeler'></option>
													<option value="3" <cfif listfind(attributes.process_type_detail,3)>selected</cfif>><cf_get_lang no='1033.Satış ve Satış İadeler'></option>
													<option value="4" <cfif listfind(attributes.process_type_detail,4)>selected</cfif>><cf_get_lang no='1034.Üretimden Giriş'></option>
														<cfquery name="get_process_cat" dbtype="query">
															SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE = 110
														</cfquery>
														<cfif get_process_cat.recordcount>
															<cfloop from="1" to="#get_process_cat.recordcount#" index="s">
																<option value="4-#get_process_cat.process_type[s]#-#get_process_cat.process_cat_id[s]#" <cfif listfind(attributes.process_type_detail,'4-#get_process_cat.process_type[s]#-#get_process_cat.process_cat_id[s]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat.process_cat[s]#</option>
															</cfloop>
														</cfif>
													<option value="5" <cfif listfind(attributes.process_type_detail,5)>selected</cfif>><cf_get_lang no='371.Sarf ve Fireler'></option>
														<cfquery name="get_process_cat_2" dbtype="query">
															SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE  IN (111,112)
														</cfquery>
														<cfif get_process_cat_2.recordcount>
															<cfloop from="1" to="#get_process_cat_2.recordcount#" index="tt">
																<option value="5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id	[tt]#" <cfif listfind(attributes.process_type_detail,'5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id[tt]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat_2.process_cat[tt]#</option>
															</cfloop>
														</cfif>
													<option value="6" <cfif listfind(attributes.process_type_detail,6)>selected</cfif>><cf_get_lang no ='1031.Dönem içi Giden Konsinye'></option>
													<option value="7" <cfif listfind(attributes.process_type_detail,7)>selected</cfif>><cf_get_lang no ='1035.Dönem İçi İade Gelen Konsinye'></option>
													<option value="19" <cfif listfind(attributes.process_type_detail,19)>selected</cfif>><cf_get_lang no ='1733.Dönem İçi Konsinye Giriş'></option>
													<option value="20" <cfif listfind(attributes.process_type_detail,20)>selected</cfif>><cf_get_lang no ='1734.Dönem İçi Konsinye Giriş İade'></option>
													<option value="8" <cfif listfind(attributes.process_type_detail,8)>selected</cfif>><cf_get_lang no ='1036.Teknik Servisten Giren'></option>
													<option value="9" <cfif listfind(attributes.process_type_detail,9)>selected</cfif>><cf_get_lang no ='1037.Teknik Servisten Çıkan'></option>
													<option value="10" <cfif listfind(attributes.process_type_detail,10)>selected</cfif>><cf_get_lang no ='1040.RMA Çıkış'></option>
													<option value="11" <cfif listfind(attributes.process_type_detail,11)>selected</cfif>><cf_get_lang no ='1041.RMA Giriş'> </option>
													<option value="12" <cfif listfind(attributes.process_type_detail,12)>selected</cfif>><cf_get_lang no ='1038.Sayım Sonuçları'></option>
													<option value="13" <cfif listfind(attributes.process_type_detail,13)>selected</cfif>><cf_get_lang no ='1039.Dönem İçi Demontaja Giden'></option>
													<option value="14" <cfif listfind(attributes.process_type_detail,14)>selected</cfif>><cf_get_lang_main  no = '1024.Dönem İçi Demontajdan Giriş'></option>
														<cfquery name="get_process_cat_3" dbtype="query">
															SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE = 119
														</cfquery>
														<cfif get_process_cat_3.recordcount>
															<cfloop from="1" to="#get_process_cat_3.recordcount#" index="yy">
																<option value="14-#get_process_cat_3.process_type[yy]#-#get_process_cat_3.process_cat_id[yy]#" <cfif listfind(attributes.process_type_detail,'14-#get_process_cat_3.process_type[yy]#-#get_process_cat_3.process_cat_id[yy]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat_3.process_cat[yy]#</option>
															</cfloop>
														</cfif>
													<option value="15" <cfif listfind(attributes.process_type_detail,15)>selected</cfif>><cf_get_lang no ='1042.Masraf Fişleri'></option>
													<option value="16" <cfif listfind(attributes.process_type_detail,16)>selected</cfif>><cf_get_lang no ='471.Depolararası Sevk İrsaliyesi'></option>
													<option value="17" <cfif listfind(attributes.process_type_detail,17)>selected</cfif>><cf_get_lang_main no='1791.İthal Mal Girişi'></option>
													<option value="18" <cfif listfind(attributes.process_type_detail,18)>selected</cfif>><cf_get_lang_main no='1833.Ambar Fişi'></option>
													<option value="21" <cfif listfind(attributes.process_type_detail,21)>selected</cfif>><cf_get_lang_main no='1412.Stok Virman'></option>
													<option value="22" <cfif listfind(attributes.process_type_detail,22)>selected</cfif>><cf_get_lang_main no='1838.Demirbaş Stok Fişi'></option>
												</select>
											</div>
										</cfoutput>	
										<div class="col col-12" id="member_report_type2" <cfif attributes.report_type neq 7>style="display:none"</cfif>>
											<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
												SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
											</cfquery>
											<select name="process_type_detail" style="width:175px; height:75px;" multiple>
												<cfoutput query="get_process_cat" group="process_type">
													<option value="0-#process_type#" <cfif listfind(attributes.process_type_detail,'0-#process_type#')> selected</cfif>>#get_process_name(process_type)#</option>										
												</cfoutput>
											</select>
										</div>				
									</div>
								</div>
							</div> 
						    <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='16.Stok Durum'></label>
										<div class="col col-12">
											<select name="control_total_stock">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<option value="0" <cfif attributes.control_total_stock eq 0>selected</cfif>><cf_get_lang no='1438.Sıfır Stok'></option>
												<option value="1" <cfif attributes.control_total_stock eq 1>selected</cfif>><cf_get_lang no ='1046.Pozitif Stok'></option>
												<option value="2" <cfif attributes.control_total_stock eq 2>selected</cfif>><cf_get_lang no ='1047.Negatif Stok'></option>
											</select>	     
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='344. Durum'></label>
										<div class="col col-12">
											<select name="product_status">
												<option value="" <cfif attributes.product_status eq ''>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
												<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
												<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
											</select>       
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
										<div class="col col-12">
											<cfoutput>
												<select name="report_type" onclick="control_report_type();">
													<option value="1" <cfif attributes.report_type eq 1> selected</cfif>><cf_get_lang no ='333.Stok Bazında'></option>
													<option value="2" <cfif attributes.report_type eq 2> selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
													<option value="3" <cfif attributes.report_type eq 3> selected</cfif>><cf_get_lang no ='331.Kategori Bazında'></option>
													<option value="4" <cfif attributes.report_type eq 4> selected</cfif>><cf_get_lang no ='373.Sorumlu Bazında'></option>
													<option value="5" <cfif attributes.report_type eq 5> selected</cfif>><cf_get_lang no ='374.Marka Bazında'></option>
													<option value="6" <cfif attributes.report_type eq 6> selected</cfif>><cf_get_lang no ='1043.Tedarikci Bazında'></option>
													<option value="7" <cfif attributes.report_type eq 7> selected</cfif>><cf_get_lang_main no='248.Belge Bazında'></option>
													<option value="8" <cfif attributes.report_type eq 8> selected</cfif>><cf_get_lang no ='1044.Spec Bazında'></option>
													<option value="12" <cfif attributes.report_type eq 12> selected</cfif>><cf_get_lang no='2085.Lot Bazında'></option> 
													<option value="9" <cfif attributes.report_type eq 9> selected</cfif>><cf_get_lang no="770.Depo Bazında"></option>
													<option value="10" <cfif attributes.report_type eq 10> selected</cfif>><cf_get_lang no="776.Lokasyon Bazında"></option>
													<option value="11" <cfif attributes.report_type eq 11> selected</cfif>><cf_get_lang no="1716.Ürün Grubu Bazında"></option> 
												</select>  
											</cfoutput>	     
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='624.Dosya Tipi'></label>
										<div class="col col-12">
											 <cfoutput>
												<select>
													<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
												</select>	
												<!---
												<select name="is_excel" style="width:175px;" >
													<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
													<option value="1" <cfif attributes.is_excel eq 1>selected</cfif>><cf_get_lang_main no='446.Excel Getir'></option>
													<option value="2" <cfif attributes.is_excel eq 2>selected</cfif>>CSV <cf_get_lang_main no='1188.Dosya Oluştur'></option>
												</select>--->
											</cfoutput>        
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'></label>
										<cfoutput>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz !'></cfsavecontent>
													<cfinput value="#attributes.date#" type="text" name="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
													<cfif not isdefined('attributes.ajax')>
														<span class="input-group-addon">
														<cf_wrk_date_image date_field="date"> 
														</span>		
													</cfif>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfinput value="#attributes.date2#"  type="text" name="date2" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
													<cfif not isdefined('attributes.ajax')>
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="date2">
														</span>	
													</cfif>
												</div>                                                 
											</div>
										</cfoutput>	
									</div>
									<div class="form-group">
										<cfoutput>
											<label><cf_get_lang no ='365.Maliyet Göster'>
												<cfif not session.ep.cost_display_valid>
												<input type="checkbox" name="display_cost" id="display_cost" onclick="control_cost_money()" value="1"<cfif isdefined('attributes.display_cost')>checked</cfif>>
												</cfif>
											</label>
											<label><cf_get_lang_main no ='383.İşlem Dövizli'>
												<cfquery name="get_money" datasource="#dsn#">
													SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
												</cfquery>
												<cfif get_cost_type.inventory_calc_type eq 3>
													<input type="checkbox" name="display_cost_money" id="display_cost_money" value="1"<cfif isdefined('attributes.display_cost_money')>checked</cfif>>
												</cfif>
											</label>
											<label>
												<cfif not session.ep.cost_display_valid><input type="checkbox" name="display_ds_prod_cost" id="display_ds_prod_cost" onclick="control_report_type();" value="1"<cfif isdefined('attributes.display_ds_prod_cost')>checked</cfif>>&nbsp;<cf_get_lang no ='1447.Dönem Sonu Birim Maliyet'>&nbsp;</cfif>
											</label>
											<label>
												<input type="checkbox" name="display_prod_volume" id="display_prod_volume" onclick="control_report_type();" value="1"<cfif isdefined('attributes.display_prod_volume')>checked</cfif>>&nbsp;<cf_get_lang_main no='2317.Hacim'>&nbsp;
											</label>		
										</cfoutput>	
									</div>
									<div class="form-group">
										<cfif get_cost_type.inventory_calc_type eq 3>
										<label>		
											<select name="cost_money" id="cost_money" onclick="control_cost_money(this.value)" >
												<cfloop query="get_money">
													<option value="<cfoutput>#MONEY#</cfoutput>" <cfif attributes.cost_money is MONEY>selected</cfif>><cfoutput>#MONEY#</cfoutput></option>
												</cfloop>
											</select>
										</label>
										</cfif>
										<label>	
										<select name="volume_unit" id="volume_unit" >
											<option value="1" <cfif attributes.volume_unit eq 1>selected</cfif>>cm3</option>
											<option value="2" <cfif attributes.volume_unit eq 2>selected</cfif>>dm3</option>
											<option value="3" <cfif attributes.volume_unit eq 3>selected</cfif>>m3</option>
										</select>
										</label>	
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div>&nbsp;</div>
									<div class="form-group">
										<cfoutput>
										    <label><cf_get_lang no ='66.Lokasyon Bazında Maliyet'>
												<cfif not session.ep.cost_display_valid and get_cost_type.inventory_calc_type eq 3>
													<input type="checkbox" name="location_based_cost" id="location_based_cost" value="1" <cfif isdefined('attributes.location_based_cost')>checked="checked"</cfif>>
													
												</cfif>
											</label>
											<label>
												<cfif not session.ep.cost_display_valid and get_cost_type.inventory_calc_type eq 3>
													<input type="checkbox" name="department_based_cost" id="department_based_cost" value="1" <cfif isdefined('attributes.department_based_cost')>checked="checked"</cfif>>
													<cf_get_lang_main no ='2753.Depo Bazında Maliyet'>
												</cfif>
											</label>
										</cfoutput>  									
									</div>
									<div class="form-group">
										<cfoutput>
										    <label>
												<input type="checkbox" name="is_envantory" id="is_envantory" value="1" <cfif isdefined('attributes.is_envantory')>checked</cfif>><cf_get_lang no ='720.Envantere Dahil'>&nbsp;
											</label>
											<cfif is_store eq 0><cfif listfind('1,2,8,12',attributes.report_type)>
												<label>
													<input type="checkbox" name="stock_age" id="stock_age" value="1" <cfif isdefined('attributes.stock_age')>checked</cfif>><cf_get_lang no ='426.Stok Yaşı'>
												</label>
												<label>				
													<input type="checkbox" name="stock_rate" id="stock_rate" value="1" <cfif isdefined('attributes.stock_rate')>checked</cfif>><cf_get_lang no ='1749.Stok Devir Hızı'>
													</cfif>
												</label>
										    </cfif>
										</cfoutput>  									
									</div>
									<div class="form-group">
										<label>
											<cfif len(session.ep.money2)><!---sistem 2.para birimi cinsinden maliyetleri getirir --->
												<input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" onclick="control_cost_money()" <cfif isdefined('attributes.is_system_money_2')>checked</cfif>><cf_get_lang no ='1444.Sistem 2 Para Br'>
											</cfif>
										</label>
										<label>
											<input type="checkbox" name="from_invoice_actions" id="from_invoice_actions" value="1" <cfif isdefined('attributes.from_invoice_actions')>checked</cfif>><cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'><cf_get_lang_main no='846.Maliyet'><cfelse><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'></cfif>
										</label> 									
									</div>
									<div class="form-group">
										<label>
											<!---secildiginde alış-satıs ve iade faturalarının tutarları gosterilir --->
											<input type="checkbox" name="is_stock_action" id="is_stock_action" value="1"<cfif isdefined('attributes.is_stock_action')>checked</cfif>><cf_get_lang no ='1445.Hareket Görmeyen Ürünleri Getirme'>
										</label>								
									</div>
									<div class="form-group">
										<label>
											<input type="checkbox" name="is_stock_fis_control" id="is_stock_fis_control" value="1"<cfif isdefined('attributes.is_stock_fis_control')>checked</cfif>><cf_get_lang no ='1744.Sadece İrsaliyelerden Oluşan Demirbaş Stok Fişleri Gelsin'> 
										</label>									
									</div>
									<div class="form-group">
										<label>
											<cfif is_store eq 0>
												<input type="checkbox" name="is_belognto_institution" id="is_belognto_institution" value="1"<cfif isdefined('attributes.is_belognto_institution')>checked</cfif>>&nbsp;3.<cf_get_lang no ='1446.Parti Kurumlara Ait Lokasyonlardaki Hareketleri Getir'> 
											</cfif>
										</label>	 									
									</div>	
								</div>			
							</div>					
						</div>
					</div>
					<div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cf_wrk_report_search_button search_function='degistir_action()' button_type='1' is_excel='1'>					
					    </div>	  
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<!--- Excel TableToExcel.convert fonksiyonu ile alındığı için kapatıldı. --->
<!---  <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>  --->

<cfif isdefined("attributes.is_form_submitted")>
    <cf_report_list id="search_list">
		 <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
			<cfset type_ = 2>
		<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
			<cfset type_ = 1>
		<cfelse>
			<cfset type_ = 0>
		</cfif> 
		<cfif attributes.report_type eq 7><cfinclude template="detail_stock_row_list.cfm"></cfif>
		<cfif attributes.report_type neq 7><cfif not listfind('1,2',attributes.is_excel)></cfif>
			<thead>
				<tr>
					<cfoutput>
						<cfif attributes.report_type eq 1><cfset report_type_colspan_= 8>
						<cfelseif attributes.report_type eq 2><cfset report_type_colspan_=7>
						<cfelseif attributes.report_type eq 8  or attributes.report_type eq 12><cfset report_type_colspan_=7>
						<cfelseif listfind("5,9",attributes.report_type) ><cfset report_type_colspan_=1>
						<cfelse><cfset report_type_colspan_=2></cfif>
						<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
							<cfset report_type_colspan_=report_type_colspan_+1>
						</cfif>
						<th align="center" colspan="#report_type_colspan_#">
							<cf_get_lang_main no='1548.Rapor Tipi'>
						</th>
						<cfif listfind('1,2,8,12',attributes.report_type)>
							<cfset db_colspan_no=1>
							<cfif isdefined('attributes.display_cost')>
								<cfset db_colspan_no = db_colspan_no+2>
								<cfif isdefined('attributes.is_system_money_2')>
									<cfset db_colspan_no = db_colspan_no+2>
								</cfif>
							</cfif>
							<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
								<cfset db_colspan_no=db_colspan_no+1>
							</cfif>
							<th align="center" colspan="#db_colspan_no#">
								<cf_get_lang_main no ='2099.Dönem Başı Stok'>
							</th>
							<th width="1"></th>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
								<cfif x_show_second_unit>
									<cfset purchase_colspan_no=6>
								<cfelse>
									<cfset purchase_colspan_no=3>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<cfset purchase_colspan_no = purchase_colspan_no+6>
									<cfif isdefined('attributes.is_system_money_2')>
										<cfset purchase_colspan_no = purchase_colspan_no+6>
									</cfif>
								</cfif>
								<th align="center" colspan="#purchase_colspan_no#">
									<cf_get_lang no ='381.Dönem İçi Alış'>
								</th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
								<cfif x_show_second_unit>
									<cfset colspan_number=6>
								<cfelse>
									<cfset colspan_number=3>
								</cfif>
								<cfif isdefined('attributes.from_invoice_actions')>
									<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
										<cfset colspan_number = colspan_number+11>
									<cfelse>
										<cfset colspan_number = colspan_number+7>
									</cfif>
									<cfif isdefined('attributes.is_system_money_2')> <!--- fatura tutarlarının 2.para birimi karsılıgı --->
										<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
											<cfset colspan_number = colspan_number+8>
										<cfelse>
											<cfset colspan_number = colspan_number+4>
										</cfif>
									</cfif>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<cfset colspan_number = colspan_number+8>
									<cfif isdefined('attributes.is_system_money_2')>
										<cfset colspan_number = colspan_number+6> <!--- maliyet tutarlarının 2.para birimi karsılıgı --->
									</cfif>
								</cfif>
								<th align="center" colspan="#colspan_number#">
									<cf_get_lang no ='382.Dönem İçi Satış'>
								</th>
								<th width="1"></th>
							</cfif>
							<cfset colspan_other=1>
							<cfif isdefined('attributes.display_cost')>
								<cfset colspan_other =colspan_other +2>
								<cfif isdefined('attributes.is_system_money_2')><cfset colspan_other =colspan_other +2></cfif>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1031.Dönem İçi Giden Konsinye'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1035.Dönem İçi İade Gelen Konsinye'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1733.Dönem İçi Konsinye Giriş'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1734.Dönem İçi Konsinye Giriş İade'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>	
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1036.Teknik Servisten Giren'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1037.Teknik Servisten Çıkan'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1041.RMA Giriş'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
								<th align="center" colspan="#colspan_other#"><cf_get_lang no ='1040.RMA Çıkış'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
								<cfif x_show_second_unit>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='383.Dönem İçi Üretim'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
								<cfif x_show_second_unit and attributes.process_type eq 5>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other*3#"><cf_get_lang no ='384.Dönem İçi Sarf ve Fire'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
								<cfif x_show_second_unit and attributes.process_type eq 12>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center"colspan="#colspan_other#"><cf_get_lang no ='385.Sayım'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
								<cfif x_show_second_unit and attributes.process_type eq 14>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang_main no='1024.Dönem İçi Demontajdan Giriş'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
								<cfif x_show_second_unit and attributes.process_type eq 13>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1039.Dönem İçi Demontaja Giden'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
								<th class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang_main no ='1409.Dönem İçi Masraf Fişleri'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
								<th class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1450.Dönem İçi Sevk İrsaliyeleri'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
								<cfif x_show_second_unit and attributes.process_type eq 17>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1451.Dönem İçi İthal Mal Girişi'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
								<th class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1452.Dönem İçi Ambar Fişleri'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
								<cfif x_show_second_unit and attributes.process_type eq 21>
									<cfset colspan_other = colspan_other + 1>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang_main no ='1412.Stok Virman'></th>
								<th width="1"></th>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
								<cfif x_show_second_unit>
									<cfset colspan_new = 1>
								<cfelse>
									<cfset colspan_new = 2>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<cfset colspan_new = colspan_new+8>
									<cfif isdefined('attributes.is_system_money_2')>
										<cfset colspan_new = colspan_new+4>
									</cfif>
								</cfif>
								<th class="form-title" align="center" colspan="#colspan_new#"><cf_get_lang_main no='1838.Demirbaş Stok Fişi'></th>
								<th width="1"></th>
							</cfif>
						</cfif>
						<cfset ds_colspan_number=1>
						<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8,12',attributes.report_type)><!--- stok,urun bazında birim ve dönem sonu toplam hacim --->
							<cfset ds_colspan_number=ds_colspan_number+2>
						</cfif>
						<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)><!---2.birim miktar gösterimi --->
							<cfset ds_colspan_number=ds_colspan_number+1>
						</cfif>			
						<cfif isdefined('attributes.display_cost')>
							<cfset ds_colspan_number=ds_colspan_number+2>
							<cfif isdefined('attributes.is_system_money_2')>
								<cfset ds_colspan_number =ds_colspan_number +2>
							</cfif>
							<cfif isdefined('attributes.display_ds_prod_cost')><!--- toplam maliyet haricinde birim maliyet gelecekse --->
								<cfset ds_colspan_number=ds_colspan_number+2>
								<cfif isdefined('attributes.is_system_money_2')>
									<cfset ds_colspan_number=ds_colspan_number+2>
								</cfif>
							</cfif>
						</cfif>
						<th align="center" colspan="#ds_colspan_number#"><cf_get_lang_main no='2100.Dönem Sonu Stok'></th>
						<cfif isdefined('attributes.stock_age')>
							<th width="1"></th>
							<th class="form-title" nowrap="nowrap" align="center"><cf_get_lang no ='426.Stok Yaşı'></th>
						</cfif>
						<cfif isdefined('attributes.stock_rate')>
							<th width="1"></th>
							<th class="form-title" nowrap="nowrap" align="center">Stok Devir Hızı</th>
						</cfif>
					</cfoutput>
				</tr>
				<tr>
				<cfoutput>
					<cfif listfind('1,8',attributes.report_type,',')>
						<th class="txtboldblue"><cf_get_lang_main no ='106.Stok Kodu'></th>
					</cfif>
					<cfif not listfind('3,4,5,6,7,9,10,11',attributes.report_type,',')>
						<th class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no='155.Ürün Kategorileri'></th>
					</cfif>
					<cfif listfind('1,2',attributes.report_type,',')>
						<th class="txtboldblue" width="110"><cf_get_lang_main no='377.Özel Kod'></th>
					</cfif>
					<th class="txtboldblue" width="130" nowrap="nowrap">
						<cfif attributes.report_type eq 1><cf_get_lang_main no='40.Stok'>
						<cfelseif attributes.report_type eq 2><cf_get_lang_main no='245.Ürün'> 
						<cfelseif attributes.report_type eq 3><cf_get_lang_main no='74.Kategori'>
						<cfelseif attributes.report_type eq 4><cf_get_lang_main no='132.Sorumlu'>
						<cfelseif attributes.report_type eq 5><cf_get_lang_main no='1435.Marka'>
						<cfelseif attributes.report_type eq 6><cf_get_lang_main no='1948.Tedarik'>
						<cfelseif attributes.report_type eq 8><cf_get_lang_main no='40.Stok'>
						<cfelseif attributes.report_type eq 9><cf_get_lang_main no='1351.Depo'>
						<cfelseif attributes.report_type eq 10><cf_get_lang_main no ='2234.Lokasyon'>
						<cfelseif attributes.report_type eq 12><cf_get_lang no='1353.Ürün Grubu'>
						</cfif>
					</th>
					<cfif listfind('1,2,8,12',attributes.report_type)>
						<th class="txtboldblue"><cf_get_lang_main no='221.Barkod'></th>
					</cfif>
					<cfif attributes.report_type eq 8>
						<th class="txtboldblue"><cf_get_lang no ='1952.Main Spec'></th>
					</cfif>
					<cfif attributes.report_type eq 12>
						<th class="txtboldblue"><cf_get_lang no ='148.Lot'></th>
					</cfif>
					<cfif listfind('1,2,8,12',attributes.report_type)>
						<th class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no='1388.Ürün Kodu'></th>
						<th class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no ='222.Üretici Kodu'></th>
						<th class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no ='224.Birim'></th>
						<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
							<th class="txtboldblue" nowrap="nowrap">2. <cf_get_lang_main no ='224.Birim'></th>
						</cfif>
						<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='391.Stok Miktarı'></th>
						<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
							<th class="txtboldblue" nowrap="nowrap" align="right">2.<cf_get_lang_main no ='224.Birim'> <cf_get_lang no ='391.Stok Miktarı'></th>
						</cfif>
						<cfif isdefined('attributes.display_cost')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='1494.Stok Maliyeti'></th>
							<cfif isdefined('attributes.is_system_money_2')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></th>
							</cfif>
						</cfif>
						<th class="txtboldblue" width="1"></th>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='393.Alım Miktarı'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='393.Alım Miktarı'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='394.Alım İade Miktarı'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='394.Alım İade Miktarı'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='395.Net Alım Miktarı'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='395.Net Alım Miktarı'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='396.Alım Tutar'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='397.Alım İade Tutarı'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='398.Net Alım Tutarı'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='396.Alım Tutar'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='397.Alım İade Tutarı'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='398.Net Alım Tutarı'></th>
								</cfif>
							</cfif>
						<th class="txtboldblue" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='2162.Satış Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='2162.Satış Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='409.Satış Maliyeti'></th>
							</cfif>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='403.Satış İade Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='403.Satış İade Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='411.Satış İade Maliyeti'></th>
							</cfif>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='406.Net Satış Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='406.Net Satış Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='414.Net Satış Maliyeti'></th>
							</cfif>
							<cfif isdefined('attributes.from_invoice_actions')><!--- faturadan hesapla secilmisse --->
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1457.Fatura Satış Miktar'></th>
								<cfif x_show_second_unit>
									<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1457.Fatura Satış Miktar'> 2</th>
								</cfif>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1458.Fatura Satış Tutar'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1458.Fatura Satış Tutar'></th>
								</cfif>
								<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1953.Fatura Satış Maliyet'></th>
									<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1953.Fatura Satış Maliyet'></th>
									</cfif>
								</cfif>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1459.Fatura Satış İade Miktar'></th>
								<cfif x_show_second_unit>
									<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1459.Fatura Satış İade Miktar'> 2</th>
								</cfif>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1460.Fatura Satış İade Tutar'></th>
								<cfif isdefined('attributes.is_system_money_2')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1460.Fatura Satış İade Tutar'></th>
								</cfif>
								<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1954.Fatura Satış İade Maliyet'></th>
									<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1954.Fatura Satış İade Maliyet'></th>
									</cfif>
								</cfif>
								<cfif type_ eq 1>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1955.Net Fatura'><cf_get_lang no ='409.Satış Maliyeti'></th>						
								<cfelse>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1955.Net Fatura'><br/><cf_get_lang no ='409.Satış Maliyeti'></th>						
								</cfif>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='409.Satış Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='411.Satış İade Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='414.Net Satış Maliyeti'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1461.Konsinye Çıkış Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1462.Konsinye Çıkış Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1462.Konsinye Çıkış Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- iade gelen konsinye --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1463.Konsinye İade Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1464.Konsinye İade Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1464.Konsinye İade Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- konsinye giriş iade--->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1738.Konsinye Giriş Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1737.Konsinye Giriş Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1737.Konsinye Giriş Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- konsinye giriş iade--->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1736.Konsinye Giriş İade Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1735.Konsinye Giriş İade Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1735.Konsinye Giriş İade Maliyet'></th>
								</cfif>
							</cfif>
							<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>				
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!---donemici uretim fişleri --->


						<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='416.Üretim Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='416.Üretim Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='417.Üretim Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='417.Üretim Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='419.Sarf Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='419.Sarf Miktar'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1465.Üretim Sarf Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1465.Üretim Sarf Miktar'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='420.Fire Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='420.Fire Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='421.Sarf Maliyet'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1466.Üretim Sarf Maliyet'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='422.Fire Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='421.Sarf Maliyet'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1466.Üretim Sarf Maliyet'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='422.Fire Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
							<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang_main no ='223.Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1467.Sayım Maliyet'></th>
								</cfif>
							</cfif>
							<th class="color-header" width="1"></th>
						</cfif>
						<!--- demontajdan giris --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1468.Demontajdan Giriş '>#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- demontaja giden --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1469.Demontaja Giden'> #session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- masraf fişleri --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1042.Masraf Fişleri'> #session.ep.money2# <cf_get_lang_main no='846.Maliyet'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- depo sevk--->
						<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></th>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- ithal mal girişi--->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- ambar fişi --->
						<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></th>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								</cfif>
							</cfif>
						<th class="color-header" width="1"></th>
						</cfif>
						<!--- stok virman --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'> 2</th>
							</cfif>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></th>
							<cfif x_show_second_unit>
								<th class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'> 2</th>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1472.Stok Giriş Maliyeti'></th>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></th>
								</cfif>
							</cfif>
							<th class="color-header" width="1"></th>
						</cfif>
						<!--- demirbaş stok fişi --->
						<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='1838.Demirbaş Stok Fişi'> <cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1750.Demirbaş Stok Fişi Kayıtlı Maliyet'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1753.Demirbaş Stok Fişi Fiyat'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1750.Demirbaş Stok Fişi Kayıtlı Maliyet'>t</th>
								</cfif>
							</cfif>
							<th class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='1840.Demirbaş Stok İade Fişi'> <cf_get_lang_main no ='223.Miktar'></th>
							<cfif isdefined('attributes.display_cost')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no ='1840.Demirbaş Stok İade Fişi'> <cf_get_lang no ='1755.Kayıtlı Maliyet'></th>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no ='1840.Demirbaş Stok İade Fişi'> <cf_get_lang_main no ='672.Fiyat'></th>
								<cfif isdefined('attributes.is_system_money_2')>
									<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no ='1840.Demirbaş Stok İade Fişi'> <cf_get_lang no ='1755.Kayıtlı Maliyet'></th>
								</cfif>
							</cfif>
							<th class="color-header" width="1"></th>
						</cfif>
					</cfif>
					<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='391.Stok Miktar'></th>
					<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
						<th class="txtboldblue" nowrap="nowrap" align="right">2.<cf_get_lang_main no ='224.Birim'> <cf_get_lang no ='391.Stok Miktar'></th>
					</cfif>
					<cfif isdefined('attributes.display_cost')>
						<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='1494.Stok Maliyet'></th>
						<cfif isdefined('attributes.is_system_money_2')>
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></th>
						</cfif>
						<cfif isdefined('attributes.display_ds_prod_cost')><!--- donem sonu stokta urun birim maliyetinin gosterilmesi secilmiş ise --->
							<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1483.Birim Maliyet'></th>
							<cfif isdefined('attributes.is_system_money_2')>
								<th class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1483.Birim Maliyet'> (#session.ep.money2#)</th>
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8,12',attributes.report_type)>
						<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1956.Birim Hacim'></th>
						<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1957.Toplam Hacim'></th>
					</cfif>
					<cfif isdefined('attributes.stock_age')>
						<th class="color-header" width="1"></th>
						<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='426.Stok Yaşı'></th>
					</cfif>
					<cfif isdefined('attributes.stock_rate')>
						<th class="color-header" width="1"></th>
						<th class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1749.Stok Devir Hızı'></th>
					</cfif>
				</cfoutput>
				</tr>
			</thead>
				<cfscript>
					for(elemet_i=1;elemet_i lte 123; elemet_i=elemet_i+1) //102-103
						page_totals[1][#elemet_i#] = 0;
				</cfscript>
				<tbody>
				<cfif GET_ALL_STOCK.recordcount>
					<cfif listfind('3,4,5,6,9,10',attributes.report_type)>
						<cfif type_ eq 1>
							<cfset attributes.maxrows = attributes.totalrecords>
						</cfif>
						<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="20">
							<td nowrap="nowrap">
							<cfif attributes.report_type eq 6 and not listfind('1,2',attributes.is_excel)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#product_groupby_id#','medium');">#ACIKLAMA#</a>
							<cfelseif attributes.report_type eq 4 and not listfind('1,2',attributes.is_excel)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#product_groupby_id#','medium');">#ACIKLAMA#</a> 
							<cfelse>#replace(ACIKLAMA,";","","all")#</cfif>
							</td>
							<td align="right" format="numeric">
								<cfif isdefined("TOTAL_STOCK") and len(TOTAL_STOCK)>
									<cfset page_totals[1][1] = page_totals[1][1] + wrk_round(TOTAL_STOCK,4)><!--- donem sonu stok --->
									#TLFormat(TOTAL_STOCK,4)#
								</cfif>
							</td>
							<cfif isdefined('attributes.display_cost')>
								<td width="100" align="right" nowrap="nowrap" format="numeric">
									<cfif isdefined('GET_ALL_STOCK.MALIYET') and GET_ALL_STOCK.MALIYET neq 0>
										<cfset page_totals[1][2] = page_totals[1][2] + (GET_ALL_STOCK.MALIYET/donem_sonu_kur)><!--- donem sonu maliyet --->
										#TLFormat(GET_ALL_STOCK.MALIYET/donem_sonu_kur)# 
									</cfif>
								</td>
								<td width="15" nowrap="nowrap">
									<cfif isdefined('GET_ALL_STOCK.MALIYET') and GET_ALL_STOCK.MALIYET neq 0>#attributes.cost_money#</cfif>
								</td>
								<cfif isdefined('attributes.is_system_money_2')>
								<td width="120" align="right" nowrap="nowrap" format="numeric">
									<cfif isdefined('MALIYET2') and MALIYET2 neq 0>
										<cfset page_totals[1][63] = page_totals[1][63] + MALIYET2><!--- donem sonu maliyet2 --->
										#TLFormat(MALIYET2)# 
									</cfif>
								</td>
								<td width="15" nowrap="nowrap">
									<cfif isdefined('MALIYET2') and MALIYET2 neq 0>#session.ep.money2#</cfif>
								</td>
								</cfif>
							</cfif>
							<cfif isdefined('attributes.stock_age')>
								<cfquery name="get_product_in_cat" dbtype="query">
									SELECT PRODUCT_ID FROM GET_ALL_STOCK WHERE PRODUCT_GROUPBY_ID =#GET_PROD_CATS.PRODUCT_GROUPBY_ID#
								</cfquery>
								<cfset genel_agirlikli_toplam=0>
								<cfset toplam_donem_sonu_stok=0>
								<cfloop query="get_product_in_cat">
									<cfif isdefined('donem_sonu_#get_product_in_cat.PRODUCT_ID#')>
										<cfquery name="get_product_detail" dbtype="query">
											SELECT 
												AMOUNT AS PURCHASE_AMOUNT,
												GUN_FARKI
											FROM 
												GET_STOCK_AGE 
											WHERE 
												PRODUCT_ID=#get_product_in_cat.PRODUCT_ID#
											ORDER BY ISLEM_TARIHI DESC
										</cfquery>
										<cfset donem_sonu_stok=evaluate('donem_sonu_#get_product_in_cat.PRODUCT_ID#')>
										<cfset toplam_donem_sonu_stok=toplam_donem_sonu_stok+donem_sonu_stok>
										<cfset agirlikli_toplam=0>
										<cfset kalan=donem_sonu_stok>
										<cfloop query="get_product_detail">
											<cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
												<cfset kalan = kalan - PURCHASE_AMOUNT>
												<cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
											<cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
												<cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
												<cfset kalan = 0>
												<!--- <cfbreak> --->
											</cfif>
										</cfloop>
									</cfif>							
								</cfloop>
								<td class="color-header" width="1"></td>
								<td align="right" nowrap="nowrap" format="numeric">
									<cfif toplam_donem_sonu_stok gt 0>#TLFormat(agirlikli_toplam/toplam_donem_sonu_stok)#</cfif>
								</td>
							</cfif>
							<cfif isdefined('attributes.stock_rate')>
								<td class="color-header" width="1"></td>
								<td align="right" nowrap="nowrap" format="numeric">
									<cfset envanter = (donem_basi_stok + donem_sonu_stok) / 2>
									<cfif envanter gt 0>#TLFormat(satis_mal_1/envanter)#</cfif>
								</td>
							</cfif>
						</tr>
						</cfoutput>
					<cfelseif attributes.report_type eq 11>
						<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td nowrap="nowrap">
								<cfset deger_ = listGetAt(product_cat_list,PRODUCT_TYPE,',')>
								<cfif deger_ eq 667>İnternet
								<cfelseif deger_ eq 607>Extranet
								<cfelseif deger_ eq 164>Kalite 
								<cfelse>
									#getLang('product',deger_)#
									<cf_get_lang_set module_name="report">
								</cfif>
							</td>
							<td align="right" format="numeric">
								<cfset page_totals[1][1] = page_totals[1][1] + MIKTAR><!--- donem sonu stok --->
								#TLFormat(MIKTAR,4)#
							</td>
							<cfif isdefined('attributes.display_cost')>
								<td width="100" align="right" nowrap="nowrap" format="numeric">
									<cfset page_totals[1][2] = page_totals[1][2] + (ALL_FINISH_COST/donem_sonu_kur)><!--- donem sonu maliyet --->
									#TLFormat(ALL_FINISH_COST/donem_sonu_kur)# 
								</td>
								<td width="15" nowrap="nowrap">
									<cfif ALL_FINISH_COST neq 0>#attributes.cost_money#</cfif>
								</td>
								<cfif isdefined('attributes.is_system_money_2')>
								<td width="120" align="right" nowrap="nowrap" format="numeric">
									<cfset page_totals[1][63] = page_totals[1][63] + ALL_FINISH_COST_2><!--- donem sonu maliyet2 --->
									#TLFormat(ALL_FINISH_COST_2)# 
								</td>
								<td width="15" nowrap="nowrap">
									<cfif ALL_FINISH_COST_2 neq 0>#session.ep.money2#</cfif>
								</td>
								</cfif>
							</cfif>
						</tr>
						</cfoutput>
					<cfelse>
						<cfif isdefined('attributes.ajax')>
							<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfscript>
									donem_sonu_stok=0;
									donem_basi_stok=0;
									donem_basi_maliyet=0;
									donem_sonu_maliyet=0;
									db_maliyet_temp = 0;
									db_maliyet2_temp = 0;
								</cfscript><cfabort>
								<cfinclude template="../../settings/cumulative/cumulative_stock_analyse_inc.cfm">
							</cfoutput>
							<cfif GET_ALL_STOCK.recordcount gte (attributes.startrow+attributes.maxrows)>
								<script type="text/javascript">
									<cfif isdefined('attributes.department_id') and len(attributes.department_id)><!--- lokasyonlara göre rapor çalıştırılıyorsa. --->
										<cfset function_code = '_#ListGetAt(attributes.department_id,1,'-')#_#ListGetAt(attributes.department_id,2,'-')#'>
										<cfoutput>user_info_show_div#function_code#(#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/GET_ALL_STOCK.recordcount)#</cfoutput>);
									<cfelse>
										//alert('<cfoutput>#attributes.maxrows#</cfoutput>');
										user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/GET_ALL_STOCK.recordcount)#</cfoutput>);
									</cfif>
								</script>
							<cfelse>
								<script type="text/javascript">
									<cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
									<cfset function_code = '_#ListGetAt(attributes.department_id,1,'-')#_#ListGetAt(attributes.department_id,2,'-')#'>
										<cfoutput>user_info_show_div#function_code#(1,1,1);</cfoutput>
									<cfelse>
										user_info_show_div(1,1,1);
									</cfif>
								</script>
								<cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
									UPDATE 
										REPORT_SYSTEM 
									SET 
										PROCESS_FINISH_DATE = #NOW()#,PROCESS_ROW_COUNT = #GET_ALL_STOCK.RECORDCOUNT#
									WHERE 
										REPORT_TABLE = 'STOCK_MONTH' AND 
										PERIOD_YEAR = #attributes.period_year# AND 
										PERIOD_MONTH = #attributes.period_month# AND 
										OUR_COMPANY_ID = #attributes.period_our_company_id#
								</cfquery>
							</cfif>
							<cfabort>
						<cfelse>
							<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
								<cfset attributes.startrow=1>
								<cfset attributes.maxrows=GET_ALL_STOCK.recordcount>
						</cfif>
							<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfif isdefined("attributes.display_cost_money")>
									<cfset donem_basi_kur_ = 1>
									<cfset donem_sonu_kur_ = 1>
								<cfelse>
									<cfset donem_basi_kur_ = donem_basi_kur>
									<cfset donem_sonu_kur_ = donem_sonu_kur>
								</cfif>
								<cfscript>
									donem_sonu_stok=0;
									donem_basi_stok=0;
									donem_basi_maliyet=0;
									donem_sonu_maliyet=0;
									db_maliyet_temp = 0;
									db_maliyet2_temp = 0;
									ds_urun_birim_maliyet=0;
									ds_urun_birim_maliyet2=0;
									ds_toplam_maliyet=0;
									ds_toplam_maliyet2=0;
									fatura_net_satis_miktar=0;
									//fatura_net_satis_miktar2=0;
									if(isdefined('attributes.display_cost'))//donem sonu birim maliyet
									{
										//db_maliyet = produc_cost_func(cost_product_id:GET_ALL_STOCK.PRODUCT_ID,cost_date:finish_date);
										ds_urun_birim_maliyet=(GET_ALL_STOCK.ALL_FINISH_COST);
										if( isdefined('attributes.is_system_money_2') )
											ds_urun_birim_maliyet2=(GET_ALL_STOCK.ALL_FINISH_COST_2);
									}
								</cfscript>
								<tr>
									<cfif listfind('1,8',attributes.report_type,',')>
										<td style="width:100px;">
											#replace(GET_ALL_STOCK.STOCK_CODE,";","","all")#&nbsp;
										</td>
									</cfif>
									<cfif not listfind('3,4,5,6,7,9,10,11',attributes.report_type,',')>
										<td style="width:100px;">#Product_Cat#</td>
									</cfif>
									<cfif listfind('1',attributes.report_type,',')>
										<td style="width:100px;">
											#stock_code_2#&nbsp; 
										</td>
									</cfif>
									<cfif listfind('2',attributes.report_type,',')>
										<td style="width:100px;">
											#product_code_2# 
										</td>
									</cfif>                            
									<td width="130" nowrap="nowrap">
									<cfif listfind('1,8',attributes.report_type,',') and not listfind('1,2',attributes.is_excel)>
										<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#"  target="_blank">#GET_ALL_STOCK.ACIKLAMA#</a>
									<cfelseif attributes.report_type eq 2 and not listfind('1,2',attributes.is_excel)>
										<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#"  target="_blank">#GET_ALL_STOCK.ACIKLAMA#</a>
									<cfelse>
									#replace(GET_ALL_STOCK.ACIKLAMA,";","","all")#
									</cfif>
									</td>
									<cfif listfind('1,2,8,12',attributes.report_type)>					
										<td>
											#replace(GET_ALL_STOCK.BARCOD,";","","all")#  
										</td>
									</cfif>
									<cfif attributes.report_type eq 8>
										<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
											<td>
												#GET_ALL_STOCK.SPECT_VAR_ID#  
												<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
												- #GET_ALL_STOCK.SPECT_NAME# 
												</cfif>
											</td>
										<cfelse>
											<td align="right">
												#GET_ALL_STOCK.SPECT_VAR_ID#
											</td>
										</cfif>
									</cfif>
									<cfif attributes.report_type eq 12>
										<td align="right" nowrap="nowrap">
										#GET_ALL_STOCK.LOT_NO#
										</td>
									</cfif>
									<cfif listfind('1,2,8,12',attributes.report_type)>					
										<td>
											#replace(GET_ALL_STOCK.PRODUCT_CODE,";","","all")# 
										</td>
									</cfif>
									<td width="130" nowrap="nowrap">
										#replace(GET_ALL_STOCK.MANUFACT_CODE,";","","all")# 
									</td>
									<td width="100" nowrap="nowrap">
										#replace(GET_ALL_STOCK.MAIN_UNIT,";","","all")# 
									</td>
									<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
										<td width="100" nowrap="nowrap">
											#replace(get_all_stock.UNIT2,";","","all")#
										</td>
									</cfif>
									<td align="right" nowrap="nowrap" format="numeric">
										<cfif isdefined("attributes.report_type") and attributes.report_type eq 8>
											<cfif isdefined("get_all_stock.DB_STOK_MIKTAR") and len(DB_STOK_MIKTAR)>
												<cfset page_totals[1][3] = page_totals[1][3] + wrk_round(DB_STOK_MIKTAR,4)><!--- donem bası stok --->
												<cfset donem_basi_stok = DB_STOK_MIKTAR>
												#TLFormat(DB_STOK_MIKTAR,4)#
											<cfelse>
												#TLFormat(0,4)#
											</cfif>
										<cfelse>
											<cfif isdefined("acilis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][3] = page_totals[1][3] + wrk_round(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#"),4)><!--- donem bası stok --->
												<cfset donem_basi_stok = evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											<cfelse>
												#TLFormat(0,4)#
											</cfif>
										</cfif>
								</td>
								<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
										<td align="right" nowrap="nowrap" format="numeric">
											<cfif isdefined("acilis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#")) and len(get_all_stock.multiplier)>
												<cfset 'amount_new_#get_all_stock.PRODUCT_GROUPBY_ID#' = evaluate("acilis_miktar_#PRODUCT_GROUPBY_ID#")/wrk_round(get_all_stock.multiplier,8,1)>
												<cfset page_totals[1][122] = page_totals[1][122] + wrk_round(evaluate("amount_new_#PRODUCT_GROUPBY_ID#"),4)><!--- 2.birim miktar stok --->
												#TLFormat(evaluate('amount_new_#get_all_stock.PRODUCT_GROUPBY_ID#'),4)#
											</cfif>
										</td>
								</cfif>
									<cfif isdefined('attributes.display_cost')>
										<cfif donem_basi_stok neq 0>
											<cfif donem_basi_stok neq 0>
												<cfset start_period_cost_date = dateformat(start_date,dateformat_style)>
												<cfset start_period_cost_date=date_add('d',-1,start_date)>
												<!--- <cfset db_maliyet2 = produc_cost_func(cost_product_id:GET_ALL_STOCK.PRODUCT_ID,cost_date:start_period_cost_date)> --->
												<cfif len(ALL_START_COST)>
													<cfset donem_basi_maliyet=(donem_basi_stok*GET_ALL_STOCK.ALL_START_COST)>
												<cfelse>
													<cfset donem_basi_maliyet = 0>
												</cfif>
												<cfif donem_basi_maliyet neq 0>
													<cfset page_totals[1][4] = page_totals[1][4] + (donem_basi_maliyet/donem_basi_kur_)><!--- donem bası maliyet --->
													<cfset db_maliyet_temp= TLFormat(donem_basi_maliyet/donem_basi_kur_)>
												</cfif>
												<cfif isdefined('attributes.is_system_money_2')>
													<cfif len(GET_ALL_STOCK.ALL_START_COST_2)>
														<cfset donem_basi_other_cost=(donem_basi_stok*GET_ALL_STOCK.ALL_START_COST_2)>
													<cfelse>
														<cfset donem_basi_other_cost = 0>
													</cfif>
													<cfif donem_basi_other_cost neq 0>
														<cfset page_totals[1][64] = page_totals[1][64] + donem_basi_other_cost><!--- donem bası maliyet 2--->
														<cfset db_maliyet2_temp= TLFormat(donem_basi_other_cost)>
													</cfif>
												</cfif>
											</cfif>
										</cfif>
										<!---Sonunda senide buldum.--->
										<td align="right" nowrap="nowrap" format="numeric">#db_maliyet_temp#</td>
										<td>
										<cfif isdefined("attributes.display_cost_money")>
											#all_start_money#
										<cfelse>
											#attributes.cost_money#	
										</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td align="right" nowrap format="numeric">#db_maliyet2_temp#</td>
											<td nowrap="nowrap" width="15">#session.ep.money2#</td>
										</cfif>
									</cfif>
									<td class="color-header" width="1"></td>
									<!--- alıs ve alıs iadeler bolumu --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
										<cfset net_alis=0>
										<cfset net_alis2=0>
										<td align="right" format="numeric">
											<cfif isdefined("alis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset net_alis=(net_alis+wrk_round(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"),4))>
												<cfset page_totals[1][5] = page_totals[1][5] + wrk_round(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!--- alıs miktar --->
												#TLFormat(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("alis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
													<cfset alis_miktar_2 = evaluate("alis_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!--- alıs miktar2 --->
													<cfset toplam_alis_miktar_2 = toplam_alis_miktar_2 + alis_miktar_2>
													#Tlformat(alis_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("alis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset net_alis= (net_alis - wrk_round(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4))>
												<cfset page_totals[1][6] = page_totals[1][6] + wrk_round(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!--- alıs iade miktar --->
												#TLFormat(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("alis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
													<cfset alis_iade_miktar_2 = evaluate("alis_iade_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!--- alıs iade miktar2 --->
													<cfset toplam_alis_iade_miktar_2 = toplam_alis_iade_miktar_2 + alis_iade_miktar_2>
													#Tlformat(alis_iade_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											#TLFormat(net_alis,4)#
											<cfset page_totals[1][7] = page_totals[1][7] + net_alis> <!--- net alım  --->
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif len(multiplier)><!--- net alım miktar2 --->
													<cfset net_alis_2 = net_alis/multiplier>
													<cfset toplam_net_alis_2 = toplam_net_alis_2 + net_alis_2>
													#TLFormat(net_alis_2,4)# 
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<cfset alis_mal_1=0>
											<cfset alis_mal_2 = 0> <!--- sistem 2. para birimi net alış tutarını gösterir --->
											<td width="85" align="right" nowrap format="numeric">
											<cfif isdefined("alis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#"))>
												<cfset alis_mal_1=alis_mal_1 + evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#")> 	
												<cfset page_totals[1][8] = page_totals[1][8] + evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#")> <!--- alıs maliyet  --->
												#TLFormat(evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#"))# 
											</cfif>
											</td>
											<td width="15" nowrap="nowrap">
												<cfif isdefined("alis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<td width="85" align="right" nowrap format="numeric">
											<cfif isdefined("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
												<cfset alis_mal_1=alis_mal_1 - evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#")>
												<cfset page_totals[1][9] = page_totals[1][9] + evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#")> <!--- alıs iade maliyet  --->
												#TLFormat(evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))# 
											</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<td width="85" align="right" nowrap format="numeric">
												#TLFormat(alis_mal_1)# 
												<cfset page_totals[1][10] = page_totals[1][10] + alis_mal_1> 
											</td>
											<td width="15" nowrap>
												<cfif alis_mal_1 neq 0>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="85" align="right" nowrap format="numeric">
												<cfif isdefined("alis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
													<cfset alis_mal_2=alis_mal_2 + evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#")> 	
													<cfset page_totals[1][47] = page_totals[1][47] + evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#")> <!--- alıs maliyet  --->
													#TLFormat(evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
												</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("alis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="85" align="right" nowrap format="numeric">
													<cfif isdefined("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>
														<cfset alis_mal_2=alis_mal_2 - evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")>
														<cfset page_totals[1][48] = page_totals[1][48] + evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")> <!--- alıs iade maliyet  --->
														#TLFormat(evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("alis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="85" align="right" nowrap format="numeric">
													#TLFormat(alis_mal_2)# 
													<cfset page_totals[1][49] = page_totals[1][49] + alis_mal_2> 
												</td>
												<td width="15" nowrap><cfif alis_mal_2 neq 0>#session.ep.money2#</cfif></td>
											</cfif>
										</cfif>
									<td class="color-header" width="1"></td>
									</cfif>
									<!--- satıs ve satıs iade bolumu --->
									<cfset satis_mal_1=0>
									<cfif isdefined("satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))>
										<cfset page_totals[1][11] = page_totals[1][11] + evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#")> <!--- satıs maliyet  --->
										<cfset satis_mal_1=satis_mal_1 + evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#")>
									</cfif>
									<cfif isdefined("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
										<cfset page_totals[1][12] = page_totals[1][12] + evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")> <!--- satıs iade maliyet  --->
										<cfset satis_mal_1=satis_mal_1 - evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")>
									</cfif>
									<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
											<cfset net_satis_miktar1=0>
											<!---<cfset net_satis_miktar2=0>--->
											<td align="right" format="numeric">
												<cfif isdefined("satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"))>
													<cfset net_satis_miktar1=net_satis_miktar1+wrk_round(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"),4)>
													<cfset page_totals[1][13] = page_totals[1][13] + wrk_round(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!--- satıs miktar  --->
													#TLFormat(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#"),4)# </cfif>
											</td>
											<cfif x_show_second_unit>
												<td align="right" format="numeric">
													<cfif isdefined("satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
														<cfset satis_miktar_2 = evaluate("satis_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!--- satıs miktar2  --->
														<cfset toplam_satis_miktar_2 = toplam_satis_miktar_2 + satis_miktar_2>
														#Tlformat(satis_miktar_2,4)#
													</cfif>
												</td>
											</cfif>
											<cfif isdefined('attributes.display_cost')>
												<td align="right" nowrap format="numeric">
													<cfif isdefined("satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][16] = page_totals[1][16] + evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#")> <!---satıs maliyet  --->
														#TLFormat(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))#
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
												</td>
											</cfif>
											<td align="right" format="numeric">
												<cfif isdefined("satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
													<cfset net_satis_miktar1=net_satis_miktar1-wrk_round(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)>
													<cfset page_totals[1][14] = page_totals[1][14] + wrk_round(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!--- satıs iade miktar  --->
													#TLFormat(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)#
												</cfif>
											</td>
											<cfif x_show_second_unit>
												<td align="right" format="numeric">
													<cfif isdefined("satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
														<cfset satis_iade_miktar_2 = evaluate("satis_iade_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!--- satıs iade miktar2 --->
														<cfset toplam_satis_iade_miktar_2 = toplam_satis_iade_miktar_2 + satis_iade_miktar_2>
														#Tlformat(satis_iade_miktar_2,4)#
													</cfif>
												</td>
											</cfif>
											<cfif isdefined('attributes.display_cost')>
												<td width="82" align="right" format="numeric">
													<cfif isdefined("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][17] = page_totals[1][17] + evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")> <!---satıs iade maliyet  --->
														#TLFormat(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
												</td>
											</cfif>
											<td align="right" format="numeric">
												#TLFormat(net_satis_miktar1,4)#
												<cfset page_totals[1][15] = page_totals[1][15] + net_satis_miktar1> <!---net satıs miktar  --->
											</td>
											<cfif x_show_second_unit>
												<td align="right" format="numeric">
													<cfif len(multiplier)>
														<cfset net_satis_miktar_2 = net_satis_miktar1/multiplier><!---net satıs miktar2  --->
														<cfset toplam_net_satis_miktar_2 = toplam_net_satis_miktar_2 + net_satis_miktar_2>
														#Tlformat(net_satis_miktar_2,4)#
													</cfif>
												</td>
											</cfif>
											<cfif isdefined('attributes.display_cost')>
												<td width="82" align="right" nowrap format="numeric">
													<cfset page_totals[1][18] = page_totals[1][18] + satis_mal_1> <!---net satıs maliyet  --->
													#TLFormat(satis_mal_1)#
												</td>
												<td width="15" nowrap>
													<cfif satis_mal_1 neq 0>#attributes.cost_money#</cfif>
												</td>
											</cfif>
											<cfif isdefined('attributes.from_invoice_actions')><!--- satıs fatura tutarı --->
												<td align="right" format="numeric">
													<cfif isdefined("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][42] = page_totals[1][42] + wrk_round(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#"),4)> 
													<cfset fatura_net_satis_miktar = fatura_net_satis_miktar +wrk_round(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#"),4)>
													#TLFormat(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#"))#
													</cfif>	
												</td>
												<cfif x_show_second_unit>
													<td align="right" format="numeric">
														<cfif isdefined("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
															<cfset fatura_satis_miktar_2 = evaluate("fatura_satis_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!--- fatura satis miktar2 --->
															<cfset toplam_fatura_satis_miktar_2 = toplam_fatura_satis_miktar_2 + fatura_satis_miktar_2>
															#Tlformat(fatura_satis_miktar_2,4)#
														</cfif>
													</td>
												</cfif>
												<td width="82" align="right" format="numeric">
													<cfif isdefined("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][43] = page_totals[1][43] + evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#")> 
														#TLFormat(evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>	
												</td>
												<td width="15" nowrap>
													<cfif isdefined("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2')>
													<td width="110" align="right" format="numeric">
														<cfif isdefined("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#"))>
															<cfset page_totals[1][66] = page_totals[1][66] + evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#")> 
															#TLFormat(evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#"))# 
														</cfif>	
													</td>
													<td width="15" nowrap>
														<cfif isdefined("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_tutar2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
													</td>
												</cfif>
												<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
													<td width="82" align="right" format="numeric">
														<cfif isdefined("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#"))>
															<cfset page_totals[1][102] = page_totals[1][102] + evaluate("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#")> 
															#TLFormat(evaluate("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#"))# 
														</cfif>
													</td>
													<td width="15" nowrap>
														<cfif isdefined("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
													</td>
													<cfif isdefined('attributes.is_system_money_2')>
														<td width="110" align="right" format="numeric">
															<cfif isdefined("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#"))>
																<cfset page_totals[1][103] = page_totals[1][103] + evaluate("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#")> 
																#TLFormat(evaluate("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#"))# 
															</cfif>	
														</td>
														<td width="15" nowrap>
															<cfif isdefined("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_maliyet_2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
														</td>
													</cfif>
												</cfif>
												<td align="right" format="numeric">
													<cfif isdefined("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][44] = page_totals[1][44] + wrk_round(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)> 
														<cfset fatura_net_satis_miktar = fatura_net_satis_miktar -wrk_round(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)>
														#TLFormat(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)#
													</cfif>	
											</td>
											<cfif x_show_second_unit>
												<td align="right" format="numeric">
														<cfif isdefined("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)>
															<cfset fatura_satis_iade_miktar_2 = evaluate("fatura_satis_iade_miktar_#PRODUCT_GROUPBY_ID#")/multiplier><!---Fatura Satış İade Miktar2--->
															<cfset toplam_fatura_satis_iade_miktar_2 = toplam_fatura_satis_iade_miktar_2 + fatura_satis_iade_miktar_2>
															#Tlformat(fatura_satis_iade_miktar_2,4)#
														</cfif>
												</td>
											</cfif>
											<td width="108" align="right" format="numeric">
													<cfif isdefined("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][45] = page_totals[1][45] + evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#")> 
														#TLFormat(evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
												</td>
												<cfif isdefined('attributes.is_system_money_2')>
													<td width="132" align="right" format="numeric">
														<cfif isdefined("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#"))>
															<cfset page_totals[1][67] = page_totals[1][67] + evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#")> 
															#TLFormat(evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#"))# 
														</cfif>
													</td>
													<td width="15" nowrap>
														<cfif isdefined("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_tutar2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
													</td>
												</cfif>
												<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
													<td width="82" align="right" format="numeric">
														<cfif isdefined("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>
															<cfset page_totals[1][104] = page_totals[1][104] + evaluate("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#")> 
															#TLFormat(evaluate("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))# 
														</cfif>
													</td>
													<td width="15" nowrap>
														<cfif isdefined("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
													</td>
													<cfif isdefined('attributes.is_system_money_2')>
														<td width="110" align="right" format="numeric">
															<cfif isdefined("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#"))>
																<cfset page_totals[1][105] = page_totals[1][105] + evaluate("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#")> 
																#TLFormat(evaluate("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#"))# 
															</cfif>	
														</td>
														<td width="15" nowrap>
															<cfif isdefined("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fatura_satis_iade_maliyet_2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
														</td>
													</cfif>
													<td width="70" align="right" nowrap format="numeric">
														<cfset page_totals[1][101] = page_totals[1][101] + wrk_round((fatura_net_satis_miktar*ds_urun_birim_maliyet)/donem_sonu_kur)>
														#TLFormat((fatura_net_satis_miktar*ds_urun_birim_maliyet)/donem_sonu_kur)#
													</td>
													<td width="15" nowrap>
														#attributes.cost_money#
													</td>
												</cfif>
											</cfif>
											<cfif isdefined('attributes.display_cost')>
												<cfset satis_net_tutar1=0>
												<cfset satis_net_tutar_2=0> <!--- sistem 2. para birimi net satıs tutarını gösterir --->
												
												<cfif isdefined('attributes.is_system_money_2')>	 				
													<td width="82" align="right" nowrap format="numeric">
													<cfif isdefined("satis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][50] = page_totals[1][50] + evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---satıs maliyet usd --->
														<cfset satis_net_tutar_2 = satis_net_tutar_2 + evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#")>
														#TLFormat(evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
													</td>
													<td width="15" nowrap>
														<cfif isdefined("satis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
													</td>
													<td width="120" align="right" format="numeric">
													<cfif isdefined("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][51] = page_totals[1][51] + evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---satıs iade maliyet  ---> 
														<cfset satis_net_tutar_2 = satis_net_tutar_2 - evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#")>
														#TLFormat(evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))#
													</cfif>
													</td>
													<td width="15" nowrap>
														<cfif isdefined("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("satis_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))> #session.ep.money2#</cfif>
													</td>
													<td width="120" align="right" nowrap format="numeric">
														<cfset page_totals[1][65] = page_totals[1][65] + satis_net_tutar_2> <!---net satıs maliyet  --->
														#TLFormat(satis_net_tutar_2)# 
													</td>
													<td width="15" nowrap format="numeric">
														<cfif satis_net_tutar_2 neq 0> #session.ep.money2#</cfif>
													</td>
												</cfif>
											</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- Konsinye cikis irs. --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
										<td align="right" format="numeric">
											<cfif isdefined("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][19] = page_totals[1][19] + wrk_round(evaluate("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---kons_cikis_miktar  --->
												#TLFormat(evaluate("kons_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="85" align="right" nowrap format="numeric">
											<cfif isdefined("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][20] = page_totals[1][20] + evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#")> <!---kons_cikis_maliyet_ --->
				
												#TLFormat(evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td width="15" nowrap>
												<cfif isdefined("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="130" align="right" format="numeric">
												<cfif isdefined("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][52] = page_totals[1][52] + evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---kons_cikis_maliyet_ --->
													#TLFormat(evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td width="15" nowrap>
													<cfif isdefined("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
									<td class="color-header" width="1"></td>
									</cfif>
									<!--- konsinye iade gelen --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
										<td align="right" format="numeric">
											<cfif isdefined("kons_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][21] = page_totals[1][21] + wrk_round(evaluate("kons_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---kons_iade_miktar_--->
												#TLFormat(evaluate("kons_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
										<td width="118" align="right" format="numeric">
											<cfif isdefined("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][22] = page_totals[1][22] + evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#")> <!---kons_iade_maliyet_--->
												#TLFormat(evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td align="right" nowrap width="15">
												<cfif isdefined("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="128" align="right" format="numeric">
													<cfif isdefined("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
														<cfset page_totals[1][53] = page_totals[1][53] + evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---kons_iade_maliyet_--->
														#TLFormat(evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td align="right" nowrap width="15">
													<cfif isdefined("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#	</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- Konsinye Giriş İrs. --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
										<td align="right" format="numeric">
											<cfif isdefined("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][95] = page_totals[1][95] + wrk_round(evaluate("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---kons_giris_miktar  --->
												#TLFormat(evaluate("konsinye_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="118" align="right" format="numeric">
											<cfif isdefined("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][96] = page_totals[1][96] + evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#")> <!---kons_giris_maliyet_ --->
												#TLFormat(evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td align="right" nowrap width="15">
												<cfif isdefined("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
											<td width="128" align="right" format="numeric">
												<cfif isdefined("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][97] = page_totals[1][97] + evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---kons_giris_maliyet_2 --->
													#TLFormat(evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
											</td>
											<td align="right" nowrap width="15">
													<cfif isdefined("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("konsinye_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- Konsinye Giriş İade İrs. --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
										<td align="right" format="numeric">
											<cfif isdefined("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][98] = page_totals[1][98] + wrk_round(evaluate("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---kons_giris_iade miktar  --->
												#TLFormat(evaluate("kons_giris_iade_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="118" align="right" format="numeric">
											<cfif isdefined("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][99] = page_totals[1][99] + evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#")> <!---kons_giris_iade maliyet_ --->
				
												#TLFormat(evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td align="right" nowrap width="15">
												<cfif isdefined("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="128" align="right" format="numeric">
												<cfif isdefined("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][100] = page_totals[1][100] + evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---kons_giris_iade maliyet_2 --->
													#TLFormat(evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td align="right" nowrap width="15">
													<cfif isdefined("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("kons_giris_iade_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td></td>
									</cfif>
									<!--- Teknik Servis Giriş --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
										<td align="right" format="numeric">
											<cfif isdefined("servis_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][23] = page_totals[1][23] + wrk_round(evaluate("servis_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---servis_giris_miktar_--->
												#TLFormat(evaluate("servis_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="42" align="right" nowrap format="numeric">
											<cfif isdefined("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][24] = page_totals[1][24] + evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#")> <!---servis_giris_maliyet_--->
												#TLFormat(evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#"))# </cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="42" format="numeric">
												<cfif isdefined("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][54] = page_totals[1][54] + evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---servis_giris_maliyet_--->
													#TLFormat(evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- Teknik Servis Çıkış --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
										<td align="right" format="numeric">
											<cfif isdefined("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][25] = page_totals[1][25] + wrk_round(evaluate("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---servis_cikis_miktar_--->
												#TLFormat(evaluate("servis_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="42" align="right" nowrap format="numeric">
											<cfif isdefined("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][26] = page_totals[1][26] + evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#")> <!---servis_cikis_miktar_--->
												#TLFormat(evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))#</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="42" format="numeric">
												<cfif isdefined("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][55] = page_totals[1][55] + evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---servis_cikis_miktar_--->
													#TLFormat(evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("servis_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- RMA Giriş --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
										<td align="right" format="numeric">
											<cfif isdefined("rma_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][27] = page_totals[1][27] + wrk_round(evaluate("rma_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---rma_giris_miktar_--->
												#TLFormat(evaluate("rma_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="34" align="right" nowrap format="numeric">
											<cfif isdefined("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][28] = page_totals[1][28] + evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#")> <!---rma_giris_maliyet_--->
												#TLFormat(evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#"))# 
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="42" format="numeric">
													<cfif isdefined("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][56] = page_totals[1][56] + evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---rma_giris_maliyet_--->
														#TLFormat(evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- RMA Çıkış --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
										<td align="right" format="numeric">
											<cfif isdefined("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][29] = page_totals[1][29] + wrk_round(evaluate("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---rma_cikis_miktar_--->
												#TLFormat(evaluate("rma_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="34" align="right" nowrap format="numeric">
												<cfif isdefined("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][30] = page_totals[1][30] + evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#")> <!---rma_cikis_maliyet_--->
													#TLFormat(evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))# 
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="42" format="numeric">
													<cfif isdefined("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][57] = page_totals[1][57] + evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---rma_cikis_maliyet_--->
														#TLFormat(evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 
													</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("rma_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- uretim fisleri --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
										<td align="right" format="numeric">
											<cfif isdefined("uretim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][31] = page_totals[1][31] + wrk_round(evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---uretim_miktar_--->
												#TLFormat(evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("uretim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---uretim miktar2--->
													<cfset uretim_miktar_2 = evaluate("uretim_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_uretim_miktar_2 = toplam_uretim_miktar_2 + uretim_miktar_2>
													#Tlformat(uretim_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td align="right" nowrap format="numeric">
											<cfif isdefined("uretim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][32] = page_totals[1][32] + evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#")> <!---uretim_maliyet_--->
												#TLFormat(evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#"))# 
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("uretim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td align="right" nowrap format="numeric">
												<cfif isdefined("uretim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][58] = page_totals[1][58] + evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---uretim_maliyet_--->
													#TLFormat(evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("uretim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- sarf ve fire fisleri --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
										<td align="right" format="numeric">
											<cfif isdefined("sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][33] = page_totals[1][33] + wrk_round(evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---sarf_miktar_--->
												#TLFormat(evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---sarf miktar2--->
													<cfset sarf_miktar_2 = evaluate("sarf_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_sarf_miktar_2 = toplam_sarf_miktar_2 + sarf_miktar_2>
													#Tlformat(sarf_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][70] = page_totals[1][70] + wrk_round(evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#"),4)>  <!---uretim sarf_miktar_--->
												#TLFormat(evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---uretim sarf miktar2--->
													<cfset uretim_sarf_miktar_2 = evaluate("uretim_sarf_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_uretim_sarf_miktar_2 = toplam_uretim_sarf_miktar_2 + uretim_sarf_miktar_2>
													#Tlformat(uretim_sarf_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("fire_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][34] = page_totals[1][34] + wrk_round(evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---fire_miktar_--->
												#TLFormat(evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("fire_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---fire miktar2--->
													<cfset fire_miktar_2 = evaluate("fire_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_fire_miktar_2 = toplam_fire_miktar_2 + fire_miktar_2>
													#Tlformat(fire_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][35] = page_totals[1][35] + evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#")> <!---sarf_maliyet_--->
												#TLFormat(evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][71] = page_totals[1][71] + evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#")> <!---uretim sarf_maliyet_--->
												#TLFormat(evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("fire_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][36] = page_totals[1][36] + evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#")> <!---fire_maliyet_--->
													#TLFormat(evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("fire_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][59] = page_totals[1][59] + evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---sarf_maliyet_--->
													#TLFormat(evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][72] = page_totals[1][72] + evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---uretim sarf_maliyet_ sistem 2.dovizi--->
													#TLFormat(evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("uretim_sarf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("fire_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][60] = page_totals[1][60] + evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#")><!---fire_maliyet_--->
													#TLFormat(evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("fire_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("fire_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- sayim fisleri --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
										<td align="right" format="numeric">
											<cfif isdefined("sayim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][37] = page_totals[1][37] + wrk_round(evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---sayim_miktar_--->
												#TLFormat(evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("sayim_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---sayim miktar2--->
													<cfset sayim_miktar_2 = evaluate("sayim_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_sayim_miktar_2 = toplam_sayim_miktar_2 + sayim_miktar_2>
													#Tlformat(sayim_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="62" align="right" nowrap format="numeric">
											<cfif isdefined("sayim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][68] = page_totals[1][68] + evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#")> <!---sayim_maliyet_--->
												#TLFormat(evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#"))# 	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("sayim_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="62" align="right" nowrap format="numeric">
												<cfif isdefined("sayim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][69] = page_totals[1][69] + evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---sayim_maliyet_--->
													#TLFormat(evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("sayim_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sayim_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- demontajdan giris --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
										<td align="right" format="numeric">
											<cfif isdefined("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][38] = page_totals[1][38] + wrk_round(evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---demontaj_giris_miktar_--->
												#TLFormat(evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---demontaj giris miktar2--->
													<cfset demontaj_giris_miktar_2 = evaluate("demontaj_giris_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_demontaj_giris_miktar_2 = toplam_demontaj_giris_miktar_2 + demontaj_giris_miktar_2>
													#Tlformat(demontaj_giris_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][39] = page_totals[1][39] + evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#")> <!---demontaj_giris_maliyet_--->
												#TLFormat(evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#"))# 
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
											<td width="125" align="right" nowrap format="numeric">
												<cfif isdefined("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][61] = page_totals[1][61] + evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#")> <!---demontaj_giris_maliyet_--->
													#TLFormat(evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- demontaja giden --->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
										<td align="right" format="numeric">
											<cfif isdefined("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][40] = page_totals[1][40] + wrk_round(evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#"),4)> <!---demontaj_giden_miktar_--->
												#TLFormat(evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---demontaj giden miktar2--->
													<cfset demontaj_giden_miktar_2 = evaluate("demontaj_giden_miktar_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_demontaj_giden_miktar_2 = toplam_demontaj_giden_miktar_2 + demontaj_giden_miktar_2>
													#Tlformat(demontaj_giden_miktar_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][41] = page_totals[1][41] + evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#")> <!---demontaj_giden_maliyet_--->
												#TLFormat(evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][62] = page_totals[1][62] + evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#")><!---demontaj_giden_maliyet_--->
													#TLFormat(evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("demontaj_giden_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!--- masraf fişleri--->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
										<td align="right" format="numeric">
											<cfif isdefined("masraf_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][73] = page_totals[1][73] + wrk_round(evaluate("masraf_miktar_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("masraf_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("masraf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][74] = page_totals[1][74] + evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("masraf_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("masraf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][75] = page_totals[1][75] + evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("masraf_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("masraf_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!---depo sevk : giris-cıkıs stok bilgileri ayrı kolonlarda--->
									<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
										<td align="right" format="numeric">
											<cfif isdefined("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][77] = page_totals[1][77] + wrk_round(evaluate("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("sevk_giris_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<td align="right" format="numeric">
											<cfif isdefined("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][78] = page_totals[1][78] + wrk_round(evaluate("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("sevk_cikis_miktar_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
										
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][79] = page_totals[1][79] + evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][80] = page_totals[1][80] + evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][81] = page_totals[1][81] + evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_giris_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][82] = page_totals[1][82] + evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#") and len(evaluate("sevk_cikis_maliyet2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!---ithal mal girişi: giris-cıkıs stok bilgileri ayrı kolonlarda--->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
										<td align="right" format="numeric">
											<cfif isdefined("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][83] = page_totals[1][83] + wrk_round(evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---ithal mal giris miktar2--->
													<cfset ithal_mal_giris_miktari_2 = evaluate("ithal_mal_giris_miktari_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_ithal_mal_giris_miktari_2 = toplam_ithal_mal_giris_miktari_2 + ithal_mal_giris_miktari_2>
													#Tlformat(ithal_mal_giris_miktari_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][84] = page_totals[1][84] + wrk_round(evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---ithal mal cikis miktar2--->
													<cfset ithal_mal_cikis_miktari_2 = evaluate("ithal_mal_cikis_miktari_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_ithal_mal_cikis_miktari_2 = toplam_ithal_mal_cikis_miktari_2 + ithal_mal_cikis_miktari_2>
													#Tlformat(ithal_mal_cikis_miktari_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][85] = page_totals[1][85] + evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][86] = page_totals[1][86] + evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][87] = page_totals[1][87] + evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][88] = page_totals[1][88] + evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!---ambar fişi--->
									<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
										<td align="right" format="numeric">
											<cfif isdefined("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][89] = page_totals[1][89] + wrk_round(evaluate("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("ambar_fis_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<td align="right" format="numeric">
											<cfif isdefined("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][90] = page_totals[1][90] + wrk_round(evaluate("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("ambar_fis_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)#</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][91] = page_totals[1][91] + evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][92] = page_totals[1][92] + evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][93] = page_totals[1][93] + evaluate("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("ambar_fis_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][94] = page_totals[1][94] + evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ambar_fis_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!---stok virman--->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
										<td align="right" format="numeric">
											<cfif isdefined("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][106] = page_totals[1][106] + wrk_round(evaluate("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---stok virman giris miktar2--->
													<cfset stok_virman_giris_miktari_2 = evaluate("stok_virman_giris_miktari_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_stok_virman_giris_miktari_2 = toplam_stok_virman_giris_miktari_2 + stok_virman_giris_miktari_2>
													#Tlformat(stok_virman_giris_miktari_2,4)#
												</cfif>
											</td>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][107] = page_totals[1][107] + wrk_round(evaluate("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif x_show_second_unit>
											<td align="right" format="numeric">
												<cfif isdefined("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#")) and len(multiplier)><!---stok virman cikis miktar2--->
													<cfset stok_virman_cikis_miktari_2 = evaluate("stok_virman_cikis_miktari_#PRODUCT_GROUPBY_ID#")/multiplier>
													<cfset toplam_stok_virman_cikis_miktari_2 = toplam_stok_virman_cikis_miktari_2 + stok_virman_cikis_miktari_2>
													#Tlformat(stok_virman_cikis_miktari_2,4)#
												</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][108] = page_totals[1][108] + evaluate("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_giris_maliyeti_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
											<cfif isdefined("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>								
												<cfset page_totals[1][109] = page_totals[1][109] + evaluate("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#")>
												#TLFormat(evaluate("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))#	
											</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_maliyeti_#PRODUCT_GROUPBY_ID#"))>#attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("stok_virman_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][110] = page_totals[1][110] + evaluate("stok_virman_giris_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("stok_virman_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("ithal_mal_giris_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
												<td width="118" align="right" nowrap format="numeric">
												<cfif isdefined("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>								
													<cfset page_totals[1][111] = page_totals[1][111] + evaluate("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#")>
													#TLFormat(evaluate("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))# 	
												</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#") and len(evaluate("stok_virman_cikis_maliyeti2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<!---demirbaş stok fişi--->
									<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
										<td align="right" format="numeric">
											<cfif isdefined("invent_stock_fis_amount_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_amount_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][112] = page_totals[1][112] + wrk_round(evaluate("invent_stock_fis_amount_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("invent_stock_fis_amount_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][113] = page_totals[1][113] + wrk_round(evaluate("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#"),4)>
													#TLFormat(evaluate("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#"),4)#
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_cost_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][114] = page_totals[1][114] + wrk_round(evaluate("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#"),4)>
													#TLFormat(evaluate("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#"),4)#
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_price_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
													<cfif isdefined("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][115] = page_totals[1][115] + wrk_round(evaluate("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#"),4)>
														#TLFormat(evaluate("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#"),4)#
													</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_cost2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td align="right" format="numeric">
											<cfif isdefined("invent_stock_fis_return_amount_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_amount_#PRODUCT_GROUPBY_ID#"))>
												<cfset page_totals[1][116] = page_totals[1][116] + wrk_round(evaluate("invent_stock_fis_return_amount_#PRODUCT_GROUPBY_ID#"),4)>
												#TLFormat(evaluate("invent_stock_fis_return_amount_#PRODUCT_GROUPBY_ID#"),4)#
											</cfif>
										</td>
										<cfif isdefined('attributes.display_cost')>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][117] = page_totals[1][117] + wrk_round(evaluate("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#"),4)>
													#TLFormat(evaluate("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#"),4)#
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_cost_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<td width="38" align="right" nowrap format="numeric">
												<cfif isdefined("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#"))>
													<cfset page_totals[1][118] = page_totals[1][118] + wrk_round(evaluate("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#"),4)>
													#TLFormat(evaluate("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#"),4)#
												</cfif>
											</td>
											<td nowrap="nowrap" width="15">
												<cfif isdefined("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_price_#PRODUCT_GROUPBY_ID#"))> #attributes.cost_money#</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td width="118" align="right" nowrap format="numeric">
													<cfif isdefined("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#"))>
														<cfset page_totals[1][119] = page_totals[1][119] + wrk_round(evaluate("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#"),4)>
														#TLFormat(evaluate("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#"),4)#
													</cfif>
												</td>
												<td nowrap="nowrap" width="15">
													<cfif isdefined("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#") and len(evaluate("invent_stock_fis_return_cost2_#PRODUCT_GROUPBY_ID#"))>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
										<td class="color-header" width="1"></td>
									</cfif>
									<td align="right" format="numeric">
										<cfif listfind('8,12',attributes.report_type)>
											<cfif isdefined("get_all_stock.TOTAL_STOCK") and len(get_all_stock.TOTAL_STOCK)>
												<cfset donem_sonu_stok=get_all_stock.TOTAL_STOCK>
												<cfset page_totals[1][1] = page_totals[1][1] + wrk_round(get_all_stock.TOTAL_STOCK,4)> <!---donem sonu stok--->
												#TLFormat(get_all_stock.TOTAL_STOCK,4)#
											<cfelse>
												#TLFormat(0,4)#
											</cfif>
										<cfelse>
											<cfif isdefined("donem_sonu_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#"))>
												<cfset donem_sonu_stok=evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#")>
												<cfset page_totals[1][1] = page_totals[1][1] + wrk_round(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#"),4)> <!---donem sonu stok--->
												#TLFormat(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#"),4)#
											<cfelse>
												#TLFormat(0,4)#
											</cfif>
										</cfif>
									</td>
									<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
										<td align="right" format="numeric">
											<cfif isdefined("donem_sonu_#PRODUCT_GROUPBY_ID#") and len(evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#")) and len(get_all_stock.multiplier)>
												<cfset 'amount_new2_#get_all_stock.PRODUCT_GROUPBY_ID#' = evaluate("donem_sonu_#PRODUCT_GROUPBY_ID#")/wrk_round(get_all_stock.multiplier,8,1)>
												<cfset page_totals[1][123] = page_totals[1][123] + wrk_round(evaluate("amount_new2_#PRODUCT_GROUPBY_ID#"),4)><!--- 2.birim miktar stok --->
												#TLFormat(evaluate('amount_new2_#get_all_stock.PRODUCT_GROUPBY_ID#'),4)#
											</cfif>
										</td>
									</cfif>
									<cfif isdefined('attributes.display_cost')>
										<cfif wrk_round(donem_sonu_stok) neq 0>
											<cfset donem_sonu_maliyet=(donem_sonu_stok*ds_urun_birim_maliyet)>
											<cfif donem_sonu_maliyet neq 0>
												<cfset page_totals[1][2] = page_totals[1][2] + (donem_sonu_maliyet/donem_sonu_kur_)> <!---donem sonu maliyet--->
												<cfset ds_toplam_maliyet = donem_sonu_maliyet/donem_sonu_kur_>
											</cfif>
											<cfif isdefined('attributes.is_system_money_2')>
												<cfif len(ds_urun_birim_maliyet2)>
													<cfset donem_sonu_maliyet2=(donem_sonu_stok*ds_urun_birim_maliyet2)>
												<cfelse>
													<cfset donem_sonu_maliyet2=0>
												</cfif>
												<cfif donem_sonu_maliyet2 neq 0>
													<cfset page_totals[1][63] = page_totals[1][63] + donem_sonu_maliyet2> <!---donem sonu maliyet 2--->											
													<cfset ds_toplam_maliyet2 =donem_sonu_maliyet2>
												</cfif>
											</cfif>
										</cfif>
										<td width="82" align="right" nowrap format="numeric">
											#TLFormat(ds_toplam_maliyet)#
										</td>
										<td>
											<cfif isdefined("attributes.display_cost_money")>
												#all_finish_money#
											<cfelse>
												#attributes.cost_money#	
											</cfif>
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td align="right" nowrap format="numeric">
												#TLFormat(ds_toplam_maliyet2)#
											</td>
											<td width="15" nowrap>
												<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
											</td>
										</cfif>
										<cfif isdefined('attributes.display_ds_prod_cost')><!--- birim maliyet --->
											<cfif isdefined('round_number')><cfset round_number = round_number><cfelse><cfset round_number = 2></cfif>
											<td align="right" nowrap format="numeric_excel">
												<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet/donem_sonu_stok,round_number)#</cfif>
											</td>
											<td>
												<cfif wrk_round(donem_sonu_stok) neq 0>
													<cfif isdefined("attributes.display_cost_money")>
														#all_finish_money#
													<cfelse>
														#attributes.cost_money#	
													</cfif>
												</cfif>
											</td>
											<cfif isdefined('attributes.is_system_money_2')>
												<td align="right" nowrap format="numeric_excel">
													<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet2/donem_sonu_stok,round_number)#</cfif>
												</td>
												<td width="15" nowrap>
													<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
												</td>
											</cfif>
										</cfif>
									</cfif>
									<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8,12',attributes.report_type)>
										<cfif len(GET_ALL_STOCK.DIMENTION)>
											<cfif attributes.volume_unit eq 1>
												<cfset prod_volume = evaluate(REPLACE(GET_ALL_STOCK.DIMENTION,',','.','ALL'))>
											<cfelseif attributes.volume_unit eq 2>
												<cfset prod_volume = evaluate(REPLACE(GET_ALL_STOCK.DIMENTION,',','.','ALL'))/ 1000>
											<cfelseif attributes.volume_unit eq 3>
												<cfset prod_volume = evaluate(REPLACE(GET_ALL_STOCK.DIMENTION,',','.','ALL')) / 1000000>
											</cfif>
										</cfif>
										<td align="right">
											<cfif len(GET_ALL_STOCK.DIMENTION)>#prod_volume#</cfif>
										</td>
										<td align="right">
											<cfif wrk_round(donem_sonu_stok) neq 0 and len(GET_ALL_STOCK.DIMENTION)>#prod_volume*wrk_round(donem_sonu_stok)# </cfif>
										</td>
									</cfif>
									<cfif isdefined('attributes.stock_age')>
										<cfset agirlikli_toplam=0>
										<cfif donem_sonu_stok gt 0>
											<cfset kalan=donem_sonu_stok>
											<cfquery name="get_product_detail" dbtype="query">
												SELECT 
													AMOUNT AS PURCHASE_AMOUNT,
													GUN_FARKI 
												FROM 
													GET_STOCK_AGE 
												WHERE 
													#ALAN_ADI# =<cfif listfind('8,12',attributes.report_type)>'#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'<cfelse>#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#</cfif>
                                                ORDER BY ISLEM_TARIHI
											</cfquery>
											<cfloop query="get_product_detail">
												<cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
													<cfset kalan = kalan - PURCHASE_AMOUNT>
													<cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
												<cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
													<cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
													<cfbreak>
												</cfif>
											</cfloop>
											<cfset agırlıklı_toplam=agırlıklı_toplam/donem_sonu_stok>
										</cfif>
										<td class="color-header" width="1"></td>
										<td nowrap="nowrap" align="right" format="numeric">
											<cfif agırlıklı_toplam gt 0>#TLFormat(agırlıklı_toplam)#</cfif>
										</td>
									</cfif>
									<cfif isdefined('attributes.stock_rate')>
										<td class="color-header" width="1"></td>
										<td nowrap="nowrap" align="right" format="numeric">
											<cfset envanter = (donem_basi_stok + donem_sonu_stok) / 2>
											<cfif envanter gt 0>#TLFormat(satis_mal_1/envanter)#</cfif>
										</td>
									</cfif>
								</tr>
							</cfoutput>
						</cfif>
					</cfif>
				</tbody>
					<tfoot>
					<cfoutput>
					<cfif listfind('3,4,5,6,9,10,11',attributes.report_type)>
						<tr height="20" class="total">
							<td nowrap class="txtbold"><cf_get_lang no="462.Sayfa Toplam"></td>
							<td align="right" format="numeric">
								#TLFormat(page_totals[1][1],4)#<!--- donem sonu stok --->
							</td>
							<cfif isdefined('attributes.display_cost')>
								<td align="right" nowrap="nowrap" colspan="2" format="numeric"><!--- donem sonu maliyet --->
									#TLFormat(page_totals[1][2])# <cfif page_totals[1][2] neq 0>#attributes.cost_money#</cfif>
								</td>
								<cfif isdefined('attributes.is_system_money_2')>
									<td align="right" nowrap="nowrap" colspan="2" format="numeric"><!--- alıs maliyet  --->
										#TLFormat(page_totals[1][63])# <cfif page_totals[1][63] neq 0>#session.ep.money2#</cfif>
									</td>
								</cfif>
							</cfif>
							<cfif isdefined('attributes.stock_age')>
								<td class="color-header" width="1"></td>
								<td nowrap="nowrap" align="right"></td>
							</cfif>
							<cfif isdefined('attributes.stock_rate')>
								<td class="color-header" width="1"></td>
								<td nowrap="nowrap" align="right"></td>
							</cfif>
						</tr>
					<cfelse>
						<tr height="20" class="total">
							<cfif attributes.report_type eq 1>
								<cfset temp_page_total_colspan_=8>
							<cfelseif attributes.report_type eq 2>
								<cfset temp_page_total_colspan_=7>
							<cfelse>
								<cfset temp_page_total_colspan_=7>
							</cfif>	
							<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
								<cfset temp_page_total_colspan_ = temp_page_total_colspan_ + 1>
							</cfif>
							<td width="130" nowrap colspan="#temp_page_total_colspan_#" class="txtbold"> <cf_get_lang no="462.Sayfa Toplam "></td>
							<td align="right" format="numeric">
								#TLFormat(page_totals[1][3],4)#<!--- donem bası stok --->
							</td>
							<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][122],4)#<!--- 2.birim miktar stok --->
								</td>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<td align="right" nowrap format="numeric"><!--- donem bası maliyet --->
									<cfif not isdefined('attributes.display_cost_money')>#TLFormat(page_totals[1][4])#</cfif>
								</td>
								<td nowrap>
									<cfif page_totals[1][4] neq 0 and not isdefined('attributes.display_cost_money')>#attributes.cost_money#</cfif>
								</td>
								<cfif isdefined('attributes.is_system_money_2')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][64])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][64] neq 0>#session.ep.money2#</cfif>
									</td>
								</cfif>
							</cfif>
							<td class="color-header" width="1"></td>
							<!--- alıs ve alıs iadeler bolumu --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
								<td align="right" format="numeric"><!--- alıs miktar --->
									#TLFormat(page_totals[1][5],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric"><!--- alıs miktar2 --->
										#TLFormat(toplam_alis_miktar_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric"><!--- alıs iade miktar --->
									#TLFormat(page_totals[1][6],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric"><!--- alıs miktar2 --->
										#TLFormat(toplam_alis_iade_miktar_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric"> <!--- net alıs  --->
									#TLFormat(page_totals[1][7],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric"> <!--- net alıs miktar2  --->
										#TLFormat(toplam_net_alis_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][8])#
									</td> <!--- alıs maliyet  --->
									<td align="right" nowrap>
										<cfif page_totals[1][8] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][9])#
									</td><!--- alıs iade maliyet  --->
									<td align="right" nowrap>
										<cfif page_totals[1][9] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][10])#
									</td> <!--- net alıs maliyet --->
									<td align="right" nowrap>
										<cfif page_totals[1][10] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][47])#
										</td><!--- alıs maliyet  --->
										<td align="right" nowrap>
											<cfif page_totals[1][47] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][48])#
										</td><!--- alıs iade maliyet  --->
										<td align="right" nowrap>
											<cfif page_totals[1][48] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][49])#
										</td><!--- net alıs maliyet --->
										<td align="right" nowrap>
											<cfif page_totals[1][49] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
								<td align="right" format="numeric">#TLFormat(page_totals[1][13],4)#</td> <!--- satıs miktar  --->
								<cfif x_show_second_unit>
									<td align="right" format="numeric">#TLFormat(toplam_satis_miktar_2,4)#</td> <!--- satıs miktar2  --->
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][16])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][16] neq 0>#attributes.cost_money#</cfif>
									</td>
								</cfif>
								<td align="right" format="numeric">#TLFormat(page_totals[1][14],4)#</td><!--- satıs iade miktar  --->
								<cfif x_show_second_unit>
									<td align="right" format="numeric">#TLFormat(toplam_satis_iade_miktar_2,4)#</td><!--- satıs iade miktar2  --->
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" format="numeric">#TLFormat(page_totals[1][17])#</td><!---Satış İade Maliyet --->
									<td align="right" nowrap>
										<cfif page_totals[1][17] neq 0>#attributes.cost_money#</cfif>
									</td>
								</cfif>
								<td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][15],4)#<!---Net Satış Miktar --->
								</td>
								<cfif x_show_second_unit>
									<td align="right" nowrap format="numeric">
										#TLFormat(toplam_net_satis_miktar_2,4)#<!---Net Satış Miktar2 --->
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][18])#<!---Net Satış Maliyet --->
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][18] neq 0>#attributes.cost_money#</cfif>
									</td>
								</cfif>
								<cfif isdefined('attributes.from_invoice_actions')><!--- fatura hareketlerinden satış-satış iade miktar ve tutar --->
									<td align="right" format="numeric"><!--- Fatura Satış Miktar --->
										#TLFormat(page_totals[1][42],4)#
									</td>
									<cfif x_show_second_unit>
										<td align="right" format="numeric"><!--- Fatura Satış Miktar2 --->
											#TLFormat(toplam_fatura_satis_miktar_2,4)#
										</td>
									</cfif>
									<td align="right" nowrap colspan="2" format="numeric">
										#TLFormat(page_totals[1][43])# 
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs tutarı sistem 2. para br cinsinden --->
											#TLFormat(page_totals[1][66])#
										</td>
									</cfif>
									<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
										<td align="right" nowrap colspan="2" format="numeric"> <!--- fatura satış maliyeti --->
											#TLFormat(page_totals[1][102])#
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
											<td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
												#TLFormat(page_totals[1][103])#
											</td>
										</cfif>
									</cfif>
									<td align="right" format="numeric">
										#TLFormat(page_totals[1][44],4)#
									</td>
									<cfif x_show_second_unit>
										<td align="right" format="numeric">
											#TLFormat(toplam_fatura_satis_iade_miktar_2,4)#
										</td>
									</cfif>
									<td align="right" nowrap colspan="2" format="numeric">
										#TLFormat(page_totals[1][45])#
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
									<td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
										#TLFormat(page_totals[1][67])#
									</td>
									</cfif>
									<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
										<td align="right" nowrap colspan="2" format="numeric">
											#TLFormat(page_totals[1][104])#
										</td>
										<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
											#TLFormat(page_totals[1][105])#
										</td>
										</cfif>
									</cfif>
									<!--- net fatura satış maliyeti  --->
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][101])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][101] neq 0>#attributes.cost_money#</cfif>
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<!--- Net Fatura Satış Maliyeti bir aşağıdaki kısımda hesaplanmakta ve fazla konulduğu için silinmiştir. Sorun Olmazsa kaldırılabilir. OS 250414
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][16])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][16] neq 0>#attributes.cost_money#</cfif>
									</td>--->
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][50])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][50] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][51])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][51] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][65])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][65] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- Konsinye cikis irs. --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][19],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][20])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][20] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][52])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][52] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- konsinye iade gelen --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][21],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][22])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][22] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][53])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][53] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- konsinye giriş --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][95],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][96])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][96] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][97])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][97] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- konsinye giriş iade --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][98],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][99])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][99] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][100])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][100] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- Teknik Servis Giriş --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][23],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][24])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][24] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][54])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][54] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- Teknik Servis Çıkış --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][25],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][26])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][26] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][55])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][55] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- RMA Giriş --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][27],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap="nowrap" format="numeric">
										#TLFormat(page_totals[1][28])#
									</td>
									<td align="right" nowrap="nowrap">
										<cfif page_totals[1][28] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap="nowrap" format="numeric">
											#TLFormat(page_totals[1][56])#
										</td>
										<td align="right" nowrap="nowrap">
											<cfif page_totals[1][56] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- RMA Çıkış --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][29],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][30])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][30] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][57])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][57] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- uretim fisleri --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][31],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_uretim_miktar_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][32])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][32] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][58])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][58] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- sarf ve fire fisleri --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][33],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_sarf_miktar_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][70],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_uretim_sarf_miktar_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][34],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_fire_miktar_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][35])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][35] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][71])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][71] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][36])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][36] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][59])#</td>
										<td align="right" nowrap>
											<cfif page_totals[1][59] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][72])#</td>
										<td align="right" nowrap>
											<cfif page_totals[1][72] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][60])#</td>
										<td align="right" nowrap>
											<cfif page_totals[1][60] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- sayim fisleri --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][37],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_sayim_miktar_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][68])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][68] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][69])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][69] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- demontajdan giris --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][38],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_demontaj_giris_miktar_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][39])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][39] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][61])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][61] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- demontaja giden --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][40],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_demontaj_giden_miktar_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][41])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][41] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][62])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][62] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- masraf fişleri --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][73],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][74])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][74] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][75])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][75] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!--- depo sevk --->
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][77],4)#
								</td>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][78],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][79])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][79] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][80])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][80] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][81])# 
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][81] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][82])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][82] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>

								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!---ithal mal girisi --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,17)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][83],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_ithal_mal_giris_miktari_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][84],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_ithal_mal_cikis_miktari_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][85])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][85] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][86])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][86] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][87])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][87] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">
											#TLFormat(page_totals[1][88])#
										</td>
										<td align="right" nowrap>
											<cfif page_totals[1][88] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!---ambar fişi --->
							<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][89],4)#
								</td>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][90],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][91])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][91] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][92])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][92] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][93])# </td>
										<td align="right" nowrap>
											<cfif page_totals[1][93] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][94])# </td>
										<td align="right" nowrap>
											<cfif page_totals[1][94] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!---stok virman --->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,21)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][106],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_stok_virman_giris_miktari_2,4)#
									</td>
								</cfif>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][107],4)#
								</td>
								<cfif x_show_second_unit>
									<td align="right" format="numeric">
										#TLFormat(toplam_stok_virman_cikis_miktari_2,4)#
									</td>
								</cfif>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][108])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][108] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][109])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][109] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][110])# </td>
										<td align="right" nowrap>
											<cfif page_totals[1][110] neq 0>#session.ep.money2#</cfif>
										</td>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][111])# </td>
										<td align="right" nowrap>
											<cfif page_totals[1][111] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<!---demirbaş iade fişi--->
							<cfif len(attributes.process_type) and listfind(attributes.process_type,22)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][112],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][113])#
									</td>
									<td nowrap>
										<cfif page_totals[1][113] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][114])#
									</td>
									<td nowrap>
										<cfif page_totals[1][114] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][115])# </td>
										<td nowrap>
											<cfif page_totals[1][115] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][116],4)#
								</td>
								<cfif isdefined('attributes.display_cost')>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][117])#
									</td>
									<td nowrap>
										<cfif page_totals[1][117] neq 0>#attributes.cost_money#</cfif>
									</td>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][118])#
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][118] neq 0>#attributes.cost_money#</cfif>
									</td>
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap format="numeric">#TLFormat(page_totals[1][119])# </td>
										<td nowrap>
											<cfif page_totals[1][119] neq 0>#session.ep.money2#</cfif>
										</td>
									</cfif>
								</cfif>
								<td class="color-header" width="1"></td>
							</cfif>
							<td align="right" format="numeric">
								#TLFormat(page_totals[1][1],4)#
							</td>
							<cfif x_show_second_unit eq 1 and listfind('1,2',attributes.report_type)>
								<td align="right" format="numeric">
									#TLFormat(page_totals[1][123],4)#<!--- 2.birim miktar stok --->
								</td>
							</cfif>
							<cfif isdefined('attributes.display_cost')>
								<td align="right" nowrap format="numeric">
									<cfif not isdefined('attributes.display_cost_money')>#TLFormat(page_totals[1][2])#</cfif>
								</td>
								<td nowrap>
									<cfif page_totals[1][2] neq 0 and not isdefined('attributes.display_cost_money')>#attributes.cost_money#</cfif>
								</td>
								<cfif isdefined('attributes.is_system_money_2')	>
									<td align="right" nowrap format="numeric">
										#TLFormat(page_totals[1][63])# 
									</td>
									<td align="right" nowrap>
										<cfif page_totals[1][63] neq 0>#session.ep.money2#</cfif>
									</td>
								</cfif>
								<cfif isdefined('attributes.display_ds_prod_cost')>
									<td align="right" nowrap colspan="2"></td><!--- birim maliyet --->
									<cfif isdefined('attributes.is_system_money_2')>
										<td align="right" nowrap colspan="2"></td><!--- birim maliyet --->
									</cfif>
								</cfif>
							</cfif>
							<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)><!--- birim ve toplam hacim  --->
								<td class="txtboldblue" nowrap="nowrap" align="right"></td>
								<td class="txtboldblue" nowrap="nowrap" align="right"></td>
							</cfif>
							<cfif isdefined('attributes.stock_age')>
								<td class="color-header" width="1"></td>
								<td class="color-header" width="1"></td>
							</cfif>
							<cfif isdefined('attributes.stock_rate')>
								<td class="color-header" width="1"></td>
								<td class="txtboldblue" nowrap="nowrap" align="right"></td>
							</cfif>
						</tr>
					</cfif>
					<!--- sayfa toplamları yazdırılıyor --->
					</cfoutput>
					</tfoot>
				<cfelse>
				<tbody>
					<cfif isdefined('attributes.ajax')>
						<script type="text/javascript">
							<cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
								<cfset function_code = '_#ListGetAt(attributes.department_id,1,'-')#_#ListGetAt(attributes.department_id,2,'-')#'>
								<cfoutput>user_info_show_div#function_code#(1,1,1);</cfoutput>
							<cfelse>
								user_info_show_div(1,1,1);
							</cfif>
						</script>
					</cfif>
					<cfoutput>
					<tr height="22">
						<td colspan="48"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse></cfif></td>
					</tr>
					</cfoutput>
				</cfif>
				</tbody>
			</cfif>
	</cf_report_list>
</cfif>	
		<cfif not listfind('1,2',attributes.is_excel)>

<cfif attributes.maxrows lt attributes.totalrecords>
	<cfset adres = "#fusebox.Circuit#.stock_analyse">
	<cfscript>
		if(len(attributes.report_type))
			adres="#adres#&report_type=#attributes.report_type#";
		if(len(attributes.employee_name) and len(attributes.product_employee_id))	
			adres="#adres#&employee_name=#attributes.employee_name#&product_employee_id=#attributes.product_employee_id#";
		if(len(attributes.product_name) and len(attributes.product_id))
			adres="#adres#&product_name=#attributes.product_name#&product_id=#attributes.product_id#";
		if(len(attributes.sup_company) and len(attributes.sup_company_id))
			adres="#adres#&sup_company=#attributes.sup_company#&sup_company_id=#attributes.sup_company_id#";
		if(len(attributes.product_code) and len(attributes.product_cat))
			adres="#adres#&product_code=#attributes.product_code#&product_cat=#attributes.product_cat#";
		if(len(attributes.brand_name) and len(attributes.brand_id))
			adres="#adres#&brand_name=#attributes.brand_name#&brand_id=#attributes.brand_id#";
		if(len(attributes.project_head) and len(attributes.project_id))
			adres="#adres#&project_head=#attributes.project_head#&project_id=#attributes.project_id#";	
		if(len(attributes.cost_money))
			adres="#adres#&cost_money=#attributes.cost_money#";
		if(isdefined('attributes.display_cost'))
			adres="#adres#&display_cost=#attributes.display_cost#";
		if(isdefined('attributes.display_cost_money'))
			adres="#adres#&display_cost=#attributes.display_cost_money#";
		if(isdefined('attributes.is_envantory'))
			adres="#adres#&is_envantory=#attributes.is_envantory#";
		if(isdefined('attributes.location_based_cost'))
			adres="#adres#&location_based_cost=#attributes.location_based_cost#";
		if(isdefined('attributes.department_based_cost'))
			adres="#adres#&department_based_cost=#attributes.department_based_cost#";
		if(isdefined('attributes.process_type_detail'))
			adres="#adres#&process_type_detail=#attributes.process_type_detail#";
		if(len(attributes.department_id))
			adres="#adres#&department_id=#attributes.department_id#";
		if(isdefined('attributes.stock_age'))
			adres="#adres#&stock_age=#attributes.stock_age#";
		if(isdefined('attributes.stock_rate'))
			adres="#adres#&stock_rate=#attributes.stock_rate#";
		if(len(attributes.department_id_new))
			adres="#adres#&department_id_new=#attributes.department_id_new#";
		if(isdefined('attributes.positive_stock'))
			adres="#adres#&positive_stock=#attributes.positive_stock#";
		if(isdefined('attributes.negatif_stock'))
			adres="#adres#&negatif_stock=1";
		if(isdefined('attributes.product_status'))
			adres="#adres#&product_status=#attributes.product_status#";
		if(isdefined('attributes.is_stock_action'))
			adres="#adres#&is_stock_action=1";
		if(isdefined('attributes.display_ds_prod_cost'))
			adres="#adres#&display_ds_prod_cost=#attributes.display_ds_prod_cost#";
		if(isdefined('attributes.is_stock_fis_control'))
			adres="#adres#&is_stock_fis_control=1";
		if(isdefined('attributes.from_invoice_actions') and len(attributes.from_invoice_actions))
			adres="#adres#&from_invoice_actions=#attributes.from_invoice_actions#";
		if(isdefined('attributes.is_belognto_institution') and len(attributes.is_belognto_institution))
			adres="#adres#&is_belognto_institution=#attributes.is_belognto_institution#";
		if( isdefined('attributes.is_system_money_2'))
			adres= "#adres#&is_system_money_2=#attributes.is_system_money_2#";
		if( isdefined('attributes.control_total_stock') and len(attributes.control_total_stock))
			adres= "#adres#&control_total_stock=#attributes.control_total_stock#";
		if( isdefined('attributes.volume_unit') and len(attributes.volume_unit))
			adres= "#adres#&volume_unit=#attributes.volume_unit#";
		if( isdefined('attributes.display_prod_volume') and len(attributes.display_prod_volume))
			adres= "#adres#&display_prod_volume=#attributes.display_prod_volume#";
		if( isdefined('attributes.product_types') and len(attributes.product_types))
			adres= "#adres#&product_types=#attributes.product_types#";
			//ekle unutma is_excel
		adres="#adres#&date=#attributes.date#&date2=#attributes.date2#";
		adres="#adres#&is_form_submitted=#attributes.is_form_submitted#";
	</cfscript>
	<cfif attributes.totalrecords gt attributes.maxrows>
				<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
			<!-- sil -->
	</cfif>		
</cfif>

</cfif>
<!--- <cfif not listfind('1,2',attributes.is_excel)>
<br/>
			
		</cfif> --->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">


<script type="text/javascript">
	
	<cfif attributes.is_excel eq 1>
		$(function() {
			TableToExcel.convert(document.getElementById('search_list')); 
		});
	</cfif>	
	function control_report_type()
	{
		if(document.rapor.report_type.value == 9 || document.rapor.report_type.value == 10)
		{
			dept_id.style.display='none';
			dept_id2.style.display='';
		}
		else
		{
			dept_id.style.display='';
			dept_id2.style.display='none';
		}
		var temp_report_type=document.rapor.report_type.options[document.rapor.report_type.selectedIndex].value;
		if(document.rapor.display_ds_prod_cost.checked==true && list_find('3,4,5,6,9,10',temp_report_type))
		{
			alert("<cf_get_lang no ='1486.Birim Maliyet, Sadece Ürün ve Stok Bazında Raporlama Yapıldığında Seçilebilir'>!");
			document.rapor.display_ds_prod_cost.checked=false;
		}
		if(document.rapor.display_prod_volume.checked==true && list_find('3,4,5,6,9,10',temp_report_type))
		{
			alert("Hacim, Sadece Ürün ve Stok Bazında Raporlama Yapıldığında Seçilebilir!");
			document.rapor.display_prod_volume.checked=false;
		}
		if(document.rapor.report_type.value==7)
		{	
			document.getElementById('member_report_type1').style.display='none';
			document.getElementById('member_report_type2').style.display='';
			document.getElementById('project_id_').style.display='';
			document.getElementById('project_id_2').style.display='';
		}
		else
		{
			document.getElementById('member_report_type2').style.display='none';
			document.getElementById('member_report_type1').style.display='';
			document.getElementById('project_id_').style.display='none';
			document.getElementById('project_id_2').style.display='none';
		}
		if(!list_find('1,2,8,12',temp_report_type))
		{
			$('#stock_properties').css('display','none');
			$('#stock_age').val();
			$('#stock_rate').val();
			$('#stock_age').prop("checked", false);
			$('#stock_rate').prop("checked", false);
		}
		else
		{
			$('#stock_properties').css('display','block');
		}
		
	}
	
	function degistir_action()
	{
		var document_id = document.rapor.department_id.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.rapor.department_id.options[i].selected && document_name.length==0)
				document_name = document_name + list_getat(document.rapor.department_id.options[i].value,1,'-');
			else if(document.rapor.department_id.options[i].selected && ! list_find(document_name,list_getat(document.rapor.department_id.options[i].value,2,'-'),','))
				document_name = document_name + ',' + list_getat(document.rapor.department_id.options[i].value,2,'-');
		}
		if (document.rapor.location_based_cost!=undefined&&document.rapor.location_based_cost.checked && list_len(document_name,',') != 1 && (document.rapor.report_type.value == 1 || document.rapor.report_type.value == 2))
		{
			alert("Lokasyon Bazında Maliyet Gösterebilmek İçin Bir Lokasyon Seçmelisiniz !");
			return false;
		}
		else if (document.rapor.location_based_cost!=undefined&&document.rapor.location_based_cost.checked && ! (document.rapor.report_type.value == 1 || document.rapor.report_type.value == 2))
		{
			document.rapor.location_based_cost.checked = false;
		}
		if (document.rapor.department_based_cost!=undefined&&document.rapor.department_based_cost.checked && list_len(document_name,',') != 1 && (document.rapor.report_type.value == 1 || document.rapor.report_type.value == 2))
		{
			alert("Depo Bazında Maliyet Gösterebilmek İçin Bir Depo Seçmelisiniz !");
			return false;
		}
		else if (document.rapor.department_based_cost!=undefined&&document.rapor.department_based_cost.checked && ! (document.rapor.report_type.value == 1 || document.rapor.report_type.value == 2))
		{
			document.rapor.department_based_cost.checked = false;
		}
		if (document.rapor.department_based_cost!=undefined&&document.rapor.department_based_cost.checked&&document.rapor.location_based_cost!=undefined&&document.rapor.location_based_cost.checked)
		{
			alert("Depo ve Lokasyon Bazlı Maliyet Birlikte Seçilemez !");
			return false;
		}
		if(document.rapor.display_cost_money!=undefined&&document.rapor.display_cost_money.checked == true && ! list_find('1,2,8',document.rapor.report_type.value))
		{
			alert("Maliyeti İşlem Dövizli Alabilmek İçin Ürün,Stok Veya Spec Bazında Rapor Almalısınız !");
			return false;
		}
		if(document.rapor.report_type.value == 10)
		{
			var document_id = document.rapor.department_id_new.options.length;	
			var document_name = '';
			for(i=0;i<document_id;i++)
				{
					if(document.rapor.department_id_new.options[i].selected && document_name.length==0)
						document_name = document_name + list_getat(document.rapor.department_id_new.options[i].value,1,'-');
					else if(document.rapor.department_id_new.options[i].selected)
						document_name = document_name + ',' + list_getat(document.rapor.department_id_new.options[i].value,1,'-');
				}
			if(list_len(document_name,',') == 0)
			{
				alert("Lokasyon Bazında Rapor Alabilmek İçin Depo Seçmelisiniz !");
				return false;
			}
			if(list_len(document_name,',') > 1)
			{
				alert("Lokasyon Bazında Rapor Alırken Birden Fazla Depo Seçemezsiniz !");
				return false;
			}
		}

		if(!date_check(rapor.date,rapor.date2,"<cf_get_lang no ='1589.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  	
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else <cfif IsDefined("GET_ALL_STOCK") and GET_ALL_STOCK.recordcount> $('#maxrows').val('<cfoutput>#GET_ALL_STOCK.recordcount#</cfoutput>'); <cfelseif isdefined("GET_ALL_STOCK_ACTION.recordcount")>$('#maxrows').val('<cfoutput>#GET_ALL_STOCK_ACTION.recordcount#</cfoutput>');</cfif>
				
	}
	function control_report_type()
	{
		var temp_report_type=document.rapor.report_type.options[document.rapor.report_type.selectedIndex].value;
		if(document.rapor.display_ds_prod_cost.checked==true && list_find('3,4,5,6,9,10',temp_report_type))
		{
			alert("<cf_get_lang no ='1486.Birim Maliyet, Sadece Ürün ve Stok Bazında Raporlama Yapıldığında Seçilebilir'>!");
			document.rapor.display_ds_prod_cost.checked=false;
		}
		if(document.rapor.display_prod_volume.checked==true && list_find('3,4,5,6,9,10',temp_report_type))
		{
			alert("Hacim, Sadece Ürün ve Stok Bazında Raporlama Yapıldığında Seçilebilir!");
			document.rapor.display_prod_volume.checked=false;
		}
		if(document.rapor.report_type.value==7)
		{	
			document.getElementById('member_report_type1').style.display='none';
			document.getElementById('member_report_type2').style.display='';
			document.getElementById('project_id_').style.display='';
			document.getElementById('project_id_2').style.display='';
		}
		else
		{
			document.getElementById('member_report_type2').style.display='none';
			document.getElementById('member_report_type1').style.display='';
			document.getElementById('project_id_').style.display='none';
			document.getElementById('project_id_2').style.display='none';
		}
		if(!list_find('1,2,8,12',temp_report_type))
		{
			$('#stock_properties').css('display','none');
			$('#stock_age').val();
			$('#stock_rate').val();
			$('#stock_age').prop("checked", false);
			$('#stock_rate').prop("checked", false);
		}
		else
		{
			$('#stock_properties').css('display','block');
		}
		if(temp_report_type == 9 || temp_report_type == 10)
		{
			dept_id.style.display='none';
			dept_id2.style.display='';
		}
		else
		{
			dept_id.style.display='';
			dept_id2.style.display='none';
		}
	}
	function control_cost_money(cost_m)
	{
		if(cost_m != undefined)
			temp_cost_money = cost_m;
		else
			temp_cost_money = document.rapor.cost_money.options[document.rapor.cost_money.selectedIndex].value;
		if(document.rapor.is_system_money_2.checked==true)
		{
			if(document.rapor.display_cost.checked== true &&  temp_cost_money!= '<cfoutput>#session.ep.money#</cfoutput>')
			{
				alert("<cf_get_lang no ='1487.Sistem 2 Para Birimi Seçildiğinde Maliyet Para Birimi Olarak'><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang no ='1488.Seçilebilir'>");
				<cfif not listfind('1,2',attributes.is_excel)>
					<cfoutput query="get_money">
						<cfif #get_money.money# eq session.ep.money>
							document.rapor.cost_money.selectedIndex = #get_money.currentrow-1#;
						</cfif>
					</cfoutput>
				</cfif>
			}
		}
	}
</script>

<!-- sil -->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">