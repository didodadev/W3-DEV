<!--- 
	Bu sayfa sistemde secilen musteriye gore sistemde benzer kayit kontrolu yapar.
	BK 060626	
 --->
<cfif not isDefined("GET_SUBSCRIPTION_AUTHORITY")>
	<!--- include edildiği sayfada çekilmiş olabilir bu nedenle kontrol ekledik Author: Tolga Sütlü, Ahmet Yolcu--->
   <cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
   <cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
</cfif>
<cfquery name="GET_SUBSCRIPTION_CONTRACT" datasource="#DSN3#">
	SELECT
		SC.SUBSCRIPTION_ID,
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.RECORD_DATE,	
		SST.SUBSCRIPTION_TYPE
	FROM
		SUBSCRIPTION_CONTRACT SC,
		SETUP_SUBSCRIPTION_TYPE AS SST
	WHERE
	  <cfif attributes.member_type eq "partner">
	  	SC.COMPANY_ID = #attributes.company_id#
	  <cfelse>
	  	SC.CONSUMER_ID = #attributes.consumer_id#
	  </cfif>
	  AND SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID 
	  <cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1>
		<!--- abone kategorisine göre yetkilendirme açık ise yetkisiz abone kategorileri değeri gelmez--->
            AND EXISTS 
                (
                    SELECT
                    SPC.SUBSCRIPTION_TYPE_ID
                    FROM        
                    #dsn#.EMPLOYEE_POSITIONS AS EP,
                    SUBSCRIPTION_GROUP_PERM SPC
                    WHERE
                    EP.POSITION_CODE = #session.ep.position_code# AND
                    (
                        SPC.POSITION_CODE = EP.POSITION_CODE OR
                        SPC.POSITION_CAT = EP.POSITION_CAT_ID
                    )
                        AND SC.SUBSCRIPTION_TYPE_ID = SPC.SUBSCRIPTION_TYPE_ID
                )	
	UNION 
		SELECT
			SC.SUBSCRIPTION_ID,
			SC.SUBSCRIPTION_NO,
			'-' SUBSCRIPTION_HEAD,
			SC.RECORD_DATE,	
			'-' SUBSCRIPTION_TYPE 
		FROM
			SUBSCRIPTION_CONTRACT SC,
			SETUP_SUBSCRIPTION_TYPE AS SST
		WHERE
		<cfif attributes.member_type eq "partner">
			SC.COMPANY_ID = #attributes.company_id#
		<cfelse>
			SC.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		AND SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID 
				AND NOT EXISTS 
					(
						SELECT
						SPC.SUBSCRIPTION_TYPE_ID
						FROM        
						#dsn#.EMPLOYEE_POSITIONS AS EP,
						SUBSCRIPTION_GROUP_PERM SPC
						WHERE
						EP.POSITION_CODE = #session.ep.position_code# AND
						(
							SPC.POSITION_CODE = EP.POSITION_CODE OR
							SPC.POSITION_CAT = EP.POSITION_CAT_ID
						)
							AND SC.SUBSCRIPTION_TYPE_ID = SPC.SUBSCRIPTION_TYPE_ID
					)
	</cfif>
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32636.Benzer Kriterlerdeki Sistem Kayıtları'></cfsavecontent>
<cf_medium_list_search title="#message#"></cf_medium_list_search>
<cf_medium_list>
<thead>
        <tr>
            <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
            <th width="60"><cf_get_lang dictionary_id='29502.Sistem No'></th>
            <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
            <th nowrap><cf_get_lang dictionary_id='58233.Tanım'></th>
            <th nowrap ><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th width="80"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
        </tr>
    </thead>
    <tbody>
        <form name="search_" method="post" action="">
			<cfif get_subscription_contract.recordcount>
				<cfoutput query="get_subscription_contract">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="://javascript" onClick="control(1,#subscription_id#);" class="tableyazi">#subscription_no#</a></td>
                        <td><cfif isdefined("attributes.company_name")>#attributes.company_name# - </cfif> #attributes.member_name#</td>
                        <td>#subscription_head#</td>
                        <td>#subscription_type#</td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                    </tr>
				</cfoutput>
                <tfoot>
                    <tr>
                        <td colspan="8" style="text-align:right;"><input type="submit" name="Devam" value="<cf_get_lang dictionary_id='33918.Varolan Kayıtları Gözardi Et'>" onClick="control(2,0);"></td>
                    </tr>
                </tfoot>
            <cfelse>
                <tr>
                	<td colspan="8"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
                </tr>
            </cfif>
        </form>
    </tbody>
</cf_medium_list>
<script type="text/javascript">
<cfif not get_subscription_contract.recordcount>
	alert("<cf_get_lang dictionary_id='33917.Benzer Kayıt Yok'>!");
	window.close();
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=</cfoutput>' + value;
		window.close();
	}
	
	if(id==2)
	{
		window.close();
	}
}
</script>
