<cfparam name="attributes.bank_type" default="">
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
<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
	<cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
			SELECT<!--- tahsilat kaydı yapabilmiş olanlar --->
				SUM(CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT) TOPLAM_TUTAR,
				COUNT(CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID) ADET,		
				FILE_IMPORTS.I_ID,
				FILE_IMPORTS.RECORD_EMP,
				FILE_IMPORTS.RECORD_DATE,
				FILE_IMPORTS.SOURCE_SYSTEM,
				FILE_IMPORTS.IMPORTED,
				FILE_IMPORTS.FILE_NAME
			FROM
				FILE_IMPORTS,
				#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
			WHERE
				FILE_IMPORTS.PROCESS_TYPE = -7 AND
				CREDIT_CARD_BANK_PAYMENTS.FILE_IMPORT_ID = FILE_IMPORTS.I_ID AND
				CREDIT_CARD_BANK_PAYMENTS.ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
				FILE_IMPORTS.IMPORTED = 1 AND
				FILE_IMPORTS.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#">
			<cfif len(attributes.bank_type)>
				AND SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
			</cfif>
			GROUP BY
				FILE_IMPORTS.I_ID,
				FILE_IMPORTS.RECORD_EMP,
				FILE_IMPORTS.RECORD_DATE,
				FILE_IMPORTS.SOURCE_SYSTEM,
				FILE_IMPORTS.IMPORTED,
				FILE_IMPORTS.FILE_NAME
		UNION
			SELECT<!--- import edilmemiş olanlar veya import edilip tahsilat kaydı yapamamış olanlar --->
				'' TOPLAM_TUTAR,
				'' ADET,		
				I_ID,
				RECORD_EMP,
				RECORD_DATE,
				SOURCE_SYSTEM,
				IMPORTED,
				FILE_NAME
			FROM
				FILE_IMPORTS
			WHERE
				PROCESS_TYPE = -7 AND<!--- Toplu Provizyon Import --->
				RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#"> AND
				(
						FILE_IMPORTS.IMPORTED = 0
					OR
					(
						FILE_IMPORTS.IMPORTED = 1 AND
						FILE_IMPORTS.I_ID NOT IN (SELECT FILE_IMPORT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE FILE_IMPORT_ID IS NOT NULL AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
					)
				)
			<cfif len(attributes.bank_type)>
				AND SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
			</cfif>
			ORDER BY
				FILE_IMPORTS.I_ID DESC
	</cfquery>
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset GET_PROVISION_IMPORTS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROVISION_IMPORTS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.list_multi_provision_import">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<select name="bank_type" id="bank_type" style="width:100px;">
						<option value=""><cf_get_lang dictionary_id='57521.Banka'></option>
						<option value="1" <cfif attributes.bank_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
						<option value="2" <cfif attributes.bank_type eq 2>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
						<option value="3" <cfif attributes.bank_type eq 3>selected</cfif>><cf_get_lang dictionary_id="48725.Garanti TPOS"></option>
						<option value="4" <cfif attributes.bank_type eq 4>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
						<option value="5" <cfif attributes.bank_type eq 5>selected</cfif>><cf_get_lang dictionary_id="48730.İş Bankası"></option>
						<option value="6" <cfif attributes.bank_type eq 6>selected</cfif>><cf_get_lang dictionary_id="48732.Yapi Kredi"></option>
						<option value="7" <cfif attributes.bank_type eq 7>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
						<option value="8" <cfif attributes.bank_type eq 8>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
						<option value="9" <cfif attributes.bank_type eq 9>selected</cfif>><cf_get_lang dictionary_id="48747.ING"></option>
						<option value="10" <cfif attributes.bank_type eq 10>selected</cfif>><cf_get_lang dictionary_id="48751.Banksoft"></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" maxlength="3" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(213,'Toplu Provizyon Dönüşleri',48874)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<th><cf_get_lang dictionary_id='57468.Belge'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id ='48913.Provizyon Sayısı'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id ='48914.Provizyon Tutarı'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=bank.list_multi_provision_import&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_PROVISION_IMPORTS.recordcount>
					<cfset employee_id_list=''>
					<cfoutput query="GET_PROVISION_IMPORTS" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(RECORD_EMP) and not listfind(employee_id_list,RECORD_EMP)>
							<cfset employee_id_list=listappend(employee_id_list,RECORD_EMP)>
						</cfif>
					</cfoutput>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfoutput query="GET_PROVISION_IMPORTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><!--- statik gelen parametrelerdir --->
								<cfswitch expression = "#SOURCE_SYSTEM#">
									<cfcase value=1><cf_get_lang dictionary_id="57717.Garanti"></cfcase>
									<cfcase value=2><cf_get_lang dictionary_id="48720.HSBC"></cfcase>
									<cfcase value=3><cf_get_lang dictionary_id="48725.Garanti TPOS"></cfcase>
									<cfcase value=4><cf_get_lang dictionary_id="48729.TEB"></cfcase>
									<cfcase value=5><cf_get_lang dictionary_id="48730.İş Bankası"></cfcase>
									<cfcase value=6><cf_get_lang dictionary_id="48732.Yapi Kredi"></cfcase>
									<cfcase value=7><cf_get_lang dictionary_id="48737.Akbank"></cfcase>
									<cfcase value=8><cf_get_lang dictionary_id="48739.Denizbank"></cfcase>
									<cfcase value=9><cf_get_lang dictionary_id="48747.ING"></cfcase>
									<cfcase value=10><cf_get_lang dictionary_id="48751.Banksoft"></cfcase>
								</cfswitch>
							</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_open_multi_prov_file&export_import_id=#I_ID#&is_import=1','small');"><i class="fa fa-paperclip"></i></td>
							<td>#dateformat(date_add("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#)</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi"> #get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]#&nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</a></td>
							<td style="text-align:right;">#ADET#</td>
							<td style="text-align:right;">#TLFormat(TOPLAM_TUTAR)#</td>
							<!-- sil -->
							<td style="text-align:center;"><cfsavecontent variable="message"><cf_get_lang dictionary_id ='48975.Provizyon Belgesini İşletmek İstediğinizden Emin misiniz'>?</cfsavecontent>
								<cfif IMPORTED eq 0>
									<a href="javascript://" onClick="if (confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=bank.popup_add_provision_import&i_id=#I_ID#');"><i class="fa fa-cube" alt="<cf_get_lang dictionary_id ='48972.İmport Et'>" title="<cf_get_lang dictionary_id ='48972.İmport Et'>"></i></a>
									<cfsavecontent variable="mesaj"><cf_get_lang dictionary_id ='48976.Provizyon Belgesini Silmek İstediğinizden Emin misiniz'>?</cfsavecontent>
									<a href="javascript://" onClick="if (confirm('#mesaj#')) openBoxDraggable('#request.self#?fuseaction=bank.emptypopup_del_provision_file&i_id=#I_ID#');"><i class="fa fa-minus"alt="<cf_get_lang dictionary_id ='48973.Belge Sil'>" title="<cf_get_lang dictionary_id ='48973.Belge Sil'>"></i></a>
								<cfelse>
									<cfsavecontent variable="messag1"><cf_get_lang dictionary_id ='48977.Provizyon Belgesi İmport İşlemini Geri Almak İstediğinizden Emin misiniz'>?</cfsavecontent>
									<a href="javascript://" onClick="if (confirm(' #messag1#')) windowopen('#request.self#?fuseaction=bank.popup_open_multi_prov_file&is_del_prov=1&export_import_id=#I_ID#','small');"><i class="fa fa-trash" alt="<cf_get_lang dictionary_id ='48974.İmport İşlemini Geri Al'>" title="<cf_get_lang dictionary_id ='48974.İmport İşlemini Geri Al'>"></i></a>
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9">
							<cfif arama_yapilmali neq 1><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!
							<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz!'>!</cfif> 
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_string = 'bank.list_multi_provision_import'>
		<cfif isdefined("attributes.form_varmi") and len(attributes.form_varmi)>
			<cfset url_string = '#url_string#&form_varmi=#attributes.form_varmi#'>
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.bank_type") and len(attributes.bank_type)>
			<cfset url_string = '#url_string#&bank_type=#attributes.bank_type#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_string#">
	</cf_box>
</div>
    <script>
    	function kontrol()
		{
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
    </script>
