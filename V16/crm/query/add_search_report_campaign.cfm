<cfset attributes.target_company_id = ListDeleteDuplicates(attributes.target_company_id,',')>
<cfquery name="ADD_TARGET_PEOPLE" datasource="#dsn3#">
	SELECT PAR_ID FROM CAMPAIGN_TARGET_PEOPLE WHERE CAMP_ID = #attributes.campaign_id# AND PAR_ID IS NOT NULL
</cfquery>
<cfset target_market_list = valuelist(add_target_people.par_id,',')>

<cfloop from="1" to="#listlen(attributes.target_company_id)#" index="i">
	<cfif listfind(target_market_list,listgetat(attributes.target_company_id,i,','),',') eq 0>
		<cfquery name="ADD_TARGET_MARKET" datasource="#dsn3#">
			INSERT
			INTO
				CAMPAIGN_TARGET_PEOPLE
				(
					CAMP_ID,
					PAR_ID,
					RECORD_EMP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.campaign_id#,
					#listgetat(attributes.target_company_id,i,',')#,
					#session.ep.userid#,
					#now()#
				)
		</cfquery>
	</cfif>
</cfloop>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='52449.Detaylı Müşteri Arama Sonuçları Seçtiğiniz Kampanyanın Liste Yöneticisine Başarı İle Aktarıldı'> !");
		<cfif not len(attributes.modal_id)>opener<cfelse>window</cfif>.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_campaign_target&camp_id=#attributes.campaign_id#&target_company_id=#target_company_id#</cfoutput>';
	<cfif  not len(attributes.modal_id)>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
