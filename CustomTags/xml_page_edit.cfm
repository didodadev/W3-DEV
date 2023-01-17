<!--- 
Amaç : Sayfaların çalışma şekil ve standartlarını müşterilerinin isteklerine göre özelleştirmek.
Created :20080623 M.ER
Modified:20081105 M.ER
Genel Kullanım : <cf_xml_page_edit> Sayfa için oluşturulmuş XML'den verileri sayfa içinde tanımlı değişkenler haline getiriyor.
Ayrıca xml_str diye bir string tanımlanarak,ajax kullanılan,yönlendirme yapılan yada listeleme sayfalarına taşımak üzere XML'deki tüm değişkenleri değerleri ile döndüren bir değişken
tanımlanıyor.
İstisna Durumlar : Örneğin bir sayfanın XML ayarlarına başka bir sayfada ihtiyaç duyarsanız,yada bir sayfa 4-5 ayrı yerde farklı fuseactionlar ile çağırlıyorsa;
<cf_xml_page_edit fuseact="prod.tracking"> kullanım bu şekilde oluyor.Yani bu kod hangi sayfada olursanız olun prod.tracking sayfası için girilmiş olan xml değişkenlerini sayfanızda tanımlı hale getirir.
 --->
<!--- Ayni sayfada farkli xml tanimlarinin kullanilmasi icin duzenlendi. BK 20141117 --->
<cfif not isdefined("caller.xml_str")>
	<cfset caller.xml_str="">
</cfif>
<cfif not isdefined("caller.xmlPageParams")>
	<cfset caller.xmlPageParams="">
</cfif>
<cfset url.event = not isdefined("url.event") ? "list" : "#url.event#">
<!--- myhome.popup_list_myaccounts  fuseaction'ına ait bazı kontroller bulunmaktadır. Bu kontrollerde atana değerler sayfaların genel XML tanımlaması için kullanılıyor. footer.cfm dosyasında XML'i olmayan sayfalar için sağ menüdeki XML alanı kapatılır. EY20160104 --->

<cfset f_sayac = 0>
<cfparam name="xml_setting_file_name" default="">
<cfparam name="attributes.fuseact" default="#caller.fuseaction#"><!--- İnclude olan sayfalarda fuseactionu değiştirmek gerekebiliyor. --->
<cfparam name="_modul_name_" default="">

<cfset attributes.fuseact = replace(attributes.fuseact,'autoexcelpopuppage_','','all')>

<cfset client["page_#listLast(caller.fuseaction,'.')#"] = attributes.fuseact>

<cfquery name="PAGE_XML_PROPERTY" datasource="#caller.dsn#">
	SELECT 
    	PROPERTY_VALUE,
		PROPERTY_NAME
    FROM
        FUSEACTION_PROPERTY
    WHERE
	<cfif isdefined("session.ep.userid")>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
	<cfelseif isdefined("session.ww.userid")>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
	<cfelseif isdefined("session.pp.userid")>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
	</cfif>
	(
		<cfloop list="#attributes.fuseact#" index="fuseactss">
			<cfset f_sayac = f_sayac+1>
			FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fuseactss#"> <cfif f_sayac lt ListLen(attributes.fuseact,',')> OR</cfif>
		</cfloop>
	)
</cfquery>
<cfscript>
	if(PAGE_XML_PROPERTY.recordcount){
		for(xml_ind_pro=1;xml_ind_pro lte PAGE_XML_PROPERTY.RECORDCOUNT;xml_ind_pro=xml_ind_pro+1){
			'caller.#PAGE_XML_PROPERTY.PROPERTY_NAME[xml_ind_pro]#' = PAGE_XML_PROPERTY.PROPERTY_VALUE[xml_ind_pro];
			caller.xml_str = "#caller.xml_str#&#PAGE_XML_PROPERTY.PROPERTY_NAME[xml_ind_pro]#=#PAGE_XML_PROPERTY.PROPERTY_VALUE[xml_ind_pro]#";
			if(not attributes.fuseact is 'myhome.popup_list_myaccounts')
				caller.xmlPageParams = "#caller.xmlPageParams#&#PAGE_XML_PROPERTY.PROPERTY_NAME[xml_ind_pro]#=#PAGE_XML_PROPERTY.PROPERTY_VALUE[xml_ind_pro]#";
			}
	}
	</cfscript>
    <!--- <cfif PAGE_XML_PROPERTY.recordcount><!--- Eğerki database'den bu sayfa ile ilgili kayıt gelmiyorsa ---> --->
		<cfif isdefined('attributes.fuseact') and ListLen(attributes.fuseact,'.')>
            <cfset _modul_name_ = ListGetAt(attributes.fuseact,1,'.')>
            <cfif _modul_name_ is 'prod'><cfset _modul_name_ = 'production_plan'></cfif>
            <cfif _modul_name_ is 'call'><cfset _modul_name_ = 'callcenter'></cfif>
			<cfif _modul_name_ is 'invent'><cfset _modul_name_ = 'inventory'></cfif>
			<cfif _modul_name_ is 'ehesap'><cfset _modul_name_ = 'hr/ehesap'></cfif>
			<cfif _modul_name_ is 'rule'><cfset _modul_name_ = 'rules'></cfif>
			<cfif _modul_name_ is 'add_options'><cfset _modul_name_ = 'add_options'></cfif>
        </cfif>

        <cfset folder_name = "#caller.index_folder##_modul_name_##caller.dir_seperator#xml#caller.dir_seperator#">
		<cfif StructKeyExists(application.objects, attributes.fuseact) and len(application.objects[attributes.fuseact].xml_path)>
			<cfset xml_setting_file_name = replace("#replace(caller.index_folder,'V16/','')##application.objects[attributes.fuseact].xml_path#",'\','/','all')>
        <cfelseif FileExists("#folder_name#faction_list.xml")>
		 	<cffile action="read" file="#folder_name#faction_list.xml" variable="xmldosyam" charset="UTF-8"><!--- Eğerki dosya bulunduysa faction_list.xml dosyası içinde verilen linkin işaret ettiği xml dosyası bulunacak ve veriler set edilecek. --->
			<cfscript>
                dosyam = XmlParse(xmldosyam);
                xml_dizi =dosyam.SETUP_SITE.XmlChildren;
                d_boyut = ArrayLen(xml_dizi);
				for(xind=1;xind lte d_boyut;xind=xind+1){
					if(ListLen(dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText,'.') gt 1){//eğerki faction list dosyasındaki linki gösteren yerin uzunluğu varsa burayı döndürüyoruz ve belirtilen dosyayı okumaya çalışıyoruz.
						xml_file_link = dosyam.SETUP_SITE.SETUPSITE[xind].LINK_FILE.XmlText;
						for(xfi=1;xfi lte ListLen(xml_file_link,',');xfi=xfi+1){//link_file'ları burda döndürüyoruz ve belirtilen sayfaya ait bir kayıt varmı ona erişmeye çalışıyoruz.
							if(ListGetAt(attributes.fuseact,1,',') is ListGetAt(xml_file_link,xfi,',')){//eğerki link_file'da dosyamız bulunur ise link_file'in içinde virgüllü olarak 1den fazla xml sayfa ismi olabileceğininden her zaman ilk ismi alıcaz.çünkü standart olarak XML klasörünün içine her zaman LINK_FLE'IN içine yazılan ilk dosya adını alıcaz.
								xml_setting_file_name = '#folder_name##ListLast(ListFirst(xml_file_link,','),'.')#.xml';//burda faction list içinde belirttiğmiz ilgili sayfa ile ilgili değerleri tutan sayfanın adını aldık.Eğer bu değişken tanımlı değil ise yada boş ise,sayfaya ait bir xml sayfası oluşturulmamıştır.
							}	
						}
					}
				}
			</cfscript>
		</cfif>
            <cfif not len(xml_setting_file_name) or not FileExists("#xml_setting_file_name#")><!---Faction List'de bir dosya ismi tanımlanmış mı veya Faction List'de bulduğumuz dosya adı ile kaydedilmiş bir XML dosyası varmı... --->
                <font color="red"><cfoutput>#caller.getLang('main',2241)#</cfoutput></font><!---Sayfa İçin XML dosyayı Belirtilmemiş,Sistem Yöneticiniz ile Temasa Geçiniz.--->
            <cfelse><!--- Eğer XML ayarlarını gösten dosya bulundu ise bu else bloğuna girer ve XML sayfasında belirtilen defaul değerler ile değişkenler set edilir. --->
				 <cffile action="read" file="#xml_setting_file_name#" variable="xmlsettingfile" charset="UTF-8">
                  <cfscript>
					xml_setting_file = XmlParse(xmlsettingfile);
					new_xml_array = xml_setting_file.OBJECT_PROPERTIES.XmlChildren;
					new_array_len = ArrayLen(new_xml_array);
					xml_property_event = XmlSearch(xml_setting_file,"/OBJECT_PROPERTIES/OBJECT_PROPERTY/PROPERTY_EVENT");
					 
					for(xsfi=1;xsfi lte new_array_len;xsfi=xsfi+1){
						if((ArrayLen(xml_property_event) gt 0 and ListFind('#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_EVENT.XmlText#','#url.event#') and not isdefined('caller.#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#')) or (ArrayLen(xml_property_event) eq 0) and not isdefined('caller.#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#')){
							/* writedump(ArrayLen(xml_property_event)); */
							'caller.#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#' = xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText;
							caller.xml_str="#caller.xml_str#&#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#=#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText#";
							if(not attributes.fuseact is 'myhome.popup_list_myaccounts')
								caller.xmlPageParams = "#caller.xmlPageParams#&#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#=#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText#";
						}
						/* else ){//case: sayfada 3 tane xml özelliği varmış önceden,sonradan 2 tane daha eklenmiş olmuş 5 ancak yukarıda kayıt varmı diye baktığımızda o sonradan eklenen 2 tanesini almıyordu dolayısı ile bizde böyle birşey yaptık..Ancak daha doğru bir yol bulmak lazım..
							'caller.#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#' = xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText;
							caller.xml_str="#caller.xml_str#&#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY.XmlText#=#xml_setting_file.OBJECT_PROPERTIES.OBJECT_PROPERTY[xsfi].PROPERTY_DEFAULT.XmlText#";
							
						} */
					}
				</cfscript>
		   </cfif>
		
	<!--- </cfif> --->
<!-- sil -->
<script type="text/javascript">
	<cfif not isDefined("caller.attributes.draggable")>
		if(document.querySelector(".rightBar")){
			if(document.querySelectorAll(".rightBar ul.tabNav li a")[2]){
				document.querySelectorAll(".rightBar ul.tabNav li a")[2].onclick = function(){
					document.querySelector("#wrk_xml_pop_").setAttribute("onclick","cfmodal('<cfoutput>#request.self#?fuseaction=objects.popup_xml_setup&event=#url.event#&fuseact=#listgetat(attributes.fuseact,1,',')#&main_fuseact=#caller.fuseaction#</cfoutput>','warning_modal')");
				}
		}else{
				document.querySelectorAll(".rightBar ul.tabNav li a")[1].onclick = function(){
					if(document.querySelector("#wrk_xml_pop_")) document.querySelector("#wrk_xml_pop_").setAttribute("onclick","cfmodal('<cfoutput>#request.self#?fuseaction=objects.popup_xml_setup&event=#url.event#&fuseact=#listgetat(attributes.fuseact,1,',')#&main_fuseact=#caller.fuseaction#</cfoutput>','warning_modal')");
				}
			}
		}
		if(document.querySelector("#wrk_xml_pop_")) document.querySelector("#wrk_xml_pop_").setAttribute("onclick","cfmodal('<cfoutput>#request.self#?fuseaction=objects.popup_xml_setup&event=#url.event#&fuseact=#listgetat(attributes.fuseact,1,',')#&main_fuseact=#caller.fuseaction#</cfoutput>','warning_modal')"); 
	</cfif>
</script>

<!-- sil -->
