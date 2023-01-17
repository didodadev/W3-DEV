<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.addPageUrl" default="project.addpro"><!--- proje ekleme sayfası --->
<cfparam name="attributes.updPageUrl" default="project.prodetail█id="><!--- alt 987 proje güncelleme sayfası --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfparam name="attributes.compenent_name" default="getProject"><!--- compenentid --->
<cfparam name="attributes.fieldName" default="project_head"><!---oluşturulan inputun adı --->
<cfparam name="attributes.fieldId" default="project_id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.returnInputValue" default="#attributes.fieldId#,#attributes.fieldName#"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="PROJECT_ID,PROJECT_HEAD"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.boxTitle" default="#caller.getLang('main',603)#"><!--- Divin üzerinde gelen başlık.. ---><!---Projeler--->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.#attributes.fieldId#" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.#attributes.fieldName#" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.formname" default="document.all">
<!--- attribute değerler... --->
<cfparam name="attributes.AgreementNo" default="0"><!--- SözleşmeNo --->
<cfparam name="attributes.Customer" default="0"><!--- Cari Hesap --->
<cfparam name="attributes.Employee" default="0"><!--- Görevli Çalışan --->
<cfparam name="attributes.Priority" default="0"><!--- Öncelik --->
<cfparam name="attributes.StartDate" default="0"><!--- Başlama Tarihi --->
<cfparam name="attributes.FinishDate" default="0"><!--- Bitiş Tarihi --->
<cfparam name="attributes.Stage" default="0"><!--- Aşama --->
<cfparam name="attributes.allproject" default="0"><!--- Tüm projeler --->
<cfparam name="attributes.buttontype" default="1"><!--- Buton tipi 1 ise liste sayfaları için ince buton , 2 ise ekleme sayfaları için artı butonu --->
<cfif attributes.buttontype eq 1>
	<cfset button_name= 'plus_thin'>
<cfelseif attributes.buttontype eq 2>
	<cfset button_name= 'plus_list'>
</cfif>
<!---///attribute değerler...  --->
<cfif len(attributes.project_id)>
	<cfif attributes.project_id eq -1>
    	<cfset 'attributes.#attributes.fieldName#' = 'Projesiz'>
	<cfelseif attributes.project_id eq -2>
    	<cfset 'attributes.#attributes.fieldName#' = 'Tüm Projeler'>
	<cfelse>        
        <cfquery name="getSelectedProjectName" datasource="#CALLER.DSN#">
            SELECT
                PROJECT_HEAD
            FROM 
                PRO_PROJECTS
            WHERE 
                PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
        </cfquery>
        <cfset 'attributes.#attributes.fieldName#' = getSelectedProjectName.project_head>
    </cfif>
</cfif>
<cfscript>
	defaultColumnList="PROJECT_ID@P.No,PROJECT_HEAD@Proje";
	columnList='';
	//'lang_PROJECT_ID' = 'ProjeId';
	//'lang_PROJECT_HEAD' = 'Proje';
	'lang_Customer' = "#caller.getLang('main',107)#";	//Cari Hesap
	'lang_Employee' = "#caller.getLang('main',157)#"; //Görevli
	'lang_Priority' = "#caller.getLang('main',73)#"; //Öncelik
	'lang_StartDate' = "#caller.getLang('main',641)#"; //Başlangıç Tarihi
	'lang_FinishDate' = "#caller.getLang('main',288)#"; //Bitiş Tarihi
	'lang_AgreementNo' = "#caller.getLang('main',2247)#"; //Sözleşme No
	'lang_Stage' = "#caller.getLang('main',70)#"; //Aşama
	comp_div_id = 'wrkProjectDiv_#attributes.fieldName#';
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
	compenent_url = '#compenent_url#&columnList=#newColumnList#';
</cfscript>
<div class="input-group">
<cfoutput>
<input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" style="width:#attributes.width#px" value="#Evaluate('attributes.#attributes.fieldId#')#">
<input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" placeholder="<cf_get_lang_main no='4.Proje'>" style="width:#attributes.width#px" onfocus="AutoComplete_Create('#attributes.fieldName#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','#attributes.fieldId#','','3','148');" autocomplete="off" value="#Evaluate('attributes.#attributes.fieldName#')#">
<cfif isDefined('session.ep.userid')>
	<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=all.#attributes.fieldId#&project_head=all.#attributes.fieldName#&allproject=all.#attributes.allproject#');"></span>
<cfelse>
	<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects2.popup_list_projects&project_id=#attributes.formname#.#attributes.fieldId#&project_head=#attributes.formname#.#attributes.fieldName#','list');"></span>
</cfif>
</cfoutput>
</div>