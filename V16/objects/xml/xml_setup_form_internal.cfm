<cfsetting showdebugoutput="no">
<cfparam name="attributes.friendly_url" default="">
<!--- XML --->
<cfoutput>
	<cfset f_sayac = 0>
	<cfquery name="PAGE_XML_PROPERTY" datasource="#DSN#">
		SELECT 
			PROPERTY_VALUE,
			PROPERTY_NAME
		FROM
			FUSEACTION_PROPERTY
		WHERE
			OUR_COMPANY_ID = #attributes.our_comp_id# AND
			(
				<cfif isdefined("attributes.friendly_url") and len(attributes.friendly_url)>
					<cfloop list="#attributes.friendly_url#" index="fuseactss">
						<cfset f_sayac = f_sayac+1>
						FRIENDLY_URL = '#fuseactss#' <cfif f_sayac lt ListLen(attributes.friendly_url,',')> OR</cfif>
					</cfloop>
				<cfelse>
					<cfloop list="#attributes.fuseact#" index="fuseactss">
						<cfset f_sayac = f_sayac+1>
						FUSEACTION_NAME = '#fuseactss#' <cfif f_sayac lt ListLen(attributes.fuseact,',')> OR</cfif>
					</cfloop>
				</cfif>
			)
	</cfquery>
	<cfset folder_name = "#index_folder##attributes._modul_name_##dir_seperator#xml#dir_seperator#">
	<!--- widget'sa --->
	<cfif isdefined("attributes.friendly_url") and len(attributes.friendly_url)>
		<cfquery name="get_widget_path" datasource="#DSN#">
			SELECT 
				XML_PATH
			FROM
				WRK_WIDGET
			WHERE
				WIDGET_FRIENDLY_NAME = '#attributes.friendly_url#' 
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.friendly_url") and len(attributes.friendly_url) and get_widget_path.recordcount gt 0 and len(get_widget_path.XML_PATH)>
		<cfset headers = '#getLang(application.objects[attributes.fuseact].DICTIONARY_ID)# XML Setup'>
		<cfset xml_setting_file_name = "#index_folder#..\#get_widget_path.XML_PATH#">
	<cfelseif StructKeyExists(application.objects, attributes.fuseact) and len(application.objects[attributes.fuseact].xml_path)>
		<cfset headers = '#getLang(application.objects[attributes.fuseact].DICTIONARY_ID)# XML Setup'>
		<cfset xml_setting_file_name = "#index_folder#..\#application.objects[attributes.fuseact].xml_path#">
	<cfelseif FileExists("#folder_name#faction_list.xml")>
		<cffile action="read" file="#folder_name#faction_list.xml" variable="xmldosyam" charset="UTF-8"><!--- İlk olarak belirtilen modül klasörünün altındaki faction_list.xml sayfası okunuyor. --->
		<cfscript>//bu blokta faction_list'de belirtilen LINK_FILE'daki dosya isimlerine göre hangisinin geçerli oluğunu bulucaz.
			dosyam = XmlParse(xmldosyam);
			xml_dizi =dosyam.SETUP_SITE.XmlChildren;
			d_boyut = ArrayLen(xml_dizi);
			for(xind=1;xind lte d_boyut;xind=xind+1){
				if(ListLen(dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText,'.') gt 1){//eğerki faction list dosyasındaki linki gösteren yerin uzunluğu varsa burayı döndürüyoruz ve belirtilen dosyayı okumaya çalışıyoruz.
					xml_file_link = dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText;
					for(xfi=1;xfi lte ListLen(xml_file_link,',');xfi=xfi+1){//link_file'ları burda döndürüyoruz ve belirtilen sayfaya ait bir kayıt varmı ona erişmeye çalışıyoruz.
						if(attributes.fuseact is ListGetAt(xml_file_link,xfi,',')){//eğerki link_file'da dosyamız bulunur ise link_file'in içinde virgüllü olarak 1den fazla xml sayfa ismi olabileceğininden her zaman ilk ismi alıcaz.çünkü standart olarak XML klasörünün içine her zaman LINK_FLE'IN içine yazılan ilk dosya adını alıcaz.
							attributes.fuseact ='#ListFirst(xml_file_link,',')#';
							xml_setting_file_name = '#folder_name##ListLast(ListFirst(xml_file_link,','),'.')#.xml';//burda faction list içinde belirttiğmiz ilgili sayfa ile ilgili değerleri tutan sayfanın adını aldık.Eğer bu değişken tanımlı değil ise yada boş ise,sayfaya ait bir xml sayfası oluşturulmamıştır.
							headers = '#dosyam.SETUP_SITE.SETUPSITE[xind].LINK_NAME.XmlText#';
						}	
					}
				}
			}
		</cfscript>
	</cfif>
	<cfif isdefined("xml_setting_file_name") and len(xml_setting_file_name)><!---Faction List'de bir dosya ismi tanımlanmış mı veya Faction List'de bulduğumuz dosya adı ile kaydedilmiş bir XML dosyası varmı... --->
		<cfif FileExists("#xml_setting_file_name#")>
			<cffile action="read" file="#xml_setting_file_name#" variable="newxmldosyam" charset="UTF-8">
			<cfscript>
				new_dosyam = XmlParse(newxmldosyam);
				new_xml_dizi =new_dosyam.OBJECT_PROPERTIES.XmlChildren;
				new_dizi_boyut = ArrayLen(new_xml_dizi);
				xml_property_event = XmlSearch(new_dosyam,"/OBJECT_PROPERTIES/OBJECT_PROPERTY/PROPERTY_EVENT");
			</cfscript>
			<cf_seperator id="xml_setup_form" title="#headers#">
			<cfform name="xml_setup_form" id="xml_setup_form" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_xml_setup">
				<cfinput type="hidden" name="fuseact_" id="fuseact_" value="#attributes.fuseaction#&fuseact=#attributes.fuseact#">
				<cfinput type="hidden" name="our_company_id" id="our_company_id" value="#attributes.our_comp_id#">
				<input type="hidden" name="page_fuseaction" id="page_fuseaction" value="#attributes.fuseact#"><!--- Hangi Sayfadan Geldiğini Tutuyor. --->
				
				<input type="hidden" id="is_upd" name="is_upd" value="#page_xml_property.recordcount?1:0#"><!--- Eğer bu query'den sonuç dönüyorsa update sayfasıdır --->
				<input type="hidden" id="friendly_url" name="friendly_url" value="#attributes.friendly_url#"><!--- Eğer bu query'den sonuç dönüyorsa update sayfasıdır --->
				<cfset ozellik_sayisi = 0>
				<div class="row">
					<div class="col col-12 col-md-12" id="SHOW_ROWS">
						<cf_flat_list> 
							<tbody>
								<cfloop index="i" from="1" to="#new_dizi_boyut#">
									<cfif ArrayLen(xml_property_event) gt 0 and ListFind('#new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_EVENT.XmlText#','#attributes.event#') or (ArrayLen(xml_property_event) eq 0)>
										<cfset type = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_TYPE.XmlText>
										<cfset ozellik_sayisi = ozellik_sayisi + 1>
										<cfset aciklama = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_DETAIL.XmlText>
										<cfset ozellik_ad = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY.XmlText>
										<cfset varsayilan = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_DEFAULT.XmlText>
										<cfset yardim = Replace(new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_HELP.XmlText,'"',"'",'all')>
										
										<cfif arrayLen(XmlSearch(new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i],"DEFINITION_LINK")) gt 0>
											<cfset defination_link = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].DEFINITION_LINK.XmlText>
										<cfelse>
											<cfset defination_link = ''>
										</cfif>
										<cfif PAGE_XML_PROPERTY.recordcount>
											<cfquery name="_PAGE_XML_PROPERTY_" dbtype="query">
												SELECT PROPERTY_VALUE FROM PAGE_XML_PROPERTY WHERE PROPERTY_NAME = '#ozellik_ad#'
											</cfquery>
											<cfif _PAGE_XML_PROPERTY_.recordcount>
												<cfset varsayilan = _PAGE_XML_PROPERTY_.PROPERTY_VALUE>
											</cfif>
										</cfif>
										<cfset degerler = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_VALUES.XmlText>
										<cfset degerler_isimler = new_dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_NAMES.XmlText>
										<tr title="* #yardim#">
											<td id="xml_help#ozellik_sayisi#">#ozellik_sayisi# - #aciklama#</td>
											<td>
												<input type="hidden" id="property_name_#ozellik_sayisi#" name="property_name_#ozellik_sayisi#" value="#ozellik_ad#">
												<cfif type is 'select'>
													<div class="form-group" id="property_#ozellik_sayisi#">
														<select name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#">
															<cfset sira_ = 0>
															<cfloop list="#degerler#" index="k">
																<cfset sira_ = sira_ + 1>
																<option value="#k#" <cfif k is '#varsayilan#'>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
															</cfloop>
														</select>
													</div>
													<cfelseif type is 'input'>
													<div class="form-group" id="property_#ozellik_sayisi#">
														<cfif len(defination_link)>
															<div class="input-group">
																<input type="text" name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#" value="#varsayilan#" style="width:65px;text-align:right;" onKeyPress="if(event.keyCode==13) {AjaxFormSubmit('xml_setup', 'SHOW_INFO',1,'Kaydediliyor','Kaydedildi'); return false;}">
																<span class="icon-ellipsis btnPointer input-group-addon"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=#defination_link#&field_id=xml_setup_form.property_#ozellik_sayisi#&from_xml=1</cfoutput>')"></span> 
															</div>
														<cfelse>
															<input type="text" name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#" value="#varsayilan#" style="width:65px;text-align:right;" onKeyPress="if(event.keyCode==13) {AjaxFormSubmit('xml_setup', 'SHOW_INFO',1,'Kaydediliyor','Kaydedildi'); return false;}">
														</cfif>
													</div>
													<cfelseif type is 'textarea'>
													<div class="form-group" id="property_#ozellik_sayisi#">
														<textarea name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#" style="width:200px;height:80px;">#varsayilan#</textarea>
													</div>
													<cfelseif type is 'multi'>
													<div class="form-group" id="property_#ozellik_sayisi#">
														<select name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" multiple="multiple" style="width:150px;height:70px;">
															<cfset sira_ = 0>
															<cfloop list="#degerler#" index="k">
																<cfset sira_ = sira_ + 1>
																<option value="#k#" <cfif k is '#varsayilan#'>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
															</cfloop>
														</select>
													</div>
												</cfif>
											</td>
											<!--- <div class="wrkPageLine col col-12 form-inline"> 
												<div class="col col-6 col-md-12" style="text-align:right; padding-bottom: 5px;">
													<input type="hidden" id="property_name_#ozellik_sayisi#" name="property_name_#ozellik_sayisi#" value="#ozellik_ad#">
													<cfif type is 'select'>
														<div class="form-group" id="property_#ozellik_sayisi#">
															<select name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#">
																<cfset sira_ = 0>
																<cfloop list="#degerler#" index="k">
																	<cfset sira_ = sira_ + 1>
																	<option value="#k#" <cfif k is '#varsayilan#'>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
																</cfloop>
															</select>
														</div>
														<cfelseif type is 'input'>
														<div class="form-group" id="property_#ozellik_sayisi#">
															<input type="text" name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#" value="#varsayilan#" style="width:65px;text-align:right;" onKeyPress="if(event.keyCode==13) {AjaxFormSubmit('xml_setup', 'SHOW_INFO',1,'Kaydediliyor','Kaydedildi'); return false;}">
														</div>
														<cfelseif type is 'textarea'>
														<div class="form-group" id="property_#ozellik_sayisi#">
															<textarea name="property_#ozellik_sayisi#"  id="property_#ozellik_sayisi#" style="width:200px;height:80px;">#varsayilan#</textarea>
														</div>
														<cfelseif type is 'multi'>
														<div class="form-group" id="property_#ozellik_sayisi#">
															<select name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" multiple="multiple" style="width:150px;height:70px;">
																<cfset sira_ = 0>
																<cfloop list="#degerler#" index="k">
																	<cfset sira_ = sira_ + 1>
																	<option value="#k#" <cfif k is '#varsayilan#'>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
																</cfloop>
															</select>
														</div>
													</cfif>
												</div>
											</div> --->
										</tr>	
									</cfif>	
								</cfloop>
								<input type="hidden" name="record_num" id="record_num" value="#ozellik_sayisi#"><!--- ÖZellik Sayısı --->
							</tbody>
						</cf_flat_list>
					</div>
				</div>	
				<div class="row">
					<div class="col col-6">
						<cfquery name="GET_PROPERTY" datasource="#DSN#">
							SELECT UPDATE_EMP, UPDATE_DATE FROM FUSEACTION_PROPERTY WHERE FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseact#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						</cfquery>
						<cfif isdefined("attributes.fuseact")>
							<cfif len(get_property.update_emp)>
								<div class="record_info">
									<i class="fa fa-pencil"></i> <cfoutput>#get_emp_info(get_property.update_emp,0,0)# - #dateformat(dateadd('h',session.ep.time_zone,get_property.update_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,get_property.update_date),timeformat_style)#</cfoutput>
								</div>
							</cfif>
						</cfif>
					</div>
					<div class="col col-6" style="text-align:right;">
						<input type="button" value="#getLang(49,'Kaydet',57461)#" onclick="fillArray();" />
					</div>
				</div>
			</cfform>
		<cfelse>
			<cf_seperator id="xml_setup_form" title="XML">
			<div id="xml_setup_form"><cf_get_lang dictionary_id="32771.Bu Sayfa İçin XML Tanımı Yapılmamış Yada Faction List  içindeki LINK FILE Adı Hatalı"></div>
		</cfif>
	<cfelse>
		<cf_seperator id="xml_setup_form" title="XML">
			<div id="xml_setup_form"><cf_get_lang dictionary_id="33095.Belirttiğiniz Modül Xml Dosyası Tanımlanmamış">!</div>
	</cfif>
</cfoutput>
<!--- XML --->

<!--- İşlem Kategorileri --->
<cf_seperator id="process_cat" title="#getLang('','',40079)#">
<cfset dsn_company = "#dsn#_#attributes.our_comp_id#" />
<cfquery name="GET_PROCESS_CATS" datasource="#dsn_company#">
	SELECT 
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.PROCESS_MODULE,				
		SPC.IS_CARI,
		SPC.IS_ACCOUNT,
		SPC.IS_BUDGET,
		SPC.IS_COST,
		SPC.IS_STOCK_ACTION,
		SPC.IS_PAYMETHOD_BASED_CARI,
		SPC.IS_EXP_BASED_ACC,
		SPC.IS_PARTNER,
		SPC.IS_PUBLIC,
		SPC.IS_ROW_PROJECT_BASED_CARI,
		SPC.SPECIAL_CODE,
		SPC.RECORD_DATE,
		SPC.RECORD_IP,
		SPC.RECORD_EMP,
		SPC.INVOICE_TYPE_CODE,
		SPC.PROFILE_ID, 
		M.MODULE_NAME,
		CASE WHEN ACDT.DOCUMENT_TYPE_ID < 0 THEN ACDT.DETAIL
		ELSE ACDT.DOCUMENT_TYPE
		END AS DOCUMENT_TYPE,
		ACPT.PAYMENT_TYPE
	FROM 
		SETUP_PROCESS_CAT SPC
		LEFT JOIN #dsn#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = SPC.DOCUMENT_TYPE
		LEFT JOIN #dsn#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = SPC.PAYMENT_TYPE,
		#dsn#.MODULES M,
		#dsn#.WRK_OBJECTS OBJ
	WHERE
		SPC.PROCESS_MODULE = M.MODULE_ID
		AND M.MODUL_NO = OBJ.MODULE_NO
		AND OBJ.FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseact#">
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<cf_flat_list id="process_cat">
	<thead>
		<tr>
			<th></th>
			<th><cf_get_lang dictionary_id='42382.İşlem Kategorisi'></th>
			<th><cf_get_lang dictionary_id='57692.İşlem'></th>
			<th><cf_get_lang dictionary_id='36742.Modül'></th>
		<cfif session.ep.our_company_info.is_efatura>
			<th><cf_get_lang dictionary_id="57441.Fatura "></th> 
			<th><cf_get_lang dictionary_id="59321.Senaryo"></th>
		</cfif>
			<th><cf_get_lang dictionary_id='58061.Cari'></th>
			<th><cf_get_lang dictionary_id='57447.Muhasebe'></th>
			<th><cf_get_lang dictionary_id='57559.Bütçe'></th>
			<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
			<th><cf_get_lang dictionary_id='43231.Stok Hareketi'></th>
			<th><cf_get_lang dictionary_id='58885.Partner'></th>
			<th><cf_get_lang dictionary_id='43232.Public'></th>
			<th><cf_get_lang dictionary_id='57468.Belge'></th>
			<th><cf_get_lang dictionary_id='30057.Ödeme Şekli'></th>
			<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_process_cats&event=add" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_process_cats.recordcount>

			<cfset process_sales_cost_list = "59,76,171,54,55,73,74,62,78,114,115,116,811,591,58,81,113,1131,63,48,50,49,51,110,761,592,1182"><!--- 761 hal irsaliyesi 592 hal fat. IS_COST--->
			<cfset process_stock_list = "171,52,53,54,55,59,62,64,65,66,69,690,591,592,531,532,70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,85,86,88,761,110,111,112,113,1131,114,115,116,140,141,120,122,118,1182"><!---IS_STOCK_ACTION--->

			<cfoutput query="GET_PROCESS_CATS"> 
				<tr>
					<td width="15">#currentrow#"</td>
					<td>
						<a href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#PROCESS_CAT_ID#" target="_blank">#PROCESS_CAT#</a>
					</td>
					<td>#PROCESS_TYPE#</td>
					<td>#MODULE_NAME#</td>
				<cfif session.ep.our_company_info.is_efatura>
					<td>#INVOICE_TYPE_CODE#</td>
					<td>#PROFILE_ID#</td>
				</cfif>
					<td style="text-align:center;"><cfif IS_CARI eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
					<td style="text-align:center;"><cfif IS_ACCOUNT eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
					<td style="text-align:center;"><cfif IS_BUDGET eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
					<td style="text-align:center;"><cfif listfind(process_sales_cost_list,get_process_cats.process_type)><cfif IS_COST eq 1><i class="icon-circle" style="color:##44b6ae"></b></cfif></cfif></td>
					<td style="text-align:center;"><cfif listfind(process_stock_list,get_process_cats.process_type)><cfif IS_STOCK_ACTION eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></cfif></td>
					<td style="text-align:center;"><cfif IS_PARTNER eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
					<td style="text-align:center;"><cfif IS_PUBLIC eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
					<td>#DOCUMENT_TYPE#</td>
					<td>#PAYMENT_TYPE#</td>
					<td>
						<a href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#PROCESS_CAT_ID#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
					</td>
				</tr>
				<tr class="table_detail" id="items_#currentrow#">
					<td colspan="16">
						<div id="display_process_info#currentrow#"></div>
					</td>
				</tr>
				<!-- sil --> 
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
<!--- İşlem Kategorileri --->

<!--- Süreçler --->
<cf_seperator id="process_rows" title="#getLang('','',32509)#">
<cfset get_queries = createObject("component","V16.process.cfc.qpic_r_main_list")>
<cfset get_process_type = get_queries.get_process_type( keyword: attributes.fuseact, is_active: 1, company_id: attributes.our_comp_id, get_pro_id_recordcount: 0 , friendly_url : attributes.friendly_url) />
<cfif get_process_type.recordcount>
	<cfset list_process=ListSort(listDeleteDuplicates(Valuelist(GET_PROCESS_TYPE.PROCESS_ID,',')),"numeric","asc",",")>
</cfif>
<cf_grid_list id="process_rows">
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58859.Süreç'></th>
			<th width="20"><a href="javascript://"><i class="fa fa-quora"></i></a></th>
			<th><cf_get_lang dictionary_id='36202.Aşamalar'></th>
			<th width="20"><a href="javascript://"><i class="fa fa-support"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_process_type.recordcount>
			<cfoutput query="get_process_type">   
				<cfset GET_CONTENTS=get_queries.get_contents(process_id:PROCESS_ID)>
				<cfset GET_STAGES=get_queries.get_stages(process_id:PROCESS_ID)>
				<tr>
					<td>#currentrow#</td>
					<td>
						<a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#" target="_blank">#process_name#</a></br>
						<cfif len(get_process_type.detail)><p><small>(#detail#)</small></p></cfif>
						<cfif len(get_process_type.MAIN_ACTION_FILE) or len(get_process_type.MAIN_FILE)>
							<div class="ui-form-list-btn flex-start">
								<div><cfif len(get_process_type.MAIN_ACTION_FILE)><a href="javascript://"><i class="fa fa-shield" style="color:##7518da!important"></i></a></cfif></div>
								<div><cfif len(get_process_type.MAIN_FILE)><a href="javascript://"><i class="fa fa-rocket" style="color:##e25757!important"></i></a></cfif></div>
							</div>
						</cfif>
					</td>
					<td><a <cfif get_contents.recordCount>href="#request.self#?fuseaction=rule.dsp_rule&cntid=#GET_CONTENTS.CONTENT_ID#&faction=#process_id#"<cfelse>href="javascript://" onclick="nocontents();"</cfif>><i class="fa fa-folder" style="color:##369cf3!important"></i></a></td>
					<td>
						<div style="display:flex;">
							<cfloop query="get_stages">
								<cfset makerCount=0>
								<cfset GET_ALL_GROUPS=get_queries.GET_ALL_GROUPS(process_row_id:GET_STAGES.PROCESS_ROW_ID)>
								<cfset workgroup_id=GET_ALL_GROUPS.workgroup_id> 
								<cfif len(GET_STAGES.PROCESS_ROW_ID)>
									<cfif GET_STAGES.is_employee eq 1>
										<cfsavecontent  variable="users"><cf_get_lang dictionary_id="59523.Tüm Kullanıcılar"></cfsavecontent>
										<cfset makerCount="#users#">
									<cfelseif len(workgroup_id)>
										<cfquery name="GET_ALL_GROUPS" datasource="#DSN#">
											SELECT * FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#GET_STAGES.PROCESS_ROW_ID#">
										</cfquery>
										
										<cfloop query="GET_ALL_GROUPS">
											<cfset makerCount=makerCount+get_queries.GET_PRO(workgroup_id:workgroup_id)>
										</cfloop>
									</cfif>
								</cfif>  
								<cfif get_stages.line_number eq 1>
									<cfset style="background-color:rgba(93,120,255,.1);color:##5d78ff;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##5d78ff!important;">
								<cfelseif  get_stages.line_number eq 2>
									<cfset style="background-color:rgba(255,184,34,.1);color:##ffb822;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##ffb822!important;">
								<cfelseif  get_stages.line_number eq 3>
									<cfset style="background-color:rgba(10,187,135,.1);color:##0abb87;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##0abb87!important;">
								<cfelseif  get_stages.line_number eq 4>
									<cfset style="background-color:rgba(253,57,122,.1);color:##fd397a;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##fd397a!important;">
								<cfelseif  get_stages.line_number eq 5>
									<cfset style="background-color:rgba(147,112,210,.1);;color:##673ab7;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##673ab7!important;">
								<cfelse>
									<cfset style="background-color:rgba(112,219,232,0.1);;color:##0d99d8;margin-right:10px;padding:5px 10px;cursor:pointer">
									<cfset icon_color="color:##0d99d8!important;">
								</cfif>
								<span class="ui-stage" style="#style#">
								<a href="#request.self#?fuseaction=process.form_add_process_rows&event=upd&process_id=#get_process_type.process_id#&process_row_id=#GET_STAGES.process_row_id#&process_name=#get_process_type.process_name#" style="#icon_color#" target="_blank">#stage#</a>
									<div class="margin-top-5">
										<small>#GET_STAGES.detail#</small>
										<a href="javascript://" onclick="window.open('index.cfm?fuseaction=objects.chatflow&tab=1&subtab=2','Workflow');"><i class="fa fa-comments" style="#icon_color#"></i></a>
										<a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=process.form_upd_process_rows&action_name=process_id&action_id=#process_id#','Workflow')"><i class="fa fa-bell" style="#icon_color#"></i></a>
										<cfif (GET_STAGES.IS_ONLINE  eq 1) or (GET_STAGES.IS_WARNING eq 1) or ( GET_STAGES.IS_EMAIL eq 1)>
											<a href="javascript://"><i class="fa fa-envelope-o" style="#icon_color#"></i></a>
										</cfif>
										<cfif GET_STAGES.CONFIRM_REQUEST eq 1>
											<a href="javascript://"><i class="fa fa-thumbs-up" style="#icon_color#"></i></a>
										</cfif>
										<a href="javascript://"><i class="catalyst-users" style="#icon_color#"><small>#makerCount#</small></i></a>
										<cfif len(GET_STAGES.display_file_name)><a href="javascript://"><i class="fa fa-shield" style="#icon_color#"></i></a></cfif>
											<cfif len(GET_STAGES.file_name)><a href="javascript://"><i class="fa fa-rocket" style="#icon_color#"></i></a></cfif>
									</div>
								</span>
								
								<!--- <cfif currentrow lt get_stages.recordcount><div style="display:flex; align-items:center; margin:0 5px;"><a href="javascript://"><i class="fa fa-caret-right" style="color:##4472b6!important; font-size:26px!important" ></i></a> </div></cfif> --->
							</cfloop>
						</div>
					</td>
					<td><a href="https://wiki.workcube.com/?keyword=#PROCESS_NAME#" target="_blank"><i class="fa fa-support" style="color:##0abb87!important"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>  	
<!--- Süreçler --->

<!--- Setting --->
<cf_seperator id="parameters" title="#getLang('','',57435)#">
<cfquery name="GET_PARAMETERS" datasource="#dsn#">
	SELECT
		S4.ITEM_#uCase(session.ep.language)# AS OBJECT,
		W.FULL_FUSEACTION
	FROM 
		WRK_OBJECTS AS W 
		LEFT JOIN SETUP_LANGUAGE_TR AS S4 ON S4.DICTIONARY_ID = W.DICTIONARY_ID 
		LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO 
	WHERE 
		W.TYPE IN (1,2,9) AND 
		W.IS_ACTIVE = 1 AND
		W.DICTIONARY_ID IS NOT NULL AND
		W.MODULE_NO = ( SELECT MODULE_NO FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseact#"> )
	ORDER BY 
		S4.ITEM_TR,
		W.RANK_NUMBER
</cfquery>
<cf_flat_list id="parameters">
	<tbody>
		<cfif GET_PARAMETERS.recordcount>
			<cfoutput query="GET_PARAMETERS"> 
				<tr>
					<td><a href="#request.self#?fuseaction=#FULL_FUSEACTION#" target="_blank">#OBJECT#</a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr><td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td></tr>
		</cfif>
	</tbody>
</cf_flat_list>
<!--- Setting --->

<!--- Output Templates --->
<cf_seperator id="templates" title="#getLang('','',42205)#">
<cfset getComponent = createObject('component','WDO.development.cfc.output_template')>
<cfset GET_TEMPLATES = getComponent.get_output_templates(related_wo:attributes.fuseact)>

<cf_flat_list id="templates">
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='44592.İsim'></th>
			<th><cf_get_lang dictionary_id='42197.Lisans'></th>
			<th><cf_get_lang dictionary_id='51038.Best Practice'></th>
			<th width="20"><a href="javascript://"><i class="fa fa-file-image-o"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_TEMPLATES.recordcount>
			<cfoutput query="GET_TEMPLATES"> 
				<tr>
					<td>#WRK_OUTPUT_TEMPLATE_NAME#</td>
					<td><cfif licence_type eq 1><cf_get_lang dictionary_id='33137.Standart'><cfelse><cf_get_lang dictionary_id='60146.Add-On'></cfif></td>
					<td>#BEST_PRACTISE_CODE#</td>
					<td><a href="javascript://" onclick="windowopen('#OUTPUT_TEMPLATE_VIEW_PATH#','page');"><i class="fa fa-file-image-o"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr><td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td></tr>
		</cfif>
	</tbody>
</cf_flat_list>
<!--- Output Templates --->