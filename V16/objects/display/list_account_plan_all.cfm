<!--- 
url üzerinden
	field_id : form_adı.id_alan_adı
	field_name : form_adı.hesapplanı_adı_yazılacak_alan_adı
yazılacak alanları alır ve yazar
parametreler gönderilmemişse sadece pencereyi kapar
 ---> 
<cfparam name="attributes.account_code" default="">
<!--- Hesap adina gore arama filtre alanı için eklendi 20140520 --->
<cfparam name="attributes.accountname" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	

<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_account_plan_all.cfm">
<cfelse>
	<cfset account_plan.recordcount = 0>
</cfif>
<cfif account_plan.recordcount>
	<cfparam name="attributes.totalrecords" default='#account_plan.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>

<cfset url_string = "">
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_id2") and len(attributes.field_id2)>
	<cfset url_string = "#url_string#&field_id2=#attributes.field_id2#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_name_2") and len(attributes.field_name_2)>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name_2#">
</cfif>
<cfif isdefined("attributes.come") and len(attributes.come)>
	<cfset url_string = "#url_string#&come=#attributes.come#">
</cfif>
<cfif isdefined("attributes.db_source") and len(attributes.db_source)>
	<cfset url_string = "#url_string#&db_source=#attributes.db_source#">
</cfif>
<cfif isdefined("attributes.period_year") and len(attributes.period_year)>
	<cfset url_string = "#url_string#&period_year=#attributes.period_year#">
</cfif>
<cfif isdefined("attributes.account_code") and len(attributes.account_code)>
	<cfset url_string = "#url_string#&account_code=#attributes.account_code#">
</cfif>
<!--- Hesap adina gore arama filtre alanı için eklendi 20140520 --->
<cfif isdefined("attributes.accountname") and len(attributes.accountname)>
	<cfset url_string = "#url_string#&accountname=#attributes.accountname#">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Hesaplar',58818)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form" method="post" action="#request.self#?fuseaction=objects.popup_account_plan_all">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<cfinput name="account_code" placeholder="#getLang('','Filtre',57460)#" value="#attributes.account_code#">
					<cfif isDefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
					<cfif isDefined("attributes.field_id2")><input type="hidden" name="field_id2" id="field_id2" value="<cfoutput>#attributes.field_id2#</cfoutput>"></cfif>	
					<cfif isDefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>		  
					<cfif isDefined("attributes.field_name_2")><input type="hidden" name="field_name_2" id="field_name_2" value="<cfoutput>#attributes.field_name_2#</cfoutput>"></cfif>	
					<cfif isDefined("attributes.changeFunctionParam2") and isdefined("attributes.changeFunctionParam")><input type="hidden" name="changeFunction" id="changeFunction" value="<cfoutput>#attributes.changeFunction#</cfoutput>"><input type="hidden" name="changeFunctionParam" id="changeFunctionParam" value="<cfoutput>#attributes.changeFunctionParam#</cfoutput>"><input type="hidden" name="changeFunctionParam2" id="changeFunctionParam2" value="<cfoutput>#attributes.changeFunctionParam2#</cfoutput>"></cfif>	 
					<cfif isDefined("attributes.changeFunction")><input type="hidden" name="changeFunction" id="changeFunction" value="<cfoutput>#attributes.changeFunction#</cfoutput>"></cfif> 
				</div>    
					<!--- Hesap adina gore arama filtre alanı için eklendi 20140520 --->
				<!--- <div class="form-group" id="item-accountname">
					<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='32634.Hesap Adı'></cfsavecontent>
						<cfinput name="account_name" placeholder="#message#" value="#attributes.accountname#">
					</div>
				</div>  --->  
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='32633.Hesap Kodu'></th>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						<th><cf_get_lang dictionary_id='34273.UFRS Code'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='32634.Hesap Adı'></th>
					<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif account_plan.recordcount and isdefined("attributes.is_form_submitted")>
					<cfoutput query="account_plan">
						<cfset straccount_name = Replace(account_name,Chr(13)," ","ALL")>
						<cfset straccount_name = Replace(straccount_name,Chr(10)," ","ALL")>
						<tr>
							<td>
								<cfif ListLen(account_code,".") neq 1>
									<cfloop from="1" to="#ListLen(account_code,".")#" index="i">&nbsp;</cfloop>
								</cfif>
								#account_code#
							</td>
							<cfif session.ep.our_company_info.is_ifrs eq 1>
								<td>
									<cfset str_ifrs_name = Replace(ifrs_name,Chr(13)," ","ALL")>
									<cfset str_ifrs_name = Replace(str_ifrs_name,Chr(10)," ","ALL")>
									<a href="javascript://" onclick="gonder('#ifrs_code#','#str_ifrs_name#');" class="tableyazi">#ifrs_code#</a>
								</td>
							</cfif>
							<td><a href="javascript://" onclick="gonder('#account_code#','#straccount_name#','#account_code# - #straccount_name#');" class="tableyazi">#account_name#</a></td>			
							<td><cfif bakiye lt 0 and len(bakiye)><font color="red">#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='29684.A'>)</font><cfelseif bakiye gt 0 and len(bakiye)>#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='58591.B'>)<cfelse>#TLFormat(0)#</cfif></td>
							<td>
								<a href="#request.self#?fuseaction=objects.popup_form_upd_account&account_id=#account_id##url_string#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='58718.Düzenle'>"></i></a>
							</td>
							<td>
								<a href="#request.self#?fuseaction=account.list_account_plan&event=sub&account_id=#account_id##url_string#&nereden_geldi=1"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='32596.Alt Hesap ekle'>"></i></a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filte Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("attributes.is_form_submitted")>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="objects.popup_account_plan_all#url_string#&is_form_submitted=1"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			</cfif>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$( "form[name=form] #keyword" ).focus();
	});

	function gonder(no,deger,deger_2)
	{
		<cfif isDefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
		<cfif isDefined("attributes.field_id2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id2#</cfoutput>.value=no;
		</cfif>	
		<cfif isDefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
		</cfif>
		<cfif isDefined("attributes.field_name_2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name_2#</cfoutput>.value=deger_2;
		</cfif>
		<cfif isDefined("attributes.changeFunction") and isdefined("attributes.changeFunctionParam") and isdefined("attributes.changeFunctionParam2")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.changeFunction#('#attributes.changeFunctionParam#','#attributes.changeFunctionParam2#')</cfoutput>;
		<cfelseif isDefined("attributes.changeFunction")>
			<cfif isdefined("attributes.draggable")><cfelse>window.opener.</cfif><cfoutput>#attributes.changeFunction#()</cfoutput>;
		</cfif>
		<cfif isdefined("attributes.come")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.parent.upd_bill_rows.upd_bill_rows.submit();
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}

</script>
