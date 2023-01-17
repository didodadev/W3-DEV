<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cfinclude template="../content/query/get_main_menus.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.menu_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.productcat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.banner_area_id" default="">
<cfparam name="attributes.yayin_type" default="">
<cfparam name="attributes.durum_type" default="">
<cfparam name="attributes.language_id" default="#session.ep.language#">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../content/query/get_banners.cfm">
<cfelse>
	<cfset get_banners.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_banners.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfset adres = "content.list_banners">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
	<cfset adres = '#adres#&product_id=#attributes.product_id#'>
</cfif>
<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset adres = '#adres#&product_name=#attributes.product_name#'>
</cfif>
<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
	<cfset adres = '#adres#&brand_id=#attributes.brand_id#'>
</cfif>
<cfif isdefined("attributes.brand_name") and len(attributes.brand_name)>
	<cfset adres = '#adres#&brand_name=#attributes.brand_name#'>
</cfif>
<cfif isdefined("attributes.productcat_id") and len(attributes.productcat_id)>
	<cfset adres = '#adres#&productcat_id=#attributes.productcat_id#'>
</cfif>
<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
	<cfset adres = '#adres#&product_cat=#attributes.product_cat#'>
</cfif>
<cfif isdefined("attributes.banner_area_id") and len(attributes.banner_area_id)>
	<cfset adres = '#adres#&banner_area_id=#attributes.banner_area_id#'>
</cfif>
<cfif isdefined("attributes.menu_id") and len(attributes.menu_id)>
	<cfset adres = '#adres#&menu_id=#attributes.menu_id#'>
    
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
</cfif>



<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cfquery name="GET_BANNERS" datasource="#DSN#">
	SELECT 
		BANNER_ID, 
		IS_ACTIVE, 
		IS_FLASH, 
		IS_HOMEPAGE, 
		IS_LOGIN_PAGE, 
		IS_LOGIN_PAGE_EMPLOYEE, 
		BANNER_NAME, 
		START_DATE, 
		FINISH_DATE, 
		BANNER_FILE, 
		BANNER_SERVER_ID, 
		URL, 
		URL_PATH, 
		BANNER_WIDTH, 
		BANNER_HEIGHT, 
		DETAIL, 
		BANNER_AREA_ID, 
		MENU_ID, 
		BANNER_PROPERTY_ID, 
		BANNER_TARGET, 
		CONTENTCAT_ID, 
		BANNER_PRODUCTCAT_ID, 
		CHAPTER_ID, 
		BANNER_BRAND_ID, 
		CONTENT_ID, 
		BANNER_PRODUCT_ID, 
		BANNER_CAMPAIGN_ID, 
		BACK_COLOR ,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
        LANGUAGE,
        SEQUENCE
	FROM 
		CONTENT_BANNERS 
	WHERE 
		BANNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.banner_id#">
</cfquery>

<cfquery name="GET_BANNER_USERS" datasource="#DSN#">
	SELECT 
		BANNER_ID, 
		COMPANYCAT_ID, 
		CONSCAT_ID, 
		IS_INTERNET, 
		IS_CAREER 
	FROM 
		CONTENT_BANNERS_USERS 
	WHERE 
		BANNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.banner_id#">
</cfquery>
<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_banner_users.companycat_id,',')),'numeric','ASC',',')>
<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_banner_users.conscat_id,',')),'numeric','ASC',',')>
<cfquery name="GET_INTERNET" dbtype="query">
	SELECT IS_INTERNET FROM GET_BANNER_USERS WHERE IS_INTERNET = 1
</cfquery>
<cfquery name="GET_CAREER" dbtype="query">
	SELECT IS_CAREER FROM GET_BANNER_USERS WHERE IS_CAREER = 1
</cfquery>
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
        SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>
<cfinclude template="../content/query/get_main_menus.cfm">
<cfinclude template="../content/query/get_content_property.cfm">
<cfinclude template="../content/query/get_company_cat.cfm">
<cfinclude template="../content/query/get_customer_cat.cfm">
<cfsavecontent variable="txt">
    <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang no='67.İmaj Upload Ediliyor'>!</b></font></div>
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.list_banners&event=add"><img src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Banner Ekle'>" title="<cf_get_lang_main no='170.Banner Ekle'>" border="0"></a>
</cfsavecontent>


<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function control()
	{	
		tarih1_ = document.getElementById('start_date').value.substr(6,4) + document.getElementById('start_date').value.substr(3,2) + document.getElementById('start_date').value.substr(0,2);
		tarih2_ = document.getElementById('finish_date').value.substr(6,4) + document.getElementById('finish_date').value.substr(3,2) + document.getElementById('finish_date').value.substr(0,2);
		
		if(tarih1_ != '' & tarih2_ != '' && tarih1_ > tarih2_)
		{
			alert("Girdiğiniz Yayın Bitiş Tarihi Başlangıç Tarihinden Önce Gözüküyor! Lütfen Düzeltiniz!");
			return false;			
		} 
		
		var obj =  document.getElementById('banner').value;		
		if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'swf') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png'))){
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='126.resim dosyası(gif,jpg veya png)!!'>");        
			return false;
		}
		if ( (obj != "") && document.getElementById('flash').checked && (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() != 'swf')){
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='93.Flash Dosyası(swf) !'>");        
			return false;		
		}
		
		document.getElementById('upload_status').style.display = '';
		return true;
	}
</script>




<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
<cfinclude template="../content/query/get_content_property.cfm">
<cfinclude template="../content/query/get_main_menus.cfm">
<cfinclude template="../content/query/get_company_cat.cfm">
<cfinclude template="../content/query/get_customer_cat.cfm">
<cfsavecontent variable="txt"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang no='67.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
        SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>


<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function control()
	{	
	
		tarih1_ = document.getElementById('start_date').value.substr(6,4) + document.getElementById('start_date').value.substr(3,2) + document.getElementById('start_date').value.substr(0,2);
		tarih2_ = document.getElementById('finish_date').value.substr(6,4) + document.getElementById('finish_date').value.substr(3,2) + document.getElementById('finish_date').value.substr(0,2);
		
		if (document.getElementById('banner_name').value == '')
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='219.Ad'>");        
			return false;	
		}
		if(tarih1_ != '' & tarih2_ != '' && tarih1_ > tarih2_)
		{
			alert("<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>");
			return false;			
		} 

		var obj =  document.getElementById('banner').value;		
		if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'swf') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='126.resim dosyası(gif,jpg veya png)!!'>!");        
			return false;
		}
		if (document.add_banner.flash.checked && (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() != 'swf'))
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='93.Flash Dosyası(swf) !'>");        
			return false;		
		}
		
		document.getElementById('upload_status').style.display = '';
		return true;
	}
</script>
</cfif>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'content.list_banners';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'content/display/list_banners.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'content.upd_banner';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'content/form/upd_banner.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'content/query/upd_banner.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'content.list_banners&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'banner_id=##attributes.banner_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.banner_id##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'content.emptypopup_del_banner';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'content/query/del_banner.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'content/query/del_banner.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'content.list_banners&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'banner_id=##attributes.banner_id##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.banner_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'content.add_banner';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'content/form/add_banner.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'content/query/add_banner.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'content.list_banners&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] ='banner_id=##attributes.banner_id##';
	WOStruct['#attributes.fuseaction#']['add']['Identity'] = '##attributes.banner_id##';
	

</cfscript>
