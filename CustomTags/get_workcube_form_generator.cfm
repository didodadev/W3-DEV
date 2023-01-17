<!--- 
   20120703 SG
   Form generator ın yayginlastirilmasi icin hazırlanmistir.Degerlendirme formlari ve anketler hazirlanip iliskilendirilebilir.
   örnek kullanım:
   <cf_get_workcube_form_generator action_type='9' action_type_id='#url.class_id#'>
   action_type : 9 eğitim ,1 fırsat,2 içerik anket formu kayıt ekranındaki tip bilgisinden bakılabilir
   action_type_id : ilişkilendirildiği kaydın id si
   design='1'
   Örnek kullanım1:
   *<cf_get_workcube_form_generator action_type='6,7,10' action_type_id='#attributes.employee_id#' design='3'> //design='3' kullanıldığında o kayda ait doldurulmuş tüm değerlendirme formlar listelenir Çalışan detayındaki Değerlendirme formları bölümüne bakılabilir.
   *<cf_get_workcube_form_generator action_type='9' related_type='9' action_type_id='#attributes.class_id#' design='0'>  //eğitim tarafındaki formlara bakılabilir.
 --->
<cfparam name="attributes.action_type" default=""><!--anket formu tipi fırsat:1,içerik:2,kampanya:3,ürün:4,proje:5,deneme süresi:6,işe alım:7,performans:8,eğitim:9,işten çıkış:10 -->
<cfparam name="attributes.action_type_id" default=""> <!-- eklendigi kayıt id si-->
<cfparam name="attributes.width" default="">
<cfparam name="attributes.style" default="1">
<cfparam name="attributes.design" default="1">
<cfparam name="attributes.is_add_upd" default="0">
<cfparam name="attributes.margin_right" default="0">
<cfparam name="attributes.xml_is_survey_add" default="0">
<cfparam name="attributes.related_type" default="0">
<cfparam name="attributes.project_cat_id" default="">
<cfparam name="attributes.work_cat_id" default="">
<cfparam name="attributes.row_count" default="99">
<cfparam name="attributes.box_id" default="wrk_get_form">

<cfset dsn = caller.dsn>
<cfset url_address ="&related_type=#attributes.related_type#&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#&design=#attributes.design#&row_count=#attributes.row_count#">
<!--- Değerlendirme Formları/anketler --->
<cfif attributes.design eq 1><!--- form ekleme ve iliskilendirme ozelligi var--->
	<cf_box
		id="#attributes.box_id#"
		style="width:#attributes.width#px; margin-right:#attributes.margin_right#px"
		unload_body="1"
		info_title="#caller.getLang('main',497)#"
		title="#caller.getLang('main',1947)#"
		info_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_detail_survey&relation_cat=#attributes.action_type_id#&relation_type=#attributes.related_type#&action_type=#attributes.action_type#&xml_is_survey_add=#attributes.xml_is_survey_add#&project_cat_id=#attributes.project_cat_id#&work_cat_id=#attributes.work_cat_id#')"
		closable="0"
		box_page="#request.self#?fuseaction=objects.emptypopup_list_form_generator#url_address#">
	</cf_box>
		<!---add_href="#request.self#?fuseaction=objects.popup_form_add_detail_survey&action_type=#attributes.action_type#&action_type_id=#attributes.action_type_id#&relation_type=#attributes.related_type#&xml_is_survey_add=#attributes.xml_is_survey_add#" 
	--->
<cfelse><!---ekli olan formları doldurabilir ve guncelleyebilir  design 1 dışındakiler--->
	<cf_box
		id="#attributes.box_id#"
		style="width:#attributes.width#px; margin-right:#attributes.margin_right#px"
		unload_body="1"
		info_title="#caller.getLang('main',497)#"
		title="#caller.getLang('main',1947)#" 
		info_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_detail_survey&relation_cat=#attributes.action_type_id#&relation_type=#attributes.related_type#&action_type=#attributes.action_type#&project_cat_id=#attributes.project_cat_id#&work_cat_id=#attributes.work_cat_id#')"
		closable="0"
		box_page="#request.self#?fuseaction=objects.emptypopup_list_form_generator#url_address#">
	</cf_box>
</cfif>
