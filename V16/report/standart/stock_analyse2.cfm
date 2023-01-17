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
<cfif attributes.is_excel eq 0> <!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
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
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
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
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID,
		SL.COMMENT
</cfquery>
					
<cfset branch_dep_list=valuelist(get_department.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfif listlen(branch_dep_list,',') eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1484.Departman ve Lokasyon Yetkilerinizi Kontrol Ediniz'>!");
	</script>
	<cfabort>
</cfif>
<cfif session.ep.isBranchAuthorization><cfset is_store=1><cfelse><cfset is_store=0></cfif><!--- şube modülü kontrolü --->
<cfset page_totals = arraynew(2)>
<cfset RECORDCOUNT.recct = 0>
<cfinclude template="../query/get_stock_analyse2.cfm"> <!--- tum queryler ve sayfada listelenen degiskenler bu include da. --->
<table width="98%" height="250" border="0" align="center" cellpadding="0" cellspacing="0" <cfif isdefined('attributes.ajax')>style="display:none;"</cfif>>
<!-- sil -->
<tr height="35" >
	<td class="headbold"><a href="javascript:gizle_goster(search);">&raquo;<cf_get_lang_main no='606.Stok Analiz'></a></td>
	<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
</tr>
<!-- sil -->
<tr>
	<td valign="top"  colspan="2">
		<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
		<!-- sil --> 
		<tr id="search">
			<td class="color-row" height="100" valign="top">
				<table border="0">
				<cfform name="rapor" action="#request.self#?fuseaction=#fusebox.Circuit#.stock_analyse2" method="post">
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
				
					<tr valign="top">
						<td width="70" valign="top"><cf_get_lang no ='370.Kategori'></td>
						<td width="150" valign="top" height="1%">
							<input type="hidden" name="product_code" id="product_code" value="<cfif len(attributes.product_cat) and len(attributes.product_code)><cfoutput>#attributes.product_code#</cfoutput></cfif>">
							<input type="text" name="product_cat" id="product_cat" style="width:135px;"  value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_code','','3','200');" autocomplete="off">
							<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.product_code&field_name=rapor.product_cat&keyword='+encodeURIComponent(document.rapor.product_cat.value));"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
						<td rowspan="3"><cf_get_lang_main no='1351.Depo'></td>
						<td rowspan="3" id="dept_id" <cfif attributes.report_type eq 9 or attributes.report_type eq 10>style="display:none;"</cfif>>
							<!--- departman veya lokasyon pasifse ilgili bolumun rengi değiştiriliyor --->
							<select name="department_id" multiple style="width:175px; height:75px;">
								<cfoutput query="get_department" group="DEPARTMENT_ID">
									<optgroup label="#department_head#" <cfif DEPARTMENT_STATUS neq 1>style="color:FF0000"</cfif>>
									<cfoutput>
										<option <cfif status neq 1>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif listfind(attributes.department_id,'#department_id#-#location_id#',',')>selected</cfif>>&nbsp;&nbsp;#comment#</option>
									</cfoutput>
									</optgroup>					  
								</cfoutput>
							</select>				
						</td>
                        <td rowspan="3" id="dept_id2" <cfif attributes.report_type neq 9 and attributes.report_type neq 10>style="display:none;"</cfif>>
							<!--- departman veya lokasyon pasifse ilgili bolumun rengi değiştiriliyor --->
							<select name="department_id_new" multiple style="width:175px; height:75px;">
								<cfoutput query="get_department">
									<option value="#department_id#" <cfif listfind(attributes.department_id_new,department_id,',')>selected</cfif>>&nbsp;&nbsp;#department_head#</option>
								</cfoutput>
							</select>				
						</td>
						<td width="70"><cf_get_lang no='16.Stok Durum'></td>
						<td><select name="control_total_stock" style="width:175px;" >
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="0" <cfif attributes.control_total_stock eq 0>selected</cfif>><cf_get_lang no='1438.Sıfır Stok'></option>
                                <option value="1" <cfif attributes.control_total_stock eq 1>selected</cfif>><cf_get_lang no ='1046.Pozitif Stok'></option>
                                <option value="2" <cfif attributes.control_total_stock eq 2>selected</cfif>><cf_get_lang no ='1047.Negatif Stok'></option>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no ='245.Ürün'></td>
						<td>
							<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name) and len(attributes.product_id)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
							<input type="text" name="product_name" id="product_name" style="width:135px;" value="<cfoutput>#attributes.product_name#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&product_id=rapor.product_id&field_name=rapor.product_name&keyword='+encodeURIComponent(document.rapor.product_name.value),'list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</td>
						<td><cf_get_lang_main no='344. Durum'></td>
						<td>
							<select name="product_status" style="width:175px;">
								<option value="" <cfif attributes.product_status eq ''>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
								<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
								<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
							</select>
						</td>
					</tr>
					<tr>
						<cfoutput>
						  <td width="70" valign="top"><cf_get_lang_main no='1736.Tedarikçi'></td>
						  <td valign="top">
							<input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif len(attributes.sup_company)>#attributes.sup_company_id#</cfif>">
							<input type="text" name="sup_company" id="sup_company" style="width:135px;" value="<cfif len(attributes.sup_company)>#attributes.sup_company#</cfif>" onFocus="AutoComplete_Create('sup_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','sup_company_id','','3','250');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_comp_name=rapor.sup_company&field_comp_id=rapor.sup_company_id&select_list=2&keyword='+encodeURIComponent(document.rapor.sup_company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						  </td>
							<td><cf_get_lang_main no='1548.Rapor Tipi'></td>
							<td>
								<select name="report_type" style="width:175px;"  onChange="control_report_type();">
									<option value="1" <cfif attributes.report_type eq 1> selected</cfif>><cf_get_lang no ='333.Stok Bazında'></option>
									<option value="2" <cfif attributes.report_type eq 2> selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
									<option value="3" <cfif attributes.report_type eq 3> selected</cfif>><cf_get_lang no ='331.Kategori Bazında'></option>
									<option value="4" <cfif attributes.report_type eq 4> selected</cfif>><cf_get_lang no ='373.Sorumlu Bazında'></option>
									<option value="5" <cfif attributes.report_type eq 5> selected</cfif>><cf_get_lang no ='374.Marka Bazında'></option>
									<option value="6" <cfif attributes.report_type eq 6> selected</cfif>><cf_get_lang no ='1043.Tedarikci Bazında'></option>
									<option value="7" <cfif attributes.report_type eq 7> selected</cfif>><cf_get_lang_main no='248.Belge Bazında'></option>
									<option value="8" <cfif attributes.report_type eq 8> selected</cfif>><cf_get_lang no ='1044.Spec Bazında'></option>
									<option value="9" <cfif attributes.report_type eq 9> selected</cfif>>Depo Bazında</option>
									<option value="10" <cfif attributes.report_type eq 10> selected</cfif>>Lokasyon Bazında</option>
								</select>
							</td>
						</cfoutput>
					</tr>
					<tr>
                    <cfoutput>
						<td><cf_get_lang_main no='1036.Ürün Sorumlusu'></td>
						<td>
							<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name) and len(attributes.product_employee_id)>#attributes.product_employee_id#</cfif>">
							<input type="text" name="employee_name" id="employee_name" style="width:135px;" value="<cfif len(attributes.employee_name)>#attributes.employee_name#</cfif>" maxlength="255" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','product_employee_id','','3','135');" autocomplete="off">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=rapor.product_employee_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9&keyword='+encodeURIComponent(document.rapor.employee_name.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
						<td width="71" rowspan="3" valign="top"><cf_get_lang_main no='388.İşlem Tipi'></td>
                        <td width="175" rowspan="2" valign="top" id="member_report_type1" <cfif attributes.report_type eq 7>style="display:none"</cfif>>
                            <cfquery name="GET_ALL_PROCESS_TYPES" datasource="#dsn3#">
                                SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (110,111,112,119) ORDER BY PROCESS_TYPE
                            </cfquery>
                            <select name="process_type_detail" style="width:175px; height:75px;" multiple>
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
                                            <option value="5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id[tt]#" <cfif listfind(attributes.process_type_detail,'5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id[tt]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat_2.process_cat[tt]#</option>
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
                            </select>
                           </td>
					    </cfoutput>
                        <td width="175" rowspan="2" valign="top" id="member_report_type2" <cfif attributes.report_type neq 7>style="display:none"</cfif>>
                         	<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                                SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
                            </cfquery>
                            <select name="process_type_detail" style="width:175px; height:75px;" multiple>
								<cfoutput query="get_process_cat" group="process_type">
                                    <option value="0-#process_type#" <cfif listfind(attributes.process_type_detail,'0-#process_type#')> selected</cfif>>#get_process_name(process_type)#</option>										
                                    <cfoutput>
                                    <option value="#currentrow#-#process_type#" <cfif listfind(attributes.process_type_detail,'#currentrow#-#process_type#')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                    </cfoutput>
                                </cfoutput>
							</select>
                        </td>
                      	<td><cf_get_lang no='624.Dosya Tipi'></td>
						<td>
							<cfoutput>
								<select name="is_excel" style="width:175px;" >
									<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
									<option value="1" <cfif attributes.is_excel eq 1>selected</cfif>><cf_get_lang_main no='446.Excel Getir'></option>
									<option value="2" <cfif attributes.is_excel eq 2>selected</cfif>>CSV <cf_get_lang_main no='1188.Dosya Oluştur'></option>
								</select>




							</cfoutput>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='1435.Marka'></td>
						<td>
							<cfoutput>
								<input type="hidden" name="brand_id" id="brand_id"  value="<cfif len(attributes.brand_name)>#attributes.brand_id#</cfif>">
								<input type="text" name="brand_name" id="brand_name" style="width:135px;" value="<cfif len(attributes.brand_name)>#attributes.brand_name#</cfif>" maxlength="255" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','135');" autocomplete="off">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_id=rapor.brand_id&brand_name=rapor.brand_name&keyword='+encodeURIComponent(document.rapor.brand_name.value),'small');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </cfoutput>
						</td>
						<td width="30" valign="top" height="1%"><cf_get_lang_main no='330.Tarih'></td>
						<td width="180" valign="top">
							<cfoutput>
								<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz !'></cfsavecontent>
								<cfinput value="#attributes.date#" type="text" name="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
								<cfif not isdefined('attributes.ajax')>
									<cf_wrk_date_image date_field="date"> /
								</cfif>
								<cfinput value="#attributes.date2#"  type="text" name="date2" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
								<cfif not isdefined('attributes.ajax')>
									<cf_wrk_date_image date_field="date2">
								</cfif>
							</cfoutput>
					    </td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6">
						<table>
							<tr>
                            <cfoutput>
								<td colspan="6">
									<input type="checkbox" name="display_cost" id="display_cost" onClick="control_cost_money()" value="1"<cfif isdefined('attributes.display_cost')>checked</cfif>>
									<cf_get_lang no ='365.Maliyet Göster'>
									<input type="checkbox" name="display_cost_money" id="display_cost_money" value="1"<cfif isdefined('attributes.display_cost_money')>checked</cfif>>
									İşlem Dövizli
									<cfquery name="get_money" datasource="#dsn#">
										SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
									</cfquery>
									<select name="cost_money" id="cost_money" style="width:100" onClick="control_cost_money(this.value)">
										<cfloop query="get_money">
										  <option value="#MONEY#" <cfif attributes.cost_money is MONEY>selected</cfif>>#MONEY#</option>
										</cfloop>
									</select>&nbsp;&nbsp;
									<input type="checkbox" name="location_based_cost" id="location_based_cost" value="1"<cfif isdefined('attributes.location_based_cost')>checked</cfif>>
									Lokasyon Bazında Maliyet
									<input type="checkbox" name="from_invoice_actions" id="from_invoice_actions" value="1" <cfif isdefined('attributes.from_invoice_actions')>checked</cfif>><cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'><cf_get_lang_main no='846.Maliyet'><cfelse><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'></cfif>&nbsp;&nbsp;<!---secildiginde alış-satıs ve iade faturalarının tutarları gosterilir --->
									<input type="checkbox" name="is_envantory" id="is_envantory" value="1" <cfif isdefined('attributes.is_envantory')>checked</cfif>><cf_get_lang no ='720.Envantere Dahil'>&nbsp;
									<cfif is_store eq 0><input type="checkbox" name="stock_age" id="stock_age" value="1" <cfif isdefined('attributes.stock_age')>checked</cfif>><cf_get_lang no ='426.Stok Yaşı'>&nbsp;</cfif>
									<input type="checkbox" name="display_ds_prod_cost" id="display_ds_prod_cost" onClick="control_report_type();" value="1"<cfif isdefined('attributes.display_ds_prod_cost')>checked</cfif>>&nbsp;<cf_get_lang no ='1447.Dönem Sonu Birim Maliyet'>&nbsp;
									<input type="checkbox" name="display_prod_volume" id="display_prod_volume" onClick="control_report_type();" value="1"<cfif isdefined('attributes.display_prod_volume')>checked</cfif>>&nbsp;<cf_get_lang_main no='2317.Hacim'> &nbsp;
									<select name="volume_unit" id="volume_unit" style="width:45px;">
										<option value="1" <cfif attributes.volume_unit eq 1>selected</cfif>>cm3</option>
										<option value="2" <cfif attributes.volume_unit eq 2>selected</cfif>>dm3</option>
										<option value="3" <cfif attributes.volume_unit eq 3>selected</cfif>>m3</option>
									</select>
							  </td>
                            </cfoutput>
							</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td colspan="6">
							<table>
								<tr>
									<cfoutput>
										<td colspan="6">
											<cfif len(session.ep.money2)><!---sistem 2.para birimi cinsinden maliyetleri getirir --->
												<input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" onClick="control_cost_money()" <cfif isdefined('attributes.is_system_money_2')>checked</cfif>><cf_get_lang no ='1444.Sistem 2 Para Br'>&nbsp;
											</cfif>
											<input type="checkbox" name="is_stock_action" id="is_stock_action" value="1"<cfif isdefined('attributes.is_stock_action')>checked</cfif>><cf_get_lang no ='1445.Hareket Görmeyen Ürünleri Getirme'> &nbsp;
											<cfif is_store eq 0>
												<input type="checkbox" name="is_belognto_institution" id="is_belognto_institution" value="1"<cfif isdefined('attributes.is_belognto_institution')>checked</cfif>>&nbsp;3.<cf_get_lang no ='1446.Parti Kurumlara Ait Lokasyonlardaki Hareketleri Getir'> &nbsp;
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
											<cfif session.ep.our_company_info.is_maxrows_control_off eq 0>
												<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
											<cfelse>
												<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="4" style="width:25px;">
											</cfif>
											<cf_get_lang_main no='1417.Kayıt Sayısı'>
											&nbsp;<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
											<cf_workcube_buttons add_function='degistir_action()' is_upd='0' is_cancel='0' insert_info='#message#' insert_alert=''>
										</td>
									</cfoutput>
								</tr>
							</table>
						</td>
					</tr>
				</cfform>
				</table>
			</td>
		</tr>
		 <!-- sil -->
    	</table>
	</td>
</tr>
</table>
<cfif listfind('1,2,8',attributes.report_type) and  isdefined("attributes.is_excel") and  attributes.is_excel eq 1 >
    <cfinclude template="/fbx_download.cfm">
    <cfif isdefined("attributes.is_form_submitted")>
        <script type="text/javascript">
             wrk_down_dosya_ver('<cfoutput>/documents/reserve_files/#drc_name_#/#file_name_#.xls</cfoutput>','1');
            //wrk_down_dosya_ver('<cfoutput>#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls</cfoutput>',1);
        </script>
    </cfif> 
<cfelse>
	<!-- sil --><cfif not listfind('1,2',attributes.is_excel)><div id="sepetim" style="width:99%;height:300px; z-index:1; overflow:auto;"></cfif><!-- sil -->
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
		<cfset type_ = 2>
	<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset type_ = 1>
    <cfelse>
		<cfset type_ = 0>
	</cfif>
	<cfif attributes.report_type eq 7><cfinclude template="detail_stock_row_list.cfm"></cfif>
	<cfif attributes.report_type neq 7><cfif not listfind('1,2',attributes.is_excel)><br/></cfif>
	<!--- // Display --->
		<!---<cf_wrk_html_table cellpadding="2"  cellspacing="1" border="0" class="color-border" width="98%" align="center" table_draw_type="#type_#" filename="stock_analyse#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cf_wrk_html_tr class="color-header" height="20">	
		<cfoutput>
           <cfif attributes.report_type eq 1><cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1><cfset report_type_colspan_= 7><cfelse><cfset report_type_colspan_= 6></cfif>
			<cfelseif attributes.report_type eq 2><cfset report_type_colspan_=5>
			<cfelseif attributes.report_type eq 8><cfset report_type_colspan_=7>
			<cfelse><cfset report_type_colspan_=1></cfif>
			<cf_wrk_html_td class="form-title" align="center" colspan="#report_type_colspan_#">
				<cf_get_lang_main no='1548.Rapor Tipi'>
			</cf_wrk_html_td>
			<cfif listfind('1,2,8',attributes.report_type)>
				<cfset db_colspan_no=1>
				<cfif isdefined('attributes.display_cost')>
					<cfset db_colspan_no = db_colspan_no+2>
					<cfif isdefined('attributes.is_system_money_2')>
						<cfset db_colspan_no = db_colspan_no+2>
					</cfif>
				</cfif>
				<cf_wrk_html_td class="form-title" align="center" colspan="#db_colspan_no#">
					<cf_get_lang_main no ='2099.Dönem Başı Stok'>
				</cf_wrk_html_td>
                <cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
					<cfset purchase_colspan_no=3>
					<cfif isdefined('attributes.display_cost')>
						<cfset purchase_colspan_no = purchase_colspan_no+6>
						<cfif isdefined('attributes.is_system_money_2')>
							<cfset purchase_colspan_no = purchase_colspan_no+6>
						</cfif>
					</cfif>
					<cf_wrk_html_td class="form-title" align="center" colspan="#purchase_colspan_no#">
						<cf_get_lang no ='381.Dönem İçi Alış'>
					</cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
					<cfset colspan_number = 3>
					<cfif isdefined('attributes.from_invoice_actions')>
						<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
							<cfset colspan_number = colspan_number+10>
						<cfelse>
							<cfset colspan_number = colspan_number+6>
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
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_number#">
						<cf_get_lang no ='382.Dönem İçi Satış'>
					</cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfset colspan_other=1>
				<cfif isdefined('attributes.display_cost')>
					<cfset colspan_other =colspan_other +2>
					<cfif isdefined('attributes.is_system_money_2')><cfset colspan_other =colspan_other +2></cfif>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1031.Dönem İçi Giden Konsinye'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1035.Dönem İçi İade Gelen Konsinye'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1733.Dönem İçi Konsinye Giriş'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1734.Dönem İçi Konsinye Giriş İade'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>	
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1036.Teknik Servisten Giren'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1037.Teknik Servisten Çıkan'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1041.RMA Giriş'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1040.RMA Çıkış'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='383.Dönem İçi Üretim'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other*3#"><cf_get_lang no ='384.Dönem İçi Sarf ve Fire'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
					<cf_wrk_html_td class="form-title" align="center"colspan="#colspan_other#"><cf_get_lang no ='385.Sayım'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang_main no='1024.Dönem İçi Demontajdan Giriş'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang no ='1039.Dönem İçi Demontaja Giden'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other#"><cf_get_lang_main no ='1409.Dönem İçi Masraf Fişleri'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1450.Dönem İçi Sevk İrsaliyeleri'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1451.Dönem İçi İthal Mal Girişi'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
					<cf_wrk_html_td class="form-title" align="center" colspan="#colspan_other*2#"><cf_get_lang no ='1452.Dönem İçi Ambar Fişleri'></cf_wrk_html_td>
					<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				</cfif>
			</cfif>
			<cfset ds_colspan_number=1>
			<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)><!--- stok,urun bazında birim ve dönem sonu toplam hacim --->
				<cfset ds_colspan_number=ds_colspan_number+2>
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
			<cf_wrk_html_td class="form-title" align="center" colspan="#ds_colspan_number#"><cf_get_lang_main no='2100.Dönem Sonu Stok'></cf_wrk_html_td>
			<cfif isdefined('attributes.stock_age')>
				<cf_wrk_html_td class="color-row" width="1"></cf_wrk_html_td>
				<cf_wrk_html_td class="form-title" nowrap="nowrap" align="center"><cf_get_lang no ='426.Stok Yaşı'></cf_wrk_html_td>
			</cfif>
		</cfoutput>
		</cf_wrk_html_tr>
        <cf_wrk_html_tr class="color-list" height="20">
		<cfoutput>
			<cfif listfind('1,8',attributes.report_type,',')>
				<cf_wrk_html_td class="txtboldblue"><cf_get_lang_main no ='106.Stok Kodu'></cf_wrk_html_td>
			</cfif>
			<cfif attributes.report_type eq 1>
				<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
					<cf_wrk_html_td class="txtboldblue" width="110"><cf_get_lang_main no='377.Özel Kod'></cf_wrk_html_td>
				</cfif>
			</cfif>
			<cf_wrk_html_td class="txtboldblue" width="130" nowrap="nowrap">
				<cfif attributes.report_type eq 1><cf_get_lang_main no='40.Stok'>
				<cfelseif attributes.report_type eq 2><cf_get_lang_main no ='245.Ürün'> 
				<cfelseif attributes.report_type eq 3><cf_get_lang_main no ='74.Kategori'>
				<cfelseif attributes.report_type eq 4><cf_get_lang_main no='132.Sorumlu'>
				<cfelseif attributes.report_type eq 5><cf_get_lang_main no='1435.Marka'>
				<cfelseif attributes.report_type eq 6><cf_get_lang no ='973.Tedarik'>
				<cfelseif attributes.report_type eq 8><cf_get_lang_main no='40.Stok'>
				<cfelseif attributes.report_type eq 9><cf_get_lang_main no='1351.Depo'>
				<cfelseif attributes.report_type eq 10><cf_get_lang_main no ='2234.Lokasyon'>
				</cfif>
			</cf_wrk_html_td>
			<cfif listfind('1,2,8',attributes.report_type)>
				<cf_wrk_html_td class="txtboldblue"><cf_get_lang_main no='221.Barkod'></cf_wrk_html_td>
			</cfif>
			<cfif attributes.report_type eq 8>
				<cf_wrk_html_td class="txtboldblue"><cf_get_lang no ='1952.Main Spec'></cf_wrk_html_td>
			</cfif>
            <cfif listfind('1,2,8',attributes.report_type)>
             	<cf_wrk_html_td class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no='1388.Ürün Kodu'></cf_wrk_html_td>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no ='222.Üretici Kodu'></cf_wrk_html_td>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap"><cf_get_lang_main no ='224.Birim'></cf_wrk_html_td>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='391.Stok Miktarı'></cf_wrk_html_td>
				<cfif isdefined('attributes.display_cost')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='1494.Stok Maliyeti'></cf_wrk_html_td>
					<cfif isdefined('attributes.is_system_money_2')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
					</cfif>
				</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='393.Alım Miktarı'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='394.Alım İade Miktarı'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='395.Net Alım Miktarı'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='396.Alım Tutar'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='397.Alım İade Tutarı'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='398.Net Alım Tutarı'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='396.Alım Tutar'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='397.Alım İade Tutarı'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='398.Net Alım Tutarı'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='2162.Satış Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='403.Satış İade Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='406.Net Satış Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.from_invoice_actions')><!--- faturadan hesapla secilmisse --->
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1457.Fatura Satış Miktar'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1458.Fatura Satış Tutar'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1458.Fatura Satış Tutar'></cf_wrk_html_td>
						</cfif>
						<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1953.Fatura Satış Maliyet'></cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1953.Fatura Satış Maliyet'></cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1459.Fatura Satış İade Miktar'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1460.Fatura Satış İade Tutar'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1460.Fatura Satış İade Tutar'></cf_wrk_html_td>
						</cfif>
						<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1953.Fatura Satış İade Maliyet'></cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1953.Fatura Satış İade Maliyet'></cf_wrk_html_td>
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='409.Satış Maliyeti'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='411.Satış İade Maliyeti'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='414.Net Satış Maliyeti'></cf_wrk_html_td>
						<cfif type_ eq 1>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1955.Net Fatura'><cf_get_lang no ='409.Satış Maliyeti'></cf_wrk_html_td>						
						<cfelse>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1955.Net Fatura'><br/><cf_get_lang no ='409.Satış Maliyeti'></cf_wrk_html_td>						
						</cfif>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='409.Satış Maliyeti'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='411.Satış İade Maliyeti'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='414.Net Satış Maliyeti'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1461.Konsinye Çıkış Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1462.Konsinye Çıkış Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1462.Konsinye Çıkış Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- iade gelen konsinye --->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1463.Konsinye İade Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1464.Konsinye İade Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							 <cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1464.Konsinye İade Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- konsinye giriş iade--->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1738.Konsinye Giriş Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1737.Konsinye Giriş Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1737.Konsinye Giriş Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- konsinye giriş iade--->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1736.Konsinye Giriş İade Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1735.Konsinye Giriş İade Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1735.Konsinye Giriş İade Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
					<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>				
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!---donemici uretim fişleri --->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='416.Üretim Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='417.Üretim Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='417.Üretim Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='419.Sarf Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1465.Üretim Sarf Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='420.Fire Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='421.Sarf Maliyet'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1466.Üretim Sarf Maliyet'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='422.Fire Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='421.Sarf Maliyet'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1466.Üretim Sarf Maliyet'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='422.Fire Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1467.Sayım Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
					<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- demontajdan giris --->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1468.Demontajdan Giriş '>#session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- demontaja giden --->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1469.Demontaja Giden'> #session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- masraf fişleri --->
				<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang_main no ='223.Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1042.Masraf Fişleri'> #session.ep.money2# <cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- depo sevk--->
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- ithal mal girişi--->
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
				<!--- ambar fişi --->
				<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1470.Stok Giriş Miktar'></cf_wrk_html_td>
					<cf_wrk_html_td class="txtboldblue" nowrap align="right"><cf_get_lang no ='1471.Stok Çıkış Miktar'></cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1472.Stok Giriş Maliyeti'></cf_wrk_html_td>
							<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2# <cf_get_lang no ='1473.Stok Çıkış Maliyeti'></cf_wrk_html_td>
						</cfif>
					</cfif>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				</cfif>
             </cfif>
			<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='391.Stok Miktar'></cf_wrk_html_td>
            <cfif isdefined('attributes.display_cost')>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang_main no='1494.Stok Maliyet'></cf_wrk_html_td>
				<cfif isdefined('attributes.is_system_money_2')>
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2">#session.ep.money2#<cf_get_lang_main no='846.Maliyet'></cf_wrk_html_td>
				</cfif>
				<cfif isdefined('attributes.display_ds_prod_cost')><!--- donem sonu stokta urun birim maliyetinin gosterilmesi secilmiş ise --->
					<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1483.Birim Maliyet'></cf_wrk_html_td>
					<cfif isdefined('attributes.is_system_money_2')>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right" colspan="2"><cf_get_lang no ='1483.Birim Maliyet'> (#session.ep.money2#)</cf_wrk_html_td>
					</cfif>
				</cfif>
			</cfif>
			<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1956.Birim Hacim'></cf_wrk_html_td>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='1957.Toplam Hacim'></cf_wrk_html_td>
			</cfif>
			<cfif isdefined('attributes.stock_age')>
				<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
				<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"><cf_get_lang no ='426.Stok Yaşı'></cf_wrk_html_td>
			</cfif>
		</cfoutput>
		</cf_wrk_html_tr>
        <cfscript>
			for(elemet_i=1;elemet_i lte 105; elemet_i=elemet_i+1) //102-103
				page_totals[1][#elemet_i#] = 0;
		</cfscript>
        <cfif .recordcount>
			<cfif listfind('3,4,5,6,9,10',attributes.report_type)>
				<cfoutput query="GET_PROD_CATS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cf_wrk_html_tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<cf_wrk_html_td nowrap="nowrap">
					<cfif attributes.report_type eq 6 and not listfind('1,2',attributes.is_excel)>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#product_groupby_id#','medium');" class="tableyazi">#ACIKLAMA#</a>
					<cfelseif attributes.report_type eq 4 and not listfind('1,2',attributes.is_excel)>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#product_groupby_id#','medium');" class="tableyazi">#ACIKLAMA#</a> 
					<cfelse>#replace(ACIKLAMA,";","","all")#</cfif>
					</cf_wrk_html_td>
					<cf_wrk_html_td align="right" format="numeric">
						<cfif isdefined("prod_cat_total_#PRODUCT_GROUPBY_ID#") and len(evaluate("prod_cat_total_#PRODUCT_GROUPBY_ID#"))>
							<cfset page_totals[1][1] = page_totals[1][1] + wrk_round(evaluate("prod_cat_total_#PRODUCT_GROUPBY_ID#"),4)><!--- donem sonu stok --->
							#TLFormat(evaluate("prod_cat_total_#PRODUCT_GROUPBY_ID#"),4)#
						</cfif>
					</cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td width="100" align="right" nowrap="nowrap" format="numeric">
							<cfset temp_groupby_id=GET_PROD_CATS.PRODUCT_GROUPBY_ID>
							<cfif isdefined('prod_cat_cost_#temp_groupby_id#') and evaluate('prod_cat_cost_#temp_groupby_id#') neq 0>
								<cfset page_totals[1][2] = page_totals[1][2] + (evaluate('prod_cat_cost_#temp_groupby_id#')/donem_sonu_kur)><!--- donem sonu maliyet --->
								#TLFormat((evaluate('prod_cat_cost_#temp_groupby_id#')/donem_sonu_kur))# 
							</cfif>
						</cf_wrk_html_td>
						<cf_wrk_html_td width="15" nowrap="nowrap">
							<cfif isdefined('prod_cat_cost_#temp_groupby_id#') and evaluate('prod_cat_cost_#temp_groupby_id#') neq 0>#attributes.cost_money#</cfif>
						</cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
						<cf_wrk_html_td  align="right" nowrap="nowrap" format="numeric">
							<cfif isdefined('prod_cat_cost2_#temp_groupby_id#') and evaluate('prod_cat_cost2_#temp_groupby_id#') neq 0>
								<cfset page_totals[1][63] = page_totals[1][63] + evaluate('prod_cat_cost2_#temp_groupby_id#')><!--- donem sonu maliyet2 --->
								#TLFormat(evaluate('prod_cat_cost2_#temp_groupby_id#'))# 
							</cfif>
						</cf_wrk_html_td>
						<cf_wrk_html_td width="15" nowrap="nowrap">
							<cfif isdefined('prod_cat_cost2_#temp_groupby_id#') and evaluate('prod_cat_cost2_#temp_groupby_id#') neq 0>#session.ep.money2#</cfif>
						</cf_wrk_html_td>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.stock_age')>
						<cfquery name="get_product_in_cat" dbtype="query">
							SELECT PRODUCT_ID FROM  WHERE PRODUCT_GROUPBY_ID =#GET_PROD_CATS.PRODUCT_GROUPBY_ID#
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
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
						<cf_wrk_html_td align="right" nowrap="nowrap" format="numeric">
							<cfif toplam_donem_sonu_stok gt 0>#TLFormat(agirlikli_toplam/toplam_donem_sonu_stok)#</cfif>
						</cf_wrk_html_td>
					</cfif>
				</cf_wrk_html_tr>
				</cfoutput>
			<cfelse>
                <cfif isdefined('attributes.ajax')>
					<cfoutput query="">
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
               		<cfif .query_count>
						<script type="text/javascript">
							<cfif isdefined('attributes.department_id') and len(attributes.department_id)><!--- lokasyonlara göre rapor çalıştırılıyorsa. --->
								<cfset function_code = '_#ListGetAt(attributes.department_id,1,'-')#_#ListGetAt(attributes.department_id,2,'-')#'>
								<cfoutput>user_info_show_div#function_code#(#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/.query_count)#</cfoutput>);
							<cfelse>
								//alert('<cfoutput>#attributes.maxrows#</cfoutput>');
								user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/.query_count)#</cfoutput>);
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
                            	PROCESS_FINISH_DATE = #NOW()#,PROCESS_ROW_COUNT = #.query_count#
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
						<cfset attributes.maxrows=.query_count>
                   </cfif>
			<cfoutput query="">
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
							if(isdefined('attributes.display_cost'))//donem sonu birim maliyet
							{
								//db_maliyet = produc_cost_func(cost_product_id:.PRODUCT_ID,cost_date:finish_date);
								ds_urun_birim_maliyet=(.ALL_FINISH_COST);
								if( isdefined('attributes.is_system_money_2') )
									ds_urun_birim_maliyet2=(.ALL_FINISH_COST_2);
							}
                        </cfscript>
						<cf_wrk_html_tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<cfif listfind('1,8',attributes.report_type,',')>
								<cf_wrk_html_td>
									#replace(.STOCK_CODE,";","","all")#
                                </cf_wrk_html_td>
                            </cfif>
							<cfif attributes.report_type eq 1>
								<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
									<cf_wrk_html_td>
										#stock_code_2#
									</cf_wrk_html_td>
								</cfif>
							</cfif>
                            <cf_wrk_html_td width="130" nowrap="nowrap">
                            <cfif listfind('1,8',attributes.report_type,',') and not listfind('1,2',attributes.is_excel)>
                                <a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi" target="_blank">#.ACIKLAMA#</a>
                            <cfelseif attributes.report_type eq 2 and not listfind('1,2',attributes.is_excel)>
                                <a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi" target="_blank">#.ACIKLAMA#</a>
                             <cfelse>
                               #replace(.ACIKLAMA,";","","all")#
                            </cfif>
                            </cf_wrk_html_td>
                            <cfif listfind('1,2,8',attributes.report_type)>					
                            	<cf_wrk_html_td>
							   		#replace(.BARCOD,";","","all")#
								</cf_wrk_html_td>
                            </cfif>
                            <cfif attributes.report_type eq 8>
								<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
									<cf_wrk_html_td>
										#.SPECT_VAR_ID#
										<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
										 - #.SPECT_NAME#
										</cfif>
									</cf_wrk_html_td>
								<cfelse>
									<cf_wrk_html_td align="right">
										#.SPECT_VAR_ID#
									</cf_wrk_html_td>
								</cfif>
                            </cfif>
                            <cfif listfind('1,2,8',attributes.report_type)>					
                                <cf_wrk_html_td>
									#replace(.PRODUCT_CODE,";","","all")#
								</cf_wrk_html_td>
                            </cfif>
                            <cf_wrk_html_td width="130" nowrap="nowrap">
								#replace(.MANUFACT_CODE,";","","all")#
							</cf_wrk_html_td>
                            <cf_wrk_html_td width="100" nowrap="nowrap">
								#replace(.MAIN_UNIT,";","","all")#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap="nowrap" format="numeric">
                                <cfif isdefined("DB_STOK_MIKTAR") and len(DB_STOK_MIKTAR)>
                                    <cfset page_totals[1][3] = page_totals[1][3] + wrk_round(DB_STOK_MIKTAR,4)><!--- donem bası stok --->
                                    <cfset donem_basi_stok = DB_STOK_MIKTAR>
                                    #TLFormat(DB_STOK_MIKTAR,4)#
                                <cfelse>
                                    #TLFormat(0,4)#
                                </cfif>
                           </cf_wrk_html_td>
                            <cfif isdefined('attributes.display_cost')>
                                <cfif donem_basi_stok neq 0>
									<cfif donem_basi_stok neq 0>
										<cfset start_period_cost_date = dateformat(start_date,dateformat_style)>
										<cfif start_period_cost_date is '01/01/#session.ep.period_year#'>
											<cfset start_period_cost_date=start_date>
										<cfelse>
											<cfset start_period_cost_date=date_add('d',-1,start_date)>
										</cfif>
										<!--- <cfset db_maliyet2 = produc_cost_func(cost_product_id:.PRODUCT_ID,cost_date:start_period_cost_date)> --->
										<cfset donem_basi_maliyet=(donem_basi_stok*.ALL_START_COST)>
										<cfif donem_basi_maliyet neq 0>
											<cfset page_totals[1][4] = page_totals[1][4] + (donem_basi_maliyet/donem_basi_kur_)><!--- donem bası maliyet --->
											<cfset db_maliyet_temp= TLFormat(donem_basi_maliyet/donem_basi_kur_)>
										</cfif>
										<cfif isdefined('attributes.is_system_money_2')>
											<cfset donem_basi_other_cost=(donem_basi_stok*.ALL_START_COST_2)>
											<cfif donem_basi_other_cost neq 0>
												<cfset page_totals[1][64] = page_totals[1][64] + donem_basi_other_cost><!--- donem bası maliyet 2--->
												<cfset db_maliyet2_temp= TLFormat(donem_basi_other_cost)>
											</cfif>
										</cfif>
									</cfif>
                                </cfif>
                                <!---Sonunda senide buldum.--->
                                <cf_wrk_html_td align="right" nowrap="nowrap" format="numeric">#db_maliyet_temp#</cf_wrk_html_td>
                                <cf_wrk_html_td>
								<cfif isdefined("attributes.display_cost_money")>
									#all_start_money#
								<cfelse>
									#attributes.cost_money#	
								</cfif>
								</cf_wrk_html_td>
                                <cfif isdefined('attributes.is_system_money_2')>
                                    <cf_wrk_html_td align="right" nowrap format="numeric">#db_maliyet2_temp#</cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">#session.ep.money2#</cf_wrk_html_td>
                                </cfif>
                            </cfif>
                            <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            <!--- alıs ve alıs iadeler bolumu --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
                                <cfset net_alis=0>
                              	<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("TOPLAM_ALIS") and len(TOPLAM_ALIS)>
                                        <cfset net_alis=(net_alis+wrk_round(TOPLAM_ALIS,4))>
                                        <cfset page_totals[1][5] = page_totals[1][5] + wrk_round(TOPLAM_ALIS,4)> <!--- alıs miktar --->
                                        #TLFormat(TOPLAM_ALIS,4)#
                                    </cfif>
                                 </cf_wrk_html_td>
                                 <cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("TOPLAM_ALIS_IADE") and len(TOPLAM_ALIS_IADE)>
                                        <cfset net_alis= (net_alis - wrk_round(TOPLAM_ALIS_IADE,4))>
                                        <cfset page_totals[1][6] = page_totals[1][6] + wrk_round(TOPLAM_ALIS_IADE,4)> <!--- alıs iade miktar --->
                                        #TLFormat(TOPLAM_ALIS_IADE,4)#
                                    </cfif>
                                 </cf_wrk_html_td>
                               <cf_wrk_html_td align="right" format="numeric">
                                #TLFormat(net_alis,4)#
                                <cfset page_totals[1][7] = page_totals[1][7] + net_alis> <!--- net alıs  --->
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cfset alis_mal_1=0>
                                    <cfset alis_mal_2 = 0> <!--- sistem 2. para birimi net alış tutarını gösterir --->
                                    <cf_wrk_html_td width="85" align="right" nowrap format="numeric">
                                    <cfif isdefined("TOPLAM_ALIS_MALIYET") and len(TOPLAM_ALIS_MALIYET)>
                                        <cfset alis_mal_1=alis_mal_1 + TOPLAM_ALIS_MALIYET> 	
                                        <cfset page_totals[1][8] = page_totals[1][8] + TOPLAM_ALIS_MALIYET> <!--- alıs maliyet  --->
                                        #TLFormat(TOPLAM_ALIS_MALIYET)# 
                                    </cfif>
                                     </cf_wrk_html_td>
                                     <cf_wrk_html_td width="15" nowrap="nowrap">
										<cfif isdefined("TOPLAM_ALIS_MALIYET") and len(TOPLAM_ALIS_MALIYET)>#attributes.cost_money#</cfif>
									 </cf_wrk_html_td>
                                     <cf_wrk_html_td width="85" align="right" nowrap format="numeric">
                                    <cfif isdefined("TOPLAM_ALIS_IADE_MALIYET") and len(TOPLAM_ALIS_IADE_MALIYET)>
                                        <cfset alis_mal_1=alis_mal_1 - TOPLAM_ALIS_IADE_MALIYET>
                                        <cfset page_totals[1][9] = page_totals[1][9] + TOPLAM_ALIS_IADE_MALIYET> <!--- alıs iade maliyet  --->
                                        #TLFormat(TOPLAM_ALIS_IADE_MALIYET)# 
                                    </cfif>
                                     </cf_wrk_html_td>
                                    <cf_wrk_html_td width="15" nowrap>
										<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET") and len(TOPLAM_ALIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
									 </cf_wrk_html_td>
									<cf_wrk_html_td width="85" align="right" nowrap format="numeric">
                                    	#TLFormat(alis_mal_1)# 
                                   		<cfset page_totals[1][10] = page_totals[1][10] + alis_mal_1> 
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td width="15" nowrap>
										<cfif alis_mal_1 neq 0>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
										<cf_wrk_html_td width="85" align="right" nowrap format="numeric">
                                        <cfif isdefined("TOPLAM_ALIS_MALIYET_2") and len(TOPLAM_ALIS_MALIYET_2)>
                                            <cfset alis_mal_2=alis_mal_2 + TOPLAM_ALIS_MALIYET_2> 	
                                            <cfset page_totals[1][47] = page_totals[1][47] + TOPLAM_ALIS_MALIYET_2> <!--- alıs maliyet  --->
                                            #TLFormat(TOPLAM_ALIS_MALIYET_2)# 
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("TOPLAM_ALIS_MALIYET_2") and len(TOPLAM_ALIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
										<cf_wrk_html_td width="85" align="right" nowrap format="numeric">
											<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET_2") and len(TOPLAM_ALIS_IADE_MALIYET_2)>
												<cfset alis_mal_2=alis_mal_2 - TOPLAM_ALIS_IADE_MALIYET_2>
												<cfset page_totals[1][48] = page_totals[1][48] + TOPLAM_ALIS_IADE_MALIYET_2> <!--- alıs iade maliyet  --->
												#TLFormat(TOPLAM_ALIS_IADE_MALIYET_2)# 
											</cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("TOPLAM_ALIS_IADE_MALIYET_2") and len(TOPLAM_ALIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
										<cf_wrk_html_td width="85" align="right" nowrap format="numeric">
											#TLFormat(alis_mal_2)# 
											<cfset page_totals[1][49] = page_totals[1][49] + alis_mal_2> 
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap><cfif alis_mal_2 neq 0>#session.ep.money2#</cfif></cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                            <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- satıs ve satıs iade bolumu --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
                                    <cfset satis_mal_1=0>
                                    <cfif isdefined("TOPLAM_SATIS_MALIYET") and len(TOPLAM_SATIS_MALIYET)>
                                        <cfset page_totals[1][11] = page_totals[1][11] + TOPLAM_SATIS_MALIYET> <!--- satıs maliyet  --->
                                        <cfset satis_mal_1=satis_mal_1 + TOPLAM_SATIS_MALIYET>
                                    </cfif>
                                    <cfif isdefined("TOP_SAT_IADE_MALIYET") and len(TOP_SAT_IADE_MALIYET)>
                                        <cfset page_totals[1][12] = page_totals[1][12] + TOP_SAT_IADE_MALIYET> <!--- satıs iade maliyet  --->
                                        <cfset satis_mal_1=satis_mal_1 -TOP_SAT_IADE_MALIYET>
                                    </cfif>
                                    <cfset net_satis_miktar1=0>

									<cf_wrk_html_td align="right" format="numeric">
                                        <cfif isdefined("TOPLAM_SATIS") and len("TOPLAM_SATIS")>
                                            <cfset net_satis_miktar1=net_satis_miktar1+wrk_round(TOPLAM_SATIS,4)>
                                            <cfset page_totals[1][13] = page_totals[1][13] + wrk_round(TOPLAM_SATIS,4)> <!--- satıs miktar  --->
                                            #TLFormat(TOPLAM_SATIS,4)#</cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td align="right" format="numeric">
                                        <cfif isdefined("TOPLAM_SATIS_IADE") and len(TOPLAM_SATIS_IADE)>
                                            <cfset net_satis_miktar1=net_satis_miktar1-wrk_round(TOPLAM_SATIS_IADE,4)>
                                            <cfset page_totals[1][14] = page_totals[1][14] + wrk_round(TOPLAM_SATIS_IADE,4)> <!--- satıs iade miktar  --->
                                            #TLFormat(TOPLAM_SATIS_IADE,4)#
										</cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td align="right" format="numeric">
                                    	#TLFormat(net_satis_miktar1,4)#
                                    	<cfset page_totals[1][15] = page_totals[1][15] + net_satis_miktar1> <!---net satıs miktar  --->
                                     </cf_wrk_html_td>
                                    <cfif isdefined('attributes.from_invoice_actions')><!--- satıs fatura tutarı --->
										<cf_wrk_html_td align="right" format="numeric">
                                            <cfif isdefined("FATURA_SATIS_MIKTAR") and len(FATURA_SATIS_MIKTAR)>
                                               <cfset page_totals[1][42] = page_totals[1][42] + wrk_round(FATURA_SATIS_MIKTAR,4)> 
                                               <cfset fatura_net_satis_miktar = fatura_net_satis_miktar +wrk_round(FATURA_SATIS_MIKTAR,4)>
											   #TLFormat(FATURA_SATIS_MIKTAR)#
                                            </cfif>	
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="82" align="right" format="numeric">
                                            <cfif isdefined("FATURA_SATIS_TUTAR") and len(FATURA_SATIS_TUTAR)>
                                                <cfset page_totals[1][43] = page_totals[1][43] + FATURA_SATIS_TUTAR> 
                                                #TLFormat(FATURA_SATIS_TUTAR)# 
                                            </cfif>	
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("FATURA_SATIS_TUTAR") and len(FATURA_SATIS_TUTAR)>#attributes.cost_money#</cfif>
										</cf_wrk_html_td>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            <cf_wrk_html_td width="110" align="right" format="numeric">
                                                <cfif isdefined("FATURA_SATIS_TUTAR_2") and len(FATURA_SATIS_TUTAR_2)>
                                                    <cfset page_totals[1][66] = page_totals[1][66] + FATURA_SATIS_TUTAR_2> 
                                                    #TLFormat(FATURA_SATIS_TUTAR_2)# 
                                                </cfif>	
                                            </cf_wrk_html_td>
                                            <cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_TUTAR_2") and len(FATURA_SATIS_TUTAR_2)>#session.ep.money2#</cfif>
											</cf_wrk_html_td>
                                        </cfif>
										<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
											<cf_wrk_html_td width="82" align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_MALIYET") and len(FATURA_SATIS_MALIYET)>
													<cfset page_totals[1][102] = page_totals[1][102] + FATURA_SATIS_MALIYET> 
													#TLFormat(FATURA_SATIS_MALIYET)# 
												</cfif>
											</cf_wrk_html_td>
											<cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_MALIYET") and len(FATURA_SATIS_MALIYET)>#attributes.cost_money#</cfif>
											</cf_wrk_html_td>
											<cfif isdefined('attributes.is_system_money_2')>
												<cf_wrk_html_td width="110" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_MALIYET_2") and len(FATURA_SATIS_MALIYET_2)>
														<cfset page_totals[1][103] = page_totals[1][103] + FATURA_SATIS_MALIYET_2> 
														#TLFormat(FATURA_SATIS_MALIYET_2)# 
													</cfif>	
												</cf_wrk_html_td>
												<cf_wrk_html_td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_MALIYET_2") and len(FATURA_SATIS_MALIYET_2)>#session.ep.money2#</cfif>
												</cf_wrk_html_td>
											</cfif>
										</cfif>
										<cf_wrk_html_td align="right" format="numeric">
                                            <cfif isdefined("FATURA_SATIS_IADE_MIKTAR") and len(FATURA_SATIS_IADE_MIKTAR)>
                                                <cfset page_totals[1][44] = page_totals[1][44] + wrk_round(FATURA_SATIS_IADE_MIKTAR,4)> 
                                                <cfset fatura_net_satis_miktar = fatura_net_satis_miktar -wrk_round(FATURA_SATIS_IADE_MIKTAR,4)>
												#TLFormat(FATURA_SATIS_IADE_MIKTAR,4)#
                                            </cfif>	
                                       </cf_wrk_html_td>
                                       <cf_wrk_html_td width="108" align="right" format="numeric">
                                            <cfif isdefined("FATURA_SATIS_IADE_TUTAR") and len(FATURA_SATIS_IADE_TUTAR)>
                                                <cfset page_totals[1][45] = page_totals[1][45] + FATURA_SATIS_IADE_TUTAR> 
                                                #TLFormat(FATURA_SATIS_IADE_TUTAR)# 
                                            </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("FATURA_SATIS_IADE_TUTAR") and len(FATURA_SATIS_IADE_TUTAR)>#attributes.cost_money#</cfif>
										</cf_wrk_html_td>
                                        <cfif isdefined('attributes.is_system_money_2')>
                                            <cf_wrk_html_td width="132" align="right" format="numeric">
                                                <cfif isdefined("FATURA_SATIS_IADE_TUTAR_2") and len(FATURA_SATIS_IADE_TUTAR_2)>
                                                    <cfset page_totals[1][67] = page_totals[1][67] + FATURA_SATIS_IADE_TUTAR_2> 
                                                    #TLFormat(FATURA_SATIS_IADE_TUTAR_2)# 
                                                </cfif>
                                            </cf_wrk_html_td>
                                            <cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_IADE_TUTAR_2") and len(FATURA_SATIS_IADE_TUTAR_2)>#session.ep.money2#</cfif>
											</cf_wrk_html_td>
                                        </cfif>
										<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
											<cf_wrk_html_td width="82" align="right" format="numeric">
												<cfif isdefined("FATURA_SATIS_IADE_MALIYET") and len(FATURA_SATIS_IADE_MALIYET)>
													<cfset page_totals[1][104] = page_totals[1][104] + FATURA_SATIS_IADE_MALIYET> 
													#TLFormat(FATURA_SATIS_IADE_MALIYET)# 
												</cfif>
											</cf_wrk_html_td>
											<cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("FATURA_SATIS_IADE_MALIYET") and len(FATURA_SATIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
											</cf_wrk_html_td>
											<cfif isdefined('attributes.is_system_money_2')>
												<cf_wrk_html_td width="110" align="right" format="numeric">
													<cfif isdefined("FATURA_SATIS_IADE_MALIYET_2") and len(FATURA_SATIS_IADE_MALIYET_2)>
														<cfset page_totals[1][105] = page_totals[1][105] + FATURA_SATIS_IADE_MALIYET_2> 
														#TLFormat(FATURA_SATIS_IADE_MALIYET_2)# 
													</cfif>	
												</cf_wrk_html_td>
												<cf_wrk_html_td width="15" nowrap>
													<cfif isdefined("FATURA_SATIS_IADE_MALIYET_2") and len(FATURA_SATIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>

												</cf_wrk_html_td>
											</cfif>
										
										</cfif>
                                    </cfif>
                                    <cfif isdefined('attributes.display_cost')>
                                        <cfset satis_net_tutar1=0>
                                        <cfset satis_net_tutar_2=0> <!--- sistem 2. para birimi net satıs tutarını gösterir --->
                                        <cf_wrk_html_td align="right" nowrap format="numeric">
                                        <cfif isdefined("TOPLAM_SATIS_MALIYET") and len(TOPLAM_SATIS_MALIYET)>
                                            <cfset page_totals[1][16] = page_totals[1][16] + TOPLAM_SATIS_MALIYET> <!---satıs maliyet  --->
                                            #TLFormat(TOPLAM_SATIS_MALIYET)# 
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("TOPLAM_SATIS_MALIYET") and len(TOPLAM_SATIS_MALIYET)>#attributes.cost_money#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="82" align="right" format="numeric">
                                        <cfif isdefined("TOP_SAT_IADE_MALIYET") and len(TOP_SAT_IADE_MALIYET)>
                                            <cfset page_totals[1][17] = page_totals[1][17] + TOP_SAT_IADE_MALIYET> <!---satıs iade maliyet  --->
                                            #TLFormat(TOP_SAT_IADE_MALIYET)# 
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("TOP_SAT_IADE_MALIYET") and len(TOP_SAT_IADE_MALIYET)>#attributes.cost_money#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="82" align="right" nowrap format="numeric">
                                        	<cfset page_totals[1][18] = page_totals[1][18] + satis_mal_1> <!---net satıs maliyet  --->
                                        	#TLFormat(satis_mal_1)#
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif satis_mal_1 neq 0>#attributes.cost_money#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="70" align="right" nowrap format="numeric">
                                        	<cfset page_totals[1][101] = page_totals[1][101] + wrk_round((fatura_net_satis_miktar*ds_urun_birim_maliyet)/donem_sonu_kur)>
											#TLFormat((fatura_net_satis_miktar*ds_urun_birim_maliyet)/donem_sonu_kur)#
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											#attributes.cost_money#
										</cf_wrk_html_td>
									    <cfif isdefined('attributes.is_system_money_2')>	 				
                                            <cf_wrk_html_td width="82" align="right" nowrap format="numeric">
                                            <cfif isdefined("TOPLAM_SATIS_MALIYET_2") and len(TOPLAM_SATIS_MALIYET_2)>
                                                <cfset page_totals[1][50] = page_totals[1][50] + TOPLAM_SATIS_MALIYET_2> <!---satıs maliyet usd --->
                                                <cfset satis_net_tutar_2 = satis_net_tutar_2 + TOPLAM_SATIS_MALIYET_2>
                                                #TLFormat(TOPLAM_SATIS_MALIYET_2)# 
                                            </cfif>
                                            </cf_wrk_html_td>
                                            <cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("TOPLAM_SATIS_MALIYET_2") and len(TOPLAM_SATIS_MALIYET_2)>#session.ep.money2#</cfif>
											</cf_wrk_html_td>
                                            <cf_wrk_html_td  align="right" format="numeric">
                                            <cfif isdefined("TOP_SAT_IADE_MALIYET_2") and len(TOP_SAT_IADE_MALIYET_2)>
                                                <cfset page_totals[1][51] = page_totals[1][51] + TOP_SAT_IADE_MALIYET_2> <!---satıs iade maliyet  ---> 
                                                <cfset satis_net_tutar_2 = satis_net_tutar_2 - TOP_SAT_IADE_MALIYET_2>
                                                #TLFormat(TOP_SAT_IADE_MALIYET_2)#
                                            </cfif>
                                            </cf_wrk_html_td>
                                            <cf_wrk_html_td width="15" nowrap>
												<cfif isdefined("TOP_SAT_IADE_MALIYET_2") and len(TOP_SAT_IADE_MALIYET_2)> #session.ep.money2#</cfif>
											</cf_wrk_html_td>
                                            <cf_wrk_html_td  align="right" nowrap format="numeric">
                                                <cfset page_totals[1][65] = page_totals[1][65] + satis_net_tutar_2> <!---net satıs maliyet  --->
                                                #TLFormat(satis_net_tutar_2)# 
                                            </cf_wrk_html_td>
                                            <cf_wrk_html_td width="15" nowrap format="numeric">
												<cfif satis_net_tutar_2 neq 0> #session.ep.money2#</cfif>
											</cf_wrk_html_td>
                                        </cfif>
                                    </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- Konsinye cikis irs. --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("KONS_CIKIS_MIKTAR") and len(KONS_CIKIS_MIKTAR)>
                                        <cfset page_totals[1][19] = page_totals[1][19] + wrk_round(KONS_CIKIS_MIKTAR,4)> <!---kons_cikis_miktar  --->
                                        #TLFormat(KONS_CIKIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
									<cf_wrk_html_td width="85" align="right" nowrap format="numeric">
                                    <cfif isdefined("KONS_CIKIS_MALIYET") and len(KONS_CIKIS_MALIYET)>								
                                        <cfset page_totals[1][20] = page_totals[1][20] + KONS_CIKIS_MALIYET> <!---kons_cikis_maliyet_ --->
                                        #TLFormat(KONS_CIKIS_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td width="15" nowrap>
										<cfif isdefined("KONS_CIKIS_MALIYET") and len(KONS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="130" align="right" format="numeric">
                                        <cfif isdefined("KONS_CIKIS_MALIYET_2") and len(KONS_CIKIS_MALIYET_2)>								
                                            <cfset page_totals[1][52] = page_totals[1][52] + KONS_CIKIS_MALIYET_2> <!---kons_cikis_maliyet_ --->
                                            #TLFormat(KONS_CIKIS_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td width="15" nowrap>
											<cfif isdefined("KONS_CIKIS_MALIYET_2") and len(KONS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <!--- BURADAN DEVAM  --->
                               <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- konsinye iade gelen --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("KONS_IADE_MIKTAR") and len(KONS_IADE_MIKTAR)>
                                        <cfset page_totals[1][21] = page_totals[1][21] + wrk_round(KONS_IADE_MIKTAR,4)> <!---kons_iade_miktar_--->
                                        #TLFormat(KONS_IADE_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                   <cf_wrk_html_td width="118" align="right" format="numeric">
                                    <cfif isdefined("KONS_IADE_MALIYET") and len(KONS_IADE_MALIYET)>								
                                        <cfset page_totals[1][22] = page_totals[1][22] + KONS_IADE_MALIYET> <!---kons_iade_maliyet_--->
                                        #TLFormat(KONS_IADE_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td align="right" nowrap width="15">
										<cfif isdefined("KONS_IADE_MALIYET") and len(KONS_IADE_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="128" align="right" format="numeric">
                                            <cfif isdefined("KONS_IADE_MALIYET_2") and len(KONS_IADE_MALIYET_2)>								
                                                <cfset page_totals[1][53] = page_totals[1][53] + KONS_IADE_MALIYET_2> <!---kons_iade_maliyet_--->
                                                #TLFormat(KONS_IADE_MALIYET_2)# 
                                            </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td align="right" nowrap width="15">
											<cfif isdefined("KONS_IADE_MALIYET_2") and len(KONS_IADE_MALIYET_2)>#session.ep.money2#	</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- Konsinye Giriş İrs. --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("KONS_GIRIS_MIKTAR") and len(KONS_GIRIS_MIKTAR)>
                                        <cfset page_totals[1][95] = page_totals[1][95] + wrk_round(KONS_GIRIS_MIKTAR,4)> <!---kons_giris_miktar  --->
                                        #TLFormat(KONS_GIRIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="118" align="right" format="numeric">
                                    <cfif isdefined("KONS_GIRIS_MALIYET") and len(KONS_GIRIS_MALIYET)>								
                                        <cfset page_totals[1][96] = page_totals[1][96] +KONS_GIRIS_MALIYET> <!---kons_giris_maliyet_ --->
                                        #TLFormat(KONS_GIRIS_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td align="right" nowrap width="15">
										<cfif isdefined("KONS_GIRIS_MALIYET") and len(KONS_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                       <cf_wrk_html_td width="128" align="right" format="numeric">
                                        <cfif isdefined("KONS_GIRIS_MALIYET_2") and len(KONS_GIRIS_MALIYET_2)>								
                                            <cfset page_totals[1][97] = page_totals[1][97] + KONS_GIRIS_MALIYET_2> <!---kons_giris_maliyet_2 --->
                                            #TLFormat(KONS_GIRIS_MALIYET_2)# 	
                                        </cfif>
                                       </cf_wrk_html_td>
                                       <cf_wrk_html_td align="right" nowrap width="15">
									   		<cfif isdefined("KONS_GIRIS_MALIYET_2") and len(KONS_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- Konsinye Giriş İade İrs. --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("KONS_GIRIS_IADE_MIKTAR") and len(KONS_GIRIS_IADE_MIKTAR)>
                                        <cfset page_totals[1][98] = page_totals[1][98] + wrk_round(KONS_GIRIS_IADE_MIKTAR,4)> <!---kons_giris_iade miktar  --->
                                        #TLFormat(KONS_GIRIS_IADE_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="118" align="right" format="numeric">
                                    <cfif isdefined("KONS_GIRIS_IADE_MALIYET") and len(KONS_GIRIS_IADE_MALIYET)>								
                                        <cfset page_totals[1][99] = page_totals[1][99] + KONS_GIRIS_IADE_MALIYET> <!---kons_giris_iade maliyet_ --->
        
                                        #TLFormat(KONS_GIRIS_IADE_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td align="right" nowrap width="15">
										<cfif isdefined("KONS_GIRIS_IADE_MALIYET") and len(KONS_GIRIS_IADE_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="128" align="right" format="numeric">
                                        <cfif isdefined("KONS_GIRIS_IADE_MALIYET_2") and len(KONS_GIRIS_IADE_MALIYET_2)>								
                                            <cfset page_totals[1][100] = page_totals[1][100] + KONS_GIRIS_IADE_MALIYET_2> <!---kons_giris_iade maliyet_2 --->
                                            #TLFormat(KONS_GIRIS_IADE_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td align="right" nowrap width="15">
											<cfif isdefined("KONS_GIRIS_IADE_MALIYET_2") and len(KONS_GIRIS_IADE_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td></cf_wrk_html_td>
                            </cfif>
                            <!--- Teknik Servis Giriş --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("SERVIS_GIRIS_MIKTAR") and len(SERVIS_GIRIS_MIKTAR)>
                                        <cfset page_totals[1][23] = page_totals[1][23] + wrk_round(SERVIS_GIRIS_MIKTAR,4)> <!---servis_giris_miktar_--->
                                        #TLFormat(SERVIS_GIRIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="42" align="right" nowrap format="numeric">
                                    <cfif isdefined("SERVIS_GIRIS_MALIYET") and len(SERVIS_GIRIS_MALIYET)>
                                        <cfset page_totals[1][24] = page_totals[1][24] + SERVIS_GIRIS_MALIYET> <!---servis_giris_maliyet_--->
                                        #TLFormat(SERVIS_GIRIS_MALIYET)# </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SERVIS_GIRIS_MALIYET") and len(SERVIS_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="42" format="numeric">
                                        <cfif isdefined("SERVIS_GIRIS_MALIYET_2") and len(SERVIS_GIRIS_MALIYET_2)>
                                            <cfset page_totals[1][54] = page_totals[1][54] + SERVIS_GIRIS_MALIYET_2> <!---servis_giris_maliyet_--->
                                            #TLFormat(SERVIS_GIRIS_MALIYET_2)# 
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SERVIS_GIRIS_MALIYET_2") and len(SERVIS_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- Teknik Servis Çıkış --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("SERVIS_CIKIS_MIKTAR") and len(SERVIS_CIKIS_MIKTAR)>
                                        <cfset page_totals[1][25] = page_totals[1][25] + wrk_round(SERVIS_CIKIS_MIKTAR,4)> <!---servis_cikis_miktar_--->
                                        #TLFormat(SERVIS_CIKIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="42" align="right" nowrap format="numeric">
                                    <cfif isdefined("SERVIS_CIKIS_MALIYET") and len(SERVIS_CIKIS_MALIYET)>
                                        <cfset page_totals[1][26] = page_totals[1][26] + SERVIS_CIKIS_MALIYET> <!---servis_cikis_miktar_--->
                                        #TLFormat(SERVIS_CIKIS_MALIYET)#</cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SERVIS_CIKIS_MALIYET") and len(SERVIS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="42" format="numeric">
                                        <cfif isdefined("SERVIS_CIKIS_MALIYET_2") and len(SERVIS_CIKIS_MALIYET_2)>
                                            <cfset page_totals[1][55] = page_totals[1][55] +SERVIS_CIKIS_MALIYET_2> <!---servis_cikis_miktar_--->
                                            #TLFormat(SERVIS_CIKIS_MALIYET_2)# 
                                        </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SERVIS_CIKIS_MALIYET_2") and len(SERVIS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- RMA Giriş --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("RMA_GIRIS_MIKTAR") and len(RMA_GIRIS_MIKTAR)>
                                        <cfset page_totals[1][27] = page_totals[1][27] + wrk_round(RMA_GIRIS_MIKTAR,4)> <!---rma_giris_miktar_--->
                                        #TLFormat(RMA_GIRIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="34" align="right" nowrap format="numeric">
                                    <cfif isdefined("RMA_GIRIS_MALIYET") and len(RMA_GIRIS_MALIYET)>
                                        <cfset page_totals[1][28] = page_totals[1][28] +RMA_GIRIS_MALIYET> <!---rma_giris_maliyet_--->
                                        #TLFormat(RMA_GIRIS_MALIYET)# 
                                    </cfif>
                                    </cf_wrk_html_td>
                                    <cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("RMA_GIRIS_MALIYET") and len(RMA_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="42" format="numeric">
                                            <cfif isdefined("RMA_GIRIS_MALIYET_2") and len(RMA_GIRIS_MALIYET_2)>
                                                <cfset page_totals[1][56] = page_totals[1][56] +RMA_GIRIS_MALIYET_2> <!---rma_giris_maliyet_--->
                                                #TLFormat(RMA_GIRIS_MALIYET_2)# 
                                            </cfif>
                                        </cf_wrk_html_td>
                                        <cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("RMA_GIRIS_MALIYET_2") and len(RMA_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- RMA Çıkış --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("RMA_CIKIS_MIKTAR") and len(RMA_CIKIS_MIKTAR)>
                                        <cfset page_totals[1][29] = page_totals[1][29] + wrk_round(RMA_CIKIS_MIKTAR,4)> <!---rma_cikis_miktar_--->
                                        #TLFormat(RMA_CIKIS_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="34" align="right" nowrap format="numeric">
										<cfif isdefined("RMA_CIKIS_MALIYET") and len(RMA_CIKIS_MALIYET)>
											<cfset page_totals[1][30] = page_totals[1][30] + RMA_CIKIS_MALIYET> <!---rma_cikis_maliyet_--->
											#TLFormat(RMA_CIKIS_MALIYET)# 
										</cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("RMA_CIKIS_MALIYET") and len(RMA_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="42" format="numeric">
                                            <cfif isdefined("RMA_CIKIS_MALIYET_2") and len(RMA_CIKIS_MALIYET_2)>
                                                <cfset page_totals[1][57] = page_totals[1][57] + RMA_CIKIS_MALIYET_2> <!---rma_cikis_maliyet_--->
                                                #TLFormat(RMA_CIKIS_MALIYET_2)# 
                                            </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("RMA_CIKIS_MALIYET_2") and len(RMA_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- uretim fisleri --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("TOPLAM_URETIM") and len(TOPLAM_URETIM)>
                                        <cfset page_totals[1][31] = page_totals[1][31] + wrk_round(TOPLAM_URETIM,4)> <!---uretim_miktar_--->
                                        #TLFormat(TOPLAM_URETIM,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td align="right" nowrap format="numeric">
                                    <cfif isdefined("URETIM_MALIYET") and len(URETIM_MALIYET)>								
                                        <cfset page_totals[1][32] = page_totals[1][32] + URETIM_MALIYET> <!---uretim_maliyet_--->
                                        #TLFormat(URETIM_MALIYET)# 
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("URETIM_MALIYET") and len(URETIM_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td align="right" nowrap format="numeric">
                                        <cfif isdefined("URETIM_MALIYET_2") and len(URETIM_MALIYET_2)>								
                                            <cfset page_totals[1][58] = page_totals[1][58] + URETIM_MALIYET_2> <!---uretim_maliyet_--->
                                            #TLFormat(URETIM_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("URETIM_MALIYET_2") and len(URETIM_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- sarf ve fire fisleri --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
								<cf_wrk_html_td align="right" format="numeric">
									<cfif isdefined("TOPLAM_SARF") and len(TOPLAM_SARF)>
										<cfset page_totals[1][33] = page_totals[1][33] + wrk_round(TOPLAM_SARF,4)> <!---sarf_miktar_--->
										#TLFormat(TOPLAM_SARF,4)#
									</cfif>
                                </cf_wrk_html_td>
								<cf_wrk_html_td align="right" format="numeric">
									<cfif isdefined("TOPLAM_URETIM_SARF") and len(TOPLAM_URETIM_SARF)>
										<cfset page_totals[1][70] = page_totals[1][70] + wrk_round(TOPLAM_URETIM_SARF,4)>  <!---uretim sarf_miktar_--->
										#TLFormat(TOPLAM_URETIM_SARF,4)#
									</cfif>
                                </cf_wrk_html_td>
								<cf_wrk_html_td align="right" format="numeric">
									<cfif isdefined("TOPLAM_FIRE") and len(TOPLAM_FIRE)>
                                   		<cfset page_totals[1][34] = page_totals[1][34] + wrk_round(TOPLAM_FIRE,4)> <!---fire_miktar_--->
                                    	#TLFormat(TOPLAM_FIRE,4)#
									</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                    <cfif isdefined("SARF_MALIYET") and len(SARF_MALIYET)>								
                                        <cfset page_totals[1][35] = page_totals[1][35] + SARF_MALIYET> <!---sarf_maliyet_--->
                                        #TLFormat(SARF_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SARF_MALIYET") and len(SARF_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                    <cfif isdefined("URETIM_SARF_MALIYET") and len(URETIM_SARF_MALIYET)>								
                                        <cfset page_totals[1][71] = page_totals[1][71] + URETIM_SARF_MALIYET> <!---uretim sarf_maliyet_--->
                                        #TLFormat(URETIM_SARF_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("URETIM_SARF_MALIYET") and len(URETIM_SARF_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
										<cfif isdefined("FIRE_MALIYET") and len(FIRE_MALIYET)>								
											<cfset page_totals[1][36] = page_totals[1][36] + FIRE_MALIYET> <!---fire_maliyet_--->
											#TLFormat(FIRE_MALIYET)# 	
										</cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
                                        <cfif isdefined("FIRE_MALIYET") and len(FIRE_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                        <cfif isdefined("SARF_MALIYET_2") and len(SARF_MALIYET_2)>								
                                            <cfset page_totals[1][59] = page_totals[1][59] + SARF_MALIYET_2> <!---sarf_maliyet_--->
                                            #TLFormat(SARF_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SARF_MALIYET_2") and len(SARF_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                        <cfif isdefined("URETIM_SARF_MALIYET_2") and len(URETIM_SARF_MALIYET_2)>								
                                            <cfset page_totals[1][72] = page_totals[1][72] + URETIM_SARF_MALIYET_2> <!---uretim sarf_maliyet_ sistem 2.dovizi--->
                                            #TLFormat(URETIM_SARF_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("URETIM_SARF_MALIYET_2") and len(URETIM_SARF_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                        <cfif isdefined("FIRE_MALIYET_2") and len(FIRE_MALIYET_2)>								
                                            <cfset page_totals[1][60] = page_totals[1][60] + FIRE_MALIYET_2><!---fire_maliyet_--->
                                            #TLFormat(FIRE_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("FIRE_MALIYET_2") and len(FIRE_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- sayim fisleri --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
								<cf_wrk_html_td align="right" format="numeric">
								<cfif isdefined("TOPLAM_SAYIM") and len(TOPLAM_SAYIM)>
                                    <cfset page_totals[1][37] = page_totals[1][37] + wrk_round(TOPLAM_SAYIM,4)> <!---sayim_miktar_--->
                                    #TLFormat(TOPLAM_SAYIM,4)#
                                </cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                    <cfif isdefined("SAYIM_MALIYET") and len(SAYIM_MALIYET)>								
                                        <cfset page_totals[1][68] = page_totals[1][68] + SAYIM_MALIYET> <!---sayim_maliyet_--->
                                        #TLFormat(SAYIM_MALIYET)# 	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SAYIM_MALIYET") and len(SAYIM_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="62" align="right" nowrap format="numeric">
                                        <cfif isdefined("SAYIM_MALIYET_2") and len(SAYIM_MALIYET_2)>								
                                            <cfset page_totals[1][69] = page_totals[1][69] + SAYIM_MALIYET_2> <!---sayim_maliyet_--->
                                            #TLFormat(SAYIM_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SAYIM_MALIYET_2") and len(SAYIM_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- demontajdan giris --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("DEMONTAJ_GIRIS") and len(DEMONTAJ_GIRIS)>
                                        <cfset page_totals[1][38] = page_totals[1][38] + wrk_round(DEMONTAJ_GIRIS,4)> <!---demontaj_giris_miktar_--->
                                        #TLFormat(DEMONTAJ_GIRIS,4)#
									</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("DEMONTAJ_GIRIS_MALIYET") and len(DEMONTAJ_GIRIS_MALIYET)>								
                                        <cfset page_totals[1][39] = page_totals[1][39] + DEMONTAJ_GIRIS_MALIYET> <!---demontaj_giris_maliyet_--->
                                        #TLFormat(DEMONTAJ_GIRIS_MALIYET)# 
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("DEMONTAJ_GIRIS_MALIYET") and len(DEMONTAJ_GIRIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                       <cf_wrk_html_td width="125" align="right" nowrap format="numeric">
                                        <cfif isdefined("DEMONTAJ_GIRIS_MALIYET_2") and len(DEMONTAJ_GIRIS_MALIYET_2)>								
                                            <cfset page_totals[1][61] = page_totals[1][61] + DEMONTAJ_GIRIS_MALIYET_2> <!---demontaj_giris_maliyet_--->
                                            #TLFormat(DEMONTAJ_GIRIS_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("DEMONTAJ_GIRIS_MALIYET_2") and len(DEMONTAJ_GIRIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- demontaja giden --->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
                            	<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("DEMONTAJ_GIDEN") and len(DEMONTAJ_GIDEN)>
                                        <cfset page_totals[1][40] = page_totals[1][40] + wrk_round(DEMONTAJ_GIDEN,4)> <!---demontaj_giden_miktar_--->
                                        #TLFormat(DEMONTAJ_GIDEN,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("DEMONTAJ_GIDEN_MALIYET") and len(DEMONTAJ_GIDEN_MALIYET)>								
                                        <cfset page_totals[1][41] = page_totals[1][41] + DEMONTAJ_GIDEN_MALIYET> <!---demontaj_giden_maliyet_--->
                                        #TLFormat(DEMONTAJ_GIDEN_MALIYET)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("DEMONTAJ_GIDEN_MALIYET") and len(DEMONTAJ_GIDEN_MALIYET)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("DEMONTAJ_GIDEN_MALIYET_2") and len(DEMONTAJ_GIDEN_MALIYET_2)>								
                                            <cfset page_totals[1][62] = page_totals[1][62] +DEMONTAJ_GIDEN_MALIYET_2><!---demontaj_giden_maliyet_--->
                                            #TLFormat(DEMONTAJ_GIDEN_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
									    <cf_wrk_html_td nowrap="nowrap" width="15">
									   		<cfif isdefined("DEMONTAJ_GIDEN_MALIYET_2") and len(DEMONTAJ_GIDEN_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!--- masraf fişleri--->
                            <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
                            	<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("TOPLAM_MASRAF_MIKTAR") and len(TOPLAM_MASRAF_MIKTAR)>
                                        <cfset page_totals[1][73] = page_totals[1][73] + wrk_round(TOPLAM_MASRAF_MIKTAR,4)>
                                        #TLFormat(TOPLAM_MASRAF_MIKTAR,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("MASRAF_MALIYET") and len(MASRAF_MALIYET)>								
                                        <cfset page_totals[1][74] = page_totals[1][74] + MASRAF_MALIYET>
                                        #TLFormat(MASRAF_MALIYET)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("MASRAF_MALIYET") and len(MASRAF_MALIYET)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("MASRAF_MALIYET_2") and len(MASRAF_MALIYET_2)>								
                                            <cfset page_totals[1][75] = page_totals[1][75] +MASRAF_MALIYET_2>
                                            #TLFormat(MASRAF_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("MASRAF_MALIYET_2") and len(MASRAF_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!---depo sevk : giris-cıkıs stok bilgileri ayrı kolonlarda--->
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
                            	<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("SEVK_GIRIS_MIKTARI") and len(SEVK_GIRIS_MIKTARI)>
                                        <cfset page_totals[1][77] = page_totals[1][77] + wrk_round(SEVK_GIRIS_MIKTARI,4)>
                                        #TLFormat(SEVK_GIRIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("SEVK_CIKIS_MIKTARI") and len(SEVK_CIKIS_MIKTARI)>
                                        <cfset page_totals[1][78] = page_totals[1][78] + wrk_round(SEVK_CIKIS_MIKTARI,4)>
                                        #TLFormat(SEVK_CIKIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("SEVK_GIRIS_MALIYETI") and len(SEVK_GIRIS_MALIYETI)>								
                                        <cfset page_totals[1][79] = page_totals[1][79] + SEVK_GIRIS_MALIYETI>
                                        #TLFormat(SEVK_GIRIS_MALIYETI)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SEVK_GIRIS_MALIYETI") and len(SEVK_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("SEVK_CIKIS_MALIYETI") and len(SEVK_CIKIS_MALIYETI)>								
                                        <cfset page_totals[1][80] = page_totals[1][80] + SEVK_CIKIS_MALIYETI>
                                        #TLFormat(SEVK_CIKIS_MALIYETI)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("SEVK_CIKIS_MALIYETI") and len(SEVK_CIKIS_MALIYETI)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                    	<cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("SEVK_GIRIS_MALIYETI_2") and len(SEVK_GIRIS_MALIYETI_2)>								
                                            <cfset page_totals[1][81] = page_totals[1][81] + SEVK_GIRIS_MALIYETI_2>
                                            #TLFormat(SEVK_GIRIS_MALIYETI_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SEVK_GIRIS_MALIYETI_2") and len(SEVK_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("SEVK_CIKIS_MALIYETI_2") and len(SEVK_CIKIS_MALIYETI_2)>								
                                            <cfset page_totals[1][82] = page_totals[1][82] + SEVK_CIKIS_MALIYETI_2>
                                            #TLFormat(SEVK_CIKIS_MALIYETI_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("SEVK_CIKIS_MALIYETI_2") and len(SEVK_CIKIS_MALIYETI_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!---ithal mal girişi: giris-cıkıs stok bilgileri ayrı kolonlarda--->
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
                            	<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("ITHAL_MAL_GIRIS_MIKTARI") and len(ITHAL_MAL_GIRIS_MIKTARI)>
                                        <cfset page_totals[1][83] = page_totals[1][83] + wrk_round(ITHAL_MAL_GIRIS_MIKTARI,4)>
                                        #TLFormat(ITHAL_MAL_GIRIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("ITHAL_MAL_CIKIS_MIKTARI") and len(ITHAL_MAL_CIKIS_MIKTARI)>
                                        <cfset page_totals[1][84] = page_totals[1][84] + wrk_round(ITHAL_MAL_CIKIS_MIKTARI,4)>
                                        #TLFormat(ITHAL_MAL_CIKIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                	<cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI") and len(ITHAL_MAL_GIRIS_MALIYETI)>								
                                        <cfset page_totals[1][85] = page_totals[1][85] +ITHAL_MAL_GIRIS_MALIYETI>
                                        #TLFormat(ITHAL_MAL_GIRIS_MALIYETI)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI") and len(ITHAL_MAL_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI") and len(ITHAL_MAL_CIKIS_MALIYETI)>								
                                        <cfset page_totals[1][86] = page_totals[1][86] + ITHAL_MAL_CIKIS_MALIYETI>
                                        #TLFormat(ITHAL_MAL_CIKIS_MALIYETI)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI") and len(ITHAL_MAL_CIKIS_MALIYETI)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI_2") and len(ITHAL_MAL_GIRIS_MALIYETI_2)>								
                                            <cfset page_totals[1][87] = page_totals[1][87] + ITHAL_MAL_GIRIS_MALIYETI_2>
                                            #TLFormat(ITHAL_MAL_GIRIS_MALIYETI_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("ITHAL_MAL_GIRIS_MALIYETI_2") and len(ITHAL_MAL_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI_2") and len(ITHAL_MAL_CIKIS_MALIYETI_2)>								
                                            <cfset page_totals[1][88] = page_totals[1][88] + ITHAL_MAL_CIKIS_MALIYETI_2>
                                            #TLFormat(ITHAL_MAL_CIKIS_MALIYETI_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("ITHAL_MAL_CIKIS_MALIYETI_2") and len(ITHAL_MAL_CIKIS_MALIYETI_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
                            <!---ambar fişi--->
                            <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("AMBAR_FIS_GIRIS_MIKTARI") and len(AMBAR_FIS_GIRIS_MIKTARI)>
                                        <cfset page_totals[1][89] = page_totals[1][89] + wrk_round(AMBAR_FIS_GIRIS_MIKTARI,4)>
                                        #TLFormat(AMBAR_FIS_GIRIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
								<cf_wrk_html_td align="right" format="numeric">
                                    <cfif isdefined("AMBAR_FIS_CIKIS_MIKTARI") and len(AMBAR_FIS_CIKIS_MIKTARI)>
                                        <cfset page_totals[1][90] = page_totals[1][90] + wrk_round(AMBAR_FIS_CIKIS_MIKTARI,4)>
                                        #TLFormat(AMBAR_FIS_CIKIS_MIKTARI,4)#</cfif>
                                </cf_wrk_html_td>
                                <cfif isdefined('attributes.display_cost')>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
										<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI") and len(AMBAR_FIS_GIRIS_MALIYETI)>								
											<cfset page_totals[1][91] = page_totals[1][91] +AMBAR_FIS_GIRIS_MALIYETI>
											#TLFormat(AMBAR_FIS_GIRIS_MALIYETI)#	
										</cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI") and len(AMBAR_FIS_GIRIS_MALIYETI)> #attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="38" align="right" nowrap format="numeric">
                                    <cfif isdefined("AMBAR_FIS_CIKIS_MALIYET") and len(AMBAR_FIS_CIKIS_MALIYET)>								
                                        <cfset page_totals[1][92] = page_totals[1][92] +AMBAR_FIS_CIKIS_MALIYET>
                                        #TLFormat(AMBAR_FIS_CIKIS_MALIYET)#	
                                    </cfif>
                                    </cf_wrk_html_td>
									<cf_wrk_html_td nowrap="nowrap" width="15">
										<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET") and len(AMBAR_FIS_CIKIS_MALIYET)>#attributes.cost_money#</cfif>
									</cf_wrk_html_td>
                                    <cfif isdefined('attributes.is_system_money_2')>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI_2") and len(AMBAR_FIS_GIRIS_MALIYETI_2)>								
                                            <cfset page_totals[1][93] = page_totals[1][93] + AMBAR_FIS_GIRIS_MALIYETI_2>
                                            #TLFormat(AMBAR_FIS_GIRIS_MALIYETI_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("AMBAR_FIS_GIRIS_MALIYETI_2") and len(AMBAR_FIS_GIRIS_MALIYETI_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                        <cf_wrk_html_td width="118" align="right" nowrap format="numeric">
                                        <cfif isdefined("AMBAR_FIS_CIKIS_MALIYET_2") and len(AMBAR_FIS_CIKIS_MALIYET_2)>								
                                            <cfset page_totals[1][94] = page_totals[1][94] + AMBAR_FIS_CIKIS_MALIYET_2>
                                            #TLFormat(AMBAR_FIS_CIKIS_MALIYET_2)# 	
                                        </cfif>
                                        </cf_wrk_html_td>
										<cf_wrk_html_td nowrap="nowrap" width="15">
											<cfif isdefined("AMBAR_FIS_CIKIS_MALIYET_2") and len(AMBAR_FIS_CIKIS_MALIYET_2)>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
                                    </cfif>
                                </cfif>
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                            </cfif>
							<cf_wrk_html_td align="right" format="numeric">
                                <cfif isdefined("TOTAL_STOCK") and len(TOTAL_STOCK)>
                                    <cfset donem_sonu_stok=TOTAL_STOCK>
                                    <cfset page_totals[1][1] = page_totals[1][1] + wrk_round(TOTAL_STOCK,4)> <!---donem sonu stok--->
                                    #TLFormat(TOTAL_STOCK,4)#
                                <cfelse>
                                    #TLFormat(0,4)#
                                </cfif>
                            </cf_wrk_html_td>
							<cfif isdefined('attributes.display_cost')>
                                <cfif wrk_round(donem_sonu_stok) neq 0>
									<cfset donem_sonu_maliyet=(donem_sonu_stok*ds_urun_birim_maliyet)>
									<cfif donem_sonu_maliyet neq 0>
										<cfset page_totals[1][2] = page_totals[1][2] + (donem_sonu_maliyet/donem_sonu_kur_)> <!---donem sonu maliyet--->
										<cfset ds_toplam_maliyet = donem_sonu_maliyet/donem_sonu_kur_>
									</cfif>
									<cfif isdefined('attributes.is_system_money_2')>
										<cfset donem_sonu_maliyet2=(donem_sonu_stok*ds_urun_birim_maliyet2)>
										<cfif donem_sonu_maliyet2 neq 0>
											<cfset page_totals[1][63] = page_totals[1][63] + donem_sonu_maliyet2> <!---donem sonu maliyet 2--->											
											<cfset ds_toplam_maliyet2 =donem_sonu_maliyet2>
										</cfif>
									</cfif>
                                </cfif>
                                <cf_wrk_html_td width="82" align="right" nowrap format="numeric">
									#TLFormat(ds_toplam_maliyet)#
								</cf_wrk_html_td>
                                <cf_wrk_html_td>
									<cfif isdefined("attributes.display_cost_money")>
										#all_finish_money#
									<cfelse>
										#attributes.cost_money#	
									</cfif>
								</cf_wrk_html_td>
                                <cfif isdefined('attributes.is_system_money_2')>
                                    <cf_wrk_html_td align="right" nowrap format="numeric">
                                    	#TLFormat(ds_toplam_maliyet2)#
									</cf_wrk_html_td>
                                    <cf_wrk_html_td width="15" nowrap>
										<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
									</cf_wrk_html_td>
                                </cfif>
                                <cfif isdefined('attributes.display_ds_prod_cost')><!--- birim maliyet --->
                                    <cf_wrk_html_td align="right" nowrap format="numeric">
										<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet/donem_sonu_stok)#</cfif>
									</cf_wrk_html_td>
                                    <cf_wrk_html_td>
										<cfif wrk_round(donem_sonu_stok) neq 0>
											<cfif isdefined("attributes.display_cost_money")>
												#all_finish_money#
											<cfelse>
												#attributes.cost_money#	
											</cfif>
										</cfif>
									</cf_wrk_html_td>
									<cfif isdefined('attributes.is_system_money_2')>
										<cf_wrk_html_td align="right" nowrap format="numeric">
											<cfif wrk_round(donem_sonu_stok) neq 0>#TLFormat(ds_toplam_maliyet2/donem_sonu_stok)#</cfif>
										</cf_wrk_html_td>
										<cf_wrk_html_td width="15" nowrap>
											<cfif ds_toplam_maliyet2 neq 0>#session.ep.money2#</cfif>
										</cf_wrk_html_td>
									</cfif>
                                </cfif>
                            </cfif>
                            <cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
                            	<cfif len(.DIMENTION)>
									<cfif attributes.volume_unit eq 1>
										<cfset prod_volume = evaluate(.DIMENTION)>
									<cfelseif attributes.volume_unit eq 2>
										<cfset prod_volume = evaluate(.DIMENTION)/ 1000>
									<cfelseif attributes.volume_unit eq 3>
										<cfset prod_volume = evaluate(.DIMENTION) / 1000000>
									</cfif>
								</cfif>
								<cf_wrk_html_td align="right">
									<cfif len(.DIMENTION)>#prod_volume#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right">
									<cfif wrk_round(donem_sonu_stok) neq 0 and len(.DIMENTION)>#prod_volume*wrk_round(donem_sonu_stok)# </cfif>
								</cf_wrk_html_td>
							</cfif>
							<cfif isdefined('attributes.stock_age')>
                                <cfset agirlikli_toplam=0>
                                <cfif donem_sonu_stok gt 0>
                                    <cfset kalan=donem_sonu_stok>
                                    <cfquery name="GET_STOCK_AGE" DATASOURCE="#DSN#_REPORT">
				    	SELECT * FROM GET_STOCK_AGE
				    </CFQUERY>
				    <cfquery name="get_product_detail" dbtype="query">
                                        SELECT 
                                            AMOUNT AS PURCHASE_AMOUNT,
                                            GUN_FARKI 
                                        FROM 
                                            GET_STOCK_AGE 
                                        WHERE 
                                            #ALAN_ADI# =<cfif attributes.report_type eq 8>'#.PRODUCT_GROUPBY_ID#'<cfelse>#.PRODUCT_GROUPBY_ID#</cfif>
                                        ORDER BY ISLEM_TARIHI DESC
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
                                <cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
                                <cf_wrk_html_td nowrap="nowrap" align="right" format="numeric">
									#agırlıklı_toplam#
								</cf_wrk_html_td>
                            </cfif>
                        </cf_wrk_html_tr>
                    </cfoutput>
				</cfif>
			</cfif>
			<cfoutput>
			<cfif listfind('3,4,5,6,9,10',attributes.report_type)>
				<cf_wrk_html_tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<cf_wrk_html_td nowrap class="txtbold">Sayfa Toplam</cf_wrk_html_td>
					<cf_wrk_html_td align="right" format="numeric">
						#TLFormat(page_totals[1][1],4)#<!--- donem sonu stok --->
					</cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td align="right" nowrap="nowrap" colspan="2" format="numeric"><!--- donem sonu maliyet --->
							#TLFormat(page_totals[1][2])# <cfif page_totals[1][2] neq 0>#attributes.cost_money#</cfif>
						</cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td align="right" nowrap="nowrap" colspan="2" format="numeric"><!--- alıs maliyet  --->
								#TLFormat(page_totals[1][63])# <cfif page_totals[1][63] neq 0>#session.ep.money2#</cfif>
							</cf_wrk_html_td>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.stock_age')>
					<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					<cf_wrk_html_td nowrap="nowrap" align="right"></cf_wrk_html_td>
					</cfif>
				</cf_wrk_html_tr>
			<cfelse>
				<cf_wrk_html_tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<cfif attributes.report_type eq 1>
						<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
							<cfset temp_page_total_colspan_=7>
						<cfelse>
							<cfset temp_page_total_colspan_=6>	
						</cfif>
					<cfelseif attributes.report_type eq 2>
						<cfset temp_page_total_colspan_=5>
					<cfelse>
						<cfset temp_page_total_colspan_=7>
					</cfif>					
					<cf_wrk_html_td width="130" nowrap colspan="#temp_page_total_colspan_#" class="txtbold"> Sayfa Toplam </cf_wrk_html_td>
					<cf_wrk_html_td align="right" format="numeric">
						#TLFormat(page_totals[1][3],4)#<!--- donem bası stok --->
					</cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td align="right" nowrap format="numeric"><!--- donem bası maliyet --->
							<cfif not isdefined('attributes.display_cost_money')>#TLFormat(page_totals[1][4])#</cfif>
						</cf_wrk_html_td>
						<cf_wrk_html_td nowrap>
							<cfif page_totals[1][4] neq 0 and not isdefined('attributes.display_cost_money')>#attributes.cost_money#</cfif>
						</cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][64])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][64] neq 0>#session.ep.money2#</cfif>
							</cf_wrk_html_td>
						</cfif>
					</cfif>
					<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					<!--- alıs ve alıs iadeler bolumu --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
						<cf_wrk_html_td align="right" format="numeric"><!--- alıs miktar --->
							#TLFormat(page_totals[1][5],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric"><!--- alıs iade miktar --->
							#TLFormat(page_totals[1][6],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric"> <!--- net alıs  --->
							#TLFormat(page_totals[1][7],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowra format="numeric"p>
								#TLFormat(page_totals[1][8])#
							</cf_wrk_html_td> <!--- alıs maliyet  --->
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][8] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][9])#
							</cf_wrk_html_td><!--- alıs iade maliyet  --->
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][9] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][10])#
							</cf_wrk_html_td> <!--- net alıs maliyet --->
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][10] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][47])#
								</cf_wrk_html_td><!--- alıs maliyet  --->
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][47] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][48])#
								</cf_wrk_html_td><!--- alıs iade maliyet  --->
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][48] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][49])#
								</cf_wrk_html_td><!--- net alıs maliyet --->
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][49] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- satıs ve satıs iade bolumu --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
						<cf_wrk_html_td align="right" format="numeric">#TLFormat(page_totals[1][13],4)#</cf_wrk_html_td> <!--- satıs miktar  --->
						<cf_wrk_html_td align="right" format="numeric">#TLFormat(page_totals[1][14],4)#</cf_wrk_html_td><!--- satıs iade miktar  --->
						<cf_wrk_html_td align="right" format="numeric">#TLFormat(page_totals[1][15],4)#</cf_wrk_html_td><!---net satıs miktar  --->
						<cfif isdefined('attributes.from_invoice_actions')><!--- fatura hareketlerinden satış-satış iade miktar ve tutar --->
							<cf_wrk_html_td align="right" format="numeric">
								#TLFormat(page_totals[1][42],4)#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric">
								#TLFormat(page_totals[1][43])#
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td align="right" nowrap colspaln="2" format="numeric"><!--- fatura satıs tutarı sistem 2. para br cinsinden --->
								#TLFormat(page_totals[1][66])#
							</cf_wrk_html_td>
							</cfif>
							<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
								<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric"> <!--- fatura satış maliyeti --->
									#TLFormat(page_totals[1][102])#
								</cf_wrk_html_td>
								<cfif isdefined('attributes.is_system_money_2')>
									<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
										#TLFormat(page_totals[1][103])#
									</cf_wrk_html_td>
								</cfif>
							</cfif>
							<cf_wrk_html_td align="right" format="numeric">
								#TLFormat(page_totals[1][44],4)#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric">
								#TLFormat(page_totals[1][45])#
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
								#TLFormat(page_totals[1][67])#
							</cf_wrk_html_td>
							</cfif>
							<cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
								<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric">
									#TLFormat(page_totals[1][104])#
								</cf_wrk_html_td>
								<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap colspan="2" format="numeric"><!--- fatura satıs iade tutarı sistem 2. para br cinsinden --->
									#TLFormat(page_totals[1][105])#
								</cf_wrk_html_td>
								</cfif>
							</cfif>
						</cfif>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][16])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][16] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][17])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][17] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][18])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][18] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<!--- net fatura satış maliyeti --->
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][101])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][101] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][50])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][50] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][51])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][51] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][65])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][65] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- Konsinye cikis irs. --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][19],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][20])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][20] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][52])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][52] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- konsinye iade gelen --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][21],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][22])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][22] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][53])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][53] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- konsinye giriş --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][95],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][96])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][96] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][97])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][97] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- konsinye giriş iade --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][98],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][99])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][99] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][100])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][100] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- Teknik Servis Giriş --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][23],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][24])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][24] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][54])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][54] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- Teknik Servis Çıkış --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][25],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][26])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][26] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][55])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][55] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- RMA Giriş --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][27],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap="nowrap" format="numeric">
								#TLFormat(page_totals[1][28])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap="nowrap">
								<cfif page_totals[1][28] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap="nowrap" format="numeric">
									#TLFormat(page_totals[1][56])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap="nowrap">
									<cfif page_totals[1][56] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- RMA Çıkış --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][29],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][30])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][30] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][57])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][57] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- uretim fisleri --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][31],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowra format="numeric"p>
								#TLFormat(page_totals[1][32])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][32] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][58])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][58] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- sarf ve fire fisleri --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][33],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][70],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][34],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][35])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][35] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][71])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][71] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][36])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][36] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">#TLFormat(page_totals[1][59])#</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][59] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">#TLFormat(page_totals[1][72])#</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][72] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">#TLFormat(page_totals[1][60])#</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][60] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- sayim fisleri --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][37],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][68])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][68] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][69])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][69] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- demontajdan giris --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][38],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][39])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][39] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][61])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][61] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- demontaja giden --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][40],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][41])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][41] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][62])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][62] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- masraf fişleri --->
					<cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][73],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowra format="numeric"p>
								#TLFormat(page_totals[1][74])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][74] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][75])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][75] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!--- depo sevk --->
					<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][77],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][78],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][79])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][79] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][80])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][80] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][81])# 
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][81] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][82])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][82] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!---ithal mal girisi --->
					<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][83],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][84],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][85])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][85] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][86])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][86] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][87])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][87] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">
									#TLFormat(page_totals[1][88])#
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									<cfif page_totals[1][88] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<!---ambar fişi --->
					<cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][89],4)#
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" format="numeric">
							#TLFormat(page_totals[1][90],4)#
						</cf_wrk_html_td>
						<cfif isdefined('attributes.display_cost')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][91])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][91] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][92])#
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								 <cfif page_totals[1][92] neq 0>#attributes.cost_money#</cfif>
							</cf_wrk_html_td>
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap format="numeric">#TLFormat(page_totals[1][93])# </cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][93] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap format="numeric">#TLFormat(page_totals[1][94])# </cf_wrk_html_td>
								<cf_wrk_html_td align="right" nowrap>
									 <cfif page_totals[1][94] neq 0>#session.ep.money2#</cfif>
								</cf_wrk_html_td>
							</cfif>
						</cfif>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
					</cfif>
					<cf_wrk_html_td align="right" format="numeric">
						#TLFormat(page_totals[1][1],4)#
					</cf_wrk_html_td>
					<cfif isdefined('attributes.display_cost')>
						<cf_wrk_html_td align="right" nowrap format="numeric">
							<cfif not isdefined('attributes.display_cost_money')>#TLFormat(page_totals[1][2])#</cfif>
						</cf_wrk_html_td>
						<cf_wrk_html_td nowrap>
							<cfif page_totals[1][2] neq 0 and not isdefined('attributes.display_cost_money')>#attributes.cost_money#</cfif>
						</cf_wrk_html_td>
						<cfif isdefined('attributes.is_system_money_2')>
							<cf_wrk_html_td align="right" nowrap format="numeric">
								#TLFormat(page_totals[1][63])# 
							</cf_wrk_html_td>
							<cf_wrk_html_td align="right" nowrap>
								<cfif page_totals[1][63] neq 0>#session.ep.money2#</cfif>
							</cf_wrk_html_td>
						</cfif>
						<cfif isdefined('attributes.display_ds_prod_cost')>
							<cf_wrk_html_td align="right" nowrap colspan="2"></cf_wrk_html_td><!--- birim maliyet --->
							<cfif isdefined('attributes.is_system_money_2')>
								<cf_wrk_html_td align="right" nowrap colspan="2"></cf_wrk_html_td><!--- birim maliyet --->
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)><!--- birim ve toplam hacim  --->
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"></cf_wrk_html_td>
					</cfif>
					<cfif isdefined('attributes.stock_age')>
						<cf_wrk_html_td class="color-header" width="1"></cf_wrk_html_td>
						<cf_wrk_html_td class="txtboldblue" nowrap="nowrap" align="right"></cf_wrk_html_td>
					</cfif>
				</cf_wrk_html_tr>
			</cfif>
			<!--- sayfa toplamları yazdırılıyor --->
			</cfoutput>
		<cfelse>
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
			<cf_wrk_html_tr class="color-list" height="22">
				<cf_wrk_html_td colspan="48"><cfif isdefined("attributes.is_form_submitted")>Kayıt Yok !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></cf_wrk_html_td>
			</cf_wrk_html_tr>
			</cfoutput>
		</cfif>
	</cf_wrk_html_table>--->
    <cfif isdefined("attributes.is_form_submitted")>
    <cfform name="stock_analyse">
        <cfgrid format="html" name="parkGrid" pagesize="50" selectmode="row" bind="cfc:cfc.stock_report.getStock({cfgridpage},{cfgridpagesize},{cfgridsortcolumn},{cfgridsortdirection})">
            <cfif listfind('1,8',attributes.report_type,',')>
				<cfgridcolumn name="STOCK_CODE" width="300" header="STOK KODU" />	
            </cfif>
            <cfif attributes.report_type eq 1>
				<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
                   <cfgridcolumn name="stock_code_2" width="180" header="Özel kod" /> 
                </cfif>
    		</cfif> 
			<cfif attributes.report_type eq 1><cfset baslik = 'Stok'>
				<cfelseif attributes.report_type eq 2><cfset baslik = 'Ürün'> 
				<cfelseif attributes.report_type eq 3><cfset baslik = 'Kategori'>
				<cfelseif attributes.report_type eq 4><cfset baslik = 'Sorumlu'>
				<cfelseif attributes.report_type eq 5><cfset baslik = 'Marka'>
				<cfelseif attributes.report_type eq 6><cfset baslik = 'Tedarik'>
				<cfelseif attributes.report_type eq 8><cfset baslik = 'Stok'>
				<cfelseif attributes.report_type eq 9><cfset baslik = 'Depo'>
				<cfelseif attributes.report_type eq 10><cfset baslik = 'Lokasyon'>
			</cfif>
			<cfif listfind('1,8',attributes.report_type,',') and not listfind('1,2',attributes.is_excel)>
                <cfgridcolumn name="ACIKLAMA"  header="#baslik#" />
            </cfif>
            <cfif listfind('1,2,8',attributes.report_type)>					
				 <cfgridcolumn name="BARCOD"  header="Barkod" />  
            </cfif>            
            <cfif attributes.report_type eq 8>
				<cfgridcolumn name="SPECT_VAR_ID"  header="Main Spec" />
    		</cfif>
            <cfif listfind('1,2,8',attributes.report_type)>					
				  <cfgridcolumn name="PRODUCT_CODE"  header="Ürün Kodu" />
            </cfif>
            <cfgridcolumn name="MANUFACT_CODE"  header="Üretici Kodu" />
            <cfgridcolumn name="MAIN_UNIT"  header="Birim" />
            <cfif isdefined("GET_ALL_STOCK.DB_STOK_MIKTAR")>
                 <cfgridcolumn name="DB_STOK_MIKTAR"  header="Stok Miktarı" />
    		</cfif>  
            <cfif isdefined('attributes.display_cost')>
				<cfgridcolumn name="STOK_MALIYET"  header="Stok Maliyeti" />
            	<cfif isdefined("attributes.display_cost_money")>
                    <cfgridcolumn name="all_start_money"  header="Stok Maliyeti2" />
        		</cfif>
                <cfif isdefined('attributes.is_system_money_2')>
                    <cfgridcolumn name="Maliyet"  header="Maliyet" />
        		</cfif>
			</cfif>
			<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
				<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS") >
                    <cfgridcolumn name="TOPLAM_ALIS"  header="Alım Miktarı" />
                </cfif>
				<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE") >
                    <cfgridcolumn name="TOPLAM_ALIS_IADE"  header="Alım İade Miktarı" />
                </cfif>
                <cfgridcolumn name="Net_Alim_Miktari"  header="Net Alım Miktarı" />
        		<cfif isdefined('attributes.display_cost')>
					<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET1")>
                        <cfgridcolumn name="TOPLAM_ALIS_MALIYET1"  header="Alım Tutar" />
                    </cfif>
					<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET1") >
                        <cfgridcolumn name="TOPLAM_ALIS_IADE_MALIYET1"  header="Alım İade Tutarı" /> 
                    </cfif>
                    <cfgridcolumn name="Net_Alim_Tutari"  header="Net Alım Tutarı" />
					<cfif isdefined('attributes.is_system_money_2')>
						<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2")>
                            <cfgridcolumn name="TOPLAM_ALIS_MALIYET_2"  header="Alım Tutar 2" />
                        </cfif>
						<cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2")>
                             <cfgridcolumn name="TOPLAM_ALIS_IADE_MALIYET1_2"  header="Alım İade Tutarı 2" />
                        </cfif>
                       <cfgridcolumn name="Net_Alim_Tutari_2"  header="Net Alım Tutarı 2" />
                	</cfif>
				</cfif>
            </cfif>
        </cfgrid>
    </cfform>
    </cfif>
	</cfif>
</cfif>
 
<script type="text/javascript">
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
		if (document.rapor.location_based_cost.checked && list_len(document_name,',') != 1 && (document.rapor.report_type.value == 1 || document.rapor.report_type.value == 2))
		{
			alert("Lokasyon Bazında Maliyet Gösterebilmek İçin Bir Lokasyon Seçmelisiniz !");
			return false;
		}
		if(document.rapor.display_cost_money.checked == true && ! list_find('1,2,8',document.rapor.report_type.value))
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
			if(list_len(document_name,',') > 1 || list_len(document_name,',') == 0)
			{
				alert("Lokasyon Bazında Rapor Alabilmek İçin Depo Seçmelisiniz !");
				return false;
			}
		}
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
		}
		else
		{
			document.getElementById('member_report_type2').style.display='none';
			document.getElementById('member_report_type1').style.display='';
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
