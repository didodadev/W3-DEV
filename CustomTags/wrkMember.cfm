<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 0)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 700>
    <cfset attributes.boxheight = 500>
</cfif>
<cfparam name="attributes.returnInputValue" default="company_id,consumer_id,partner_id,partner_name,company,member_type"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="COMPANY_ID,CONSUMER_ID,PARTNER_ID,PARTNER_NAME,COMPANY_NAME,MEMBER_TYPE"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.comp_fldName" default="company"><!---company için oluşturulan inputun adı --->
<cfparam name="attributes.comp_fldId" default="company_id"><!---company_id için  oluşturulan inputun idsi --->
<cfparam name="attributes.dsp_partner_fld" default="1"><!--- partner-yetkili inputu olusturulsun mu --->
<cfparam name="attributes.partner_fldName" default="partner_name"><!---partner-yetkili için oluşturulan inputun adı --->
<cfparam name="attributes.partner_fldId" default="partner_id"><!---partner-yetkili için oluşturulan inputun idsi --->
<cfparam name="attributes.cons_fieldID" default="consumer_id"><!---partner-yetkili için oluşturulan inputun adı --->
<cfparam name="attributes.member_type_fldID" default="">
<cfparam name="attributes.comp_width" default="120"><!--- cari input width --->
<cfparam name="attributes.prtnr_width" default="180"><!---yetkili input width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.boxTitle" default=""><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.select_list" default="1,2,3"> <!--- calışan listesi,bireysel üye list, kurumsal üye listeleri seçilebilecek şekilde gelir --->
<cfparam name="attributes.wrk_member_type" default="#listfirst(attributes.select_list)#"> <!---select_list ile birden fazla seçenek gönderilmişse, hangisinin öncelikli olarak gösterileceğini belirtir. deger gonderilmezse listelerden ilki default açılır--->
<!--- attribute değerler... --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<!--- kurumsal uyeler liste alanları --->
<cfparam name="attributes.CompNo" default="1"><!--- Üye No --->
<cfparam name="attributes.CompName" default="1"><!--- Cari Hesap --->
<cfparam name="attributes.PrtnrName" default="1"><!--- Cari Hesap --->
<cfparam name="attributes.CompCity" default="1"><!--- Şehir --->
<cfparam name="attributes.CompCat" default="1"><!--- Üye Kategorisi --->
<cfparam name="attributes.CompExtre" default="1"><!--- Extre ikonu getir --->
<cfparam name="attributes.CompInfo" default="1"><!--- şirket detay için ikon getir --->
<cfparam name="attributes.AddComp" default="1"><!--- çalışan ekle için ikon getir --->
<!--- filtre alanlarının display degerleri --->
<cfscript>
	url_string = '';
	url_string = '#url_string#&boxwidth=#attributes.boxwidth#';
	url_string = '#url_string#&boxheight=#attributes.boxheight#';
	url_string = '#url_string#&boxTitle=#attributes.boxTitle#';
	url_string = '#url_string#&select_list=#attributes.select_list#';
	url_string = '#url_string#&wrk_member_type=#attributes.wrk_member_type#';
	url_string = '#url_string#&returnInputValue=#attributes.returnInputValue#';
	url_string = '#url_string#&returnQueryValue=#attributes.returnQueryValue#';
	url_string = '#url_string#&FIELDID=#attributes.comp_fldId#';
	url_string = '#url_string#&FIELDNAME=#attributes.comp_fldName#';
	/*parametrelerden sadece 0 olan yani listede gosterilmesi istenmeyenler wrk_search sayfasına gonderiliyor*/
	if(len(attributes.CompNo) and attributes.CompNo eq 1)
		url_string = '#url_string#&CompNo=#attributes.CompNo#';
	if(len(attributes.CompName) and attributes.CompName eq 1)
		url_string = '#url_string#&CompName=#attributes.CompName#';
	if(len(attributes.PrtnrName) and attributes.PrtnrName eq 1)
		url_string = '#url_string#&PrtnrName=#attributes.PrtnrName#';
	if(len(attributes.CompCity) and attributes.CompCity eq 1)
		url_string = '#url_string#&CompCity=#attributes.CompCity#';
	if(len(attributes.CompCat) and attributes.CompCat eq 1)
		url_string = '#url_string#&CompCat=#attributes.CompCat#';
	if(len(attributes.CompExtre) and attributes.CompExtre eq 1)
		url_string = '#url_string#&CompExtre=#attributes.CompExtre#';
	if(len(attributes.CompInfo) and attributes.CompInfo eq 1)
		url_string = '#url_string#&CompInfo=#attributes.CompInfo#';
	if(len(attributes.AddComp) and attributes.AddComp eq 1)
		url_string = '#url_string#&AddComp=#attributes.AddComp#';
	if(len(attributes.keyword))
		url_string = '#url_string#&keyword=#attributes.keyword#';
	/*if (isdefined("attributes.str_opener_form_url")) url_string = "#url_string#&str_opener_form_url=#str_opener_form_url#";
	if (isdefined("attributes.str_opener_form")) url_string = "#url_string#&str_opener_form=#str_opener_form#";
	if (isdefined("attributes.type")) url_string = '#url_string#';
	if (isdefined('attributes.islem')) url_string = '#url_string#&islem=#islem#';
	if (isdefined('url.come')) url_string = '#url_string#&come=#url.come#';
	if (isdefined('attributes.function_name')) url_string = '#url_string#&function_name=#function_name#';
	if (isdefined('attributes.startdate')) url_string = '#url_string#&startdate=#attributes.startdate#';
	if (isdefined('attributes.finishdate')) url_string = '#url_string#&finishdate=#attributes.finishdate#';
	if (isdefined("attributes.ship_method_id")) url_string = "#url_string#&ship_method_id=#attributes.ship_method_id#";
	if (isdefined("attributes.ship_method_name")) url_string = "#url_string#&ship_method_name=#attributes.ship_method_name#";
	if (isdefined("attributes.call_function")) url_string = "#url_string#&call_function=#attributes.call_function#";
	if (isdefined('attributes.is_store_module')) url_string = '#url_string#&is_store_module=1';
	if (isdefined("attributes.process_row_id")) url_string = "#url_string#&process_row_id=#attributes.process_row_id#";
	if (isdefined("attributes.process_date")) url_string = "#url_string#&process_date=#attributes.process_date#";*/

comp_div_id = 'wrkMemberDiv_#attributes.comp_fldName#';
compenent_url='';
/*	
defaultColumnList="CUSTOMER_ID@NO,CUSTOMER_NAME@Cari Hesap";
	columnList='';
	'lang_CUSTOMER_ID' = 'NO';
	'lang_CUSTOMER_NAME' = 'Cari Hesap';
	columnList='';
	'lang_Customer' = 'Cari Hesap';
	'lang_Employee' = 'Görevli';
	'lang_Priority' = 'Öncelik';
	'lang_StartDate' = 'Başlangıç Tarihi';
	'lang_FinishDate' = 'Bitiş Tarihi';
	'lang_AgreementNo' = 'S.No';
	'lang_Stage' = 'Aşama';
	
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
		
		if((object_ is 'Customer' or object_ is 'AgreementNo' or object_ is 'Employee' or object_ is 'Priority' or object_ is 'StartDate' or object_ is 'FinishDate' or object_ is 'Stage') and object_value gt 0)
			columnList = ListAppend(columnList,"#object_#@#Evaluate("lang_#object_#")#",',');
		else
			if(len(object_value))
				compenent_url='#compenent_url#&#object_#=#object_value#';
	}
	newColumnList='';//alanları sıralamak için yeni bir columnlist tanımlıyoruz..
	if(listlen(columnList,',')){
		newColumnList = ArrayNew(1);
		for(clind=1;clind lte listlen(columnList,',');clind=clind+1){
			columnName = ListGetAt(ListGetAt(columnList,clind,','),1,'@');
			if(isdefined("attributes.#columnName#")){
				newColumnList[Evaluate("attributes.#columnName#")] ='#ListGetAt(columnList,clind,',')#';
			}	
		}
		newColumnList = ArrayToList(newColumnList,',');
	}
	newColumnList='#defaultColumnList#,#newColumnList#';
	compenent_url = '#compenent_url#&columnList=#newColumnList#';*/
</cfscript>
<cfoutput>
<cfif len(attributes.member_type_fldID)><!--- member type alanı olusturulacaksa --->
	<input type="hidden" name="#attributes.member_type_fldID#"  id="#attributes.member_type_fldID#" value='#Evaluate("attributes.#attributes.member_type_fldID#")#'>
</cfif>
<input type="hidden" name="#attributes.cons_fieldID#"  id="#attributes.cons_fieldID#">
<input type="hidden" name="#attributes.comp_fldId#"  id="#attributes.comp_fldId#">
<input type="text" name="#attributes.comp_fldName#" id="#attributes.comp_fldName#" style="width:#attributes.comp_width#px" onKeyPress="if(event.keyCode==13) {compenentAutoComplete(this,'#comp_div_id#','#compenent_url#'); return false;}"> <img  src="/images/plus_thin.gif" border="0" onClick="compenentAutoComplete('','#comp_div_id#','#compenent_url#');" style="cursor:pointer;" align="absmiddle">
<cfif attributes.dsp_partner_fld eq 1><!--- yetkili alanı olusturulacaksa --->
	<br />
	<input type="hidden" name="#attributes.partner_fldId#"  id="#attributes.partner_fldId#">
	<input type="text" name="#attributes.partner_fldName#" id="#attributes.partner_fldName#" style="width:#attributes.partner_fldName#px" value="" readonly="yes">
</cfif>
<div id="#comp_div_id#" style="position:absolute;display:none;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;"></div>
<script type="text/javascript">
	function compenentAutoComplete(object_,div_id,comp_url){
		var left_ = AutoComplete_GetLeft(document.getElementById('#attributes.comp_fldName#'));
		var top_ = AutoComplete_GetTop(document.getElementById('#attributes.comp_fldName#'));
		document.getElementById('#comp_div_id#').style.left=left_+'px';
		document.getElementById('#comp_div_id#').style.top=top_+20+'px';
		<cfif attributes.listPage neq 1><!---Liste Sayfası ise SürükleBırak Olmasın.. --->
			Drag.init(document.getElementById('#comp_div_id#'));
		</cfif>
		 var keyword_ =(!object_)?'':object_.value;
		 if(keyword_.length < 3 && object_ != ""){
			alert("#caller.getLang('main',2152)#");
			return false;}
		 else{
			document.getElementById(div_id).style.display='';
			AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_member_search&comp_div_id=#comp_div_id#&#url_string#"',div_id,1);
			return false;	
		 }
		 return false;
	}
</script>
</cfoutput>
