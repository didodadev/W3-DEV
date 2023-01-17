<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.addPageUrl" default="project.addpro"><!--- proje ekleme sayfası --->
<cfparam name="attributes.updPageUrl" default="project.prodetail█id="><!--- alt 987 proje güncelleme sayfası --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>

<cfparam name="attributes.returnInputValue" default="operation_type_id,operation_type"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="OPERATION_TYPE_ID,OPERATION_TYPE"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="getOperationType"><!--- compenentid --->
<cfparam name="attributes.fieldName" default="operation_type"><!---oluşturulan inputun adı --->
<cfparam name="attributes.fieldId" default="operation_type_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.width" default="120"><!--- input width --->
<cfparam name="attributes.boxwidth" default="400"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.title" default="Operasyonlar"><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.operation_type_id" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.operation_type" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.control_status" default="0">
<cfif len(attributes.operation_type_id)>
    <cfquery name="getSelectedOperationName" datasource="#CALLER.DSN3#">
        SELECT
            OPERATION_TYPE_ID,
			#caller.dsn#.Get_Dynamic_Language(OPERATION_TYPE_ID,'#session.ep.language#','OPERATION_TYPES','OPERATION_TYPE',NULL,NULL,OPERATION_TYPE) AS OPERATION_TYPE
			
        FROM 
            OPERATION_TYPES
        WHERE 
			OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.operation_type_id#">
    </cfquery>
    <cfset attributes.operation_type = getSelectedOperationName.operation_type>
</cfif>
<cfscript>
	defaultColumnList="OPERATION_CODE@Operasyon Kodu,OPERATION_TYPE@İşlem";
	columnList='';
	comp_div_id = 'wrkProductModelDiv_#attributes.fieldName#';
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
	<div id="#comp_div_id#" class="ui-cfmodal"></div>
<div class="input-group">
    <input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" value="#attributes.operation_type_id#">
    <input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" onBlur="compenentInputValueEmptyingoperation(this);" value="#attributes.operation_type#" onKeyPress="if(event.keyCode==13) {compenentAutoCompletemodel(this,'#comp_div_id#','#compenent_url#'); return false;}">
    <span class="input-group-addon icon-ellipsis btnPointer" onClick="compenentAutoCompletemodel('','#comp_div_id#','#compenent_url#');"></span>
</div>
<script type="text/javascript">
	function compenentAutoCompletemodel(object_,div_id,comp_url){

		other_parameters = 'control_status§#attributes.control_status#█';//alt+789=§ ve alt+987=█
		 var keyword_ =(!object_)?'':object_.value;
		 if(keyword_.length < 3 && object_ != ""){
			alert("#caller.getLang('main',2152)#");
			return false;}
		 else{
			document.getElementById(div_id).style.display='';
			comp_url = comp_url+'&keyword='+keyword_+'';
			openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#&other_parameters='+other_parameters+''+comp_url+'');
			return false;	
		 }
		 return false;	
	}
	function compenentInputValueEmptyingoperation(object_)
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
