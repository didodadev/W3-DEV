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
	<cfquery name="GET_AUTOPAYMENTS" datasource="#DSN2#">
		<!--- tahsilat kaydi yapabilmis olanlar --->
		SELECT
			SUM(ROUND(BANK_ACTIONS.ACTION_VALUE,2)) TOPLAM_TUTAR,
			COUNT(BANK_ACTIONS.ACTION_ID) ADET,		
			FILE_IMPORTS.I_ID,
			FILE_IMPORTS.RECORD_EMP,
			FILE_IMPORTS.RECORD_DATE,
			FILE_IMPORTS.SOURCE_SYSTEM,
			FILE_IMPORTS.IMPORTED,
			FILE_IMPORTS.FILE_NAME,
			FILE_IMPORTS.IS_DBS
		FROM
			FILE_IMPORTS,
			BANK_ACTIONS
		WHERE
			FILE_IMPORTS.PROCESS_TYPE = -12 AND<!--- Otomatik odeme Import --->
			BANK_ACTIONS.FILE_IMPORT_ID = FILE_IMPORTS.I_ID AND
			FILE_IMPORTS.IMPORTED = 1 AND
			FILE_IMPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
			<cfif attributes.source eq 2>
            	AND FILE_IMPORTS.IS_DBS = 1
            </cfif>
            <cfif len(attributes.bank) and attributes.source eq 2>
                AND FILE_IMPORTS.IS_DBS = 1 AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
            </cfif>
            <cfif attributes.source eq 1>
	            AND (FILE_IMPORTS.IS_DBS = 0 OR FILE_IMPORTS.IS_DBS IS NULL)
            </cfif>
            <cfif len(attributes.bank_name) and attributes.source eq 1>
                AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
            </cfif>
		GROUP BY
			FILE_IMPORTS.I_ID,
			FILE_IMPORTS.RECORD_EMP,
			FILE_IMPORTS.RECORD_DATE,
			FILE_IMPORTS.SOURCE_SYSTEM,
			FILE_IMPORTS.IMPORTED,
			FILE_IMPORTS.FILE_NAME,
			FILE_IMPORTS.IS_DBS
		
		UNION
		<!--- import edilmemis olanlar veya import edilip tahsilat kaydı yapamamis olanlar --->
		SELECT
			'' TOPLAM_TUTAR,
			'' ADET,		
			I_ID,
			RECORD_EMP,
			RECORD_DATE,
			SOURCE_SYSTEM,
			IMPORTED,
			FILE_NAME,
			IS_DBS
		FROM
			FILE_IMPORTS
		WHERE
			PROCESS_TYPE = -12 AND<!--- Otomatik ödeme Import --->
			RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)# AND
			(
					FILE_IMPORTS.IMPORTED = 0
				OR
				(
					FILE_IMPORTS.IMPORTED = 1 AND
					FILE_IMPORTS.I_ID NOT IN (SELECT FILE_IMPORT_ID FROM BANK_ACTIONS WHERE FILE_IMPORT_ID IS NOT NULL)
				)
			)
			<cfif attributes.source eq 2>
            	AND FILE_IMPORTS.IS_DBS = 1
            </cfif>
            <cfif len(attributes.bank) and attributes.source eq 2>
                AND FILE_IMPORTS.IS_DBS = 1 AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank#">
            </cfif>
            <cfif attributes.source eq 1>
	            AND (FILE_IMPORTS.IS_DBS = 0 OR FILE_IMPORTS.IS_DBS IS NULL)
            </cfif>
            <cfif len(attributes.bank_name) and attributes.source eq 1>
                AND FILE_IMPORTS.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
            </cfif>
		ORDER BY
			FILE_IMPORTS.I_ID DESC
	</cfquery>
<cfelse>
	<cfset get_autopayments.recordcount = 0>
</cfif>

<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_autopayments.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.list_bank_autopayment_import">
			<input name="is_submitted" id="is_submitted" value="1" type="hidden">
			<cf_box_search> 
				<div class="form-group">
					<select name="source" id="source" style="width:153px;" onChange="display_();">
						<option value="1" <cfif attributes.source eq 1>selected</cfif>><cf_get_lang dictionary_id="48800.Sistem Ödeme Planı"></option>
						<option value="2" <cfif attributes.source eq 2>selected</cfif>><cf_get_lang dictionary_id="48801.Fatura Ödeme Planı"></option>
					</select>
				</div>
				<div class="form-group" id="pos_2" <cfif attributes.source eq 2>style="display:none;"</cfif>>
					<select name="bank_name" id="bank_name">
						<option value=""><cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<option value="37" <cfif attributes.bank_name eq 37>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
						<option value="41" <cfif attributes.bank_name eq 41>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
						<option value="31" <cfif attributes.bank_name eq 31>selected</cfif>><cf_get_lang dictionary_id="48765.Finansbank"></option>
						<option value="42" <cfif attributes.bank_name eq 42 >selected</cfif>><cf_get_lang dictionary_id="48776.Fortis"></option>
						<option value="33" <cfif attributes.bank_name eq 33>selected</cfif>><cf_get_lang dictionary_id="48725.Garanti"></option>
						<option value="30" <cfif attributes.bank_name eq 30>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
						<option value="32" <cfif attributes.bank_name eq 32>selected</cfif>><cf_get_lang dictionary_id="48730.İşBankası"></option>
						<option value="34" <cfif attributes.bank_name eq 34>selected</cfif>><cf_get_lang dictionary_id="48766.OyakBank"></option>
						<option value="38" <cfif attributes.bank_name eq 38>selected</cfif>><cf_get_lang dictionary_id="48771.PTT"></option>
						<option value="40" <cfif attributes.bank_name eq 40>selected</cfif>><cf_get_lang dictionary_id="48802.PTT Kapıda Ödeme"></option>
						<option value="43" <cfif attributes.bank_name eq 43>selected</cfif>><cf_get_lang dictionary_id="48803.Yurtiçi Kapıda Ödeme"></option>
						<option value="35" <cfif attributes.bank_name eq 35>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
						<option value="43" <cfif attributes.bank_name eq 43>selected</cfif>><cf_get_lang dictionary_id="48760.Vakıf Bank"></option>
						<option value="36" <cfif attributes.bank_name eq 36>selected</cfif>><cf_get_lang dictionary_id="48784.YKB"></option>
						<option value="39" <cfif attributes.bank_name eq 39>selected</cfif>><cf_get_lang dictionary_id="48774.Ziraat"></option>
						<option value="44" <cfif attributes.bank_name eq 44>selected</cfif>><cf_get_lang dictionary_id="42726.Halkbank"></option>
						<option value="45" <cfif attributes.bank_name eq 45>selected</cfif>><cf_get_lang dictionary_id="51519.Odeabank"></option>
						<option value="46" <cfif attributes.bank_name eq 46>selected</cfif>><cf_get_lang dictionary_id="51551.Şekerbank"></option>
					</select>
				</div>
				<div class="form-group" id="bank_2" <cfif attributes.source eq 1>style="display:none;"</cfif>>
					<select name="bank" id="bank">
						<option value=""><cf_get_lang dictionary_id="57521.Banka"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_bank_names">
							<option value="#bank_id#" <cfif attributes.bank eq bank_id>selected</cfif>>#bank_name#</option>
						</cfoutput>
					</select>                         
				</div>                
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>                                 
				<div class="form-group small">
					<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" maxlength="3" range="1,250" required="yes">						 
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>  
			</cf_box_search>
		</cfform>
	</cf_box>	
	<cf_box title="#getLang(215,'Otomatik Ödeme İşlemi Dönüşleri',48876)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57521.Banka'></th>
					<!-- sil --><th><cf_get_lang dictionary_id='57468.Belge'></th><!-- sil -->
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id ='48915.İşlem Sayısı'></th>
					<th><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=bank.list_bank_autopayment_import&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_autopayments.recordcount>
					<cfset employee_id_list=''>
					<cfset bank_id_list=''>
					<cfoutput query="get_autopayments" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
							<cfset employee_id_list=listappend(employee_id_list,record_emp)>
						</cfif>
						<cfif len(source_system) and not listfind(bank_id_list,source_system)>
							<cfset bank_id_list=listappend(bank_id_list,source_system)>
						</cfif>
					</cfoutput>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif len(bank_id_list)>
						<cfset bank_id_list=listsort(bank_id_list,"numeric","ASC",",")>
						<cfquery name="get_bank_name" datasource="#dsn#">
							SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES WHERE BANK_ID IN (#bank_id_list#) ORDER BY BANK_ID
						</cfquery>
					</cfif>
				<cfoutput query="get_autopayments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif is_dbs eq 1>
								#get_bank_name.bank_name[listfind(bank_id_list,source_system,',')]#
							<cfelse>
								<cfswitch expression = "#source_system#">
									<cfcase value="30"><cf_get_lang dictionary_id="48720.HSBC"></cfcase>
									<cfcase value="31"><cf_get_lang dictionary_id="48765.Finansbank"></cfcase>
									<cfcase value="32"><cf_get_lang dictionary_id="48730.İş Bankası"></cfcase>
									<cfcase value="33"><cf_get_lang dictionary_id="48725.Garanti"></cfcase>
									<cfcase value="34"><cf_get_lang dictionary_id="48766.OyakBank"></cfcase>
									<cfcase value="35"><cf_get_lang dictionary_id="48729.TEB"></cfcase>
									<cfcase value="36,50"><cf_get_lang dictionary_id="48732.Yapi Kredi"></cfcase>
									<cfcase value="37,51"><cf_get_lang dictionary_id="48737.Akbank"></cfcase>
									<cfcase value="38"><cf_get_lang dictionary_id="48771.PTT"></cfcase>
									<cfcase value="39"><cf_get_lang dictionary_id="48774.Ziraat"></cfcase>
									<cfcase value="41"><cf_get_lang dictionary_id="48739.Denizbank"></cfcase>
									<cfcase value="42"><cf_get_lang dictionary_id="48776.Fortis"></cfcase>
									<cfcase value="43"><cf_get_lang dictionary_id="48760.Vakıf Bank"></cfcase>
									<cfcase value="44"><cf_get_lang dictionary_id="42726.Halkbank"></cfcase>
									<cfcase value="45"><cf_get_lang dictionary_id="51519.Odeabank"></cfcase>
									<cfcase value="46"><cf_get_lang dictionary_id="51551.Şekerbank"></cfcase>
								</cfswitch>
							</cfif>
						</td>
						
						<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_open_multi_prov_file&export_import_id=#I_ID#&is_import=1','list');"><i class="fa fa-paperclip"></i></a></td><!-- sil -->
						<td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(record_date,timeformat_style)#)</td>
						<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#');" class="tableyazi"> #get_emp_detail.employee_name[listfind(employee_id_list,record_emp,',')]#&nbsp; #get_emp_detail.employee_surname[listfind(employee_id_list,record_emp,',')]#</a></td>
						<td style="text-align:right;">#adet#</td>
						<td style="text-align:right;">#TLFormat(toplam_tutar)#</td>
						<!-- sil -->
						<td width="50" align="center">
							<cfif imported eq 0>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='49041.Otomatik Ödeme Belgesini İmport Etmek İstediğinizden Emin misiniz'>?</cfsavecontent>
								<a href="javascript://" onClick="if (confirm('#message#')) openBoxDraggable('#request.self#?fuseaction=bank.list_bank_autopayment_import&event=import&i_id=#i_id#');"><i class="fa fa-cube" alt="<cf_get_lang dictionary_id ='48972.İmport Et'>" title="<cf_get_lang dictionary_id ='48972.İmport Et'>"></i></a>
								<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='49042.Otomatik Ödeme Belgesini Silmek İstediğinizden Emin misiniz'>?</cfsavecontent>
								<a href="javascript://" onClick="if (confirm('#message2#')) openBoxDraggable('#request.self#?fuseaction=bank.emptypopup_del_provision_file&i_id=#i_id#');"><i class="fa fa-minus"alt="<cf_get_lang dictionary_id ='48973.Belge Sil'>" title="<cf_get_lang dictionary_id ='48973.Belge Sil'>"></i></a>
							<cfelse>
								<cfsavecontent variable="message3"><cf_get_lang dictionary_id ='49043.Otomatik Ödeme İmport İşlemini Geri Almak İstediğinizden Emin misiniz'>?</cfsavecontent>
								<a href="javascript://" onClick="if (confirm('#message3#')) openBoxDraggable('#request.self#?fuseaction=bank.list_bank_autopayment_import&event=revImport&is_autopayment=1&export_import_id=#i_id#');"><i class="fa fa-trash" alt="<cf_get_lang dictionary_id ='48974.İmport İşlemini Geri Al'>" title="<cf_get_lang dictionary_id ='48974.İmport İşlemini Geri Al'>"></i></a>
							</cfif>
						</td>
						<!-- sil -->
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9">
							<cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz!'>!</cfif> 
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_string = ''>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_string = '#url_string#&is_submitted=#attributes.is_submitted#'>
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
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="bank.list_bank_autopayment_import#url_string#">
	</cf_box>
</div>
<script>
	function kontrol()
	{
		if(!$("#maxrows").val().length && $("#maxrows").val()==0)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"}) 
			return false;
		}
		if($("#maxrows").val()==0)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"}) 
			return false;
		}
		if(!$("#start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfoutput>"}) 
			return false;
		}
		if(!$("#finish_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfoutput>"}) 
			return false;
		}
		if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
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
