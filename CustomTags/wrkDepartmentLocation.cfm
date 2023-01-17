<!--- 

	UPDATE DATE : 24072019-İLKER ALTINDAL

	DEPO LOKASYON FİLTRE ALANLARININ KULLANILDIĞI HER YERDE BU CUSTOM TAG KULLANILMALIDIR.
	
	ÖRNEK KULLANIM :
	<cf_wrkdepartmentlocation 
		returninputvalue="sales_departments,department_id,location_id"
		returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
		fieldname="sales_departments"
		fieldid="location_id"
		department_fldid="department_id"
		department_id="#attributes.department_id#"
		location_name="#attributes.sales_departments#"
		location_id="#attributes.location_id#"
		user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
		width="120">

	ŞİRKET AKIŞ PARAMETRELERİNDEN LOKASYON BAZLI TAKİP YAPILSIN SEÇENEĞİ SEÇİLİ İKEN YA DA ŞUBE BAZLI ÇALIŞAN YETKİ GRUPLARINDA SADECE YETKİLİ OLUNAN DEPO VE LOKASYONLAR,
	ŞUBE BAZLI ÇALIŞMAYAN YETKİ GRUPLARINDA İSE TÜM DEPO VE LOKASYONLAR GÖRÜNTÜLENEBİLMEKTEDİR.
--->

<link href="../../JS/temp/scroll/jquery.mCustomScrollbar.css" rel="stylesheet" />
<script src="../../JS/temp/scroll/jquery.mCustomScrollbar.concat.min.js"></script>
<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.addPageUrl" default="project.addpro"><!--- proje ekleme sayfası --->
<cfparam name="attributes.updPageUrl" default="project.prodetail█id="><!--- alt 987 proje güncelleme sayfası --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfparam name="attributes.line_info" default="1">
<cfparam name="attributes.returnInputValue" default="location_id,location_name,department_id,branch_id"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.returnQueryValue2" default="DEPARTMENT_ID,DEPARTMENT_HEAD">
<cfparam name="attributes.compenent_name" default="get_department_location"><!--- compenentid --->

<cfparam name="attributes.is_submit" default="0"><!--- formdan göndrilir , eğer 1 olarak mgelirse session değerlerini almaz --->
<cfparam name="attributes.fieldId" default="location_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.fieldName" default="location_name"><!--- oluşturulan inputun adı--->

<cfparam name="attributes.department_fldId" default="department_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.branch_fldId" default="branch_id"><!--- oluşturulan inputun idsi --->

<cfparam name="attributes.is_department" default="0"><!---1 olursa Departmanlar lokasyondan bağımsız görüntülenebilsin --->
<cfparam name="attributes.status" default="1"><!---0 olursa Pasif depo ve lokasyonlar görüntülensin --->
<cfparam name="attributes.form_name" default="">
<cfparam name="attributes.width" default="200"><!--- input width --->
<cfparam name="attributes.boxwidth" default="250"><!--- div width --->
<cfparam name="attributes.boxheight" default="200"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfsavecontent  variable="def_title"><cf_get_lang dictionary_id="41184.Depo - Lokasyon"></cfsavecontent>
<cfparam name="attributes.title" default="#def_title#"><!--- Divin üzerinde gelen başlık.. ---><!---Departman  - Lokasyon--->
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.is_store_kontrol" default="1">
<cfparam name="attributes.user_level_control" default="1"><!--- user control yapilsin --->
<cfparam name="attributes.is_delivery" default=""><!---sevkiyat depo kontrol --->
<cfparam name="attributes.location_type" default=""><!---tip kontrol noktalı bvirgül (;) ile ayırınız (location_type parametresi eklendi. 1-Hammadde Depo 2- Mal Depo 3-Mamul Depo BK 20060419)--->
<cfparam name="attributes.user_location" default="1"><!--- user lokasyonu default gelsin --->
<cfparam name="attributes.sistem_company_id" default=""><!--- belirtilen sirkettekiler gelmesin --->
<cfparam name="attributes.is_ingroup" default=""><!--- grup sirketi subeleri --->
<cfif caller.fusebox.circuit is 'store' and attributes.is_store_kontrol eq 1><cfset is_store_module=1><cfelse><cfset is_store_module = 0></cfif>
<cfparam name="attributes.is_store_module" default="#is_store_module#">
<cfparam name="attributes.call_function" default="1"><!--- calisacak js fonksiyonu --->
<cfparam name="attributes.data_msg" default="">
<cfparam name="attributes.xml_all_depo" default=""> <!---Siparişlerdeki tüm depolar gelsin mi kontrolüne ek olarak diğer sayfalardaki depo xml bilgisi (Tüm depolar,yetkili depolar gelsin) için kullanıldı PY  --->
<cfif len(attributes.location_id) and len(attributes.department_id)>
    <cfquery name="getSelectedDepartmentLocation" datasource="#CALLER.DSN#">
        SELECT
        	D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.COMPANY_ID,

			B.BRANCH_NAME,			
			D.DEPARTMENT_HEAD,
			SL.COMMENT,
			SL.LOCATION_ID,
			<cfif caller.database_type is 'MSSQL'>
			D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME
			<cfelseif caller.database_type is 'DB2'>
			D.DEPARTMENT_HEAD || ' - ' || SL.COMMENT AS LOCATION_NAME
			</cfif>
        FROM 
            DEPARTMENT D,
            BRANCH B,
            STOCKS_LOCATION SL
        WHERE 
			B.BRANCH_ID = D.BRANCH_ID AND
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND
			SL.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
		ORDER BY
			LOCATION_NAME
    </cfquery>
    <cfset attributes.location_name = getSelectedDepartmentLocation.location_name>
	<cfset attributes.location_id = getSelectedDepartmentLocation.location_id>
	<cfset attributes.department_id = getSelectedDepartmentLocation.department_id>
	<cfset attributes.branch_id = getSelectedDepartmentLocation.branch_id>
<cfelseif attributes.user_location eq 1 and isDefined('session.ep.user_location') and listlen(session.ep.user_location,'-') eq 3 and attributes.is_submit eq 0>
	<cfquery name="getSelectedDepartmentLocation" datasource="#CALLER.DSN#">
        SELECT
        	D.DEPARTMENT_ID,
			B.BRANCH_ID,
			B.COMPANY_ID,
			B.BRANCH_NAME,			
			D.DEPARTMENT_HEAD,
			SL.COMMENT,
			SL.LOCATION_ID,
			<cfif caller.database_type is 'MSSQL'>
			D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME
			<cfelseif caller.database_type is 'DB2'>
			D.DEPARTMENT_HEAD || ' - ' || SL.COMMENT AS LOCATION_NAME
			</cfif>
        FROM 
            DEPARTMENT D,
            BRANCH B,
            STOCKS_LOCATION SL
        WHERE 
			B.BRANCH_ID = D.BRANCH_ID AND
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			SL.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(session.ep.user_location,'-')#"> AND
			SL.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(session.ep.user_location,'-')#">
			<!--- default lokasyon gelebilmesi icin (user_location="1") lokasyonunun bulundugu sirkete yetkili olunmasi gerekir --->
			AND B.COMPANY_ID IN (SELECT OC.COMP_ID FROM EMPLOYEE_POSITIONS EP,EMPLOYEE_POSITION_PERIODS EPP,SETUP_PERIOD SP,OUR_COMPANY OC WHERE SP.OUR_COMPANY_ID = OC.COMP_ID AND SP.PERIOD_ID = EPP.PERIOD_ID AND  EP.POSITION_ID = EPP.POSITION_ID AND EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		ORDER BY
			LOCATION_NAME
    </cfquery>
    <cfset attributes.location_name = getSelectedDepartmentLocation.location_name>
	<cfset attributes.location_id = getSelectedDepartmentLocation.location_id>
	<cfset attributes.department_id = getSelectedDepartmentLocation.department_id>
	<cfset attributes.branch_id = getSelectedDepartmentLocation.branch_id>
</cfif>

<cfscript>
	defaultColumnList="LOCATION_NAME@#caller.getLang('main',2234)#";
	columnList='';
	"comp_div_id_#attributes.line_info#" = 'wrkDepartmentLocationDiv_#attributes.fieldName#';
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
		
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
	compenent_url = '#compenent_url#&columnList=#newColumnList#';
</cfscript>
<cfoutput>
<input type="hidden" name="#attributes.branch_fldId#"  id="#attributes.branch_fldId#" value="#attributes.branch_id#">
<input type="hidden" name="#attributes.department_fldId#" id="#attributes.department_fldId#" value="#attributes.department_id#">
<input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.location_id#">
<div class="ui-cfmodal" id="#evaluate("comp_div_id_#attributes.line_info#")#"></div>
<div class="input-group">
	<input type="text" placeholder="<cf_get_lang dictionary_id="58763.Depo">" name="#attributes.fieldName#"<cfif len(attributes.data_msg)>data-msg="#attributes.data_msg#" required="yes"</cfif> id="#attributes.fieldName#"  autocomplete="off" onblur="compenentInputValueEmptyinglocation_#attributes.line_info#(this);" value="#attributes.location_name#" onkeypress="if(event.keyCode==13) {compenentAutoCompletelocation_#attributes.line_info#(this,'#evaluate("comp_div_id_#attributes.line_info#")#','#compenent_url#'); return false;}"> 
	<span class="input-group-addon btnPointer icon-ellipsis" id="plus_this_department" name="plus_this_department" onclick="if(#attributes.call_function#){compenentAutoCompletelocation_#attributes.line_info#('','#evaluate("comp_div_id_#attributes.line_info#")#','#compenent_url#');}"></span>
</div>
<script type="text/javascript">
	function compenentAutoCompletelocation_#attributes.line_info#(object_,div_id,comp_url){
		 other_parameters = 'is_delivery§#attributes.is_delivery#/location_type§#attributes.location_type#/sistem_company_id§#attributes.sistem_company_id#/is_ingroup§#attributes.is_ingroup#/user_level_control§#attributes.user_level_control#/is_store_module§#attributes.is_store_module#/xml_all_depo§#attributes.xml_all_depo#/status§#attributes.status#';//alt+789=§ ve alt+987=█ 
	<!---  other_parameters = 'is_delivery*#attributes.is_delivery#/location_type*#attributes.location_type#/sistem_company_id*#attributes.sistem_company_id#/is_ingroup*#attributes.is_ingroup#/user_level_control*#attributes.user_level_control#/is_store_module*#attributes.is_store_module#/status*#attributes.status#';//alt+789=§ ve alt+987=█ --->
		 var keyword_ =(!object_)?'':object_.value;
		 if(keyword_.length < 3 && object_ != ""){
			alert("#caller.getLang('main',2152)#");
			return false;}
		 else{
			document.getElementById(div_id).style.display='';
			if(keyword_ == '')
			keyword_ = "0";
			openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&keyword='+keyword_+comp_url+'&comp_div_id=#evaluate("comp_div_id_#attributes.line_info#")#&other_parameters='+other_parameters);
			return false;	
		 }
		 return false;	
	}
	function compenentInputValueEmptyinglocation_#attributes.line_info#(object_)
	{
		var keyword_ = object_.value;
		if(keyword_.length == 0)
		{
			<cfloop from="1" to="#listlen(attributes.returnQueryValue)#" index="qval_">
				document.getElementById('#listgetat(attributes.returnInputValue,qval_,',')#').value ='';
			</cfloop>	
		}
	}
</script>
</cfoutput>