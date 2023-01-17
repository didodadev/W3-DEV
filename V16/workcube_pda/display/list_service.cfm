<cfparam name="attributes.is_submit" default="0">
<cfif isdefined("session.service_reply")>
	<cfscript>structdelete(session,"service_reply");</cfscript>
</cfif>
<cfif isdefined("session.service_task")>
	<cfscript>structdelete(session,"service_task");</cfscript>
</cfif>
<cfinclude template="../../objects2/service/query/get_service.cfm">
<cfset get_service.recordcount = 0>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%pda.list_services%">
</cfquery>
<cfinclude template="../../objects2/service/query/get_service_status.cfm">
<cfinclude template="../../objects2/query/get_service_appcat.cfm">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.subscription_id" default=''>
<cfparam name="attributes.subscription_no" default=''>
<cfparam name="attributes.process_stage" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_service.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Servis Başvuruları</td>
        <td align="center" style="width:70%;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.form_add_service" class="txtsubmenu"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a></td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
            <table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%" class="color-border">
                <tr class="color-header" style="height:22px;">
                    <td class="form-title" style="width:15%"><cf_get_lang_main no='75.No'></td>
                    <td class="form-title"><cf_get_lang_main no='68.Konu'></td>
                    <td class="form-title" style="width:20%"><cf_get_lang_main no='330.Tarih'></td>
                    <td class="form-title" style="width:15%"><cf_get_lang_main no='70.Aşama'></td>
                </td>
                <cfif get_service.recordcount>
                    <cfset service_id_list=''>
                    <cfset ship_service_id_list =''>
                    <cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset service_id_list = Listappend(service_id_list,service_id)>
                    </cfoutput>
                    <cfif len(service_id_list)>
                        <cfquery name="GET_SHIP" datasource="#DSN2#">
                            SELECT SR.SERVICE_ID FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID = SR.SHIP_ID AND SR.SERVICE_ID IN (#service_id_list#) AND S.SHIP_TYPE = 141 ORDER BY SR.SERVICE_ID
                        </cfquery>
                        <cfset ship_service_id_list = listsort(listdeleteduplicates(valuelist(get_ship.service_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                            <td><a href="#request.self#?fuseaction=pda.detail_service&service_id=#service_id#&is_form_submitted=1" class="tableyazi">#service_no#</a></td>
                             <td>#service_head#</td>
                            <td>
                                #dateformat(date_add('h',session.pda.time_zone,get_service.apply_date),'dd/mm/yyyy')# 
                                #timeformat(date_add('h',session.pda.time_zone,get_service.apply_date),'HH:MM')#
                            </td>
                            <td>#stage#</td>
                        </tr>
                    </cfoutput>	
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="11"><cfif attributes.is_submit><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </table>
        </td>
    </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" align="center" style="width:100%; height:35px;">
		<tr>
		  	<td>
				<cfset adres="#attributes.fuseaction#">
					<cfset adres = adres&"&keyword="&attributes.keyword>
				<cfif isDefined('attributes.category') and len(attributes.category)>
					<cfset adres = adres&"&category="&attributes.category>
				</cfif>
				<cfif isDefined('attributes.status') and len(attributes.status)>
					<cfset adres = adres&"&status="&attributes.status>
				</cfif>
				<cfif isDefined('attributes.sub_status') and len(attributes.sub_status)>
					<cfset adres = adres&"&sub_status="&attributes.sub_status>
				</cfif>
				<cfif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>
					<cfset adres = adres&"&subscription_id="&attributes.subscription_id>
				</cfif>
				<cfif isDefined('attributes.subscription_no') and len(attributes.subscription_no)>
					<cfset adres = adres&"&subscription_no="&attributes.subscription_no>
				</cfif>
				<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
					<cfset adres = adres&"&company_id="&attributes.company_id>
				</cfif>
				<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
					<cfset adres = adres&"&process_stage="&attributes.process_stage>
				</cfif>
				<cfif isDefined('attributes.is_submit') and len(attributes.is_submit)>
					<cfset adres = adres&"&is_submit="&attributes.is_submit>
				</cfif>
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#">
		  	<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_service.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
  	</table>
</cfif>
