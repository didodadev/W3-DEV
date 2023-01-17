<!--- 
	Banka seçimi için kulllanılan custom tag
	created SM 20090924
 --->
<cfparam name="attributes.listpage" default="0"><!--- Liste sayfası olup olmadığı --->
<cfparam name="attributes.returnInputValue" default="bank_name"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="bank_name"><!--- Queryden gönderileeck değerler --->
<cfparam name="attributes.compenent_name" default="getBank"><!--- component id --->
<cfparam name="attributes.fieldName" default="bank_name"><!--- Oluşturulan input isim--->
<cfparam name="attributes.fieldId" default="bank_name"><!--- Oluşturulan input isim--->
<cfparam name="attributes.width" default="140"><!--- imput width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.title" default="Bankalar"><!--- Başlık --->
<cfparam name="attributes.draggable" default="0">
<cfscript>
	defaultColumnList="BANK_NAME@Banka Tipi,DETAIL@Açıklama";
	columnList='';
	comp_div_id = 'wrkProductDiv_#attributes.fieldName#';
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
	<div class="input-group"><input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="" onFocus="AutoComplete_Create('#attributes.fieldName#','BANK_NAME','BANK_NAME','get_bank_autocomplete','0','','','#attributes.form_name#','3','#attributes.width#');" onBlur="compenentInputValueEmptying(this);" onKeyPress="if(event.keyCode==13) {compenentAutoComplete_(this,'#comp_div_id#','#compenent_url#'); return false;}">
		<span class="input-group-addon icon-ellipsis" onClick="compenentAutoComplete_('','#comp_div_id#','#compenent_url#');"></span>
	</div>
	<div id="#comp_div_id#" onscroll="document.onmousemove = null;document.onmouseup= null;" style="z-index:2;position:absolute;display:none;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;"></div>
	<script type="text/javascript">
		function compenentAutoComplete_(object_,div_id,comp_url)
		{
			<cfif attributes.draggable>
				var top_=1;
				var left_=1;
				<cfelse>
					var top_=1;
				var left_=1;
			</cfif>
			
			document.getElementById('#comp_div_id#').style.left=left_+'px';
			document.getElementById('#comp_div_id#').style.top=top_+20+'px';
			Drag.init(document.getElementById('#comp_div_id#'));
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
				<cfif attributes.draggable>
					openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#'+comp_url+'',div_id,1);
				<cfelse>
					AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&comp_div_id=#comp_div_id#'+comp_url+'',div_id,1);
				</cfif>
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
