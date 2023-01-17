<!--- 
	banka şubesi seçimi için kulllanılan custom tag
	created SM 20090924
 --->
<cfparam name="attributes.listpage" default="0"><!--- Liste sayfası olup olmadığı --->
<cfparam name="attributes.returnInputValue" default="bank_branch_name"><!--- değer gönderilecek input isimleri..--->
<cfparam name="attributes.returnQueryValue" default="bank_branch_name"><!--- Queryden gönderileeck değerler --->
<cfparam name="attributes.compenent_name" default="getBankBranch"><!--- component id --->
<cfparam name="attributes.fieldName" default="bank_branch_name"><!--- Oluşturulan input isim--->
<cfparam name="attributes.fieldId" default="bank_branch_name"><!--- Oluşturulan input isim--->
<cfparam name="attributes.width" default="140"><!--- imput width --->
<cfparam name="attributes.boxwidth" default="200"><!--- div width --->
<cfparam name="attributes.boxheight" default="250"><!--- div height --->
<cfparam name="attributes.title" default="#caller.getLang('main',2245)#"><!--- Başlık ---><!---Banka Şubeleri--->
<cfparam name="attributes.kontrol_bank_name" default="0"><!--- Varsa seçilmeden önce çağrılacak fonksiyon --->
<cfparam name="attributes.draggable" default="0">
<cfscript>
	defaultColumnList="BANK_BRANCH_NAME@Şube Adı,BRANCH_CODE@Şube Kodu";
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
	<input type="text" name="branch_code" id="branch_code" style="display:none">
	<div class="input-group"><input type="text" name="#attributes.fieldName#" id="#attributes.fieldName#" style="width:#attributes.width#px" value="" onFocus="call_auto_complete();" onBlur="compenentInputValueEmptying(this);" onKeyUp="<cfif attributes.kontrol_bank_name eq 1>kontrol_bank_name();</cfif>" onKeyPress="if(event.keyCode==13) {compenentAutoComplete(this,'#comp_div_id#','#compenent_url#'); return false;}"> <span class="input-group-addon icon-ellipsis" onClick="compenentAutoComplete('','#comp_div_id#','#compenent_url#');"></span></div>
	<div id="#comp_div_id#" onscroll="document.onmousemove = null;document.onmouseup= null;" style="z-index:2;position:absolute;display:none;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;"></div>
	<!--- 
	AutoComplete_Create('get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','list_works','3','250');"  
	--->
	<script type="text/javascript">
		function call_auto_complete()
		{
			document.getElementById('#attributes.fieldName#').onkeyup=function(){
				if (kontrol_bank_name())
					AutoComplete_Create('#attributes.fieldName#','BANK_BRANCH_NAME,BRANCH_CODE','BANK_BRANCH_NAME,BRANCH_CODE','get_bankbranch_autocomplete','\''+document.#attributes.form_name#.bank_name.value+'\'','BRANCH_CODE','branch_code');
			}
			
		}
		function kontrol_bank_name()
		{
			if(document.#attributes.form_name#.bank_name.value=="")
			{
				alert("#caller.getLang('main',2175)#");
				document.#attributes.form_name#.#attributes.fieldName#.value="";
				return false;
			}
			return true;
		}
		function compenentAutoComplete(object_,div_id,comp_url)
		{
			kontrol_function=1;
			<cfif attributes.kontrol_bank_name eq 1>
				if(document.#attributes.form_name#.bank_name.value=="")
				{
					alert("#caller.getLang('main',2175)#");
					document.#attributes.form_name#.#attributes.fieldName#.value="";
					kontrol_function = 0;
				}
			</cfif>
			if(kontrol_function == 1)
			{
				<cfif attributes.draggable>
				var top_=1;
				var left_=1;
				<cfelse>
					var left_ = AutoComplete_GetLeft(document.getElementById('#attributes.fieldName#'));
				var top_ = AutoComplete_GetTop(document.getElementById('#attributes.fieldName#'));
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
					bank_name='';
					if(document.getElementById('bank_name'))
					bank_name = document.getElementById('bank_name').value;
				<cfif attributes.draggable>
					openBoxDraggable('#request.self#?fuseaction=objects.popup_wrk_list_comp&other_parameters=bank_name@'+bank_name+'&comp_div_id=#comp_div_id#'+comp_url+'',div_id,1);
				<cfelse>
					AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_list_comp&other_parameters=bank_name@'+bank_name+'&comp_div_id=#comp_div_id#'+comp_url+'',div_id,1);
				</cfif>
					return false;
				 }
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
