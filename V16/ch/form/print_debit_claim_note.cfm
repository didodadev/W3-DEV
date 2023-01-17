<!---E.A 19072012 select ifadeleri düzenlendi.--->
<cf_get_lang_set module_name="ch"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<!-- sil -->
<cfquery name="GET_NOTE" datasource="#db_adres#">
	SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID,
        ACS.ACTION_ID,
        ACS.ACTION_TYPE
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	<cfif len(get_note.from_cmp_id)>
			<cfif len(GET_NOTE.multi_action_id)>
                ACS.ACTION_TYPE = 420
                AND ACS.ACTION_ID = #GET_NOTE.multi_action_id#
            <cfelse>
                ACS.ACTION_TYPE = 42
                AND ACS.ACTION_ID = #attributes.id#
            </cfif>
        <cfelse>
			<cfif len(GET_NOTE.multi_action_id)>
                ACS.ACTION_TYPE = 410
                AND ACS.ACTION_ID = #GET_NOTE.multi_action_id#
            <cfelse>
                ACS.ACTION_TYPE = 41
                AND ACS.ACTION_ID = #attributes.id#
            </cfif>
        </cfif>
</cfquery>
<cfsavecontent variable="img_">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_card.action_id#&process_cat=#get_card.action_type#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
    </cfif>
    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
</cfsavecontent>
<!-- sil -->
<cf_popup_box right_images="#img_#">
<cfset fatura_verilen = ''>
<cfset adres = ''>
<cfset telcode =''>
<cfset tel =''>
<cfset faxcode =''>
<cfset fax =''>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME1,
		ASSET_FILE_NAME1_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.COMPANY#">
	</cfif>
</cfquery>
<cfinclude template="../query/get_money_rate.cfm">
<br/>
<!-- sil -->
<table width="650" border="1" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td colspan="3" height="100" valign="top"> <br/>
            <table width="95%"  border="0">
                <tr>
                    <td align="center" colspan="2">
                        <cfif get_note.ACTION_TYPE_ID eq 41><cf_get_lang_main no='437.Borc Dekontu'></cfif>
                        <cfif get_note.ACTION_TYPE_ID eq 42><cf_get_lang_main no='436.Alacak Dekontu'></cfif>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cfoutput query="check">
                            <table width="100%">
                            	<tr>
                                    <td width="50%">
                                        <table width="98%">
                                            <tr>
                                                <td colspan="2" class="formbold"> #company_name#</td>
                                            </tr>
                                            <tr>
                                                <td width="20" valign="top"><cf_get_lang_main no="1311.ADRES"></td>
                                            <td>: #address#</td>
                                            </tr>
                                            <tr>
                                                <td valign="top"><cf_get_lang_main no="87.Telefon"></td>
                                            <td>: #tel_code# - #tel#  #tel2#  #tel3# #tel4#</td>
                                            </tr>
                                            <tr>
                                                <td valign="top"><cf_get_lang_main no="76.FAX"></td>
                                                <td>: #fax#</td>
                                            </tr>
                                        </table>
                            		</td>
                                    <td style="text-align:right;">
                                        <cf_get_server_file output_file="settings/#CHECK.asset_file_name1#" output_server="#CHECK.asset_file_name1_server_id#" output_type="5">
                                    </td>
                                </tr>
                            </table>
                        </cfoutput>
                    </td>
                </tr>
                <tr>
                    <td width="40">&nbsp; <cf_get_lang_main no='534.Fiş No'> </td>
                    <td>: <cfoutput>#GET_NOTE.ACTION_ID#</cfoutput></td>
                </tr>
                <tr>
                    <td>&nbsp;<cf_get_lang_main no='330.Tarih'> </td>
                    <td>: <cfoutput>#dateformat(GET_NOTE.ACTION_DATE,dateformat_style)#</cfoutput></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr align="center" height="30" class="formbold">
        <td><cf_get_lang_main no='107.CARİ HESAP'></td>
        <td><cf_get_lang_main no='217.AÇIKLAMA'></td>
        <td><cf_get_lang_main no='261.TUTAR'></td>
    </tr>
    <tr height="30" class="formbold">
        <td>&nbsp;<cfoutput>
			<cfif len(get_note.from_cmp_id)>
            #get_par_info(get_note.from_cmp_id,1,1,0)#
            <cfelseif len(get_note.to_cmp_id)>
            #get_par_info(get_note.to_cmp_id,1,1,0)#
            <cfelseif len(get_note.from_consumer_id)>
            #get_cons_info(get_note.from_consumer_id,0,0)#
            <cfelseif len(get_note.to_consumer_id)>
            #get_cons_info(get_note.to_consumer_id,0,0)#
            </cfif></cfoutput>
        </td>
        <td><cfoutput>#get_note.ACTION_DETAIL#</cfoutput>&nbsp;</td>
        <td> &nbsp;
			<cfif len(get_note.ACTION_VALUE)>
            <cfoutput>#tlformat(get_note.ACTION_VALUE)# #get_note.ACTION_CURRENCY_ID#</cfoutput>
            <cfelseif len(get_note.OTHER_CASH_ACT_VALUE)>
            <cfoutput>#tlformat(get_note.OTHER_CASH_ACT_VALUE)#</cfoutput>
            <cfif len(get_note.other_money)>
            <cfoutput>#get_note.other_money#</cfoutput>
            </cfif>
            </cfif>
        </td>
    </tr>
    <tr>
        <td colspan="3" valign="top">
            <br/>
            <table width="95%"  border="0">
                <tr>
                    <td height="50" valign="top"><cf_get_lang_main no='1545.İMZA'> : </td>
                </tr>
                <tr>
                    <td><cf_get_lang no='92.Yazıyla'> :
						<cfif len(get_note.ACTION_VALUE)>
							<cfoutput>
                                <cfset myNumber = get_note.ACTION_VALUE>
                                <cf_n2txt number="myNumber" para_birimi="#get_note.ACTION_CURRENCY_ID#">#myNumber#</cfoutput>
                                <cfelseif len(get_note.OTHER_CASH_ACT_VALUE)>
                            <cfoutput>
                            <cfset myNumber = get_note.OTHER_CASH_ACT_VALUE>
                            <cf_n2txt number="myNumber">#myNumber#</cfoutput>
                            <cfif len(get_note.other_money)>
                            	<cfoutput>#get_note.other_money#</cfoutput>
                            </cfif>
                        </cfif>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- sil -->
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
