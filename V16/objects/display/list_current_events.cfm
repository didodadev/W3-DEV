<cf_get_lang_set module_name="agenda">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.event_cat" default="">
<cfparam name="attributes.startdate" default="#DateFormat(Now(),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#DateFormat(Now(),dateformat_style)#">
<cfparam name="attributes.event_place" default="">
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="get_event" datasource="#dsn#">
	SELECT
		E.EVENTCAT_ID,
		E.EVENT_HEAD,
		E.STARTDATE,
		E.FINISHDATE,
		E.EVENT_TO_POS,
		E.EVENT_TO_PAR,
		EC.EVENTCAT
	FROM
		EVENT E,
		EVENT_CAT EC
	WHERE 
		E.EVENTCAT_ID = EC.EVENTCAT_ID
		<cfif Len(attributes.keyword)>
			AND EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif Len(attributes.event_cat)>
			AND E.EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_cat#">
		</cfif>
		<cfif Len(attributes.startdate)>
			AND E.STARTDATE >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		</cfif>
		<cfif Len(attributes.finishdate)>
			AND E.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfif>
		<cfif Len(attributes.event_place)>
			AND E.EVENT_PLACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_place#">
		</cfif>
	ORDER BY
		FINISHDATE
</cfquery>
<cfquery name="get_event_cat" datasource="#dsn#">
	SELECT EVENTCAT_ID,EVENTCAT FROM EVENT_CAT ORDER BY EVENTCAT
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_event.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" method="post" action="#request.self#?fuseaction=objects.popup_list_current_events">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32417.Başvuru No'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" style="width:120px;" value="#attributes.keyword#"></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cfinput type="text" name="startdate" style="width:65px;" required="Yes" message="#message#" validate="#validate_style#" value="#DateFormat(attributes.startdate,dateformat_style)#"> 
					<cf_wrk_date_image date_field="startdate">
					<cfinput type="text" name="finishdate" style="width:65px;" required="Yes" message="#message#" validate="#validate_style#" value="#DateFormat(attributes.finishdate,dateformat_style)#"> 
					<cf_wrk_date_image date_field="finishdate">
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td>
					<cf_wrk_search_button>
				</td>
			</tr>
		</table>
	</cf_medium_list_search_area>
	<cf_medium_list_search_detail_area>
		<table>
			<tr>
				<td><select name="event_cat" id="event_cat" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_event_cat">
							<option value="#eventcat_id#" <cfif len(attributes.event_cat) and (attributes.event_cat eq eventcat_id)> selected</cfif>>#eventcat#</option>
						</cfoutput>
					</select>
				</td>
				<td><select name="event_place" id="event_place" style="width:90px;">
						<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="1" <cfif attributes.event_place eq 1>selected</cfif>><cf_get_lang dictionary_id='47576.Ofis İçi'></option>
						<option value="2" <cfif attributes.event_place eq 2>selected</cfif>><cf_get_lang dictionary_id='47580.Ofis Dışı'></option>
						<option value="3" <cfif attributes.event_place eq 3>selected</cfif>><cf_get_lang dictionary_id='47582.Müşteri Ofisi'></option>
					</select>
				</td>
			</tr>
		</table>
	</cf_medium_list_search_detail_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<tbody>
	<cfif get_event.recordcount>
		<cfoutput query="get_event" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
				<tr>
					<td class="txtboldblue">&nbsp;#get_event.event_head# (#eventcat#)</td>
					<td>
						<cfif isdefined("session.pp.time_zone")>
							<cfset event_startdate = date_add('h', session.pp.time_zone, get_event.startdate)>
							<cfset event_finishdate = date_add('h', session.pp.time_zone, get_event.finishdate)>
							#dateformat(event_startdate,dateformat_style)# (#timeformat(event_startdate,timeformat_style)#) - #dateformat(event_finishdate,dateformat_style)# (#timeformat(event_finishdate,timeformat_style)#)
						</cfif>
						<cfif isdefined("session.ep.time_zone")>
							<cfset event_startdate = date_add('h', session.ep.time_zone, get_event.startdate)>
							<cfset event_finishdate = date_add('h', session.ep.time_zone, get_event.finishdate)>
							#dateformat(event_startdate,dateformat_style)# (#timeformat(event_startdate,timeformat_style)#) - #dateformat(event_finishdate,dateformat_style)# (#timeformat(event_finishdate,timeformat_style)#)
						</cfif>
					</td>
				</tr>
				<cfif Len(event_to_pos)>  
					<tr>
						<td colspan="2"><strong><cf_get_lang dictionary_id='58875.Çalışanlar'></strong> : 
							<cfquery name="DETAIL_EVENT_TO_POS" datasource="#DSN#">
								SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#ListSort(event_to_pos,'numeric')#)
							</cfquery>
							<cfloop query="DETAIL_EVENT_TO_POS">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#DETAIL_EVENT_TO_POS.employee_id#','medium');" class="tableyazi">#detail_event_to_pos.employee_name# #detail_event_to_pos.employee_surname#</a>,&nbsp;
							</cfloop>
						</td>
					</tr>		
				</cfif>		
				<cfif Len(event_to_par)>
					<tr>
						<td><strong><cf_get_lang dictionary_id='57417.Üyeler'></strong> :
							<cfquery name="DETAIL_EVENT_TO_PAR" datasource="#DSN#">
								SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#ListSort(event_to_par,'numeric')#)
							</cfquery>
							<cfloop query="DETAIL_EVENT_TO_PAR">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#DETAIL_EVENT_TO_PAR.partner_id#','medium');" class="tableyazi">#detail_event_to_par.company_partner_name# #detail_event_to_par.company_partner_surname#</a>,&nbsp;
							</cfloop>
						</td>
					</tr>
				</cfif>	
		</cfoutput>
	<cfelse>
		<tr>
			<td><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
		</tr>
	</cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "objects.popup_list_current_events">
	<cfif Len(attributes.keyword)><cfset adres = "#adres#&keyword=#attributes.keyword#"></cfif>
	<cfif Len(attributes.event_cat)><cfset adres = "#adres#&event_cat=#attributes.event_cat#"></cfif>
	<cfif Len(attributes.startdate)><cfset adres = "#adres#&startdate=#attributes.startdate#"></cfif>
	<cfif Len(attributes.finishdate)><cfset adres = "#adres#&finishdate=#attributes.finishdate#"></cfif>
	<cfif Len(attributes.event_place)><cfset adres = "#adres#&event_place=#attributes.event_place#"></cfif>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
		<tr> 
			<td><cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#"> 
			</td>
			<!-- sil -->
			<td style="text-align:right;">
				<cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
			</td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
