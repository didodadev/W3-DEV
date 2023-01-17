<!--- 
	Fiziki varlıklar
	created SM 20091027
 ---> 
<cfparam name="attributes.listpage" default="0"><!--- Liste sayfası olup olmadığı --->
<cfparam name="attributes.compenent_name" default="getAssetp"><!--- component id --->
<cfparam name="attributes.line_info" default=""><!--- Eğer birden fazla kullanılacaksa sayfada aynı isimde değişken olmasın diye --->
<cfparam name="attributes.fieldName" default="asset_name#attributes.line_info#"><!--- Oluşturulan input isim--->
<cfparam name="attributes.fieldId" default="asset_id#attributes.line_info#"><!--- Oluşturulan input isim--->
<cfparam name="attributes.width" default="150"><!--- input width --->
<cfparam name="attributes.boxwidth" default="600"><!--- div width --->
<cfparam name="attributes.boxheight" default="400"><!--- div height --->
<cfparam name="attributes.title" default="Fiziki Varlıklar"><!--- Başlık --->
<cfparam name="attributes.button_type" default="plus_thin"><!--- image type --->
<cfparam name="attributes.returnInputValue" default="asset_id#attributes.line_info#,asset_name#attributes.line_info#"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="ASSETP_ID,ASSETP"><!--- Queryden gönderileeck değerler --->
<cfparam name="attributes.xmlvalue" default="0">
<cfparam name="attributes.call_function_name" default=""><!--- fonksiyon çalıştımak için--->
<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
    <cfquery name="GETSELECTEDASSETNAME" datasource="#CALLER.DSN#">
        SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
    </cfquery>
    <cfset attributes.asset_name = getSelectedAssetName.assetp>
<cfelse>
	<cfset attributes.asset_id = ''>
	<cfset attributes.asset_name = ''>
</cfif>
<cfscript>
	defaultColumnList="ASSETP@Varlık,DEPT_NAME@Kullanıcı Lokasyon,FULL_NAME@Sorumlu,ASSETP_CAT@Kategori";
	columnList='';
	'comp_div_id#attributes.line_info#' = 'wrkAssetDiv_#attributes.fieldName#';
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1)
	{
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
			if(len(object_value))
				compenent_url='#compenent_url#&#object_#=#object_value#';
	}
	newColumnList='';//alanları sıralamak için yeni bir columnlist tanımlıyoruz..
	if(listlen(columnList,','))
	{
		newColumnList = ArrayNew(1);
		for(clind=1;clind lte listlen(columnList,',');clind=clind+1)
		{
			columnName = ListGetAt(ListGetAt(columnList,clind,','),1,'@');
			if(isdefined("attributes.#columnName#"))
			{
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
        <input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.asset_id#">
        
	<input type="text" name="#attributes.fieldName#" placeholder ="<cf_get_lang_main no ='1421.Fiziki Varlık'>" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#attributes.asset_name#" onBlur="compenentInputValueEmptying_asset(this);" onfocus="AutoComplete_Create('#attributes.fieldName#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','#attributes.fieldId#','','3','148');">
		<cfif isDefined('session.ep.userid')>
			<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&event_id=0<cfif len(attributes.call_function_name)>&call_function=#attributes.call_function_name#</cfif>&field_id=#attributes.form_name#.#attributes.fieldId#&field_name=#attributes.form_name#.#attributes.fieldName#&xmlvalue=#attributes.xmlvalue#');"></span>
		<cfelse>
		<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&event_id=0<cfif len(attributes.call_function_name)>&call_function=#attributes.call_function_name#</cfif>&field_id=#attributes.form_name#.#attributes.fieldId#&field_name=#attributes.form_name#.#attributes.fieldName#&xmlvalue=#attributes.xmlvalue#','list','popup_list_assetps');"></span>
		</cfif>
	</div>
	<script type="text/javascript">
		function compenentAutoComplete_asset(object_,div_id,comp_url)
		{
			var left_ = AutoComplete_GetLeft(document.getElementById('#attributes.fieldName#'));
			var top_ = AutoComplete_GetTop(document.getElementById('#attributes.fieldName#'));
			document.getElementById('#evaluate("comp_div_id#attributes.line_info#")#').style.left=left_+'px';
			document.getElementById('#evaluate("comp_div_id#attributes.line_info#")#').style.top=top_+20+'px';
			Drag.init(document.getElementById('#evaluate("comp_div_id#attributes.line_info#")#'));
			var keyword_ =(!object_)?'':object_.value;
			 if(keyword_.length < 3 && object_ != "")
			 {
				alert("#caller.getLang('main',2152)#");
				return false;
			 }
			 else
			 {
				document.getElementById('#evaluate("comp_div_id#attributes.line_info#")#').style.display='';
				comp_url = comp_url+'&keyword='+keyword_+'';
				AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&other_parameters=&comp_div_id=#evaluate("comp_div_id#attributes.line_info#")#'+comp_url+'','#evaluate("comp_div_id#attributes.line_info#")#',1);
				return false;
			 }
		}
		function compenentInputValueEmptying_asset(object_)
		{
			var keyword_ = object_.value;
			if(keyword_.length == 0)
			{
				<cfloop from="1" to="#listlen(attributes.returnQueryValue)#" index="qval_">
					if(document.getElementById('#listgetat(attributes.returnInputValue,qval_,',')#') != undefined)
						document.getElementById('#listgetat(attributes.returnInputValue,qval_,',')#').value ='';
				</cfloop>
			}
		}

	</script>
</cfoutput>
