<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.addPageUrl" default="project.addpro"><!--- proje ekleme sayfası --->
<cfparam name="attributes.updPageUrl" default="project.prodetail█id="><!--- alt 987 proje güncelleme sayfası --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<!--- attribute değerler... --->
<cfparam name="attributes.returnInputValue" default="model_id,model_name,model_code"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="model_id,model_name,model_code"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="getProductModel_"><!--- compenentid --->
<cfparam name="attributes.fieldName" default="model_name"><!---oluşturulan inputun adı --->
<cfparam name="attributes.fieldId" default="model_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.fieldcode" default="model_code"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.title" default="#caller.getLang('main',813)#"><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.model_ID" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.model_name" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.model_code" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.control_field_id" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.control_field_name" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.control_field_message" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.single_line" default="1">
<cfif len(attributes.model_ID)>
	<cfif isDefined('session.pp.userid')>
		<cfif not isDefined('get_all_for_langs')>
            <cfquery name="GET_ALL_FOR_LANGS" datasource="#CALLER.DSN#">
                SELECT 
                    UNIQUE_COLUMN_ID, 
                    TABLE_NAME,
                    COLUMN_NAME,
                    LANGUAGE,
                    ITEM 
                FROM 
                    SETUP_LANGUAGE_INFO 
                WHERE 
                    (
                        (TABLE_NAME = 'PRODUCT_BRANDS_MODEL' AND COLUMN_NAME = 'MODEL_CODE') OR
                        (TABLE_NAME = 'PRODUCT_BRANDS_MODEL' AND COLUMN_NAME = 'MODEL_NAME')
                    ) AND
                    ITEM <> '' AND
                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_ID#"> AND
                    LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
            </cfquery>
        </cfif>
        <cfif get_all_for_langs.recordcount>
            <cfquery name="GET_LANG_MODEL_NAME" dbtype="query">
                SELECT
                    *
                FROM 
                    GET_ALL_FOR_LANGS
                WHERE 
                    TABLE_NAME = 'PRODUCT_BRANDS_MODEL' AND 
                    COLUMN_NAME = 'MODEL_NAME'
            </cfquery>
            <cfquery name="GET_LANG_MODEL_CODE" dbtype="query">
                SELECT
                    *
                FROM 
                    GET_ALL_FOR_LANGS
                WHERE 
                    TABLE_NAME = 'PRODUCT_BRANDS_MODEL' AND 
                    COLUMN_NAME = 'MODEL_CODE'
            </cfquery>
            <cfset attributes.model_name = get_lang_model_name.item>
            <cfset attributes.model_code = get_lang_model_code.item>        
        <cfelse>
            <cfquery name="getSelectedModelName" datasource="#CALLER.DSN1#">
                SELECT
                    MODEL_NAME,
                    MODEL_CODE
                FROM 
                    PRODUCT_BRANDS_MODEL
                WHERE 
                    MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
            </cfquery>
            <cfset attributes.model_name = getSelectedModelName.model_name>
            <cfset attributes.model_code = getSelectedModelName.model_code>
        </cfif>
    <cfelse>
        <cfquery name="getSelectedModelName" datasource="#CALLER.DSN1#">
            SELECT
                MODEL_NAME,
                MODEL_CODE
            FROM 
                PRODUCT_BRANDS_MODEL
            WHERE 
                MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
        </cfquery>
        <cfset attributes.model_name = getSelectedModelName.model_name>
        <cfset attributes.model_code = getSelectedModelName.model_code>
    </cfif>
</cfif>
<cfscript>
	defaultColumnList="MODEL_NAME@#caller.getLang('main',1173)#,MODEL_CODE@#caller.getLang('main',813)#";
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
<div class="input-group">
    <input type="hidden" name="#attributes.fieldcode#"  id="#attributes.fieldcode#" value="#attributes.model_code#">
    <input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" value="#attributes.model_id#">
    <input type="text" name="#attributes.fieldName#" placeholder="<cf_get_lang dictionary_id='58225.Model'>" id="#attributes.fieldName#" style="width:#attributes.width#px" onblur="compenentInputValueEmptyingmodel(this);" value="#attributes.model_name#" onkeypress="if(event.keyCode==13) {compenentAutoCompletemodel(this,'#compenent_url#'); return false;}"> 
	<span class="input-group-addon btnPointer icon-ellipsis" onclick="compenentAutoCompletemodel('','#compenent_url#');"> </span>
</div>
<script type="text/javascript">
	function compenentAutoCompletemodel(object_,comp_url)
	{

		 var company_model_ =(!object_)?'':object_.value;
		 var keyword_ =(!object_)?'':object_.value;
		
		 if(keyword_.length < 3 && object_ != "")
		 {
			alert("#caller.getLang('main',2152)#");
			return false;
		 }
		 else
		 {
			<cfif len(attributes.control_field_id)>
				other_parameters = '#attributes.control_field_id#*' + document.getElementById('#attributes.control_field_id#').value;//alt+789=§ ve alt+987=█
			<cfelse>
				other_parameters = '';
			</cfif>
			comp_url = comp_url+'&company_model_='+company_model_+'&keyword='+keyword_+'';
			<cfif isDefined('session.pp.userid')>
				openBoxDraggable('#request.self#?fuseaction=objects2.popup_wrk_list_comp&other_parameters='+other_parameters+'&'+comp_url);
			<cfelse>
				openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&other_parameters='+other_parameters+'&'+comp_url);
			</cfif>
			return false;	
		}
		return false;	
	}
	function compenentInputValueEmptyingmodel(object_)
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
