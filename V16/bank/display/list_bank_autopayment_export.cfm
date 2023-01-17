<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfparam name="attributes.source" default="1">
<cfparam name="attributes.bank_name" default="">
<cfparam name="attributes.bank" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_AUTOPAYM" datasource="#DSN2#">
		SELECT
			FILE_NAME,
			TARGET_SYSTEM,
			FILE_EXPORTS.RECORD_DATE,
			FILE_EXPORTS.RECORD_EMP,
			IS_IPTAL,
			E_ID,
			FILE_EXPORT_TYPE,
			IS_DBS,
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME,
			BANK_NAME
		FROM
			FILE_EXPORTS
			LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = FILE_EXPORTS.RECORD_EMP
			LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON BANK_ID = TARGET_SYSTEM
		WHERE
			PROCESS_TYPE = -11 AND
			FILE_EXPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
            <cfif attributes.source eq 2>
            	AND IS_DBS = 1 
				<cfif len(attributes.bank)>
					AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
				</cfif>
            <cfelseif attributes.source eq 1>
	            AND 
				(IS_DBS = 0 OR IS_DBS IS NULL) 
				<cfif len(attributes.bank_name)>
					AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
				</cfif>
            </cfif>
		ORDER BY
			E_ID DESC
	</cfquery>
<cfelse>
  	<cfset get_autopaym.recordcount = 0>
</cfif>
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_autopaym.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.list_bank_autopayment_export">
			<input name="is_submitted" id="is_submitted" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<select name="source" id="source" onChange="display_();"> 
						<option value="0"><cf_get_lang dictionary_id="48801.Kaynak"></option>
						<option value="1" <cfif attributes.source eq 1>selected</cfif>><cf_get_lang dictionary_id="48800.Sistem Ödeme Planı"></option>
						<option value="2" <cfif attributes.source eq 2>selected</cfif>><cf_get_lang dictionary_id="48801.Fatura Ödeme Planı"></option>
					</select>
				</div>
				<div class="form-group" id="pos_2" <cfif attributes.source eq 2>style="display:none;"</cfif>>
					<select name="bank_name" id="bank_name">
						<option value=""><cf_get_lang dictionary_id="57521.Banka"></option>
						<option value="17" <cfif attributes.bank_name eq 17>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
						<option value="20" <cfif attributes.bank_name eq 20>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
						<option value="11" <cfif attributes.bank_name eq 11>selected</cfif>><cf_get_lang dictionary_id="48765.Finansbank"></option>
						<option value="21" <cfif attributes.bank_name eq 21>selected</cfif>><cf_get_lang dictionary_id="48776.Fortis"></option>
						<option value="13" <cfif attributes.bank_name eq 13>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
						<option value="10" <cfif attributes.bank_name eq 10>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
						<option value="12" <cfif attributes.bank_name eq 12>selected</cfif>><cf_get_lang dictionary_id="48730.İşBankası"></option>
						<option value="14" <cfif attributes.bank_name eq 14>selected</cfif>><cf_get_lang dictionary_id="48766.OyakBank"></option>
						<option value="18" <cfif attributes.bank_name eq 18>selected</cfif>><cf_get_lang dictionary_id="48771.PTT"></option>
						<option value="15" <cfif attributes.bank_name eq 15>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
						<option value="22" <cfif attributes.bank_name eq 22>selected</cfif>><cf_get_lang dictionary_id="48760.Vakıf Bank"></option>
						<option value="16" <cfif attributes.bank_name eq 16>selected</cfif>><cf_get_lang dictionary_id="48784.YKB"></option>
						<option value="19" <cfif attributes.bank_name eq 19>selected</cfif>><cf_get_lang dictionary_id="48774.Ziraat Bankası"></option>
						<option value="23" <cfif attributes.bank_name eq 23>selected</cfif>><cf_get_lang dictionary_id = "42726.Halkbank"></option>
						<option value="24" <cfif attributes.bank_name eq 24>selected</cfif>><cf_get_lang dictionary_id = "51519.Odeabank"></option>
						<option value="25" <cfif attributes.bank_name eq 25>selected</cfif>><cf_get_lang dictionary_id = "51551.Şekerbank"></option>
					</select>   
				</div>
				<div class="form-group" id="bank_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>
					<select name="bank" id="bank">
						<option value=""><cf_get_lang dictionary_id="57521.Banka"></option>
						<cfoutput query="get_bank_names">
							<option value="#bank_id#" <cfif attributes.bank eq bank_id>selected</cfif>>#bank_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div> 
				<div class="form-group small">
					<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>--->
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" maxlength="3" validate="integer" range="1,250" required="yes">	  
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>                
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(214,'Otomatik Ödeme İşlemleri',48875)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='57468.Belge'></th>
					<th><cf_get_lang dictionary_id ='58578.Belge Türü'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>			
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>																				 															
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=bank.list_bank_autopayment_export&event=add</cfoutput>','wwide','popup_add_autopayment_export');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_autopaym.recordcount>
					<cfoutput query="get_autopaym" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><!--- statik gelen parametrelerdir --->
								<cfif is_dbs eq 1>
									#bank_name#
								<cfelse>
								<cfif len(file_export_type)>
									<cfswitch expression = "#file_export_type#">
										<cfcase value="1"><cf_get_lang dictionary_id="48732.Yapı Kredi"></cfcase>
										<cfcase value="2"><cf_get_lang dictionary_id="48729.TEB"></cfcase>
										<cfcase value="3"><cf_get_lang dictionary_id="48730.İş Bankası"></cfcase>
										<cfcase value="4"><cf_get_lang dictionary_id="48739.Denizbank"></cfcase>
										<cfcase value="5"><cf_get_lang dictionary_id="48737.Akbank"></cfcase>
										<cfcase value="6"><cf_get_lang dictionary_id="48720.HSBC"></cfcase>
										<cfcase value="7"><cf_get_lang dictionary_id="48725.Garanti"></cfcase>
										<cfcase value="8"><cf_get_lang dictionary_id="48760.Vakıf Bank"></cfcase>
									</cfswitch>
								<cfelse>
									<cfswitch expression = "#target_system#">
										<cfcase value="10"><cf_get_lang dictionary_id="48720.HSBC"></cfcase>
										<cfcase value="11"><cf_get_lang dictionary_id="48765.Finansbank"></cfcase>
										<cfcase value="12"><cf_get_lang dictionary_id="48730.İş Bankası"></cfcase>
										<cfcase value="13"><cf_get_lang dictionary_id="48725.Garanti"></cfcase>
										<cfcase value="14"><cf_get_lang dictionary_id="48766.OyakBank"></cfcase>
										<cfcase value="15"><cf_get_lang dictionary_id="48729.TEB"></cfcase>
										<cfcase value="16,30"><cf_get_lang dictionary_id="48732.Yapi Kredi"></cfcase>
										<cfcase value="17,31"><cf_get_lang dictionary_id="48737.Akbank"></cfcase>
										<cfcase value="18"><cf_get_lang dictionary_id="48771.PTT"></cfcase>
										<cfcase value="19"><cf_get_lang dictionary_id="48774.Ziraat"></cfcase>
										<cfcase value="20"><cf_get_lang dictionary_id="48739.Denizbank"></cfcase>
										<cfcase value="21"><cf_get_lang dictionary_id="48776.Fortis"></cfcase>
										<cfcase value="22"><cf_get_lang dictionary_id="48760.Vakıf Bank"></cfcase>
										<cfcase value="23"><cf_get_lang dictionary_id="42726.Halkbank"></cfcase>
										<cfcase value="24"><cf_get_lang dictionary_id="51519.Odeabank"></cfcase>
										<cfcase value="25"><cf_get_lang dictionary_id="51551.Şekerbank"></cfcase>
									</cfswitch>
								</cfif>
								</cfif> 
							</td>
							<td>#file_name#</td>
							<td><cfif ListFind('30,31',target_system)><cf_get_lang dictionary_id="48779.TOS"><cfelse>O.<cf_get_lang dictionary_id="57847.Ödeme"></cfif></td>
							<td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#name#</a></td>
							<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_bank_autopayment_export&event=file&export_import_id=#e_id#','small');"><i class="fa fa-save" alt="<cf_get_lang dictionary_id='29477.Belge Oluştur'>"></i></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10">
							<cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz!'>!</cfif> 
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_string = ''>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_string = '#url_string#&is_submitted=#attributes.is_submitted#'>
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.bank_name") and len(attributes.bank_name)>
			<cfset url_string = '#url_string#&bank_name=#attributes.bank_name#'>
		</cfif>
		<cfif isdefined("attributes.bank") and len(attributes.bank)>
			<cfset url_string = '#url_string#&bank=#attributes.bank#'>
		</cfif>
		<cfif isdefined("attributes.source") and len(attributes.source)>
			<cfset url_string = '#url_string#&source=#attributes.source#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="bank.list_bank_autopayment_export#url_string#">
	</cf_box>
</div>

<script>
	function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;	
	}
	function display_()
	{
		if (document.getElementById('source').value == 1)
		{
			gizle(bank_2);
			goster(pos_2);
		}
		else
		{
			goster(bank_2);
			gizle(pos_2);
		}
	}
</script>
