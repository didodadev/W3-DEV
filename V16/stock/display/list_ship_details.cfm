<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.eshipment_associate" default="">
<cfset purchase_sales = ( len(attributes.eshipment_associate) and attributes.eshipment_associate eq 1 ? 0 : 1 ) >

<cfparam name="attributes.is_form_submitted" default="">
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfinclude template="../query/get_ship_method.cfm">
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="GET_SHIPPINGS" datasource="#DSN2#">
		SELECT
			CAST(S.ADDRESS AS NVARCHAR(1000)) ADDRESS,
			S.SHIP_ID,
			S.SHIP_STATUS,
			S.SHIP_NUMBER,
			S.SHIP_TYPE,
			S.SHIP_DATE,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.PARTNER_ID,
			S.DELIVER_STORE_ID,
			S.NETTOTAL,
			S.SHIP_METHOD,
			S.DELIVER_STORE_ID DEP_ID,
			S.ORDER_ID,
			D.DEPARTMENT_HEAD,
			S.PROJECT_ID,
			P.PROJECT_HEAD,
			P.PROJECT_NUMBER
		FROM
			SHIP S
			LEFT JOIN #dsn_alias#.PRO_PROJECTS P ON P.PROJECT_ID = S.PROJECT_ID
			LEFT JOIN #dsn_alias#.DEPARTMENT D ON D.DEPARTMENT_ID = S.DELIVER_STORE_ID 
		WHERE
			S.PURCHASE_SALES = #purchase_sales#
			<cfif isdefined("attributes.ship_method") and len(attributes.ship_method)>
				AND S.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method#">
			</cfif>			
			<cfif isdefined("attributes.ship_id_list") and len(attributes.ship_id_list)>
				AND S.SHIP_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id_list#" list="yes">)
			</cfif>
			<cfif isdefined("attributes.ship_type_list") and len(attributes.ship_type_list)>
				AND S.SHIP_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_type_list#" list="yes">)
			</cfif>
			<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
				AND S.PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#" list="yes">)
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND S.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfif>
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND S.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND S.SHIP_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
			<cfif len(attributes.start_date)>
				AND S.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND S.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			</cfif>
			<cfif isdefined("attributes.ship_list") and len(attributes.ship_list)>
				AND S.SHIP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_list#" list="yes">)
			</cfif>
			<cfif isdefined("attributes.deliver_company_id") and len(attributes.deliver_company_id)>
				AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_company_id#">
			</cfif>
            <cfif isdefined("attributes.deliver_consumer_id") and len(attributes.deliver_consumer_id)>
				AND S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_consumer_id#">
			</cfif>
           
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>
            	<cfif attributes.project_id eq -1>
                    AND S.PROJECT_ID IS NULL
                <cfelse>
                    AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif> 
			</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND 
				(	S.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">) OR 
					S.DELIVER_STORE_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#"> )
				)
			</cfif>
			AND S.SHIP_ID NOT IN (SELECT SHIP_ID FROM GET_SHIP_RESULT WHERE IS_TYPE = 'SHIP' AND SHIP_ID IS NOT NULL)
	</cfquery>
<cfelse>
	<cfset get_shippings.recordcount=0>
</cfif>

<cfset url_str = "">
<cfif isdefined("attributes.ship_id") and len(attributes.ship_id)>
	<cfset url_str = "#url_str#&ship_id=#attributes.ship_id#">
</cfif>
<cfif isdefined("attributes.ship_number") and len(attributes.ship_number)>
	<cfset url_str = "#url_str#&ship_number=#attributes.ship_number#">
</cfif>
<cfif isdefined("attributes.ship_date") and len(attributes.ship_date)>
	<cfset url_str = "#url_str#&ship_date=#attributes.ship_date#">
</cfif>
<cfif isdefined("attributes.ship_deliver") and len(attributes.ship_deliver)>
	<cfset url_str = "#url_str#&ship_deliver=#attributes.ship_deliver#">
</cfif>
<cfif isdefined("attributes.ship_type") and len(attributes.ship_type)>
	<cfset url_str = "#url_str#&ship_type=#attributes.ship_type#">
</cfif>
<cfif isdefined("attributes.ship_type_id") and len(attributes.ship_type_id)>
	<cfset url_str = "#url_str#&ship_type_id=#attributes.ship_type_id#">
</cfif>
<cfif isdefined("attributes.ship_adress") and len(attributes.ship_adress)>
	<cfset url_str = "#url_str#&ship_adress=#attributes.ship_adress#">
</cfif>
<cfif isdefined("attributes.ship_id_list") and len(attributes.ship_id_list)>
	<cfset url_str = "#url_str#&ship_id_list=#attributes.ship_id_list#">
</cfif>
<cfif isdefined("attributes.ship_type_list") and len(attributes.ship_type_list)>
	<cfset url_str = "#url_str#&ship_type_list=#attributes.ship_type_list#">
</cfif>
<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
	<cfset url_str = "#url_str#&process_cat=#attributes.process_cat#">
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
	<cfset url_str = "#url_str#&location_id=#attributes.location_id#">
</cfif>
<cfif isdefined("attributes.eshipment_associate") and len(attributes.eshipment_associate)>
	<cfset url_str = "#url_str#&eshipment_associate=#attributes.eshipment_associate#">
</cfif>
<cfif isdefined("attributes.deliver_company_id") and len(attributes.deliver_company_id)>
	<cfset url_str = "#url_str#&deliver_company_id=#attributes.deliver_company_id#">
</cfif>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_shippings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='45485.İrsaliyeler'> <cfif isdefined('attributes.assetp_id')><cf_get_lang dictionary_id='58480.Araç'> : <cfoutput>#get_it_assets.assetp#</cfoutput></cfif></cfsavecontent>
<cf_box title="#head#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details#url_str#">
		<cf_box_search more="0">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<div class="form-group">
				<cfinput type="text" name="keyword"  placeholder="#getLang('main','Filtre',57460)#" value="#attributes.keyword#" maxlength="50" style="width:80px;">
			</div>	
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" message="#message#" style="width:65px;">
					<span class="input-group-addon btnPointer"> <cf_wrk_date_image date_field="start_date"></span>
				</div>
			</div>	
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" message="#message#" style="width:65px;">
					<span class="input-group-addon btnPointer"> <cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>	
			<div class="form-group">
				<div class="input-group">
					<cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#"> 
					<input type="text" name="project_head" id="project_head" placeholder=<cfoutput>"#getLang('main',4)#"</cfoutput> onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off" value="<cfif Len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" style="width:100px;">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=attributes.project_id&project_head=attributes.project_head');"></span>
				</div>
			</div>	
			<div class="form-group">
				<select name="ship_method" id="ship_method">
					<option value=""><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></option>
					<cfoutput query="get_ship_method">
						<option value="#ship_method_id#"<cfif attributes.ship_method eq ship_method_id>selected</cfif>>#ship_method#</option>
					</cfoutput>
				</select>
			</div>	
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("date_check(form.start_date,form.finish_date,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#') && loadPopupBox('form' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="20"></th>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="75"><cf_get_lang dictionary_id='57880.Belge No'></th>
				<th><cf_get_lang dictionary_id='58733.Alıcı'></th>
				<th width="100"><cf_get_lang dictionary_id='58763.Depo'></th>
				<th width="100"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
				<th><cf_get_lang dictionary_id='45487.Teslim Adres'></th>
				<th width="75"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
				<th width="75"><cf_get_lang dictionary_id='57416.Proje'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_shippings.recordcount and isdefined("attributes.is_form_submitted")>
				<cfset ship_method_list=''>
				<cfset company_id_list=''>
				<cfset consumer_id_list=''>
				<cfoutput query="get_shippings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(ship_method) and not listfind(ship_method_list,ship_method)>
						<cfset ship_method_list = listappend(ship_method_list,ship_method)>
					</cfif>
					<cfif len(company_id) and not listfind(company_id_list,company_id)>
						<cfset company_id_list = listappend(company_id_list,company_id)>
					</cfif>
					<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
						<cfset consumer_id_list = listappend(consumer_id_list,consumer_id)>
					</cfif>
				</cfoutput>
				<cfif len(ship_method_list)>
					<cfset ship_method_list=listsort(ship_method_list,"numeric","ASC",",")>
					<cfquery name="GET_SHIP_METHODS" datasource="#DSN#">
						SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID IN (#ship_method_list#) ORDER BY SHIP_METHOD_ID
					</cfquery>
					<cfset main_ship_method_list = listsort(listdeleteduplicates(valuelist(get_ship_methods.ship_method_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(company_id_list)>
					<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
					<cfquery name="GET_COMPANY" datasource="#DSN#">
						SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
					</cfquery>
					<cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(consumer_id_list)>
					<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CONSUMER" datasource="#DSN#">
						SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_shippings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="25" align="center" id="ship_#currentrow#" class="color-row" onClick="gizle_goster(ship_detail#currentrow#);connectAjax(#currentrow#,'#ship_id#');gizle_goster(ship_goster#currentrow#);gizle_goster(ship_gizle#currentrow#);">
							<img id="ship_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
							<img id="ship_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
						</td>
						<td>#currentrow#</td>
						<td><a href="javascript://" class="tableyazi" onClick="gonder('#ship_id#','#ship_number#','#dateformat(ship_date,dateformat_style)#','<cfif len(company_id)>#get_company.nickname[listfind(main_company_id_list,get_shippings.company_id,',')]#<cfelseif len(consumer_id)>#get_consumer.consumer_name[listfind(main_consumer_id_list,get_shippings.consumer_id,',')]#&nbsp;#get_consumer.consumer_surname[listfind(main_consumer_id_list,get_shippings.consumer_id,',')]#</cfif>','<cfif len(ship_method)>#get_ship_methods.ship_method[listfind(main_ship_method_list,get_shippings.ship_method,',')]#</cfif>','#trim(address)#')">#ship_number#</a></td>
						<td>
							<cfif len(company_id)>#get_company.nickname[listfind(main_company_id_list,get_shippings.company_id,',')]#
							<cfelseif len(consumer_id)>#get_consumer.consumer_name[listfind(main_consumer_id_list,get_shippings.consumer_id,',')]#&nbsp;#get_consumer.consumer_surname[listfind(main_consumer_id_list,get_shippings.consumer_id,',')]#
							<cfelse>
							</cfif>
						</td>
						<td>#department_head#</td>
						<td><cfif len(ship_method)>#get_ship_methods.ship_method[listfind(main_ship_method_list,get_shippings.ship_method,',')]#</cfif></td>
						<td>#address#</td>
						<td><cfif len(ship_date)>#dateformat(ship_date,dateformat_style)#</cfif></td>
						<td>#PROJECT_HEAD#</td>
					</tr>
					<tr id="ship_detail#currentrow#" class="color-list" style="display:none">
						<td colspan="9"><div align="left" id="SHIP_DETAIL_INFO#currentrow#"></div></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="9"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif isdefined("attributes.is_form_submitted")>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.ship_method)>
				<cfset url_str = "#url_str#&ship_method=#attributes.ship_method#">
			</cfif>
			<cfif len(attributes.project_id)>
				<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
			</cfif>
			<cfif len(attributes.eshipment_associate)>
				<cfset url_str = "#url_str#&eshipment_associate=#attributes.eshipment_associate#">
			</cfif>
			<cfif len(attributes.project_head)>
				<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details&#url_str#&is_form_submitted=1"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(ship_id,ship_number,ship_date,ship_deliver,ship_type,ship_address)
	{
		<cfif isDefined('attributes.is_multi')>
			<cfif isDefined('attributes.ship_id')>
				<cfoutput>#attributes.ship_id#</cfoutput>.value=ship_id;
			</cfif>
			<cfif isDefined('attributes.ship_number')>
				document.getElementById('<cfoutput>#attributes.ship_number#</cfoutput>').value=ship_number;
			</cfif>
			<cfif isDefined('attributes.ship_date')>
				document.getElementById('<cfoutput>#attributes.ship_date#</cfoutput>').value=ship_date;
			</cfif>
			<cfif isDefined('attributes.ship_deliver')>
				document.getElementById('<cfoutput>#attributes.ship_deliver#</cfoutput>').value=ship_deliver;
			</cfif>
			<cfif isDefined('attributes.ship_type')>
				document.getElementById('<cfoutput>#attributes.ship_type#</cfoutput>').value=ship_type;
			</cfif>
			<cfif isDefined('attributes.ship_adress')>
				document.getElementById('<cfoutput>#attributes.ship_adress#</cfoutput>').value=ship_address;
			</cfif>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		<cfelse>
			<cfif isDefined('attributes.ship_id')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_id#</cfoutput>.value=ship_id;
			</cfif>
			<cfif isDefined('attributes.ship_number')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_number#</cfoutput>.value=ship_number;
			</cfif>
			<cfif isDefined('attributes.ship_date')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_date#</cfoutput>.value=ship_date;
			</cfif>
			<cfif isDefined('attributes.ship_deliver')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_deliver#</cfoutput>.value=ship_deliver;
			</cfif>
			<cfif isDefined('attributes.ship_type')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_type#</cfoutput>.value=ship_type;
			</cfif>
			<cfif isDefined('attributes.ship_adress')>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.ship_adress#</cfoutput>.value=ship_address;
			</cfif>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfif>
	}
	function add_mon()
	{
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="project_id'+row_count+'" id="project_id'+row_count+'" value="<cfoutput>#attributes.project_id#</cfoutput>"> <input type="text" name="project_head'+ row_count+'" id="project_head'+ row_count+'" onFocus="autocomp_man('+row_count+');" value="" style="width:160px;" autocomplete="off">';
	}
	function autocomp_man()
	{
		AutoComplete_Create("project_head","project_head","project_head","get_opp","","project_id","","3","130");
	}
	function connectAjax(crtrow,ship_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=stock.list_products_from_ship&ship_id=</cfoutput>'+ship_id;
		AjaxPageLoad(bb,'SHIP_DETAIL_INFO'+crtrow,1);
	}
</script>
