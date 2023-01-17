<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfif isdefined('attributes.company_id')>
	<cfset attributes.company_id = Decrypt(attributes.company_id,'A0A054FHCMFKT6590',"CFMX_COMPAT","Hex")>
</cfif>
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
</cfif>
<cfquery name="GET_RESULT_ROWS" datasource="#DSN#">
    SELECT EVENT_ID,EVENT_RESULT_ID FROM EVENT_RESULT
</cfquery>
<cfquery name="GET_EVENTS" datasource="#DSN#">
	SELECT
		E.EVENT_ID,
		E.STARTDATE,
		E.FINISHDATE,
		E.EVENT_HEAD,
		EC.EVENTCAT,
		E.RECORD_PAR,
		E.UPDATE_PAR,
		E.VALIDATOR_PAR,
		E.EVENT_TO_PAR,
		E.EVENT_CC_PAR
	FROM
		EVENT E,
		EVENT_CAT EC
	WHERE
		<cfif isDefined('attributes.keyword') and Len(attributes.keyword)>
			E.EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
		</cfif>
		<cfif isDefined('attributes.startdate') and Len(attributes.startdate) and isDefined ('attributes.finishdate') and Len(attributes.finishdate)>
			E.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
			E.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
		<cfelseif isDefined ('attributes.startdate') and Len(attributes.startdate)>
			E.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		<cfelseif isDefined('attributes.finishdate') and Len(attributes.finishdate)>
			E.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finishdate)#"> AND
		</cfif>
		(
			<cfif isdefined('attributes.company_id')>
				EXISTS(SELECT 'x' FROM COMPANY_PARTNER CP WHERE CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				CHARINDEX(','+LTRIM(STR(CP.PARTNER_ID))+',', ISNULL(E.EVENT_TO_PAR, '')) > 0) OR
				EXISTS(SELECT 'x' FROM COMPANY_PARTNER CP WHERE CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				CHARINDEX(','+LTRIM(STR(CP.PARTNER_ID))+',', ISNULL(E.EVENT_CC_PAR, '')) > 0)
			<cfelseif isDefined('session.pp.userid')>
				E.EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.userid#%"> OR
				E.EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.userid#%">
            <cfelse>
            	1=1
			</cfif>
		) AND
		E.EVENTCAT_ID = EC.EVENTCAT_ID
	ORDER BY
		E.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_events.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <table cellspacing="1" cellpadding="2" border="0" align="center" style="width:98%">
        <tr style="height:35px;">		
			<cfif isdefined('attributes.company_id')>
                <cfinput type="hidden" name="company_id" id="company_id" value="#encrypt(attributes.company_id,'A0A054FHCMFKT6590','CFMX_COMPAT','Hex')#">
            </cfif>
            <td class="headbold"><cf_get_lang no='735.Olaylar'></td>
            <td  style="text-align:right;">
                <cf_get_lang_main no='48.Filtre'> :&nbsp;
                <cfinput type="text" name="keyword" id="keyword" maxlength="100" value="#attributes.keyword#" style="width:130px;">
                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihini Yazınız'></cfsavecontent>
                <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
                    <cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" maxlength="10" message="#message#" validate="eurodate" style="width:70px;">
                <cfelse>
                    <cfinput type="text" name="startdate" id="startdate" value="" validate="eurodate" maxlength="10" message="#message#" style="width:70px;">
                </cfif>
                <cf_wrk_date_image date_field="startdate">
                <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş tarihini Giriniz'></cfsavecontent>
                <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
                    <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" maxlength="10" message="#message#" validate="eurodate" style="width:70px;">
                <cfelse>
                    <cfinput type="text" name="finishdate" id="finishdate" value="" maxlength="10" message="#message#" style="width:70px;" validate="eurodate">
                </cfif>
                <cf_wrk_date_image date_field="finishdate">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                <cf_wrk_search_button>	
            </td>
		</tr>
	</table>
</cfform>
<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:98%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang_main no='68.Konu'></td>
		<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title"><cf_get_lang_main no='243.Başlama Tarihi'></td>
		<td class="form-title"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
		<td class="form-title"><cf_get_lang_main no='272.Sonuç'></td>
	</tr>
	<cfif get_events.recordcount>
		<cfset get_result_row_list = ''>
		<cfoutput query="get_events" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(event_id) and not listfind(get_result_row_list,event_id)>
				<cfset get_result_row_list = listappend(get_result_row_list,event_id,',')>
			</cfif>
			<cfif ListLen(get_result_row_list)>
				<cfquery name="GET_RESULT_ROW" dbtype="query">
					SELECT EVENT_ID,EVENT_RESULT_ID FROM GET_RESULT_ROWS WHERE EVENT_ID IN (#get_result_row_list#) ORDER BY EVENT_ID
				</cfquery>
				<cfset get_result_row_list = listsort(ValueList(get_result_row.event_id,','),'numeric','ASC',',')>
			</cfif>
			<tr class="color-row" style="height:20px;">
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=objects2.form_upd_event&event_id=#encrypt(event_id,session.pp.userid,"CFMX_COMPAT","Hex")#<cfif isdefined('attributes.company_id')>&company_id=#attributes.company_id#</cfif>" class="tableyazi">#event_head#</a></td>
				<td>#eventcat#</td>
				<td>#dateformat(date_add('h',session.pp.time_zone,startdate),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,startdate),'HH:MM')#</td>
				<td>#dateformat(date_add('h',session.pp.time_zone,finishdate),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,finishdate),'HH:MM')#</td>
				<td>
					<cfif listfind(get_result_row_list,event_id,',')>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_event_result&event_id=#event_id#','page');" class="tableyazi"><cf_get_lang no='187.Tutanak Göster'></a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
        <tr class="color-row" style="height:20px;">
            <td colspan="6"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
        </tr>
	</cfif>
</table>
<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str= "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#" >
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#" >
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:35px;">
		<tr> 
			<td>
                <cf_pages page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#attributes.fuseaction##url_str#"> 
			</td>
	   		<!-- sil --><td style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
