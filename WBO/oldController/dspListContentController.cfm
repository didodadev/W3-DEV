<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cf_xml_page_edit fuseact="content.list_content">
<cf_get_lang_set module_name="content">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.content_property_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.user_friendly_url" default="">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.language_id" default="#session.ep.language#">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.record_member" default="">
<cfparam name="attributes.record_member_id" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.priority" default="">
<cfparam name="attributes.record_date" default="">
<cfif isdate(attributes.record_date)><cf_date tarih="attributes.record_date"></cfif>
<cfif fusebox.circuit eq 'training_management'><!--- eğitim yönetiminde yalnızca kategorisi Egitim olanların gelmesi icin eklendi--->
	<cfset attributes.is_training = 1>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<!---<cfinclude template="../query/get_content.cfm">--->
		<cfscript>
		get_content_list_action = CreateObject("component","content.cfc.get_content");
		get_content_list_action.dsn = dsn;
		get_content = get_content_list_action.get_content_list_fnc(
			record_member_id : '#iif(isdefined("record_member_id"),"record_member_id",DE(""))#' ,
			is_selected_lang : '#iif(isdefined("x_is_selected_language"),"x_is_selected_language",DE(""))#' ,
			record_member : '#iif(isdefined("attributes.record_member"),"attributes.record_member",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#', 
			language_id : '#iif(isdefined("attributes.language_id"),"attributes.language_id",DE(""))#',
			stage_id : '#iif(isdefined("attributes.stage_id"),"attributes.stage_id",DE(""))#',
			priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#',
			status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
			content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
			ana_sayfa : '#iif(isdefined("attributes.ana_sayfa"),"attributes.ana_sayfa",DE(""))#',
			ana_sayfayan : '#iif(isdefined("attributes.ana_sayfayan"),"attributes.ana_sayfayan",DE(""))#',
			bolum_basi : '#iif(isdefined("attributes.bolum_basi"),"attributes.bolum_basi",DE(""))#',
			bolum_yan : '#iif(isdefined("attributes.bolum_yan"),"attributes.bolum_yan",DE(""))#' ,
			ch_bas : '#iif(isdefined("attributes.ch_bas"),"attributes.ch_bas",DE(""))#',
			ch_yan : '#iif(isdefined("attributes.ch_yan"),"attributes.ch_yan",DE(""))#',
			none_tree : '#iif(isdefined("attributes.none_tree"),"attributes.none_tree",DE(""))#' ,
			is_viewed : '#iif(isdefined("attributes.is_viewed"),"attributes.is_viewed",DE(""))#',
			order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#' ,
			is_training: '#iif(isdefined("attributes.is_training"),"attributes.is_training",DE(""))#',
			is_fulltext_search : '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_content.recordcount = 0>
</cfif>
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>
<cfquery name="GET_CONTENT_PROCESS_STAGES" datasource="#DSN#">
	SELECT 
		PTR.PROCESS_ROW_ID AS STAGE_ID,
		PTR.STAGE STAGE_NAME 
	FROM 
		PROCESS_TYPE PT, 
		PROCESS_TYPE_ROWS PTR 
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.FACTION LIKE 'content.%' AND
		PT.PROCESS_ID = PTR.PROCESS_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_content.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.chpid") or isdefined("id")>
	<cfinclude template="#fusebox.rootpath#query/get_chapter_name.cfm">
</cfif>
<cfinclude template="../content/display/dsp_list_content_search.cfm">


<cfset url_str = "">
	<cfif isdefined("attributes.stage_id") and len(attributes.stage_id)>
		<cfset url_str = "#url_str#&stage_id=#attributes.stage_id#">
	</cfif>
	<cfif isdefined("attributes.form_submitted")>
	  	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.user_friendly_url)>
		<cfset url_str = "#url_str#&user_friendly_url=#attributes.user_friendly_url#">
	</cfif>
	<cfif len(attributes.order_type)>
		<cfset url_str = "#url_str#&order_type=#attributes.order_type#">
	</cfif>
	<cfif len(attributes.cat)>
		<cfset url_str = "#url_str#&cat=#attributes.cat#">
	</cfif>
	<cfif len(attributes.content_property_id)>
		<cfset url_str = "#url_str#&content_property_id=#attributes.content_property_id#">
	</cfif>
	<cfif len(attributes.status)>
		<cfset url_str = "#url_str#&status=#attributes.status#">
	</cfif>
	<cfif len(attributes.record_member)>
		<cfset url_str = "#url_str#&record_member=#attributes.record_member#">
		<cfset url_str = "#url_str#&record_member_id=#attributes.record_member_id#">
	</cfif>
	<cfif len(attributes.priority)>
		<cfset url_str = "#url_str#&priority=#attributes.priority#">
	</cfif>
	<cfif len(attributes.record_date)>
		<cfset url_str = "#url_str#&record_date=#dateformat(attributes.record_date,'dd/mm/yyyy')#">
	</cfif>

	<cfif isdefined("attributes.ana_sayfa")>
		<cfset url_str = "#url_str#&ana_sayfa=#attributes.ana_sayfa#">
	</cfif>
	<cfif isdefined("attributes.ana_sayfayan")>
		<cfset url_str = "#url_str#&ana_sayfayan=#attributes.ana_sayfayan#">
	</cfif>
	<cfif isdefined("attributes.bolum_basi")>
		<cfset url_str = "#url_str#&bolum_basi=#attributes.bolum_basi#">
	</cfif>
	<cfif isdefined("attributes.bolum_yan")>
		<cfset url_str = "#url_str#&bolum_yan=#attributes.bolum_yan#">
	</cfif>
	<cfif isdefined("attributes.ch_bas")>
		<cfset url_str = "#url_str#&ch_bas=#attributes.ch_bas#">
	</cfif>
	<cfif isdefined("attributes.ch_yan")>
		<cfset url_str = "#url_str#&ch_yan=#attributes.ch_yan#">
	</cfif>
	<cfif isdefined("attributes.none_tree")>
		<cfset url_str = "#url_str#&none_tree=#attributes.none_tree#">
	</cfif>
	<cfif isdefined("attributes.is_viewed")>
		<cfset url_str = "#url_str#&is_viewed=#attributes.is_viewed#">
	</cfif>
	<cfif isdefined("attributes.language_id")>
		<cfset url_str = "#url_str#&language_id=#attributes.language_id#">
	</cfif>
    
    <script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_content_cat()
	{
		var type = document.getElementById('language_id').value;
		var send_address = "<cfoutput>#request.self#?fuseaction=content.emptypopup_get_content_cat_ajax&cat=#attributes.cat#</cfoutput>&type=";
		send_address += type;
		AjaxPageLoad(send_address,'content_cat_place','1');
	}
	get_content_cat();
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">



<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cf_xml_page_edit fuseact="content.view_content"> 
<cf_get_lang_set module_name="content">
<cfset session.userFilesPath = "/documents/content/">
<cf_xml_page_edit fuseact="content.view_content">
<cfif isnumeric(attributes.cntid)>
	<cfscript>
		get_content_list_action = CreateObject("component","content.cfc.get_content");
		get_content_list_action.dsn = dsn;
		get_content = get_content_list_action.get_content_list_fnc(
			record_member_id : '#iif(isdefined("record_member_id"),"record_member_id",DE(""))#' ,
			record_member : '#iif(isdefined("attributes.record_member"),"attributes.record_member",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#', 
			language_id : '#iif(isdefined("attributes.language_id"),"attributes.language_id",DE(""))#',
			stage_id : '#iif(isdefined("attributes.stage_id"),"attributes.stage_id",DE(""))#',
			priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#',
			status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
			content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#',
			internet_view : '#iif(isdefined("attributes.internet_view"),"attributes.internet_view",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
			ana_sayfa : '#iif(isdefined("attributes.ana_sayfa"),"attributes.ana_sayfa",DE(""))#',
			ana_sayfayan : '#iif(isdefined("attributes.ana_sayfayan"),"attributes.ana_sayfayan",DE(""))#',
			bolum_basi : '#iif(isdefined("attributes.bolum_basi"),"attributes.bolum_basi",DE(""))#',
			bolum_yan : '#iif(isdefined("attributes.bolum_yan"),"attributes.bolum_yan",DE(""))#' ,
			ch_bas : '#iif(isdefined("attributes.ch_bas"),"attributes.ch_bas",DE(""))#',
			ch_yan : '#iif(isdefined("attributes.ch_yan"),"attributes.ch_yan",DE(""))#',
			none_tree : '#iif(isdefined("attributes.none_tree"),"attributes.none_tree",DE(""))#' ,
			is_viewed : '#iif(isdefined("attributes.is_viewed"),"attributes.is_viewed",DE(""))#',
			order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#',  
			spot : '#iif(isdefined("attributes.spot"),"attributes.spot",DE(""))#',
			is_rule_popup : '#iif(isdefined("attributes.is_rule_popup"),"attributes.is_rule_popup",DE(""))#',
			cntid : '#iif(isdefined("attributes.cntid"),"attributes.cntid",DE(""))#',
			is_fulltext_search : '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_content.recordcount = 0>
</cfif>
<cfif get_content.recordcount eq 0>
	<cfset hata  = 11>
	<cfsavecontent variable="hata_mesaj">Şirket Yetkiniz Uygun Değil Veya Böyle Bir Kayıt Bulunamadı !</cfsavecontent>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfinclude template="../content/query/get_company_cat.cfm">
    <cfinclude template="../content/query/get_customer_cat.cfm">
    <cfinclude template="../content/query/get_content_cat.cfm">
    <cfquery name="GET_LANGUAGE" datasource="#DSN#">
        SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_ID ASC
    </cfquery>
    <cfquery name="GET_POSITION_CATS" datasource="#DSN#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
    </cfquery>
    <cfquery name="GET_USER_GROUPS" datasource="#DSN#">
        SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
    </cfquery>
    <cfquery name="GET_CAT" datasource="#DSN#">
        SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 2
    </cfquery>
  	<cfscript>
        if (isdefined("Session.cid"))
        structdelete(Session,"CID");
    </cfscript>
    <cfset session.cid  = attributes.cntid>
    <cfif fuseaction contains "popup">
        <cfset is_popup=1>
    <cfelse>
        <cfset is_popup=0>

    </cfif>
    <script type="text/javascript">
        function val_kontrol()
        {
            window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#</cfoutput>.view_content&cntid=<cfoutput>#attributes.cntid#</cfoutput>&cont_catid="+document.fHtmlEditor.cont_catid.value;
        }
        function chk_poz(gelen)
        {
            if ( (gelen == 1) && (fHtmlEditor.ana_sayfayan.checked) ) fHtmlEditor.ana_sayfayan.checked = false;
            if ( (gelen == 2) && (fHtmlEditor.ana_sayfa.checked) ) fHtmlEditor.ana_sayfa.checked = false;
            if ( (gelen == 3) && (fHtmlEditor.bolum_yan.checked) ) fHtmlEditor.bolum_yan.checked = false;
            if ( (gelen == 4) && (fHtmlEditor.bolum_basi.checked) ) fHtmlEditor.bolum_basi.checked = false;
            if ( (gelen == 5) && (fHtmlEditor.ch_bas.checked) ) fHtmlEditor.ch_yan.checked = false;	
            if ( (gelen == 6) && (fHtmlEditor.ch_yan.checked) ) fHtmlEditor.ch_bas.checked = false;
        }
    </script>
    
    
    <script type="text/javascript">
		function showChapter(cont_catid)	
		{
			var cont_catid = document.getElementById('cont_catid').value;
			if (cont_catid != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=content.popup_ajax_list_chapter&cont_catid="+cont_catid;
				AjaxPageLoad(send_address,'chapter_place',1,'İlişkili Bölümler');
			}
		}

		<cfif fusebox.circuit eq 'training_management'>
			var is_training = 1;
		<cfelse>
			var is_training = 0;
		</cfif>	
				
		<cfif isdefined('x_is_selected_language') and (x_is_selected_language eq 1)> 
			<!--- Dil seçeneği değişince ilişkili dildeki kategorileri getirir --->
			$('#language_id').change(function() { get_lang_(); } ) 
			function get_lang_()
			{                                                                           
			   url_ = "/web_services/get_list_cat.cfc?method=get_cat_list_fnc&language_id="+document.getElementById("language_id").value+"&is_training="+is_training+"";
			   $.ajax({
				  cache: false,
				  url: url_,
				  dataType: "text",
				  success: function(read_data)
				  {
					$('#cont_catid option').remove();
					var new_opt = '<option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
					$('#cont_catid').append(new_opt);
					data_ = jQuery.parseJSON(read_data);
						$.each(data_.DATA,function(i){
							$.each(data_.COLUMNS,function(k){
								var CONTENTCAT = data_.DATA[i][0];
								var CONTENTCAT_ID = data_.DATA[i][1];
								
								if(k == 1){
									if(CONTENTCAT_ID == '<cfoutput>#get_content.CONTENTCAT_ID#</cfoutput>')	
										var new_opt = '<option value="'+CONTENTCAT_ID+'" selected>'+CONTENTCAT+'</option>';
									else
										var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';									
									$('#cont_catid').append(new_opt);
								}
							});
						});
						get_chapter();
				  }
			   });
			};

			get_lang_(); <!--- Sayfa ilk yüklendiğinde varsayılan dile göre kategorileri getirir --->					
			<!--- Kategori diline uygun ilişkili bölümleri getirir --->	
			
			
			$('#cont_catid').change(function() { get_chapter(); } );
			
			function get_chapter()
			{  
			   url_ = "/web_services/get_list_cat.cfc?method=get_chapter_list_fnc&cont_catid="+document.getElementById("cont_catid").value;
			   
			   $.ajax({
				  cache: false,
				  url: url_,
				  dataType: "text",
				  success: function(read_data)
				  {
					$('#chapter option').remove();
					var new_opt = '<option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
					$('#chapter').append(new_opt);
					data_ = jQuery.parseJSON(read_data);
						$.each(data_.DATA,function(i){
							$.each(data_.COLUMNS,function(k){
								var CHAPTER_ID = data_.DATA[i][0];
								var CHAPTER = data_.DATA[i][1];	
								if(k == 1){
									if(CHAPTER_ID == '<cfoutput>#get_content.chapter_id#</cfoutput>')	
										var new_opt = '<option value="'+CHAPTER_ID+'" selected>'+CHAPTER+'</option>';
									else
										var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';									
									$('#chapter').append(new_opt);
								}
							});
						});
				  }
				  
			   });
			}
		</cfif>  
				
		function kontrol()
		{
	
			tarih1_ = document.getElementById('view_date_start').value.substr(6,4) + document.getElementById('view_date_start').value.substr(3,2) + document.getElementById('view_date_start').value.substr(0,2);
			tarih2_ = document.getElementById('view_date_finish').value.substr(6,4) + document.getElementById('view_date_finish').value.substr(3,2) + document.getElementById('view_date_finish').value.substr(0,2);
			
			if(tarih1_ != '' & tarih2_ != '' && tarih1_ > tarih2_)
			{
				alert("<cf_get_lang_main no='168.Girdiğiniz Yayın Bitiş Tarihi Başlangıç Tarihinden Önce Gözüküyor! Lütfen Düzeltiniz!'>");
				return false;			
			} 
			
			x = document.fHtmlEditor.cont_catid.selectedIndex;
			if (document.fHtmlEditor.cont_catid[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='32.İçerik Kategorisi '>!");
				return false;
			}
			
			x = document.fHtmlEditor.chapter.selectedIndex;
			if (document.fHtmlEditor.chapter[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='83.İçerik Bölümü '>!");
				return false;
			}
			
			x = document.fHtmlEditor.process_stage.selectedIndex;
			if (document.fHtmlEditor.process_stage[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok ! '>");
				return false;
			}
			return process_cat_control();
		}
		
		//page loading for ajax TÖ
		<cfif isdefined("attributes.template_id")>
			<cfinclude template="../content/query/get_templates.cfm">	
			document.fHtmlEditor.CONT_BODY.value = '<cfoutput>#setup_template.template_content#</cfoutput>';	
		</cfif>
		function buyult_kucult(type)
		{	
			if(type==1)//1 ise küçültsün
				document.getElementById('cont').style.height="335px";
			if(type==2)//2 ise büyültsün
				document.getElementById('cont').style.height="600px";
		}
		
		function usergroup_hepsi()
		{
			if (document.fHtmlEditor.user_group_id_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = false;
			}
			return false;
		}
		
		function position_hepsi()
		{
			if (document.fHtmlEditor.position_cat_id_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = false;
			}
			return false;
		}
		
		function partner_hepsi()
		{
			if (document.fHtmlEditor.comp_cat_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = false;
			}
			return false;
		}
		
		function public_hepsi()
		{
			if (document.fHtmlEditor.cunc_cat_all.checked)
			{	
				document.fHtmlEditor.internet_view.checked = true;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = true;
			}
			else
			{	
				document.fHtmlEditor.internet_view.checked = false;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = false;
			}
			return false;
		}
		
		function career_hepsi()
		{
			if (document.fHtmlEditor.career_view_all.checked)
				document.fHtmlEditor.career_view.checked = true;
			else
				document.fHtmlEditor.career_view.checked = false;
		}
		function hepsi()
		{
			if(document.fHtmlEditor.all.checked)
			{
				document.fHtmlEditor.internet_view.checked = true;
				document.fHtmlEditor.user_group_id_all.checked = true;
				document.fHtmlEditor.position_cat_id_all.checked = true;
				document.fHtmlEditor.career_view_all.checked = true;
				document.fHtmlEditor.cunc_cat_all.checked = true;
				document.fHtmlEditor.comp_cat_all.checked = true;
				document.fHtmlEditor.employee_view.checked = true;
				document.fHtmlEditor.career_view.checked = true;
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = true;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = true;
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = true;
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = true;
			}
			else
			{
				document.fHtmlEditor.internet_view.checked = false;
				document.fHtmlEditor.user_group_id_all.checked = false;
				document.fHtmlEditor.position_cat_id_all.checked = false;
				document.fHtmlEditor.career_view_all.checked = false;
				document.fHtmlEditor.cunc_cat_all.checked = false;
				document.fHtmlEditor.comp_cat_all.checked = false;
				document.fHtmlEditor.employee_view.checked = false;
				document.fHtmlEditor.career_view.checked = false;
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = false;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = false;
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = false;
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = false;
			}
		}
    </script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

    
    
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
<cf_xml_page_edit fuseact="content.add_content">
<cf_get_lang_set module_name="content">
<cfset session.userFilesPath = "/documents/content/" />
<cfinclude template="../objects/display/imageprocess/imcontrol.cfm">
<cfinclude template="../content/query/get_company_cat.cfm">
<cfinclude template="../content/query/get_chapter_menu.cfm">
<cfset form_add = 1 > <!--- Sadece Aktif durumdaki kategorilerin gelmesi için eklendi --->
<cfinclude template="../content/query/get_customer_cat.cfm">
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_ID ASC
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 2
</cfquery>

<script type="text/javascript">
	function check_view()
	{
		if (fHtmlEditor.is_viewed.checked && (fHtmlEditor.view_date_finish.value == ""))
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='102.Ana Sayfa Duyuru Bitiş Tarihi !'>");
			return false;
		}
		return true;
	}
	
	function val_kontrol()
	{	
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.add_form_content&cont_catid="+document.getElementById('cont_catid').value;
	}
	
	function chk_poz(gelen)
	{
		if ( (gelen == 1) && (fHtmlEditor.ana_sayfayan.checked) ) fHtmlEditor.ana_sayfayan.checked = false;
		if ( (gelen == 2) && (fHtmlEditor.ana_sayfa.checked) ) fHtmlEditor.ana_sayfa.checked = false;
		if ( (gelen == 3) && (fHtmlEditor.bolum_yan.checked) ) fHtmlEditor.bolum_yan.checked = false;
		if ( (gelen == 4) && (fHtmlEditor.bolum_basi.checked) ) fHtmlEditor.bolum_basi.checked = false;
		if ( (gelen == 5) && (fHtmlEditor.ch_yan.checked) ) fHtmlEditor.ch_yan.checked = false;
		if ( (gelen == 6) && (fHtmlEditor.ch_bas.checked) ) fHtmlEditor.ch_bas.checked = false;
	}
</script>
<cfif isDefined("attributes.cntid")> <!--- İçerik Kopyalama için cid ile gelinmesi durumunda --->
	<cfif isnumeric(attributes.cntid)>
		<cfscript>
            get_content_list_action = CreateObject("component","content.cfc.get_content");
            get_content_list_action.dsn = dsn;
            get_content = get_content_list_action.get_content_list_fnc(
            cntid : '#iif(isdefined("attributes.cntid"),"attributes.cntid",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_content.recordcount = 0>
	</cfif>
</cfif>


<script type="text/javascript">
	function showChapter(cont_catid)	
	{
		var cont_catid = document.getElementById('cont_catid').value;
		if (cont_catid != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=content.popup_ajax_list_chapter&cont_catid="+cont_catid;
			AjaxPageLoad(send_address,'chapter_place',1,'İlişkili Bölümler');
		}
	}

	<cfif fusebox.circuit eq 'training_management'>
		var is_training = 1;
	<cfelse>
		var is_training = 0;
	</cfif>	
		
	<cfif isdefined('x_is_selected_language') and (x_is_selected_language eq 1)>
		<!--- Dil seçeneği değişince ilişkili dildeki kategorileri getirir --->
		$('#language_id').change(function() { get_lang_(); })
		function get_lang_()
		{    
		   	url_ = "/web_services/get_list_cat.cfc?method=get_cat_list_fnc&language_id="+document.getElementById("language_id").value+"&is_training="+is_training+"";
		   	$.ajax({
			  cache: false,
			  url: url_,
			  dataType: "text",
			  success: function(read_data)
			  {
				$('#cont_catid option').remove();
				var new_opt = '<option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
				$('#cont_catid').append(new_opt);
				data_ = jQuery.parseJSON(read_data);
					$.each(data_.DATA,function(i){
						$.each(data_.COLUMNS,function(k){
							var CONTENTCAT = data_.DATA[i][0];
							var CONTENTCAT_ID = data_.DATA[i][1];
							
							if(k == 1){
								<cfif isdefined("attributes.cntid")>
									if(CONTENTCAT_ID == '<cfoutput>#get_content.CONTENTCAT_ID#</cfoutput>')	
										var new_opt = '<option value="'+CONTENTCAT_ID+'" selected>'+CONTENTCAT+'</option>';
									else
										var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';									
								<cfelse>
									var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';
								</cfif>
								$('#cont_catid').append(new_opt);
							}
						});
					});
				}
			});
			get_chapter();
		};
		
		get_lang_(); <!--- Sayfa ilk yüklendiğinde varsayılan dile göre kategorileri getirir --->
	
		<!--- Kategori diline uygun ilişkili bölümleri getirir --->	
		$('#cont_catid').change(function() { get_chapter(); } );
		function get_chapter()
		{  		
		   	url_ = "/web_services/get_list_cat.cfc?method=get_chapter_list_fnc&cont_catid="+document.getElementById("cont_catid").value;
		   
		   $.ajax({
			  cache: false,
			  url: url_,
			  dataType: "text",
			  success: function(read_data)
			  {
				$('#chapter option').remove();
				var new_opt = '<option value=""><cf_get_lang_main no='322.Seçiniz'></option>';
				$('#chapter').append(new_opt);
				data_ = jQuery.parseJSON(read_data);
					$.each(data_.DATA,function(i){
						$.each(data_.COLUMNS,function(k){
							var CHAPTER_ID = data_.DATA[i][0];
							var CHAPTER = data_.DATA[i][1];
							if(k == 1){
								<cfif isdefined("attributes.cntid")>
									if(CHAPTER_ID == '<cfoutput>#get_content.chapter_id#</cfoutput>')
										var new_opt = '<option value="'+CHAPTER_ID+'" selected>'+CHAPTER+'</option>';
									else
										var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';
								<cfelse>
									var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';
								</cfif>
								$('#chapter').append(new_opt);
							}
						});
					});
			  	}
			  
		   });
		}
	</cfif> 
	
	function kontrol()
	{	
		x = document.getElementById('cont_catid').selectedIndex;
		if (document.getElementById('cont_catid')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='32.İçerik Kategorisi!'>");
			return false;
		}
		
		x = document.getElementById('chapter').selectedIndex;
		if (document.getElementById('chapter')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='83.İçerik Bölümü '>!");
			return false;
		}
		
		x = document.getElementById('process_stage').selectedIndex;
		if (document.getElementById('process_stage')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok ! '>");
			return false;
		}
		
		tarih1_ = document.getElementById('view_date_start').value.substr(6,4) + document.getElementById('view_date_start').value.substr(3,2) + document.getElementById('view_date_start').value.substr(0,2);
		tarih2_ = document.getElementById('view_date_finish').value.substr(6,4) + document.getElementById('view_date_finish').value.substr(3,2) + document.getElementById('view_date_finish').value.substr(0,2);
		
		if(tarih1_ != '' & tarih2_ != '' && tarih1_ > tarih2_)
		{
			alert("<cf_get_lang_main no='782.Girdiğiniz Yayın Bitiş Tarihi Başlangıç Tarihinden Önce Gözüküyor! Lütfen Düzeltiniz!'>");
			return false;			
		} 
		return check_view();
	}
	
	<cfif isdefined("attributes.template_id") AND len(attributes.template_id)>
		<cfinclude template="../content/query/get_templates.cfm">  	
		document.fHtmlEditor.CONT_BODY.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>	
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">	
</cfif>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'content.list_content';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'content/display/dsp_list_content.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'content.view_content';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'content/display/dsp_content_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'content/query/update_content.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'content.list_content&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'cntid=##attributes.cntid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cntid##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'content.del_content';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'content/query/del_content.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'content/query/del_content.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'content.list_content&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'cntid=##attributes.cntid##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.cntid##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'content.add_form_content';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'content/form/form_add_content.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'content/query/add_content.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'content.list_content&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] ='cntid=##attributes.cntid##';
	WOStruct['#attributes.fuseaction#']['add']['Identity'] = '##attributes.cntid##';
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Yorum Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=rule.popup_add_content_comment&content_id=#attributes.cntid#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = 'Uyarılar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=content.view_content&action_name=cntid&action_id=#attributes.cntid#','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'İçerik Takip';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=content.popup_view_content_follows&cntid=#attributes.cntid#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = 'Tarihçe';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=content.popup_list_content_history&content_id=#attributes.cntid#','project')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Literatür';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "#request.self#?fuseaction=rule.dsp_rule&cntid=#attributes.cntid#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = 'Yorumlar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=content.popup_view_content_comment&content_id=#attributes.cntid#','medium');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=content.list_content&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=content.list_content&cntid=#attributes.cntid#&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_editor&editor_name=fHtmlEditor.CONT_BODY&editor_header=fHtmlEditor.subject&module=content&is_pop=#is_popup#&title1=Başlık&title2=Detay','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
