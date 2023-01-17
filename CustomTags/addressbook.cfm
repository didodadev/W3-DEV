<!--- 
	Adres Defteri Kayit- Guncelleme Calismasi FBS 20120904
	Type;
	0	Ozel Kayitlar
	1	Calisanlar / Employees
	2	Kurumsal Uye Calisanlari / Company_Partner
	3	Bireysel Uyeler / Consumer
	
	Design;
	1	Add
	2	Update
	3	Select
	4	Delete
--->
<cfparam name="attributes.data_source" default="#caller.dsn#">
<cfparam name="attributes.design" default="">
<cfparam name="attributes.active" default="1">
<cfparam name="attributes.type" default="0">
<cfparam name="attributes.type_id" default="0">
<cfparam name="attributes.id" default="0">
<cfparam name="attributes.name" default="">
<cfparam name="attributes.surname" default="">
<cfparam name="attributes.sector_id" default="0">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.telcode" default="">
<cfparam name="attributes.telno" default="">
<cfparam name="attributes.telno2" default="">
<cfparam name="attributes.faxno" default="">
<cfparam name="attributes.mobilcode" default="">
<cfparam name="attributes.mobilno" default="">
<cfparam name="attributes.web" default="">
<cfparam name="attributes.postcode" default="">
<cfparam name="attributes.address" default="">
<cfparam name="attributes.semt" default="">
<cfparam name="attributes.county_id" default="0">
<cfparam name="attributes.county_name" default="">
<cfparam name="attributes.city_id" default="0">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.country_id" default="0">
<cfparam name="attributes.country_name" default="">
<cfparam name="attributes.info" default="">
<cfparam name="attributes.special_emp" default="">
<cfparam name="attributes.kep_address" default="">
<cfparam name="attributes.query_name" default="get_AddressBook">

<cfif attributes.data_source eq caller.dsn><cfset process_db = ""><cfelse><cfset process_db = caller.dsn_alias&"."></cfif><!--- Transaction Icin dsn Tanimi --->

<cfset Cmp = createObject("component","CustomTags.cfc.get_addressbook") />
<cfset Cmp.data_source = attributes.data_source />
<cfset Cmp.process_db = process_db />

<cfif attributes.design eq 1>
	<cfset add_AddressBook = Cmp.add_AddressBook(
		active				: attributes.active,
		type				: attributes.type,
		type_id				: attributes.type_id,
		name				: attributes.name,
		surname				: attributes.surname,
		sector_id			: iif(Len(attributes.sector_id),attributes.sector_id,de(0)),
		company_name		: attributes.company_name,
		title				: attributes.title,
		email				: attributes.email,
		kep_address			: attributes.kep_address,
		telcode				: attributes.telcode,
		telno				: attributes.telno,
		telno2				: attributes.telno2,
		faxno				: attributes.faxno,
		mobilcode			: attributes.mobilcode,
		mobilno				: attributes.mobilno,
		web					: attributes.web,
		postcode			: attributes.postcode,
		address				: attributes.address,
		semt				: attributes.semt,
		county_id			: iif(Len(attributes.county_id),attributes.county_id,de(0)),
		county_name			: attributes.county_name,
		city_id				: iif(Len(attributes.city_id),attributes.city_id,de(0)),
		city_name			: attributes.city_name,
		country_id			: iif(Len(attributes.country_id),attributes.country_id,de(0)),
		country_name		: attributes.country_name,
		info				: attributes.info,
		special_emp			: iif(Len(attributes.special_emp),attributes.special_emp,de(0))
		) />
<cfelseif attributes.design eq 2>
	<cfset upd_AddressBook = Cmp.upd_AddressBook(
		active				: attributes.active,
		type				: attributes.type,
		type_id				: attributes.type_id,
		id					: attributes.id,
		name				: attributes.name,
		surname				: attributes.surname,
		sector_id			: iif(Len(attributes.sector_id),attributes.sector_id,de(0)),
		company_name		: attributes.company_name,
		title				: attributes.title,
		email				: attributes.email,
		kep_address			: attributes.kep_address,
		telcode				: attributes.telcode,
		telno				: attributes.telno,
		telno2				: attributes.telno2,
		faxno				: attributes.faxno,
		mobilcode			: attributes.mobilcode,
		mobilno				: attributes.mobilno,
		web					: attributes.web,
		postcode			: attributes.postcode,
		address				: attributes.address,
		semt				: attributes.semt,
		county_id			: iif(Len(attributes.county_id),attributes.county_id,de(0)),
		county_name			: attributes.county_name,
		city_id				: iif(Len(attributes.city_id),attributes.city_id,de(0)),
		city_name			: attributes.city_name,
		country_id			: iif(Len(attributes.country_id),attributes.country_id,de(0)),
		country_name		: attributes.country_name,
		info				: attributes.info,
		special_emp			: iif(Len(attributes.special_emp),attributes.special_emp,de(0))
		) />
<cfelseif attributes.design eq 3>
	<cfset get_AddressBook = Cmp.get_AddressBook(
		active				: attributes.active,
		type				: attributes.type,
		type_id				: attributes.type_id,
		id					: attributes.id,
		name				: attributes.name,
		surname				: attributes.surname,
		sector_id			: iif(Len(attributes.sector_id),attributes.sector_id,de(0)),
		company_name		: attributes.company_name,
		title				: attributes.title,
		email				: attributes.email,
		kep_address			: attributes.kep_address,
		telcode				: attributes.telcode,
		telno				: attributes.telno,
		telno2				: attributes.telno2,
		faxno				: attributes.faxno,
		mobilcode			: attributes.mobilcode,
		mobilno				: attributes.mobilno,
		web					: attributes.web,
		postcode			: attributes.postcode,
		address				: attributes.address,
		semt				: attributes.semt,
		county_id			: iif(Len(attributes.county_id),attributes.county_id,de(0)),
		county_name			: attributes.county_name,
		city_id				: iif(Len(attributes.city_id),attributes.city_id,de(0)),
		city_name			: attributes.city_name,
		country_id			: iif(Len(attributes.country_id),attributes.country_id,de(0)),
		country_name		: attributes.country_name,
		info				: attributes.info,
		special_emp			: iif(Len(attributes.special_emp),attributes.special_emp,de(0))
		) />
		<cfset caller.get_AddressBook = get_AddressBook>
<cfelseif attributes.design eq 4>
	<cfset del_AddressBook = Cmp.del_AddressBook(
		active				: attributes.active,
		type				: attributes.type,
		type_id				: attributes.type_id,
		id					: attributes.id,
		name				: attributes.name,
		surname				: attributes.surname,
		sector_id			: iif(Len(attributes.sector_id),attributes.sector_id,de(0)),
		company_name		: attributes.company_name,
		title				: attributes.title,
		email				: attributes.email,
		kep_address			: attributes.kep_address,
		telcode				: attributes.telcode,
		telno				: attributes.telno,
		telno2				: attributes.telno2,
		faxno				: attributes.faxno,
		mobilcode			: attributes.mobilcode,
		mobilno				: attributes.mobilno,
		web					: attributes.web,
		postcode			: attributes.postcode,
		address				: attributes.address,
		semt				: attributes.semt,
		county_id			: iif(Len(attributes.county_id),attributes.county_id,de(0)),
		county_name			: attributes.county_name,
		city_id				: iif(Len(attributes.city_id),attributes.city_id,de(0)),
		city_name			: attributes.city_name,
		country_id			: iif(Len(attributes.country_id),attributes.country_id,de(0)),
		country_name		: attributes.country_name,
		info				: attributes.info,
		special_emp			: iif(Len(attributes.special_emp),attributes.special_emp,de(0))
		) />
</cfif>
