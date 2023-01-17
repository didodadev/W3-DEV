<cfset attributes.style=1>
<cfif is_dsp_photo_right eq 1>
<cf_box id="photo" collapsed="#iif(attributes.style,1,0)#" closable="0"  title="#lang_array.item[105]#"> 
  <table align="center">
	<tr>
		<td style="text-align:center">
			<cfif not len(get_consumer.picture)>
           		<cfif get_consumer.sex eq 1>
                    <img src="/images/male.jpg" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
                <cfelse>
                    <img src="/images/female.jpg" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
                </cfif>             
			<cfelse>
				<cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="120" image_height="150">
			</cfif>
		</td>
	</tr>
  </table>
</cf_box>
</cfif>


<cfif len(get_consumer.genius_id)>
    <cfquery name="get_cus_cards" datasource="#dsn_gen#">
        SELECT * FROM CARD WHERE FK_CUSTOMER = #get_consumer.genius_id#
    </cfquery>
     <cfquery name="get_total_bonus" datasource="#dsn_gen#">
        SELECT * FROM CUSTOMER WHERE ID = #get_consumer.genius_id#
    </cfquery>
    <cf_box id="puan_info" collapsed="#iif(attributes.style,1,0)#" closable="0"  title="Puan Bilgileri"> 
        <cfset toplam_kazanilan = 0>
        <cfset toplam_kullanilan = 0>
        <cfset toplam_kalan = 0>
        <cfset toplam_bonus = 0>
        <div id="puan_details_div" style="display:none;">
		<cfoutput query="get_cus_cards">
        	<cfquery name="get_bonus_kazanilan" datasource="#dsn_gen#">
            	SELECT
                	SUM(AMOUNT) AS TOTAL
                FROM
                	CUSTOMER_BONUS
                WHERE
                	FK_CARD = #ID# AND
                    FK_REASON_TYPE = 1
            </cfquery>
            <cfquery name="get_bonus_kullanilan" datasource="#dsn_gen#">
            	SELECT
                	SUM(AMOUNT) AS TOTAL
                FROM
                	CUSTOMER_BONUS
                WHERE
                	FK_CARD = #ID# AND
                    FK_REASON_TYPE = 2
            </cfquery>
            <cfif get_bonus_kazanilan.recordcount and len(get_bonus_kazanilan.TOTAL)>
            	<cfset kazanilan = get_bonus_kazanilan.TOTAL>
            <cfelse>
            	<cfset kazanilan = 0>
            </cfif>
            <cfif get_bonus_kullanilan.recordcount and len(get_bonus_kullanilan.TOTAL)>
            	<cfset kullanilan = get_bonus_kullanilan.TOTAL>
            <cfelse>
            	<cfset kullanilan = 0>
            </cfif>
            <cfset kalan = kazanilan - kullanilan>
        	<table>
                <tr>
                	<td colspan="2" class="txtboldblue"><a href="#request.self#?index.cfm&fuseaction=retail.list_consumer_bonus&consumer_id=#attributes.cid#&card_no=#code#">#CODE#</a></td>
                </tr>
                <tr>
                    <td class="formbold" width="75">Kazanılan</td>
                    <td width="45" style="text-align:right;">#tlformat(kazanilan)#</td>
                </tr>
                <tr>
                    <td class="formbold">Kullanılan</td>
                    <td style="text-align:right;">#tlformat(kullanilan)#</td>
                </tr>
                <tr>
                    <td class="formbold">Kalan</td>
                    <td style="text-align:right;">#tlformat(kalan)#</td>
                </tr>
            </table>
            <cfset toplam_bonus = toplam_bonus + bonus>
            <cfset toplam_kazanilan = toplam_kazanilan + kazanilan>
            <cfset toplam_kullanilan = toplam_kullanilan + kullanilan>
			<cfset toplam_kalan = toplam_kalan + kalan>
        </cfoutput>
        <hr />
        </div>
        <cfoutput>
        <table>
            <tr>
                <td class="formbold" width="75">Kazanılan</td>
                <td width="45" style="text-align:right;"><a href="javascript://" onclick="$('##puan_details_div').toggle();" class="tableyazi">#tlformat(toplam_kazanilan)#</a></td>
            </tr>
            <tr>
                <td class="formbold">Kullanılan</td>
                <td style="text-align:right;">#tlformat(toplam_kullanilan)#</td>
            </tr>
            <tr>
                <td class="formbold">Kalan</td>
                <td style="text-align:right;">#tlformat(toplam_kalan)#</td>
            </tr>
            <tr>
                <td class="formbold">Total Bonus</td>
                <td style="text-align:right;">#tlformat(get_total_bonus.BONUS)#</td>
            </tr>
            <tr>
                <td colspan="2"><a href="#request.self#?index.cfm&fuseaction=retail.list_consumer_bonus&consumer_id=#attributes.cid#" class="tableyazi">Tüm Hareketler</a></td>
            </tr>
        </table>
        </cfoutput>
    </cf_box>
</cfif>

<!--- Sube Iliskisi --->
<cfif is_dsp_related_branch_right eq 1>
	<cfif isdefined("attributes.cid")>
        <cf_get_workcube_member_branch action_id_2="#attributes.cid#" style="1">
   <cfelseif isdefined("attributes.cpid")>
        <cf_get_workcube_member_branch action_id="#attributes.cpid#" style="1">
   </cfif>
</cfif>

<!--- Notlar --->
<cf_get_workcube_note action_section='CONSUMER_ID' action_id='#attributes.cid#'>

<!--- Belgeler --->
<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='4' action_section='CONSUMER_ID' action_id='#attributes.cid#'>

<!--- Kart No Bilgileri --->
<cfif is_dsp_card_no_info eq 1>
	 <cfif isdefined('attributes.cid')>
    	<cf_get_workcube_list_customer_cards action_type="CONSUMER_ID" action_id="#attributes.cid#">
	<cfelseif isdefined('attributes.pid')>
    	<cf_get_workcube_list_customer_cards action_type="PARTNER_ID" action_id="#attributes.pid#">
	</cfif>
</cfif>