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
	<cfquery name="GET_PROVISIONS" datasource="#dsn2#">
		SELECT
			FILE_NAME,
			TARGET_SYSTEM,
			RECORD_DATE,
			RECORD_EMP,
			IS_IPTAL,
			E_ID
		FROM
			FILE_EXPORTS
		WHERE
			PROCESS_TYPE = -6 AND
			RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.finish_date)#">
		<cfif len(attributes.bank_type)>
			AND TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type#">
		</cfif>
		ORDER BY
			E_ID DESC
	</cfquery>
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset GET_PROVISIONS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROVISIONS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_multi_provision">
			<input name="form_varmi" id="form_varmi" value="1" type="hidden">
			<cf_box_search more="0">	
				
				<div class="form-group">
                	<select name="bank_type" id="bank_type" >
                        <option value=""><cf_get_lang dictionary_id='57521.Banka'></option>
                        <option value="1" <cfif attributes.bank_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57717.Garanti"></option>
                        <option value="2" <cfif attributes.bank_type eq 2>selected</cfif>><cf_get_lang dictionary_id="48720.HSBC"></option>
                        <option value="3" <cfif attributes.bank_type eq 3>selected</cfif>><cf_get_lang dictionary_id="48725.Garanti TPOS"></option>
                        <option value="4" <cfif attributes.bank_type eq 4>selected</cfif>><cf_get_lang dictionary_id="48729.TEB"></option>
                        <option value="5" <cfif attributes.bank_type eq 5>selected</cfif>><cf_get_lang dictionary_id="48730.İş Bankası"></option>
                        <option value="6" <cfif attributes.bank_type eq 6>selected</cfif>><cf_get_lang dictionary_id="48784.YKB"></option>
                        <option value="7" <cfif attributes.bank_type eq 7>selected</cfif>><cf_get_lang dictionary_id="48737.Akbank"></option>
                        <option value="8" <cfif attributes.bank_type eq 8>selected</cfif>><cf_get_lang dictionary_id="48739.Denizbank"></option>
                        <option value="9" <cfif attributes.bank_type eq 9>selected</cfif>><cf_get_lang dictionary_id="48747.ING"></option>
                        <option value="10" <cfif attributes.bank_type eq 10>selected</cfif>><cf_get_lang dictionary_id="48751.Banksoft"></option>
                    </select>
            	</div>

				<div class="form-group">
                	<div class="input-group ">
                    	<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#"  validate="#validate_style#" maxlength="10" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group ">
                    	<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" maxlength="10" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
	                <div class="input-group small">
	                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows"  onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
	                </div>
            	</div>
				<div class="form-group">
            		<cf_wrk_search_button button_type="4" search_function="kontrol()">
            	</div>

			</cf_box_search>
		</cfform>
	</cf_box>

<cf_box title="#getLang(685,'Toplu Provizyon',48873)#" uidrop="1" hide_table_column="1">
<cf_grid_list>

	<thead>
		<tr>
        	<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57521.Banka'></th>
			<th><cf_get_lang dictionary_id='57468.Belge'></th>
			<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th width="30" class="header_icn_none" nowrap="nowrap"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_multi_provision&event=add</cfoutput>','wide');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_PROVISIONS.recordcount>
			<cfset employee_id_list=''>
			<cfoutput query="GET_PROVISIONS" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
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
			<cfoutput query="GET_PROVISIONS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
                	<td>#currentrow#</td>
					<td><!--- statik gelen parametrelerdir --->
						<cfswitch expression = "#TARGET_SYSTEM#">
							<cfcase value=1><cf_get_lang dictionary_id="57717.Garanti"></cfcase>
							<cfcase value=2>#getLang('bank',59,'HSBC')#</cfcase>
							<cfcase value=3>#getLang('bank',64,'Garanti')#</cfcase>
							<cfcase value=4>#getLang('bank',68,'TEB')#</cfcase>
							<cfcase value=5>#getLang('bank',69,'İş Bankası')#</cfcase>
							<cfcase value=6>#getLang('bank',71,'Yapi Kredi')#</cfcase>
							<cfcase value=7>#getLang('bank',76,'Akbank')#</cfcase>
							<cfcase value=8>#getLang('bank',78,'Denizbank')#</cfcase>
							<cfcase value=9>#getLang('bank',86,'ING')#</cfcase>
							<cfcase value=10>#getLang('bank',90,'Banksoft')#</cfcase>
						</cfswitch>
					</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_multi_provision&event=file&export_import_id=#E_ID#','small');"><img src="/images/attach.gif" alt=""></a></td>
					<td>#dateformat(date_add("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#)</td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi"> #get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]#&nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</a></td>
					<td><cfsavecontent variable="message">#getLang('bank',284,'Provizyon Belgesini İptal Etmek İstediğinizden Emin misiniz Dosyanızın Bankaya Gönderilmediğinden ve Sonuçlarının İmport Edilmediğinden Emin Olmalısınız')#</cfsavecontent>
						<cfif IS_IPTAL neq 1>
							<a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_multi_provision&event=file&export_import_id=#E_ID#&is_iptal=1','small');"><img src="/images/delete.gif" alt="<cf_get_lang dictionary_id ='48944.Belgeyi İptal Et'>" title="<cf_get_lang dictionary_id ='48944.Belgeyi İptal Et'>"></a>
						<cfelse>
							<cf_get_lang dictionary_id ='59190.İptal Edildi'>
						</cfif>
					</td>
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
</cf_box>
</div>
<cfset url_string = '#listfirst(attributes.fuseaction,'.')#.list_multi_provision'>
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
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_string#">
    <script>
    	function kontrol()
			{
				if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
					return false;
				else
					return true;	
			}
    </script> 
