<cfsetting showdebugoutput="yes">
<!--- 
	eger db_source belli ise dbsource olarak onu kullanacak. parametre olarak db_source=company id period year da period yil bilgilisi oalrak gonderilmek zorunda.
	url üzerinden
		field_id : form_adı.id_alan_adı
		field_name : form_adı.hesapplanı_adı_yazılacak_alan_adı
	yazılacak alanları alır ve yazar
	parametreler gönderilmemişse sadece pencereyi kapar
 --->
<!--- E.A performans dolayısıyla bakiye göstermeyi xml e bağladık. "is_xml_remainder" E.A 2013.08.28 ---->
<cf_xml_page_edit>
<cf_xml_page_edit fuseact="objects.popup_account_plan">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.account_code" default=''>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_account_plan.cfm">
<cfelse>
	<cfset account_plan.recordcount = 0>	
</cfif>
<cfif account_plan.recordcount>
	<cfparam name="attributes.totalrecords" default='#account_plan.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<script type="text/javascript">
	function gonder(no,ifrs_no,deger,hesap_adi,no2)
	{
		<cfif isDefined("attributes.field_id")>
			<cfoutput>
				<cfif listlen(attributes.field_id,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").value=no;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id#.value=no;
				</cfif>
			</cfoutput>
		</cfif>
		<cfif isdefined("attributes.is_title") and len(attributes.is_title) and attributes.is_title eq 1>
			<cfif isDefined("attributes.field_id")>
				<cfoutput>
					<cfif listlen(attributes.field_id,".") eq 1>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id#").title = hesap_adi;
					<cfelse>
						<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id#.title=hesap_adi;
					</cfif>
				</cfoutput>
			</cfif>
		</cfif>
		<cfif isDefined("attributes.field_id2")>
			<cfoutput>
				<cfif listlen(attributes.field_id2,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_id2#").value = no;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id2#.value = no;
				</cfif>
			</cfoutput>
		</cfif>	
		<cfif isDefined("attributes.field_ufrs_no")>
			<cfoutput>
				<cfif listlen(attributes.field_ufrs_no,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_ufrs_no#").value = ifrs_no;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ufrs_no#.value = ifrs_no;
				</cfif>
			</cfoutput>
		</cfif>	
		<cfif isDefined("attributes.field_name")>
			<cfoutput>
				<cfif listlen(attributes.field_name,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_name#").value=deger;	
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value=deger;						
				</cfif>
			</cfoutput>
		</cfif>
		<cfif isDefined("attributes.field_acc_name")>
			<cfoutput>
				<cfif listlen(attributes.field_acc_name,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_acc_name#").value=hesap_adi;	//sadece hesap dinin gitmesi gerektigi zaman
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_acc_name#.value=hesap_adi;						//sadece hesap dinin gitmesi gerektigi zaman
				</cfif>
			</cfoutput>
		</cfif>
		//ozel kod alanı
		<cfif isDefined("attributes.field_ozel_kod")>
			<cfoutput>
				<cfif listlen(attributes.field_ozel_kod,".") eq 1>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById("#attributes.field_ozel_kod#").value=no2;
				<cfelse>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_ozel_kod#.value=no2;
				</cfif>
			</cfoutput>
		</cfif>
		<cfif isdefined("attributes.come")>
			opener.parent.upd_bill_rows.upd_bill_rows.submit();
		</cfif>
		<cfif isdefined('attributes.function_name')>
			window.opener.<cfoutput>#function_name#</cfoutput>;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function add_account(account_code)
	{  
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
			var satir = <cfoutput>#attributes.satir#</cfoutput>;
		<cfelse>
			var satir = -1;
		</cfif>
		if(window.opener.basket && satir > -1) 
			window.opener.updateBasketItemFromPopup(satir, { ROW_ACC_CODE: account_code}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20190213
		
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfscript>
	url_string = "";
	if(isdefined("attributes.form_submitted") and len(attributes.form_submitted))
		url_string = "#url_string#&form_submitted=#form_submitted#";
	if(isdefined("attributes.field_id") and len(attributes.field_id))
		url_string = "#url_string#&field_id=#field_id#";
	if(isdefined("attributes.come") and len(attributes.come))
		url_string = "#url_string#&come=#attributes.come#";
	if(isdefined("attributes.field_id2") and len(attributes.field_id2))
		url_string = "#url_string#&field_id2=#attributes.field_id2#";
	if(isdefined("attributes.field_ufrs_no") and len(attributes.field_ufrs_no))
		url_string = "#url_string#&field_ufrs_no=#attributes.field_ufrs_no#";
	if(isdefined("attributes.field_name") and len(attributes.field_name))
		url_string = "#url_string#&field_name=#attributes.field_name#";
	if(isdefined("attributes.field_acc_name") and len(attributes.field_acc_name))
		url_string = "#url_string#&field_acc_name=#attributes.field_acc_name#";
	if(isdefined("attributes.field_ozel_kod") and len(attributes.field_ozel_kod))
		url_string = "#url_string#&field_ozel_kod=#attributes.field_ozel_kod#";
	if(isdefined("attributes.code") and len(attributes.code))
		url_string = "#url_string#&code=#attributes.code#";
	if(isdefined("attributes.db_source") and len(attributes.db_source))
		url_string = "#url_string#&db_source=#attributes.db_source#";
	if(isdefined("attributes.period_year") and len(attributes.period_year))
		url_string = "#url_string#&period_year=#attributes.period_year#";
	if(isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi))
		url_string = "#url_string#&nereden_geldi=#attributes.nereden_geldi#";
	if(isdefined("attributes.search_account_code") and len(attributes.search_account_code))
		url_string = "#url_string#&search_account_code=#attributes.search_account_code#";
	if(isdefined("attributes.function_name") and len(attributes.function_name))
		url_string = "#url_string#&function_name=#attributes.function_name#";
	if(isdefined("attributes.satir") and len(attributes.satir))
		url_string = "#url_string#&satir=#attributes.satir#";
	if(isdefined("attributes.#listfirst(session.dark_mode,":").trim()#"))
		url_string = "#url_string#&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#";
</cfscript>
<cfparam name="attributes.model_id" default="">

<cf_box title="#getLang('','Hesaplar',58818)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
	<ul class="link-list">
		<cfoutput>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan#url_string#',#attributes.modal_id#);">0</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=1#url_string#',#attributes.modal_id#);">1</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=2#url_string#',#attributes.modal_id#);">2</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=3#url_string#',#attributes.modal_id#);">3</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=4#url_string#',#attributes.modal_id#);">4</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=5#url_string#',#attributes.modal_id#);">5</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=6#url_string#',#attributes.modal_id#);">6</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=7#url_string#',#attributes.modal_id#);">7</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=8#url_string#',#attributes.modal_id#);">8</a></li>
			<li><a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&account_code=9#url_string#',#attributes.modal_id#);">9</a></li>
		</cfoutput>
	</ul>
	<cfform name="acc" action="#request.self#?fuseaction=objects.popup_account_plan&#url_string#" method="post">
		<cf_box_search more="0">
			<div class="form-group" id="account_code">
				<cfinput type="hidden" name="form_submitted" value="1">
				<cfinput name="account_code" type="text" placeholder= "#getLang('','Hesap Adı/Kodu',33499)#" value="#attributes.account_code#">
			</div>   	
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" onKeyUp="isNumber(this)" message="#getLang('','Maksimum Kayıt sayısı Hatalı',33097)#">			
			</div>
			<div class="form-group">    
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('acc' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>	
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='32633.Hesap Kodu'></th>
				<cfif session.ep.our_company_info.is_ifrs eq 1><th><cf_get_lang dictionary_id='34273.UFRS Code'></th></cfif>
				<th><cf_get_lang dictionary_id='32634.Hesap Adı'></th>
				<cfif isdefined("is_xml_remainder") and is_xml_remainder eq 1 >
					<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
				</cfif>
				<th width="20"><a><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></a></th>
				<th width="20"><a><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></th>
				<th width="20"><a><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<cfif isdefined("attributes.form_submitted")>
			<tbody>
			<cfif account_plan.recordcount>
				<cfoutput query="account_plan">
				<tr>
					<cfset list="'">
					<cfset list2=" ">
					<cfset straccount_name = replace(account_name,'#list#',' ','all')>
					<td>
						<cfif ListLen(account_code,".") neq 1>
							<cfloop from="1" to="#ListLen(account_code,'.')#" index="i">&nbsp;</cfloop>
						</cfif>#account_code#
					</td>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						<td>
							<cfif sub_account eq 0 or not len(sub_account)>
								<cfset str_ifrs_name = replace(ifrs_name,'#list#',' ','all')>
								<cfif isdefined('attributes.satir')>
									<a href="javascript://" onclick="add_account('#account_code#');">#ifrs_code#</a>
								<cfelse>
									<a href="javascript://" onclick="gonder('#account_code#','#ifrs_code#','#account_code#-#str_ifrs_name#','#straccount_name#','#account_code2#');" id="satir_#currentrow#">#ifrs_code#</a>
								</cfif>
							<cfelse>
								#ifrs_code#
							</cfif>
						</td>
					</cfif>
					<td>
						<cfif sub_account eq 0 or not len(sub_account)>
							<cfif isdefined('attributes.satir')>
								<a href="javascript://" onclick="add_account('#account_code#');">#straccount_name#</a>
							<cfelse>
								<a href="javascript://" onclick="gonder('#account_code#','#ifrs_code#','#account_code#-#straccount_name#','#straccount_name#','#account_code2#');" id="satir_#currentrow#">#straccount_name#</a>
							</cfif>
						<cfelse>
							#straccount_name#
						</cfif>
					</td>
					<cfif isdefined("is_xml_remainder") and is_xml_remainder eq 1 >
						<td class="moneybox"><cfif bakiye lt 0 and len(bakiye)><font color="red">#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='29684.A'>)</font><cfelseif bakiye gt 0 and len(bakiye)>#TLFormat(abs(bakiye))# (<cf_get_lang dictionary_id='58591.B'>)<cfelse>#TLFormat(0)#</cfif></td>
					</cfif>
					<td width="20">
						<cfif sub_account eq 0 or not len(sub_account)>
							<a href="javascript:windowopen('#request.self#?fuseaction=account.popup_list_account_plan_rows&code=#account_code#','wide');"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></a>
						</cfif>
					</td>
					<td width="20">
						<cfif get_module_user(22) and not listfindnocase(denied_pages,'objects.popup_form_upd_account')>
							<a href="#request.self#?fuseaction=objects.popup_form_upd_account&account_id=#account_id##url_string#&search_account_code=#attributes.account_code#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
						</cfif>
					</td>
					<td width="20">
						<cfif get_module_user(22) and not listfindnocase(denied_pages,'account.list_account_plan')>
							<a href="#request.self#?fuseaction=account.list_account_plan&event=sub&account_id=#account_id##url_string#&nereden_geldi=2&search_account_code=#attributes.account_code#"><i class="fa fa-plus"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</cfif>
					</td>
				</tr>
				</cfoutput>
				<cfelse>
					<cfif isnumeric(left(attributes.account_code,3))>
						<cfif listlen(attributes.account_code,".") lt 2>
							<script type="text/javascript">
								window.location.href = '<cfoutput>#request.self#?fuseaction=account.list_account_plan&event=add#url_string#</cfoutput>&nereden_geldi=2&acc_code=<cfoutput>#attributes.account_code#</cfoutput>';
							</script>
						<cfelse>
							<cfquery name="GET_SUB_ACC_" datasource="#dsn2#">
								SELECT ACCOUNT_CODE,ACCOUNT_ID FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#listdeleteat(attributes.account_code, listlen(attributes.account_code,"."), ".")#'
							</cfquery>
							<cfif not get_sub_acc_.recordcount>
								<script type="text/javascript">
									alert('<cfoutput>#listdeleteat(attributes.account_code, listlen(attributes.account_code,"."), ".")#</cfoutput>' + "<cf_get_lang dictionary_id='60076.Üst Hesap Kodu Tanımlı Değil'> !");
									<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
								</script>
							<cfelse>
								<script type="text/javascript">
									window.location.href = '<cfoutput>#request.self#?fuseaction=account.list_account_plan&event=sub#url_string#</cfoutput>&nereden_geldi=2&no_ref=1<cfoutput>&account_id=#get_sub_acc_.account_id#&search_account_code=#attributes.account_code#</cfoutput>';
								</script>
							</cfif>
						</cfif>
						<cfabort>
					</cfif>
					<tr>
						<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
		</tbody>
		<cfelse>
			<tbody>
				<tr>
					<cfif session.ep.our_company_info.is_ifrs eq 1>
						<td colspan="7"><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</td>
					<cfelse>
						<td colspan="7"><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</td>
					</cfif>	    
				</tr>
			</tbody>
		</cfif>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif isdefined("attributes.account_code") and len(attributes.account_code)>
			<cfset url_string = "#url_string#&account_code=#attributes.account_code#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#"
			adres="objects.popup_account_plan#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>

<script type="text/javascript">
	document.getElementById('account_code').focus();
</script>
