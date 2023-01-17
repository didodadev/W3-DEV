<!--- 
	Süreç Yönetimi - Tufan Çakiroglu - 12/10/2004
	FBS 20100706 iliskili sirket kontrolleri eklendi.
	FBS 20120607 query ve cfclerde duzenleme-iyilestirme yapildi.
	FBS 20120928 session duzenlemeleri yapildi, schedule kullanimlarinda session yerine tanimlanan ifadeler nedeniyle sayfada direkt session degeri kullanmayiniz
	upd : 22/11/2019 Uğur Hamurpet - Workflow üzerinden aksiyonların yönetimi için düzenlemeler yapıldı
	
	Kullanilan Parametreler;
	data_source				: (Action) Sayfadan gonderilen data_source degeri sayesinde surecler transaction icerisinde kullanilabilir.
	action_page				: (Action) Surecten giden onay/uyarilardaki link bu parametre ile action sayfasindan gonderilir.
	action_id				: (Action) Surecten giden onay/uyarilardaki id bu parametre ile action sayfasindan gonderilir.
	action_column			: (Action) Surecten giden onay/uyarilardaki ilgili tablonun ID adi bu parametre ile action sayfasindan gonderilir.
	action_table			: (Action) Surecten giden onay/uyarilardaki ilgili TABLO adi bu parametre ile action sayfasindan gonderilir.
	new_comp_id				: (Action) Surecten giden onay/uyarilardaki company_id bu parametre ile action sayfasindan gonderilir.
	fusepath				: (Display) Surecin fuseactionu manuel gonderilmek istendiginde kullanilir
	onclick_function		: (Display) Sureclerin formlarda geldigi selectbox icin fonksiyon eklenmesini saglar.
	tabindex				: (Display) Sureclerin formlarda geldigi selectbox icin tabindex eklenmesini saglar.
	process_cat_width		: (Display) Sureclerin formlarda geldigi selectbox icin width eklenmesini saglar.
	select_value			: (Display) Belgenin guncelleme sayfasi olmasi durumunda bulundugu asamayi getirir.
	extra_process_row_id	: (Display) Cekilen icerik gelen belirli Id ler ile cekilir.(Project.addwork)
	* is_upd				: (Action/Display) Surecin action mu yoksa form sayfasından mi calistigini gösterir; 0 ise form 1, ise query anlamina gelir.
	* is_detail				: (Action/Display) Ekleme yada guncelleme sayfası oldugunu gösterir; 0 ekleme, 1 guncelleme anlamina gelir.
	* process_stage			: (Action) Belgede surecin bulundugu asamayi getirir.
	* old_process_line		: (Action) Belgede surecin bir onceki asamasinin LINE_NUMBER bilgisini getirir. (Ayni asamadaki filelarin calismamasi kontrollerinde kullanilir)
	* record_member			: (Action) Surecten giden onay/uyarilardaki kaydeden bu parametre ile action sayfasindan gonderilir.
	* record_date			: (Action) Surecten giden onay/uyarilardaki tarih bu parametre ile action sayfasindan gonderilir.
	* warning_description	: (Action) Surecten giden onay/uyarilardaki aciklama bu parametre ile action sayfasindan gonderilir.
	get_faction_recordcount	: (Action/Display) Surecteki toplam asama sayisini getirir, ilgili formdan cekilebilir. (get_faction_recordcount eq 1 vb)

	Ornek Kullanimlar;
	<cf_workcube_process is_upd='0' select_value='#get_order_detail.order_stage#' process_cat_width='125' is_detail='1'>
	<cf_workcube_process
		is_upd="1"
		data_source="#dsn#"
		old_process_line="#attributes.old_process_line#"
		process_stage="#attributes.process_stage#"
		record_member="#session.ep.userid#"
		record_date="#now()#"
		action_table="ORDERS"
		action_column="ORDER_ID"
		action_id="#attributes.order_id#"
		action_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_order&order_id=#attributes.order_id#"
		warning_description="Sipariş : #paper_full#">
--->

<cfparam name="attributes.caller" type="struct" default="#structNew()#">
<cfset caller = (structCount( attributes.caller )) ? attributes.caller : caller>
<cfif not isdefined("attributes.extra_process_row_id")><cfset attributes.extra_process_row_id = "-1"></cfif><!--- Is Sureclerinde Kullaniliyor --->

<cfif not isdefined("attributes.fuseaction")>
	<cfset attributes.fuseaction = (structKeyExists(caller.attributes, "fuseaction"))?caller.attributes.fuseaction:'xxx'>
</cfif>

<cfif not isdefined("attributes.page_name")>
	<cfset attributes.page_name = (structKeyExists(caller.attributes, "param_1"))?caller.attributes.param_1:''>
</cfif>

<cfparam name="attributes.data_source" default="#caller.dsn#">
<cfparam name="attributes.select_name" default="process_stage"><!---- Select ismi(listeleme sayfalarında toplu onay ile karışıyor) --->
<cfparam name="attributes.fusepath" default="#attributes.fuseaction#">
<cfparam name="attributes.extra_process_id" default="">
<cfparam name="attributes.action_table" default="">
<cfparam name="attributes.action_column" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.action_page" default="">
<cfparam name="attributes.onclick_function" default="">
<cfparam name="attributes.tabindex" default="">
<cfparam name="attributes.position_code" type="numeric" default="0">
<cfparam name="attributes.mandate_position_code" type="numeric" default="0"><!--- Vekaleten yapılan işlemlerde vekalet edilen kişinin position_code değeri gönderilir --->
<cfparam name="attributes.type" type="string" default="">
<cfparam name="attributes.is_select_text" type="string" default=""><!--- Seçiniz yazısı gelsin --->
<cfparam name="attributes.general_paper_id" type="numeric" default="0">
<cfparam name="attributes.actions" type="string" default="#(isDefined('caller.attributes.actions')) ? caller.attributes.actions : ''#"><!--- Belge içerisinde yapılan aksiyon (Onay, red vs.) --->
<cfparam name="attributes.warning_id" type="string" default="#(isDefined('caller.attributes.warning_id')) ? caller.attributes.warning_id : ''#"><!--- Belge içerisinde onaylanan uyarı id ---->
<cfparam name="attributes.is_notification" type="boolean" default="0">
<cfparam name="attributes.paper_no" type="string" default="">
<cfparam name="attributes.warning_access_code" type="string" default="">
<cfparam name="attributes.warning_password" type="string" default="">
<cfparam name="attributes.wrkflow" type="string" default="">
<cfparam name="attributes.pathinfo" type="string" default="">


<cfif attributes.data_source eq caller.dsn><cfset process_db = ""><cfelse><cfset process_db = caller.dsn&"."></cfif><!--- Transaction Icin dsn Tanimi --->
<cfset attributes.wrkflow = len(attributes.wrkflow) ? attributes.wrkflow : (IsDefined("caller.attributes.wrkflow") ? caller.attributes.wrkflow : 0) />
<cfset attributes.pathinfo = len(attributes.pathinfo) ? attributes.pathinfo : cgi.query_string />

<cfset session_position_code = "">
<cfset session_partner_id = "">
<!--- Session tanimlari --->
<cfif isdefined('session.ep')>
	<cfset module_type = "e">
	<cfset my_our_company_id_ = session.ep.company_id>
	<cfset lang = session.ep.language>
	<cfset session_position_code = session.ep.position_code>
	<cfset session_period_id = session.ep.period_id>
	<cfset my_our_company_name_ = session.ep.company>
	<cfset my_our_company_email_ = session.ep.company_email>
	<cfset session_time_zone = session.ep.time_zone>
<cfelseif isdefined('session.pda')>
	<cfset module_type = "e">
	<cfset my_our_company_id_ = session.pda.our_company_id>
	<cfset lang = session.pda.language>
	<cfset session_position_code = session.pda.position_code>
	<cfset session_period_id = session.pda.period_id>
	<cfset my_our_company_name_ = "">
	<cfset my_our_company_email_ = "">
	<cfset session_time_zone = session.pda.time_zone>
<cfelseif isdefined('session.pp')>
	<cfset module_type = "p">
	<cfset my_our_company_id_ = session.pp.our_company_id>
	<cfset lang = session.pp.language>
	<cfset session_partner_id = session.pp.userid>
	<cfset session_period_id = session.pp.period_id>
	<cfset my_our_company_name_ = session.pp.our_name>
	<cfset my_our_company_email_ = session.pp.our_company_email>
	<cfset session_time_zone = session.pp.time_zone>
<cfelseif isdefined('session.ww')>
	<cfset module_type = "w">
	<cfset my_our_company_id_ = session.ww.our_company_id>
	<cfset lang = session.ww.language>
    <cfif isdefined('session.ww.userid')>
		<cfset session_partner_id = session.ww.userid>
    <cfelse>
		<cfset session_partner_id = ''>    
	</cfif>
	<cfset session_period_id = session.ww.period_id>
    <cfif isdefined('session.ww.userid')>
		<cfset my_our_company_name_ = session.ww.our_name>
		<cfset my_our_company_email_ = session.ww.our_company_email>
    <cfelse>
		<cfset my_our_company_name_ = ''> 
		<cfset my_our_company_email_ = ''>  
	</cfif>
	<cfset session_time_zone = session.ww.time_zone>
<cfelseif isdefined('session.wp')>
	<cfset module_type = "w">
	<cfset my_our_company_id_ = session.wp.our_company_id>
	<cfset lang = session.wp.language>
	<cfset session_period_id = session.wp.period_id>
	<cfset my_our_company_name_ = session.wp.company>
	<cfset my_our_company_email_ = session.wp.our_company_email>
	<cfset session_time_zone = session.wp.time_zone>
<cfelse>
	<cfset module_type = "w">
	<cfset my_our_company_id_ = caller.my_our_company_id_>
	<cfset lang = caller.lang>
	<cfset session_position_code = caller.session_position_code>
	<cfset session_period_id = caller.period_id>
	<cfset my_our_company_name_ = caller.my_our_company_name_>
	<cfset my_our_company_email_ = caller.my_our_company_email_>
	<cfset session_time_zone = caller.session_time_zone>
</cfif>
<cfif isdefined('attributes.new_comp_id')><cfset my_our_company_id_ = attributes.new_comp_id></cfif><!--- Siparisler Sureclerinde kullanılıyor --->
<!--- //Session tanimlari --->

<cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process") />
<cfset Cmp.data_source = attributes.data_source />
<cfset Cmp.process_db = process_db />
<cfset Cmp.module_type = module_type />
<cfset Cmp.my_our_company_id_ = my_our_company_id_ />
<cfset Cmp.lang = lang />
<cfif not (isDefined("attributes.select_value") and Len(attributes.select_value))><cfset attributes.select_value = 0></cfif>
<!---
	Uğur Hamurpet - 02/01/2020
	Süreç aşamalarının rekli olarak görüntülenmesini sağlar. 
	Aşama sırasına göre arkaplan ve yazı rengi verir 
--->
<cfif len( attributes.type )>
	<cfif attributes.type eq 'color-status' and isDefined("attributes.process_stage") and len( attributes.process_stage )>

		<cfset get_ProcessType = Cmp.get_ProcessType(
			fuseaction		: attributes.fusepath
		) />
		<cfset get_Process_Type_1 = Cmp.get_Process_Type_1(
			process_id	: get_ProcessType.PROCESS_ID
		) />

		<cfset process_rows_color = {
			1 : { backgroundColor : "rgba(10,187,135,0.1)", color : "##0abb87" }, <!--- Yeşil --->
			2 : { backgroundColor : "rgba(204,114,21,0.1)", color : "##f37923" }, <!--- Turuncu --->
			3 : { backgroundColor : "rgba(93,120,255,0.1)", color : "##5d78ff" }, <!--- Mavi --->
			4 : { backgroundColor : "rgba(241,226,57,0.1)", color : "##deea22" }, <!--- Sarı --->
			5 : { backgroundColor : "rgba(82,172,181,0.1)", color : "##21dcef" }, <!--- Turkuaz --->
			6 : { backgroundColor : "rgba(183,47,148,0.1)", color : "##bb3291" }, <!--- Mor --->
			7 : { backgroundColor : "rgba(228,22,22,0.1)", color : "##d01818" }, <!--- Kırmızı Koyu --->
			8 : { backgroundColor : "rgba(187,67,10,0.1)", color : "##b94b0b" }, <!--- Turuncu Koyu --->
			9 : { backgroundColor : "rgba(253,57,122,0.1)", color : "##fd397a" }, <!--- Kırmızı --->
			10: { backgroundColor : "rgba(206,40,236,0.1)", color : "##ff22f8" } <!--- Menekşe --->
		}/>
		
		<cfif get_Process_Type_1.recordcount>
			<cfoutput query="get_Process_Type_1">
				<cfif PROCESS_ROW_ID eq attributes.process_stage>
					<cfif LINE_NUMBER lte 10><span class="ui-stage" style="background-color: #process_rows_color[LINE_NUMBER]['backgroundColor']#; color: #process_rows_color[LINE_NUMBER]['color']#;">#STAGE#</span>
					<cfelse><span class="ui-stage" style="background-color:##E8E6E6; color:##000000;" >#STAGE#</span></cfif>
				</cfif>
			</cfoutput>
		</cfif>

	</cfif>
<cfelse>
	<cfif attributes.is_upd eq 0>
		<!--- Surec Formdan Calisiyorsa --->
		
		<!--- (PROCESS_TYPE,PROCESS_TYPE_OUR_COMPANY) Sureclerin Aktiflik ve Sirket Yetkilerine Gore Gelip Gelmemesi Kontrol Edilir- Fuseactiona Bakilarak --->
		<cfset get_ProcessType = Cmp.get_ProcessType(
			our_company_id	: my_our_company_id_,
			fuseaction		: attributes.fusepath,
			extra_process_id : attributes.extra_process_id,
			page_name : attributes.page_name
			) />
		
		<cfset get_Faction = Cmp.get_Faction(
			extra_process_row_id: attributes.extra_process_row_id,
			fuseaction			: attributes.fusepath,
			position_code		: session_position_code,
			partner_id			: session_partner_id,
			wrkflow				: attributes.wrkflow,
			pathinfo 			: attributes.pathinfo
			) />
		<cfset caller.get_faction_recordcount = get_faction.recordcount>
		<!--- Asamada Display_File Burada Çalisacak - Include --->
		<cfset get_File_Name = Cmp.get_File_Name(
			select_value	: attributes.select_value
			) />
		<script type="text/javascript">
			function process_cat_dsp_function()
			{
				return true;
			}
		</script>
		<!--- Buradaki faction list parametresini, bir belgede birden fazla surec varsa sadece yetkili olduklarimiz gelsin diye ekledik, aksi taktirde butun surecler dokuluyor fbs 20140805 --->
		<cfset get_Main_Files = Cmp.get_ProcessType(
			our_company_id		: my_our_company_id_,
			fuseaction			: attributes.fusepath,
			select_value		: attributes.select_value,
			extra_process_id 	: attributes.extra_process_id,
			faction_list		: ValueList(get_Faction.process_row_id)
			) />
		<cfif get_Main_Files.is_main_action_file eq 1>
			<cfif len(get_main_files.main_action_file)>
				<cfinclude template="#caller.dir_seperator#V16#caller.dir_seperator#process#caller.dir_seperator#files#caller.dir_seperator##get_main_files.main_action_file#">
			</cfif>
		<cfelse>
			<cfif len(get_Main_Files.main_action_file)>
				<!--- use_script_on_process ifadesi parama eklendi, musterilerin kullanimlari farklilik gosterdigi icin tanima gore sekillenmesi saglandi FBS 20120420 --->
				<cfif (isDefined("caller.use_script_on_process") and caller.use_script_on_process eq 1) or not isDefined("caller.use_script_on_process")>
					<script type="text/javascript" src="<cfoutput>#request.self#?fuseaction=home.emptypopup_process_functions&get_procees_file=#caller.file_web_path#settings#caller.dir_seperator##get_main_files.main_action_file#</cfoutput>"></script>
				<cfelse>
					<!---  Bu kisim gerekli olan musterilerde yukaridaki satirin yerine kullanilacak (script duzenlemeleri yapilmamis musteriler icin) --->
					<cfinclude template="#caller.file_web_path#settings#caller.dir_seperator##get_main_files.main_action_file#">
				</cfif>
			</cfif>
		</cfif>
		<cfif len(get_file_name.display_file_name)>
			<cfif get_file_name.is_display_file_name eq 1>
				<cfinclude template="#caller.dir_seperator#V16#caller.dir_seperator#process#caller.dir_seperator#files#caller.dir_seperator##get_file_name.display_file_name#">
			<cfelse>
				<cfinclude template="#caller.file_web_path#settings#caller.dir_seperator##get_file_name.display_file_name#">
			</cfif>
		</cfif>
		<cfif attributes.is_detail eq 0>
			<!--- Ekleme sayfasi ise --->
			<cfif get_faction.recordcount>
				<select class="form-control" name="<cfoutput>#attributes.select_name#</cfoutput>" id="<cfoutput>#attributes.select_name#</cfoutput>" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
					<cfif isdefined("attributes.is_select_text") and attributes.is_select_text eq 1>
						<option value="" ><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
					</cfif>	
					<cfoutput query="get_faction">
						<option value="#process_row_id#" <cfif isdefined("attributes.select_value") and (process_row_id eq attributes.select_value)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
					</cfoutput>
				</select>
			<cfelse>
				<select class="form-control" name="process_stage" id="process_stage" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
					<option value=""><cfoutput>#caller.getLang('main',561)#</cfoutput></option><!--- 561.Yetkisiz --->
				</select>
				<script language="javascript">
					alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>");
				</script>			
			</cfif>
			<cfset is_Main_Display_Include = get_faction.is_Display>
		<cfelse>
			<!--- Update sayfasi ise --->
			<cfif get_faction.recordcount>
				<cfset get_Line_Number = Cmp.get_Line_Number(
					select_value	: attributes.select_value
				) />
				<input type="hidden" name="old_process_line" id="old_process_line" value="<cfoutput>#get_line_number.line_number#</cfoutput>">
				<input type="hidden" name="old_process_stage" id="old_process_stage" value="<cfoutput>#attributes.select_value#</cfoutput>">
				<!--- get_line_number.is_stage_back degerine gore LINE_NUMBER where kosuluna girer yada girmez (Aşamalar Geriye Dönebilir olayi) --->
				<cfset get_Select_Line0 = Cmp.get_Select_Line0(
					extra_process_row_id: attributes.extra_process_row_id,
					fuseaction			: attributes.fusepath,
					position_code		: session_position_code,
					partner_id			: session_partner_id,
					select_value		: attributes.select_value,
					wrkflow				: attributes.wrkflow,
					pathinfo 			: attributes.pathinfo
					) />
				
				<cfset get_Select_Line1 = Cmp.get_Select_Line1(
					select_value	: attributes.select_value
					) />

				<cfset get_Select_Line = Cmp.get_Select_Line() />
				<cfif get_Select_Line1.recordcount>
					<!--- get_select_line halini kaldirdim, cunku asamasi olmayan bir islem detayinda yetkili oldugum asamalardan biri geliyordu-yanlis-, sorun yaratirsa detayli bakilacak fbs20120918 --->
					<cfoutput query="get_select_line">
						<input type="hidden" name="line_stage_number#process_row_id#" id="line_stage_number#process_row_id#" value="#line_number#">
						<input type="hidden" name="is_continue#process_row_id#"  id="is_continue#process_row_id#"value="#get_select_line.is_continue#">
					</cfoutput>

					<!---
						Uğur Hamurpet - 19/02/2020
						Güncelleme formlarında, kullanıcı süreçte varsa ve kendisinden onay isteniyorsa belge içerisinden onay verilebilmesi için düzenleme yapıldı. 
					--->
					<cfif len( attributes.action_id ) and len( attributes.select_value )>

						<cfset get_page_warning = Cmp.get_page_warning(
							action_id : attributes.action_id,
							action_stage_id : attributes.select_value,
							fuseact : attributes.fusepath
						)>

					<cfelse>
						<cfset get_page_warning.recordcount = 0>
					</cfif>
					<cfif get_page_warning.recordcount and get_page_warning.CONFIRM_REQUEST>

						<input type="hidden" name="warning_id" id="warning_id" value="<cfoutput>#get_page_warning.W_ID#</cfoutput>">
						<div class="input-group">
							<select class="form-control" name="process_stage" id="process_stage" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif isdefined("attributes.select_value")>onChange="process_cat_kontrol_first()"<cfelse><cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif></cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
								<!--- select_value ifadesinin degeri kontrol ediliyor. selectbox un secili gelmemesi adina  --->
								<cfif get_select_line.recordcount eq 0><option value=""><cfoutput>#caller.getLang('main',2018)#</cfoutput></option></cfif><!--- 2018.Aşamasız --->
								<cfoutput query="get_select_line">
									<option value="#process_row_id#" <cfif isdefined("attributes.select_value") and (process_row_id eq attributes.select_value)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
								</cfoutput>
							</select>
							<span class="input-group-addon no-bg"></span>
							<select class="form-control" name="actions" id="actions">
								<cfif get_page_warning.IS_CONFIRM><option value="confirm">Onayla</option></cfif>
								<cfif get_page_warning.IS_REFUSE><option value="refuse">Reddet</option></cfif>
								<cfif get_page_warning.IS_AGAIN><option value="again">Tekrar Yap</option></cfif>
								<cfif get_page_warning.IS_SUPPORT><option value="support">Destek Al</option></cfif>
								<cfif get_page_warning.IS_CANCEL><option value="cancel">İptal Et</option></cfif>
							</select>
						</div>

						<script>
							document.querySelector("#process_stage").addEventListener("change", (event) => {
								if( event.target.value != '<cfoutput>#attributes.select_value#</cfoutput>' ) document.getElementById("actions").disabled = true;
								else document.getElementById("actions").disabled = false;
							});
						</script>

					<cfelse>
						
						<select class="form-control" name="process_stage" id="process_stage" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif isdefined("attributes.select_value")>onChange="process_cat_kontrol_first()"<cfelse><cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif></cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
							<!--- select_value ifadesinin degeri kontrol ediliyor. selectbox un secili gelmemesi adina  --->
							<cfif get_select_line.recordcount eq 0><option value=""><cfoutput>#caller.getLang('main',2018)#</cfoutput></option></cfif><!--- 2018.Aşamasız --->
							<cfoutput query="get_select_line">
								<option value="#process_row_id#" <cfif isdefined("attributes.select_value") and (process_row_id eq attributes.select_value)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
							</cfoutput>
						</select>

					</cfif>
					
				<cfelse>
					<select class="form-control" name="process_stage" id="process_stage" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif len(attributes.onclick_function)>onChange="<cfoutput>#attributes.onclick_function#</cfoutput>;"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
					<cfif get_Line_Number.recordcount>
						<cfoutput query="get_Line_Number">
							<option value="#process_row_id#"><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
						</cfoutput>
					<cfelse>
						<option value=""><cfoutput>#caller.getLang('main',2018)#</cfoutput></option><!--- 2018.Aşamasız --->
						<cfif get_select_line.recordcount>
							<cfoutput query="get_select_line">
								<option value="#process_row_id#" <cfif isdefined("attributes.select_value") and (process_row_id eq attributes.select_value)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
							</cfoutput>
						<cfelseif get_faction.recordcount>
							<cfoutput query="get_faction">
								<option value="#process_row_id#" <cfif isdefined("attributes.select_value") and (process_row_id eq attributes.select_value)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
							</cfoutput>
						</cfif>
					</cfif>
					</select>
				</cfif>
			<cfelse>
				<cfset get_Line_Number = Cmp.get_Line_Number(
					select_value	: attributes.select_value
					) />
				<input type="hidden" name="old_process_line" id="old_process_line"value="<cfoutput>#get_line_number.line_number#</cfoutput>">
				<input type="hidden" name="is_continue" id="is_continue" value="<cfoutput>#get_line_number.is_continue#</cfoutput>">
				<select class="form-control" name="process_stage" id="process_stage" <cfif isdefined("attributes.process_cat_width")>style="width:<cfoutput>#attributes.process_cat_width#</cfoutput>px;"</cfif> <cfif len(attributes.tabindex)>tabindex="<cfoutput>#attributes.tabindex#</cfoutput>"</cfif>>
					<option value=""><cfoutput>#caller.getLang('main',561)#</cfoutput></option><!--- 561.Yetkisiz --->
				</select>
			</cfif>
			<cfset is_Main_Display_Include = get_Line_Number.is_Display>
		</cfif>

		<cfif not (isdefined("attributes.is_mobile") and attributes.is_mobile eq 1)><!---Mobil projede include ettigim için js kısmını kapatıyorum py 061212 --->
			<cfif isdefined("attributes.select_value")>
				<!--- 562.Onay Süreci Geriye Dogru Döndürülemez ! --->
				<script type="text/javascript">
					function process_cat_kontrol_first()
					{
						if(eval('document.all.line_stage_number'+document.getElementById("process_stage").value) < <cfoutput>#attributes.select_value#</cfoutput>)
						{
							alertObject({message: "<cf_get_lang dictionary_id='57974.Onay Süreci Geriye Doğru Döndürülemez!'>"});
							document.getElementById("process_stage").value = <cfoutput>#attributes.select_value#</cfoutput>;
						}
						<cfif len(attributes.onclick_function)>
							<cfoutput>#attributes.onclick_function#</cfoutput>;
						</cfif>
					}
				</script>
			</cfif>
		
			<!--- 563.Süreci Bir Sonraki Asamaya Getirmediniz. Emin misiniz? Bir Sonraki Asama :  --->
			<!--- 564.Lütfen Süreçlerinizi Tanimlayiniz ve/veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok ! --->
			<script type="text/javascript">		
				function process_cat_control()
				{
					//Guncelleme ise
					<cfif attributes.is_detail eq 1>
						if((document.all.process_stage.length > 1) && (document.all.process_stage.selectedIndex < document.all.process_stage.length) && (document.all.process_stage.value == <cfoutput>#attributes.select_value#</cfoutput>))				
						{
							value_is_continue = eval('document.all.is_continue'+document.all.process_stage.value);
							if(value_is_continue.value == 1)
							{
								if (confirm("<cfoutput>#caller.getLang('main',563)#</cfoutput>" + document.all.process_stage[document.all.process_stage.selectedIndex+1].text));
								return false;
							}
						}
					</cfif>
					if(document.getElementById("process_stage").value == "")
					{
						if(document.all.process_stage.length > 1){
							alertObject({message: "<cf_get_lang dictionary_id='52167.Lütfen Süreç-Aşama Seçiniz'>!"});
						}
						else{
							alertObject({message: "<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!"});
						}
						return false;
					}
					else
						return process_cat_dsp_function();
				}
			</script>
		</cfif>
		
	<cfelseif attributes.is_upd eq 1>
		<!--- Surec Queryden Calisiyorsa --->
		
		<cfset get_Process_Type_1 = Cmp.get_Process_Type_1(
			process_stage	: attributes.process_stage
		) />

		<!--- 
			Uğur Hamurpet 19/02/2020
			Belge üzerinden yapılan onaylarda;
			- Page_warnings üzerindeki ilgili bildirimin aksiyon kaydını atar.
			- Aksiyon sonrası geçilecek aşama varsa; 
				* Belgenin aşamasını değiştirir
				* Bildirimler yeni aşama üzerinden devam ettirilir
		--->

		<cfif len( attributes.actions ) and len( attributes.warning_id )>

			<cfset get_page_warning = Cmp.get_page_warning(
				warning_id : attributes.warning_id
			) />
			
			<cfif get_page_warning.recordcount>

				<cfset getActionInfo = createObject("component","cfc.getActionInfo")>
				<cfset actionInfo = getActionInfo.get(action_table:get_page_warning.action_table)>
				
				<cfif Len(actionInfo.action_stage_column)>

					<cfset warningAction = Cmp.add_page_warning_action(
						warning_id : attributes.warning_id,
						url_link : "#get_page_warning.url_link#",
						warning_description : "#get_page_warning.warning_description#",
						action_db : "#actionInfo.action_db#",
						action_table : "#get_page_warning.action_table#",
						action_column : "#get_page_warning.action_column#",
						action_stage_column : "#actionInfo.action_stage_column#",
						action_stage_id : "#get_page_warning.action_stage_id#",
						action_id : "#get_page_warning.action_id#",
						action_type : "#attributes.actions#",
						confirm_result : "#(len(get_page_warning.confirm_result) ? get_page_warning.confirm_result : 0)#"
					) />

					<cfset get_page_warning.CHECKER_NUMBER = len( get_page_warning.CHECKER_NUMBER ) ? get_page_warning.CHECKER_NUMBER : 0 />

					<cfif warningAction.status and ( get_Process_Type_1.CHECKER_NUMBER eq 0 or get_page_warning.CHECKER_NUMBER gte get_Process_Type_1.CHECKER_NUMBER or attributes.actions neq 'confirm' )>

						<cfswitch expression="#attributes.actions#">
							<cfcase value="confirm"><cfset processStage = get_Process_Type_1.IS_CONFIRM_STAGE_ID></cfcase>
							<cfcase value="refuse"><cfset processStage = get_Process_Type_1.IS_REFUSE_STAGE_ID></cfcase>
							<cfcase value="again"><cfset processStage = get_Process_Type_1.IS_AGAIN_STAGE_ID></cfcase>
							<cfcase value="support"><cfset processStage = get_Process_Type_1.IS_SUPPORT_STAGE_ID></cfcase>
							<cfcase value="cancel"><cfset processStage = get_Process_Type_1.IS_CANCEL_STAGE_ID></cfcase>
							<cfdefaultcase><cfset processStage = ""></cfdefaultcase>
						</cfswitch>

						<cfset attributes.process_stage = ( len( processStage ) ? processStage : attributes.process_stage )>
					
						<!--- Belgenin aşamasını değiştirir ---->
						<cfset Cmp.changeAction(
							process_db: "#actionInfo.action_db#.",
							data_source: caller.dsn,
							actionTable: UCase(get_page_warning.action_table),
							actionStageColumn: UCase(actionInfo.action_stage_column),
							actionIdColumn: UCase(get_page_warning.ACTION_COLUMN),
							actionId: get_page_warning.ACTION_ID,
							process_stage: attributes.process_stage
						)/>

						<!--- Aşama değişikliği olabileceğinden Cmp.get_Process_Type_1 yeniden kurulur --->
						<cfset get_Process_Type_1 = Cmp.get_Process_Type_1(
							process_stage	: attributes.process_stage
						) />

					</cfif>

					<!--- Tüm ilişkili uyarıların onaylayan sayısını 1 artırır --->
					<cfif attributes.actions eq 'confirm'>
						<cfset Cmp.upd_warnings_checker_number(
							action_table : '#get_page_warning.action_table#',
							action_column : '#get_page_warning.action_column#',
							action_id : #get_page_warning.action_id#,
							process_stage : #actionInfo.action_stage_column#
						) />
					</cfif>

				</cfif>

			</cfif>

		</cfif>

		<cffunction name="actionFileControl">
			<!--- 
				Uğur Hamurpet 21/02/2021
					- Süreç aşama detayında 'Aşama değişmese de Action File çalışır' ifadesi seçilirse; AF aşama değişse de değişmese de çalışır!
					- ya da Aşama değiştirilmişse AF çalışır!
			--->
			<!--- Aşama Action File çalıştırır! --->
			<cfif get_Process_Type_1.IS_STAGE_ACTION eq 1 or get_Process_Type_1.Line_Number neq attributes.Old_Process_Line>
				<cfif len(get_Process_Type_1.file_name)>
					<cfif get_Process_Type_1.is_file_name eq 1>
						<cfif get_process_type_1.file_name contains 'v16'>
							<cfinclude template="#caller.dir_seperator##get_process_type_1.file_name#">
						<cfelse>
							<cfinclude template="#caller.dir_seperator#V16#caller.dir_seperator#process#caller.dir_seperator#files#caller.dir_seperator##get_process_type_1.file_name#">							
						</cfif>						
					<cfelse>
						<cfinclude template="#caller.dir_seperator#documents#caller.dir_seperator#settings#caller.dir_seperator##get_process_type_1.file_name#">
					</cfif>
				</cfif>
			</cfif>
			<!--- Aşama Action File çalıştırır! --->
			
			<!--- Main Action File Çalistiriliyor - Main Action File Include Et Secili ise Calisir --->
			<cfset get_Main_File = Cmp.get_Main_File(
				process_stage	: attributes.process_stage
				) />
			<cfif get_Main_File.is_main_file eq 1>
				<cfif len(get_Main_File.main_file) and (get_Main_File.is_action eq 1)>
					<cfif get_main_file.main_file contains 'v16'>
						<cfinclude template="#caller.dir_seperator##get_main_file.main_file#">
					<cfelse>
						<cfinclude template="#caller.dir_seperator#V16#caller.dir_seperator#process#caller.dir_seperator#files#caller.dir_seperator##get_main_file.main_file#">						
					</cfif>	
				</cfif>
			<cfelse>
				<cfif len(get_Main_File.main_file) and (get_Main_File.is_action eq 1)>
					<cfinclude template="#caller.file_web_path#settings#caller.dir_seperator##get_main_file.main_file#">
				</cfif>
			</cfif>
			<!--- //Main Action File Çalistiriliyor - Main Action File Include Et Secili ise Calisir --->
		</cffunction>

		<cfset attributes.record_date = createdatetime(year(attributes.record_date), month(attributes.record_date), day(attributes.record_date), hour(attributes.record_date), minute(attributes.record_date), second(attributes.record_date))>

		<cfif get_Process_Type_1.Line_Number neq attributes.Old_Process_Line>
			<!--- Surec Degismis ise Uyari, Mail, Online Mesaj, Sms vb Gonderilebilir --->
			
			<!--- Action_Table,Action_Id Varsa ve Belge Baska Bir Asamada Guncellenmisse Eski Uyarilar Pasife Aliniyor --->
			<cfif Len(attributes.action_table) and Len(attributes.action_id) and ( len(attributes.Old_Process_Line) and attributes.Old_Process_Line neq 0 )>
				<cfset upd_Page_Warnings = Cmp.upd_Page_Warnings(
					our_company_id 		: my_our_company_id_,
					period_id 			: session_period_id,
					action_table 		: attributes.action_table,
					action_column 		: attributes.action_column,
					action_id 			: attributes.action_id,
					old_process_stage   : (isdefined("attributes.old_process_stage")) ? attributes.old_process_stage : 0
					) />
			</cfif>

			<cfset get_Employee_WorkGroup = Cmp.get_Employee_WorkGroup(
				process_stage	: attributes.process_stage,
				position_code 	: session_position_code,
				partner_id 		: session_partner_id
				) />
			<cfif get_employee_workgroup.recordcount>
				<cfset value_workgroup_id = ValueList(GET_EMPLOYEE_WORKGROUP.WORKGROUP_ID,',')>
				<cfset value_mainworkgroup_id = ValueList(GET_EMPLOYEE_WORKGROUP.MAINWORKGROUP_ID,',')>
			<cfelse>
				<cfset value_workgroup_id = 0>
				<cfset value_mainworkgroup_id = 0>
			</cfif>
			<cfset get_Inf_Position_Type = Cmp.get_Inf_Position_Type(
				process_stage			: attributes.process_stage,
				value_workgroup_id 		: value_workgroup_id,
				value_mainworkgroup_id 	: value_mainworkgroup_id,
				is_consumer 			: get_process_type_1.is_consumer
				) />
			<cfset get_Cau_Position_Type = Cmp.get_Cau_Position_Type(
				process_stage			: attributes.process_stage,
				value_workgroup_id 		: value_workgroup_id,
				value_mainworkgroup_id 	: value_mainworkgroup_id,
				is_consumer 			: get_process_type_1.is_consumer,
				is_approval_chief		: #iif( get_process_type_1.is_confirm_first_chief eq 1 or get_process_type_1.is_confirm_second_chief eq 1, DE(1), DE(0) )#,
				is_confirm_first_chief	: #iif( get_process_type_1.is_confirm_first_chief eq 1, DE(1), DE(0))#,
				is_confirm_second_chief	: #iif( get_process_type_1.is_confirm_second_chief eq 1, DE(1), DE(0))#,
				position_code			: #iif( attributes.position_code neq 0, attributes.position_code, DE(0))#,
				mandate_position_code	: #attributes.mandate_position_code#
				) />
			<cfset get_General_Positions = Cmp.get_General_Positions() />
			<cfif caller.fusebox.process_tree_control eq 1><!--- eger agacli yapi var ise buna bagli olarak kisi izinde iken onun onaylari yedegine duser --->
				<cfset get_General_Positions_All = Cmp.get_General_Positions() />
				
				<cfset GET_GENERAL_POSITIONS = QueryNew("PRO_POSITION_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL,EMPLOYEE_ID,MOBILCODE,MOBILTEL,POSITION_CODE,TYPE","Integer,VarChar,VarChar,VarChar,Integer,VarChar,VarChar,Integer,Integer")>				
				<cfset ROW_OF_QUERY = 0>
				<cfoutput query="GET_GENERAL_POSITIONS_ALL">
					<cfset get_Real_Izin = Cmp.get_Real_Izin(
						employee_id	: get_General_Positions_All.Employee_Id,
						record_date	: now()
						) />
					<cfif get_real_izin.recordcount>
						<cfset get_StandBys = Cmp.get_StandBys(
							position_code	: get_General_Positions_All.Position_Code
							) />
						
						<cfset gercek_yaz = 0>
						<cfset yedek_1_yaz = 0>
						<cfset yedek_2_yaz = 0>
						<cfset yedek_3_yaz = 0>
						
						<cfif get_standbys.recordcount>
							<cfif len(get_standbys.candidate_pos_1)>
								<cfset get_yedek_1 = Cmp.get_Yedek(
									position_code	: get_standbys.candidate_pos_1
									) />
								<cfset get_real_izin_1 = Cmp.get_Real_Izin(
									position_code	: get_standbys.candidate_pos_1,
									record_date		: now()
									) />
								<cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
							</cfif>
							<cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
								<cfset get_yedek_2 = Cmp.get_Yedek(
									position_code	: get_standbys.candidate_pos_2
									) />
								<cfset get_real_izin_2 = Cmp.get_Real_Izin(
									position_code	: get_standbys.candidate_pos_2,
									record_date		: now()
									) />
								<cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
							</cfif>
							<cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
								<cfset get_yedek_3 = Cmp.get_Yedek(
									position_code	: get_standbys.candidate_pos_3
									) />
								<cfset get_real_izin_3 = Cmp.get_Real_Izin(
									position_code	: get_standbys.candidate_pos_3,
									record_date		: now()
									) />
								<cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
							</cfif>
						<cfelse>
							<cfset gercek_yaz = 1>
						</cfif>
					<cfelse>
						<cfset gercek_yaz = 1>
					</cfif>
					
					<cfif gercek_yaz eq 0 and yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and yedek_3_yaz eq 0><cfset gercek_yaz = 1></cfif>
					
					<cfif gercek_yaz eq 1>
						<cfscript>
							YAZILACAK_PRO_POSITION_ID = PRO_POSITION_ID;
							YAZILACAK_EMPLOYEE_NAME = EMPLOYEE_NAME;
							YAZILACAK_EMPLOYEE_SURNAME = EMPLOYEE_SURNAME;
							YAZILACAK_EMPLOYEE_EMAIL = EMPLOYEE_EMAIL;
							YAZILACAK_EMPLOYEE_ID = EMPLOYEE_ID;
							YAZILACAK_MOBILCODE = MOBILCODE;
							YAZILACAK_MOBILTEL = MOBILTEL;
							YAZILACAK_POSITION_CODE = POSITION_CODE;
						</cfscript>
					<cfelseif yedek_1_yaz eq 1>
						<cfscript>
							YAZILACAK_PRO_POSITION_ID = get_yedek_1.PRO_POSITION_ID;
							YAZILACAK_EMPLOYEE_NAME = get_yedek_1.EMPLOYEE_NAME;
							YAZILACAK_EMPLOYEE_SURNAME = get_yedek_1.EMPLOYEE_SURNAME;
							YAZILACAK_EMPLOYEE_EMAIL = get_yedek_1.EMPLOYEE_EMAIL;
							YAZILACAK_EMPLOYEE_ID = get_yedek_1.EMPLOYEE_ID;
							YAZILACAK_MOBILCODE = get_yedek_1.MOBILCODE;
							YAZILACAK_MOBILTEL = get_yedek_1.MOBILTEL;
							YAZILACAK_POSITION_CODE = get_yedek_1.POSITION_CODE;
						</cfscript>
					<cfelseif yedek_2_yaz eq 1>
						<cfscript>
							YAZILACAK_PRO_POSITION_ID = get_yedek_2.PRO_POSITION_ID;
							YAZILACAK_EMPLOYEE_NAME = get_yedek_2.EMPLOYEE_NAME;
							YAZILACAK_EMPLOYEE_SURNAME = get_yedek_2.EMPLOYEE_SURNAME;
							YAZILACAK_EMPLOYEE_EMAIL = get_yedek_2.EMPLOYEE_EMAIL;
							YAZILACAK_EMPLOYEE_ID = get_yedek_2.EMPLOYEE_ID;
							YAZILACAK_MOBILCODE = get_yedek_2.MOBILCODE;
							YAZILACAK_MOBILTEL = get_yedek_2.MOBILTEL;
							YAZILACAK_POSITION_CODE = get_yedek_2.POSITION_CODE;
						</cfscript>
					<cfelseif yedek_3_yaz eq 1>
						<cfscript>
							YAZILACAK_PRO_POSITION_ID = get_yedek_3.PRO_POSITION_ID;
							YAZILACAK_EMPLOYEE_NAME = get_yedek_3.EMPLOYEE_NAME;
							YAZILACAK_EMPLOYEE_SURNAME = get_yedek_3.EMPLOYEE_SURNAME;
							YAZILACAK_EMPLOYEE_EMAIL = get_yedek_3.EMPLOYEE_EMAIL;
							YAZILACAK_EMPLOYEE_ID = get_yedek_3.EMPLOYEE_ID;
							YAZILACAK_MOBILCODE = get_yedek_3.MOBILCODE;
							YAZILACAK_MOBILTEL = get_yedek_3.MOBILTEL;
							YAZILACAK_POSITION_CODE = get_yedek_3.POSITION_CODE;
						</cfscript>
					<cfelse>
						<cfscript>
							YAZILACAK_PRO_POSITION_ID = PRO_POSITION_ID;
							YAZILACAK_EMPLOYEE_NAME = EMPLOYEE_NAME;
							YAZILACAK_EMPLOYEE_SURNAME = EMPLOYEE_SURNAME;
							YAZILACAK_EMPLOYEE_EMAIL = EMPLOYEE_EMAIL;
							YAZILACAK_EMPLOYEE_ID = EMPLOYEE_ID;
							YAZILACAK_MOBILCODE = MOBILCODE;
							YAZILACAK_MOBILTEL = MOBILTEL;
							YAZILACAK_POSITION_CODE = POSITION_CODE;
						</cfscript>
					</cfif>	
					
					<cfscript>
						ROW_OF_QUERY = ROW_OF_QUERY + 1;
						QueryAddRow(GET_GENERAL_POSITIONS,1);
						QuerySetCell(GET_GENERAL_POSITIONS,"PRO_POSITION_ID",YAZILACAK_PRO_POSITION_ID,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"EMPLOYEE_NAME",YAZILACAK_EMPLOYEE_NAME,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"EMPLOYEE_SURNAME",YAZILACAK_EMPLOYEE_SURNAME,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"EMPLOYEE_EMAIL",YAZILACAK_EMPLOYEE_EMAIL,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"EMPLOYEE_ID",YAZILACAK_EMPLOYEE_ID,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"MOBILCODE",YAZILACAK_MOBILCODE,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"MOBILTEL",YAZILACAK_MOBILTEL,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"POSITION_CODE",YAZILACAK_POSITION_CODE,ROW_OF_QUERY);
						QuerySetCell(GET_GENERAL_POSITIONS,"TYPE",GET_GENERAL_POSITIONS_ALL.TYPE,ROW_OF_QUERY);
					</cfscript>
				</cfoutput>
			</cfif>

			<cfif Len(attributes.action_page)><!--- Bu kontrol silme sayfalarindan calistiginda uyari/sms mail vb gitmemesi icin eklendi, defaultta durum degismeyecek FBS 20120302 --->
				
				<cfset wsr_code = get_Process_Type_1.is_add_access_code ? len(attributes.warning_access_code) ? attributes.warning_access_code : CreateUUID() : '' />
				<cfset wsr_password = get_Process_Type_1.is_create_password ? len(attributes.warning_password) ? attributes.warning_password : randRange(100000, 999999, "CFMX_COMPAT") : '' />
				
				<cfif get_general_positions.recordcount>
					<cfoutput query="get_general_positions">
						<cfif get_Process_Type_1.is_email eq 1>
							<!--- Email --->
							<cfif len(get_general_positions.employee_email)>
								<cfif Len(my_our_company_email_)>
									<cfset attributes.mail_content_from ='#my_our_company_name_#<#my_our_company_email_#>'>
									<cfset attributes.start_date=DateFormat(dateadd('h',session_time_zone,now()), 'DD/MM/YYYY') & " " & TimeFormat(dateadd('h',session_time_zone,now()), 'HH:MM')>
								</cfif>
								<cfset attributes.mail_content_to = '#get_general_positions.employee_email#'>
								<cfif get_general_positions.type eq 0>
									<cfset attributes.mail_content_subject = 'Onay Süreci - #get_Process_Type_1.process_name#'>
								<cfelse>
									<cfset attributes.mail_content_subject = 'Bilgi Süreci - #get_Process_Type_1.process_name#'>
								</cfif>
								
								<cfset attributes.mail_content_additor = '#employee_name# #employee_surname#'>
								<cfset attributes.mail_content_info2='#attributes.warning_description#'>
								<cfif attributes.old_process_line eq 0>
									<cfset attributes.mail_record_emp = attributes.record_member>
									<cfset attributes.mail_record_date = DateFormat(dateadd('h',session_time_zone,attributes.record_date), 'DD/MM/YYYY') & " " & TimeFormat(dateadd('h',session_time_zone,attributes.record_date), 'HH:MM')> 
								<cfelse>
									<cfset attributes.mail_update_emp = attributes.record_member>
									<cfset attributes.mail_update_date = DateFormat(dateadd('h',session_time_zone,attributes.record_date), 'DD/MM/YYYY') & " " & TimeFormat(dateadd('h',session_time_zone,attributes.record_date), 'HH:MM')> 
								</cfif>
								<cfif isdefined("caller.attributes.project_id") and len(caller.attributes.project_id) and isdefined("caller.attributes.project_head") and len(caller.attributes.project_head)>
									<cfset attributes.project_id = caller.attributes.project_id>
									<cfset attributes.project_head = caller.attributes.project_head>
								</cfif>
								<cfsavecontent variable="attributes.mail_content_info">Süreç Takip Kaydı</cfsavecontent>
								<cfif cgi.server_port eq 443>
									<cfset user_domain = "https://#cgi.server_name#">
								<cfelse>
									<cfset user_domain = "http://#cgi.server_name#">
								</cfif>
								<cfset attributes.mail_content_link = '#user_domain#/#attributes.action_page#&wrkflow=1#len(wsr_code) ? "&wsr_code=" & wsr_code :""#'><!--- 'http://#user_domain#/#attributes.action_page#' --->
								<cfset attributes.process_stage_info = attributes.process_stage>
								<cfinclude template="../design/template/info_mail/mail_content.cfm">
							</cfif>
						</cfif>
						<cfif get_Process_Type_1.is_online eq 1>
							<!--- Online Mesaj --->
							<cfset add_Wrk_Message = Cmp.add_Wrk_Message(
								employee_id		: get_general_positions.employee_id,
								record_member 	: attributes.record_member,
								record_date 	: attributes.record_date,
								action_id		: (len(attributes.action_id)) ? attributes.action_id : 0,
								action_page		: "#attributes.action_page#",
								warning_head	: "#get_Process_Type_1.process_name# - #get_Process_Type_1.stage#",
								action_column	: "#attributes.action_column#",
								fuseaction		: "#caller.attributes.fuseaction#",
								message 		: "#attributes.warning_description#",
								stage_id		: "#attributes.process_stage#"
								) />
						</cfif>
						<cfif get_Process_Type_1.is_sms eq 1>
							<!--- SMS --->
							<cfif len(MobilCode) eq 3 and len(MobilTel) eq 7>
								<cfset attributes.mobil_phone = "#MobilCode##MobilTel#">
								<cfset attributes.sms_body = Left("#get_Process_Type_1.process_name# - #get_Process_Type_1.stage# - #attributes.warning_description#",462)>
								<cfset attributes.member_type = "employee">
								<cfset attributes.member_id = Employee_Id>
								<cfset attributes.paper_id = attributes.action_id>
								<cfset attributes.sms_template_id = -1>
								<cfset callcenter_include = 1>
								<cfinclude template="/V16/objects/query/add_send_sms.cfm">
							</cfif>
						</cfif>
					</cfoutput>
				</cfif>
				<!--- BURADA SORUN OLABILIR, AGACLI YAPIDA CALISAN IZINDEYKEN MAIL VE ONLINE MESAJ GONDERIMI YEDEGE YAPILIYOR ANCAK ONAY (PAGE_WARNINGS) YINE IZINDEKI CALISANA YAPILIYOR INCELENECEK, FBS 20120619 --->
				<cfif get_Process_Type_1.is_warning eq 1>
					<cfif get_cau_position_type.recordcount>
						<cfset socketItems = [] />
						<cfoutput query="get_cau_position_type">
							<cfset max_warning_date = attributes.record_date>
							<cfif len(get_Process_Type_1.answer_hour)>
								<cfset max_warning_date = dateadd("h", get_Process_Type_1.answer_hour,max_warning_date)>
							</cfif>
							<cfif len(get_Process_Type_1.answer_minute)>
								<cfset max_warning_date = dateadd("n", get_Process_Type_1.answer_minute,max_warning_date)>
							</cfif>
							<cfset warning_description_ = attributes.warning_description>
							<cfif Len(get_Process_Type_1.detail)><cfset warning_description_ = warning_description_ & " - " & get_Process_Type_1.detail></cfif>
		
							<!--- 
								Uğur Hamurpet - 21/07/2020 
								Desc : Tekil kayıtlarda belge numarasını bularak page_warnings tablosuna kaydedilmesini sağlar
							--->
							<cfif not len( attributes.paper_no ) and attributes.general_paper_id eq 0>
								<cfset getActionInfo = createObject("component","cfc.getActionInfo")>
								<cfset actionInfo = getActionInfo.get(action_table:attributes.action_table)>
								<cfif structKeyExists(actionInfo, "paper_type") and len(actionInfo.paper_type)>
									<cfset dsn = Replace(process_db,".","") />
									<cfset "#actionInfo.action_datasource_name#" = actionInfo.action_db />
									<cfif actionInfo.paper_type eq 'order' or actionInfo.paper_type eq 'offer'>
										<cf_papers paper_type="#actionInfo.paper_type#" increase="false" paper_type2="1">
									<cfelse>
										<cf_papers paper_type="#actionInfo.paper_type#" increase="false">
									</cfif>
									<cfset attributes.paper_no = paper_full />
								</cfif>
							</cfif>

							<cfset add_Page_Warnings = Cmp.add_Page_Warnings(
								action_page					: attributes.action_page,
								warning_head 				: "#get_Process_Type_1.process_name# - #get_Process_Type_1.stage#",
								process_row_id 				: get_Process_Type_1.process_row_id,
								warning_description			: warning_description_,
								warning_date 				: max_warning_date,
								record_date 				: attributes.record_date,
								record_member 				: attributes.record_member,
								position_code 				: get_cau_position_type.position_code,
								sender_position_code 		: session.ep.position_code,
								<!--- position_code_cc		: #iif( attributes.position_code_cc neq 0, attributes.position_code_cc, DE(0) )#, --->
								our_company_id 				: my_our_company_id_,
								period_id 					: session_period_id,
								action_table 				: attributes.action_table,
								action_column 				: attributes.action_column,
								action_id 					: (len(attributes.action_id)) ? attributes.action_id : 0,
								action_stage 				: attributes.process_stage,
								is_confirm 					: get_Process_Type_1.confirm_request,
								is_refuse 					: get_Process_Type_1.is_refuse,
								is_again 					: get_Process_Type_1.is_again,
								is_support 					: get_Process_Type_1.is_support,
								is_cancel 					: get_Process_Type_1.is_cancel,
								is_approve_all_checkers		: get_Process_Type_1.is_approve_all_checkers,
								is_confirm_first_chief		: get_Process_Type_1.is_confirm_first_chief,
								is_confirm_second_chief		: get_Process_Type_1.is_confirm_second_chief,
								general_paper_id			: attributes.general_paper_id,
								is_mandate 					: ( attributes.mandate_position_code neq 0 ) ? 1 : 0,
								is_notification				: attributes.is_notification,
								paper_no					: (len(attributes.paper_no)) ? attributes.paper_no : ( len(attributes.action_id) ? attributes.action_id : "" ),
								comment_request				: get_Process_Type_1.comment_request,
								checker_number				: 0,
								is_checker_update_authority	: get_Process_Type_1.is_checker_update_authority,
								access_code					: len(wsr_code) ? wsr_code :"",
								warning_password			: len(wsr_password) ? wsr_password :"",
								is_confirm_comment_required	: get_Process_Type_1.is_confirm_comment_required,
								is_refuse_comment_required	: get_Process_Type_1.is_refuse_comment_required,
								is_again_comment_required	: get_Process_Type_1.is_again_comment_required,
								is_support_comment_required	: get_Process_Type_1.is_support_comment_required,
								is_cancel_comment_required	: get_Process_Type_1.is_cancel_comment_required

							) />
							<!--- Uğur Hamurpet : 11/03/2020 Soket üzerinden bildirim göndermek için düzenleme yapıldı --->
							<cfset user_domain = (( cgi.server_port eq 443 ) ? 'https://' : 'http://') & cgi.server_name >
							<cfset socketItems[currentrow] = {
								channel : 'workflow.#get_cau_position_type.EMPLOYEE_ID#',
								data : {
									type : 'workflow',
									action_page : "#attributes.action_page#",
									warning_head : "#get_Process_Type_1.process_name# - #get_Process_Type_1.stage#",
									process_row_id : get_Process_Type_1.process_row_id,
									warning_description : "#warning_description_#",
									record_date : attributes.record_date,
									record_member : attributes.record_member,
									position_code : get_cau_position_type.position_code,
									sender_position_code : session.ep.position_code,
									action_id : (len(attributes.action_id)) ? attributes.action_id : 0,
									action_stage : attributes.process_stage,
									general_paper_id : attributes.general_paper_id,
									notification_settings : {
										status : true,
										title : "Yeni bir bildiriminiz var!",
										content : "#get_Process_Type_1.process_name# - #get_Process_Type_1.stage# ( #warning_description_# )",
										redirecturl : "#user_domain#/#attributes.action_page#"
									}
								}
							} />
						</cfoutput>
						<cf_workcube_websocket socketItems="#socketItems#"><!--- WebSocket --->
					</cfif>
				</cfif>
			</cfif>
			<!--- 
			<cfset qdynamic_actions = Cmp.get_process_row_dynamic_action(attributes.process_stage)>
			<cfset schemas = { main: caller.dsn, company: caller.dsn3, period: caller.dsn2, product: caller.dsn1 }>
			<cfloop query="qdynamic_actions">
				<cfquery name="qaction" datasource="#schemas[qdynamic_actions.da_schema]#">
					UPDATE #qdynamic_actions.da_table# SET #qdynamic_actions.da_column# = #isNumeric(qdynamic_actions.da_columnvalue)?qdynamic_actions.da_columnvalue:'#qdynamic_actions.da_columnvalue#'#
					WHERE #qdynamic_actions.da_keycolumn# = #isNumeric(caller[qdynamic_actions.da_keyvariable])?caller[qdynamic_actions.da_keyvariable]:'#caller[qdynamic_actions.da_keyvariable]#'#
				</cfquery>
			</cfloop>
			--->
			
		</cfif>

		<!--- 
			Uğur Hamurpet 05/03/2020  
			Toplu aşama değiştirme işlemlerinde action file dosyasının her bir belge için çalışması sağlandı
			actionfile en son çalışır
		--->
		<cfif attributes.general_paper_id gt 0>
			<cfset workcubeGeneralProcess = createObject("component","CustomTags.cfc.workcube_general_process")>
			<cfset getGeneralPaper = workcubeGeneralProcess.select( gp_id : attributes.general_paper_id )>
			<cfif getGeneralPaper.recordcount and len(getGeneralPaper.ACTION_LIST_ID)>
				<cfset actionListCounter = 0 /> <!--- action file içerisinde sayaç işlevi görür --->
				<cfloop index="item" list="#getGeneralPaper.ACTION_LIST_ID#">
					<cfset attributes.action_id = item>
					<cfset actionListCounter++ />
					<cfset actionFileControl() />
				</cfloop>
				<cfset attributes.action_id = 0 />
			</cfif>
		<cfelse>
			<cfset actionFileControl() />
		</cfif>

	</cfif>
</cfif>