<!--- 
	Servis popupları yerine kullanılacak custom tag,
	gönderilen değişkenlere göre getService.cfc den aldığı değerleri wrk_list_page kullanarak listeler.
	created AE 20090819
 --->
<cfparam name="attributes.listPage" default="0"><!--- Liste sayfası olup olmadığı --->
<cfparam name="attributes.addPageUrl" default="service.add_service"><!--- Ekleme sayfası url --->
<cfparam name="attributes.updPageUrl" default="service.upd_service█service_id="><!--- Güncelleme sayfası url --->
<cfparam name="attributes.returnInputValue" default="service_id,service_no"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="SERVICE_ID,SERVICE_NO"><!--- Queryden gönderileeck değerler --->
<cfparam name="attributes.compenent_name" default="getService"><!--- component id --->
<cfparam name="attributes.fieldName" default="service_no"><!--- Oluşturulan input isim--->
<cfparam name="attributes.fieldId" default="service_id"><!--- Oluşturulan input id--->
<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.js_page" default="0"><!--- js den çağrılıp çağrılmadığı --->
<cfparam name="attributes.service_id" default=""><!--- Update sayfasına gidecekse gönderilecek parametre --->
<cfparam name="attributes.service_no" default=""><!--- Update sayfasına gidecekse gönderilecek isim --->
<cfparam name="attributes.title" default="#caller.getLang('main',2242)#"><!--- Servis Başvuruları --->

<cfif not (attributes.listPage neq 1)>
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfif len(attributes.service_id)>
    <cfquery name="getSelectedServiceName" datasource="#CALLER.DSN3#">
        SELECT
            SERVICE_NO
        FROM 
            SERVICE
        WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
    </cfquery>
    <cfset attributes.service_no = getSelectedServiceName.service_no>
</cfif>
<cfscript>
	defaultColumnList="SERVICE_NO@Başvuru No,APPLY_DATE@Tarih,SERVICE_HEAD@Konu";
	columnList='';
	'lang_SERVICE_NO' = 'Servis Başvuruları';
	comp_div_id = 'wrkServiceDiv_#attributes.fieldName#';
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
	<input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" style="width:#attributes.width#px" value="#Evaluate('attributes.#attributes.fieldId#')#">
	<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#Evaluate('attributes.#attributes.fieldName#')#" onBlur="compenentInputValueEmptying(this);" onKeyPress="if(event.keyCode==13) {compenentAutoComplete(this,'#comp_div_id#','#compenent_url#'); return false;}"> <img  src="/images/plus_thin.gif" border="0" onClick="compenentAutoComplete('','#comp_div_id#','#compenent_url#');" style="cursor:pointer;" align="absmiddle">
	<div id="#comp_div_id#" onscroll="document.onmousemove = null;document.onmouseup= null;" style="position:absolute;display:none;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;"></div>
	<script type="text/javascript">
		function compenentAutoComplete(object_,div_id,comp_url)
		{
			var left_ = AutoComplete_GetLeft(document.getElementById('#attributes.fieldName#'));
			var top_ = AutoComplete_GetTop(document.getElementById('#attributes.fieldName#'));
			document.getElementById('#comp_div_id#').style.left=left_+'px';
			document.getElementById('#comp_div_id#').style.top=top_+20+'px';
			<cfif attributes.listPage neq 1>
				Drag.init(document.getElementById('#comp_div_id#'));
			</cfif>
			 var keyword_ =(!object_)?'':object_.value;
			 if(keyword_.length < 3 && object_ != "")
			 {
				alert("#caller.getLang('main',2152)#");		<!---En Az 3 Karakter Giriniz--->
				return false;}
			 else
			 {
				document.getElementById(div_id).style.display='';
				comp_url = comp_url+'&keyword='+keyword_+'';
				AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#'+comp_url+'',div_id,1);
				return false;
			 }
			 return false;	
		}
		function compenentInputValueEmptying(object_)
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
