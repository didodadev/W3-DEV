<cfparam name="attributes.keyword" default="">
<cfquery name="GET_EMP_REQ" datasource="#dsn#">
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.EMPLOYEE_ID,
		TCA.CLASS_ID,
		E.EMPLOYEE_NAME AD,
		E.EMPLOYEE_SURNAME SOYAD,
		E.EMPLOYEE_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		EMPLOYEES E
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		E.EMPLOYEE_ID=TCA.EMPLOYEE_ID
		<cfif len(attributes.keyword)>AND E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'</cfif>
	UNION ALL
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.PAR_ID,
		TCA.CLASS_ID,
		CP.COMPANY_PARTNER_NAME AS AD,
		CP.COMPANY_PARTNER_SURNAME AS SOYAD,
		CP.COMPANY_PARTNER_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		COMPANY_PARTNER CP
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		CP.PARTNER_ID=TCA.PAR_ID
		<cfif len(attributes.keyword)>AND CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%'</cfif>
	UNION ALL
	SELECT
		TCA.ANNOUNCE_ID,
		TCA.CONS_ID,
		TCA.CLASS_ID,
		C.CONSUMER_NAME AS AD,
		C.CONSUMER_SURNAME AS SOYAD,
		C.CONSUMER_EMAIL AS EMAIL
	FROM
		TRAINING_CLASS_ANNOUNCE_ATTS TCA,
		CONSUMER C
	WHERE
		TCA.ANNOUNCE_ID = #attributes.announce_id# AND
		C.CONSUMER_ID=TCA.CONS_ID
		<cfif len(attributes.keyword)>AND C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME LIKE '%#attributes.keyword#%'</cfif>
	ORDER BY AD,SOYAD
</cfquery>
<cfquery name="GET_CLASS" datasource="#dsn#">
	SELECT
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.START_DATE,
		TC.FINISH_DATE,
		TCG.ANNOUNCE_CLASS_ID 
	FROM
		TRAINING_CLASS_ANNOUNCE_CLASSES TCG,
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID=TCG.CLASS_ID AND
		TCG.ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_emp_req.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str="">
<cfif isdefined("attributes.announce_id")>
	<cfset url_str = "#url_str#&announce_id=#attributes.announce_id#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfset mails = "">
<cfoutput query="GET_EMP_REQ">
	  <cfif len(EMAIL) and (EMAIL contains "@") and (Len(EMAIL) gte 6)>
		<cfset mails = mails & EMAIL & ",">
	  </cfif>
</cfoutput>
<form name="mail_list">
  <input name="mails" id="mails" type="hidden" value="<cfif Len(mails) gt 1><cfoutput>#Left(mails,Len(mails) - 1)#</cfoutput></cfif>">
</form>
<cfform name="add_potential_attenders" method="post" action="#request.self#?fuseaction=training_management.popup_list_announce_emps">
<input type="hidden" name="ANNOUNCE_ID" id="ANNOUNCE_ID" value="<cfoutput>#attributes.ANNOUNCE_ID#</cfoutput>">
<cf_medium_list_search title="#getLang('training_management',465)#">
	<cf_medium_list_search_area>
		<div class="row">
			<br>
			<div class="col col-5 paddingNone">
				<div class="form-group" id="item-keyword">
					<input type="text" name="keyword" placeholder="filtre" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
				</div>
			</div>
			<div class="col col-2">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
			</div>
				<div class="form-group">
					<cf_wrk_search_button>
				</div>
					<cfif listlen(mails)><td width="22" style="text-align:right;"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_mail&special_mail=#Left(mails,Len(mails) - 1)#','list');" class="tableyazi"><img src="/images/mail.gif" border="0" align="absmiddle"></a></cfoutput><br/></td></cfif>
			
		</div>
	</cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang_main no='75.No'></th>
			<th><cf_get_lang_main no='158.Adı Soyadı'></th>
			<th><cf_get_lang_main no='7.Eğitim'></th>
			<th width="15">
				<cfset url_direction = 'training_management.emptypopup_add_announce_potential_attenders&class_id=#get_class.class_id#&announce_id=#attributes.announce_id#&url_params=announce_id,class_id&select_list=1'>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions_multiuser&url_direction=#url_direction#&select_list=1,7,8','list'</cfoutput>);"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a><!---Potansiyel Katılımcı ekleme --->
			</th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_EMP_REQ.RECORDCOUNT>
		  <cfoutput query="GET_EMP_REQ" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
			  <td width="25">#currentrow#</td>
			  <td width="200">
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#employee_id#','project');" class="tableyazi">#AD# #SOYAD#</a></td>
			  <td width="300">
				<cfif len(class_id)>
					<cfquery name="get_req_class" dbtype="query">
						SELECT
							CLASS_NAME,
							START_DATE,
							FINISH_DATE
						FROM
							get_class
						WHERE
							CLASS_ID=#class_id#
					</cfquery>
					#get_req_class.CLASS_NAME# ( #dateformat(get_req_class.START_DATE,dateformat_style)#-#dateformat(get_req_class.FINISH_DATE,dateformat_style)# )
				</cfif>
			  </td>
			  <td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.emptypopup_del_announce_emps&ANNOUNCE_ID=#attributes.ANNOUNCE_ID#&employee_id=#employee_id#','small');"><img src="../images/delete_list.gif"></a></td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr>
			  <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif GET_EMP_REQ.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center">
		<tr>
			<td>
				<cf_pages
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="training_management.popup_list_announce_emps#url_str#">
			</td>
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>
