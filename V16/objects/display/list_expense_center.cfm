<!--- 
	url üzerinden
	field_id : form_adı.id_alan_adı
	field_name : form_adı.hesapplanı_adı_yazılacak_alan_adı
	is_invoice ise EXPENSE ID gonderilecek
	yazılacak alanları alır ve yazar

	parametreler gönderilmemisse sadece pencereyi kapar
 --->
<cf_xml_page_edit fuseact="objects.popup_expense_center">
 <cfparam name="attributes.position_code" default="#session.ep.position_code#">
<cfinclude template="../query/get_expense_center.cfm">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#expense_center.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfif isdefined("field_id")><cfset url_string = "#url_string#&field_id=#field_id#"></cfif>
<cfif isdefined("field_name")><cfset url_string = "#url_string#&field_name=#field_name#"></cfif>
<cfif isdefined("is_invoice")><cfset url_string = "#url_string#&is_invoice=1"></cfif>
<cfif isdefined("position_code")><cfset url_string = "#url_string#&position_code=#attributes.position_code#"></cfif>
<cfif isdefined("from_health")><cfset url_string = "#url_string#&from_health=#from_health#"></cfif>
<cfif isdefined("x_authorized_branch_department")><cfset url_string = "#url_string#&x_authorized_branch_department=#x_authorized_branch_department#"></cfif>
<cfif isdefined("xml_get_expense_center")><cfset url_string = "#url_string#&xml_get_expense_center=#xml_get_expense_center#"></cfif>
<cfif isdefined("code")><cfset url_string = "#url_string#&code=#code#"></cfif>
<cfif isdefined("is_store_module")><cfset url_string = "#url_string#&is_store_module=#is_store_module#"></cfif>
<cfif isdefined("field_acc_name")><cfset url_string = "#url_string#&field_acc_name=#field_acc_name#"></cfif>
<cfif isdefined("field_code")><cfset url_string = "#url_string#&field_code=#field_code#"></cfif>
<cfif isdefined("field_acc_code_name")><cfset url_string = "#url_string#&field_acc_code_name=#field_acc_code_name#"></cfif>
<cfif isdefined("call_function")><cfset url_string = "#url_string#&call_function=#call_function#"></cfif>
<cfif isdefined("call_function_parameter")><cfset url_string = "#url_string#&call_function_parameter=#call_function_parameter#"></cfif>
<cfif isdefined("expense_center_id")><cfset url_string = "#url_string#&expense_center_id=#expense_center_id#"></cfif>
<cfif isdefined("expense_center_name")><cfset url_string = "#url_string#&expense_center_name=#expense_center_name#"></cfif>
<cfif isdefined("satir")><cfset url_string = "#url_string#&satir=#satir#"></cfif>
<cfif isdefined("attributes.#listfirst(session.dark_mode,":").trim()#")> <cfset url_string = "#url_string#&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#"></cfif>
<script type="text/javascript">
function add_pro(expense_center_id,expense_center_name,activity_id)
{  
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { ROW_EXP_CENTER_ID: expense_center_id, ROW_EXP_CENTER_NAME: expense_center_name, ROW_ACTIVITY_ID: activity_id }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
			
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Masraf/Gelir Merkezleri',32713)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_expense_center" method="post" action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#">
			<cf_box_search> 
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" placeholder= "#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("control() && loadPopupBox('list_expense_center' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>		
					<th width="100"><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='32714.Masraf/Gelir Merkezi Adı'></th>
				</tr>
			</thead>
			<tbody>
				<cfif expense_center.recordcount>
					<cfoutput query="expense_center" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tr>
					<cfif isdefined("attributes.satir") and len(attributes.satir)>
						<td><cfif ListLen(expense_code,".") neq 1><cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop></cfif><a href="javascript://" onclick="add_pro('#EXPENSE_ID#','#EXPENSE#','#ACTIVITY_ID#');" class="tableyazi">#expense_code#</a></td>
						<td><cfif ListLen(expense_code,".") neq 1><cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop></cfif><a href="javascript://" onclick="add_pro('#EXPENSE_ID#','#EXPENSE#','#ACTIVITY_ID#');" class="tableyazi">#expense#</a></td>
					<cfelse>
						<td><cfif ListLen(expense_code,".") neq 1><cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop></cfif><a href="javascript://" onclick="gonder('#EXPENSE_ID#','#jsStringFormat(expense)#','#expense_code#','#ACTIVITY_ID#');" class="tableyazi">#expense_code#</a></td>
						<td><cfif ListLen(expense_code,".") neq 1><cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop></cfif><a href="javascript://" onclick="gonder('#EXPENSE_ID#','#jsStringFormat(expense)#','#expense_code#','#ACTIVITY_ID#');" class="tableyazi">#expense#</a></td>
					</cfif>
					</tr>		
					</cfoutput>
				<cfelse>
				<tr>
					<td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
				</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.is_store_module")>
				<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
			</cfif>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.popup_expense_center#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(no,deger,code,activity_id)
{ 
	<cfif isDefined("attributes.field_id")>
	
		<cfif listlen(attributes.field_id,".") eq 1>
		
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").value=no;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_code")>
	
		<cfif listlen(attributes.field_code,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_code#").value=code;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_code#</cfoutput>.value=code;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_name")>
	
		<cfif listlen(attributes.field_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").value=deger;
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").focus();
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_id_1")>
		var activity_id_ = ( activity_id != '' ) ? activity_id : '<cf_get_lang dictionary_id='33167.Akitivite Tipi'>';
		<cfif listlen(attributes.field_id_1,".") eq 1>
		
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id_1#").value=activity_id;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id_1#</cfoutput>.value=activity_id;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_acc_name")>
	
		<cfif listlen(attributes.field_acc_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_acc_name#").value=no+' - '+deger;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_acc_name#</cfoutput>.value=no+' - '+deger;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_acc_code_name")>
	
		<cfif listlen(attributes.field_acc_code_name,".") eq 1>
			<cfoutput>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_acc_code_name#").value=code+' - '+deger;
			</cfoutput>
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_acc_code_name#</cfoutput>.value=code+' - '+deger;
		</cfif>
	</cfif>
	<cfif isdefined('attributes.call_function')>
		<cfif isdefined('attributes.call_function_parameter')>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.call_function#(#attributes.call_function_parameter#);</cfoutput>
		<cfelse>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.call_function#();</cfoutput>
		</cfif>
	</cfif>
	
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}

function control()
{
	if($('#call_function_parameter').val()){
		var action = $('form[name =list_expense_center]').attr('action');
		action += $('#call_function_parameter').val();
		$('form[name =list_expense_center]').attr('action', action);
	}
	return true;
}
</script>
