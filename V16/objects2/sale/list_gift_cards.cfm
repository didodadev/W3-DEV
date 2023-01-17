<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1>
	<cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
		SELECT
			OMC.GIFT_CARD_NO,
			OMC.ORDER_CREDIT_ID,
			OMC.ORDER_ID, 
			OMC.CREDIT_RATE,
			OMC.MONEY_CREDIT,
			OMC.VALID_DATE,
			OMC.USE_CREDIT,
			OMC.COMPANY_ID,
			OMC.CONSUMER_ID, 
			O.ORDER_NUMBER,
			OMC.MONEY_CREDIT_STATUS
		FROM
			ORDER_MONEY_CREDITS OMC,
			ORDERS O
		WHERE
			OMC.ORDER_ID = O.ORDER_ID
			AND ISNULL(OMC.IS_TYPE,0) = 1
			<cfif isdefined('session.pp.userid')>
				AND OMC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			<cfelseif isdefined('session.ww.userid')>
				AND OMC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
			</cfif>
			<cfif len(attributes.startdate)>
				AND OMC.VALID_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> 
			</cfif>
			<cfif len(attributes.finishdate)>
				AND OMC.VALID_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> 
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_money_credits.recordcount= 0>
</cfif>
<cfscript>
	url_str = "keyword=#attributes.keyword#";
</cfscript>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'> 
<cfparam name="attributes.totalrecords" default="#get_money_credits.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<table cellpadding="0" cellspacing="0" border="0" align="center" width="98%">
	<tr>
		<td class="headbold" height="35"></td>
		<td valign="bottom" align="right"> 
		<table>
			<cfform name="order_form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input name="is_submit" id="is_submit" value="1" type="hidden">
			<tr> 
				<td align="right"><cf_get_lang_main no='48.Filtre'> :
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#">
				</td>
				<td align="right">
					<cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput  validate="eurodate" maxlength="10" message="#message#" type="text" name="startdate" style="width:63px;" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#">
					<cf_wrk_date_image date_field="startdate">
				</td>
				<td align="right">
					<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput validate="eurodate" maxlength="10" message="#message#" type="text" name="finishdate" style="width:63px;" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
					<cf_wrk_date_image date_field="finishdate">
				</td>
				<td align="right">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					<cf_wrk_search_button is_excel='0'>
				</td>
			</tr>
			</cfform>
		</table>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr style="height:22px;" class="color-header">
		<td class="form-title" width="20">No</td>
		<td class="form-title">Sipariş</td>
		<td class="form-title" align="right">Hediye Çeki</td>
		<td class="form-title" align="right">Kullanılan Tutar</td>
		<td class="form-title" width="150">Geçerlilik Tarihi</td>
		<td class="form-title" width="100">Numara</td>
	</tr>
	<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1>
		<cfif get_money_credits.recordcount>
			<cfscript>
				company_id_list='';
				consumer_id_list='';
			</cfscript>
			<cfoutput query="get_money_credits" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
				<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
					<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
				</cfif>
				<cfif len(company_id_list)>
					<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
					<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
						SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
					</cfquery>
				</cfif>
				<cfif len(consumer_id_list)>
					<cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
						SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
					</cfquery>
				</cfif>
				<tr class="color-row" height="20">
					<td>#currentrow#</td>
					<td><a href="#request.self#?fuseaction=objects2.order_detail&order_id=#order_id#" class="tableyazi">#order_number#</a></td>
					<td align="right">#TlFormat(money_credit)#</td>
					<td align="right">#TlFormat(use_credit)#</td>
					<td align="right">#DateFormat(valid_date,'dd/mm/yyyy')#</td>
					<td align="right">
						<cfif money_credit_status eq 0>Onay Bekleniyor<cfelse>
							#gift_card_no#
						</cfif>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row" height="20">
				<td colspan="6">Kayıt Yok!</td>
			</tr>
		</cfif>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="6">Filtre Ediniz!</td>
		</tr>
	</cfif>
</table>
<cfif get_money_credits.recordcount and (attributes.totalrecords gte attributes.maxrows)>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr> 
			<td>
				<cfset url_str = url_str & "&startrow=#attributes.startrow#">
				<cfset url_str = url_str & "&keyword=#attributes.keyword#">
				<cf_pages page="#attributes.page#" page_type="2" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#listgetat(attributes.fuseaction,1,'.')#.list_money_credits&#url_str#&is_submit=1&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
			</td>
			<td align="right">
				<cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#get_money_credits.recordcount#</cfoutput>&nbsp;<cf_pages page="#attributes.page#" page_type="3" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#listgetat(attributes.fuseaction,1,'.')#.list_money_credits&#url_str#&is_submit=1&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
			</td>
		</tr>
	</table>
</cfif>
