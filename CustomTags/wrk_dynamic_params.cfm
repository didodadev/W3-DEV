<!---
    File: wrk_dynamic_params.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 2020/03/06 14:23:21
    Description:Gönderilen parametre tipine göre data'yı getirir.    
    History:      
    To Do:
    PARAMETRELERİN KULLANILDIĞI HER YERDE BU CUSTOM TAG KULLANILMALIDIR.
    ÖRNEK KULLANIM :
        <cf_wrk_dynamic_params 
                returninputvalue="outland_transport_type_id,outland_transport_type"
                returnqueryvalue="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"
                type_id="1"
                defaultColumnList="Taşıma Şekilleri"
                type_name="Sınırdaki Taşıma Şekilleri"
                fieldId="outland_transport_type_id" 
                fieldName="outland_transport_type">
--->
<cfparam name="attributes.placeHolder" default="">
<cfparam  name="attributes.line_info" default="1"><!---sayfada birden fazla kullanılacak ise gönderilir--->
<cfparam name="attributes.defaultColumnList" default="">
<cfparam name="attributes.type_id" default="">
<cfparam name="attributes.data_id" default="">
<cfparam name="attributes.type_name" default=""><!--- gelen parametre adı --->
<cfparam name="attributes.data_type_name" default="">
<cfparam name="attributes.data_type_id" default=""><!--- gelen parametre adı --->
<cfparam name="attributes.width " default="">
<cfparam name="attributes.listPage" default="0"><!--- 1 ise sadece liste görünümü olacak ve sayfalama olacak değilse satıra tıklandığında veri gönderimi yapacak. --->
<cfparam name="attributes.returnInputValue" default="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="PARAM_DATA_ID,PARAM_DATA_DESCRIPTION"><!--- queryden gönderilecek değerler.. --->
<cfparam name="attributes.compenent_name" default="get_parameters_datas">
<cfparam name="attributes.boxwidth" default="100"><!--- div width --->
<cfparam name="attributes.boxheight" default="100"><!--- div height --->
<cfparam name="attributes.title" default="#attributes.type_name#"><!--- Parametre Adı --->
<cfparam name="attributes.is_parameter" default="1">
<cfif isdefined("attributes.data_id") and len(attributes.data_id)>
    <cfquery name="get_parameters_datas" datasource="#caller.dsn#">        	
			SELECT
            	PARAM_DATA_ID,
                PARAM_DATA_TYPE,
                PARAM_DATA_STATUS,
                PARAM_DATA_DESCRIPTION,
                PARAM_DATA_DETAIL
            FROM 
             	SETUP_PARAM_DATA
            WHERE 
                PARAM_DATA_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.data_id#">
        </cfquery>
        <cfset attributes.data_type_name = get_parameters_datas.PARAM_DATA_DESCRIPTION>
        <cfset attributes.data_type_id = get_parameters_datas.PARAM_DATA_ID>
        
</cfif>
<cfscript>
	defaultColumnList="PARAM_DATA_DESCRIPTION@#attributes.type_name#";
	columnList='';
	"param_div_id_#attributes.line_info#" = 'wrkParametreDiv_#attributes.fieldName#';
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
<input type="hidden" name="#attributes.fieldId#" id="#attributes.fieldId#" value="#attributes.data_type_id#">
<div class="input-group">
    <input type="text" <cfif len(attributes.placeHolder)>placeholder="#attributes.placeHolder#"</cfif> name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="#attributes.data_type_name#" onFocus="AutoComplete_Create('#attributes.fieldName#','PARAM_DATA_TYPE','PARAM_DATA_DESCRIPTION','GET_PARAMETERS_DATAS','#attributes.type_id#','PARAM_DATA_ID','#attributes.fieldId#','','3','#attributes.width#');" onBlur="compenentInputValueEmptying_#attributes.line_info#(this);" onKeyPress="if(event.keyCode==13) {compenentAutoComplete_(this,'#evaluate("param_div_id_#attributes.line_info#")#','#compenent_url#'); return false;}"> 
    <span class="input-group-addon btnPointer icon-ellipsis" id="plus_this_parameters" name="plus_this_parameters" onclick="compenentAutoComplete_#attributes.line_info#('','#evaluate("param_div_id_#attributes.line_info#")#','#compenent_url#');"></span>
    <div id="#evaluate("param_div_id_#attributes.line_info#")#" onscroll="document.onmousemove = null;document.onmouseup= null;" style="z-index:1;position:absolute;width:100%;display:none;"></div>
</div>
<script type="text/javascript">
    function compenentAutoComplete_#attributes.line_info#(object_,div_id,comp_url)
    {
        var other_parameters = '#attributes.type_id#';
        console.log(other_parameters);
        Drag.init(document.getElementById('#evaluate("param_div_id_#attributes.line_info#")#'));
        var keyword_ =(!object_)?'':object_.value;
            if(keyword_.length < 3 && object_ != "")
            {
                alert("#caller.getLang('main',2152)#");
                return false;
            }
            else
            {
                $("##"+div_id).parent().css('position','relative');
                document.getElementById(div_id).style.display='';
                comp_url = comp_url+'&keyword='+keyword_+'';
                openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#evaluate("param_div_id_#attributes.line_info#")#'+comp_url+'&other_parameters='+other_parameters+'');
                return false;
            }
            return false;	
    }
    function compenentInputValueEmptying_#attributes.line_info#(object_)
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