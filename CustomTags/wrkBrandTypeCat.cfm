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
<cfparam name="attributes.returnInputValue" default="brand_name,brand_type_cat_id,brand_id,brand_type_id"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_CAT_ID,BRAND_ID,BRAND_TYPE_ID"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="getBrandTypeCat1"><!--- compenentid --->
<cfparam name="attributes.single_line" default="1">

<cfparam name="attributes.is_type_cat_id" default="1"><!--- text alandaki ifade brand_name-brand_type_name-brand_type_cat_name seklinde mi brand_name-brand_type_name BK 20090609 --->

<cfparam name="attributes.fieldName" default="brand_name"><!---oluşturulan inputun adı --->
<cfif attributes.is_type_cat_id eq 1>
	<cfparam name="attributes.fieldId" default="brand_type_cat_id"><!--- oluşturulan inputun idsi (brand_type_cat_id)--->
<cfelse>
	<cfparam name="attributes.fieldId" default="brand_type_id"><!--- oluşturulan inputun idsi (brand_type_id)--->
</cfif>

<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="240"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfif attributes.is_type_cat_id eq 1>
	<cfparam name="attributes.title" default="#caller.getLang('main',2243)#"><!--- Divin üzerinde gelen başlık.. ---><!---Marka Tip Kategorisi--->
<cfelse>
	<cfparam name="attributes.title" default="#caller.getLang('main',2244)#"><!--- Divin üzerinde gelen başlık.. ---><!---Marka Tipi--->
</cfif>
<cfparam name="attributes.brand_type_cat_id" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.brand_type_cat_head" default=""><!--- update sayfasında gösterilir. --->

<!--- attribute değerler... --->
<cfif attributes.is_type_cat_id eq 1>
	<cfif len(attributes.brand_type_cat_id)>
        <cfquery name="getSelectedBrandTypeCatName" datasource="#caller.dsn#">
             SELECT
                SETUP_BRAND_TYPE_CAT.*,
                (SETUP_BRAND.BRAND_NAME + ' - ' + SETUP_BRAND_TYPE.BRAND_TYPE_NAME + ' - ' +  SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME) BRAND_TYPE_CAT_HEAD
            FROM
                SETUP_BRAND_TYPE_CAT,
                SETUP_BRAND_TYPE,
                SETUP_BRAND
            WHERE
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
                SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND 
                SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_type_cat_id#"> 
        </cfquery>
        <cfset attributes.brand_type_cat_head = getSelectedBrandTypeCatName.brand_type_cat_head>
    </cfif>
<cfelse>
	<cfif len(attributes.brand_type_id)>
        <cfquery name="getSelectedBrandTypeName" datasource="#caller.dsn#">
             SELECT
                (SETUP_BRAND.BRAND_NAME + ' - ' + SETUP_BRAND_TYPE.BRAND_TYPE_NAME) BRAND_TYPE_CAT_HEAD
            FROM
                SETUP_BRAND_TYPE,
                SETUP_BRAND
            WHERE
                SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND 
                SETUP_BRAND_TYPE.BRAND_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_type_id#">
        </cfquery>
        <cfset attributes.brand_type_cat_head = getSelectedBrandTypeName.brand_type_cat_head>
    </cfif>
</cfif>
<cfscript>
	defaultColumnList="BRAND_NAME@#caller.getLang('main',1435)#,BRAND_TYPE_NAME@#caller.getLang('main',2244)#";
	columnList='';
	'lang_BRAND_TYPE_CAT_NAME' = '#caller.getLang('main',74)#';
	comp_div_id = 'wrkBrandTypeCatDiv_#attributes.fieldName#';
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
		if((object_ is 'BRAND_TYPE_CAT_NAME') and object_value gt 0)
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

<div class="ui-cfmodal">
	<div id="#comp_div_id#"></div>
</div>


<div class="input-group">
    <input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width#px" value='#Evaluate("attributes.#attributes.fieldId#")#'>
    <input type="text" name="#attributes.fieldName#" placeholder="#caller.getLang('','',30041)#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#attributes.brand_type_cat_head#" onBlur="compenentInputValueEmptying(this);" onKeyPress="if(event.keyCode==13) {compenentAutoComplete(this,'#comp_div_id#','#compenent_url#'); return false;}"> 
    <span class="input-group-addon btnPointer icon-ellipsis" onClick="compenentAutoComplete('','#comp_div_id#','#compenent_url#');"></span>
	
</div>

<script type="text/javascript">
	function compenentAutoComplete(object_,div_id,comp_url)
	{
		<cfif attributes.listPage neq 1><!---Liste Sayfası ise SürekleBırak Olmasın.. --->
			Drag.init(document.getElementById('#comp_div_id#'));
		</cfif>
		var keyword_ =(!object_)?'':object_.value;
		if(keyword_.length < 3 && object_ != "")
		{
			alert("#caller.getLang('main',2152)#");
			return false;
		}
		else
		{
			document.getElementById(div_id).style.display='';
			comp_url = comp_url+'&keyword='+keyword_+'';
			openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#'+comp_url+'');
			return false;	
		}
		return false;	
	}
	
	function compenentInputValueEmptying(object_)
	{
		var keyword_ = object_.value;
		if(keyword_.length == 0)
		{
			<cfloop from="2" to="#listlen(attributes.returnQueryValue)#" index="qval_">
			<cfoutput>
				document.getElementById('#listgetat(attributes.returnInputValue,qval_,',')#').value ='';
			</cfoutput>
			</cfloop>	
		}
	}
</script>
</cfoutput>