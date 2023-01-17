<cfquery name="CHECK_BRANCH" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME ='#trim(attributes.compbranch__name)#' AND 
		COMPANY_ID = #attributes.company_id#
</cfquery>
<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='1735.şube adı'><cf_get_lang_main no='781.tekrarı'>");
		window.history.go(-1);
	</script>
<cfelse>
    <cfif isdefined('attributes.compbranch_status')><cfset attributes.compbranch_status = 1><cfelse><cfset attributes.compbranch_status = 0></cfif>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<cfset cmp.addBranch(
			company_id:attributes.company_id,
			manager_partner_id:attributes.manager,
			status:attributes.compbranch_status,
			brach_name:attributes.compbranch__name,
			detail:attributes.compbranch__nickname,
			email:attributes.compbranch_email,
			homepage:attributes.homepage,
			telcod:attributes.compbranch_telcode,
			tel1:attributes.compbranch_tel1,
			tel2:attributes.compbranch_tel2,
			tel3:attributes.compbranch_tel3,
			fax:attributes.compbranch_fax,
			mobilcat_id:attributes.mobilcat_id,
			mobiltel:attributes.mobiltel,
			postcod:attributes.compbranch_postcode,
			adres:attributes.compbranch_address,
			county_id:attributes.county_id,
			city_id:attributes.city_id,
			country:attributes.country,
			semt:attributes.semt,
			coordinate_1:attributes.coordinate_1,
			coordinate_2:attributes.coordinate_2
		) />
	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#attributes.company_id#" addtoken="no">
</cfif>
