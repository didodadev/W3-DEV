<cfif isdefined("attributes.workcube_id") and len(attributes.workcube_id)>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT
			SUBSCRIPTION_ID,			
			SUBSCRIPTION_NO
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_id#">
	</cfquery>
<cfelse>
	<cfset get_subscription.recordcount = 0>
</cfif>
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.workcube_id" default="">
<cfparam name="attributes.app_cat" default="">
<cfparam name="attributes.app_name" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.is_reply" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,now())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>

<cfif isdefined("session.pp.our_company_id")>
	<cfset my_our_comp_ = session.pp.our_company_id>
<cfelseif isdefined("session.ww.our_company_id")>
	<cfset my_our_comp_ = session.ww.our_company_id>
<cfelse>
	<cfset my_our_comp_ = session.ep.company_id>
</cfif>
<cfquery name="GET_CALLCENTER_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_comp_#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.helpdesk%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMMETHOD" datasource="#DSN#">
	SELECT COMMETHOD_ID, COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfif isdefined('session.pp') or isdefined('session.ww.userid') or get_subscription.recordcount>
	<cfquery name="GET_HELP" datasource="#DSN#">
		SELECT
			RECORD_EMP,
			CUS_HELP_ID,
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			PROCESS_STAGE,
			SUBJECT,
			SUBSCRIPTION_ID,
			APPLICANT_NAME,
			APP_CAT,
			RECORD_DATE,
			IS_REPLY,
			IS_REPLY_MAIL,
			UPDATE_EMP,
			RECORD_EMP,
			OUR_COMPANY_ID,
			SITE_DOMAIN
		FROM
			CUSTOMER_HELP
		WHERE
			1 = 1
			<cfif isdefined('session.pp')>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			<cfelseif isdefined('session.ww.userid')>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
			<cfif get_subscription.recordcount>
				AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_id#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND 
					(
					SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					<cfif isnumeric(attributes.keyword)>
						OR CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
					</cfif>
					)
			</cfif>
			<cfif len(attributes.app_cat)>
				AND APP_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_cat#">
			</cfif>
			<cfif len(attributes.record_emp) and len(attributes.record_name)>
				AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#">
			</cfif>
			<cfif attributes.is_reply eq 0>
				AND	IS_REPLY_MAIL  = 0		  
			<cfelseif attributes.is_reply eq 1>
				AND	IS_REPLY_MAIL  = 1		  
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				AND RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date)#">
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_help.recordcount = 0>
</cfif>
<cfif isDefined('session.ep.maxrows')>
	<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfelseif isDefined('session.pp.userid')>
	<cfparam name="attributes.maxrows" default="#session.pp.maxrows#">
<cfelseif isDefined('session.ww.maxrows')>
	<cfparam name="attributes.maxrows" default="#session.ww.maxrows#">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default = "#get_help.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cf_medium_list_search id="body_helpdesk">
	<cf_medium_list_search_area>
			<cfform name="list_help" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
                <table align="right">
                    <tr>
                        <input type="hidden" name="app_name" id="app_name" value="<cfoutput>#attributes.app_name#</cfoutput>">
                        <input type="hidden" name="email" id="email" value="<cfoutput>#attributes.email#</cfoutput>">
                        <input type="hidden" name="workcube_id" id="workcube_id" value="<cfoutput>#attributes.workcube_id#</cfoutput>">
                        <td><cf_get_lang_main no='48.Filtre'>:</td>
                        <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:75px;"></td>
                        <td>
                            <select name="process_stage_type" id="process_stage_type" style="width:100px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_callcenter_stage">
                                    <option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>
                            <select name="is_reply" id="is_reply">
                                <option value="2" <cfif attributes.is_reply eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                <option value="0" <cfif attributes.is_reply eq 0>selected</cfif>>Cevapsız</option>
                                <option value="1" <cfif attributes.is_reply eq 1>selected</cfif>>Cevaplı</option>
                            </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:64px;" validate="eurodate" message="#message#">
                            <cf_wrk_date_image date_field="start_date">
                            <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" style="width:64px;" validate="eurodate" message="#message#">
                            <cf_wrk_date_image date_field="finish_date">
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><input type="submit" onclick="kontrol()" value="<cfoutput>#getLang('main',499)#</cfoutput>"></td>
                    </tr>
                </table>
       		</cfform>
    </cf_medium_list_search_area>
</cf_medium_list_search>	
<cf_medium_list>   
	<thead> 
        <tr>
            <th></td>
            <th style="width:40px;"><cf_get_lang_main no='75.No'></td>
            <th style="width:160px;"><cf_get_lang_main no='1140.Konu'></td>
            <th style="width:100px;"><cf_get_lang_main no='1717.Başvuru Yapan'></td>
            <th style="width:80px;"><cf_get_lang_main no='344.Süreç'></td>
            <th style="width:65px;"><cf_get_lang_main no='330.Tarih'></td>
            <th style="width:100px;"><cf_get_lang no='47.Başvuru Durumu'></td>
            <cfif isDefined('attributes.is_helpdesk_button') and attributes.is_helpdesk_button eq 1><th style="width:15px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.add_service_help"><img src="/images/plus_list.gif" border="0"></a></td></cfif>
        </tr>
    <thead>
    <tbody>
		<cfif get_help.recordcount>
            <cfset stage_list =''>
            <cfset partner_id_list =''>
            <cfset consumer_id_list =''>
            <cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(process_stage) and not listfind(stage_list,process_stage)>
                    <cfset stage_list=listappend(stage_list,process_stage)>
                </cfif>
                <cfif len(partner_id) and not listFindnocase(partner_id_list,partner_id)>
                    <cfset partner_id_list = listappend(partner_id_list,partner_id)>
                </cfif>
                <cfif len(consumer_id) and not listFindnocase(consumer_id_list,consumer_id)>
                    <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                </cfif>
            </cfoutput>
            <cfif len(stage_list)>
                <cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
                <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                    SELECT
                        STAGE,
                        PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS
                    WHERE
                        PROCESS_ROW_ID IN (#stage_list#)
                    ORDER BY
                        PROCESS_ROW_ID
                </cfquery>
                <cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type.process_row_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif listlen(partner_id_list)>
                <cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
                <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                    SELECT
                        CP.COMPANY_PARTNER_NAME,
                        CP.COMPANY_PARTNER_SURNAME,
                        CP.PARTNER_ID
                    FROM 
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.PARTNER_ID IN (#partner_id_list#) AND
                        CP.COMPANY_ID = C.COMPANY_ID
                    ORDER BY
                        CP.PARTNER_ID
                </cfquery>
                <cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif listlen(consumer_id_list)>
                <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                    SELECT
                        CONSUMER_ID,
                        CONSUMER_NAME,
                        CONSUMER_SURNAME
                    FROM
                        CONSUMER
                    WHERE
                        CONSUMER_ID IN (#consumer_id_list#)
                    ORDER BY
                        CONSUMER_ID
                </cfquery>
                <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td style="width:20px;">#currentrow#</td>
                    <td style="width:40px;"><a href="javascript://" onclick="gizle_goster(help_detail#currentrow#);connectAjax(#currentrow#,#cus_help_id#);" class="tableyazi">#cus_help_id#</a></td>
                    <td><a href="javascript://" onclick="gizle_goster(help_detail#currentrow#);connectAjax(#currentrow#,#cus_help_id#);" class="tableyazi">#left(subject,50)#</a></td>
                    <td>#applicant_name#</td>
                    <td>#process_type.stage[listfind(stage_list,process_stage,',')]#</td>
                    <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                    <td colspan="2">
                        <cfif is_reply_mail neq 1>
                            <font color="FFF0000">Cevaplandırılmadı</font>
                            <cfparam  name="cevap_verilmedi" default="">
                        </cfif>
                        <cfif (is_reply_mail eq 1)>
                            Cevaplandırıldı
                        <cfelseif not isdefined('cevap_verilmedi')>
                            Cevap Verilmedi
                        </cfif>
                    </td>
                </tr>
                <tr id="help_detail#currentrow#" class="nohover" style="display:none;">
                    <td colspan="8">
                        <div id="show_help_detail#currentrow#" style="width:100%;"></div>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8" style="text-align:left;"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "">
	<cfif len(attributes.keyword)>
		<cfset adres ="#adres#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.is_reply)>
		<cfset adres ="#adres#&is_reply=#attributes.is_reply#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset adres ="#adres#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset adres ="#adres#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined('attributes.workcube_id') and len(attributes.workcube_id)>
		<cfset adres ="#adres#&workcube_id=#attributes.workcube_id#">
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0" align="center" class="color-row" style="width:100%; height:35px;">
		<tr>
			<td>
				<cf_pages page="#attributes.page#" page_type="2" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" button_type="1" startrow="#attributes.startrow#" adres="#attributes.fuseaction##adres#&form_submitted=1">
			</td>
			<td  style="text-align:right;">
				<cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#</cfoutput>&nbsp;<cf_pages page="#attributes.page#" page_type="3" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##adres#&form_submitted=1">
			</td>
		</tr>
	</table>
</cfif>

<!---
                <cf_paging
                    name="helpdesk"
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#attributes.fuseaction##adres#&form_submitted=1"
                    isAjax="1"
                    target="body_helpdesk"
                    >
--->
<br/>
<script language="JavaScript">
	document.getElementById('keyword').focus();
	function kontrol()
	{  
		if( !date_check(document.list_help.start_date, document.list_help.finish_date, "<cf_get_lang no='244.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz!'>") )
			return false;
		else
			return true;
	}
	function connectAjax(row_id,cus_help_id)
	{
		var detail_help = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_help_detail&satir_id="+row_id+"&id="+cus_help_id+"";
		AjaxPageLoad(detail_help,'show_help_detail'+row_id+'',0);
	}
</script>
