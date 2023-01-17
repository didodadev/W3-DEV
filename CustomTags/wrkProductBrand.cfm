<cfsetting showdebugoutput="no">
<link href="../../JS/temp/scroll/jquery.mCustomScrollbar.css" rel="stylesheet" />
<script src="../../JS/temp/scroll/jquery.mCustomScrollbar.concat.min.js"></script>
<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfparam name="attributes.returnInputValue" default="brand_id,brand_name"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="BRAND_ID,BRAND_NAME"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="getProductBrand"><!--- compenentid --->
<cfparam name="attributes.fieldName" default="brand_name"><!---oluşturulan inputun adı --->
<cfparam name="attributes.fieldId" default="brand_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.title" default="#caller.getLang('main',1435)#"><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.brand_ID" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.brand_name" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.single_line" default="1">
<!--- attribute değerler... --->
<cfparam name="attributes.brand_code" default="0"><!--- Marka Codu --->
<cfparam name="attributes.is_internet" default="0"><!--- İnternet Yayını --->
<!---///attribute değerler...  --->
<cfif len(attributes.brand_id)>
    <cfquery name="getSelectedBrandName" datasource="#CALLER.DSN1#">
        SELECT
            BRAND_NAME
        FROM 
            PRODUCT_BRANDS
        WHERE 
        	BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
    </cfquery>
    <cfset attributes.brand_name = getSelectedBrandName.brand_name>
</cfif>
<cfscript>
	defaultColumnList="BRAND_NAME@#caller.getLang('main',1435)#";
	columnList='';
	'lang_brand_code' = 'Kod';
	'lang_is_internet' = 'Web';
	comp_div_id = 'wrkProductBrandDiv_#attributes.fieldName#';
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
		
		if((object_ is 'brand_code' or object_ is 'is_internet') and object_value gt 0)
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
	compenent_url = '#compenent_url#&columnList=#newColumnList#';
</cfscript>
<cfoutput>
<div class="input-group">
    <input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" style="width:#attributes.width#px" value="#attributes.brand_id#">
    <input type="text" name="#attributes.fieldName#" placeholder="#caller.getLang('main',1435)#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#attributes.brand_name#" onblur="compenentInputValueEmptyingbrand(this);" onkeypress="if(event.keyCode==13) {compenentAutoCompletebrand(this,'#compenent_url#'); return false;}">
    <span class="input-group-addon btnPointer icon-ellipsis" onclick="compenentAutoCompletebrand('','#compenent_url#');"> </span>
</div>
<script type="text/javascript">
	function compenentAutoCompletebrand(object_,comp_url){
		 var company_brand_ =(!object_)?'':object_.value;
		 var keyword_ =(!object_)?'':object_.value;
		 if(keyword_.length < 3 && object_ != ""){
			alert("<cf_get_lang_main no='2152.En Az 3 Karakter Giriniz'>!");
			return false;
			}
		 else{
			comp_url = comp_url+'&company_brand='+company_brand_+'&keyword='+keyword_+'';
			openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&'+comp_url);
			return false;	
		 }
		 return false;	
	}
	function compenentInputValueEmptyingbrand(object_){
		var keyword_ = object_.value;
		if(keyword_.length == 0){
			<cfloop from="1" to="#listlen(attributes.returnQueryValue)#" index="qval_">
				document.getElementById('#listgetat(attributes.returnInputValue,qval_,',')#').value ='';
			</cfloop>	
		}
	}
</script>
</cfoutput>
