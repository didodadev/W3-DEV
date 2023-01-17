<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfquery name="get_cari_acts" datasource="#dsn2#">
	SELECT
		PAPER_NO,
		CARI_ACTION_ID,
		ACTION_DATE,
		DUE_DATE,
		ACTION_ID,
		OTHER_CASH_ACT_VALUE,
		OTHER_MONEY,
		ACTION_TYPE_ID,
		ACTION_TABLE,
		PROCESS_CAT,
		ACTION_NAME
	FROM
		CARI_ROWS
	WHERE
		(ACTION_TYPE_ID IN(251,241,90,97,42,40,420,43) OR (ACTION_TYPE_ID IN (31,24) AND PROCESS_CAT NOT IN (SELECT PROCESS_CAT_ID FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 121)))
		AND (FROM_CMP_ID IS NOT NULL OR FROM_CONSUMER_ID IS NOT NULL)
		<cfif isDefined("attributes.cat") and len(attributes.cat)>
			AND ACTION_TYPE_ID IN(#attributes.cat#)
		</cfif>
		<cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
			AND PAPER_NO LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%'
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND ACTION_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND ACTION_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
			AND FROM_CMP_ID IN (#attributes.comp_id#)
		</cfif>
		<cfif isdefined('attributes.cons_id') and len(attributes.cons_id)>
			AND FROM_CONSUMER_ID IN (#attributes.cons_id#)
		</cfif>
	ORDER BY
		ACTION_DATE
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_cari_acts.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function add_cari(cari_action_id,period_id,act_id,act_type,act_table)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = cari_action_id;
		</cfif>
		<cfif isdefined("attributes.field_period_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_period_id#</cfoutput>.value = period_id;
		</cfif>
		<cfif isdefined("attributes.field_act_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_act_id#</cfoutput>.value = act_id;
		</cfif>
		<cfif isdefined("attributes.field_act_type")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_act_type#</cfoutput>.value = act_type;
		</cfif>
		<cfif isdefined("attributes.field_act_table")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_act_table#</cfoutput>.value = act_table;
		</cfif>
		<cfif isdefined("attributes.is_paid")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#is_paid#</cfoutput>.checked = true;
		</cfif>
		<cfif isdefined('attributes.call_function') and isdefined('attributes.call_function_param')>
            <cfoutput><cfif not isdefined("attributes.draggable")>window.opener</cfif>.#attributes.call_function#('#attributes.call_function_param#');</cfoutput>
			<cfif isdefined("attributes.is_main")>
          	<cfoutput><cfif not isdefined("attributes.draggable")>window.opener</cfif>.#attributes.call_function#(20);</cfoutput>
			</cfif>
        <cfelseif isdefined("attributes.call_function")>
            <cfif not isdefined("attributes.draggable")>window.opener</cfif>.<cfoutput>#call_function#</cfoutput>();
        </cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<cfset url_string="">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("attributes.field_period_id")>
	<cfset url_string = "#url_string#&field_period_id=#field_period_id#">
</cfif>
<cfif isdefined("attributes.cons_id")>
	<cfset url_string = "#url_string#&cons_id=#attributes.cons_id#">  
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfset url_string = "#url_string#&comp_id=#attributes.comp_id#">  
</cfif>
<cfif isdefined("attributes.is_paid")>
	<cfset url_string = "#url_string#&is_paid=#is_paid#">
</cfif>
<cfif isdefined("attributes.field_act_id")>
	<cfset url_string = "#url_string#&field_act_id=#attributes.field_act_id#">
</cfif>
<cfif isdefined("attributes.field_act_type")>
	<cfset url_string = "#url_string#&field_act_type=#attributes.field_act_type#">
</cfif>
<cfif isdefined("attributes.field_act_table")>
	<cfset url_string = "#url_string#&field_act_table=#attributes.field_act_table#">
</cfif>
<cfif isDefined('attributes.call_function') and len(attributes.call_function)>
    <cfset url_string = "#url_string#&call_function=#attributes.call_function#">
</cfif>
<cfif isDefined('attributes.call_function_param') and len(attributes.call_function_param)>
    <cfset url_string = "#url_string#&call_function_param=#attributes.call_function_param#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="Tahsilatlar" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_cari_actions" action="#request.self#?fuseaction=objects.popup_list_cari_actions#url_string#" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<select name="cat" id="cat">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<OPTGROUP LABEL="<cf_get_lang dictionary_id='58896.Banka İşlemleri'>">
							<option value="24" <cfif listfind(attributes.cat,24)>selected</cfif>><cf_get_lang dictionary_id='57834.Gelen Havale'></option>
							<option value="251" <cfif listfind(attributes.cat,251)>selected</cfif>><cf_get_lang dictionary_id ='58165.Gelen Banka Talimatı'></option>
							<option value="241" <cfif listfind(attributes.cat,241)>selected</cfif>><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></option>
						</OPTGROUP>
						<OPTGROUP LABEL="<cf_get_lang dictionary_id='58897.Kasa İşlemleri'>">
							<option value="31" <cfif listfind(attributes.cat,31)>selected</cfif>><cf_get_lang dictionary_id='57845.Tahsilat'></option>
						</OPTGROUP>
						<OPTGROUP LABEL="<cf_get_lang dictionary_id='58900.Çek Senet İşlemleri'>">
							<option value="90" <cfif listfind(attributes.cat,90)>selected</cfif>><cf_get_lang dictionary_id='57852.Çek Giriş Bordrosu'></option>
							<option value="97" <cfif listfind(attributes.cat,97)>selected</cfif>><cf_get_lang dictionary_id='58010.Senet Giriş Bordrosu'></option>
						</OPTGROUP>
						<OPTGROUP LABEL="Cari İşlemler">
							<option value="42" <cfif listfind(attributes.cat,42)>selected</cfif>><cf_get_lang dictionary_id='57848.Alacak Dekontu'></option>
							<option value="420" <cfif listfind(attributes.cat,420)>selected</cfif>><cf_get_lang dictionary_id='29571.Toplu Alacak Dekontu'></option>
							<option value="43" <cfif listfind(attributes.cat,43)>selected</cfif>><cf_get_lang dictionary_id='29567.Cari Virman'></option>
							<option value="40" <cfif listfind(attributes.cat,40)>selected</cfif>><cf_get_lang dictionary_id='58756.Açılış Fişi'></option>
						</OPTGROUP>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','başlama girmelisiniz',57655)#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','bitiş tarihi girmelisiniz',57739)#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt sayısı hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button is_excel='0' button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_cari_actions' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="75"><cf_get_lang dictionary_id='32695.Cari Action ID'></th>
					<th width="90"><cf_get_lang dictionary_id='57880.Belge No'></th>		
					<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>		
					<th><cf_get_lang dictionary_id='57673.Tutar'></th> 
					<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th> 
				</tr>
			</thead>
			<tbody>
				<cfset process_cat_id_list=''>
					<cfoutput query="get_cari_acts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif not listfind(process_cat_id_list,process_cat)>
							<cfset process_cat_id_list=listappend(process_cat_id_list,process_cat)>
						</cfif>
					</cfoutput>
					<cfif len(process_cat_id_list)>					
						<cfquery name="GET_PROCESS_CAT_ROW" datasource="#dsn3#">
							SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY	PROCESS_CAT_ID
						</cfquery>
						<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif get_cari_acts.recordcount>
						<cfoutput query="get_cari_acts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td><a href="javascript://" class="tableyazi" onclick="add_cari('#cari_action_id#','#session.ep.period_id#','#action_id#','#action_type_id#','#action_table#');">#cari_action_id#</a></td>
								<td><a href="javascript://" class="tableyazi" onclick="add_cari('#cari_action_id#','#session.ep.period_id#','#action_id#','#action_type_id#','#action_table#');">#paper_no#</a></td>
								<td><cfif len(process_cat_id_list) and action_id neq -1>#get_process_cat_row.process_cat[listfind(process_cat_id_list,process_cat,',')]#<cfelse>#action_name#</cfif></td>
								<td align="center">#dateformat(action_date,dateformat_style)#</td>
								<td align="center">#dateformat(due_date,dateformat_style)#</td>
								<td style="text-align:right;">#TLFormat(other_cash_act_value)#</td>
								<td style="text-align:right;">#other_money#</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="7" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.cat)>
				<cfset url_string = "#url_string#&cat=#attributes.cat#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdate(attributes.start_date)>
				<cfset url_string = "#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset url_string = "#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_cari_actions#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>	
