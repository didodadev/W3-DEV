<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.addPageUrl" default="project.addpro"><!--- proje ekleme sayfası --->
<cfparam name="attributes.updPageUrl" default="project.prodetail█id="><!--- alt 987 proje güncelleme sayfası --->
<!---Sürekle bırak sadece Liste Sayfası değilse çalısın.... --->
<cfif not (attributes.listPage neq 1)><!---Eğerki Liste Sayfası ise div genişik ve yüksekliklerini arttırıyoruz ki ekranı kaplasın... ---->
	<cfset attributes.boxwidth = 1024>
    <cfset attributes.boxheight = 1280>
</cfif>
<cfparam name="attributes.search_field" default="">
<cfparam name="attributes.returnInputValue" default="station_id,station_head"><!--- değer gönderilecek input isimleri.. --->
<cfparam name="attributes.returnQueryValue" default="STATION_ID,STATION_NAME"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="get_workstation_reservation"><!--- compenentid --->
<cfparam name="attributes.width" default="140"><!--- input width --->
<cfparam name="attributes.boxwidth" default="300"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.boxTitle" default="İstasyonlar"><!--- Divin üzerinde gelen başlık.. --->
<cfparam name="attributes.js_page" default="0"><!--- js sayfadan mı çağırılıyor? --->
<cfparam name="attributes.station_Id" default=""><!--- update sayfası için gönderilir.. --->
<cfparam name="attributes.station_head" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.stationName" default=""><!--- update sayfasında gösterilir. --->
<cfparam name="attributes.fieldName" default="station_head"><!---oluşturulan inputun adı --->
<cfparam name="attributes.fieldId" default="station_Id"><!--- oluşturulan inputun idsi --->
<cfparam name="attributes.width" default="">
<cfparam name="attributes.length" default="">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.abh" default="0">
<!--- attribute değerler... --->
<cfparam name="attributes.Branch" default="0"><!--- Sube --->
<cfparam name="attributes.Department" default="0"><!--- departman --->
<cfparam name="attributes.Employee " default="0"><!--- calısan --->
<cfparam name="attributes.StartDate" default="0"><!--- Başlama Tarihi --->
<cfparam name="attributes.FinishDate" default="0"><!--- Bitiş Tarihi --->
<cfparam name="attributes.Stage" default="0"><!--- Aşama --->
<!---///attribute değerler...  --->
<cfset dsn_1 = '#caller.dsn#_#session.ep.company_id#'> 
<cfif len(attributes.station_Id)>
    <cfquery name="getSelectedStationName" datasource="#dsn_1#">
        SELECT
            WS.STATION_NAME +' - '+ (SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = WS.UP_STATION) AS STATION_NAME,
            WS.WIDTH,
            WS.HEIGHT,
            WS.LENGTH,
			WS.UP_STATION
        FROM 
            WORKSTATIONS WS
        WHERE WS.STATION_ID = #attributes.station_Id#
    </cfquery>
    <cfset attributes.stationName = getSelectedStationName.STATION_NAME>
</cfif>
<cfscript>
	defaultColumnList="STATION_ID@S.No,STATION_NAME@İstasyon";
	columnList='';
	'lang_STATION_ID' = 'S.No';
	'lang_STATION_NAME' = 'İstasyon';
	'lang_Department' = 'Departman';
	'lang_Employee' = 'Görevli';
	'lang_StartDate' = 'Başlangıç Tarihi';
	'lang_FinishDate' = 'Bitiş Tarihi';
	'lang_Stage' = 'Aşama';
	comp_div_id = 'wrkStationDiv_#attributes.fieldName#';
	StructList = StructKeyList(attributes,',');
	compenent_url = '';
	for(arg_ind=1;arg_ind lte listlen(StructList,',');arg_ind=arg_ind+1){
		object_ = ListGetAt(StructList,arg_ind,',');
		object_value = Evaluate("attributes.#object_#");
		
		if((object_ is 'STATION_NAME' or object_ is 'Department' or object_ is 'Employee'  or object_ is 'StartDate' or object_ is 'FinishDate' or object_ is 'Stage') and object_value gt 0)
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
    <input type="hidden" name="#attributes.fieldId#"  id="#attributes.fieldId#" style="width:#attributes.width#px" value="#Evaluate('attributes.#attributes.fieldId#')#">
   	<input type="hidden" name="station_width" id="station_width" value="<cfif len(attributes.station_Id)>#getSelectedStationName.WIDTH#</cfif>" />
    <input type="hidden" name="station_length" id="station_length" value="<cfif len(attributes.station_Id)>#getSelectedStationName.LENGTH#</cfif>" />
    <input type="hidden" name="station_height" id="station_height" value="<cfif len(attributes.station_Id)>#getSelectedStationName.HEIGHT#</cfif>" />
    <input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="<cfif len(attributes.station_Id)>#getSelectedStationName.STATION_NAME#</cfif>"onKeyPress="if(event.keyCode==13) {compenentAutoComplete(this,'#comp_div_id#','#compenent_url#'); return false;}"> <img  src="/images/plus_thin.gif" border="0" onClick="compenentAutoComplete('','#comp_div_id#','#compenent_url#');" style="cursor:pointer;" align="absmiddle">
    <div id="#comp_div_id#" style="position:absolute;display:none;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;"></div>
    <script type="text/javascript">
        function compenentAutoComplete(object_,div_id,comp_url){
			<cfif len(attributes.search_field)>
			other_parameters = '';
			for(sfi=1;sfi<=#listlen(attributes.search_field)#;sfi++){
				var inp_obj_name = list_getat('#attributes.search_field#',sfi,',');
				var inp_obj_value = document.getElementById(inp_obj_name).value;
				other_parameters += ''+inp_obj_name+'§'+inp_obj_value+'█';//alt+789=§ ve alt+987=█
			}
			</cfif>
			var left_ = AutoComplete_GetLeft(document.getElementById('#attributes.fieldName#'));
            var top_ = AutoComplete_GetTop(document.getElementById('#attributes.fieldName#'));
            document.getElementById('#comp_div_id#').style.left=left_+'px';
            document.getElementById('#comp_div_id#').style.top=top_+20+'px';
             var keyword_ =(!object_)?'':object_.value;
             if(keyword_.length < 3 && object_ != ""){
                alert('<cf_get_lang dictionary_id="29949.En Az 3 Karakter Giriniz!">');
                return false;}
             else{
				<cfif len(attributes.search_field)>
					var inp_obj_name = list_getat('#attributes.search_field#',3,',');
					var inp_obj_value = document.getElementById(inp_obj_name).value;
					if(inp_obj_name != '' && inp_obj_value == '')
					{
						alert('<cf_get_lang_main no="2145.Önce Şube Seçmelisiniz">!');
						return false;
					}
				</cfif>
				document.getElementById(div_id).style.display='';
                comp_url = comp_url+'&keyword='+keyword_+'';
                AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#'+comp_url+'&other_parameters='+other_parameters+'',div_id,1);
                return false;	
             }
             return false;	
        }
    </script>
</cfoutput>
