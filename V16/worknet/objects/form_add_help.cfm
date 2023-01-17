<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="getCompany" datasource="#dsn#">
	SELECT 
		FULLNAME,
		MANAGER_PARTNER_ID
	FROM 
		COMPANY 
	WHERE 
		COMPANY_ID = '#attributes.cpid#'
</cfquery>

<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cfoutput>#getCompany.fullname#</cfoutput></h1></div>
	</div>
	<div class="iletisim">
		<div class="iletisim_1">
			<cfset attributes.is_security = 0>
			<cfset attributes.is_category = 0>
			<cfset attributes.cat_id = 2>
			<cfset attributes.company_id = attributes.cpid>
			<cfset attributes.pid = getCompany.MANAGER_PARTNER_ID>
			<cfinclude template="../../objects2/display/add_service_help.cfm">
		</div>
		<div class="iletisim_2">
			<div class="iletisim_21">
				<strong><cfoutput>#getCompany.fullname#</cfoutput></strong><br /><br />
				Üyelik kaydınız sistemimizde mevcuttur. <br />
				Kaydınızı aktif etmek istiyorsanız yandaki<br /> formu doldurmanızı rica ederiz<br />
			</div>
		</div>
	</div>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

