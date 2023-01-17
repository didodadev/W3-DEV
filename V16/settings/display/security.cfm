<cfquery name="get_pos_id" datasource="#dsn#">
	SELECT
		POSITION_ID,
		EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS 'EMPLOYEE_NAME'
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<!--- <table class="dph">
    <tr>
        <td class="dpht"><cf_get_lang_main no='739.Güvenlik'></td>
    </tr>
</table>
 --->
<cf_catalystHeader>
<cfoutput>
<div class="params_content">
	<div class="col col-3 col-md-4 col-sm-6 col-xs-12 params_item">
		<ul class="params_list">
			<div class="params_list_title color-ER"><cf_get_lang dictionary_id='42191.Yetkiler'></div> 
			<span></span>
			<ul>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_add_user_group">- <cf_get_lang dictionary_id='42144.Yetki Grupları'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_add_block_group">- <cf_get_lang dictionary_id ='44491.Blok Grupları'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.denied_pages">- <cf_get_lang dictionary_id='63605.Rol Bazlı Sayfa Kısıtları'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.list_denied_pages_lock">- <cf_get_lang dictionary_id='63606.Kilitli Kayıtlar'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.partner_user_denied">- <cf_get_lang dictionary_id='42194.Partner Sayfa Kısıtları'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_add_password_inf">- <cf_get_lang dictionary_id='42823.Şifreleme Sistemi'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_add_login_inf">- <cf_get_lang dictionary_id='42053.Giriş Kontrol Sistemi'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.list_digital_asset_group">- <cf_get_lang dictionary_id='45129.Dijital varlık grupları'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.list_emp_authority_definition">- <cf_get_lang dictionary_id='43055.Çalışan Yetki Tanımları'></a></li>
				<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions_poweruser&employee_id=#session.ep.userid#&position_id=#get_pos_id.position_id#&employee_name=#get_pos_id.employee_name#&from_sec=1','wwide1');">- <cf_get_lang dictionary_id='43089.Toplu Yetkilendirme'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.waap">- <cf_get_lang dictionary_id='52713.Admin'><cf_get_lang dictionary_id='46754.Yetkilendirme'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.emp_denied_pages">- <cf_get_lang dictionary_id='63661.Kişi Bazlı Sayfa Kısıtları'></a></li>
			</ul>	 
		</ul>
	</div>
	<div class="col col-3 col-md-4 col-sm-6 col-xs-12 params_item">
		<ul class="params_list">
			<div class="params_list_title color-PM"><cf_get_lang dictionary_id='43413.Sistem Login'></div> 
			<span></span>
			<ul>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_stop_logins&type=0">- <cf_get_lang dictionary_id='44840.Çalışan Giriş Kısıtlama'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_stop_logins&type=1">- <cf_get_lang dictionary_id='44841.Kurumsal Üye Giriş Kısıtlama'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_stop_logins&type=2">- <cf_get_lang dictionary_id='44842.Bireysel Üye Giriş Kısıtlama'></a></li>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.security_rule">- <cf_get_lang dictionary_id="271.Güvenlik Şablonu"></a></li>	
				<li><a target="_blank" href="#request.self#?fuseaction=report.failed_logins_report">- <cf_get_lang dictionary_id='63744.Hatalı Girişler'></a></li>			
			</ul>	
		</ul>
	</div>
	<div class="col col-3 col-md-4 col-sm-6 col-xs-12 params_item">
		<ul class="params_list">
			<div class="params_list_title color-IN"><cf_get_lang dictionary_id='43423.Kredi Kartı Şifreleme Anahtarı'></div>
			<span></span> 
			<ul>
				<li><a target="_blank" href="#request.self#?fuseaction=settings.form_add_ccno_key">- <cf_get_lang dictionary_id='61266.Şifreleme Anahtarları'></a></li>	
			</ul>
		</ul>
	</div>
</div>
</cfoutput>
<script>
	$(function() {
		var $msrContent = $('.params_content');
		$msrContent.masonry({itemSelector: '.params_item',percentPosition: true});
	});
</script> 
<!--- <script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script> --->
